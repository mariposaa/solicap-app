/// SOLICAP - PDF Exam Creator Screen
/// Deneme sınavı oluşturma ve önizleme ekranı

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../services/pdf_exam_service.dart';
import '../services/user_dna_service.dart';
import '../models/user_dna_model.dart';

class PdfExamScreen extends StatefulWidget {
  const PdfExamScreen({super.key});

  @override
  State<PdfExamScreen> createState() => _PdfExamScreenState();
}

class _PdfExamScreenState extends State<PdfExamScreen> {
  final PdfExamService _pdfService = PdfExamService();
  final UserDNAService _dnaService = UserDNAService();
  
  String _selectedSubject = 'Matematik';
  String _selectedTopic = 'Türev';
  int _questionCount = 10;
  String _difficulty = 'medium';
  
  bool _isGenerating = false;
  bool _isPersonalizedMode = false;
  double _progress = 0;
  List<WeakTopic> _weakTopics = [];
  UserDNA? _userDNA;
  bool _isLoadingDNA = true;

  @override
  void initState() {
    super.initState();
    _loadUserDNA();
  }

  Future<void> _loadUserDNA() async {
    try {
      final dna = await _dnaService.getDNA();
      if (mounted) {
        setState(() {
          _userDNA = dna;
          _isLoadingDNA = false;
          if (dna != null) {
            _weakTopics = dna.weakTopics;
            // Eğer zayıf konu varsa otomatik kişiselleştirilmiş modu aktif et
            if (_weakTopics.isNotEmpty) {
              _isPersonalizedMode = true;
              _selectedSubject = _weakTopics.first.topic;
              _selectedTopic = _weakTopics.first.subTopic;
            } else if (dna.subTopicPerformance.isNotEmpty) {
              // Zayıf konu yok ama veri varsa ilk mevcut konuyu seç
              final firstPerf = dna.subTopicPerformance.values.first;
              _selectedSubject = firstPerf.parentTopic;
              _selectedTopic = firstPerf.subTopic;
            }
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingDNA = false);
      debugPrint('DNA load error: $e');
    }
  }

  // Statik listeler kaldırıldı, artık DNA'dan çekilecek
  List<String> get _displaySubjects {
    if (_userDNA == null) return [];
    
    // Sadece kullanıcının veri sahibi olduğu dersleri getir
    return _userDNA!.subTopicPerformance.values
        .map((p) => p.parentTopic)
        .toSet()
        .toList();
  }

  List<String> get _displayTopics {
    if (_userDNA == null) return [];
    
    // Seçili derse ait alt konuları getir
    return _userDNA!.subTopicPerformance.values
        .where((p) => p.parentTopic == _selectedSubject)
        .map((p) => p.subTopic)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDNA) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      );
    }

    final totalSolved = _userDNA?.totalQuestionsSolved ?? 0;
    final isLocked = totalSolved < 10;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.picture_as_pdf, color: AppTheme.errorColor),
            SizedBox(width: 8),
            Text(
              'PDF Deneme Oluştur',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLocked ? _buildLockedState(totalSolved) : _buildMainContent(),
    );
  }

  Widget _buildLockedState(int totalSolved) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_person,
                size: 64,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deneme Modu Henüz Kilitli',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Kişiselleştirilmiş deneme sınavı oluşturabilmemiz için en az 10 soru çözmelisin. Şu an $totalSolved soru çözdün.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            LinearProgressIndicator(
              value: totalSolved / 10,
              backgroundColor: AppTheme.surfaceColor,
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              minHeight: 12,
            ),
            const SizedBox(height: 12),
            Text(
              'İlerleme: %${(totalSolved * 10).toInt()}',
              style: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Geri Dön ve Soru Çöz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kartı
          _buildHeaderCard(),
          
          const SizedBox(height: 24),
          
          // Ders seçimi
          _buildSectionTitle('📚 Ders Seç'),
          const SizedBox(height: 12),
          _buildSubjectSelector(),
          
          const SizedBox(height: 20),
          
          // Konu seçimi
          _buildSectionTitle('📖 Konu Seç'),
          const SizedBox(height: 12),
          _buildTopicSelector(),
          
          const SizedBox(height: 20),
          
          // Soru sayısı
          _buildSectionTitle('🔢 Soru Sayısı'),
          const SizedBox(height: 12),
          _buildQuestionCountSelector(),
          
          const SizedBox(height: 20),
          
          // Zorluk
          _buildSectionTitle('⚡ Zorluk'),
          const SizedBox(height: 12),
          _buildDifficultySelector(),
          
          const SizedBox(height: 32),
          
          // Oluştur butonu
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.errorColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (_isPersonalizedMode ? AppTheme.accentColor : AppTheme.errorColor).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _isPersonalizedMode ? Icons.auto_awesome : Icons.quiz,
              color: _isPersonalizedMode ? AppTheme.accentColor : AppTheme.errorColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPersonalizedMode ? '🎯 Sana Özel Deneme' : 'AI Destekli Sınav',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isPersonalizedMode 
                    ? 'Zayıf olduğun konuları güçlendir' 
                    : 'Senin için özel sorular üretilecek',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (_weakTopics.isNotEmpty)
            Switch(
              value: _isPersonalizedMode,
              onChanged: (val) {
                setState(() {
                  _isPersonalizedMode = val;
                  if (val) {
                    _selectedSubject = _weakTopics.first.topic;
                    _selectedTopic = _weakTopics.first.subTopic;
                  }
                });
              },
              activeColor: AppTheme.accentColor,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubjectSelector() {
    final subjects = _displaySubjects;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: subjects.map((subject) {
        final isSelected = subject == _selectedSubject;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSubject = subject;
              _selectedTopic = _displayTopics.isNotEmpty ? _displayTopics.first : '';
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.surfaceColor,
              ),
            ),
            child: Text(
              subject,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopicSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTopic.isNotEmpty && _displayTopics.contains(_selectedTopic) 
              ? _selectedTopic 
              : (_displayTopics.isNotEmpty ? _displayTopics.first : null),
          isExpanded: true,
          dropdownColor: AppTheme.cardColor,
          style: const TextStyle(color: AppTheme.textPrimary),
          items: _displayTopics.map((topic) {
            return DropdownMenuItem(
              value: topic,
              child: Text(topic),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedTopic = value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCountSelector() {
    return Row(
      children: [5, 10, 15, 20].map((count) {
        final isSelected = count == _questionCount;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _questionCount = count),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accentColor : AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDifficultySelector() {
    final difficulties = [
      {'value': 'easy', 'label': 'Kolay', 'color': AppTheme.successColor},
      {'value': 'medium', 'label': 'Orta', 'color': AppTheme.warningColor},
      {'value': 'hard', 'label': 'Zor', 'color': AppTheme.errorColor},
    ];

    return Row(
      children: difficulties.map((d) {
        final isSelected = d['value'] == _difficulty;
        final color = d['color'] as Color;
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _difficulty = d['value'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    d['label'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _generateExam,
        icon: _isGenerating
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                  value: _progress > 0 ? _progress : null,
                ),
              )
            : const Icon(Icons.picture_as_pdf),
        label: Text(
          _isGenerating 
              ? 'Oluşturuluyor... %${(_progress * 100).toInt()}'
              : 'PDF Oluştur',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Future<void> _generateExam() async {
    setState(() {
      _isGenerating = true;
      _progress = 0;
    });

    // Progress simulasyonu
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() => _progress = i / 10);
      }
    }

    try {
      final pdfBytes = await _pdfService.generateExamWithAI(
        subject: _selectedSubject,
        topic: _selectedTopic,
        questionCount: _questionCount,
        difficulty: _difficulty,
      );

      if (pdfBytes == null) {
        throw Exception('PDF oluşturulamadı');
      }

      // PDF'i kaydet
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'SOLICAP_${_selectedTopic}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        _showSuccessDialog(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showSuccessDialog(String filePath) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor),
            SizedBox(width: 8),
            Text(
              'PDF Hazır!',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deneme sınavın başarıyla oluşturuldu.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description, 
                      color: AppTheme.errorColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      filePath.split('/').last,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Share.shareXFiles([XFile(filePath)]);
            },
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Paylaş'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
