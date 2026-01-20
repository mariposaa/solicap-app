/// SOLICAP - Skill Radar Widget
/// Öğrencinin tüm konulardaki yetkinliğini radar grafiği ile gösterir

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/user_dna_model.dart';

class SkillRadarWidget extends StatefulWidget {
  final Map<String, TopicPerformance> topicPerformance;
  final Map<String, SubTopicPerformance> subTopicPerformance;

  const SkillRadarWidget({
    super.key,
    required this.topicPerformance,
    required this.subTopicPerformance,
  });

  @override
  State<SkillRadarWidget> createState() => _SkillRadarWidgetState();
}

class _SkillRadarWidgetState extends State<SkillRadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
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
    final radarData = _prepareRadarData();

    // RadarChart en az 3 veri noktası gerektirir.
    // Kullanıcı talebi: Hayalet veri yerine "Yeterli veri yok" göster.
    if (radarData.length < 3) {
      return _buildEmptyState();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.1),
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
                              AppTheme.primaryColor.withOpacity(0.2),
                              AppTheme.accentColor.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.radar,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yetenek Haritası',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Tüm konulardaki ustalık seviyen',
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

                  // Radar Chart
                  SizedBox(
                    height: 280,
                    child: RadarChart(
                      RadarChartData(
                        radarShape: RadarShape.polygon,
                        tickCount: 4,
                        ticksTextStyle: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 10,
                        ),
                        tickBorderData: BorderSide(
                          color: AppTheme.dividerColor.withOpacity(0.5),
                        ),
                        gridBorderData: BorderSide(
                          color: AppTheme.dividerColor.withOpacity(0.5),
                          width: 1,
                        ),
                        radarBorderData: const BorderSide(
                          color: Colors.transparent,
                        ),
                        titleTextStyle: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        getTitle: (index, angle) {
                          if (index < radarData.length) {
                            return RadarChartTitle(
                              text: radarData[index].name,
                              angle: 0,
                            );
                          }
                          return const RadarChartTitle(text: '');
                        },
                        dataSets: [
                          RadarDataSet(
                            dataEntries: radarData
                                .map((e) => RadarEntry(
                                      value: e.value * _scaleAnimation.value,
                                    ))
                                .toList(),
                            fillColor: AppTheme.primaryColor.withOpacity(0.3),
                            borderColor: AppTheme.primaryColor,
                            borderWidth: 2,
                            entryRadius: 4,
                          ),
                        ],
                        titlePositionPercentageOffset: 0.15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Legend
                  _buildLegend(radarData),
                ],
              ),
            ),
          ),
        );
      },
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
            Icons.radar,
            size: 64,
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Yetenek Haritası',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Analiz için yeterli veri yok.\nEn az 3 farklı konuda soru çözmelisin.',
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

  Widget _buildLegend(List<RadarDataPoint> data) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.map((point) {
        final color = _getColorForValue(point.value);
        final percentage = (point.value * 100).toInt();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${point.name}: %$percentage',
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<RadarDataPoint> _prepareRadarData() {
    final List<RadarDataPoint> data = [];

    // Ana konuları kullan
    if (widget.topicPerformance.isNotEmpty) {
      for (final entry in widget.topicPerformance.entries) {
        final name = _shortenTopicName(entry.key);
        final value = entry.value.weightedProficiency > 0
            ? entry.value.weightedProficiency
            : entry.value.successRate;
        data.add(RadarDataPoint(name: name, value: value.clamp(0.0, 1.0)));
      }
    }

    // Eğer ana konu yoksa alt konulardan grupla
    if (data.isEmpty && widget.subTopicPerformance.isNotEmpty) {
      final Map<String, List<double>> grouped = {};
      for (final entry in widget.subTopicPerformance.entries) {
        final parent = entry.value.parentTopic;
        grouped.putIfAbsent(parent, () => []);
        grouped[parent]!.add(entry.value.weightedProficiency);
      }

      for (final entry in grouped.entries) {
        final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
        data.add(RadarDataPoint(
          name: _shortenTopicName(entry.key),
          value: avg.clamp(0.0, 1.0),
        ));
      }
    }

    // En fazla 8 konu göster
    if (data.length > 8) {
      data.sort((a, b) => b.value.compareTo(a.value));
      return data.take(8).toList();
    }

    return data;
  }

  String _shortenTopicName(String name) {
    const Map<String, String> shortcuts = {
      'Matematik': 'Mat',
      'Fizik': 'Fiz',
      'Kimya': 'Kim',
      'Biyoloji': 'Bio',
      'Türkçe': 'Trk',
      'Türk Dili': 'Trk',
      'Tarih': 'Tar',
      'Coğrafya': 'Coğ',
      'Geometri': 'Geo',
      'İngilizce': 'Eng',
      'Felsefe': 'Fel',
    };

    return shortcuts[name] ?? (name.length > 5 ? name.substring(0, 4) : name);
  }

  Color _getColorForValue(double value) {
    if (value >= 0.7) return AppTheme.successColor;
    if (value >= 0.4) return AppTheme.warningColor;
    return const Color(0xFFEF4444); // danger red
  }
}

/// Radar veri noktası
class RadarDataPoint {
  final String name;
  final double value;

  RadarDataPoint({required this.name, required this.value});
}
