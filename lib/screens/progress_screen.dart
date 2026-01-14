/// SOLICAP - Progress Screen
/// Öğrenci gelişim ve analiz ekranı

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../services/session_tracking_service.dart';
import '../models/learning_gap_model.dart';
import '../models/learning_event_model.dart';
import '../services/learning_insights_service.dart';
import '../services/gemini_service.dart';
import '../services/user_dna_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final AnalyticsService _analyticsService = AnalyticsService();
  final AuthService _authService = AuthService();
  final SessionTrackingService _sessionTracker = SessionTrackingService();
  
  StudentAnalytics? _analytics;
  String? _aiAnalysis;
  bool _isLoading = true;
  bool _isLoadingAI = false;
  
  // Gelişim grafiği için
  List<FlSpot> _progressData = [];
  List<DailyLearningSnapshot> _dailySnapshots = [];
  
  // Bugünün özeti
  DailyLearningSnapshot? _todaySnapshot;

  // 🧠 Akıllı içgörüler
  final LearningInsightsService _insightsService = LearningInsightsService();
  LearningInsights? _insights;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final analytics = await _analyticsService.analyzeStudent(userId);
    
    // 📊 GERÇEK VERİ: Son 7 günün snapshot'larını al
    final snapshots = await _sessionTracker.getRecentSnapshots(days: 7);
    final todaySnap = await _sessionTracker.getTodaySnapshot();
    
    // Snapshot'ları grafik verisine dönüştür
    final spots = <FlSpot>[];
    
    if (snapshots.isNotEmpty) {
      // Tarihe göre sırala (eskiden yeniye)
      final sortedSnapshots = List<DailyLearningSnapshot>.from(snapshots)
        ..sort((a, b) => a.date.compareTo(b.date));
      
      for (int i = 0; i < sortedSnapshots.length; i++) {
        final snapshot = sortedSnapshots[i];
        // Başarı oranını yüzde olarak al
        final successPercent = snapshot.successRate * 100;
        spots.add(FlSpot(i.toDouble(), successPercent.clamp(0.0, 100.0)));
      }
      
      _dailySnapshots = sortedSnapshots;
    } else {
      // Henüz veri yoksa boş grafik
      debugPrint('📊 Henüz günlük snapshot verisi yok');
    }
    
    // 🧠 İçgörüleri hesapla
    final insights = await _insightsService.calculateInsights();
    
    setState(() {
      _analytics = analytics;
      _progressData = spots;
      _todaySnapshot = todaySnap;
      _insights = insights;
      _isLoading = false;
    });
  }

  Future<void> _loadAIAnalysis() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    setState(() => _isLoadingAI = true);
    
    // GeminiService üzerinden analiz al (AnalyticsService dairesel bağımlılıktan dolayı kaldırıldı)
    final dnaService = UserDNAService();
    final dna = await dnaService.getDNA();
    
    String? report;
    if (dna != null) {
      final activityLog = dna.failedQuestions.take(5).map((q) => {
        'topic': q.topic,
        'result': 'wrong',
        'error_type': q.failureReason,
      }).toList();

      final analysis = await GeminiService().getAIAnalysis(
        activityLog: activityLog,
        topicPerformance: {
          for (var entry in dna.topicPerformance.entries)
            entry.key: entry.value.successRate
        },
      );
      report = analysis?.deepAnalysis;
    }

    setState(() {
      _aiAnalysis = report ?? 'Henüz yeterli veri toplanmadı.';
      _isLoadingAI = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.backgroundColor,
      child: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Gelişim Raporu',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Öğrenme yolculuğunu takip et',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Genel İstatistikler
                    _buildOverviewCard(),
                    
                    const SizedBox(height: 20),
                    
                    // 📊 Bugün Kartı
                    if (_todaySnapshot != null)
                      _buildTodayCard(),
                    
                    if (_todaySnapshot != null)
                      const SizedBox(height: 20),
                    
                    // 🧠 Akıllı İçgörüler Kartı
                    if (_insights != null)
                      _buildInsightsCard(),
                    
                    if (_insights != null)
                      const SizedBox(height: 20),
                    
                    // 📈 Gelişim Grafiği
                    if (_progressData.isNotEmpty)
                      _buildProgressChart(),
                    
                    if (_progressData.isNotEmpty)
                      const SizedBox(height: 20),
                    
                    // Konu Dağılımı
                    if (_analytics != null &&
                        _analytics!.subjectDistribution.isNotEmpty)
                      _buildSubjectDistribution(),
                    
                    const SizedBox(height: 20),
                    
                    // Zayıf Alanlar
                    if (_analytics != null && _analytics!.weakAreas.isNotEmpty)
                      _buildWeakAreas(),
                    
                    const SizedBox(height: 20),
                    
                    // Güçlü Alanlar
                    if (_analytics != null && _analytics!.strongAreas.isNotEmpty)
                      _buildStrongAreas(),
                    
                    const SizedBox(height: 20),
                    
                    // AI Analizi
                    _buildAIAnalysisCard(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  /// 📈 Gelişim Grafiği Widget
  Widget _buildProgressChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTrendIcon(),
                color: _getTrendColor(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Haftalık Gelişim',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_insights != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTrendColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_insights!.trendEmoji} ${_insights!.trendLabel}',
                    style: TextStyle(
                      color: _getTrendColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppTheme.dividerColor,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 25,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        // Gerçek tarihlerden etiket oluştur
                        if (index >= 0 && index < _dailySnapshots.length) {
                          final date = _dailySnapshots[index].date;
                          final dayName = _getDayName(date.weekday);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dayName,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _progressData,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.3),
                          AppTheme.primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: AppTheme.primaryColor,
                        );
                      },
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppTheme.cardColor,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()}%',
                          const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    final analytics = _analytics ?? StudentAnalytics.empty();
    final successPercent = (analytics.overallSuccessRate * 100).toInt();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                value: '${analytics.totalQuestionsSolved}',
                label: 'Toplam Soru',
                icon: Icons.quiz,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItem(
                value: '${analytics.totalCorrectAnswers}',
                label: 'Doğru',
                icon: Icons.check_circle,
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildStatItem(
                value: '%$successPercent',
                label: 'Başarı',
                icon: Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectDistribution() {
    final distribution = _analytics!.subjectDistribution;
    final total = distribution.values.fold(0, (a, b) => a + b);
    
    return _buildSection(
      title: 'Konu Dağılımı',
      child: Column(
        children: distribution.entries.map((entry) {
          final subject = entry.key;
          final count = entry.value;
          final percentage = total > 0 ? count / total : 0.0;
          final color = AppTheme.subjectColors[subject] ?? AppTheme.primaryColor;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getSubjectIcon(subject),
                    color: color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$count soru',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: percentage,
                        backgroundColor: AppTheme.surfaceColor,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeakAreas() {
    return _buildSection(
      title: 'Geliştirilmesi Gereken Alanlar',
      icon: Icons.warning_amber,
      iconColor: AppTheme.warningColor,
      child: Column(
        children: _analytics!.weakAreas.map((gap) {
          return _buildGapCard(gap, isWeak: true);
        }).toList(),
      ),
    );
  }

  Widget _buildStrongAreas() {
    return _buildSection(
      title: 'Güçlü Alanlar',
      icon: Icons.star,
      iconColor: AppTheme.successColor,
      child: Column(
        children: _analytics!.strongAreas.map((gap) {
          return _buildGapCard(gap, isWeak: false);
        }).toList(),
      ),
    );
  }

  Widget _buildGapCard(LearningGap gap, {required bool isWeak}) {
    final color = isWeak ? AppTheme.warningColor : AppTheme.successColor;
    final successPercent = (gap.successRate * 100).toInt();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${gap.subject} - ${gap.topic}',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '%$successPercent',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${gap.correctAttempts}/${gap.totalAttempts} doğru',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
          if (gap.recommendations.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              gap.recommendations.first,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAIAnalysisCard() {
    return _buildSection(
      title: 'AI Öğrenme Analizi',
      icon: Icons.auto_awesome,
      iconColor: AppTheme.accentColor,
      child: Column(
        children: [
          if (_aiAnalysis != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _aiAnalysis!,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoadingAI ? null : _loadAIAnalysis,
                icon: _isLoadingAI
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isLoadingAI ? 'Analiz yapılıyor...' : 'AI Analizi Al',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    IconData? icon,
    Color? iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematik':
        return Icons.calculate;
      case 'fizik':
        return Icons.science;
      case 'kimya':
        return Icons.biotech;
      case 'biyoloji':
        return Icons.eco;
      case 'türkçe':
        return Icons.menu_book;
      case 'tarih':
        return Icons.history_edu;
      case 'coğrafya':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  /// 📊 Bugün Kartı - Günlük özet
  Widget _buildTodayCard() {
    final today = _todaySnapshot!;
    final successPercent = (today.successRate * 100).toInt();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.15),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.today,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Bugün',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSuccessColor(today.successRate).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '%$successPercent',
                  style: TextStyle(
                    color: _getSuccessColor(today.successRate),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTodayStat(
                icon: Icons.quiz,
                value: '${today.questionsAttempted}',
                label: 'Soru',
              ),
              _buildTodayStat(
                icon: Icons.check_circle,
                value: '${today.questionsCorrect}',
                label: 'Doğru',
                color: AppTheme.successColor,
              ),
              _buildTodayStat(
                icon: Icons.timer,
                value: '${today.totalStudyMinutes}dk',
                label: 'Süre',
              ),
              if (today.hintsUsed > 0)
                _buildTodayStat(
                  icon: Icons.lightbulb,
                  value: '${today.hintsUsed}',
                  label: 'İpucu',
                  color: AppTheme.warningColor,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayStat({
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? AppTheme.textSecondary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppTheme.textPrimary,
            fontSize: 18,
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
    );
  }

  Color _getSuccessColor(double rate) {
    if (rate >= 0.7) return AppTheme.successColor;
    if (rate >= 0.4) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Pzt';
      case 2: return 'Sal';
      case 3: return 'Çar';
      case 4: return 'Per';
      case 5: return 'Cum';
      case 6: return 'Cmt';
      case 7: return 'Paz';
      default: return '';
    }
  }

  /// 🧠 Akıllı İçgörüler Kartı
  Widget _buildInsightsCard() {
    final insights = _insights!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Akıllı İçgörüler',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Streak badge
              if (insights.currentStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${insights.currentStreak} gün',
                        style: const TextStyle(
                          color: AppTheme.accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // İstatistik satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInsightStat(
                icon: Icons.trending_up,
                label: 'Bu Hafta',
                value: '%${(insights.thisWeekSuccessRate * 100).toInt()}',
                color: _getTrendColor(),
              ),
              _buildInsightStat(
                icon: Icons.schedule,
                label: 'Peak Saat',
                value: insights.peakHours.isNotEmpty 
                    ? '${insights.peakHours.first}:00'
                    : '-',
                color: AppTheme.secondaryColor,
              ),
              _buildInsightStat(
                icon: Icons.quiz,
                label: 'Soru',
                value: '${insights.thisWeekQuestions}',
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          
          // Aksiyon önerileri
          if (insights.actionableInsights.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: AppTheme.dividerColor),
            const SizedBox(height: 12),
            ...insights.actionableInsights.take(2).map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                insight,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
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
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  IconData _getTrendIcon() {
    if (_insights == null) return Icons.trending_flat;
    
    switch (_insights!.weeklyTrend) {
      case TrendDirection.rising:
        return Icons.trending_up;
      case TrendDirection.falling:
        return Icons.trending_down;
      case TrendDirection.stable:
        return Icons.trending_flat;
      case TrendDirection.unknown:
        return Icons.help_outline;
    }
  }

  Color _getTrendColor() {
    if (_insights == null) return AppTheme.textMuted;
    
    switch (_insights!.weeklyTrend) {
      case TrendDirection.rising:
        return AppTheme.successColor;
      case TrendDirection.falling:
        return AppTheme.errorColor;
      case TrendDirection.stable:
        return AppTheme.warningColor;
      case TrendDirection.unknown:
        return AppTheme.textMuted;
    }
  }
}
