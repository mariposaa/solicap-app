/// SOLICAP - Challenge Lobby Screen
/// Kategori seçimi ve rakip arama ekranı

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../services/challenge_service.dart';
import '../services/points_service.dart';
import '../models/challenge_model.dart';
import '../models/challenge_question_model.dart';
import 'challenge_vs_screen.dart';

class ChallengeLobbyScreen extends StatefulWidget {
  /// Rövanş için önceden seçili kategori/zorluk
  final String? initialCategory;
  final String? initialDifficulty;
  /// Rövanş: açıldığında otomatik "Rakip Ara" tetikle
  final bool autoSearch;

  const ChallengeLobbyScreen({
    super.key,
    this.initialCategory,
    this.initialDifficulty,
    this.autoSearch = false,
  });

  @override
  State<ChallengeLobbyScreen> createState() => _ChallengeLobbyScreenState();
}

class _ChallengeLobbyScreenState extends State<ChallengeLobbyScreen> {
  final ChallengeService _challengeService = ChallengeService();
  final PointsService _pointsService = PointsService();
  final TextEditingController _inviteCodeController = TextEditingController();

  late String _selectedCategory;
  late String _selectedDifficulty;
  bool _isSearching = false;
  bool _isJoiningByInvite = false;
  int _userDiamonds = 0;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? ChallengeCategories.genelKultur;
    _selectedDifficulty = widget.initialDifficulty ?? ChallengeDifficulties.ilkokul;
    _initAndMaybeAutoSearch();
  }

  Future<void> _initAndMaybeAutoSearch() async {
    await _loadUserDiamonds();
    if (widget.autoSearch && mounted) {
      _startSearch();
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDiamonds() async {
    final diamonds = await _pointsService.getPoints();
    if (mounted) {
      setState(() => _userDiamonds = diamonds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '⚔️ Challenge',
          style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Elmas göstergesi
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_userDiamonds',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık kartı
            _buildHeaderCard(),
            
            const SizedBox(height: 24),
            
            // Kategori seçimi
            _buildSectionTitle('📚 Kategori Seç'),
            const SizedBox(height: 12),
            _buildCategoryGrid(),
            
            const SizedBox(height: 24),
            
            // Okul düzeyi seçimi
            _buildSectionTitle('🎯 Okul Düzeyi'),
            const SizedBox(height: 12),
            _buildDifficultySelector(),
            
            const SizedBox(height: 24),
            
            // Davet kodu ile katıl
            _buildInviteCodeSection(),
            
            const SizedBox(height: 24),
            
            // Rakip ara butonu
            _buildSearchButton(),
            
            const SizedBox(height: 16),
            
            // Bilgi notu
            _buildInfoNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade400,
            Colors.purple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.sports_kabaddi, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Bilgi Düellosu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '10 soru • En hızlı ve doğru kazanır!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    // Okul düzeyine göre: İlkokul=Sosyal Bilgiler; Ortaokul/Lise=Tarih+Coğrafya ayrı; Lise=Fizik+Kimya+Biyoloji
    final categories = ChallengeCategories.categoriesForDifficulty(_selectedDifficulty);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory == category;
        final icon = ChallengeCategories.getIcon(category);
        final name = ChallengeCategories.getDisplayName(category);

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = category),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppTheme.primaryColor.withOpacity(0.15)
                  : AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultySelector() {
    final difficulties = [
      ChallengeDifficulties.ilkokul,
      ChallengeDifficulties.ortaokul,
      ChallengeDifficulties.lise,
    ];
    return Row(
      children: difficulties.map((diff) {
        final isSelected = _selectedDifficulty == diff;
        final name = ChallengeDifficulties.getDisplayName(diff);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedDifficulty = diff;
                final newCategories = ChallengeCategories.categoriesForDifficulty(diff);
                if (!newCategories.contains(_selectedCategory)) {
                  _selectedCategory = newCategories.first;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: diff != difficulties.last ? 12 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                ),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchButton() {
    final hasEnoughDiamonds = _userDiamonds >= ChallengeService.entryFee;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: hasEnoughDiamonds
            ? const LinearGradient(
                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
              )
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasEnoughDiamonds
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSearching
              ? null
              : () async {
                  if (hasEnoughDiamonds) {
                    _startSearch();
                  } else {
                    final watched = await PointsService.showInsufficientPointsDialog(
                      context,
                      actionName: 'Challenge (Rakip Ara)',
                      onPointsAdded: () async {
                        await _loadUserDiamonds();
                        if (mounted) setState(() {});
                      },
                    );
                    if (watched && mounted) {
                      await _loadUserDiamonds();
                      setState(() {});
                      _startSearch();
                    }
                  }
                },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSearching)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.search, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  _isSearching ? 'Hazırlanıyor...' : 'Düello Start',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isSearching) ...[
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.diamond, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${ChallengeService.entryFee}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInviteCodeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.share, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Davet Kodu ile Katıl',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Arkadaşın sana challenge paylaştıysa, mesajdaki kodu buraya yaz.\n'
            '💡 Kod, rakibin "Yarışmalarım" ekranındaki paylaş butonuyla gönderilir.',
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inviteCodeController,
                  decoration: InputDecoration(
                    hintText: 'Challenge kodu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isJoiningByInvite ? null : _joinByInviteCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isJoiningByInvite
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Katıl'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _joinByInviteCode() async {
    final code = _inviteCodeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen davet kodunu gir'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() => _isJoiningByInvite = true);
    try {
      final challenge = await _challengeService.joinChallengeByInviteCode(code);
      if (challenge != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeVsScreen(challenge: challenge),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('❌ Geçersiz veya süresi dolmuş challenge kodu'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isJoiningByInvite = false);
    }
  }

  Widget _buildInfoNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Kazanan 15 💎 ve +10 puan kazanır.\nKaybeden -10 puan kaybeder.',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Arkadaşını davet et, davet kodunla katıldığında ${PointsService.inviteReward} 💎 hediye kazan!',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _startSearch() async {
    setState(() => _isSearching = true);

    try {
      // Elmas düş (Düello Start'a basınca)
      final spent = await _pointsService.spendPoints(
        'challenge_entry',
        description: 'Challenge giriş ücreti',
      );
      if (!spent) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Elmas düşürülemedi'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      // Elmas UI güncelle
      await _loadUserDiamonds();

      // Önce bekleyen bir challenge ara
      Challenge? challenge = await _challengeService.findWaitingChallenge(
        category: _selectedCategory,
        difficulty: _selectedDifficulty,
      );

      if (challenge != null) {
        // Mevcut challenge'a katıl (normal akış)
        challenge = await _challengeService.joinChallenge(challenge.id);
        if (challenge != null && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeVsScreen(challenge: challenge!),
            ),
          );
        }
      } else {
        // Solo mod: Sadece soruları yükle, challenge 10 soru bitince oluşturulacak
        final questions = await _challengeService.getRandomQuestions(
          category: _selectedCategory,
          difficulty: _selectedDifficulty,
        );

        if (questions.length < ChallengeService.questionsPerMatch) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Bu kategori ve okul düzeyi için henüz yeterli soru yok. Lütfen İlkokul 4-5 veya başka bir kategori deneyin.',
                ),
                backgroundColor: Colors.orange.shade700,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          return;
        }

        // Geçici challenge objesi (Firestore'a henüz yazılmayacak)
        final tempChallenge = Challenge(
          id: '', // Boş ID = henüz oluşturulmamış
          category: _selectedCategory,
          difficulty: _selectedDifficulty,
          status: ChallengeStatus.waiting,
          player1: ChallengePlayer(
            userId: '',
            displayName: 'Sen',
          ),
          questionIds: questions.map((q) => q.id).toList(),
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeVsScreen(
                challenge: tempChallenge,
                preloadedQuestions: questions,
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Challenge arama hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }
}
