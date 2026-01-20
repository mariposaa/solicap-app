/// SOLICAP - Practice Screen
/// Benzer sorular çözme ekranı

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/analytics_service.dart';
import '../models/question_model.dart';
import '../services/user_dna_service.dart';
import '../services/spaced_repetition_service.dart';
import '../services/points_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PracticeScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final String originalQuestion;
  final String? originalSolution; // 🆕 Orijinal sorunun çözüm mantığı

  const PracticeScreen({
    super.key,
    required this.subject,
    required this.topic,
    required this.originalQuestion,
    this.originalSolution, // 🆕 Opsiyonel parametre
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final GeminiService _geminiService = GeminiService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final UserDNAService _dnaService = UserDNAService();
  final SpacedRepetitionService _spacedRepetitionService = SpacedRepetitionService();
  final PointsService _pointsService = PointsService();
  
  List<SimilarQuestion> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _geminiService.generateSimilarQuestions(
        subject: widget.subject,
        topic: widget.topic,
        originalQuestion: widget.originalQuestion,
        originalSolutionLogic: widget.originalSolution, // 🆕 Çözüm mantığını aktar
        count: 1, // 🔴 5'ten 1'e düşürüldü (maliyet optimizasyonu)
      );

      // 📊 Analytics: Benzer soru üretildi
      await _analyticsService.logSimilarQuestionsGenerated(
        subject: widget.subject,
        count: questions.length,
      );

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Soru yükleme hatası: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('${widget.topic} Pratik'),
        actions: [
          if (_questions.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
          : _questions.isEmpty
              ? _buildEmpty()
              : _buildQuestionView(),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.primaryColor),
          const SizedBox(height: 24),
          Text(
            'Benzer sorular hazırlanıyor...',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz_outlined,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          const Text(
            'Soru oluşturulamadı',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Lütfen tekrar deneyin',
            style: TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadQuestions();
            },
            child: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İlerleme çubuğu
          _buildProgressBar(),
          
          const SizedBox(height: 24),
          
          // Soru
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Soru ${_currentIndex + 1}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  question.question,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Seçenekler
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswer == option;
            final isCorrect = option == question.correctAnswer;
            
            Color bgColor = AppTheme.surfaceColor;
            Color borderColor = Colors.transparent;
            
            if (_showResult) {
              if (isCorrect) {
                bgColor = AppTheme.successColor.withOpacity(0.2);
                borderColor = AppTheme.successColor;
              } else if (isSelected && !isCorrect) {
                bgColor = AppTheme.errorColor.withOpacity(0.2);
                borderColor = AppTheme.errorColor;
              }
            } else if (isSelected) {
              bgColor = AppTheme.primaryColor.withOpacity(0.2);
              borderColor = AppTheme.primaryColor;
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _showResult
                      ? null
                      : () => setState(() => _selectedAnswer = option),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option.replaceAll(RegExp(r'^[A-D]\)\s*'), ''),
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (_showResult && isCorrect)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.successColor,
                          ),
                        if (_showResult && isSelected && !isCorrect)
                          const Icon(
                            Icons.cancel,
                            color: AppTheme.errorColor,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          
          const SizedBox(height: 16),
          
          // Açıklama (sonuç gösterildiğinde)
          if (_showResult)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.secondaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.secondaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.explanation,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 💎 Yeni: İnteraktif Çözüm Butonu
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _solveCurrentQuestion(question),
                      icon: const Icon(Icons.psychology, size: 20),
                      label: const Text('Adım Adım Çözümü Gör (5 💎)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Butonlar
          SizedBox(
            width: double.infinity,
            child: _showResult
                ? ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      _currentIndex < _questions.length - 1
                          ? 'Sonraki Soru'
                          : 'Sonuçları Gör',
                    ),
                  )
                : ElevatedButton(
                    onPressed:
                        _selectedAnswer != null ? _checkAnswer : null,
                    child: const Text('Cevabı Kontrol Et'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Doğru: $_correctCount',
              style: const TextStyle(
                color: AppTheme.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Kalan: ${_questions.length - _currentIndex}',
              style: const TextStyle(color: AppTheme.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: AppTheme.surfaceColor,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ],
    );
  }

  void _checkAnswer() async {
    final question = _questions[_currentIndex];
    final isCorrect = _selectedAnswer == question.correctAnswer;
    
    if (isCorrect) {
      _correctCount++;
    }
    
    // 📊 DNA GÜNCELLEME: Her soruyu anlık kaydet
    try {
      await _dnaService.recordQuestionAttempt(
        topic: widget.subject,
        subTopic: widget.topic,
        difficulty: 'medium', // Üretilen sorular genelde orta seviye
        isCorrect: isCorrect,
        questionText: question.question,
        correctAnswer: question.correctAnswer,
      );

      // Eğer yanlışsa tekrar kartlarına da ekle
      if (!isCorrect) {
        await _spacedRepetitionService.addCard(
          questionId: '${widget.topic}_${DateTime.now().millisecondsSinceEpoch}',
          questionText: question.question,
          topic: widget.subject,
          subTopic: widget.topic,
          correctAnswer: question.correctAnswer,
        );
      }
    } catch (e) {
      debugPrint('DNA kayıt hatası: $e');
    }
    
    setState(() => _showResult = true);
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Pratik Tamamlandı! 🎉',
          style: TextStyle(color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correctCount / ${_questions.length}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _correctCount >= _questions.length * 0.7
                  ? 'Harika! Bu konuda çok iyisin! 🌟'
                  : _correctCount >= _questions.length * 0.5
                      ? 'İyi gidiyorsun! Biraz daha pratik yapalım.'
                      : 'Bu konuyu tekrar gözden geçirelim.',
              style: const TextStyle(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Ana Sayfaya Dön'),
          ),
        ],
      ),
    );
  }

  // 💎 Özel Soru Çözdürme Fonksiyonu
  Future<void> _solveCurrentQuestion(SimilarQuestion question) async {
    final hasEnough = await _pointsService.checkAndSpendPoints(
      context, 
      'standard_solve', // 5 Elmas
      description: 'Benzer soru için detaylı çözüm',
      onPointsAdded: () => setState(() {}),
    );

    if (!hasEnough) return;

    if (!mounted) return;
    
    // Çözüm beklenirken loading göster
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => FutureBuilder<QuestionSolution?>(
        future: _geminiService.solveQuestion(
          imageBytes: null, // Görsel yok, metinden çözülecek
          manuallyEnteredText: "Konu: ${widget.subject} - ${widget.topic}\nSoru: ${question.question}\nŞıklar: ${question.options.join(', ')}",
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 16),
                    Text('AI Çözümü Hazırlıyor...', style: TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text('Çözüm alınamadı, lütfen tekrar deneyin.')),
            );
          }

          final sol = snapshot.data!;
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      const Text(
                        'Master AI Çözümü',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      const Spacer(),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const Divider(height: 32),
                  MarkdownBody(
                    data: sol.solution,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, height: 1.6),
                      strong: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      h3: const TextStyle(color: AppTheme.primaryColor, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
