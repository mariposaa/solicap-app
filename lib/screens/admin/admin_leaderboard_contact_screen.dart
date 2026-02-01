/// Admin: Yarışmalar bölümü - sıralama listesi ve kullanıcıya tıklanınca ödül iletişim bilgileri

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/leaderboard_service.dart';
import '../../models/leaderboard_model.dart';

class AdminLeaderboardContactScreen extends StatefulWidget {
  const AdminLeaderboardContactScreen({super.key});

  @override
  State<AdminLeaderboardContactScreen> createState() => _AdminLeaderboardContactScreenState();
}

class _AdminLeaderboardContactScreenState extends State<AdminLeaderboardContactScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  Map<GradeGroup, List<LeaderboardEntry>> _allTime = {};
  List<LeaderboardEntry> _weeklyElementary = [];
  List<LeaderboardEntry> _weeklyHighSchool = [];
  List<LeaderboardEntry> _weeklyUniversity = [];
  Map<String, _ContactInfo> _contactCache = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final map = await _leaderboardService.getAllTimeLeaderboard();
      final weeklyElem = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.elementary);
      final weeklyHigh = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.highSchool);
      final weeklyUni = await _leaderboardService.getWeeklyLeaderboard(GradeGroup.university);
      if (mounted) {
        _allTime = map;
        _weeklyElementary = weeklyElem;
        _weeklyHighSchool = weeklyHigh;
        _weeklyUniversity = weeklyUni;
        // Ödül iletişim bilgilerini user_dna'dan çek
        for (final entries in map.values) {
          for (final e in entries) {
            if (!_contactCache.containsKey(e.userId)) {
              final contact = await _fetchContact(e.userId);
              if (mounted) _contactCache[e.userId] = contact;
            }
          }
        }
        for (final e in weeklyElem) {
          if (!_contactCache.containsKey(e.userId)) {
            final contact = await _fetchContact(e.userId);
            if (mounted) _contactCache[e.userId] = contact;
          }
        }
        for (final e in weeklyHigh) {
          if (!_contactCache.containsKey(e.userId)) {
            final contact = await _fetchContact(e.userId);
            if (mounted) _contactCache[e.userId] = contact;
          }
        }
        for (final e in weeklyUni) {
          if (!_contactCache.containsKey(e.userId)) {
            final contact = await _fetchContact(e.userId);
            if (mounted) _contactCache[e.userId] = contact;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Admin leaderboard yükleme hatası: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<_ContactInfo> _fetchContact(String userId) async {
    try {
      final doc = await _firestore.collection('user_dna').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return _ContactInfo(
          email: data['prizeContactEmail'] as String?,
          phone: data['prizeContactPhone'] as String?,
        );
      }
    } catch (_) {}
    return _ContactInfo(email: null, phone: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('🏆 Yarışmalar - Ödül İletişim'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _isLoading ? null : _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppTheme.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kullanıcıya tıklayınca ödül iletişim bilgileri (e-posta / telefon) açılır.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    _buildGroupSection(
                      '📚 İlkokul - Ortaokul (Tüm Zamanlar)',
                      _allTime[GradeGroup.elementary] ?? [],
                    ),
                    const SizedBox(height: 24),
                    _buildGroupSection(
                      '🎓 Lise (Tüm Zamanlar)',
                      _allTime[GradeGroup.highSchool] ?? [],
                    ),
                    const SizedBox(height: 24),
                    _buildGroupSection(
                      '🎓 Üniversite (Tüm Zamanlar)',
                      _allTime[GradeGroup.university] ?? [],
                    ),
                    const SizedBox(height: 24),
                    _buildGroupSection(
                      '📚 İlkokul - Ortaokul (Haftalık)',
                      _weeklyElementary,
                    ),
                    const SizedBox(height: 24),
                    _buildGroupSection(
                      '🎓 Lise (Haftalık)',
                      _weeklyHighSchool,
                    ),
                    const SizedBox(height: 24),
                    _buildGroupSection(
                      '🎓 Üniversite (Haftalık)',
                      _weeklyUniversity,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGroupSection(String title, List<LeaderboardEntry> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Henüz sıralama yok',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final rank = index + 1;
              final contact = _contactCache[entry.userId];
              return _buildEntryTile(entry, rank, contact);
            },
          ),
      ],
    );
  }

  Widget _buildEntryTile(LeaderboardEntry entry, int rank, _ContactInfo? contact) {
    final hasContact = (contact?.email != null && contact!.email!.isNotEmpty) ||
        (contact?.phone != null && contact!.phone!.isNotEmpty);
    return Material(
      color: AppTheme.cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _showContactDialog(entry, contact),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? Colors.amber.withOpacity(0.2)
                      : AppTheme.dividerColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rank <= 3 ? Colors.amber.shade800 : AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.displayName,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${entry.points} puan',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                hasContact ? Icons.contact_mail : Icons.contact_mail_outlined,
                color: hasContact ? AppTheme.primaryColor : AppTheme.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _gradeGroupLabel(GradeGroup g) {
    return g == GradeGroup.elementary ? 'İlkokul-Ortaokul'
        : g == GradeGroup.university ? 'Üniversite'
        : 'Lise';
  }

  void _showContactDialog(LeaderboardEntry entry, _ContactInfo? contact) {
    final email = contact?.email?.trim() ?? '';
    final phone = contact?.phone?.trim() ?? '';
    final hasAny = email.isNotEmpty || phone.isNotEmpty;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.displayName,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.points} puan • ${_gradeGroupLabel(entry.gradeGroup)}',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ödül iletişim bilgileri',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            if (!hasAny)
              const Text(
                'Girilmemiş. Kullanıcıya profilinden e-posta/telefon eklemesini duyurabilirsiniz (Ödül Duyurusu ekranından "E-postanızı kontrol edin" vb.).',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
              )
            else ...[
              if (email.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined, size: 18, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      SelectableText(email, style: const TextStyle(color: AppTheme.textPrimary)),
                    ],
                  ),
                ),
              if (phone.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 18, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    SelectableText(phone, style: const TextStyle(color: AppTheme.textPrimary)),
                  ],
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}

class _ContactInfo {
  final String? email;
  final String? phone;

  _ContactInfo({this.email, this.phone});
}
