/// SOLICAP - Dil Öğrenme Dashboard
/// Seviye rozeti, XP çubuğu, streak, ünite haritası

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/language_models.dart';
import '../services/language_learning_service.dart';
import 'language_placement_screen.dart';
import 'language_lesson_screen.dart';
import 'language_stats_screen.dart';
import 'word_game_screen.dart';

class LanguageDashboard extends StatefulWidget {
  const LanguageDashboard({super.key});

  @override
  State<LanguageDashboard> createState() => _LanguageDashboardState();
}

class _LanguageDashboardState extends State<LanguageDashboard> {
  final LanguageLearningService _service = LanguageLearningService();
  LanguageProgress? _progress;
  bool _isLoading = true;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _service.initialize();
    final progress = await _service.getProgress();
    if (mounted) {
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
    }

    final progress = _progress;
    if (progress == null) return const SizedBox.shrink();

    // Seviye belirleme yapılmadıysa
    if (!progress.placementDone) {
      return _buildPlacementPrompt();
    }

    return RefreshIndicator(
      onRefresh: _init,
      color: const Color(0xFF2E7D32),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(progress),
            const SizedBox(height: 20),
            _buildStreakCard(progress),
            const SizedBox(height: 20),
            _buildXPProgressCard(progress),
            const SizedBox(height: 24),
            _buildUnitMap(progress),
            const SizedBox(height: 24),
            _buildWordGameCard(),
          ],
        ),
      ),
    );
  }

  // ── Seviye belirleme prompt ──
  Widget _buildPlacementPrompt() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 16 : 24),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, size: _isSmallScreen ? 44 : 56, color: const Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 24),
          Text(
            'Seviyeni Belirleyelim',
            style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            '20 soruluk kısa bir testle İngilizce seviyeni belirleyeceğiz.\nSonra sana uygun derslerle başlayacağız.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<LanguageProgress>(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguagePlacementScreen()),
                );
                if (result != null && mounted) {
                  setState(() => _progress = result);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
              ),
              child: const Text('Teste Başla'),
            ),
          ),
          const SizedBox(height: 32),
          _buildWordGameCard(),
        ],
      ),
    );
  }

  // ── Header: Seviye rozeti ──
  Widget _buildHeader(LanguageProgress progress) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.translate_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                progress.currentLevel.code,
                style: TextStyle(color: Colors.white, fontSize: _isSmallScreen ? 17 : 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                progress.currentLevel.label,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: _isSmallScreen ? 11 : 13),
              ),
            ],
          ),
        ),
        const Spacer(),
        // İstatistik butonu
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => LanguageStatsScreen(progress: progress)));
          },
          icon: const Icon(Icons.bar_chart_rounded, color: Color(0xFF2E7D32)),
          tooltip: 'İstatistikler',
        ),
      ],
    );
  }

  // ── Streak kartı ──
  Widget _buildStreakCard(LanguageProgress progress) {
    final now = DateTime.now();
    final lastActive = progress.lastActiveDate;
    final isActiveToday = now.year == lastActive.year && now.month == lastActive.month && now.day == lastActive.day;
    final dailyPercent = progress.dailyGoal > 0
        ? (progress.dailyXP / progress.dailyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Row(
        children: [
          // Streak flame
          Container(
            width: _isSmallScreen ? 42 : 52,
            height: _isSmallScreen ? 42 : 52,
            decoration: BoxDecoration(
              color: progress.currentStreak > 0
                  ? Colors.orange.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              progress.currentStreak > 0 ? '🔥' : '❄️',
              style: const TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${progress.currentStreak} gün seri',
                      style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const Spacer(),
                    Text(
                      '${progress.dailyXP}/${progress.dailyGoal} XP',
                      style: TextStyle(
                        fontSize: _isSmallScreen ? 11 : 13,
                        fontWeight: FontWeight.w600,
                        color: isActiveToday ? const Color(0xFF2E7D32) : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: dailyPercent,
                    minHeight: 6,
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      dailyPercent >= 1.0 ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dailyPercent >= 1.0 ? 'Günlük hedef tamamlandı!' : 'Günlük hedefe ${progress.dailyGoal - progress.dailyXP} XP kaldı',
                  style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── XP seviye ilerleme kartı ──
  Widget _buildXPProgressCard(LanguageProgress progress) {
    final nextLevel = progress.currentLevel.next;
    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
              const SizedBox(width: 8),
              Text(
                'Toplam ${progress.totalXP} XP',
                style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          if (nextLevel != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(progress.currentLevel.code, style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32), fontSize: _isSmallScreen ? 11 : 13)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.levelProgress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(nextLevel.code, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 13)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${nextLevel.code} seviyesine ${progress.xpNeededForLevelUp - progress.xpForCurrentLevel} XP kaldı',
              style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: AppTheme.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  // ── Ünite haritası ──
  Widget _buildUnitMap(LanguageProgress progress) {
    final units = _service.getUnits(progress.currentLevel);
    if (units.isEmpty) {
      return const Center(child: Text('Bu seviye için ünite bulunamadı.', style: TextStyle(color: AppTheme.textMuted)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ünite Haritası',
          style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        ...units.map((unit) {
          final isLocked = _service.isUnitLocked(unit.id, progress);
          final unitProg = progress.unitProgresses[unit.id];
          final percent = unitProg?.progressPercent ?? 0;
          final isCompleted = unitProg?.isCompleted ?? false;

          return _buildUnitCard(unit, isLocked, isCompleted, percent, progress);
        }),
      ],
    );
  }

  Widget _buildUnitCard(LanguageUnit unit, bool isLocked, bool isCompleted, double percent, LanguageProgress progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLocked
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Önceki üniteyi tamamla!'), duration: Duration(seconds: 2)),
                  )
              : () => _openUnit(unit, progress),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
            decoration: BoxDecoration(
              color: isLocked
                  ? AppTheme.cardColor.withOpacity(0.5)
                  : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isLocked ? [] : AppTheme.subtleShadow,
              border: isCompleted
                  ? Border.all(color: const Color(0xFF4CAF50).withOpacity(0.5), width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                // Ünite ikonu
                Container(
                  width: _isSmallScreen ? 42 : 52,
                  height: _isSmallScreen ? 42 : 52,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.1)
                        : isCompleted
                            ? const Color(0xFF4CAF50).withOpacity(0.15)
                            : const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: isLocked
                      ? const Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: 24)
                      : Text(unit.icon, style: const TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ünite ${unit.order}',
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? AppTheme.textMuted : const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.titleTr,
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? AppTheme.textMuted : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.title,
                        style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: isLocked ? AppTheme.textMuted.withOpacity(0.6) : AppTheme.textSecondary),
                      ),
                      if (!isLocked && percent > 0) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 4,
                            backgroundColor: Colors.grey.withOpacity(0.12),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isCompleted ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24)
                else if (!isLocked)
                  const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openUnit(LanguageUnit unit, LanguageProgress progress) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LanguageLessonScreen(unit: unit, initialProgress: progress),
      ),
    ).then((_) => _init()); // Geri dönünce yenile
  }

  // ── Kelime Oyunu Kartı ──
  Widget _buildWordGameCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WordGameScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(_isSmallScreen ? 14 : 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: const Color(0xFF1B5E20).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: _isSmallScreen ? 44 : 52,
              height: _isSmallScreen ? 44 : 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.abc_rounded, color: Colors.greenAccent, size: _isSmallScreen ? 28 : 32),
            ),
            SizedBox(width: _isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎮 Kelime Gezisi',
                    style: TextStyle(color: Colors.white, fontSize: _isSmallScreen ? 16 : 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Harfleri birleştir, kelime bul, İngilizce öğren!',
                    style: TextStyle(color: Colors.white70, fontSize: _isSmallScreen ? 12 : 13)),
                  const SizedBox(height: 4),
                  Text('🏆 +10/sv  ⭐ +25/10.sv  🎖️ +100/50.sv',
                    style: TextStyle(color: Colors.amber.withOpacity(0.8), fontSize: _isSmallScreen ? 10 : 11)),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
