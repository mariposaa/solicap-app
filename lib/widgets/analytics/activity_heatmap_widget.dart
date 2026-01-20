/// SOLICAP - Activity Heatmap Widget
/// GitHub tarzı son 30 günün çalışma aktivitesini gösterir

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/learning_event_model.dart';

class ActivityHeatmapWidget extends StatefulWidget {
  final List<DailyLearningSnapshot> snapshots;

  const ActivityHeatmapWidget({
    super.key,
    required this.snapshots,
  });

  @override
  State<ActivityHeatmapWidget> createState() => _ActivityHeatmapWidgetState();
}

class _ActivityHeatmapWidgetState extends State<ActivityHeatmapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
        curve: Curves.easeIn,
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
    final heatmapData = _prepareHeatmapData();

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
                  color: AppTheme.successColor.withOpacity(0.1),
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
                            AppTheme.successColor.withOpacity(0.2),
                            AppTheme.primaryColor.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: AppTheme.successColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Çalışma Takvimi',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Son 28 günlük aktiviten',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Toplam soru sayısı badge
                    _buildTotalBadge(heatmapData),
                  ],
                ),

                const SizedBox(height: 20),

                // Gün isimleri
                _buildDayLabels(),

                const SizedBox(height: 8),

                // Heatmap Grid
                _buildHeatmapGrid(heatmapData),

                const SizedBox(height: 16),

                // Legend
                _buildLegend(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalBadge(Map<DateTime, int> data) {
    final total = data.values.fold(0, (sum, count) => sum + count);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.quiz, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            '$total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayLabels() {
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
        children: days.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeatmapGrid(Map<DateTime, int> data) {
    // 4 hafta (28 gün) göster
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 27));

    // Haftaları oluştur
    // Haftaları oluştur
    List<List<DateTime>> weeks = [];
    DateTime current = startDate;
    
    // İlk hafta listesini başlat
    List<DateTime> currentWeek = [];
    
    // Başlangıç gününe kadar olan geçmiş günleri (padding) ekle
    // Örn: Başlangıç Çarşamba ise, Pzt ve Salı'yı "boş" (past date) olarak ekle
    for (int i = 1; i < current.weekday; i++) {
       currentWeek.add(current.subtract(Duration(days: current.weekday - i)));
    }
    weeks.add(currentWeek);

    while (current.isBefore(today) || _isSameDay(current, today)) {
      // Pazartesi ise ve mevcut hafta boş değilse yeni hafta aç
      if (current.weekday == 1 && weeks.last.isNotEmpty) {
        currentWeek = [];
        weeks.add(currentWeek);
      }

      weeks.last.add(current);
      current = current.add(const Duration(days: 1));
    }

    return Column(
      children: weeks.asMap().entries.map((entry) {
        final weekIndex = entry.key;
        final week = entry.value;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (weekIndex * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      // Hafta numarası
                      SizedBox(
                        width: 20,
                        child: Text(
                          'H${weekIndex + 1}',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      // Günler
                      ...List.generate(7, (dayIndex) {
                        if (dayIndex < week.length) {
                          final date = week[dayIndex];
                          final isBeforeStart = date.isBefore(startDate);
                          final count = isBeforeStart ? -1 : (data[_normalizeDate(date)] ?? 0);

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: _buildDayCell(date, count, _isSameDay(date, today)),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              height: 24,
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(DateTime date, int questionCount, bool isToday) {
    // -1 = geçersiz gün (grid padding)
    if (questionCount < 0) {
      return Container(
        height: 24,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    final intensity = _getIntensity(questionCount);
    final color = _getColorForIntensity(intensity);

    return Tooltip(
      message: '${date.day}/${date.month}: $questionCount soru',
      child: Container(
        height: 24,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: isToday
              ? Border.all(color: AppTheme.primaryColor, width: 2)
              : null,
          boxShadow: questionCount > 0
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: questionCount > 5
            ? Center(
                child: Text(
                  '$questionCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Az',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
        ),
        const SizedBox(width: 8),
        ...[0, 1, 2, 3, 4].map((intensity) {
          return Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: _getColorForIntensity(intensity),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'Çok',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
        ),
      ],
    );
  }

  Map<DateTime, int> _prepareHeatmapData() {
    final Map<DateTime, int> data = {};

    for (final snapshot in widget.snapshots) {
      final normalizedDate = _normalizeDate(snapshot.date);
      data[normalizedDate] = snapshot.questionsAttempted;
    }

    return data;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int _getIntensity(int count) {
    if (count == 0) return 0;
    if (count <= 2) return 1;
    if (count <= 5) return 2;
    if (count <= 10) return 3;
    return 4;
  }

  Color _getColorForIntensity(int intensity) {
    switch (intensity) {
      case 0:
        return AppTheme.surfaceColor;
      case 1:
        return AppTheme.successColor.withOpacity(0.3);
      case 2:
        return AppTheme.successColor.withOpacity(0.5);
      case 3:
        return AppTheme.successColor.withOpacity(0.75);
      case 4:
        return AppTheme.successColor;
      default:
        return AppTheme.surfaceColor;
    }
  }
}
