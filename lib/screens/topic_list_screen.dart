/// SOLICAP - Topic List Screen
/// Tüm konuların ve mikro derslerin listelendiği ekran

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_dna_service.dart';
import '../services/gemini_service.dart';
import '../services/micro_lesson_cache_service.dart';
import '../models/user_dna_model.dart';
import 'micro_lesson_screen.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

/// 🎯 Keyword gruplama için sabitler
const Map<String, List<String>> _keywordGroups = {
  'Türev ve İntegral': ['türev', 'integral', 'diferansiyel', 'leibniz'],
  'Limit ve Süreklilik': ['limit', 'süreklilik', 'yakınsama'],
  'Fonksiyonlar': ['fonksiyon', 'polinom', 'rasyonel', 'trigonometrik'],
  'Denklemler': ['denklem', 'eşitsizlik', 'mutlak değer'],
  'Geometri': ['geometri', 'üçgen', 'çember', 'dörtgen', 'alan', 'hacim'],
  'Olasılık ve İstatistik': ['olasılık', 'istatistik', 'permütasyon', 'kombinasyon'],
  'Sayılar': ['sayı', 'asal', 'bölen', 'obeb', 'okek', 'faktöriyel'],
  'Diziler ve Seriler': ['dizi', 'seri', 'aritmetik', 'geometrik'],
  // Fizik
  'Mekanik': ['kuvvet', 'hareket', 'ivme', 'hız', 'newton', 'momentum'],
  'Elektrik ve Manyetizma': ['elektrik', 'manyetik', 'akım', 'direnç', 'potansiyel'],
  'Dalgalar ve Optik': ['dalga', 'ışık', 'optik', 'yansıma', 'kırılma'],
  // Kimya
  'Atom ve Periyodik': ['atom', 'periyodik', 'element', 'izotop'],
  'Kimyasal Tepkimeler': ['tepkime', 'reaksiyon', 'denge', 'asit', 'baz'],
  'Organik Kimya': ['organik', 'hidrokarbon', 'alkan', 'alken'],
  // Türkçe/Edebiyat
  'Dil Bilgisi': ['fiil', 'isim', 'sıfat', 'zarf', 'cümle', 'yazım'],
  'Paragraf': ['paragraf', 'anlam', 'yorum', 'çıkarım'],
};

/// 🧠 Gruplanmış konu modeli
class TopicGroup {
  final String groupName;
  final String parentTopic;
  final List<SubTopicPerformance> subTopics;
  final int totalQuestions;
  final double avgSuccessRate;

  TopicGroup({
    required this.groupName,
    required this.parentTopic,
    required this.subTopics,
    required this.totalQuestions,
    required this.avgSuccessRate,
  });
}

class _TopicListScreenState extends State<TopicListScreen> {
  final UserDNAService _dnaService = UserDNAService();
  final GeminiService _geminiService = GeminiService();
  final MicroLessonCacheService _cacheService = MicroLessonCacheService();
  
