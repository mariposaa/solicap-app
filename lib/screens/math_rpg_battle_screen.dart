/// SOLICAP - Math RPG Savaş Ekranı
/// Canavarlarla savaş, matematik çöz!
/// Efektler: Shake, flash, damage pop, critical hit, boss glow, vignette

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/math_rpg_models.dart';

class MathRPGBattleScreen extends StatefulWidget {
  final MathRPGLevel level;

  const MathRPGBattleScreen({super.key, required this.level});

  @override
  State<MathRPGBattleScreen> createState() => _MathRPGBattleScreenState();
}

class _MathRPGBattleScreenState extends State<MathRPGBattleScreen>
    with TickerProviderStateMixin {
  // ══════════════════════════════════════════
  // 🎮 GAME STATE
  // ══════════════════════════════════════════
  int _currentMonsterIdx = 0;
  int _questionInMonster = 0;
  int _monsterHP = 0;
  int _playerHP = 100;
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  int _correctCount = 0;
  int _totalAnswered = 0;
  int _criticalHits = 0;

  // ══════════════════════════════════════════
  // 🖥️ UI STATE
  // ══════════════════════════════════════════
  bool _isAnswering = false;
  int? _selectedOption;
  bool? _wasCorrect;
  bool _showDamageNum = false;
  String _damageText = '';
  Color _damageColor = Colors.white;
  bool _showCritical = false;
  bool _gameOver = false;
  bool _victory = false;
  bool _monsterDefeated = false;
  bool _gameStarted = false;

  // ══════════════════════════════════════════
  // 📝 SORU GRUPLARI
  // ══════════════════════════════════════════
  late List<List<MathRPGQuestion>> _monsterQuestions;

  MathRPGMonster get _currentMonster =>
      widget.level.monsters[_currentMonsterIdx];
  MathRPGQuestion get _currentQuestion =>
      _monsterQuestions[_currentMonsterIdx][_questionInMonster];

  // ══════════════════════════════════════════
  // 🎬 ANİMASYON CONTROLLERS
  // ══════════════════════════════════════════
  late AnimationController _monsterShakeCtrl;
  late AnimationController _timerCtrl;
  late AnimationController _monsterEntryCtrl;
  late AnimationController _flashCtrl;
  late AnimationController _damagePopCtrl;
  late AnimationController _bossGlowCtrl;
  late AnimationController _idleCtrl;         // 🫁 Nefes / bob animasyonu
  late AnimationController _monsterAttackCtrl; // ⚔️ Canavar saldırı lunge
  bool _monsterHitFlash = false;               // 💥 Hasar flash

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initQuestions();
    _startGame();
  }

  void _initAnimations() {
    _monsterShakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _timerCtrl = AnimationController(
      duration: Duration(seconds: widget.level.timeLimit),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && _gameStarted) {
          _onTimeUp();
        }
      });

    _monsterEntryCtrl = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flashCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _damagePopCtrl = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bossGlowCtrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 🫁 Idle bob - sürekli yukarı aşağı sallanma
    _idleCtrl = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // ⚔️ Canavar saldırı - yanlış cevapta öne atılır
    _monsterAttackCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  /// Soruları zorluğa göre sırala, her canavara 5 soru ata
  void _initQuestions() {
    final sorted = List<MathRPGQuestion>.from(widget.level.questions)
      ..sort((a, b) => a.difficulty.compareTo(b.difficulty));

    final rng = Random();
    _monsterQuestions = [];

    for (int i = 0; i < widget.level.monsters.length; i++) {
      final start = i * 5;
      final end = (start + 5).clamp(0, sorted.length);
      if (start < sorted.length) {
        final group = sorted.sublist(start, end)..shuffle(rng);
        _monsterQuestions.add(group);
      }
    }
  }

  void _startGame() {
    _gameStarted = true;
    _startMonster();
  }

  void _startMonster() {
    setState(() {
      _monsterHP = _currentMonster.maxHp;
      _questionInMonster = 0;
      _monsterDefeated = false;
      _isAnswering = false;
      _selectedOption = null;
      _wasCorrect = null;
    });

    _monsterEntryCtrl.forward(from: 0);

    if (_currentMonster.isBoss) {
      _bossGlowCtrl.repeat(reverse: true);
    } else {
      _bossGlowCtrl.stop();
      _bossGlowCtrl.reset();
    }

    // Giriş animasyonu bitince timer başlat
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && !_gameOver && !_victory) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timerCtrl.forward(from: 0);
  }

  void _onTimeUp() {
    if (_gameOver || _victory) return;
    // Süre dolduysa cevaplama durumunu zorla sıfırla
    _isAnswering = false;
    _onAnswer(-1); // Süre doldu = yanlış
  }

  // ══════════════════════════════════════════
  // ⚔️ CEVAP MANTIK
  // ══════════════════════════════════════════

  void _onAnswer(int optionIndex) {
    if (_isAnswering || _gameOver || _victory) return;
    _isAnswering = true;
    _timerCtrl.stop();

    final isCorrect =
        optionIndex >= 0 && optionIndex == _currentQuestion.correct;
    final timeElapsed = _timerCtrl.value;

    setState(() {
      _selectedOption = optionIndex;
      _wasCorrect = isCorrect;
      _totalAnswered++;
    });

    if (isCorrect) {
      _handleCorrect(timeElapsed);
    } else {
      _handleWrong();
    }
  }

  void _handleCorrect(double timeElapsed) {
    _correctCount++;
    _combo++;
    if (_combo > _maxCombo) _maxCombo = _combo;

    // Hasar hesapla
    int damage;
    bool isCritical = false;

    if (timeElapsed < 0.25) {
      damage = 40;
      isCritical = true;
      _criticalHits++;
    } else if (timeElapsed < 0.5) {
      damage = 30;
    } else {
      damage = 20;
    }

    // Kombo bonusu
    if (_combo >= 3) damage += 5;
    if (_combo >= 5) damage += 10;

    setState(() {
      _monsterHP = (_monsterHP - damage).clamp(0, 9999);
      _score += damage + (_combo * 2);
    });

    // Efektler
    _monsterShakeCtrl.forward(from: 0);
    _showDamagePopup('-$damage', isCritical ? Colors.amber : Colors.greenAccent);

    // 💥 Hit flash - canavar beyaz yanıp söner (belirgin)
    setState(() => _monsterHitFlash = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _monsterHitFlash = false);
    });

    if (isCritical) {
      setState(() => _showCritical = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _showCritical = false);
      });
    }

    _proceedAfterAnswer();
  }

  void _handleWrong() {
    _combo = 0;
    final damage = _currentMonster.attack;

    // ⚔️ Canavar saldırı animasyonu (öne atılır)
    _monsterAttackCtrl.forward(from: 0);

    setState(() {
      _playerHP = (_playerHP - damage).clamp(0, 100);
    });

    _flashCtrl.forward(from: 0);
    _showDamagePopup('-$damage', Colors.redAccent);

    if (_playerHP <= 0) {
      _stopAllAnimations();
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _gameOver = true);
      });
      return;
    }

    _proceedAfterAnswer();
  }

  void _showDamagePopup(String text, Color color) {
    setState(() {
      _damageText = text;
      _damageColor = color;
      _showDamageNum = true;
    });
    _damagePopCtrl.forward(from: 0).then((_) {
      if (mounted) setState(() => _showDamageNum = false);
    });
  }

  void _proceedAfterAnswer() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || _gameOver || _victory) return;

      if (_monsterHP <= 0) {
        // Canavar yenildi!
        _score += _currentMonster.isBoss ? 100 : 50;
        setState(() => _monsterDefeated = true);
        // Ölüm animasyonu: entry controller'ı ters çevir
        _monsterEntryCtrl.duration = const Duration(milliseconds: 600);
        _monsterEntryCtrl.reverse();

        Future.delayed(const Duration(milliseconds: 900), () {
          if (!mounted || _gameOver || _victory) return;
          // Duration'ı geri al
          _monsterEntryCtrl.duration = const Duration(milliseconds: 800);
          _nextMonster();
        });
      } else {
        _questionInMonster++;
        if (_questionInMonster >= _monsterQuestions[_currentMonsterIdx].length) {
          // Tüm sorular bitti, sonraki canavar
          _nextMonster();
        } else {
          setState(() {
            _isAnswering = false;
            _selectedOption = null;
            _wasCorrect = null;
          });
          _startTimer();
        }
      }
    });
  }

  void _nextMonster() {
    _currentMonsterIdx++;
    if (_currentMonsterIdx >= widget.level.monsters.length) {
      _stopAllAnimations();
      _awardPoints();
      setState(() => _victory = true);
    } else {
      _startMonster();
    }
  }

  void _stopAllAnimations() {
    _timerCtrl.stop();
    _bossGlowCtrl.stop();
    _idleCtrl.stop();
  }

  Future<void> _awardPoints() async {
    // Puan verilmiyor - hileye açık olduğu için devre dışı
  }

  void _restartGame() {
    setState(() {
      _currentMonsterIdx = 0;
      _playerHP = 100;
      _score = 0;
      _combo = 0;
      _maxCombo = 0;
      _correctCount = 0;
      _totalAnswered = 0;
      _criticalHits = 0;
      _gameOver = false;
      _victory = false;
      _monsterDefeated = false;
    });
    _initQuestions();
    _startMonster();
  }

  Color _getMonsterColor() {
    if (_currentMonster.isBoss) return const Color(0xFFFF1744);
    switch (_currentMonster.difficulty) {
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.cyanAccent;
      case 3:
        return Colors.orangeAccent;
      case 4:
        return Colors.redAccent;
      case 5:
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Savaştan Çıkılsın mı?',
            style: TextStyle(color: Colors.white)),
        content: const Text('İlerlemeniz kaybolacak.',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Devam Et',
                style: TextStyle(color: Colors.greenAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child:
                const Text('Çık', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _monsterShakeCtrl.dispose();
    _timerCtrl.dispose();
    _monsterEntryCtrl.dispose();
    _flashCtrl.dispose();
    _damagePopCtrl.dispose();
    _bossGlowCtrl.dispose();
    _idleCtrl.dispose();
    _monsterAttackCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════
  // 🖼️ BUILD
  // ══════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Arka plan
          _buildBackground(),

          // Ana oyun UI
          SafeArea(
            child: _gameOver
                ? _buildGameOver()
                : _victory
                    ? _buildVictory()
                    : _buildGameUI(),
          ),

          // Düşük HP kırmızı vignette
          if (_playerHP <= 25 && !_gameOver && !_victory)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        Colors.red.withOpacity(0.25),
                      ],
                      radius: 0.85,
                    ),
                  ),
                ),
              ),
            ),

          // Kırmızı flash overlay (hasar alınca)
          _buildFlashOverlay(),

          // Damage sayı popup
          if (_showDamageNum) _buildDamageNumber(),

          // KRİTİK vuruş yazısı
          if (_showCritical) _buildCriticalText(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D0D1A),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 🎮 ANA OYUN UI
  // ══════════════════════════════════════════

  Widget _buildGameUI() {
    return Column(
      children: [
        _buildTopBar(),
        const SizedBox(height: 4),
        Expanded(flex: 4, child: _buildMonsterArea()),
        _buildPlayerHP(),
        const SizedBox(height: 8),
        _buildTimerBar(),
        const SizedBox(height: 10),
        Expanded(flex: 5, child: _buildQuestionArea()),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── ÜST BAR ───
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Geri butonu
          GestureDetector(
            onTap: _showExitDialog,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),

          const SizedBox(width: 12),

          // Canavar sayacı
          Text(
            '${_currentMonsterIdx + 1}/${widget.level.monsters.length}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),

          const Spacer(),

          // Skor
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Kombo göstergesi
          if (_combo >= 2)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6D00), Color(0xFFFF1744)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 13)),
                  const SizedBox(width: 2),
                  Text(
                    'x$_combo',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ─── CANAVAR ALANI ───
  Widget _buildMonsterArea() {
    final color = _getMonsterColor();

    return AnimatedBuilder(
      animation: Listenable.merge([
        _monsterShakeCtrl,
        _monsterEntryCtrl,
        _bossGlowCtrl,
        _idleCtrl,
        _monsterAttackCtrl,
      ]),
      builder: (context, child) {
        final entryVal = _monsterEntryCtrl.value; // 0→1 giriş, 1→0 ölüm

        // ─── SCALE HESAPLA ───
        double scale;
        double rotation = 0.0;

        if (_monsterDefeated) {
          // Ölüm: controller reverse ediyor (1→0), doğrudan kullan
          scale = entryVal;
          rotation = (1.0 - entryVal) * pi * 2; // tam tur döner
        } else {
          // Giriş: elastic bounce
          scale = Curves.elasticOut.transform(entryVal.clamp(0.0, 1.0));
        }

        // 🫁 Idle bob - sürekli yukarı aşağı (nefes)
        final idlePhase = _idleCtrl.value * pi * 2;
        final idleY = sin(idlePhase) * 8;
        final idleScale = 1.0 + sin(idlePhase) * 0.03;

        // 💢 Shake - hasar verince yatay titreşim
        final shakeP = _monsterShakeCtrl.value;
        final shakeAmp = 18.0 * (1.0 - shakeP);
        final shakeX = sin(shakeP * pi * 8) * shakeAmp;

        // ⚔️ Saldırı lunge - yanlış cevapta aşağı atılır
        final atkP = _monsterAttackCtrl.value;
        final atkY = sin(atkP * pi) * 60;
        final atkScale = 1.0 + sin(atkP * pi) * 0.25;

        // 💥 Hit punch - vurunca kısa büyüme
        final hitScale = _monsterHitFlash ? 1.15 : 1.0;

        // ✨ Boss glow pulse
        final glowI =
            _currentMonster.isBoss ? 0.3 + (_bossGlowCtrl.value * 0.4) : 0.3;

        // ─── TOPLAM ───
        final totalScale = scale * idleScale * atkScale * hitScale;
        final totalX = shakeX;
        final totalY = idleY + atkY;

        return Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(totalX, totalY)
              ..rotateZ(rotation)
              ..scale(totalScale),
            child: Opacity(
              // Ölürken solma
              opacity: _monsterDefeated ? entryVal.clamp(0.0, 1.0) : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Canavar adı
                  Text(
                    _currentMonster.name,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            color: color.withOpacity(0.5), blurRadius: 10),
                      ],
                    ),
                  ),

                  // Boss etiketi
                  if (_currentMonster.isBoss)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.red.withOpacity(0.6)),
                      ),
                      child: const Text(
                        '💀 BOSS',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // 🔮 Canavar emoji + aura + gölge
                  Column(
                    children: [
                      // Emoji container - glow + hit flash
                      Container(
                        width: _currentMonster.isBoss ? 130 : 110,
                        height: _currentMonster.isBoss ? 130 : 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: _monsterHitFlash
                                ? [
                                    Colors.white.withOpacity(0.9),
                                    Colors.white.withOpacity(0.4),
                                    Colors.transparent,
                                  ]
                                : [
                                    color.withOpacity(glowI),
                                    color.withOpacity(glowI * 0.3),
                                    Colors.transparent,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _monsterHitFlash
                                  ? Colors.white.withOpacity(0.9)
                                  : color.withOpacity(glowI),
                              blurRadius:
                                  _monsterHitFlash ? 50 : (_currentMonster.isBoss ? 40 : 25),
                              spreadRadius:
                                  _monsterHitFlash ? 8 : (_currentMonster.isBoss ? 5 : 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentMonster.emoji,
                            style: TextStyle(
                                fontSize:
                                    _currentMonster.isBoss ? 60 : 50),
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 🌑 Gölge - canavarın altında oval
                      Container(
                        width: _currentMonster.isBoss ? 80 : 60,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Canavar HP bar
                  _buildMonsterHPBar(color),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonsterHPBar(Color color) {
    final hpPercent = (_monsterHP / _currentMonster.maxHp).clamp(0.0, 1.0);
    final isLow = hpPercent < 0.25;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('HP',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 10)),
              Text(
                '$_monsterHP / ${_currentMonster.maxHp}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 10,
                    width: constraints.maxWidth * hpPercent,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(isLow ? 0.8 : 0.4),
                          blurRadius: isLow ? 12 : 6,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── OYUNCU HP ───
  Widget _buildPlayerHP() {
    final hpPercent = (_playerHP / 100.0).clamp(0.0, 1.0);
    final hpColor = hpPercent > 0.5
        ? Colors.greenAccent
        : hpPercent > 0.25
            ? Colors.amber
            : Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text('❤️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 12,
                      width: constraints.maxWidth * hpPercent,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [hpColor, hpColor.withOpacity(0.5)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: hpColor.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$_playerHP',
            style: TextStyle(
              color: hpColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ─── ZAMANLAYICI BAR ───
  Widget _buildTimerBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _timerCtrl,
        builder: (context, child) {
          final remaining = (1.0 - _timerCtrl.value).clamp(0.0, 1.0);
          final color = remaining > 0.5
              ? Colors.greenAccent
              : remaining > 0.25
                  ? Colors.amber
                  : Colors.redAccent;
          final isUrgent = remaining < 0.25 && remaining > 0;

          return LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 6,
                    width: constraints.maxWidth * remaining,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: isUrgent
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.6),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ─── SORU ALANI ───
  Widget _buildQuestionArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Kategori etiketi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _currentQuestion.category.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Soru metni
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _currentQuestion.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cevap butonları 2x2
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildOptionButton(0)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildOptionButton(1)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildOptionButton(2)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildOptionButton(3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    if (index >= _currentQuestion.options.length) {
      return const SizedBox.shrink();
    }

    final labels = ['A', 'B', 'C', 'D'];
    final text = _currentQuestion.options[index];
    final isSelected = _selectedOption == index;
    final isCorrect = index == _currentQuestion.correct;
    final showResult = _selectedOption != null;

    Color bgColor;
    Color borderColor;

    if (showResult) {
      if (isCorrect) {
        bgColor = Colors.greenAccent.withOpacity(0.15);
        borderColor = Colors.greenAccent;
      } else if (isSelected) {
        bgColor = Colors.redAccent.withOpacity(0.15);
        borderColor = Colors.redAccent;
      } else {
        bgColor = Colors.white.withOpacity(0.03);
        borderColor = Colors.white.withOpacity(0.06);
      }
    } else {
      bgColor = Colors.white.withOpacity(0.06);
      borderColor = Colors.white.withOpacity(0.15);
    }

    return GestureDetector(
      onTap: _isAnswering ? null : () => _onAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: showResult && isCorrect
              ? [
                  BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.3),
                      blurRadius: 12),
                ]
              : showResult && isSelected && !isCorrect
                  ? [
                      BoxShadow(
                          color: Colors.redAccent.withOpacity(0.3),
                          blurRadius: 12),
                    ]
                  : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Harf etiketi
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Cevap metni
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // İkon
              if (showResult && isCorrect)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.check_circle,
                      color: Colors.greenAccent, size: 20),
                ),
              if (showResult && isSelected && !isCorrect)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child:
                      Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // ✨ OVERLAY EFEKTLER
  // ══════════════════════════════════════════

  /// Kırmızı flash - hasar alınca
  Widget _buildFlashOverlay() {
    return AnimatedBuilder(
      animation: _flashCtrl,
      builder: (context, child) {
        final opacity = (1.0 - _flashCtrl.value) * 0.4;
        if (opacity <= 0.01) return const SizedBox.shrink();
        return Positioned.fill(
          child: IgnorePointer(
            child: Container(color: Colors.red.withOpacity(opacity)),
          ),
        );
      },
    );
  }

  /// Hasar sayısı yukarı uçar
  Widget _buildDamageNumber() {
    return AnimatedBuilder(
      animation: _damagePopCtrl,
      builder: (context, child) {
        final progress = _damagePopCtrl.value;
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.22 - (progress * 60),
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: (1.0 - progress).clamp(0.0, 1.0),
                child: Text(
                  _damageText,
                  style: TextStyle(
                    color: _damageColor,
                    fontSize: 34 + (progress * 10),
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: _damageColor.withOpacity(0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// KRİTİK vuruş yazısı
  Widget _buildCriticalText() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: 1.2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: const Text(
                  '⚡ KRİTİK! ⚡',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(color: Color(0xCCFFD700), blurRadius: 30),
                      Shadow(color: Color(0x99FF8C00), blurRadius: 60),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 🏆 ZAFER & 💀 YENİLGİ EKRANLARI
  // ══════════════════════════════════════════

  Widget _buildVictory() {
    final accuracy =
        _totalAnswered > 0 ? (_correctCount / _totalAnswered * 100).toInt() : 0;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kupa animasyonu
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Text('🏆', style: TextStyle(fontSize: 80)),
                );
              },
            ),

            const SizedBox(height: 20),

            // ZAFER yazısı - parlak gradient
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFF8C00),
                  Color(0xFFFFD700)
                ],
              ).createShader(bounds),
              child: const Text(
                'ZAFER!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              '${widget.level.levelName} tamamlandı!',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 14),
            ),

            const SizedBox(height: 30),

            // İstatistikler
            _buildStatBox([
              _StatItem('Puan', '$_score', Colors.amber),
              _StatItem('Doğru', '$_correctCount / $_totalAnswered', Colors.greenAccent),
              _StatItem('Başarı', '%$accuracy', accuracy >= 70 ? Colors.greenAccent : Colors.orangeAccent),
              _StatItem('Max Kombo', 'x$_maxCombo', Colors.orange),
              _StatItem('Kritik Vuruş', '$_criticalHits', Colors.amber),
            ]),

            const SizedBox(height: 30),

            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEndButton(
                    'Ana Menü', Colors.grey, () => Navigator.pop(context)),
                const SizedBox(width: 16),
                _buildEndButton('Tekrar Oyna', Colors.amber, _restartGame),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kafatası animasyonu
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.bounceOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Text('💀', style: TextStyle(fontSize: 80)),
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'YENİLDİN!',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                shadows: [
                  Shadow(color: Color(0x80FF1744), blurRadius: 20),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              '${_currentMonster.name} seni yendi...',
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),

            const SizedBox(height: 30),

            // İstatistikler
            _buildStatBox([
              _StatItem('Puan', '$_score', Colors.amber),
              _StatItem('Doğru', '$_correctCount / $_totalAnswered', Colors.greenAccent),
              _StatItem('Max Kombo', 'x$_maxCombo', Colors.orange),
              _StatItem('Kritik Vuruş', '$_criticalHits', Colors.amber),
            ]),

            const SizedBox(height: 30),

            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEndButton(
                    'Ana Menü', Colors.grey, () => Navigator.pop(context)),
                const SizedBox(width: 16),
                _buildEndButton('Tekrar Dene', Colors.redAccent, _restartGame),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════
  // 🔧 YARDIMCI WİDGETLAR
  // ══════════════════════════════════════════

  Widget _buildStatBox(List<_StatItem> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        item.value,
                        style: TextStyle(
                          color: item.color,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildEndButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

/// İstatistik satırı veri sınıfı
class _StatItem {
  final String label;
  final String value;
  final Color color;
  const _StatItem(this.label, this.value, this.color);
}
