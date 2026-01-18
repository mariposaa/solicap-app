/// SOLICAP - Quiz Screen (Deneme Sınavı)
/// PDF yerine uygulama içi interaktif test ekranı

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../models/user_dna_model.dart';
import '../services/user_dna_service.dart';
import '../services/points_service.dart';
import '../services/gemini_service.dart';

class PdfExamScreen extends StatefulWidget {
  const PdfExamScreen({super.key});

  @override
  State<PdfExamScreen> createState() => _PdfExamScreenState();
}

class _PdfExamScreenState extends State<PdfExamScreen> {
  final GeminiService _geminiService = GeminiService();
  final UserDNAService _dnaService = UserDNAService();
  final PointsService _pointsService = PointsService();
  
  // Ayarlar
  String _selectedSubject = 'Matematik';
  String _selectedTopic = 'Türev';
  String _difficulty = 'medium';
  
  // Durum
  bool _isGenerating = false;
  bool _isQuizMode = false;
  bool _showResults = false;
  bool _isLoadingDNA = true;
  
  // Quiz verileri
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  Map<int, String> _userAnswers = {};
  
  // DNA verileri
  List<WeakTopic> _weakTopics = [];
  UserDNA? _userDNA;

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
            if (_weakTopics.isNotEmpty) {
              _selectedSubject = _weakTopics.first.topic;
              _selectedTopic = _weakTopics.first.subTopic;
            } else if (dna.subTopicPerformance.isNotEmpty) {
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

  List<String> get _displaySubjects {
    if (_userDNA == null) return [];
    return _userDNA!.subTopicPerformance.values
        .map((p) => p.parentTopic)
        .toSet()
        .toList();
  }

  List<String> get _displayTopics {
    if (_userDNA == null) return [];
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
        title: Row(
          children: [
            Icon(
              _isQuizMode ? Icons.quiz : Icons.school,
              color: AppTheme.accentColor,
            ),
            const SizedBox(width: 8),
            Text(
              _isQuizMode ? 'Deneme Sınavı' : 'Test Oluştur',
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () {
            if (_isQuizMode && !_showResults) {
              _showExitConfirmation();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: isLocked 
          ? _buildLockedState(totalSolved) 
          : _isQuizMode 
              ? (_showResults ? _buildResultsView() : _buildQuizView())
              : _buildSetupView(),
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
              decoration: const BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_person, size: 64, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deneme Modu Kilitli',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'En az 10 soru çözmelisin. Şu an $totalSolved soru çözdün.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            LinearProgressIndicator(
              value: totalSolved / 10,
              backgroundColor: AppTheme.surfaceColor,
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              minHeight: 12,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SETUP VIEW - Test ayarları
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildSetupView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('📚 Ders Seç'),
          const SizedBox(height: 12),
          _buildSubjectSelector(),
          
          const SizedBox(height: 20),
          
          _buildSectionTitle('📖 Konu Seç'),
          const SizedBox(height: 12),
          _buildTopicSelector(),
          
          const SizedBox(height: 20),
          
          _buildSectionTitle('⚡ Zorluk'),
          const SizedBox(height: 12),
          _buildDifficultySelector(),
          
          const SizedBox(height: 32),
          
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.quiz, color: AppTheme.accentColor, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 5 Soruluk Mini Test',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Seçtiğin konudan AI destekli sorular',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubjectSelector() {
    final subjects = _displaySubjects;
    if (subjects.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Henüz soru çözmediniz', style: TextStyle(color: AppTheme.textMuted)),
      );
    }
    
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
    final topics = _displayTopics;
    if (topics.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Bu derste konu yok', style: TextStyle(color: AppTheme.textMuted)),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: topics.contains(_selectedTopic) ? _selectedTopic : topics.first,
          isExpanded: true,
          dropdownColor: AppTheme.cardColor,
          style: const TextStyle(color: AppTheme.textPrimary),
          items: topics.map((topic) => DropdownMenuItem(value: topic, child: Text(topic))).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedTopic = value);
          },
        ),
      ),
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

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : _startQuiz,
        icon: _isGenerating
            ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.play_arrow),
        label: Text(
          _isGenerating ? 'Sorular Hazırlanıyor...' : 'Testi Başlat',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // QUIZ VIEW - Soru gösterimi
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildQuizView() {
    if (_questions.isEmpty) return const SizedBox();
    
    final question = _questions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];
    
    return Column(
      children: [
        // Progress bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soru ${_currentQuestionIndex + 1} / ${_questions.length}',
                    style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$_selectedTopic',
                    style: const TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  backgroundColor: AppTheme.surfaceColor,
                  color: AppTheme.accentColor,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        
        // Soru
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Soru metni
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: MarkdownBody(
                    data: '**${_currentQuestionIndex + 1}.** ${question.text}',
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, height: 1.5),
                      strong: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Seçenekler
                ...question.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final letter = String.fromCharCode(65 + index);
                  final isSelected = selectedAnswer == letter;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _userAnswers[_currentQuestionIndex] = letter),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.accentColor.withOpacity(0.15) : AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.accentColor : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.accentColor : AppTheme.surfaceColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        
        // Navigasyon butonları
        _buildQuizNavigation(),
      ],
    );
  }

  Widget _buildQuizNavigation() {
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;
    final hasAnswer = _userAnswers.containsKey(_currentQuestionIndex);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentQuestionIndex > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _currentQuestionIndex--),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Önceki'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            if (_currentQuestionIndex > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: hasAnswer
                    ? () {
                        if (isLastQuestion) {
                          _finishQuiz();
                        } else {
                          setState(() => _currentQuestionIndex++);
                        }
                      }
                    : null,
                icon: Icon(isLastQuestion ? Icons.check : Icons.arrow_forward),
                label: Text(isLastQuestion ? 'Bitir' : 'Sonraki'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastQuestion ? AppTheme.successColor : AppTheme.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // RESULTS VIEW - Sonuç ekranı
  // ═══════════════════════════════════════════════════════════════
  
  Widget _buildResultsView() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctAnswer) correct++;
    }
    final percentage = (correct / _questions.length * 100).round();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Skor kartı
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: percentage >= 60 
                    ? [AppTheme.successColor.withOpacity(0.2), AppTheme.successColor.withOpacity(0.05)]
                    : [AppTheme.errorColor.withOpacity(0.2), AppTheme.errorColor.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Icon(
                  percentage >= 60 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                  size: 64,
                  color: percentage >= 60 ? AppTheme.successColor : AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  '%$percentage',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: percentage >= 60 ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
                Text(
                  '$correct / ${_questions.length} Doğru',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  percentage >= 80 ? 'Mükemmel! 🎉' : percentage >= 60 ? 'İyi! 👍' : 'Çalışmaya devam! 💪',
                  style: TextStyle(
                    color: percentage >= 60 ? AppTheme.successColor : AppTheme.warningColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Soru detayları
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '📋 Soru Detayları',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(_questions.length, (index) {
            final q = _questions[index];
            final userAnswer = _userAnswers[index] ?? '-';
            final isCorrect = userAnswer == q.correctAnswer;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCorrect ? AppTheme.successColor.withOpacity(0.3) : AppTheme.errorColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.text.length > 50 ? '${q.text.substring(0, 50)}...' : q.text,
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Cevabın: $userAnswer',
                              style: TextStyle(
                                color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (!isCorrect) ...[
                              const Text(' • ', style: TextStyle(color: AppTheme.textMuted)),
                              Text(
                                'Doğru: ${q.correctAnswer}',
                                style: const TextStyle(color: AppTheme.successColor, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ],
              ),
            );
          }),
          
          const SizedBox(height: 24),
          
          // Tekrar dene butonu
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isQuizMode = false;
                  _showResults = false;
                  _questions = [];
                  _userAnswers = {};
                  _currentQuestionIndex = 0;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Yeni Test Oluştur', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════
  
  Future<void> _startQuiz() async {
    // Not: Puan kontrolü generateSimilarQuestions içinde yapılıyor
    // Çift harcama önlemek için burada kontrol YAPILMIYOR

    setState(() => _isGenerating = true);

    try {
      // Daha açıklayıcı soru şablonu oluştur
      final questionTemplate = '''
$_selectedSubject dersi, $_selectedTopic konusu için $_difficulty seviyesinde bir test sorusu.
Soru türü: Çoktan seçmeli (A, B, C, D, E şıklı)
Konu: $_selectedTopic
Zorluk: ${_difficulty == 'easy' ? 'Kolay' : _difficulty == 'medium' ? 'Orta' : 'Zor'}
''';

      final similarQuestions = await _geminiService.generateSimilarQuestions(
        subject: _selectedSubject,
        topic: _selectedTopic,
        originalQuestion: questionTemplate,
        originalSolutionLogic: 'Standart $_selectedTopic çözüm yöntemi kullanılacak',
        count: 5,
      );

      if (similarQuestions.isEmpty) {
        throw Exception('Sorular oluşturulamadı');
      }

      setState(() {
        _questions = similarQuestions.map((q) => QuizQuestion(
          text: q.question,
          options: q.options,
          correctAnswer: q.correctAnswer,
        )).toList();
        _isQuizMode = true;
        _isGenerating = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  void _finishQuiz() {
    setState(() => _showResults = true);
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Testten Çık?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'Testten çıkarsan ilerleme kaydedilmez.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }
}

/// Quiz soru modeli
class QuizQuestion {
  final String text;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}
