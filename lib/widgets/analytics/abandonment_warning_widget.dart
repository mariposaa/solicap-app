/// SOLICAP - Abandonment Warning Widget
/// Öğrencinin nerede vazgeçtiğini analiz edip uyarı gösterir

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user_dna_model.dart';

class AbandonmentWarningWidget extends StatefulWidget {
  final List<AbandonmentPoint> abandonmentPoints;
  final double similarQuestionCompletionRate;

  const AbandonmentWarningWidget({
    super.key,
    required this.abandonmentPoints,
    this.similarQuestionCompletionRate = 0,
  });

  @override
  State<AbandonmentWarningWidget> createState() =>
      _AbandonmentWarningWidgetState();
}

class _AbandonmentWarningWidgetState extends State<AbandonmentWarningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
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
    final pattern = _analyzeAbandonmentPattern();

    if (pattern == null && widget.abandonmentPoints.isEmpty) {
      return const SizedBox.shrink(); // Veri yoksa gösterme
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(
              _shakeAnimation.value < 0.5
                  ? (0.5 - _shakeAnimation.value) * 10 * (_shakeAnimation.value % 2 == 0 ? 1 : -1)
                  : 0,
              0,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFEF4444).withOpacity(0.1),
                    AppTheme.warningColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withOpacity(0.1),
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
                          color: const Color(0xFFEF4444).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFEF4444),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bırakma Uyarısı',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Davranış analizi',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('⚡', style: TextStyle(fontSize: 28)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Main insight card
                  if (pattern != null) _buildMainInsight(pattern),

                  const SizedBox(height: 16),

                  // Stats row
                  _buildStatsRow(),

                  const SizedBox(height: 16),

                  // Recent abandonment points
                  if (widget.abandonmentPoints.isNotEmpty) ...[
                    const Text(
                      'Son Bırakma Noktaları:',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.abandonmentPoints.take(3).map(
                          (point) => _buildAbandonmentItem(point),
                        ),
                  ],

                  const SizedBox(height: 12),

                  // Tip
                  _buildTip(pattern),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainInsight(AbandonmentPattern pattern) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                pattern.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pattern.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pattern.description,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (pattern.avgQuestionBeforeAbandon > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.trending_down,
                  color: const Color(0xFFEF4444),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Genellikle ${pattern.avgQuestionBeforeAbandon}. soruda bırakıyorsun',
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final completionPercent = (widget.similarQuestionCompletionRate * 100).toInt();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.psychology,
            value: '${widget.abandonmentPoints.length}',
            label: 'Toplam Bırakma',
            color: const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            value: '%$completionPercent',
            label: 'Tamamlama',
            color: completionPercent >= 70
                ? AppTheme.successColor
                : AppTheme.warningColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbandonmentItem(AbandonmentPoint point) {
    final stageEmoji = _getStageEmoji(point.stage);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(stageEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${point.topic} - ${point.subTopic}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getStageLabel(point.stage),
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${point.questionIndex}. soru',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(AbandonmentPattern? pattern) {
    final tip = pattern?.tip ?? 'Zorluklarda pes etme, her adım seni güçlendirir!';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AbandonmentPattern? _analyzeAbandonmentPattern() {
    if (widget.abandonmentPoints.isEmpty) return null;

    // Stage'lere göre grupla
    final Map<String, int> stageCounts = {};
    int totalQuestionIndex = 0;

    for (final point in widget.abandonmentPoints) {
      stageCounts[point.stage] = (stageCounts[point.stage] ?? 0) + 1;
      totalQuestionIndex += point.questionIndex;
    }

    // En sık bırakılan stage'i bul
    String dominantStage = 'genel';
    int maxCount = 0;
    stageCounts.forEach((stage, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantStage = stage;
      }
    });

    final avgQuestion = widget.abandonmentPoints.isNotEmpty
        ? (totalQuestionIndex / widget.abandonmentPoints.length).round()
        : 0;

    // Pattern türüne göre mesaj oluştur
    switch (dominantStage) {
      case 'soru_cozum':
        return AbandonmentPattern(
          emoji: '🤯',
          title: 'Soru Çözümünde Zorlanıyorsun',
          description:
              'Sorular zorlaştığında vazgeçme eğilimin var.',
          avgQuestionBeforeAbandon: avgQuestion,
          tip: 'Zorlandığında hemen ipucu al, baştan bırakma!',
        );
      case 'benzer_soru':
        return AbandonmentPattern(
          emoji: '😴',
          title: 'Pratik Sıkıcı Geliyor',
          description:
              'Benzer soru pratiklerinde çabuk sıkılıyorsun.',
          avgQuestionBeforeAbandon: avgQuestion,
          tip: 'Pratikleri 5\'er soru halinde böl, araya mola koy.',
        );
      case 'analiz':
        return AbandonmentPattern(
          emoji: '⏱️',
          title: 'Analiz Sabırsızlığı',
          description:
              'Detaylı analizleri okumadan atlıyorsun.',
          avgQuestionBeforeAbandon: 0,
          tip: 'Analizler seni güçlendirir, 2 dakika ayır!',
        );
      default:
        return AbandonmentPattern(
          emoji: '⚡',
          title: 'Genel Vazgeçme Eğilimi',
          description:
              'Çeşitli noktalarda çalışmayı bırakıyorsun.',
          avgQuestionBeforeAbandon: avgQuestion,
          tip: 'Her çalışmaya "3 soru bitireceğim" hedefiyle başla.',
        );
    }
  }

  String _getStageEmoji(String stage) {
    switch (stage) {
      case 'soru_cozum':
        return '📝';
      case 'benzer_soru':
        return '🔄';
      case 'analiz':
        return '📊';
      default:
        return '📚';
    }
  }

  String _getStageLabel(String stage) {
    switch (stage) {
      case 'soru_cozum':
        return 'Soru çözümünde';
      case 'benzer_soru':
        return 'Benzer soru pratiğinde';
      case 'analiz':
        return 'Analiz ekranında';
      default:
        return 'Çalışma sırasında';
    }
  }
}

/// Abandonment pattern model
class AbandonmentPattern {
  final String emoji;
  final String title;
  final String description;
  final int avgQuestionBeforeAbandon;
  final String tip;

  AbandonmentPattern({
    required this.emoji,
    required this.title,
    required this.description,
    required this.avgQuestionBeforeAbandon,
    required this.tip,
  });
}
