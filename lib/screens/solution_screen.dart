/// SOLICAP - Solution Screen
/// Soru çözümü gösterim ekranı

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/user_dna_service.dart';
import '../services/spaced_repetition_service.dart';
import '../services/points_service.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_model.dart';
import '../models/user_dna_model.dart';
import 'practice_screen.dart';

class SolutionScreen extends StatefulWidget {
  final QuestionSolution solution;
  final Uint8List imageBytes;

  const SolutionScreen({
    super.key,
    required this.solution,
    required this.imageBytes,
  });

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  final UserDNAService _dnaService = UserDNAService();
  final SpacedRepetitionService _srService = SpacedRepetitionService();
  
  bool _showImage = false;
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
        });

        // 📊 OTOMATİK DNA KAYDI: Kamera ile çözülen sorular 'zorlanılan' kabul edilir
        _recordStruggle();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingDNA = false);
    }
  }

  Future<void> _recordStruggle() async {
    // 🛑 OTOMATİK KART EKLEME İPTAL EDİLDİ (Kullanıcı İsteği)
    // Artık sadece manuel olarak 'Kart Üret' butonu ile ekleniyor.
    
    // 🏆 Liderlik Puanı Ekle (+10 soru çözümü)
    await LeaderboardService().addPoints(
      LeaderboardPoints.questionSolve, 
      'question_solve',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Çözüm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_showImage ? Icons.hide_image : Icons.image),
            onPressed: () => setState(() => _showImage = !_showImage),
            tooltip: 'Soruyu Göster',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soru görseli (toggle ile)
            if (_showImage)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: MemoryImage(widget.imageBytes),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

            // Konu Bilgisi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTopicChips(),
            ),

            // Performans İçgörüsü
            if (!_isLoadingDNA && _userDNA != null)
              _buildPerformanceInsight(),

            const SizedBox(height: 16),

            // Soru Metni (geometrik şekil tanımı temizlenmiş)
            if (widget.solution.questionText.isNotEmpty && _cleanQuestionText(widget.solution.questionText).isNotEmpty)
              _buildSection(
                title: 'Soru',
                child: Text(
                  _cleanQuestionText(widget.solution.questionText),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),

            // Çözüm
            _buildSection(
              title: 'Çözüm',
              child: MarkdownBody(
                data: _formatSolutionText(widget.solution.solution),
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: AppTheme.textPrimary, height: 1.6, fontSize: 16),
                  strong: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                  h3: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                  code: TextStyle(
                    backgroundColor: AppTheme.surfaceColor,
                    color: AppTheme.secondaryColor,
                    fontSize: 14,
                  ),
                  listBullet: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            ),

            // 💡 Üslü ifade bilgilendirme notu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppTheme.primaryColor.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'x^2 gibi ifadeler x² (üs) anlamına gelir.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cevap
            if (widget.solution.correctAnswer != null)
              _buildSection(
                title: 'Doğru Cevap',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.successColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.solution.correctAnswer!,
                          style: const TextStyle(
                            color: AppTheme.successColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Kullanılan Kavramlar
            if (widget.solution.keyConceptsUsed.isNotEmpty)
              _buildSection(
                title: 'Kullanılan Kavramlar',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.solution.keyConceptsUsed.map((concept) {
                    return Chip(
                      label: Text(concept),
                      backgroundColor: AppTheme.surfaceColor,
                      labelStyle: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                ),
              ),

            // İpuçları
            if (widget.solution.tips.isNotEmpty)
              _buildSection(
                title: 'İpuçları',
                child: Column(
                  children: widget.solution.tips.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.warningColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 24),

            // ✨ AI Kart Üret Butonu (Sadece Sözel ve Biyoloji)
            if (_isEligibleForFlashcards())
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _generateAiFlashcards,
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text('✨ Akıllı Kart Üret (30 💎)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChips() {
    final subjectColor = AppTheme.subjectColors[widget.solution.subject] ?? AppTheme.primaryColor;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: subjectColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getSubjectIcon(widget.solution.subject),
                color: subjectColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                widget.solution.subject,
                style: TextStyle(
                  color: subjectColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.solution.topic,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        const Spacer(),
        _buildDifficultyBadge(),
      ],
    );
  }

  Widget _buildDifficultyBadge() {
    Color color;
    String text;
    
    switch (widget.solution.difficulty) {
      case 'easy':
        color = AppTheme.successColor;
        text = 'Kolay';
        break;
      case 'hard':
        color = AppTheme.errorColor;
        text = 'Zor';
        break;
      default:
        color = AppTheme.warningColor;
        text = 'Orta';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// OCR'dan gelen geometrik şekil / grafik tanımını soru metninden temizle
  String _cleanQuestionText(String text) {
    // Temizlenecek tanım başlıkları (geometri + grafik varyasyonları)
    final patterns = [
      'GEOMETRİK ŞEKİL TANIMI',
      'GRAFIK TANIMI',
      'GRAFİK TANIMI',
      '**GRAFIK TANIMI:**',
      '**GRAFİK TANIMI:**',
      '**GEOMETRİK ŞEKİL TANIMI:**',
      'Koordinat sistemi:',
      'Koordinat Sistemi:',
    ];

    for (final pattern in patterns) {
      final index = text.indexOf(pattern);
      if (index != -1) {
        // Tanım bloğundan sonra asıl soru kısmını bul
        final soruIndex = text.indexOf(
          RegExp(r'\*?\*?SORU:?\*?\*?|\*?\*?VERİLEN ?BİLGİ:?\*?\*?|\*?\*?ŞIKLAR:?\*?\*?', caseSensitive: false),
          index,
        );
        if (soruIndex != -1) {
          // Tanım öncesi metin + soru kısmı
          final before = text.substring(0, index).trim();
          final after = text.substring(soruIndex).trim();
          return before.isEmpty ? after : '$before\n\n$after';
        }
        // Soru kısmı bulunamazsa tanım öncesini göster
        return text.substring(0, index).trim();
      }
    }
    return text;
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildPerformanceInsight() {
    final topicName = widget.solution.topic;
    final perf = _userDNA?.subTopicPerformance[topicName];
    
    if (perf == null || perf.totalQuestions == 0) return const SizedBox.shrink();

    final successRate = (perf.successRate * 100).toInt();
    final color = successRate > 70 ? AppTheme.successColor : (successRate > 40 ? AppTheme.warningColor : AppTheme.errorColor);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.insights, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bu konuda uzmanlığın: %$successRate (${perf.totalQuestions} çözüm)',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematik':
        return Icons.calculate;
      case 'fizik':
        return Icons.science;
      case 'kimya':
        return Icons.biotech;
      case 'biyoloji':
        return Icons.eco;
      case 'türkçe':
        return Icons.menu_book;
      case 'tarih':
        return Icons.history_edu;
      case 'coğrafya':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  void _goToPractice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeScreen(
          subject: widget.solution.subject,
          topic: widget.solution.topic,
          originalQuestion: widget.solution.questionText,
          originalSolution: widget.solution.solution, // 🆕 Çözüm mantığını aktar
        ),
      ),
    );
  }

  /// 📝 Çözüm metnini Markdown formatına çevir
  String _formatSolutionText(String raw) {
    if (raw.isEmpty) return 'Çözüm bulunamadı.';

    String formatted = raw;

    // 1. Adım Başlıklarını Kalınlaştır
    // "1. Adım:", "Adım 1:", "Step 1:" gibi ifadeleri bulup ** ** içine al
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?:^|\n)(\d+\.\s*Adım|Adım\s*\d+|Step\s*\d+)(?::|\s)', caseSensitive: false),
      (match) => '\n\n### ${match.group(1)}\n',
    );

    // 2. Anahtar kelimeleri vurgula (Cevap, Sonuç, Uyarı)
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?:^|\n)(Cevap|Yanıt|Sonuç|Uyarı|Not|Dikkat|İpucu)(?::|\s)', caseSensitive: false),
      (match) => '\n\n**${match.group(1)}** ',
    );

    // 3. Madde işaretlerini düzelt (- veya * ile başlayanları alt satıra al)
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?<!\n)([•\-\*])\s+'), 
      (match) => '\n${match.group(1)} ',
    );

    return formatted.trim();
  }

  /// 🧐 Bu konu kart üretimi için uygun mu? (Sözel + Biyoloji)
  bool _isEligibleForFlashcards() {
    final s = widget.solution.subject.toLowerCase();
    
    // İzin verilenler: Sözel dersler + Biyoloji
    if (s.contains('biyoloji') || s.contains('biology')) return true;
    if (s.contains('tarih') || s.contains('history')) return true;
    if (s.contains('coğrafya') || s.contains('geography')) return true;
    if (s.contains('türkçe') || s.contains('turkish')) return true;
    if (s.contains('edebiyat') || s.contains('literature')) return true;
    if (s.contains('felsefe') || s.contains('philosophy')) return true;
    if (s.contains('din') || s.contains('religion')) return true;
    if (s.contains('ingilizce') || s.contains('english')) return true; // Dil de sözel sayılabilir
    
    return false;
  }

  /// 🪄 AI ile Kart Üret ve Kaydet
  Future<void> _generateAiFlashcards() async {
    final gemini = GeminiService(); // Singleton değilse instance al
    
    // Puan Kontrolü UI
    final hasPoints = await PointsService().hasEnoughPoints('generate_flashcards');
    if (!hasPoints) {
      if (mounted) {
        PointsService.showInsufficientPointsDialog(
          context, 
          actionName: 'Kart Üretimi',
          onPointsAdded: () {}
        );
      }
      return;
    }

    // Yükleniyor...
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✨ Yapay zeka kartlarını hazırlıyor...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Kartları Üret
      final cards = await gemini.generateFlashcards(widget.solution.subject, widget.solution.topic);
      
      if (cards.isEmpty) {
         if (mounted) _showError('Kart üretilemedi. Lütfen tekrar dene.');
         return;
      }

      // Kartları Kaydet
      int successCount = 0;
      for (final card in cards) {
        await _srService.addCard(
          questionText: card['question']!,
          correctAnswer: card['answer']!,
          topic: widget.solution.subject, // Ana ders
          subTopic: widget.solution.topic, // Konu
          questionId: 'ai_gen_${DateTime.now().millisecondsSinceEpoch}_$successCount',
        );
        successCount++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('🎉 $successCount adet akıllı kart eklendi!'),
            backgroundColor: Colors.green,
          ),
        );
      }

    } catch (e) {
      if (mounted) _showError('Hata: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
