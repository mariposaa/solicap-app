/// SOLICAP - Progress Screen
/// Öğrenci gelişim ve analiz ekranı - Premium Analytics Dashboard

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../services/session_tracking_service.dart';
import '../models/learning_gap_model.dart';
import '../models/learning_event_model.dart';
import '../models/user_dna_model.dart';
import '../services/learning_insights_service.dart';
import '../services/gemini_service.dart';
import '../services/user_dna_service.dart';
import '../widgets/analytics/skill_radar_widget.dart';
import '../widgets/analytics/error_breakdown_widget.dart';
import '../widgets/analytics/activity_heatmap_widget.dart';
import '../widgets/analytics/streak_celebration_widget.dart';
import '../widgets/analytics/knowledge_decay_widget.dart';
import '../widgets/analytics/cognitive_load_widget.dart';
import '../widgets/analytics/abandonment_warning_widget.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final AnalyticsService _analyticsService = AnalyticsService();
  final AuthService _authService = AuthService();
  final SessionTrackingService _sessionTracker = SessionTrackingService();
  final UserDNAService _dnaService = UserDNAService();
  
  StudentAnalytics? _analytics;
  MasterAnalysis? _masterAnalysis;  // 🔍 Premium Sherlock Analizi
  UserDNA? _userDNA; // 🎯 Kullanıcı DNA'sı - Premium analizler için
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

  // ✨ Animasyon kontrolü
  bool _showAnalysisAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    
    // ✨ Animasyon Controller Setup
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuad,
    );
    
    _loadAnalytics();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    
    // 🎯 UserDNA'yı yükle (Premium analizler için)
    final dna = await _dnaService.getDNA();
    
    setState(() {
      _analytics = analytics;
      _progressData = spots;
      _todaySnapshot = todaySnap;
      _insights = insights;
      _userDNA = dna;
      _isLoading = false;
    });
  }

  Future<void> _loadAIAnalysis() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    setState(() => _isLoadingAI = true);
    
    // ✨ Reset animation
    _animationController.reset();
    _showAnalysisAnimation = false;
    
    try {
      // GeminiService üzerinden premium analiz al
      final analysis = await GeminiService().getAIAnalysis(
        activityLog: [], // DNA'dan otomatik çekilecek
      );

      setState(() {
        _masterAnalysis = analysis;
        _isLoadingAI = false;
        _showAnalysisAnimation = true;
      });
      
      // ✨ Animasyonu başlat
      _animationController.forward();
      
    } catch (e) {
      debugPrint('❌ AI Analiz hatası: $e');
      setState(() => _isLoadingAI = false);
    }
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
                    // Header - Premium Design
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.analytics_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gelişim Raporu',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Öğrenme yolculuğunu takip et',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Genel İstatistikler
                    _buildOverviewCard(),
                    
                    const SizedBox(height: 24),
                    
                    // 🎨 P0: YETENEK RADARI (YENİ!)
                    if (_userDNA != null)
                      SkillRadarWidget(
                        topicPerformance: _userDNA!.topicPerformance,
                        subTopicPerformance: _userDNA!.subTopicPerformance,
                      ),
                    
                    if (_userDNA != null)
                      const SizedBox(height: 24),
                    
                    // 📊 P0: HATA ANALİZİ (YENİ!)
                    if (_userDNA != null)
                      ErrorBreakdownWidget(
                        errorPatterns: _userDNA!.errorPatterns,
                        weakTopics: _userDNA!.weakTopics,
                      ),
                    
                    if (_userDNA != null)
                      const SizedBox(height: 24),
                    
                    // 🔥 P1: STREAK CELEBRATION (YENİ!)
                    if (_insights != null)
                      StreakCelebrationWidget(
                        currentStreak: _insights!.currentStreak,
                        longestStreak: _insights!.currentStreak, // TODO: Track longest
                        thisWeekQuestions: _insights!.thisWeekQuestions,
                      ),
                    
                    if (_insights != null)
                      const SizedBox(height: 24),
                    
                    // 📅 P1: AKTİVİTE HEATMAP (YENİ!)
                    if (_dailySnapshots.isNotEmpty)
                      ActivityHeatmapWidget(
                        snapshots: _dailySnapshots,
                      ),
                    
                    if (_dailySnapshots.isNotEmpty)
                      const SizedBox(height: 24),
                    
                    // ⏳ P2: BİLGİ DECAY GÖSTERGESİ (YENİ!)
                    if (_userDNA != null && _userDNA!.subTopicPerformance.isNotEmpty)
                      KnowledgeDecayWidget(
                        subTopicPerformance: _userDNA!.subTopicPerformance,
                      ),
                    
                    if (_userDNA != null && _userDNA!.subTopicPerformance.isNotEmpty)
                      const SizedBox(height: 24),
                    
                    // 🧠 P2: BİLİŞSEL YÜK METRESİ (YENİ!)
                    if (_insights != null)
                      CognitiveLoadWidget(
                        currentLoad: _insights!.recentCognitiveLoad,
                        recentHintsUsed: _todaySnapshot?.hintsUsed ?? 0,
                        recentWrongAnswers: _todaySnapshot != null 
                            ? (_todaySnapshot!.questionsAttempted - _todaySnapshot!.questionsCorrect)
                            : 0,
                        averageTimePerQuestion: _insights!.averageSessionDuration * 60,
                      ),
                    
                    if (_insights != null)
                      const SizedBox(height: 24),
                    
                    // ⚠️ P2: BIRAKMA NOKTASI UYARISI (YENİ!)
                    if (_userDNA != null && _userDNA!.abandonmentPoints.isNotEmpty)
                      AbandonmentWarningWidget(
                        abandonmentPoints: _userDNA!.abandonmentPoints,
                        similarQuestionCompletionRate: _userDNA!.similarQuestionCompletionRate,
                      ),
                    
                    if (_userDNA != null && _userDNA!.abandonmentPoints.isNotEmpty)
                      const SizedBox(height: 24),
                    
                    // 📊 Bugün Kartı
                    if (_todaySnapshot != null)
                      _buildTodayCard(),
                    
                    if (_todaySnapshot != null)
                      const SizedBox(height: 20),
                    
                    // 📈 Gelişim Grafiği
                    if (_progressData.isNotEmpty)
                      _buildProgressChart(),
                    
                    if (_progressData.isNotEmpty)
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
      title: '🔍 Sherlock Analizi',
      icon: Icons.psychology,
      iconColor: AppTheme.accentColor,
      child: Column(
        children: [
          if (_masterAnalysis != null)
            // ✨ Animasyonlu Premium İçerik
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_fadeAnimation),
                child: _buildPremiumAnalysisContent(),
              ),
            )
          else
            _buildAnalysisButton(),
        ],
      ),
    );
  }

  /// 🎯 Premium Analiz İçeriği
  Widget _buildPremiumAnalysisContent() {
    final analysis = _masterAnalysis!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔍 TEMEL BULGU KARTI
        Container(
          width: double.infinity,
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
                  Text(
                    analysis.headlineEmoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      analysis.headline,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ✨ Animasyonlu Güven Skoru Badge
              Row(
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: analysis.confidenceScore),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getConfidenceColor(value).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '🎯 Güven: %$value',
                          style: TextStyle(
                            color: _getConfidenceColor(value),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      analysis.rootCauseTag,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                analysis.deepAnalysis,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 📊 KONU BREAKDOWN
        if (analysis.topicBreakdown.isNotEmpty) ...[
          const Text(
            '📊 Konu Analizi',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...analysis.topicBreakdown.map((topic) => _buildTopicBreakdownItem(topic)),
          const SizedBox(height: 16),
        ],
        
        // 🎯 AKSİYON PLANI
        if (analysis.actionPlan.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🚀 3 Adımlık Aksiyon Planı',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...analysis.actionPlan.map((step) => _buildActionStepItem(step)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // 💡 MOTİVASYON
        if (analysis.motivationQuote.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('💪', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    analysis.motivationQuote,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Yeniden Analiz Butonu
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoadingAI ? null : _loadAIAnalysis,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Yeniden Analiz Et'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accentColor,
              side: BorderSide(color: AppTheme.accentColor.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }

  /// 📊 Konu Breakdown Item
  Widget _buildTopicBreakdownItem(TopicBreakdown topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(topic.statusEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.topic,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  topic.comment,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getSuccessColor(topic.successRate / 100).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '%${topic.successRate.toInt()}',
              style: TextStyle(
                color: _getSuccessColor(topic.successRate / 100),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎯 Aksiyon Step Item
  Widget _buildActionStepItem(ActionStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.successColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${step.step}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.task,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '⏱️ ${step.durationMinutes} dk',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(step.priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        step.priority.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(step.priority),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Analiz Butonu (İlk durum)
  Widget _buildAnalysisButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.psychology,
            size: 48,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          const Text(
            '🔍 Sherlock Holmes Analizi',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yapay zeka ile öğrenme profilini analiz et ve kişiselleştirilmiş öneriler al',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
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
              _isLoadingAI ? 'Analiz yapılıyor...' : 'Analizi Başlat (40 💎)',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Güven skoru rengi
  Color _getConfidenceColor(int score) {
    if (score >= 80) return AppTheme.successColor;
    if (score >= 60) return AppTheme.warningColor;
    return Colors.red;
  }

  /// Öncelik rengi
  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'bugün':
        return Colors.red;
      case 'yarın':
        return AppTheme.warningColor;
      default:
        return AppTheme.primaryColor;
    }
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
