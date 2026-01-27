/// SOLICAP - Topic List Screen
/// Tüm konuların ve mikro derslerin listelendiği ekran

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_dna_service.dart';
import '../services/gemini_service.dart';
import '../models/user_dna_model.dart';
import 'micro_lesson_screen.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  final UserDNAService _dnaService = UserDNAService();
  final GeminiService _geminiService = GeminiService();
  bool _isLoading = true;
  bool _isAnalyzing = false; // 🧠 Ortak problem analizi yapılırken
  UserDNA? _dna;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadDNA();
  }

  Future<void> _loadDNA() async {
    final dna = await _dnaService.getDNA();
    if (mounted) {
      setState(() {
        _dna = dna;
        _isLoading = false;
      });
    }
  }

  List<SubTopicPerformance> get _filteredTopics {
    if (_dna == null) return [];
    
    // 🎯 MİNİMUM 3 SORU EŞİĞİ: Yetersiz veri ile mikro ders önerme
    // Aynı konuda en az 3 soru çözülmeden analiz yapılamaz
    final topics = _dna!.subTopicPerformance.values
        .where((t) => t.totalQuestions >= 3)
        .toList();
    
    // Başarı oranına göre sırala (Düşük başarı → En üstte)
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
                  child: _filteredTopics.isEmpty
                      ? _buildEmptyState()
                      : _buildTopicList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
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
    );
  }

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: topic.subTopic,
              strugglePoints: [specificFocus],
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('⚠️ Ortak analiz hatası: $e');
      // Hata olsa bile mikro derse yönlendir
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MicroLessonScreen(
              topic: topic.subTopic,
              strugglePoints: [topic.subTopic],
            ),
          ),
        );
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
