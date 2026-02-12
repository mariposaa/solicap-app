/// SOLICAP - STEM Stats Screen
/// Konu bazlı istatistikler

import 'package:flutter/material.dart';
import '../models/stem_models.dart';
import '../services/stem_learning_service.dart';
import '../theme/app_theme.dart';

class StemStatsScreen extends StatelessWidget {
  final StemProgress progress;
  final GradeLevel gradeLevel;
  final StemSubject subject;

  const StemStatsScreen({
    super.key,
    required this.progress,
    required this.gradeLevel,
    required this.subject,
  });

  bool _isSmall(BuildContext context) => MediaQuery.of(context).size.width < 380;

  @override
  Widget build(BuildContext context) {
    final sm = _isSmall(context);
    final service = StemLearningService();
    final units = service.getUnits(gradeLevel, subject);
    final completedUnits = progress.completedUnitCount;
    final totalLessonsCompleted = progress.unitProgresses.values
        .fold<int>(0, (sum, u) => sum + u.completedCount);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('İstatistikler', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sm ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(sm, completedUnits, units.length, totalLessonsCompleted),
            const SizedBox(height: 24),
            _buildUnitProgressSection(sm, units),
            const SizedBox(height: 24),
            _buildMiniStats(sm),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(bool sm, int completedUnits, int totalUnits, int totalLessons) {
    return Row(
      children: [
        Expanded(child: _statCard(sm, '📐', '${gradeLevel.label}', 'Sınıf')),
        SizedBox(width: sm ? 6 : 10),
        Expanded(child: _statCard(sm, '⚡', '${progress.totalXP}', 'Toplam XP')),
        SizedBox(width: sm ? 6 : 10),
        Expanded(child: _statCard(sm, '🔥', '${progress.currentStreak}', 'Gün Serisi')),
      ],
    );
  }

  Widget _statCard(bool sm, String emoji, String value, String label) {
    return Container(
      padding: EdgeInsets.all(sm ? 10 : 14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: sm ? 18 : 22)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: sm ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: sm ? 10 : 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildUnitProgressSection(bool sm, List<StemUnit> units) {
    final completedUnits = progress.completedUnitCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ünite İlerlemesi', style: TextStyle(fontSize: sm ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            Text('$completedUnits/${units.length} tamamlandı', style: TextStyle(fontSize: sm ? 11 : 13, color: AppTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 12),
        ...units.map((unit) {
          final unitProg = progress.unitProgresses[unit.id];
          final percent = unitProg?.progressPercent ?? 0;
          final isCompleted = unitProg?.isCompleted ?? false;
          final examScore = unitProg?.bestExamScore ?? unitProg?.examScore;
          final attempts = unitProg?.attempts ?? 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(sm ? 10 : 14),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 3)],
              border: isCompleted ? Border.all(color: const Color(0xFF81C784).withOpacity(0.5), width: 1) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(unit.icon, style: TextStyle(fontSize: sm ? 16 : 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ünite ${unit.order}: ${unit.titleTr}',
                            style: TextStyle(fontSize: sm ? 12 : 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${unitProg?.completedCount ?? 0}/5 ders tamamlandı',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isCompleted)
                      const Icon(Icons.check_circle, color: Color(0xFF81C784), size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 4,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? const Color(0xFF81C784) : const Color(0xFF37474F),
                    ),
                  ),
                ),
                if (examScore != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Sınav: %${examScore.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: examScore >= 60 ? const Color(0xFF388E3C) : Colors.red,
                        ),
                      ),
                      if (attempts > 1) ...[
                        const SizedBox(width: 8),
                        Text('($attempts deneme)', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMiniStats(bool sm) {
    final totalLessons = progress.unitProgresses.values.fold<int>(0, (sum, u) => sum + u.completedCount);
    return Row(
      children: [
        Expanded(child: _miniStat(sm, '${progress.bestStreak}', 'En İyi Seri')),
        SizedBox(width: sm ? 6 : 10),
        Expanded(child: _miniStat(sm, '${progress.dailyGoal}', 'Günlük Hedef')),
        SizedBox(width: sm ? 6 : 10),
        Expanded(child: _miniStat(sm, '$totalLessons', 'Tamamlanan Ders')),
      ],
    );
  }

  Widget _miniStat(bool sm, String value, String label) {
    return Container(
      padding: EdgeInsets.all(sm ? 8 : 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 3)],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: sm ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: sm ? 9 : 10, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