  bool _isLoading = true;
  bool _isAnalyzing = false; // 🧠 Ortak problem analizi yapılırken
  UserDNA? _dna;
  String _searchQuery = '';
  Set<String> _savedTopics = {}; // Yeşil tik için
  DateFilter _selectedFilter = DateFilter.all;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dna = await _dnaService.getDNA();
    final savedTopics = await _cacheService.getSavedTopics();
    if (mounted) {
      setState(() {
        _dna = dna;
        _savedTopics = savedTopics;
        _isLoading = false;
      });
    }
  }

  /// 🎯 Keyword bazlı gruplama ile konuları getir
  List<TopicGroup> get _groupedTopics {
    if (_dna == null) return [];
    
    final allSubTopics = _dna!.subTopicPerformance.values.toList();
    if (allSubTopics.isEmpty) return [];
    
    final Map<String, List<SubTopicPerformance>> groups = {};
    final Set<String> usedSubTopics = {};
    
    // Her keyword grubu için eşleşen subTopic'leri bul
    for (final entry in _keywordGroups.entries) {
      final groupName = entry.key;
      final keywords = entry.value;
      
      final matchingTopics = allSubTopics.where((t) {
        final lowerSubTopic = t.subTopic.toLowerCase();
        return keywords.any((kw) => lowerSubTopic.contains(kw)) && !usedSubTopics.contains(t.subTopic);
      }).toList();
      
      if (matchingTopics.isNotEmpty) {
        groups[groupName] = matchingTopics;
        usedSubTopics.addAll(matchingTopics.map((t) => t.subTopic));
      }
    }
    
    // Gruplandırılmamış konuları kendi gruplarına ekle (3+ soru olanlar)
    for (final topic in allSubTopics) {
      if (!usedSubTopics.contains(topic.subTopic) && topic.totalQuestions >= 3) {
        groups[topic.subTopic] = [topic];
      }
    }
    
    // TopicGroup listesi oluştur (toplam 3+ soru olanlar)
    final result = <TopicGroup>[];
    for (final entry in groups.entries) {
      final totalQ = entry.value.fold<int>(0, (sum, t) => sum + t.totalQuestions);
      if (totalQ >= 3) {
        final avgRate = entry.value.fold<double>(0, (sum, t) => sum + t.successRate) / entry.value.length;
        result.add(TopicGroup(
          groupName: entry.key,
          parentTopic: entry.value.first.parentTopic,
          subTopics: entry.value,
          totalQuestions: totalQ,
          avgSuccessRate: avgRate,
        ));
      }
    }
    
    // Başarı oranına göre sırala (Düşük başarı → En üstte)
    result.sort((a, b) => a.avgSuccessRate.compareTo(b.avgSuccessRate));
    
    if (_searchQuery.isEmpty) return result;
    
    return result.where((g) => 
      g.groupName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      g.parentTopic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      g.subTopics.any((t) => t.subTopic.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }
  
  // Geriye uyumluluk için eski getter (kullanılmıyor artık)
  List<SubTopicPerformance> get _filteredTopics {
    if (_dna == null) return [];
    final topics = _dna!.subTopicPerformance.values
        .where((t) => t.totalQuestions >= 3)
        .toList();
    topics.sort((a, b) => a.successRate.compareTo(b.successRate));
    if (_searchQuery.isEmpty) return topics;
    return topics.where((t) => 
      t.subTopic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      t.parentTopic.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Konu Anlatımları',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : Column(
              children: [
                _buildSearchField(),
                Expanded(
                  child: _groupedTopics.isEmpty
                      ? _buildEmptyState()
                      : _buildGroupedTopicList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Arama alanı
          TextField(
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Konu veya ders ara...',
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
              filled: true,
              fillColor: AppTheme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          // Tarih filtresi
          _buildDateFilter(),
        ],
      ),
    );
  }

  Widget _buildDateFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DateFilter.values.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter.label),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedFilter = filter);
              },
              backgroundColor: AppTheme.cardColor,
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGroupedTopicList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _groupedTopics.length,
      itemBuilder: (context, index) {
        final group = _groupedTopics[index];
        return _buildGroupCard(group);
      },
    );
  }

  Widget _buildGroupCard(TopicGroup group) {
    Color levelColor;
    String levelText;
    
    if (group.avgSuccessRate >= 0.8) {
      levelColor = AppTheme.successColor;
      levelText = 'Ustalık';
    } else if (group.avgSuccessRate >= 0.5) {
      levelColor = AppTheme.warningColor;
      levelText = 'Gelişiyor';
    } else {
      levelColor = AppTheme.errorColor;
      levelText = 'Zayıf';
    }

    // Yeşil tik: Bu topic için ders oluşturulmuş mu?
    final hasSavedLesson = _savedTopics.contains(group.groupName);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasSavedLesson ? AppTheme.successColor.withOpacity(0.5) : AppTheme.dividerColor,
          width: hasSavedLesson ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: levelColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.library_books, color: levelColor),
            ),
            // Yeşil tik badge
            if (hasSavedLesson)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                group.groupName,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (hasSavedLesson)
              _buildChip('✅ Hazır', AppTheme.successColor)
            else if (group.avgSuccessRate < 0.5)
              _buildChip('🎯 Sana Özel', AppTheme.accentColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${group.parentTopic} • ${group.totalQuestions} soru',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            if (group.subTopics.length > 1) ...[
              const SizedBox(height: 4),
              Text(
                group.subTopics.map((t) => t.subTopic).take(3).join(', ') + 
                  (group.subTopics.length > 3 ? '...' : ''),
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(levelText, levelColor),
                const SizedBox(width: 8),
                Text(
                  '%${(group.avgSuccessRate * 100).toInt()} başarı',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _isAnalyzing 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor))
            : const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textMuted),
        onTap: () => _navigateToGroupMicroLesson(group),
      ),
    );
  }

  /// 🧠 Gruplanmış konularda ortak problem analizi yaparak mikro derse yönlendir
  Future<void> _navigateToGroupMicroLesson(TopicGroup group) async {
    if (_isAnalyzing) return;
    
    setState(() => _isAnalyzing = true);
    
    try {
      // Gruptaki tüm subTopic'lerden soruları topla
      final allSubTopicNames = group.subTopics.map((t) => t.subTopic).toSet();
      
      final failedQuestions = _dna?.failedQuestions
          .where((q) => allSubTopicNames.contains(q.subTopic))
          .take(5)
          .map((q) {
            final text = q.questionText.length > 100 
                ? '${q.questionText.substring(0, 100)}...' 
                : q.questionText;
            return '$text [Hata: ${q.failureReason}]';
          })
          .toList() ?? [];
      
      String specificFocus = group.groupName;
      
      // Yeterli soru varsa ortak problem analizi yap
      if (failedQuestions.length >= 3) {
        final result = await _geminiService.analyzeCommonStruggle(
          topic: group.parentTopic,
          subTopic: group.groupName,
          questionSummaries: failedQuestions,
        );
        
        if (result != null && result.microLessonFocus.isNotEmpty) {
          specificFocus = result.microLessonFocus;
          debugPrint('🧠 Ortak problem tespit edildi: $specificFocus');
        }
      } else if (group.totalQuestions >= 3 && failedQuestions.isEmpty) {
        // Toplam 3+ soru var ama yanlış soru yok → Genel konu tekrarı
        debugPrint('📚 Genel konu anlatımı: ${group.groupName} (${group.totalQuestions} soru çözüldü)');
        specificFocus = 'Genel tekrar ve eksik kapatma';
      }
      
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: group.groupName,
              strugglePoints: [specificFocus],
            ),
          ),
        );
        // Dönünce yeşil tikleri güncelle
        _refreshSavedTopics();
      }
    } catch (e) {
      debugPrint('⚠️ Ortak analiz hatası: $e');
      // Hata olsa bile mikro derse yönlendir
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: group.groupName,
              strugglePoints: [group.groupName],
            ),
          ),
        );
        _refreshSavedTopics();
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  /// Yeşil tikleri güncelle
  Future<void> _refreshSavedTopics() async {
    final savedTopics = await _cacheService.getSavedTopics();
    if (mounted) {
      setState(() => _savedTopics = savedTopics);
    }
  }

  // Eski metot (geriye uyumluluk için tutuldu)
  Widget _buildTopicList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredTopics.length,
      itemBuilder: (context, index) {
        final topic = _filteredTopics[index];
        return _buildTopicCard(topic);
      },
    );
  }

  Widget _buildTopicCard(SubTopicPerformance topic) {
    Color levelColor;
    String levelText;
    
    if (topic.successRate >= 0.8) {
      levelColor = AppTheme.successColor;
      levelText = 'Ustalık';
    } else if (topic.successRate >= 0.5) {
      levelColor = AppTheme.warningColor;
      levelText = 'Gelişiyor';
    } else {
      levelColor = AppTheme.errorColor;
      levelText = 'Zayıf';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: levelColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.library_books, color: levelColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                topic.subTopic,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (topic.successRate < 0.5)
              _buildChip('🎯 Sana Özel', AppTheme.accentColor),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              topic.parentTopic,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChip(levelText, levelColor),
                const SizedBox(width: 8),
                Text(
                  '%${(topic.successRate * 100).toInt()} başarı',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: _isAnalyzing 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor))
            : const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textMuted),
        onTap: () => _navigateToMicroLesson(topic),
      ),
    );
  }

  /// 🧠 Ortak problem analizi yaparak mikro derse yönlendir
  Future<void> _navigateToMicroLesson(SubTopicPerformance topic) async {
    if (_isAnalyzing) return;
    
    setState(() => _isAnalyzing = true);
    
    try {
      // DNA'dan bu konudaki son soruların özetlerini al
      final failedQuestions = _dna?.failedQuestions
          .where((q) => q.subTopic == topic.subTopic)
          .take(5)
          .map((q) {
            final text = q.questionText.length > 100 
                ? '${q.questionText.substring(0, 100)}...' 
                : q.questionText;
            return '$text [Hata: ${q.failureReason}]';
          })
          .toList() ?? [];
      
      String specificFocus = topic.subTopic;
      
      // Yeterli yanlış soru varsa ortak problem analizi yap (3 soru gerekli)
      // Eğer yanlış soru yoksa ama toplam 3+ soru varsa, genel konu anlatımı yap
      if (failedQuestions.length >= 3) {
        final result = await _geminiService.analyzeCommonStruggle(
          topic: topic.parentTopic,
          subTopic: topic.subTopic,
          questionSummaries: failedQuestions,
        );
        
        if (result != null && result.microLessonFocus.isNotEmpty) {
          specificFocus = result.microLessonFocus;
          debugPrint('🧠 Ortak problem tespit edildi: $specificFocus');
        }
      } else if (topic.totalQuestions >= 3 && failedQuestions.isEmpty) {
        // Toplam 3+ soru var ama yanlış soru yok → Genel konu tekrarı
        debugPrint('📚 Genel konu anlatımı: ${topic.subTopic} (${topic.totalQuestions} soru çözüldü)');
        specificFocus = 'Genel tekrar ve eksik kapatma';
      }
      
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: topic.subTopic,
              strugglePoints: [specificFocus],
            ),
          ),
        );
        _refreshSavedTopics();
      }
    } catch (e) {
      debugPrint('⚠️ Ortak analiz hatası: $e');
      // Hata olsa bile mikro derse yönlendir
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: topic.subTopic,
              strugglePoints: [topic.subTopic],
            ),
          ),
        );
        _refreshSavedTopics();
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school_outlined, size: 64, color: AppTheme.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'Henüz mikro ders önerisi yok',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aynı konuda en az 3 soru çözünce\nburası dolmaya başlayacak.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
