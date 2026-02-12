/// SOLICAP - Gelişim Raporu Ekranı
/// Sınav simülasyonu, konu eksik haritası, haftalık rapor, yol haritası, check-in

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/user_dna_service.dart';
import '../services/session_tracking_service.dart';
import '../services/points_service.dart';
import '../services/gemini_service.dart';
import '../services/note_service.dart';
import '../services/notification_service.dart';
import '../models/user_dna_model.dart';
import '../models/learning_event_model.dart';

// ── Sınav Tarihleri ──
class ExamDate {
  final String name;
  final DateTime date;
  const ExamDate(this.name, this.date);
}

final List<ExamDate> examDates2026 = [
  ExamDate('LGS', DateTime(2026, 6, 7)),
  ExamDate('YKS TYT', DateTime(2026, 6, 20)),
  ExamDate('YKS AYT', DateTime(2026, 6, 21)),
  ExamDate('KPSS', DateTime(2026, 8, 29)),
  ExamDate('DGS', DateTime(2026, 7, 12)),
  ExamDate('ALES', DateTime(2026, 5, 17)),
  ExamDate('TUS', DateTime(2026, 4, 19)),
];

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  final SessionTrackingService _sessionTracker = SessionTrackingService();
  final PointsService _pointsService = PointsService();
  final NoteService _noteService = NoteService();

  UserDNA? _userDNA;
  List<DailyLearningSnapshot> _snapshots = [];
  bool _isLoading = true;
  bool _isGeneratingRoadmap = false;
  bool _isGeneratingCheckin = false;
  String? _roadmapResult;
  String? _checkinResult;
  bool _roadmapNeedUpdate = false;

  final _mockNetController = TextEditingController();
  final _targetNetController = TextEditingController();

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _mockNetController.dispose();
    _targetNetController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final dna = await _dnaService.getDNA();
    final snaps = await _sessionTracker.getRecentSnapshots(days: 7);
    if (mounted) {
      // Son yol haritasını yükle
      final savedRoadmap = dna?.lastRoadmapText;
      final lastDate = dna?.lastRoadmapDate;
      final needUpdate = lastDate == null || DateTime.now().difference(lastDate).inDays >= 7;

      setState(() {
        _userDNA = dna;
        _snapshots = snaps;
        _isLoading = false;
        _roadmapResult = savedRoadmap;
        _roadmapNeedUpdate = needUpdate;
      });
    }
  }

  ExamDate? _getExamDate() {
    final exam = _userDNA?.targetExam;
    if (exam == null) return null;
    final lower = exam.toLowerCase();
    for (final ed in examDates2026) {
      if (lower.contains(ed.name.toLowerCase()) || ed.name.toLowerCase().contains(lower.split(' ').first)) return ed;
    }
    if (lower.contains('yks') || lower.contains('tyt') || lower.contains('ayt')) {
      return examDates2026.firstWhere((e) => e.name == 'YKS TYT');
    }
    return null;
  }

  int? _getDaysRemaining() {
    final ed = _getExamDate();
    if (ed == null) return null;
    return ed.date.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('📊 Gelişim Raporu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 16 : 18)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(_isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExamCountdown(),
                    const SizedBox(height: 14),
                    _buildMockExamInput(),
                    const SizedBox(height: 14),
                    _buildExamSimulation(),
                    const SizedBox(height: 14),
                    _buildWeeklyReport(),
                    const SizedBox(height: 14),
                    _buildTopicGapMap(),
                    const SizedBox(height: 14),
                    _buildRoadmapSection(),
                    const SizedBox(height: 14),
                    _buildCheckinSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 1. SINAV COUNTDOWN
  // ════════════════════════════════════════════════════════════

  Widget _buildExamCountdown() {
    final examDate = _getExamDate();
    final daysLeft = _getDaysRemaining();
    final examName = examDate?.name ?? _userDNA?.targetExam ?? 'Sınav';

    if (daysLeft == null) {
      return _buildCard(
        child: Row(
          children: [
            Icon(Icons.event_note, color: AppTheme.textMuted, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Profil sayfasından hedef sınavını seç',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 13 : 14)),
            ),
          ],
        ),
      );
    }

    final urgencyColor = daysLeft < 30
        ? const Color(0xFFE53935)
        : daysLeft < 90 ? const Color(0xFFFF8F00) : AppTheme.primaryColor;

    return Container(
      padding: EdgeInsets.all(_isSmallScreen ? 14 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [urgencyColor, urgencyColor.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: urgencyColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text('$daysLeft', style: TextStyle(
                  color: Colors.white, fontSize: _isSmallScreen ? 28 : 34, fontWeight: FontWeight.bold)),
                Text('GÜN', style: TextStyle(
                  color: Colors.white70, fontSize: _isSmallScreen ? 10 : 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(width: _isSmallScreen ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⏰ $examName\'a kalan süre',
                  style: TextStyle(color: Colors.white, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${(daysLeft / 7).ceil()} hafta kaldı',
                  style: TextStyle(color: Colors.white70, fontSize: _isSmallScreen ? 12 : 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 2. DENEME SONUCU GİRİŞİ
  // ════════════════════════════════════════════════════════════

  Widget _buildMockExamInput() {
    final lastMock = _userDNA?.lastMockNetScore;
    final lastDate = _userDNA?.lastMockDate;
    final targetNet = _userDNA?.targetNetScore;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Color(0xFFFF8F00), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('📝 Deneme & Hedef Girişi',
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Hedef netini ve son deneme sonucunu gir. Veriler kaydedilir ve gelişimin takip edilir.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          const SizedBox(height: 12),

          if (lastMock != null || targetNet != null)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (targetNet != null) ...[
                    const Icon(Icons.flag, color: Color(0xFF4CAF50), size: 16),
                    const SizedBox(width: 4),
                    Text('Hedef: $targetNet net',
                      style: TextStyle(color: const Color(0xFF2E7D32), fontSize: _isSmallScreen ? 12 : 13, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                  ],
                  if (lastMock != null) ...[
                    const Icon(Icons.history, color: Color(0xFFFF8F00), size: 16),
                    const SizedBox(width: 4),
                    Text('Son: $lastMock net',
                      style: TextStyle(color: const Color(0xFFE65100), fontSize: _isSmallScreen ? 12 : 13, fontWeight: FontWeight.w600)),
                    if (lastDate != null)
                      Text(' (${_formatDate(lastDate)})',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 10 : 11)),
                  ],
                ],
              ),
            ),

          Row(
            children: [
              Expanded(child: _buildInput(controller: _targetNetController, hint: 'Hedef net', icon: Icons.flag_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildInput(controller: _mockNetController, hint: 'Deneme neti', icon: Icons.quiz_outlined)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _saveMockData,
                child: Container(
                  padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.save_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput({required TextEditingController controller, required String hint, required IconData icon}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 13 : 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 12 : 13),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 18),
        filled: true,
        fillColor: AppTheme.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.dividerColor)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.dividerColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),
      ),
    );
  }

  Future<void> _saveMockData() async {
    final targetText = _targetNetController.text.trim();
    final mockText = _mockNetController.text.trim();
    if (targetText.isEmpty && mockText.isEmpty) { _showSnack('En az bir alan doldur', Colors.orange); return; }

    final dna = _userDNA;
    if (dna == null) return;

    int? newTarget = targetText.isNotEmpty ? int.tryParse(targetText) : null;
    int? newMock = mockText.isNotEmpty ? int.tryParse(mockText) : null;

    List<MockExamEntry> updatedHistory = List.from(dna.mockHistory);
    if (newMock != null) {
      updatedHistory.add(MockExamEntry(netScore: newMock, examType: dna.targetExam, date: DateTime.now()));
    }

    final updated = dna.copyWith(
      targetNetScore: newTarget ?? dna.targetNetScore,
      targetNetDetail: newTarget != null ? '${dna.targetExam ?? ''} $newTarget net' : dna.targetNetDetail,
      lastMockNetScore: newMock ?? dna.lastMockNetScore,
      lastMockDate: newMock != null ? DateTime.now() : dna.lastMockDate,
      mockHistory: updatedHistory,
    );

    await _dnaService.saveDNA(updated);
    _targetNetController.clear();
    _mockNetController.clear();
    setState(() => _userDNA = updated);
    _showSnack('✅ Kaydedildi', const Color(0xFF4CAF50));
  }

  // ════════════════════════════════════════════════════════════
  // 3. SINAV SİMÜLASYONU (ÜCRETSİZ)
  // ════════════════════════════════════════════════════════════

  Widget _buildExamSimulation() {
    final dna = _userDNA;
    if (dna == null) return const SizedBox.shrink();

    final targetNet = dna.targetNetScore;
    final lastMock = dna.lastMockNetScore;
    final hasMock = lastMock != null;
    final gap = (targetNet != null && lastMock != null) ? targetNet - lastMock : null;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🎯 Sınav Simülasyonu', Icons.analytics_rounded, const Color(0xFF5C6BC0), badge: 'ÜCRETSİZ'),
          const SizedBox(height: 4),
          Text('Deneme sonuçların üzerinden sınav performansını takip et. Hedefine ne kadar yakınsın gör.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          const SizedBox(height: 14),

          if (!hasMock)
            _buildInfoBox('Deneme sonucunu yukarıdan gir, simülasyon burada görünsün.', Colors.orange)
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCircle('Son\nDeneme', '$lastMock', const Color(0xFF5C6BC0)),
                if (targetNet != null) _buildStatCircle('Hedef\nNet', '$targetNet', const Color(0xFF4CAF50)),
                if (dna.mockHistory.length >= 2)
                  _buildStatCircle('İlk\nDeneme', '${dna.mockHistory.first.netScore}', AppTheme.textMuted),
              ],
            ),
            if (gap != null) ...[
              const SizedBox(height: 12),
              _buildInfoBox(
                gap > 0 ? 'Hedefine $gap net uzaktasın. Devam et!' : 'Hedefinin üstündesin! 🎉',
                gap > 0 ? Colors.orange : const Color(0xFF4CAF50),
              ),
            ],
            if (dna.mockHistory.length >= 2) ...[
              const SizedBox(height: 12),
              _buildMockTrendMini(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatCircle(String label, String value, Color color) {
    final size = _isSmallScreen ? 68.0 : 80.0;
    return Column(
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
            color: color.withOpacity(0.08),
          ),
          alignment: Alignment.center,
          child: Text(value, style: TextStyle(color: color, fontSize: _isSmallScreen ? 22 : 26, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 10 : 11)),
      ],
    );
  }

  Widget _buildMockTrendMini() {
    final history = _userDNA!.mockHistory;
    final sorted = List<MockExamEntry>.from(history)..sort((a, b) => a.date.compareTo(b.date));
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📈 Deneme Gelişimi', style: TextStyle(
            color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 12 : 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: sorted.map((m) {
                final maxNet = sorted.map((e) => e.netScore).reduce((a, b) => a > b ? a : b);
                final ratio = maxNet > 0 ? m.netScore / maxNet : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${m.netScore}', style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 9 : 10)),
                        const SizedBox(height: 2),
                        Container(
                          height: 24 * ratio,
                          decoration: BoxDecoration(color: const Color(0xFF5C6BC0).withOpacity(0.7), borderRadius: BorderRadius.circular(3)),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 4. HAFTALIK RAPOR (ÜCRETSİZ)
  // ════════════════════════════════════════════════════════════

  Widget _buildWeeklyReport() {
    final dna = _userDNA;
    if (dna == null) return const SizedBox.shrink();

    final totalQ = dna.totalQuestionsSolved;
    final correct = dna.totalCorrect;
    final successPct = totalQ > 0 ? (correct / totalQ * 100).round() : 0;

    final thisWeekSnaps = _snapshots.where((s) => DateTime.now().difference(s.date).inDays < 7).toList();
    final weeklyQuestions = thisWeekSnaps.fold<int>(0, (sum, s) => sum + s.questionsAttempted);
    final weeklyCorrect = thisWeekSnaps.fold<int>(0, (sum, s) => sum + s.questionsCorrect);
    final weeklyRate = weeklyQuestions > 0 ? (weeklyCorrect / weeklyQuestions * 100).round() : 0;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📅 Haftalık Rapor', Icons.calendar_today_rounded, const Color(0xFF0288D1), badge: 'ÜCRETSİZ'),
          const SizedBox(height: 4),
          Text('Son 7 günlük çalışma istatistiklerin. Her gün soru çözdükçe güncellenir.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          const SizedBox(height: 14),

          Row(
            children: [
              _buildMiniStat('Bu Hafta', '$weeklyQuestions soru', Icons.quiz_outlined, const Color(0xFF0288D1)),
              _buildMiniStat('Başarı', '%$weeklyRate', Icons.check_circle_outline, const Color(0xFF4CAF50)),
              _buildMiniStat('Toplam', '$totalQ soru', Icons.all_inclusive, AppTheme.textSecondary),
              _buildMiniStat('Genel', '%$successPct', Icons.bar_chart, const Color(0xFFFF8F00)),
            ],
          ),

          if (thisWeekSnaps.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final day = DateTime.now().subtract(Duration(days: 6 - i));
                  final snap = thisWeekSnaps.where((s) =>
                    s.date.year == day.year && s.date.month == day.month && s.date.day == day.day).firstOrNull;
                  final count = snap?.questionsAttempted ?? 0;
                  final maxQ = thisWeekSnaps.map((s) => s.questionsAttempted).fold(1, (a, b) => a > b ? a : b);
                  final ratio = count / maxQ;
                  final dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (count > 0) Text('$count', style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 8 : 9)),
                          const SizedBox(height: 2),
                          Container(
                            height: count > 0 ? 24 * ratio + 4 : 4,
                            decoration: BoxDecoration(
                              color: count > 0 ? const Color(0xFF0288D1).withOpacity(0.6) : AppTheme.dividerColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(dayNames[day.weekday - 1], style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 8 : 9)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: _isSmallScreen ? 18 : 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 12 : 14, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 9 : 10)),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 5. KONU EKSİK HARİTASI (ÜCRETSİZ)
  // ════════════════════════════════════════════════════════════

  Widget _buildTopicGapMap() {
    final dna = _userDNA;
    if (dna == null || dna.topicPerformance.isEmpty) {
      return _buildCard(
        child: Column(
          children: [
            Icon(Icons.map_outlined, color: AppTheme.textMuted, size: 36),
            const SizedBox(height: 10),
            Text('🗺️ Çözdürdüğün Konular',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Soru çözdürdükçe hangi konularda destek aldığın burada görünecek. Bu konular senin eksik alanların — çalışmaya odaklan!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          ],
        ),
      );
    }

    final topics = dna.topicPerformance.entries.toList()
      ..sort((a, b) => b.value.totalQuestions.compareTo(a.value.totalQuestions));

    final maxQ = topics.isNotEmpty ? topics.first.value.totalQuestions : 1;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🗺️ Çözdürdüğün Konular', Icons.map_rounded, const Color(0xFFFF5722), badge: 'ÜCRETSİZ'),
          const SizedBox(height: 4),
          Text('Çözdürdüğün konular = eksik alanların. Çok çözdürdüğün konulara daha çok çalış!',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 10 : 11)),
          const SizedBox(height: 14),

          ...topics.take(10).map((entry) {
            final count = entry.value.totalQuestions;
            final ratio = count / maxQ;
            // Çok çözdürdüyse kırmızı (eksik), az çözdürdüyse yeşil (az eksik)
            final color = ratio > 0.7 ? const Color(0xFFE53935) : ratio > 0.4 ? const Color(0xFFFF8F00) : const Color(0xFF4CAF50);
            final emoji = ratio > 0.7 ? '🔴' : ratio > 0.4 ? '🟡' : '🟢';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  Expanded(flex: 3, child: Text(entry.key,
                    style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 12 : 13), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Expanded(flex: 4, child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: ratio, backgroundColor: AppTheme.dividerColor,
                      valueColor: AlwaysStoppedAnimation(color), minHeight: 8),
                  )),
                  const SizedBox(width: 8),
                  SizedBox(width: 36, child: Text('$count',
                    style: TextStyle(color: color, fontSize: _isSmallScreen ? 11 : 12, fontWeight: FontWeight.bold))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 6. YOL HARİTASI (30💎)
  // ════════════════════════════════════════════════════════════

  Widget _buildRoadmapSection() {
    final lastDate = _userDNA?.lastRoadmapDate;
    final daysSince = lastDate != null ? DateTime.now().difference(lastDate).inDays : null;

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🗺️ Kişisel Yol Haritası', Icons.route_rounded, const Color(0xFF5C6BC0), badge: '30 💎', badgeColor: const Color(0xFF5C6BC0)),
          const SizedBox(height: 4),
          Text('AI verilerine göre sana özel haftalık çalışma planı oluşturur.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          const SizedBox(height: 8),

          // 🔔 7 gün hatırlatma
          if (_roadmapNeedUpdate && _roadmapResult != null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.update_rounded, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '${daysSince ?? 7}+ gün oldu, yol haritanı güncelle!',
                    style: TextStyle(color: Colors.orange.shade800, fontSize: _isSmallScreen ? 11 : 12, fontWeight: FontWeight.w600),
                  )),
                ],
              ),
            ),

          // Son güncelleme tarihi
          if (lastDate != null && _roadmapResult != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('Son güncelleme: ${lastDate.day}.${lastDate.month}.${lastDate.year}',
                style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 10 : 11)),
            ),

          if (_roadmapResult != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
              child: Text(_roadmapResult!,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 12 : 13, height: 1.5)),
            ),
            const SizedBox(height: 8),

            // 📝 Notlarıma Kaydet butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _saveRoadmapToNotes,
                icon: const Icon(Icons.note_add_rounded, size: 18),
                label: const Text('Notlarıma Kaydet'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF5C6BC0),
                  side: const BorderSide(color: Color(0xFF5C6BC0)),
                  padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 8 : 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGeneratingRoadmap ? null : _generateRoadmap,
              icon: _isGeneratingRoadmap
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome, size: 18),
              label: Text(_isGeneratingRoadmap ? 'Oluşturuluyor...' : (_roadmapResult != null ? 'Yol Haritasını Güncelle' : 'Yol Haritası Oluştur')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C6BC0), foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateRoadmap() async {
    setState(() => _isGeneratingRoadmap = true);
    try {
      if (!mounted) return;
      final hasPoints = await _pointsService.checkAndSpendPoints(context, 'roadmap_analysis', description: 'Yol Haritası (30💎)');
      if (!hasPoints) { setState(() => _isGeneratingRoadmap = false); return; }

      final dna = _userDNA;
      if (dna == null) return;
      final daysLeft = _getDaysRemaining();
      final examName = _getExamDate()?.name ?? dna.targetExam ?? 'Sınav';

      // En çok çözdürdüğü konular (eksik alanları)
      final topicSorted = dna.topicPerformance.entries.toList()
          ..sort((a, b) => b.value.totalQuestions.compareTo(a.value.totalQuestions));
      final topicStr = topicSorted.take(8).map((e) => '${e.key} (${e.value.totalQuestions} soru)').join(', ');

      // Deneme gelişim trendi
      final mockTrend = dna.mockHistory.isNotEmpty
          ? dna.mockHistory.map((m) => '${m.date.day}.${m.date.month}: ${m.netScore} net').join(' → ')
          : 'Deneme verisi yok';

      // Bu hafta çözülen soru sayısı
      final weekQ = _snapshots.fold<int>(0, (sum, s) => sum + s.questionsAttempted);

      final prompt = '''Sen tecrübeli bir Türk sınav koçusun. Öğrencinin gerçek verilerine dayalı, uygulanabilir haftalık çalışma planı oluştur.

⚠️ ÖNEMLİ BAĞLAM: Bu uygulama öğrencinin yapamadığı soruları AI'a çözdürtme uygulamasıdır. Dolayısıyla:
- Çok çözdürdüğü konu = en zayıf olduğu, en çok çalışması gereken konu
- Toplam çözdürdüğü soru sayısı yüksekse aktif çalışıyor demektir
- Gerçek sınav performansı deneme sınavı sonuçlarından ölçülür

ÖĞRENCİ VERİLERİ:
- Hedef sınav: $examName
- Sınava kalan gün: ${daysLeft ?? 'Bilinmiyor'}
- Hedef net: ${dna.targetNetScore ?? 'Belirtilmemiş'}
- Son deneme neti: ${dna.lastMockNetScore ?? 'Girilmemiş'}
- Deneme trendi: $mockTrend
- Toplam çözdürdüğü soru: ${dna.totalQuestionsSolved}
- Bu hafta çözdürdüğü soru: $weekQ
- En çok çözdürdüğü (eksik) konular: $topicStr

PLAN KURALLARI:
- Deneme neti yoksa "deneme sınavına gir" uyarısı ver
- Konulara günlük soru hedefi koy (örn: "Paragraf: 15 soru/gün")
- Haftanın her günü farklı ders/konu planla
- Cumartesi-Pazar tekrar ve deneme günü olsun
- Gerçekçi ol, günde 3-4 saatten fazla planlamа
- Her konunun önem sebebini kısaca açıkla

FORMAT:
1. DURUM DEĞERLENDİRMESİ (3 cümle - gerçekçi, net)
2. BU HAFTA ÖNCELİKLİ KONULAR (en çok eksik 3-5 konu + neden + günlük hedef soru sayısı)
3. GÜNLÜK PLAN (Pazartesi-Pazar, her gün 2-3 satır, konu + süre + soru sayısı)
4. HAFTALlK HEDEF (somut: "Bu hafta sonunda X konuda Y soru çözmüş ol")
5. MOTİVASYON (1 cümle)

Kısa, somut, aksiyon odaklı. Türkçe yaz. Genel tavsiye verme, spesifik ol.''';

      final response = await GeminiService().generateFreeText(prompt);
      final result = response ?? 'Plan oluşturulamadı.';

      // UserDNA'ya kaydet
      if (response != null) {
        final now = DateTime.now();
        final updated = dna.copyWith(lastRoadmapDate: now, lastRoadmapText: result);
        await _dnaService.saveDNA(updated);

        // 🔔 Analiz yapıldı, 7 gün sonrası için hatırlatma zamanla
        try { await NotificationService().markAnalysisDone(); } catch (_) {}
      }

      setState(() {
        _roadmapResult = result;
        _isGeneratingRoadmap = false;
        _roadmapNeedUpdate = false;
      });
    } catch (e) {
      setState(() => _isGeneratingRoadmap = false);
      _showSnack('Hata: $e', Colors.red);
    }
  }

  Future<void> _saveRoadmapToNotes() async {
    if (_roadmapResult == null) return;
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;
      final date = DateTime.now();
      final title = '🗺️ Yol Haritası - ${date.day}.${date.month}.${date.year}';
      await _noteService.saveNote(userId: userId, title: title, content: _roadmapResult!);
      _showSnack('Yol haritası notlarına kaydedildi! ✅', const Color(0xFF4CAF50));
    } catch (e) {
      _showSnack('Kaydetme hatası: $e', Colors.red);
    }
  }

  // ════════════════════════════════════════════════════════════
  // 7. HAFTALIK CHECK-IN (15💎)
  // ════════════════════════════════════════════════════════════

  Widget _buildCheckinSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📋 Haftalık Check-in', Icons.self_improvement_rounded, const Color(0xFF00897B), badge: '15 💎', badgeColor: const Color(0xFF00897B)),
          const SizedBox(height: 4),
          Text('Kendini değerlendir, AI sana kişisel geri bildirim versin.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 12)),
          const SizedBox(height: 12),

          if (_checkinResult != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.backgroundColor, borderRadius: BorderRadius.circular(12)),
              child: Text(_checkinResult!,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 12 : 13, height: 1.5)),
            ),
            const SizedBox(height: 8),
          ],

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGeneratingCheckin ? null : _showCheckinDialog,
              icon: _isGeneratingCheckin
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.chat_outlined, size: 18),
              label: Text(_isGeneratingCheckin ? 'Analiz ediliyor...' : 'Check-in Yap'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B), foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckinDialog() {
    String? mood;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('📋 Haftalık Check-in',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bu hafta nasıl hissettin?', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    _checkinChip('😊 Motive', mood == 'motive', () => setDialogState(() => mood = 'motive')),
                    _checkinChip('😐 Normal', mood == 'normal', () => setDialogState(() => mood = 'normal')),
                    _checkinChip('😩 Yorgun', mood == 'yorgun', () => setDialogState(() => mood = 'yorgun')),
                    _checkinChip('😰 Stresli', mood == 'stresli', () => setDialogState(() => mood = 'stresli')),
                  ],
                ),
                const SizedBox(height: 16),
                Text('En çok zorlandığın konu?', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: noteController,
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Örn: Türev, paragraf...',
                    hintStyle: TextStyle(color: AppTheme.textMuted),
                    filled: true, fillColor: AppTheme.backgroundColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.dividerColor)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx),
              child: Text('İptal', style: TextStyle(color: AppTheme.textMuted))),
            ElevatedButton(
              onPressed: mood == null ? null : () { Navigator.pop(ctx); _processCheckin(mood!, noteController.text); },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00897B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Gönder (15💎)', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkinChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00897B).withOpacity(0.15) : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? const Color(0xFF00897B) : AppTheme.dividerColor),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? const Color(0xFF00897B) : AppTheme.textSecondary, fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }

  Future<void> _processCheckin(String mood, String struggle) async {
    setState(() => _isGeneratingCheckin = true);
    try {
      if (!mounted) return;
      final hasPoints = await _pointsService.checkAndSpendPoints(context, 'checkin_analysis', description: 'Haftalık Check-in (15💎)');
      if (!hasPoints) { setState(() => _isGeneratingCheckin = false); return; }

      final dna = _userDNA;
      final weekQ = _snapshots.where((s) => DateTime.now().difference(s.date).inDays < 7).fold<int>(0, (sum, s) => sum + s.questionsAttempted);
      final topConular = dna?.topicPerformance.entries.toList()?..sort((a, b) => b.value.totalQuestions.compareTo(a.value.totalQuestions));
      final topStr = topConular?.take(5).map((e) => '${e.key} (${e.value.totalQuestions} soru)').join(', ') ?? 'Yok';
      final prompt = '''Öğrenci haftalık check-in yaptı. Kısa ve motive edici geri bildirim ver.

NOT: Öğrenci yapamadığı soruları AI'a çözdürüyor. Çok çözdürdüğü konular eksik alanları.

ÖĞRENCİ DURUMU:
- Ruh hali: $mood
- Zorlandığı konu: ${struggle.isNotEmpty ? struggle : 'Belirtmedi'}
- Bu hafta çözdürdüğü soru: $weekQ
- En çok çözdürdüğü (eksik) konular: $topStr
- Son deneme neti: ${dna?.lastMockNetScore ?? 'Girilmemiş'}

FORMAT:
1. Durum değerlendirmesi (2 cümle)
2. Bu hafta için 2 pratik öneri
3. Motivasyon mesajı (1 cümle)

Kısa, samimi ve Türkçe yaz.''';

      final response = await GeminiService().generateFreeText(prompt);
      setState(() { _checkinResult = response ?? 'Analiz oluşturulamadı.'; _isGeneratingCheckin = false; });
    } catch (e) {
      setState(() => _isGeneratingCheckin = false);
      _showSnack('Hata: $e', Colors.red);
    }
  }

  // ════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ════════════════════════════════════════════════════════════

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_isSmallScreen ? 14 : 18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, {String? badge, Color? badgeColor}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: TextStyle(
            color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (badgeColor ?? const Color(0xFF4CAF50)).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(badge, style: TextStyle(
              color: badgeColor ?? const Color(0xFF4CAF50), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildInfoBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text,
            style: TextStyle(color: color.withOpacity(0.9), fontSize: _isSmallScreen ? 12 : 13))),
        ],
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color, behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}';
}
