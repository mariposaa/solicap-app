/// SOLICAP - Challenge VS Screen
/// VS animasyonu ve oyuna başlama ekranı

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge_model.dart';
import '../models/challenge_question_model.dart';
import 'challenge_game_screen.dart';

class ChallengeVsScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeVsScreen({super.key, required this.challenge});

  @override
  State<ChallengeVsScreen> createState() => _ChallengeVsScreenState();
}

class _ChallengeVsScreenState extends State<ChallengeVsScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _vsController;
  late AnimationController _player1Controller;
  late AnimationController _player2Controller;
  late AnimationController _countdownController;
  late AnimationController _pulseController;
  
  late Animation<double> _vsScale;
  late Animation<Offset> _player1Slide;
  late Animation<Offset> _player2Slide;
  late Animation<double> _pulseAnimation;
  
  int _countdown = 3;
  bool _showCountdown = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimationSequence();
  }

  void _setupAnimations() {
    // VS animasyonu
    _vsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _vsScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _vsController, curve: Curves.elasticOut),
    );

    // Player 1 (soldan gelir)
    _player1Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _player1Slide = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _player1Controller,
      curve: Curves.easeOutBack,
    ));

    // Player 2 (sağdan gelir)
    _player2Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _player2Slide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _player2Controller,
      curve: Curves.easeOutBack,
    ));

    // Countdown
    _countdownController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Pulse animasyonu (VS glow için)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _startAnimationSequence() async {
    // 1. Oyuncular kayarak gelir
    await Future.delayed(const Duration(milliseconds: 300));
    _player1Controller.forward();
    _player2Controller.forward();

    // 2. VS ortada belirir
    await Future.delayed(const Duration(milliseconds: 500));
    _vsController.forward();

    // 3. Geri sayım başlar
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _showCountdown = true);
    
    for (int i = 3; i >= 1; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }

    // 4. Oyun ekranına geç
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChallengeGameScreen(challenge: widget.challenge),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _vsController.dispose();
    _player1Controller.dispose();
    _player2Controller.dispose();
    _countdownController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    final player1 = challenge.player1;
    final player2 = challenge.player2;
    final categoryIcon = ChallengeCategories.getIcon(challenge.category);
    final categoryName = ChallengeCategories.getDisplayName(challenge.category);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // Arka plan gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Işık efektleri
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.red.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Kategori bilgisi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(categoryIcon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        categoryName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // VS Bölümü
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Player 1
                    SlideTransition(
                      position: _player1Slide,
                      child: _buildPlayerCard(
                        name: player1.displayName,
                        color: Colors.blue,
                        isLeft: true,
                      ),
                    ),

                    // VS
                    ScaleTransition(
                      scale: _vsScale,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow efekti (animasyonlu)
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Container(
                                  width: 80 + (_pulseAnimation.value * 20),
                                  height: 80 + (_pulseAnimation.value * 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(_pulseAnimation.value),
                                        blurRadius: 30 + (_pulseAnimation.value * 20),
                                        spreadRadius: 10 + (_pulseAnimation.value * 10),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // Statik iç glow
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            // VS text
                            const Text(
                              'VS',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Player 2
                    SlideTransition(
                      position: _player2Slide,
                      child: _buildPlayerCard(
                        name: player2?.displayName ?? 'Rakip Bekleniyor',
                        color: Colors.red,
                        isLeft: false,
                        isWaiting: player2 == null,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Geri sayım
                if (_showCountdown)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade400,
                            Colors.orange.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$_countdown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 120),

                const SizedBox(height: 60),

                // Alt bilgi
                Text(
                  '10 Soru • 15 Saniye/Soru',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required Color color,
    required bool isLeft,
    bool isWaiting = false,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: isWaiting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          // İsim
          Text(
            name.length > 12 ? '${name.substring(0, 10)}...' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isWaiting) ...[
            const SizedBox(height: 4),
            Text(
              isLeft ? 'Sen' : 'Rakip',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
