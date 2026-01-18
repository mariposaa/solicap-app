/// SOLICAP - Knowledge Decay Widget
/// Ebbinghaus unutma eğrisine göre hangi konuların unutulmaya başladığını gösterir

import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user_dna_model.dart';

class KnowledgeDecayWidget extends StatefulWidget {
  final Map<String, SubTopicPerformance> subTopicPerformance;
  final VoidCallback? onRefreshTopic;

  const KnowledgeDecayWidget({
    super.key,
    required this.subTopicPerformance,
    this.onRefreshTopic,
  });

  @override
  State<KnowledgeDecayWidget> createState() => _KnowledgeDecayWidgetState();
}

class _KnowledgeDecayWidgetState extends State<KnowledgeDecayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decayingTopics = _calculateDecayingTopics();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.warningColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.warningColor.withOpacity(0.2),
                            const Color(0xFFEF4444).withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.hourglass_bottom_rounded,
                        color: AppTheme.warningColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bilgi Tazeliği',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Unutmaya başladığın konular',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Decay info badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${decayingTopics.length} konu',
                        style: const TextStyle(
                          color: AppTheme.warningColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (decayingTopics.isEmpty)
                  _buildEmptyState()
                else
                  ...decayingTopics.take(5).map((topic) => _buildDecayItem(topic)),

                if (decayingTopics.length > 5) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      '+ ${decayingTopics.length - 5} konu daha',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppTheme.successColor.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tebrikler! 🎉',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tüm konuların taze görünüyor',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecayItem(DecayingTopic topic) {
    final urgencyColor = _getUrgencyColor(topic.decayLevel);
    final urgencyEmoji = _getUrgencyEmoji(topic.decayLevel);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: topic.retentionPercent / 100),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: urgencyColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: urgencyColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(urgencyEmoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.subTopic,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          topic.parentTopic,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: urgencyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${topic.retentionPercent.toInt()}%',
                      style: TextStyle(
                        color: urgencyColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress bar
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 6,
                    width: MediaQuery.of(context).size.width * 0.6 * value,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          urgencyColor,
                          urgencyColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${topic.daysSinceLastStudy} gün önce çalışıldı',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  if (topic.decayLevel >= 2)
                    GestureDetector(
                      onTap: widget.onRefreshTopic,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: urgencyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Tekrar Et',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<DecayingTopic> _calculateDecayingTopics() {
    final List<DecayingTopic> decaying = [];
    final now = DateTime.now();

    for (final entry in widget.subTopicPerformance.entries) {
      final perf = entry.value;
      final daysSince = now.difference(perf.lastUpdate).inDays;

      // 3 günden fazla çalışılmamış konuları dahil et
      if (daysSince >= 3) {
        // Ebbinghaus forgetting curve: R = e^(-t/S)
        // t = days, S = stability (based on proficiency)
        final stability = 5 + (perf.weightedProficiency * 15); // 5-20 days
        final retention = exp(-daysSince / stability) * 100;

        decaying.add(DecayingTopic(
          parentTopic: perf.parentTopic,
          subTopic: perf.subTopic,
          daysSinceLastStudy: daysSince,
          retentionPercent: retention.clamp(0, 100),
          decayLevel: _calculateDecayLevel(retention),
        ));
      }
    }

    // En düşük retention'a göre sırala
    decaying.sort((a, b) => a.retentionPercent.compareTo(b.retentionPercent));

    return decaying;
  }

  int _calculateDecayLevel(double retention) {
    if (retention >= 70) return 0; // Taze
    if (retention >= 50) return 1; // Hafif unutma
    if (retention >= 30) return 2; // Orta unutma
    return 3; // Kritik unutma
  }

  Color _getUrgencyColor(int level) {
    switch (level) {
      case 0:
        return AppTheme.successColor;
      case 1:
        return AppTheme.warningColor;
      case 2:
        return const Color(0xFFF97316); // Orange
      case 3:
        return const Color(0xFFEF4444); // Red
      default:
        return AppTheme.textMuted;
    }
  }

  String _getUrgencyEmoji(int level) {
    switch (level) {
      case 0:
        return '✅';
      case 1:
        return '⚠️';
      case 2:
        return '🔶';
      case 3:
        return '🆘';
      default:
        return '📚';
    }
  }
}

/// Decaying topic model
class DecayingTopic {
  final String parentTopic;
  final String subTopic;
  final int daysSinceLastStudy;
  final double retentionPercent;
  final int decayLevel; // 0-3

  DecayingTopic({
    required this.parentTopic,
    required this.subTopic,
    required this.daysSinceLastStudy,
    required this.retentionPercent,
    required this.decayLevel,
  });
}
