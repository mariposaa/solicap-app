/// SOLICAP - Competitions Screen
/// Yarışmalar ve Liderlik Tablosu (4 Tab)

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../services/leaderboard_service.dart';
import '../services/user_dna_service.dart';
import '../services/auth_service.dart';
import '../services/challenge_service.dart';
import '../services/points_service.dart';
import '../models/leaderboard_model.dart';
import '../models/challenge_model.dart';
import '../models/challenge_question_model.dart';
import '../services/award_announcement_service.dart';
import 'challenge_lobby_screen.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> 
    with SingleTickerProviderStateMixin {
  
  final LeaderboardService _leaderboardService = LeaderboardService();
  final UserDNAService _dnaService = UserDNAService();
  final AuthService _authService = AuthService();
  final ChallengeService _challengeService = ChallengeService();
  
  late TabController _tabController;
  
  bool _isLoading = true;
  GradeGroup? _userGradeGroup;
  
  // Challenge verileri
  UserChallengeStats? _userChallengeStats;
  List<Challenge> _activeChallenges = [];
  List<UserChallengeStats> _challengeLeaderboard = [];
  int _userAllTimePoints = 0;
  int _userWeeklyPoints = 0;
  int _userAllTimeRank = -1;
  int _userWeeklyRank = -1;
  
  Map<GradeGroup, List<LeaderboardEntry>> _allTimeLeaderboard = {};
  List<LeaderboardEntry> _weeklyElementary = [];
  List<LeaderboardEntry> _weeklyHighSchool = [];
  List<LeaderboardEntry> _weeklyUniversity = [];
  
  DateTime? _lastUpdate;
  AwardAnnouncement? _awardAnnouncement;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Kullanıcı bilgileri
      final dna = await _dnaService.getDNA();
      _userGradeGroup = getGradeGroup(
        dna?.gradeLevel,
        targetExam: dna?.targetExam,
        level: dna?.level,
      );
      
      // Puanlar
      _userAllTimePoints = await _leaderboardService.getUserPoints(weekly: false);
      _userWeeklyPoints = await _leaderboardService.getUserPoints(weekly: true);
      
      // Sıralamalar
      _userAllTimeRank = await _leaderboardService.getUserRank(weekly: false);
      _userWeeklyRank = await _leaderboardService.getUserRank(
        weekly: true, 
        gradeGroup: _userGradeGroup,
      );
      
      // Liderlik tabloları
      _allTimeLeaderboard = await _leaderboardService.getAllTimeLeaderboard();
      _weeklyElementary = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.elementary);
      _weeklyHighSchool = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.highSchool);
      _weeklyUniversity = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.university);
      
      // Challenge verileri
      _userChallengeStats = await _challengeService.getUserStats();
      _activeChallenges = await _challengeService.getMyActiveChallenges();
      _challengeLeaderboard = await _challengeService.getLeaderboard(limit: 10);
      
      _awardAnnouncement = await AwardAnnouncementService().get();
      _lastUpdate = DateTime.now();
    } catch (e) {
      debugPrint('❌ Yarışmalar yükleme hatası: $e');
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Yarışmalar 🏆',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: '⚔️ Challenge'),
            Tab(text: 'Tüm Zamanlar'),
            Tab(text: 'İlk-Orta Haftalık'),
            Tab(text: 'Lise Haftalık'),
            Tab(text: 'Üniversite Haftalık'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textMuted),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : Column(
              children: [
                // Güncelleme bilgisi
                if (_lastUpdate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: AppTheme.surfaceColor,
                    child: Center(
                      child: Text(
                        'Son güncelleme: ${_formatTime(_lastUpdate!)} (3 saatte bir yenilenir)',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                
                // Kullanıcı özet kartı
                _buildUserSummaryCard(),
                
                // Ödül duyurusu (mor ekran ile sıralama arası)
                _buildAwardAnnouncementCard(),
                
                // Tab içerikleri
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildChallengeTab(),
                      _buildAllTimeTab(),
                      _buildWeeklyTab(GradeGroup.elementary),
                      _buildWeeklyTab(GradeGroup.highSchool),
                      _buildWeeklyTab(GradeGroup.university),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Kullanıcı özet kartı
  Widget _buildUserSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade400,
            Colors.purple.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Puan
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Toplam Puanın',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_userAllTimePoints',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            width: 1,
            height: 50,
            color: Colors.white24,
          ),
          
          // Bu hafta
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Bu Hafta',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+$_userWeeklyPoints',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            width: 1,
            height: 50,
            color: Colors.white24,
          ),
          
          // Sıralama
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Sıralaman',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userAllTimeRank > 0 ? '#$_userAllTimeRank' : '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Ödül duyuru kartı (mor ekran ile İlkokul-Ortaokul bölümü arası)
  Widget _buildAwardAnnouncementCard() {
    final announcement = _awardAnnouncement;
    if (announcement == null || !announcement.isActive) return const SizedBox.shrink();
    if (announcement.title.isEmpty && announcement.body.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade700.withOpacity(0.9),
            Colors.orange.shade600.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.emoji_events, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (announcement.title.isNotEmpty)
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (announcement.title.isNotEmpty && announcement.body.isNotEmpty) const SizedBox(height: 6),
                if (announcement.body.isNotEmpty)
                  Text(
                    announcement.body,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tüm zamanlar tab'ı
  Widget _buildAllTimeTab() {
    final elementary = _allTimeLeaderboard[GradeGroup.elementary] ?? [];
    final highSchool = _allTimeLeaderboard[GradeGroup.highSchool] ?? [];
    final university = _allTimeLeaderboard[GradeGroup.university] ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İlkokul-Ortaokul
          _buildGroupHeader('📚 İlkokul - Ortaokul', GradeGroup.elementary),
          const SizedBox(height: 8),
          _buildLeaderboardList(elementary, GradeGroup.elementary, false),
          
          const SizedBox(height: 24),
          
          // Lise
          _buildGroupHeader('🎓 Lise', GradeGroup.highSchool),
          const SizedBox(height: 8),
          _buildLeaderboardList(highSchool, GradeGroup.highSchool, false),
          
          const SizedBox(height: 24),
          
          // Üniversite
          _buildGroupHeader('🎓 Üniversite', GradeGroup.university),
          const SizedBox(height: 8),
          _buildLeaderboardList(university, GradeGroup.university, false),
        ],
      ),
    );
  }

  /// Haftalık tab'ı
  Widget _buildWeeklyTab(GradeGroup gradeGroup) {
    final entries = gradeGroup == GradeGroup.elementary 
        ? _weeklyElementary 
        : gradeGroup == GradeGroup.highSchool 
            ? _weeklyHighSchool 
            : _weeklyUniversity;
    
    final groupName = gradeGroup == GradeGroup.elementary 
        ? '📚 İlkokul - Ortaokul' 
        : gradeGroup == GradeGroup.highSchool 
            ? '🎓 Lise' 
            : '🎓 Üniversite';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupHeader('$groupName - Haftalık', gradeGroup),
          const SizedBox(height: 8),
          _buildLeaderboardList(entries, gradeGroup, true),
        ],
      ),
    );
  }

  /// Grup başlığı
  Widget _buildGroupHeader(String title, GradeGroup gradeGroup) {
    final isUserGroup = _userGradeGroup == gradeGroup;
    
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isUserGroup) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Senin Grubun',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Liderlik listesi
  Widget _buildLeaderboardList(List<LeaderboardEntry> entries, GradeGroup gradeGroup, bool isWeekly) {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Henüz sıralama yok.\nİlk sen ol! 🚀',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ),
      );
    }
    
    final userId = _authService.currentUser?.uid;
    final isUserInTop10 = entries.any((e) => e.userId == userId);
    final isUserGroup = _userGradeGroup == gradeGroup;
    
    return Column(
      children: [
        // İlk 10 listesi
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isCurrentUser = entry.userId == userId;
              
              return _buildLeaderboardItem(
                rank: index + 1,
                entry: entry,
                isCurrentUser: isCurrentUser,
              );
            },
          ),
        ),
        
        // Kullanıcı ilk 10'da değilse göster
        if (!isUserInTop10 && isUserGroup) ...[
          const SizedBox(height: 12),
          _buildUserRankCard(isWeekly),
        ],
      ],
    );
  }

  /// Liderlik listesi öğesi
  Widget _buildLeaderboardItem({
    required int rank,
    required LeaderboardEntry entry,
    required bool isCurrentUser,
  }) {
    Color? rankColor;
    IconData? rankIcon;
    
    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = Colors.grey.shade400;
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = Colors.brown.shade400;
        rankIcon = Icons.emoji_events;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppTheme.primaryColor.withOpacity(0.1) : null,
        border: Border(
          bottom: BorderSide(color: AppTheme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          // Sıra
          SizedBox(
            width: 40,
            child: rankIcon != null
                ? Icon(rankIcon, color: rankColor, size: 24)
                : Text(
                    '#$rank',
                    style: TextStyle(
                      color: isCurrentUser ? AppTheme.primaryColor : AppTheme.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          
          // İsim
          Expanded(
            child: Text(
              entry.displayName + (isCurrentUser ? ' (Sen)' : ''),
              style: TextStyle(
                color: isCurrentUser ? AppTheme.primaryColor : AppTheme.textPrimary,
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Puan
          Text(
            '${entry.points} ⭐',
            style: TextStyle(
              color: isCurrentUser ? AppTheme.primaryColor : AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Kullanıcı sıra kartı (ilk 10'da değilse)
  Widget _buildUserRankCard(bool isWeekly) {
    final rank = isWeekly ? _userWeeklyRank : _userAllTimeRank;
    final points = isWeekly ? _userWeeklyPoints : _userAllTimePoints;
    
    if (rank <= 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade400.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sıralaman: #$rank',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '$points ⭐',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Saat formatla
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // ═══════════════════════════════════════════════════════════════
  // CHALLENGE TAB
  // ═══════════════════════════════════════════════════════════════

  /// Challenge Tab'ı
  Widget _buildChallengeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kullanıcı Challenge İstatistikleri
          _buildChallengeStatsCard(),
          
          const SizedBox(height: 20),
          
          // Yeni Challenge Başlat Butonu
          _buildStartChallengeButton(),
          
          const SizedBox(height: 24),
          
          // Aktif Challenge'lar
          _buildActiveChallengesSection(),
          
          const SizedBox(height: 24),
          
          // Challenge Liderboard
          _buildChallengLeaderboardSection(),
        ],
      ),
    );
  }

  /// Challenge istatistik kartı
  Widget _buildChallengeStatsCard() {
    final stats = _userChallengeStats;
    final points = stats?.challengePoints ?? 0;
    final wins = stats?.wins ?? 0;
    final losses = stats?.losses ?? 0;
    final winRate = stats?.winRate.toStringAsFixed(0) ?? '0';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '⚔️ Challenge Puanın',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$points',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Galibiyet', '$wins', Colors.green.shade300),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildStatItem('Mağlubiyet', '$losses', Colors.red.shade300),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildStatItem('Kazanma %', '%$winRate', Colors.amber.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  /// Yeni Challenge Başlat Butonu
  Widget _buildStartChallengeButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChallengeLobbyScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.sports_kabaddi, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'Yeni Challenge Başlat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text('${ChallengeService.entryFee} 💎', style: TextStyle(color: Colors.amber, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Aktif Challenge'lar bölümü
  Widget _buildActiveChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.pending_actions, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Aktif Challenge\'lar',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (_activeChallenges.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_activeChallenges.length}',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (_activeChallenges.isEmpty)
          _buildEmptyChallengesState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activeChallenges.length,
            itemBuilder: (context, index) {
              return _buildChallengeCard(_activeChallenges[index]);
            },
          ),
      ],
    );
  }

  /// Boş Challenge durumu
  Widget _buildEmptyChallengesState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_esports_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Aktif challenge yok',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Yeni bir challenge başlat ve rakiplerini alt et!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// Challenge kartı
  Widget _buildChallengeCard(Challenge challenge) {
    final isWaiting = challenge.status == ChallengeStatus.waiting;
    final statusColor = isWaiting ? Colors.amber : Colors.green;
    final statusText = isWaiting ? 'Rakip Bekleniyor' : 'Devam Ediyor';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Kategori ikonu
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.quiz, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 14),
          
          // Bilgiler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      challenge.difficulty,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Aksiyon butonları
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bekleyen challenge - Paylaş (sadece oluşturan için)
              if (isWaiting && challenge.player1.userId == _authService.currentUser?.uid)
                IconButton(
                  onPressed: () => _shareChallenge(challenge),
                  icon: const Icon(Icons.share, color: Colors.orange, size: 24),
                  tooltip: 'Arkadaşına Gönder (+${PointsService.inviteReward} 💎 hediye)',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              if (isWaiting && challenge.player1.userId == _authService.currentUser?.uid)
                const SizedBox(width: 8),
              // Devam eden - Oyna
              if (!isWaiting)
                ElevatedButton(
                  onPressed: () {
                    // Oyun ekranına yönlendirme yapılabilir
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text('Oyna'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareChallenge(Challenge challenge) {
    final inviteUrl = 'https://solicap.web.app/invite?c=${challenge.id}';
    final categoryName = ChallengeCategories.getDisplayName(challenge.category);

    final text = '⚔️ Solicap Challenge\'a katıl!\n\n'
        '$categoryName yarışmasına davetlisin.\n\n'
        '📲 Tek tıkla indir (cihazına göre Play Store / App Store açılır):\n'
        '$inviteUrl\n\n'
        'Veya Challenge kodu: ${challenge.id}\n'
        'Uygulamada "Davet kodu ile katıl"a gir ve bu kodu yaz.\n\n'
        'Arkadaşın katıldığında sen ${PointsService.inviteReward} 💎 hediye kazanırsın!';

    Share.share(text, subject: 'Solicap Challenge Daveti');
  }

  /// Challenge Liderboard bölümü (FAZ-5 polish)
  Widget _buildChallengLeaderboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.leaderboard, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Challenge Liderboard',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Top 10',
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        if (_challengeLeaderboard.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Column(
              children: [
                Icon(Icons.emoji_events_outlined, size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                const Text(
                  'Henüz sıralama yok',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
                const Text(
                  'Challenge oynayarak sıralamaya gir!',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                ),
              ],
            ),
          )
        else
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - value)),
                child: child,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _challengeLeaderboard.length,
                  itemBuilder: (context, index) {
                    final stats = _challengeLeaderboard[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.95, end: 1.0),
                      duration: Duration(milliseconds: 250 + (index * 40)),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) => Transform.scale(
                        scale: scale,
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                      child: _buildChallengeLeaderboardItem(index + 1, stats),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildChallengeLeaderboardItem(int rank, UserChallengeStats stats) {
    final userId = _authService.currentUser?.uid;
    final isCurrentUser = stats.userId == userId;
    
    Color rankColor;
    String rankEmoji;
    Color? rankBadgeBg;
    
    switch (rank) {
      case 1:
        rankColor = const Color(0xFFFFD700); // Altın
        rankEmoji = '🥇';
        rankBadgeBg = const Color(0xFFFFD700).withOpacity(0.2);
        break;
      case 2:
        rankColor = const Color(0xFFC0C0C0); // Gümüş
        rankEmoji = '🥈';
        rankBadgeBg = const Color(0xFFC0C0C0).withOpacity(0.2);
        break;
      case 3:
        rankColor = const Color(0xFFCD7F32); // Bronz
        rankEmoji = '🥉';
        rankBadgeBg = const Color(0xFFCD7F32).withOpacity(0.2);
        break;
      default:
        rankColor = AppTheme.textMuted;
        rankEmoji = '';
        rankBadgeBg = null;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.orange.withOpacity(0.08) : null,
        border: Border(
          bottom: BorderSide(color: AppTheme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          // Sıra rozeti
          SizedBox(
            width: 44,
            child: rankEmoji.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: rankBadgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: Text(rankEmoji, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
                  )
                : Text(
                    '#$rank',
                    style: TextStyle(
                      color: isCurrentUser ? Colors.orange : AppTheme.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          
          // Kullanıcı ID (kısaltılmış)
          Expanded(
            child: Text(
              '${stats.userId.length > 8 ? "${stats.userId.substring(0, 8)}..." : stats.userId}${isCurrentUser ? " (Sen)" : ""}',
              style: TextStyle(
                color: isCurrentUser ? Colors.orange : AppTheme.textPrimary,
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Galibiyet/Mağlubiyet
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${stats.wins}W',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${stats.losses}L',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Puan
          Text(
            '${stats.challengePoints}',
            style: TextStyle(
              color: isCurrentUser ? Colors.orange : AppTheme.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, color: Colors.amber, size: 16),
        ],
      ),
    );
  }
}
