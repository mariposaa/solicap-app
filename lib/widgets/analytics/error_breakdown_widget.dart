/// SOLICAP - Error Breakdown Widget
/// Öğrencinin hata türlerini animasyonlu pie chart ile gösterir

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/user_dna_model.dart';

class ErrorBreakdownWidget extends StatefulWidget {
  final Map<String, int> errorPatterns;
  final List<WeakTopic> weakTopics;

  const ErrorBreakdownWidget({
    super.key,
    required this.errorPatterns,
    required this.weakTopics,
  });

  @override
  State<ErrorBreakdownWidget> createState() => _ErrorBreakdownWidgetState();
}

class _ErrorBreakdownWidgetState extends State<ErrorBreakdownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
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
    final chartData = _prepareChartData();

    if (chartData.isEmpty) {
      return _buildEmptyState();
    }

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
                        Icons.pie_chart_rounded,
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
                            'Hata Analizi',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Hatalarının kök nedenleri',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Pie Chart
                SizedBox(
                  height: 220,
                  child: Row(
                    children: [
                      // Pie Chart
                      Expanded(
                        flex: 3,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159 / 180 * 0,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (event, response) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        response == null ||
                                        response.touchedSection == null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex = response
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 3,
                              centerSpaceRadius: 40,
                              sections: _buildPieSections(chartData),
                            ),
                          ),
                        ),
                      ),
                      // Legend
                      Expanded(
                        flex: 2,
                        child: _buildLegend(chartData),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Dominant Error Insight
                _buildInsightCard(chartData),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildPieSections(List<ErrorDataPoint> data) {
    final total = data.fold(0, (sum, e) => sum + e.count);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      final isTouched = index == _touchedIndex;
      final percentage = total > 0 ? (point.count / total * 100) : 0.0;
      final radius = isTouched ? 70.0 : 60.0;

      return PieChartSectionData(
        color: point.color,
        value: point.count.toDouble(),
        title: isTouched ? '%${percentage.toInt()}' : '',
        radius: radius * _animationController.value.clamp(0.3, 1.0),
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: point.color.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  point.emoji,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  Widget _buildLegend(List<ErrorDataPoint> data) {
    final total = data.fold(0, (sum, e) => sum + e.count);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((point) {
        final percentage = total > 0 ? (point.count / total * 100).toInt() : 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: point.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  point.label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '%$percentage',
                style: TextStyle(
                  color: point.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInsightCard(List<ErrorDataPoint> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    // En yüksek hatayı bul
    data.sort((a, b) => b.count.compareTo(a.count));
    final dominant = data.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            dominant.color.withOpacity(0.15),
            dominant.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dominant.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            dominant.emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'En büyük zorluk: ${dominant.label}',
                  style: TextStyle(
                    color: dominant.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getAdviceForError(dominant.type),
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: AppTheme.successColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hata Analizi',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Harika! Henüz kayıtlı hata yok.\nÇözdüğün sorularda hata yaparsan\nburada analiz edeceğiz.',
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

  List<ErrorDataPoint> _prepareChartData() {
    final List<ErrorDataPoint> data = [];

    // Error patterns'den veri çek
    if (widget.errorPatterns.isNotEmpty) {
      for (final entry in widget.errorPatterns.entries) {
        data.add(ErrorDataPoint(
          type: entry.key,
          label: _getErrorLabel(entry.key),
          emoji: _getErrorEmoji(entry.key),
          color: _getErrorColor(entry.key),
          count: entry.value,
        ));
      }
    }
    // Error patterns boşsa weak topics'ten sebep çıkar
    else if (widget.weakTopics.isNotEmpty) {
      final Map<String, int> reasonCounts = {};
      for (final topic in widget.weakTopics) {
        final reason = topic.reason.isNotEmpty ? topic.reason : 'konu_eksigi';
        reasonCounts[reason] = (reasonCounts[reason] ?? 0) + 1;
      }

      for (final entry in reasonCounts.entries) {
        data.add(ErrorDataPoint(
          type: entry.key,
          label: _getErrorLabel(entry.key),
          emoji: _getErrorEmoji(entry.key),
          color: _getErrorColor(entry.key),
          count: entry.value,
        ));
      }
    }

    // Sayıya göre sırala
    data.sort((a, b) => b.count.compareTo(a.count));
    return data.take(5).toList(); // Max 5 kategori
  }

  String _getErrorLabel(String type) {
    switch (type) {
      case 'konu_eksigi':
        return 'Konu Eksikliği';
      case 'dikkatsizlik':
        return 'Dikkatsizlik';
      case 'zaman_yetersiz':
        return 'Zaman Sorunu';
      case 'anlama_sorunu':
        return 'Anlama Sorunu';
      case 'hesaplama_hatasi':
        return 'Hesaplama Hatası';
      case 'kavram_eksik':
        return 'Kavram Eksikliği';
      default:
        return type;
    }
  }

  String _getErrorEmoji(String type) {
    switch (type) {
      case 'konu_eksigi':
        return '📚';
      case 'dikkatsizlik':
        return '👀';
      case 'zaman_yetersiz':
        return '⏰';
      case 'anlama_sorunu':
        return '🤔';
      case 'hesaplama_hatasi':
        return '🔢';
      case 'kavram_eksik':
        return '💡';
      default:
        return '❓';
    }
  }

  Color _getErrorColor(String type) {
    switch (type) {
      case 'konu_eksigi':
        return const Color(0xFFEF4444); // Red
      case 'dikkatsizlik':
        return AppTheme.warningColor; // Amber
      case 'zaman_yetersiz':
        return const Color(0xFF8B5CF6); // Purple
      case 'anlama_sorunu':
        return const Color(0xFF3B82F6); // Blue
      case 'hesaplama_hatasi':
        return const Color(0xFFEC4899); // Pink
      case 'kavram_eksik':
        return const Color(0xFF14B8A6); // Teal
      default:
        return AppTheme.textMuted;
    }
  }

  String _getAdviceForError(String type) {
    switch (type) {
      case 'konu_eksigi':
        return 'Bu konuyu mikro derslerle güçlendir!';
      case 'dikkatsizlik':
        return 'Soruları çözmeden önce derin bir nefes al.';
      case 'zaman_yetersiz':
        return 'Zamanlı pratikler yaparak hızını artır.';
      case 'anlama_sorunu':
        return 'Soruyu parçalara ayırarak analiz et.';
      case 'hesaplama_hatasi':
        return 'Her adımı yazarak kontrol et.';
      case 'kavram_eksik':
        return 'Temel kavramları tekrar gözden geçir.';
      default:
        return 'Pratik yaparak gelişebilirsin!';
    }
  }
}

/// Hata veri noktası
class ErrorDataPoint {
  final String type;
  final String label;
  final String emoji;
  final Color color;
  final int count;

  ErrorDataPoint({
    required this.type,
    required this.label,
    required this.emoji,
    required this.color,
    required this.count,
  });
}
