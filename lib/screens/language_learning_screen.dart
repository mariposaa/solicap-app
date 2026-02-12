/// SOLICAP - Dil Öğrenme Ekranı
/// 3 sekmeli yapı: Dil Öğrenme, YDS Test, Test Analiz

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/yds_models.dart';
import '../services/yds_service.dart';
import '../services/points_service.dart';
import 'my_notes_screen.dart';
import 'language_dashboard_screen.dart';

class LanguageLearningScreen extends StatefulWidget {
  const LanguageLearningScreen({super.key});

  @override
  State<LanguageLearningScreen> createState() => _LanguageLearningScreenState();
}

class _LanguageLearningScreenState extends State<LanguageLearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final YdsService _ydsService = YdsService();
  YdsProgress? _progress;
  bool _isLoading = true;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _init();
  }

  Future<void> _init() async {
    await _ydsService.initialize();
    final progress = await _ydsService.getProgress();
    if (mounted) {
      setState(() {
        _progress = progress;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProgress() async {
    final progress = await _ydsService.getProgress();
    if (mounted) setState(() => _progress = progress);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: Text(
          'Dil Öğren & Sınava Hazırlan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 15 : 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: _isSmallScreen ? 12 : 14),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: _isSmallScreen ? 12 : 14),
          tabs: const [
            Tab(icon: Icon(Icons.menu_book_rounded, size: 20), text: 'Dil Öğrenme'),
            Tab(icon: Icon(Icons.quiz_outlined, size: 20), text: 'YDS Test'),
            Tab(icon: Icon(Icons.analytics_outlined, size: 20), text: 'Test Analiz'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDilOgrenmeTab(),
                _buildYdsTestTab(),
                _buildTestAnalizTab(),
              ],
            ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SEKME 1: DİL ÖĞRENME (şimdilik boş)
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDilOgrenmeTab() {
    return const LanguageDashboard();
  }

  // ═══════════════════════════════════════════════════════════════
  // SEKME 2: YDS TEST
  // ═══════════════════════════════════════════════════════════════

  Widget _buildYdsTestTab() {
    final progress = _progress;
    if (progress == null) return const SizedBox.shrink();

    final currentFaz = progress.currentFaz;
    final currentStage = progress.currentStage;
    final faz = YdsFaz.getFaz(currentFaz);

    // Tüm fazlar bitti mi?
    if (currentStage == 'completed' && currentFaz == 3) {
      return _buildAllCompletedView();
    }

    // Hangi test gösterilecek?
    final isBaslangic = currentStage == 'baslangic_test';
    final isBitirme = currentStage == 'bitirme_test';
    final isInAnalysis = currentStage == 'baslangic_analiz' || currentStage == 'bitirme_analiz';

    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Faz başlığı
          _buildFazHeader(faz, currentStage),
          SizedBox(height: _isSmallScreen ? 12 : 20),

          // Faz ilerleme barı
          _buildFazProgressBar(progress),
          SizedBox(height: _isSmallScreen ? 16 : 24),

          // Konu listesi
          _buildTopicList(faz),
          SizedBox(height: _isSmallScreen ? 16 : 24),

          // Test butonu veya durum mesajı
          if (isBaslangic)
            _buildTestStartButton(
              title: 'Faz $currentFaz - Başlangıç Testi',
              subtitle: '15 orta düzey soru',
              difficulty: 'orta',
              fazNumber: currentFaz,
              testType: 'baslangic',
            ),
          if (isBitirme)
            _buildTestStartButton(
              title: 'Faz $currentFaz - Bitirme Testi',
              subtitle: '15 zor düzey soru',
              difficulty: 'zor',
              fazNumber: currentFaz,
              testType: 'bitirme',
            ),
          if (isInAnalysis)
            _buildGoToAnalysisButton(),
        ],
      ),
    );
  }

  Widget _buildFazHeader(YdsFaz faz, String stage) {
    String stageText;
    IconData stageIcon;
    switch (stage) {
      case 'baslangic_test':
        stageText = 'Başlangıç Testi';
        stageIcon = Icons.play_arrow_rounded;
        break;
      case 'baslangic_analiz':
        stageText = 'Eksik Konularını Öğren';
        stageIcon = Icons.school_rounded;
        break;
      case 'bitirme_test':
        stageText = 'Bitirme Testi';
        stageIcon = Icons.emoji_events_rounded;
        break;
      case 'bitirme_analiz':
        stageText = 'Son Analiz';
        stageIcon = Icons.analytics_rounded;
        break;
      default:
        stageText = 'Tamamlandı';
        stageIcon = Icons.check_circle;
    }

    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B5E20).withOpacity(0.15),
            const Color(0xFF2E7D32).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(_isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(stageIcon, color: const Color(0xFF2E7D32), size: _isSmallScreen ? 20 : 24),
              ),
              SizedBox(width: _isSmallScreen ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faz ${faz.fazNumber}: ${faz.title}',
                      style: TextStyle(
                        fontSize: _isSmallScreen ? 15 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stageText,
                      style: TextStyle(
                        fontSize: _isSmallScreen ? 12 : 14,
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: _isSmallScreen ? 8 : 12),
          Text(
            faz.description,
            style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFazProgressBar(YdsProgress progress) {
    // 3 faz * 2 aşama (başlangıç + bitirme) = 6 adım
    int completedSteps = 0;
    for (int i = 1; i <= 3; i++) {
      final fp = progress.fazProgresses[i];
      if (fp != null) {
        if (fp.baslangicCardsCompleted) completedSteps++;
        if (fp.bitirmeCardsCompleted) completedSteps++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Genel İlerleme',
              style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            Text(
              '$completedSteps / 6',
              style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completedSteps / 6,
            backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
            color: const Color(0xFF2E7D32),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTopicList(YdsFaz faz) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konular',
          style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
        SizedBox(height: _isSmallScreen ? 8 : 12),
        ...faz.topics.asMap().entries.map((entry) {
          final index = entry.key;
          final topic = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: _isSmallScreen ? 6 : 8),
            padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: _isSmallScreen ? 11 : 13,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: _isSmallScreen ? 8 : 12),
                Expanded(
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontSize: _isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTestStartButton({
    required String title,
    required String subtitle,
    required String difficulty,
    required int fazNumber,
    required String testType,
  }) {
    final questions = _ydsService.getQuestions(
      fazNumber: fazNumber,
      difficulty: difficulty,
    );

    final hasQuestions = questions.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasQuestions
            ? () => _startTest(fazNumber, testType, difficulty, questions)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hasQuestions ? title : '$title (Sorular yükleniyor...)',
                  style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: _isSmallScreen ? 6 : 8),
                Icon(Icons.diamond, size: _isSmallScreen ? 14 : 16, color: Colors.amber),
                Text(
                  ' ${PointsService.costs['yds_test']}',
                  style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoToAnalysisButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _tabController.animateTo(2),
        icon: const Icon(Icons.analytics_outlined),
        label: const Text('Test Analiz bölümüne git'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildAllCompletedView() {
    final progress = _progress;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 12 : 20, vertical: _isSmallScreen ? 16 : 24),
      child: Column(
        children: [
          // ── Tebrik Bölümü ──
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 16 : 24),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.emoji_events, size: _isSmallScreen ? 50 : 64, color: Colors.amber),
          ),
          SizedBox(height: _isSmallScreen ? 12 : 20),
          Text(
            'Tebrikler!',
            style: TextStyle(fontSize: _isSmallScreen ? 22 : 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Tüm YDS fazlarını başarıyla tamamladın!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textSecondary, height: 1.5),
          ),

          SizedBox(height: _isSmallScreen ? 16 : 28),

          // ── İstatistik Özet ──
          if (progress != null) _buildStatsSection(progress),

          SizedBox(height: _isSmallScreen ? 16 : 24),

          // ── Notlarıma Git Butonu ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyNotesScreen()),
                );
              },
              icon: const Icon(Icons.menu_book_rounded, size: 20),
              label: const Text('Notlarıma Git'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          SizedBox(height: _isSmallScreen ? 8 : 12),

          // ── Tekrar Çöz Butonu ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showResetConfirmDialog(),
              icon: Icon(Icons.refresh_rounded, size: _isSmallScreen ? 18 : 20),
              label: const Text('Baştan Çöz'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textSecondary,
                side: BorderSide(color: AppTheme.textMuted.withOpacity(0.3)),
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── İstatistik kartları ──
  Widget _buildStatsSection(YdsProgress progress) {
    int totalCorrect = 0;
    int totalWrong = 0;
    final fazStats = <int, Map<String, int>>{};

    for (int faz = 1; faz <= 3; faz++) {
      final fp = progress.fazProgresses[faz];
      int fazCorrect = 0;
      int fazWrong = 0;

      if (fp?.baslangicTestResult != null) {
        fazCorrect += fp!.baslangicTestResult!.totalCorrect;
        fazWrong += fp.baslangicTestResult!.totalWrong;
      }
      if (fp?.bitirmeTestResult != null) {
        fazCorrect += fp!.bitirmeTestResult!.totalCorrect;
        fazWrong += fp.bitirmeTestResult!.totalWrong;
      }

      fazStats[faz] = {'correct': fazCorrect, 'wrong': fazWrong};
      totalCorrect += fazCorrect;
      totalWrong += fazWrong;
    }

    final totalQuestions = totalCorrect + totalWrong;
    final overallScore = totalQuestions > 0 ? (totalCorrect / totalQuestions * 100) : 0.0;

    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: const Color(0xFF4CAF50), size: _isSmallScreen ? 18 : 22),
              SizedBox(width: _isSmallScreen ? 6 : 8),
              Text(
                'Genel İstatistik',
                style: TextStyle(fontSize: _isSmallScreen ? 15 : 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          SizedBox(height: _isSmallScreen ? 10 : 16),

          // Genel skor çubuğu
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: overallScore / 100,
                    minHeight: 10,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      overallScore >= 70 ? const Color(0xFF4CAF50) : overallScore >= 40 ? Colors.orange : Colors.redAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(width: _isSmallScreen ? 8 : 12),
              Text(
                '%${overallScore.toStringAsFixed(0)}',
                style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
            ],
          ),
          SizedBox(height: _isSmallScreen ? 6 : 8),
          Text(
            '6 testte toplam $totalCorrect doğru, $totalWrong yanlış',
            style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textMuted),
          ),

          SizedBox(height: _isSmallScreen ? 10 : 16),
          Divider(color: Colors.white.withOpacity(0.06)),
          SizedBox(height: _isSmallScreen ? 8 : 12),

          // Faz bazlı detaylar
          for (int faz = 1; faz <= 3; faz++) ...[
            _buildFazStatRow(faz, fazStats[faz]!),
            if (faz < 3) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildFazStatRow(int faz, Map<String, int> stats) {
    final correct = stats['correct'] ?? 0;
    final wrong = stats['wrong'] ?? 0;
    final total = correct + wrong;
    final pct = total > 0 ? (correct / total * 100) : 0.0;

    return Row(
      children: [
        Container(
          width: _isSmallScreen ? 36 : 42,
          height: _isSmallScreen ? 36 : 42,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            'F$faz',
            style: TextStyle(color: const Color(0xFF4CAF50), fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 14),
          ),
        ),
        SizedBox(width: _isSmallScreen ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faz $faz',
                style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: _isSmallScreen ? 12 : 14),
              ),
              const SizedBox(height: 2),
              Text(
                '$correct doğru / $wrong yanlış',
                style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 10 : 12),
              ),
            ],
          ),
        ),
        Text(
          '%${pct.toStringAsFixed(0)}',
          style: TextStyle(
            color: pct >= 70 ? const Color(0xFF4CAF50) : pct >= 40 ? Colors.orange : Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: _isSmallScreen ? 13 : 15,
          ),
        ),
      ],
    );
  }

  // ── Sıfırlama Onay Diyaloğu ──
  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Baştan Çöz',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Tüm YDS ilerleme verilerin sıfırlanacak ve Faz 1\'den tekrar başlayacaksın.\n\nNotlarına kaydedilen kartlar silinmez.',
          style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isLoading = true);
              await _ydsService.resetProgress();
              await _init();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Sıfırla'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SEKME 3: TEST ANALİZ
  // ═══════════════════════════════════════════════════════════════

  Widget _buildTestAnalizTab() {
    final progress = _progress;
    if (progress == null) return const SizedBox.shrink();

    // Analiz sekmesi kilitli mi?
    if (!progress.isAnalysisUnlocked) {
      return _buildLockedAnalysisView();
    }

    final currentStage = progress.currentStage;
    final isInAnalysis = currentStage == 'baslangic_analiz' || currentStage == 'bitirme_analiz';

    if (!isInAnalysis) {
      // Analiz aşamasında değil - beklemede
      return _buildAnalysisWaitingView(progress);
    }

    // Aktif analiz - yanlış konuları getir
    final fazProgress = progress.fazProgresses[progress.currentFaz];
    final YdsTestResult? testResult;
    final String testType;

    if (currentStage == 'baslangic_analiz') {
      testResult = fazProgress?.baslangicTestResult;
      testType = 'baslangic';
    } else {
      testResult = fazProgress?.bitirmeTestResult;
      testType = 'bitirme';
    }

    if (testResult == null || testResult.wrongTopics.isEmpty) {
      // Yanlış yok - direkt geç
      return _buildPerfectScoreView(progress, testType);
    }

    // Elmas ödenmeden önce önizleme + başlat butonu göster
    if (!_analysisStarted) {
      return _buildAnalysisPreview(testResult, progress.currentFaz, testType);
    }

    return _YdsAnalysisCards(
      wrongTopics: testResult.wrongTopics,
      fazNumber: progress.currentFaz,
      testType: testType,
      testResult: testResult,
      ydsService: _ydsService,
      onComplete: () async {
        await _refreshProgress();
        if (mounted) {
          setState(() => _analysisStarted = false);
          _tabController.animateTo(1); // YDS Test sekmesine geri dön
        }
      },
    );
  }

  bool _analysisStarted = false;

  Widget _buildAnalysisPreview(YdsTestResult result, int fazNumber, String testType) {
    final faz = YdsFaz.getFaz(fazNumber);
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 16 : 24),
      child: Column(
        children: [
          SizedBox(height: _isSmallScreen ? 12 : 20),
          // Sonuç özeti
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF1B5E20).withOpacity(0.1), const Color(0xFF2E7D32).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Faz $fazNumber: ${faz.title}',
                  style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Text(
                  testType == 'baslangic' ? 'Başlangıç Testi Sonucu' : 'Bitirme Testi Sonucu',
                  style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textSecondary),
                ),
                SizedBox(height: _isSmallScreen ? 10 : 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBox('${result.totalCorrect}', 'Doğru', const Color(0xFF2E7D32)),
                    _buildStatBox('${result.totalWrong}', 'Yanlış', Colors.red),
                    _buildStatBox('%${result.score.toInt()}', 'Başarı', result.score >= 70 ? const Color(0xFF2E7D32) : Colors.orange),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: _isSmallScreen ? 12 : 20),

          // Yanlış konular listesi
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eksik Konuların:',
                  style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                SizedBox(height: _isSmallScreen ? 8 : 10),
                ...result.wrongTopics.map((topic) => Padding(
                  padding: EdgeInsets.only(bottom: _isSmallScreen ? 4 : 6),
                  child: Row(
                    children: [
                      Icon(Icons.close, color: Colors.red, size: _isSmallScreen ? 16 : 18),
                      SizedBox(width: _isSmallScreen ? 6 : 8),
                      Text(topic, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textPrimary)),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: _isSmallScreen ? 8 : 12),

          SizedBox(height: _isSmallScreen ? 16 : 24),

          // 💎 Analizi Başlat butonu (elmas kontrolü)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final pointsService = PointsService();
                final canProceed = await pointsService.checkAndSpendPoints(
                  context,
                  'yds_analysis',
                  description: 'YDS Faz $fazNumber Test Analiz',
                );
                if (!canProceed || !mounted) return;
                setState(() => _analysisStarted = true);
              },
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.analytics_outlined, size: _isSmallScreen ? 18 : 20),
                  SizedBox(width: _isSmallScreen ? 2 : 4),
                  Icon(Icons.diamond, size: _isSmallScreen ? 14 : 16, color: Colors.amber),
                  SizedBox(width: 2),
                  Text(
                    '${PointsService.costs['yds_analysis']}',
                    style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              label: Text('Analizi Başlat', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
            ),
          ),
          SizedBox(height: _isSmallScreen ? 8 : 12),
          Text(
            'Yanlış yaptığın sorulara göre sana özel YDS tüyoları ve konu anlatımı yapılacak.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textSecondary, height: 1.4),
          ),
          SizedBox(height: _isSmallScreen ? 24 : 40),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: _isSmallScreen ? 22 : 28, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: AppTheme.textMuted)),
      ],
    );
  }

  Widget _buildLockedAnalysisView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 16 : 24),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange.withOpacity(0.3), width: 2),
              ),
              child: Icon(Icons.lock_outline, size: _isSmallScreen ? 38 : 48, color: Colors.orange),
            ),
            SizedBox(height: _isSmallScreen ? 16 : 24),
            Text(
              'Test Analiz Kilitli',
              style: TextStyle(fontSize: _isSmallScreen ? 18 : 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 16),
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: Text(
                'YDS Test bölümünden ilk testi çöz ve eksiklerini görerek konuları öğrenelim.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textSecondary, height: 1.5),
              ),
            ),
            SizedBox(height: _isSmallScreen ? 16 : 24),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('YDS Test\'e Git'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 16 : 24, vertical: _isSmallScreen ? 12 : 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisWaitingView(YdsProgress progress) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: _isSmallScreen ? 38 : 48, color: AppTheme.textMuted),
            SizedBox(height: _isSmallScreen ? 12 : 20),
            Text(
              'Bir sonraki testi tamamla',
              style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Faz ${progress.currentFaz} testini çözdüğünde burada analiz göreceksin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfectScoreView(YdsProgress progress, String testType) {
    final isBaslangic = testType == 'baslangic';
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: _isSmallScreen ? 50 : 64, color: Colors.amber),
            SizedBox(height: _isSmallScreen ? 12 : 20),
            Text(
              'Mükemmel! 🎉',
              style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Hiç yanlışın yok! Harika bir performans.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textSecondary),
            ),
            SizedBox(height: _isSmallScreen ? 16 : 24),
            ElevatedButton(
              onPressed: () async {
                await _ydsService.completeAnalysisCards(
                  fazNumber: progress.currentFaz,
                  testType: testType,
                );
                await _refreshProgress();
                if (mounted) _tabController.animateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 20 : 32, vertical: _isSmallScreen ? 12 : 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isBaslangic ? 'Bitirme Testine Geç' : 'Sonraki Faza Geç',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TEST BAŞLATMA
  // ═══════════════════════════════════════════════════════════════

  Future<void> _startTest(int fazNumber, String testType, String difficulty, List<YdsQuestion> questions) async {
    // 💎 Elmas kontrolü
    final pointsService = PointsService();
    final canProceed = await pointsService.checkAndSpendPoints(
      context,
      'yds_test',
      description: 'YDS Faz $fazNumber ${testType == 'baslangic' ? 'Başlangıç' : 'Bitirme'} Testi',
    );
    if (!canProceed || !mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _YdsTestScreen(
          fazNumber: fazNumber,
          testType: testType,
          questions: questions,
          ydsService: _ydsService,
          onTestComplete: (result) async {
            // Firebase'den okumaya çalış
            await _refreshProgress();

            // Eğer Firebase başarısız olduysa, lokal olarak güncelle
            if (_progress != null && !_progress!.isAnalysisUnlocked) {
              debugPrint('⚠️ Firebase progress okunamadı, lokal güncelleme yapılıyor...');
              final fazProgress = _progress!.fazProgresses[fazNumber] ?? const YdsFazProgress();
              YdsFazProgress updatedFazProgress;
              if (testType == 'baslangic') {
                updatedFazProgress = fazProgress.copyWith(baslangicTestResult: result);
              } else {
                updatedFazProgress = fazProgress.copyWith(bitirmeTestResult: result);
              }
              final updatedProgress = _progress!
                  .updateFazProgress(fazNumber, updatedFazProgress)
                  .advanceStage();
              setState(() => _progress = updatedProgress);
            }

            if (mounted) {
              _tabController.animateTo(2); // Test Analiz'e yönlendir
            }
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TEST EKRANI (15 soru ekranı)
// ═══════════════════════════════════════════════════════════════

class _YdsTestScreen extends StatefulWidget {
  final int fazNumber;
  final String testType;
  final List<YdsQuestion> questions;
  final YdsService ydsService;
  final Function(YdsTestResult) onTestComplete;

  const _YdsTestScreen({
    required this.fazNumber,
    required this.testType,
    required this.questions,
    required this.ydsService,
    required this.onTestComplete,
  });

  @override
  State<_YdsTestScreen> createState() => _YdsTestScreenState();
}

class _YdsTestScreenState extends State<_YdsTestScreen> {
  int _currentQuestion = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> answerIndex

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  YdsQuestion get currentQ => widget.questions[_currentQuestion];
  bool get isLastQuestion => _currentQuestion == widget.questions.length - 1;
  bool get hasSelectedAnswer => _selectedAnswers.containsKey(_currentQuestion);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        title: Text(
          'Faz ${widget.fazNumber} - ${widget.testType == 'baslangic' ? 'Başlangıç' : 'Bitirme'}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentQuestion + 1) / widget.questions.length,
            backgroundColor: Colors.white24,
            color: Colors.greenAccent,
            minHeight: 6,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Soru numarası
            Padding(
              padding: EdgeInsets.fromLTRB(_isSmallScreen ? 12 : 20, _isSmallScreen ? 10 : 16, _isSmallScreen ? 12 : 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soru ${_currentQuestion + 1} / ${widget.questions.length}',
                    style: TextStyle(
                      fontSize: _isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 8 : 10, vertical: _isSmallScreen ? 2 : 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentQ.topic,
                      style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: const Color(0xFF2E7D32), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // Soru içeriği
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Passage varsa göster
                    if (currentQ.passage != null && currentQ.passage!.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          currentQ.passage!,
                          style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, height: 1.6, color: AppTheme.textPrimary),
                        ),
                      ),
                      SizedBox(height: _isSmallScreen ? 10 : 16),
                    ],

                    // Soru metni
                    Text(
                      currentQ.questionText,
                      style: TextStyle(
                        fontSize: _isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: _isSmallScreen ? 12 : 20),

                    // Şıklar
                    ...currentQ.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected = _selectedAnswers[_currentQuestion] == index;
                      final label = String.fromCharCode(65 + index); // A, B, C, D, E

                      return GestureDetector(
                        onTap: () => setState(() => _selectedAnswers[_currentQuestion] = index),
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
                          padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2E7D32).withOpacity(0.1)
                                : AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2E7D32) : AppTheme.dividerColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2E7D32)
                                      : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: _isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: _isSmallScreen ? 8 : 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: _isSmallScreen ? 12 : 14,
                                    color: isSelected ? const Color(0xFF1B5E20) : AppTheme.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Alt butonlar
            Container(
              padding: EdgeInsets.fromLTRB(_isSmallScreen ? 12 : 20, _isSmallScreen ? 8 : 12, _isSmallScreen ? 12 : 20, _isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestion > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentQuestion--),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32),
                          side: const BorderSide(color: Color(0xFF2E7D32)),
                          padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Önceki', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  if (_currentQuestion > 0) SizedBox(width: _isSmallScreen ? 8 : 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: hasSelectedAnswer
                          ? () {
                              if (isLastQuestion) {
                                _completeTest();
                              } else {
                                setState(() => _currentQuestion++);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isLastQuestion ? 'Tamamla' : 'Sonraki',
                        style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeTest() async {
    // Tüm cevapları topla
    final answers = <YdsAnswer>[];
    for (int i = 0; i < widget.questions.length; i++) {
      final q = widget.questions[i];
      final selected = _selectedAnswers[i] ?? 0;
      answers.add(YdsAnswer(
        questionId: q.id,
        topic: q.topic,
        selectedAnswer: selected,
        correctAnswer: q.correctAnswer,
        isCorrect: selected == q.correctAnswer,
      ));
    }

    // Sonucu kaydet
    final result = await widget.ydsService.completeTest(
      fazNumber: widget.fazNumber,
      testType: widget.testType,
      answers: answers,
    );

    if (mounted) {
      Navigator.pop(context); // Test ekranından çık
      widget.onTestComplete(result);
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// ANALİZ KARTLARI (AI üretimli konu anlatımları)
// ═══════════════════════════════════════════════════════════════

class _YdsAnalysisCards extends StatefulWidget {
  final List<String> wrongTopics;
  final int fazNumber;
  final String testType;
  final YdsTestResult testResult;
  final YdsService ydsService;
  final VoidCallback onComplete;

  const _YdsAnalysisCards({
    required this.wrongTopics,
    required this.fazNumber,
    required this.testType,
    required this.testResult,
    required this.ydsService,
    required this.onComplete,
  });

  @override
  State<_YdsAnalysisCards> createState() => _YdsAnalysisCardsState();
}

class _YdsAnalysisCardsState extends State<_YdsAnalysisCards> {
  List<YdsTopicCard>? _cards;
  bool _isLoading = true;
  int _currentCardIndex = 0;
  bool _allCompleted = false;
  bool _savedToNotes = false;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    // Yanlış soruların hata tiplerini topla
    final errorDetails = <String, List<String>>{};
    final allQuestions = widget.ydsService.getQuestions(
      fazNumber: widget.fazNumber,
      difficulty: widget.testType == 'baslangic' ? 'orta' : 'zor',
    );
    for (final answer in widget.testResult.answers.where((a) => !a.isCorrect)) {
      try {
        final question = allQuestions.firstWhere((q) => q.id == answer.questionId);
        errorDetails.putIfAbsent(answer.topic, () => []).add(question.explanation);
      } catch (_) {}
    }

    final cards = await widget.ydsService.generateTopicCards(
      widget.wrongTopics,
      errorDetails: errorDetails,
    );
    if (mounted) {
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    }
  }

  void _markAsLearned() {
    if (_cards == null) return;

    setState(() {
      _cards![_currentCardIndex] = _cards![_currentCardIndex].copyWith(isCompleted: true);

      if (_currentCardIndex < _cards!.length - 1) {
        _currentCardIndex++;
      } else {
        _allCompleted = true;
      }
    });
  }

  Future<void> _saveAndContinue() async {
    if (_cards == null) return;

    // Notlara kaydet
    await widget.ydsService.saveCardsToNotes(
      fazNumber: widget.fazNumber,
      testType: widget.testType,
      cards: _cards!,
    );

    // İlerlemeyi güncelle
    await widget.ydsService.completeAnalysisCards(
      fazNumber: widget.fazNumber,
      testType: widget.testType,
    );

    setState(() => _savedToNotes = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            Text(
              'AI konu kartları hazırlanıyor...',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '30 saniye içinde hazır',
              style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 13),
            ),
          ],
        ),
      );
    }

    if (_cards == null || _cards!.isEmpty) {
      return const Center(child: Text('Kart üretilemedi.'));
    }

    // Tamamlanma sonrası
    if (_allCompleted && _savedToNotes) {
      return _buildCompletionView();
    }

    if (_allCompleted) {
      return _buildSaveView();
    }

    // Aktif kart gösterimi
    final card = _cards![_currentCardIndex];
    return _buildCardView(card);
  }

  Widget _buildCardView(YdsTopicCard card) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sonuç özeti
          _buildResultSummary(),
          SizedBox(height: _isSmallScreen ? 12 : 20),

          // Kart ilerleme
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Konu ${_currentCardIndex + 1} / ${_cards!.length}',
                style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32)),
              ),
              Text(
                '${_cards!.where((c) => c.isCompleted).length} tamamlandı',
                style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          SizedBox(height: _isSmallScreen ? 6 : 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _cards!.where((c) => c.isCompleted).length / _cards!.length,
              backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
              color: const Color(0xFF2E7D32),
              minHeight: 6,
            ),
          ),
          SizedBox(height: _isSmallScreen ? 12 : 20),

          // Konu kartı
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Konu başlığı
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(_isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.error_outline, color: Colors.red, size: _isSmallScreen ? 18 : 20),
                    ),
                    SizedBox(width: _isSmallScreen ? 8 : 12),
                    Expanded(
                      child: Text(
                        card.topic,
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 15 : 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: _isSmallScreen ? 16 : 24),

                // AI anlatımı
                Text(
                  card.explanation,
                  style: TextStyle(
                    fontSize: _isSmallScreen ? 12 : 14,
                    color: AppTheme.textPrimary,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _isSmallScreen ? 16 : 24),

          // Öğrendim butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _markAsLearned,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                'Tamamladım / Öğrendim',
                style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
            ),
          ),
          SizedBox(height: _isSmallScreen ? 24 : 40),
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    final result = widget.testResult;
    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.08), Colors.orange.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '${result.totalCorrect}',
                style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
              ),
              Text('Doğru', style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: AppTheme.textMuted)),
            ],
          ),
          SizedBox(width: _isSmallScreen ? 16 : 24),
          Column(
            children: [
              Text(
                '${result.totalWrong}',
                style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Text('Yanlış', style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: AppTheme.textMuted)),
            ],
          ),
          const Spacer(),
          Text(
            '%${result.score.toInt()}',
            style: TextStyle(
              fontSize: _isSmallScreen ? 22 : 28,
              fontWeight: FontWeight.bold,
              color: result.score >= 70 ? const Color(0xFF2E7D32) : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: _isSmallScreen ? 50 : 64, color: const Color(0xFF2E7D32)),
            SizedBox(height: _isSmallScreen ? 12 : 20),
            Text(
              'Tüm Kartlar Tamamlandı!',
              style: TextStyle(fontSize: _isSmallScreen ? 18 : 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            SizedBox(height: _isSmallScreen ? 8 : 12),
            Text(
              'Kartlar Notlarım bölümüne kaydedilecek.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary),
            ),
            SizedBox(height: _isSmallScreen ? 20 : 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveAndContinue,
                icon: const Icon(Icons.save_alt),
                label: const Text('Kaydet ve Devam Et', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionView() {
    final progress = widget.fazNumber;
    final isBaslangic = widget.testType == 'baslangic';
    final nextText = isBaslangic
        ? 'Faz $progress Bitirme Testine Hazır mısın?'
        : (progress < 3 ? 'Faz ${progress + 1}\'e Geçmeye Hazır mısın?' : 'Tüm Fazlar Tamamlandı!');

    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bookmark_added, size: _isSmallScreen ? 38 : 48, color: const Color(0xFF2E7D32)),
            ),
            SizedBox(height: _isSmallScreen ? 12 : 20),
            Text(
              'Notlarına Kaydedildi! 📝',
              style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            SizedBox(height: _isSmallScreen ? 16 : 24),
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
              ),
              child: Text(
                nextText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _isSmallScreen ? 15 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ),
            SizedBox(height: _isSmallScreen ? 16 : 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 12 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'Tamam, Hazırım!',
                  style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
