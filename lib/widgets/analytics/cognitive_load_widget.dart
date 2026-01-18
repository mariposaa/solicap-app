/// SOLICAP - Cognitive Load Meter Widget
/// Öğrencinin bilişsel yükünü gösteren gauge widget

import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/question_session_model.dart';

class CognitiveLoadWidget extends StatefulWidget {
  final CognitiveLoadLevel? currentLoad;
  final int recentHintsUsed;
  final int recentWrongAnswers;
  final double averageTimePerQuestion; // seconds

  const CognitiveLoadWidget({
    super.key,
    this.currentLoad,
    this.recentHintsUsed = 0,
    this.recentWrongAnswers = 0,
    this.averageTimePerQuestion = 0,
  });

  @override
  State<CognitiveLoadWidget> createState() => _CognitiveLoadWidgetState();
}

class _CognitiveLoadWidgetState extends State<CognitiveLoadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gaugeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _gaugeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();

    // Repeat pulse for high/overload
    if (widget.currentLoad == CognitiveLoadLevel.high ||
        widget.currentLoad == CognitiveLoadLevel.overload) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _loadValue {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return 0.25;
      case CognitiveLoadLevel.medium:
        return 0.5;
      case CognitiveLoadLevel.high:
        return 0.75;
      case CognitiveLoadLevel.overload:
        return 0.95;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.currentLoad == CognitiveLoadLevel.overload
              ? _pulseAnimation.value
              : 1.0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getLoadColor().withOpacity(0.3),
                width: widget.currentLoad == CognitiveLoadLevel.overload ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getLoadColor().withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getLoadColor().withOpacity(0.2),
                            _getLoadColor().withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        color: _getLoadColor(),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beyin Durumu',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Bilişsel yük seviyesi',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _getLoadEmoji(),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Gauge
                SizedBox(
                  height: 120,
                  child: CustomPaint(
                    size: const Size(200, 120),
                    painter: _GaugePainter(
                      value: _loadValue * _gaugeAnimation.value,
                      color: _getLoadColor(),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: 0,
                                end: (_loadValue * 100).toInt(),
                              ),
                              duration: const Duration(milliseconds: 1500),
                              builder: (context, value, child) {
                                return Text(
                                  '$value%',
                                  style: TextStyle(
                                    color: _getLoadColor(),
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            Text(
                              _getLoadLabel(),
                              style: TextStyle(
                                color: _getLoadColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMiniStat(
                      icon: Icons.lightbulb_outline,
                      value: '${widget.recentHintsUsed}',
                      label: 'İpucu',
                      color: AppTheme.warningColor,
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: AppTheme.dividerColor,
                    ),
                    _buildMiniStat(
                      icon: Icons.close,
                      value: '${widget.recentWrongAnswers}',
                      label: 'Yanlış',
                      color: const Color(0xFFEF4444),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: AppTheme.dividerColor,
                    ),
                    _buildMiniStat(
                      icon: Icons.timer_outlined,
                      value: '${widget.averageTimePerQuestion.toInt()}s',
                      label: 'Ort. Süre',
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Recommendation
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getLoadColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getLoadColor().withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRecommendationIcon(),
                        color: _getLoadColor(),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _getRecommendation(),
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Color _getLoadColor() {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return AppTheme.successColor;
      case CognitiveLoadLevel.medium:
        return AppTheme.primaryColor;
      case CognitiveLoadLevel.high:
        return AppTheme.warningColor;
      case CognitiveLoadLevel.overload:
        return const Color(0xFFEF4444);
      default:
        return AppTheme.textMuted;
    }
  }

  String _getLoadLabel() {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return 'Rahat';
      case CognitiveLoadLevel.medium:
        return 'Normal';
      case CognitiveLoadLevel.high:
        return 'Yorgun';
      case CognitiveLoadLevel.overload:
        return 'Aşırı Yük';
      default:
        return 'Bilinmiyor';
    }
  }

  String _getLoadEmoji() {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return '😊';
      case CognitiveLoadLevel.medium:
        return '🤔';
      case CognitiveLoadLevel.high:
        return '😓';
      case CognitiveLoadLevel.overload:
        return '🤯';
      default:
        return '🧠';
    }
  }

  String _getRecommendation() {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return 'Harika! Zorlu sorulara geçebilirsin.';
      case CognitiveLoadLevel.medium:
        return 'İyi gidiyorsun, tempoyu koru.';
      case CognitiveLoadLevel.high:
        return 'Biraz dinlenebilirsin. 5 dk mola öneriyorum.';
      case CognitiveLoadLevel.overload:
        return '⚠️ Mola zamanı! Beynin yoruldu, 10-15 dk dinlen.';
      default:
        return 'Birkaç soru çöz, seni analiz edeyim.';
    }
  }

  IconData _getRecommendationIcon() {
    switch (widget.currentLoad) {
      case CognitiveLoadLevel.low:
        return Icons.rocket_launch;
      case CognitiveLoadLevel.medium:
        return Icons.thumb_up;
      case CognitiveLoadLevel.high:
        return Icons.coffee;
      case CognitiveLoadLevel.overload:
        return Icons.bed;
      default:
        return Icons.info_outline;
    }
  }
}

/// Custom gauge painter
class _GaugePainter extends CustomPainter {
  final double value; // 0-1
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    // Background arc
    final bgPaint = Paint()
      ..color = AppTheme.surfaceColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      bgPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: pi,
        endAngle: 2 * pi,
        colors: [
          AppTheme.successColor,
          AppTheme.warningColor,
          const Color(0xFFEF4444),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * value,
      false,
      valuePaint,
    );

    // Indicator dot
    final angle = pi + (pi * value);
    final dotX = center.dx + radius * cos(angle);
    final dotY = center.dy + radius * sin(angle);

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotShadow = Paint()
      ..color = color.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(dotX, dotY), 8, dotShadow);
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
    
    final innerDotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(dotX, dotY), 4, innerDotPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
