/// SOLICAP - Streak Celebration Widget
/// Öğrencinin günlük çalışma serisini kutlayan animasyonlu widget

import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StreakCelebrationWidget extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final int thisWeekQuestions;

  const StreakCelebrationWidget({
    super.key,
    required this.currentStreak,
    this.longestStreak = 0,
    this.thisWeekQuestions = 0,
  });

  @override
  State<StreakCelebrationWidget> createState() => _StreakCelebrationWidgetState();
}

class _StreakCelebrationWidgetState extends State<StreakCelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Pulse animation for flame
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Confetti animation
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _confettiController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    // Generate confetti particles for streak >= 7
    if (widget.currentStreak >= 7) {
      _generateConfetti();
      _confettiController.forward();
    } else {
      _confettiController.value = 1.0; // Skip animation
    }
  }

  void _generateConfetti() {
    for (int i = 0; i < 30; i++) {
      _particles.add(ConfettiParticle(
        color: _getRandomColor(),
        x: _random.nextDouble(),
        y: _random.nextDouble() * 0.5,
        size: 4 + _random.nextDouble() * 6,
        velocity: 0.5 + _random.nextDouble() * 1.5,
        angle: _random.nextDouble() * pi * 2,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.successColor,
      AppTheme.warningColor,
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFF14B8A6), // Teal
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentStreak == 0) {
      return _buildNoStreakState();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _confettiController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: _getStreakGradient(),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _getStreakColor().withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Confetti particles
                if (widget.currentStreak >= 7)
                  ..._particles.map((p) => _buildConfettiParticle(p)),

                // Main content
                Column(
                  children: [
                    // Streak flame with pulse
                    Transform.scale(
                      scale: _pulseAnimation.value,
                      child: _buildStreakFlame(),
                    ),

                    const SizedBox(height: 16),

                    // Streak count
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: widget.currentStreak),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          '$value GÜN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 4),

                    // Title with badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getStreakTitle(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.currentStreak >= 7) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '⭐ MASTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMiniStat(
                          icon: Icons.emoji_events,
                          value: '${widget.longestStreak}',
                          label: 'En Uzun',
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        _buildMiniStat(
                          icon: Icons.quiz,
                          value: '${widget.thisWeekQuestions}',
                          label: 'Bu Hafta',
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Motivational message
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getMotivationalMessage(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoStreakState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_fire_department_outlined,
            size: 48,
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Seriye Başla!',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bugün bir soru çöz ve\nserine başla 🔥',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakFlame() {
    final size = widget.currentStreak >= 7 ? 80.0 : 60.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Text(
          '🔥',
          style: TextStyle(fontSize: size * 0.7),
        ),
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiParticle(ConfettiParticle particle) {
    final progress = _confettiController.value;
    final y = particle.y + (progress * particle.velocity);
    final opacity = (1 - progress).clamp(0.0, 1.0);

    return Positioned(
      left: particle.x * 280,
      top: y * 200,
      child: Transform.rotate(
        angle: particle.angle + (progress * pi),
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: particle.size,
            height: particle.size,
            decoration: BoxDecoration(
              color: particle.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getStreakGradient() {
    if (widget.currentStreak >= 7) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFEF4444), // Red
          Color(0xFFF97316), // Orange
          Color(0xFFEAB308), // Yellow
        ],
      );
    } else if (widget.currentStreak >= 3) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.warningColor,
          AppTheme.warningColor.withRed(255),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryColor,
          AppTheme.accentColor,
        ],
      );
    }
  }

  Color _getStreakColor() {
    if (widget.currentStreak >= 7) return const Color(0xFFEF4444);
    if (widget.currentStreak >= 3) return AppTheme.warningColor;
    return AppTheme.primaryColor;
  }

  String _getStreakTitle() {
    if (widget.currentStreak >= 30) return 'EFSANE SERİ';
    if (widget.currentStreak >= 14) return 'ŞAMPİYON SERİ';
    if (widget.currentStreak >= 7) return 'STREAK MASTER';
    if (widget.currentStreak >= 3) return 'Harika Gidiyorsun!';
    return 'İyi Başlangıç!';
  }

  String _getMotivationalMessage() {
    if (widget.currentStreak >= 14) {
      return '🏆 2 haftadır düzenli çalışıyorsun! Efsanesin!';
    } else if (widget.currentStreak >= 7) {
      return '⭐ 1 haftayı geçtin! Bu disiplini koru!';
    } else if (widget.currentStreak >= 3) {
      return '💪 3 gün üstüste! Ritmi kaybetme!';
    } else {
      return '🚀 Her gün çalışmaya devam et!';
    }
  }
}

/// Confetti particle model
class ConfettiParticle {
  final Color color;
  final double x;
  final double y;
  final double size;
  final double velocity;
  final double angle;

  ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
    required this.velocity,
    required this.angle,
  });
}
