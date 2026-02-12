/// SOLICAP - YoYo Test Sınav Ekranı
/// Hız antrenmanı: 7 seviye, daralan süre, performans analizi

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/yoyo_test_models.dart';
import '../services/points_service.dart';
import '../services/leaderboard_service.dart';

class YoYoTestBattleScreen extends StatefulWidget {
  final YoYoSubject subject;

  const YoYoTestBattleScreen({super.key, required this.subject});

  @override
  State<YoYoTestBattleScreen> createState() => _YoYoTestBattleScreenState();
}

class _YoYoTestBattleScreenState extends State<YoYoTestBattleScreen>
    with TickerProviderStateMixin {
  // ─── DURUM ───
  int _currentLevel = 0; // 0-indexed (0..6)
  int _questionIndex = 0; // Seviye içi soru index (0..5)
  List<YoYoQuestion> _currentQuestions = [];
  final Set<int> _usedIndices = {};

  int _totalCorrect = 0;
  int _totalWrong = 0;
  int _totalAnswered = 0;

  // Seviye bazlı istatistik
  final List<int> _levelCorrects = [];
  final List<int> _levelWrongs = [];
  final List<String> _wrongTopics = [];

  int _levelCorrectCount = 0;
  int _levelWrongCount = 0;

  bool _isAnswering = false;
  int? _selectedOption;
  bool _gameOver = false;
  bool _victory = false;
  bool _showAnalysis = false;

  // Ödüller
  int _totalDiamondsEarned = 0;
  int _totalLeaderboardPoints = 0;

  // ─── ZAMANLAYICI ───
  late int _timeRemaining;
  Timer? _timer;
  late AnimationController _timerPulseCtrl;

  // ─── ANİMASYON ───
  late AnimationController _questionEntryCtrl;
  late AnimationController _levelUpCtrl;
  bool _showLevelUp = false;

  @override
  void initState() {
    super.initState();

    _timerPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _questionEntryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _levelUpCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _startLevel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerPulseCtrl.dispose();
    _questionEntryCtrl.dispose();
    _levelUpCtrl.dispose();
    super.dispose();
  }

  // ─── SEVİYE BAŞLAT ───
  void _startLevel() {
    _currentQuestions = widget.subject.getQuestionsForLevel(_usedIndices);
    _questionIndex = 0;
    _levelCorrectCount = 0;
    _levelWrongCount = 0;
    _timeRemaining = yoyoLevelTimes[_currentLevel];
    _isAnswering = false;
    _selectedOption = null;

    _startTimer();
    _questionEntryCtrl.forward(from: 0.0);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _timeRemaining--;
      });

      // Son 30 saniye pulse
      if (_timeRemaining <= 30 && _timeRemaining > 0) {
        _timerPulseCtrl.forward(from: 0.0);
      }

      if (_timeRemaining <= 0) {
        t.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _timer?.cancel();
    setState(() {
      _gameOver = true;
    });
  }

  // ─── CEVAP ───
  void _onAnswer(int optionIndex) {
    if (_isAnswering || _gameOver || _victory) return;

    final question = _currentQuestions[_questionIndex];
    final isCorrect = optionIndex == question.correct;

    setState(() {
      _isAnswering = true;
      _selectedOption = optionIndex;
    });

    _totalAnswered++;

    if (isCorrect) {
      _totalCorrect++;
      _levelCorrectCount++;
    } else {
      _totalWrong++;
      _levelWrongCount++;
      _wrongTopics.add(question.topic);
    }

    // 💀 3 yanlış = Elenme!
    if (_totalWrong >= 3) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _timer?.cancel();
        setState(() {
          _gameOver = true;
        });
      });
      return;
    }

    // Kısa gecikme ile devam et
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _gameOver || _victory) return;
      _proceedNext();
    });
  }

  void _proceedNext() {
    if (_questionIndex < _currentQuestions.length - 1) {
      // Aynı seviyede sonraki soru
      setState(() {
        _questionIndex++;
        _isAnswering = false;
        _selectedOption = null;
      });
      _questionEntryCtrl.forward(from: 0.0);
    } else {
      // Seviye tamamlandı
      _levelCorrects.add(_levelCorrectCount);
      _levelWrongs.add(_levelWrongCount);

      // 💎 Seviye ödülü: 3 elmas + 5 sıralama puanı
      _awardLevelReward();

      if (_currentLevel >= 6) {
        // TÜM 7 seviye tamam → Zafer!
        _timer?.cancel();
        setState(() {
          _victory = true;
        });
      } else {
        // Sonraki seviye
        _timer?.cancel();
        _showLevelTransition();
      }
    }
  }

  void _showLevelTransition() {
    setState(() {
      _showLevelUp = true;
    });
    _levelUpCtrl.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _showLevelUp = false;
        _currentLevel++;
      });
      _startLevel();
    });
  }

  // ─── SEVİYE ÖDÜLÜ ───
  void _awardLevelReward() {
    // 💎 3 elmas
    PointsService().addPoints(3, 'yoyo_test_level_${_currentLevel + 1}');
    _totalDiamondsEarned += 3;

    // 🏆 5 sıralama puanı
    LeaderboardService().addPoints(5, 'yoyo_test_level');
    _totalLeaderboardPoints += 5;

    debugPrint('🏃 YoYo Seviye ${_currentLevel + 1} ödül: +3💎, +5🏆');
  }

  // ─── YENİDEN BAŞLA ───
  Future<void> _restartGame() async {
    // 💎 Tekrar denemek için elmas kontrolü
    final pointsService = PointsService();
    final success = await pointsService.checkAndSpendPoints(
      context,
      'yoyo_test',
      description: 'YoYo Test - ${widget.subject.name} (Tekrar)',
    );

    if (!success) return; // Yetersiz elmas veya iptal
    if (!mounted) return;

    _usedIndices.clear();
    _levelCorrects.clear();
    _levelWrongs.clear();
    _wrongTopics.clear();
    setState(() {
      _currentLevel = 0;
      _totalCorrect = 0;
      _totalWrong = 0;
      _totalAnswered = 0;
      _gameOver = false;
      _victory = false;
      _showAnalysis = false;
      _totalDiamondsEarned = 0;
      _totalLeaderboardPoints = 0;
    });
    _startLevel();
  }

  // ─── SÜRE FORMAT ───
  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_showAnalysis) return _buildAnalysisScreen();
    if (_gameOver) return _buildGameOverScreen();
    if (_victory) return _buildVictoryScreen();
    if (_showLevelUp) return _buildLevelUpOverlay();
    return _buildQuizScreen();
  }

  // ─── SINAV EKRANI ───
  Widget _buildQuizScreen() {
    final question = _currentQuestions.isNotEmpty && _questionIndex < _currentQuestions.length
        ? _currentQuestions[_questionIndex]
        : null;
    if (question == null) return const SizedBox();

    final totalSeconds = yoyoLevelTimes[_currentLevel];
    final progress = _timeRemaining / totalSeconds;
    final isLowTime = _timeRemaining <= 30;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            // ─── ÜST BAR ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  // Seviye + soru numarası + çıkış
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showExitDialog(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.close, color: Colors.white54, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Seviye göstergesi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        child: Text(
                          'SEVİYE ${_currentLevel + 1}/7',
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Skor + Can
                      Row(
                        children: [
                          Text(
                            '✓ $_totalCorrect',
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          // 3 can göster (yanlış sayısına göre kırmızıya döner)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (i) {
                              final lost = i < _totalWrong;
                              return Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Icon(
                                  lost ? Icons.heart_broken : Icons.favorite,
                                  color: lost ? Colors.grey.withOpacity(0.4) : Colors.redAccent,
                                  size: 18,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Süre barı
                  AnimatedBuilder(
                    animation: _timerPulseCtrl,
                    builder: (context, child) {
                      final pulseScale = isLowTime
                          ? 1.0 + (_timerPulseCtrl.value * 0.03)
                          : 1.0;
                      return Transform.scale(
                        scale: pulseScale,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '⏱️ ${_formatTime(_timeRemaining)}',
                                  style: TextStyle(
                                    color: isLowTime ? Colors.redAccent : Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Soru ${_questionIndex + 1}/6',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation(
                                  isLowTime
                                      ? Colors.redAccent
                                      : progress > 0.5
                                          ? Colors.cyanAccent
                                          : Colors.orangeAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ─── SORU ALANI ───
            Expanded(
              child: AnimatedBuilder(
                animation: _questionEntryCtrl,
                builder: (context, child) {
                  final slideY = (1.0 - _questionEntryCtrl.value) * 30;
                  final opacity = _questionEntryCtrl.value.clamp(0.0, 1.0);
                  return Transform.translate(
                    offset: Offset(0, slideY),
                    child: Opacity(
                      opacity: opacity,
                      child: child,
                    ),
                  );
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Konu etiketi
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          question.topic,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Soru metni
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          question.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Şıklar
                      ...List.generate(question.options.length, (i) {
                        return _buildOptionButton(question, i);
                      }),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(YoYoQuestion question, int index) {
    final isSelected = _selectedOption == index;
    final isCorrect = index == question.correct;
    final showResult = _isAnswering;

    Color bgColor = Colors.white.withOpacity(0.06);
    Color borderColor = Colors.white.withOpacity(0.15);
    Color textColor = Colors.white;

    if (showResult) {
      if (isCorrect) {
        bgColor = Colors.greenAccent.withOpacity(0.15);
        borderColor = Colors.greenAccent.withOpacity(0.6);
        textColor = Colors.greenAccent;
      } else if (isSelected && !isCorrect) {
        bgColor = Colors.redAccent.withOpacity(0.15);
        borderColor = Colors.redAccent.withOpacity(0.6);
        textColor = Colors.redAccent;
      }
    } else if (isSelected) {
      bgColor = Colors.cyanAccent.withOpacity(0.1);
      borderColor = Colors.cyanAccent.withOpacity(0.4);
    }

    final letters = ['A', 'B', 'C', 'D'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _onAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              // Harf dairesi
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: showResult && isCorrect
                      ? Colors.greenAccent.withOpacity(0.2)
                      : showResult && isSelected && !isCorrect
                          ? Colors.redAccent.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    letters[index],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Şık metni
              Expanded(
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: showResult && isCorrect ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              // Doğru/yanlış ikonu
              if (showResult && isCorrect)
                const Icon(Icons.check_circle, color: Colors.greenAccent, size: 22),
              if (showResult && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Colors.redAccent, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SEVİYE GEÇİŞ OVERLAY ───
  Widget _buildLevelUpOverlay() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: AnimatedBuilder(
          animation: _levelUpCtrl,
          builder: (context, child) {
            final scale = Curves.elasticOut.transform(_levelUpCtrl.value.clamp(0.0, 1.0));
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.cyanAccent, Colors.blueAccent, Colors.cyanAccent],
                ).createShader(bounds),
                child: Text(
                  'SEVİYE ${_currentLevel + 2}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Süre: ${_formatTime(yoyoLevelTimes[_currentLevel + 1 > 6 ? 6 : _currentLevel + 1])}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bu seviye: $_levelCorrectCount doğru / $_levelWrongCount yanlış',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── OYUN BİTTİ (SÜRE DOLDU) ───
  Widget _buildGameOverScreen() {
    // Son seviyenin istatistiğini kaydet (henüz kaydedilmediyse)
    if (_levelCorrects.length <= _currentLevel) {
      _levelCorrects.add(_levelCorrectCount);
      _levelWrongs.add(_levelWrongCount);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_totalWrong >= 3 ? '💀' : '⏱️', style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent],
                  ).createShader(bounds),
                  child: Text(
                    _totalWrong >= 3 ? '3 YANLIŞ!' : 'SÜRE DOLDU!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _totalWrong >= 3
                      ? '3 yanlış yaptın, elendin!'
                      : 'Seviye ${_currentLevel + 1}\'de elendin',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // İstatistik kutusu
                _buildStatBox(),

                const SizedBox(height: 24),

                // Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      label: 'Tekrar Dene',
                      icon: Icons.refresh,
                      color: Colors.cyanAccent,
                      onTap: _restartGame,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      label: 'Analiz',
                      icon: Icons.analytics_outlined,
                      color: Colors.amberAccent,
                      onTap: () => setState(() => _showAnalysis = true),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Derslere Dön',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── ZAFER EKRANI ───
  Widget _buildVictoryScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFFD700)],
                  ).createShader(bounds),
                  child: const Text(
                    'TEBRİKLER!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '7 seviyeyi tamamladın!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                _buildStatBox(),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      label: 'Tekrar Dene',
                      icon: Icons.refresh,
                      color: Colors.cyanAccent,
                      onTap: _restartGame,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      label: 'Analiz',
                      icon: Icons.analytics_outlined,
                      color: Colors.amberAccent,
                      onTap: () => setState(() => _showAnalysis = true),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Derslere Dön',
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── İSTATİSTİK KUTUSU ───
  Widget _buildStatBox() {
    final successRate = _totalAnswered > 0
        ? (_totalCorrect / _totalAnswered * 100).toStringAsFixed(0)
        : '0';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Seviye', '${_levelCorrects.length}/7', Colors.cyanAccent),
              _buildStatItem('Doğru', '$_totalCorrect', Colors.greenAccent),
              _buildStatItem('Yanlış', '$_totalWrong', Colors.redAccent),
              _buildStatItem('Başarı', '%$successRate', Colors.amberAccent),
            ],
          ),
          if (_totalDiamondsEarned > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.diamond, color: Colors.amber, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '+$_totalDiamondsEarned elmas',
                    style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  const Text('🏆', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '+$_totalLeaderboardPoints puan',
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ─── ANALİZ EKRANI ───
  Widget _buildAnalysisScreen() {
    final successRate = _totalAnswered > 0
        ? (_totalCorrect / _totalAnswered * 100)
        : 0.0;

    // Konu bazlı yanlış sayıları
    final topicCounts = <String, int>{};
    for (final t in _wrongTopics) {
      topicCounts[t] = (topicCounts[t] ?? 0) + 1;
    }
    final sortedTopics = topicCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Performans yorumu
    String performanceText;
    String performanceEmoji;
    if (successRate >= 90) {
      performanceText = 'Mükemmel! Harika bir performans.';
      performanceEmoji = '🌟';
    } else if (successRate >= 70) {
      performanceText = 'İyi gidiyorsun! Zayıf konulara odaklan.';
      performanceEmoji = '👍';
    } else if (successRate >= 50) {
      performanceText = 'Geliştirilmeli. Tekrar çalış.';
      performanceEmoji = '📚';
    } else {
      performanceText = 'Daha çok çalışmalısın. Temel konulara dön.';
      performanceEmoji = '💪';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri butonu
              GestureDetector(
                onTap: () => setState(() => _showAnalysis = false),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                ),
              ),

              const SizedBox(height: 20),

              // Başlık
              Center(
                child: Column(
                  children: [
                    Text(performanceEmoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 10),
                    const Text(
                      'PERFORMANS ANALİZİ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.subject.name,
                      style: TextStyle(
                        color: Colors.cyanAccent.withOpacity(0.8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Genel performans
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Genel Durum',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Toplam', '$_totalAnswered', Colors.white),
                        _buildStatItem('Doğru', '$_totalCorrect', Colors.greenAccent),
                        _buildStatItem('Yanlış', '$_totalWrong', Colors.redAccent),
                        _buildStatItem('Başarı', '%${successRate.toStringAsFixed(0)}', Colors.amberAccent),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Başarı barı
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (successRate / 100).clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(
                          successRate >= 70
                              ? Colors.greenAccent
                              : successRate >= 50
                                  ? Colors.orangeAccent
                                  : Colors.redAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        performanceText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Seviye bazlı sonuçlar
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seviye Bazlı',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_levelCorrects.length, (i) {
                      final c = _levelCorrects[i];
                      final w = _levelWrongs[i];
                      final total = c + w;
                      final rate = total > 0 ? (c / total * 100).toStringAsFixed(0) : '0';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                'Seviye ${i + 1}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: total > 0 ? c / total : 0,
                                  minHeight: 6,
                                  backgroundColor: Colors.redAccent.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              child: Text(
                                '$c/$total',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 35,
                              child: Text(
                                '%$rate',
                                style: TextStyle(
                                  color: double.parse(rate) >= 50
                                      ? Colors.greenAccent.withOpacity(0.8)
                                      : Colors.redAccent.withOpacity(0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Zayıf konular
              if (sortedTopics.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('⚠️', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Text(
                            'Zayıf Konular',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...sortedTopics.take(5).map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.value}',
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Butonlar
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      label: 'Tekrar Dene',
                      icon: Icons.refresh,
                      color: Colors.cyanAccent,
                      onTap: _restartGame,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      label: 'Derslere Dön',
                      icon: Icons.arrow_back,
                      color: Colors.white54,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ─── ORTAK BUTON ───
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ÇIKIŞ DİYALOGU ───
  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sınavdan Çık?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Çıkarsan ilerleme kaybolur. Baştan başlamak zorunda kalırsın.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Devam Et', style: TextStyle(color: Colors.cyanAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Çık', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
