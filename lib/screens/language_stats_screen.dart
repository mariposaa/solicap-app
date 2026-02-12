/// SOLICAP - Dil Öğrenme İstatistik Ekranı
/// Beceri bazlı analiz, haftalık aktivite, genel özet

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/language_models.dart';

class LanguageStatsScreen extends StatelessWidget {
  final LanguageProgress progress;

  const LanguageStatsScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final sm = MediaQuery.of(context).size.width < 380;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('İstatistikler', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(sm ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(sm),
            SizedBox(height: 24),
            _buildSkillRadar(sm),
            SizedBox(height: 24),
            _buildUnitProgress(sm),
          ],
        ),
      ),
    );
  }

  // ── Genel Özet Kartları ──
  Widget _buildOverviewCards(bool sm) {
    final completedUnits = progress.unitProgresses.values.where((u) => u.isCompleted).length;
    final totalLessons = progress.unitProgresses.values.fold<int>(0, (sum, u) => sum + u.completedCount);

    return Row(
      children: [
        _statCard(sm, '🏆', 'Seviye', progress.currentLevel.code, const Color(0xFF2E7D32)),
        SizedBox(width: sm ? 6 : 10),
        _statCard(sm, '⭐', 'Toplam XP', '${progress.totalXP}', Colors.amber),
        SizedBox(width: sm ? 6 : 10),
        _statCard(sm, '🔥', 'Seri', '${progress.currentStreak} gün', Colors.orange),
      ],
    );
  }

  Widget _statCard(bool sm, String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(sm ? 10 : 14),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: sm ? 20 : 24)),
            SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: sm ? 15 : 18, fontWeight: FontWeight.bold, color: color)),
            SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: sm ? 10 : 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  // ── Beceri Radar Grafiği ──
  Widget _buildSkillRadar(bool sm) {
    final skills = {
      'Grammar': progress.skillScores['grammar'] ?? 0.0,
      'Vocabulary': progress.skillScores['vocabulary'] ?? 0.0,
      'Reading': progress.skillScores['reading'] ?? 0.0,
      'Listening': progress.skillScores['listening'] ?? 0.0,
      'Speaking': progress.skillScores['speaking'] ?? 0.0,
    };
    final chartHeight = sm ? 160.0 : 220.0;

    return Container(
      padding: EdgeInsets.all(sm ? 12 : 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beceri Analizi', style: TextStyle(fontSize: sm ? 14 : 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 20),

          // Radar chart
          SizedBox(
            height: chartHeight,
            child: CustomPaint(
              size: Size(double.infinity, chartHeight),
              painter: _RadarChartPainter(skills),
            ),
          ),

          SizedBox(height: 16),

          // Skill bars
          ...skills.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: sm ? 60 : 80,
                      child: Text(entry.key, style: TextStyle(fontSize: sm ? 11 : 13, color: AppTheme.textSecondary)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: entry.value / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            entry.value >= 70
                                ? const Color(0xFF4CAF50)
                                : entry.value >= 40
                                    ? Colors.orange
                                    : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: sm ? 6 : 10),
                    Text(
                      '%${entry.value.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: sm ? 11 : 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Ünite İlerleme ──
  Widget _buildUnitProgress(bool sm) {
    final completedUnits = progress.unitProgresses.values.where((u) => u.isCompleted).length;
    final totalUnits = progress.unitProgresses.length;

    return Container(
      padding: EdgeInsets.all(sm ? 12 : 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ünite İlerlemesi', style: TextStyle(fontSize: sm ? 14 : 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          SizedBox(height: 6),
          Text('$completedUnits ünite tamamlandı', style: TextStyle(fontSize: sm ? 11 : 13, color: AppTheme.textMuted)),
          SizedBox(height: 16),

          Row(
            children: [
              _miniStat(sm, 'En İyi Seri', '${progress.bestStreak} gün'),
              SizedBox(width: 16),
              _miniStat(sm, 'Günlük Hedef', '${progress.dailyGoal} XP'),
              SizedBox(width: 16),
              _miniStat(sm, 'Tamamlanan Ders', '${progress.unitProgresses.values.fold<int>(0, (sum, u) => sum + u.completedCount)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(bool sm, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: sm ? 14 : 16, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: sm ? 10 : 11, color: AppTheme.textMuted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// RADAR CHART PAINTER
// ═══════════════════════════════════════════════════════════════

class _RadarChartPainter extends CustomPainter {
  final Map<String, double> data;

  _RadarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 30;
    final count = data.length;
    final angleStep = 2 * math.pi / count;

    // Arka plan çizgileri
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int level = 1; level <= 4; level++) {
      final r = radius * level / 4;
      final path = Path();
      for (int i = 0; i <= count; i++) {
        final angle = -math.pi / 2 + angleStep * i;
        final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(path, gridPaint);
    }

    // Eksen çizgileri
    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + angleStep * i;
      final end = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      canvas.drawLine(center, end, gridPaint);
    }

    // Veri alanı
    final values = data.values.toList();
    final dataPath = Path();
    final fillPaint = Paint()
      ..color = const Color(0xFF2E7D32).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i <= count; i++) {
      final idx = i % count;
      final angle = -math.pi / 2 + angleStep * idx;
      final value = (values[idx] / 100).clamp(0.0, 1.0);
      final r = radius * value;
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));

      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, strokePaint);

    // Veri noktaları
    final dotPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + angleStep * i;
      final value = (values[i] / 100).clamp(0.0, 1.0);
      final r = radius * value;
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      canvas.drawCircle(point, 4, dotPaint);
    }

    // Etiketler
    final labels = data.keys.toList();
    final textPainterStyle = const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500);

    for (int i = 0; i < count; i++) {
      final angle = -math.pi / 2 + angleStep * i;
      final labelRadius = radius + 18;
      final point = Offset(center.dx + labelRadius * math.cos(angle), center.dy + labelRadius * math.sin(angle));

      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: textPainterStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(point.dx - tp.width / 2, point.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
