/// SOLICAP - STEM Dashboard Screen
/// Sınıf seçimi + Ders tabları + Ünite haritası

import 'package:flutter/material.dart';
import '../data/stem_content_data.dart';
import '../models/stem_models.dart';
import '../services/stem_learning_service.dart';
import '../theme/app_theme.dart';
import 'stem_lesson_screen.dart';
import 'stem_stats_screen.dart';

class StemDashboardScreen extends StatefulWidget {
  const StemDashboardScreen({super.key});

  @override
  State<StemDashboardScreen> createState() => _StemDashboardScreenState();
}

class _StemDashboardScreenState extends State<StemDashboardScreen> with TickerProviderStateMixin {
  final StemLearningService _service = StemLearningService();

  GradeLevel _selectedGrade = GradeLevel.sinif5;
  late TabController _subjectTabController;
  StemProgress? _progress;
  bool _isLoading = true;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _initSubjectTabs();
    _init();
  }

  void _initSubjectTabs() {
    final subjects = _selectedGrade.availableSubjects;
    _subjectTabController = TabController(length: subjects.length, vsync: this);
    _subjectTabController.addListener(_onSubjectTabChanged);
  }

  void _onSubjectTabChanged() {
    if (!_subjectTabController.indexIsChanging) {
      _loadProgress();
    }
  }

  Future<void> _init() async {
    await _service.initialize();
    await _loadProgress();
  }

  Future<void> _loadProgress() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final subjects = _selectedGrade.availableSubjects;
    final currentSubject = subjects[_subjectTabController.index];
    final progress = await _service.getProgress(_selectedGrade, currentSubject);

    if (mounted) {
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    }
  }

  void _onGradeChanged(GradeLevel grade) {
    if (grade == _selectedGrade) return;
    _subjectTabController.removeListener(_onSubjectTabChanged);
    _subjectTabController.dispose();
    setState(() {
      _selectedGrade = grade;
    });
    _initSubjectTabs();
    _loadProgress();
  }

  StemSubject get _currentSubject {
    final subjects = _selectedGrade.availableSubjects;
    return subjects[_subjectTabController.index];
  }

  @override
  void dispose() {
    _subjectTabController.removeListener(_onSubjectTabChanged);
    _subjectTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('STEM Öğren', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_progress != null)
            IconButton(
              icon: const Icon(Icons.bar_chart_rounded, color: AppTheme.textPrimary),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StemStatsScreen(
                    progress: _progress!,
                    gradeLevel: _selectedGrade,
                    subject: _currentSubject,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Sınıf Seçimi
          _buildGradeSelector(),
          const SizedBox(height: 8),
          // Ders Tabları
          _buildSubjectTabs(),
          const SizedBox(height: 8),
          // İçerik
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF37474F)))
                : RefreshIndicator(
                    onRefresh: _loadProgress,
                    color: const Color(0xFF37474F),
                    child: _buildContent(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16),
      child: Row(
        children: GradeLevel.values.map((grade) {
          final isSelected = grade == _selectedGrade;
          final hasContent = _service.getUnits(grade, grade.availableSubjects.first).isNotEmpty;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(grade.label),
              selected: isSelected,
              onSelected: hasContent ? (_) => _onGradeChanged(grade) : null,
              selectedColor: const Color(0xFF37474F),
              backgroundColor: AppTheme.cardColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (hasContent ? AppTheme.textPrimary : AppTheme.textMuted),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: _isSmallScreen ? 11 : 13,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(
                color: isSelected ? const Color(0xFF37474F) : AppTheme.dividerColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubjectTabs() {
    final subjects = _selectedGrade.availableSubjects;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: TabBar(
        controller: _subjectTabController,
        tabs: subjects.map((s) => Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.emoji, style: TextStyle(fontSize: _isSmallScreen ? 14 : 16)),
              const SizedBox(width: 6),
              Text(s.label, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13)),
            ],
          ),
        )).toList(),
        labelColor: const Color(0xFF37474F),
        unselectedLabelColor: AppTheme.textMuted,
        indicatorColor: const Color(0xFF37474F),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildContent() {
    final progress = _progress;
    if (progress == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(progress),
          const SizedBox(height: 16),
          _buildStreakXPRow(progress),
          const SizedBox(height: 20),
          _buildUnitMap(progress),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(StemProgress progress) {
    final completedUnits = progress.completedUnitCount;
    final totalUnits = _service.getUnits(_selectedGrade, _currentSubject).length;
    final overallProgress = progress.overallProgress;

    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF37474F), Color(0xFF455A64), Color(0xFF37474F)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_currentSubject.emoji, style: TextStyle(fontSize: _isSmallScreen ? 22 : 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedGrade.label} - ${_currentSubject.label}',
                      style: TextStyle(color: Colors.white, fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completedUnits / $totalUnits ünite tamamlandı',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: _isSmallScreen ? 11 : 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF81C784)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakXPRow(StemProgress progress) {
    return Row(
      children: [
        Expanded(child: _buildMiniCard('🔥', '${progress.currentStreak}', 'Gün Serisi')),
        const SizedBox(width: 10),
        Expanded(child: _buildMiniCard('⚡', '${progress.totalXP}', 'Toplam XP')),
        const SizedBox(width: 10),
        Expanded(child: _buildMiniCard('📊', '${progress.dailyXP}/${progress.dailyGoal}', 'Günlük XP')),
      ],
    );
  }

  Widget _buildMiniCard(String emoji, String value, String label) {
    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3)],
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: _isSmallScreen ? 16 : 20)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: _isSmallScreen ? 13 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          Text(label, style: TextStyle(fontSize: _isSmallScreen ? 9 : 10, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildUnitMap(StemProgress progress) {
    final units = _service.getUnits(_selectedGrade, _currentSubject);
    if (units.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(Icons.construction_rounded, size: 48, color: AppTheme.textMuted),
              const SizedBox(height: 12),
              Text(
                'Bu sınıf/ders için içerik hazırlanıyor...',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ünite Haritası',
          style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 12),
        ...units.map((unit) {
          final isLocked = _service.isUnitLocked(unit.id, progress);
          final unitProg = progress.unitProgresses[unit.id];
          final percent = unitProg?.progressPercent ?? 0;
          final isCompleted = unitProg?.isCompleted ?? false;
          // İçerik placeholder mı kontrol et (Yakında etiketi için)
          final content = getStemUnitContent(unit.id);
          final isComingSoon = content != null &&
              content.examQuestions.length <= 1 &&
              content.examQuestions.first.question.contains('yakında');

          return _buildUnitCard(unit, isLocked || isComingSoon, isCompleted, percent, progress, isComingSoon: isComingSoon);
        }),
      ],
    );
  }

  Widget _buildUnitCard(StemUnit unit, bool isLocked, bool isCompleted, double percent, StemProgress progress, {bool isComingSoon = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isLocked
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isComingSoon ? 'Bu içerik yakında eklenecek!' : 'Önceki üniteyi tamamla!'),
                      duration: const Duration(seconds: 2),
                    ),
                  )
              : () => _openUnit(unit, progress),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
            decoration: BoxDecoration(
              color: isLocked ? AppTheme.cardColor.withOpacity(0.5) : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isLocked ? [] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              border: isCompleted
                  ? Border.all(color: const Color(0xFF81C784).withOpacity(0.6), width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                // Ünite ikonu
                Container(
                  width: _isSmallScreen ? 40 : 48,
                  height: _isSmallScreen ? 40 : 48,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.08)
                        : isCompleted
                            ? const Color(0xFF81C784).withOpacity(0.12)
                            : const Color(0xFF37474F).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: isLocked
                      ? Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: _isSmallScreen ? 18 : 22)
                      : Text(unit.icon, style: TextStyle(fontSize: _isSmallScreen ? 20 : 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ünite ${unit.order}',
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 10 : 11,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? AppTheme.textMuted : const Color(0xFF37474F),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.titleTr,
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? AppTheme.textMuted : AppTheme.textPrimary,
                        ),
                      ),
                      if (!isLocked && percent > 0) ...[
                        const SizedBox(height: 6),
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
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Yakında',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  )
                else if (isCompleted)
                  const Icon(Icons.check_circle, color: Color(0xFF81C784), size: 22)
                else if (!isLocked)
                  const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openUnit(StemUnit unit, StemProgress progress) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StemLessonScreen(
          unit: unit,
          gradeLevel: _selectedGrade,
          subject: _currentSubject,
          initialProgress: progress,
        ),
      ),
    ).then((_) => _loadProgress());
  }
}
