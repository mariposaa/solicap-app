/// SOLICAP - Challenge Game Screen
/// Soru ekranı, timer, şık seçimi - Animasyonlu versiyon

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge_model.dart';
import '../models/challenge_question_model.dart';
import '../services/challenge_service.dart';
import 'challenge_result_screen.dart';

class ChallengeGameScreen extends StatefulWidget {
  final Challenge challenge;
  /// Solo mod: sorular önceden yüklenmiş, 10 soru bitince challenge oluşturulacak
  final List<ChallengeQuestion>? preloadedQuestions;

  const ChallengeGameScreen({
    super.key,
    required this.challenge,
    this.preloadedQuestions,
  });

  @override
  State<ChallengeGameScreen> createState() => _ChallengeGameScreenState();
}

class _ChallengeGameScreenState extends State<ChallengeGameScreen>
    with TickerProviderStateMixin {
  
  final ChallengeService _challengeService = ChallengeService();
  
  List<ChallengeQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _selectedAnswer = -1;
  bool _isAnswerLocked = false;
  bool _isLoading = true;
  
  // Skorlar
  int _correctAnswers = 0;
  int _totalTimeMs = 0;
  List<int> _userAnswers = [];
  
  // Timer
  Timer? _timer;
  int _timeLeft = 15;
  final int _timePerQuestion = 15;
  
  // Animasyonlar
  late AnimationController _timerController;
  late AnimationController _questionController;
  late AnimationController _shakeController;
  late AnimationController _scorePopupController;
  late AnimationController _flashController;
  
  late Animation<double> _questionFade;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scorePopupAnimation;
  late Animation<double> _flashAnimation;
  
  // Score popup
  bool _showScorePopup = false;
  int _lastScoreGained = 0;
  bool _lastAnswerCorrect = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadQuestions();
  }

  void _setupAnimations() {
    // Timer animasyonu
    _timerController = AnimationController(
      duration: Duration(seconds: _timePerQuestion),
      vsync: this,
    );

    // Soru geçiş animasyonu
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _questionFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeOut),
    );

    // Shake animasyonu (yanlış cevap için)
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // Score popup animasyonu
    _scorePopupController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scorePopupAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scorePopupController, curve: Curves.easeOutBack),
    );

    // Flash animasyonu
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeOut),
    );
  }

  Future<void> _loadQuestions() async {
    try {
      // Solo mod: preloaded sorular varsa onları kullan
      if (widget.preloadedQuestions != null && widget.preloadedQuestions!.isNotEmpty) {
        setState(() {
          _questions = widget.preloadedQuestions!;
          _isLoading = false;
        });
        _startQuestion();
        return;
      }

      // Normal mod: Firestore'dan yükle
      final questions = await _challengeService.getQuestionsByIds(
        widget.challenge.questionIds,
      );

      if (questions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Sorular yüklenemedi')),
          );
          Navigator.pop(context);
        }
        return;
      }

      setState(() {
        _questions = questions;
        _isLoading = false;
      });

      _startQuestion();
    } catch (e) {
      debugPrint('❌ Soru yükleme hatası: $e');
    }
  }

  void _startQuestion() {
    _questionController.forward(from: 0);
    _timeLeft = _timePerQuestion;
    _timerController.forward(from: 0);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _lockAnswer(-1); // Süre doldu
      }
    });
  }

  void _selectAnswer(int index) {
    if (_isAnswerLocked) return;
    setState(() => _selectedAnswer = index);
  }

  void _lockAnswer(int answerIndex) {
    if (_isAnswerLocked) return;

    _timer?.cancel();
    
    final isCorrect = answerIndex >= 0 && 
        _questions[_currentQuestionIndex].isCorrect(answerIndex);
    
    setState(() {
      _isAnswerLocked = true;
      _selectedAnswer = answerIndex;
      _lastAnswerCorrect = isCorrect;
    });

    // Süreyi hesapla
    final timeTaken = (_timePerQuestion - _timeLeft) * 1000;
    _totalTimeMs += timeTaken;
    _userAnswers.add(answerIndex);

    // Animasyonları tetikle
    if (isCorrect) {
      _correctAnswers++;
      _lastScoreGained = 100 + ((_timeLeft * 10).clamp(0, 150));
      
      // Doğru cevap animasyonları
      _flashController.forward().then((_) => _flashController.reverse());
      
      // Score popup
      setState(() => _showScorePopup = true);
      _scorePopupController.forward(from: 0);
    } else {
      // Yanlış cevap animasyonları
      _shakeController.forward(from: 0);
      _flashController.forward().then((_) => _flashController.reverse());
    }

    // 1.5 saniye bekle, sonra sonraki soru
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _showScorePopup = false);
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = -1;
        _isAnswerLocked = false;
      });
      _startQuestion();
    } else {
      _finishGame();
    }
  }

  Future<void> _finishGame() async {
    _timer?.cancel();

    String challengeId = widget.challenge.id;

    // Solo mod: 10 soru bitti, şimdi challenge oluştur
    if (widget.preloadedQuestions != null && widget.challenge.id.isEmpty) {
      final newChallenge = await _challengeService.createChallengeWithQuestions(
        category: widget.challenge.category,
        difficulty: widget.challenge.difficulty,
        questions: _questions,
        correctAnswers: _correctAnswers,
        totalTimeMs: _totalTimeMs,
        answers: _userAnswers,
      );
      if (newChallenge != null) {
        challengeId = newChallenge.id;
      } else {
        // Challenge oluşturulamadı
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Challenge kaydedilemedi')),
          );
          Navigator.pop(context);
        }
        return;
      }
    } else {
      // Normal mod: sonucu kaydet
      await _challengeService.submitPlayerResult(
        challengeId: challengeId,
        correctAnswers: _correctAnswers,
        totalTimeMs: _totalTimeMs,
        answers: _userAnswers,
      );
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChallengeResultScreen(
            challengeId: challengeId,
            correctAnswers: _correctAnswers,
            totalQuestions: _questions.length,
            totalTimeMs: _totalTimeMs,
            category: widget.challenge.category,
            difficulty: widget.challenge.difficulty,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerController.dispose();
    _questionController.dispose();
    _shakeController.dispose();
    _scorePopupController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              SizedBox(height: 16),
              Text('Sorular yükleniyor...', style: TextStyle(color: AppTheme.textMuted)),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Flash overlay (doğru/yanlış)
          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (context, child) {
              return Container(
                color: _lastAnswerCorrect
                    ? Colors.green.withOpacity(_flashAnimation.value)
                    : Colors.red.withOpacity(_flashAnimation.value),
              );
            },
          ),
          
          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                // Üst bar
                _buildTopBar(),
                
                // Progress bar
                _buildProgressBar(),
                
                // Timer
                _buildTimer(),
                
                const SizedBox(height: 24),
                
                // Soru (shake animasyonlu)
                Expanded(
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      final shakeOffset = sin(_shakeAnimation.value * pi * 4) * 10;
                      return Transform.translate(
                        offset: Offset(shakeOffset, 0),
                        child: child,
                      );
                    },
                    child: FadeTransition(
                      opacity: _questionFade,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildQuestionCard(question),
                            const SizedBox(height: 24),
                            _buildOptions(question),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Kilitle butonu
                if (_selectedAnswer >= 0 && !_isAnswerLocked)
                  _buildLockButton(),
              ],
            ),
          ),
          
          // Score popup
          if (_showScorePopup)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: ScaleTransition(
                    scale: _scorePopupAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        '+$_lastScoreGained',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Soru numarası
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Soru ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Doğru sayısı (animasyonlu)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: _lastAnswerCorrect && _isAnswerLocked ? 1.2 : 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$_correctAnswers',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: TweenAnimationBuilder<double>(
          tween: Tween(
            begin: _currentQuestionIndex / _questions.length,
            end: (_currentQuestionIndex + 1) / _questions.length,
          ),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: AppTheme.dividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final isWarning = _timeLeft <= 5;
    final color = isWarning ? Colors.red : Colors.amber;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular timer (animasyonlu)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: isWarning ? 1.1 : 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Arka plan daire
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade100),
                  ),
                  // İlerleme
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: _timeLeft / _timePerQuestion),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      );
                    },
                  ),
                  // Sayı
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: color,
                      fontSize: isWarning ? 32 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    child: Text('$_timeLeft'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ChallengeQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        question.questionText,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptions(ChallengeQuestion question) {
    return Column(
      children: List.generate(question.options.length, (index) {
        return _buildOptionButton(
          index: index,
          text: question.options[index],
          letter: question.getOptionLetter(index),
          isCorrect: question.correctIndex == index,
        );
      }),
    );
  }

  Widget _buildOptionButton({
    required int index,
    required String text,
    required String letter,
    required bool isCorrect,
  }) {
    final isSelected = _selectedAnswer == index;
    
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (_isAnswerLocked) {
      if (isCorrect) {
        bgColor = Colors.green.withOpacity(0.15);
        borderColor = Colors.green;
        textColor = Colors.green.shade700;
      } else if (isSelected && !isCorrect) {
        bgColor = Colors.red.withOpacity(0.15);
        borderColor = Colors.red;
        textColor = Colors.red.shade700;
      } else {
        bgColor = AppTheme.surfaceColor;
        borderColor = AppTheme.dividerColor;
        textColor = AppTheme.textMuted;
      }
    } else {
      if (isSelected) {
        bgColor = AppTheme.primaryColor.withOpacity(0.1);
        borderColor = AppTheme.primaryColor;
        textColor = AppTheme.primaryColor;
      } else {
        bgColor = AppTheme.surfaceColor;
        borderColor = AppTheme.dividerColor;
        textColor = AppTheme.textPrimary;
      }
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            // Şık harfi
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected || (_isAnswerLocked && isCorrect)
                    ? borderColor
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: isSelected || (_isAnswerLocked && isCorrect)
                        ? Colors.white
                        : textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Cevap metni
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Doğru/yanlış ikonu
            if (_isAnswerLocked && (isCorrect || (isSelected && !isCorrect)))
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _lockAnswer(_selectedAnswer),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 20),
              SizedBox(width: 8),
              Text(
                'Cevabı Kilitle',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
