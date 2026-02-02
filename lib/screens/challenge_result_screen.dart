/// SOLICAP - Challenge Result Screen
/// Kazanan/kaybeden, puan ve elmas değişimi - Animasyonlu versiyon

import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/challenge_model.dart';
import '../services/challenge_service.dart';
import '../services/auth_service.dart';
import 'challenge_lobby_screen.dart';

class ChallengeResultScreen extends StatefulWidget {
  final String challengeId;
  final int correctAnswers;
  final int totalQuestions;
  final int totalTimeMs;
  /// Rövanş için kategori/zorluk (aynı kategoride tekrar oyna)
  final String? category;
  final String? difficulty;

  const ChallengeResultScreen({
    super.key,
    required this.challengeId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.totalTimeMs,
    this.category,
    this.difficulty,
  });

  @override
  State<ChallengeResultScreen> createState() => _ChallengeResultScreenState();
}

class _ChallengeResultScreenState extends State<ChallengeResultScreen>
    with TickerProviderStateMixin {
  
  final ChallengeService _challengeService = ChallengeService();
  final AuthService _authService = AuthService();
  
  Challenge? _challenge;
  bool _isLoading = true;
  bool _isWinner = false;
  bool _isDraw = false;
  bool _isWaiting = false; // Rakip henüz bitirmedi
  StreamSubscription? _challengeSubscription;
  
  late AnimationController _resultController;
  late AnimationController _statsController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadResult();
  }

  void _setupAnimations() {
    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _statsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeOut),
    );
  }

  void _applyChallengeResult(Challenge? c) {
    if (c == null || !mounted) return;
    _challenge = c;
    if (c.status == ChallengeStatus.completed) {
      final userId = _authService.currentUserId;
      _isWaiting = false;
      _isWinner = c.winnerId == userId;
      _isDraw = c.isDraw;
      _challengeSubscription?.cancel();
      _challengeSubscription = null;
      setState(() {});
    }
  }

  Future<void> _loadResult() async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final c = await _challengeService.getChallenge(widget.challengeId);
      if (!mounted) return;

      _challenge = c;
      if (c != null && c.status == ChallengeStatus.completed) {
        final userId = _authService.currentUserId;
        _isWaiting = false;
        _isWinner = c.winnerId == userId;
        _isDraw = c.isDraw;
      } else {
        _isWaiting = true;
        if (c != null) {
          _challengeSubscription = _challengeService
              .getChallengeStream(widget.challengeId)
              .listen((c) => _applyChallengeResult(c));
        }
      }

      setState(() => _isLoading = false);
      _resultController.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _statsController.forward();
      });
    } catch (e) {
      debugPrint('❌ Sonuç yükleme hatası: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _challengeSubscription?.cancel();
    _resultController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.amber),
              SizedBox(height: 16),
              Text('Sonuçlar hesaplanıyor...', style: TextStyle(color: AppTheme.textMuted)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Sonuç kartı
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildResultCard(),
                    ),
                    
                    const SizedBox(height: 32),
                
                // İstatistikler
                _buildStatsSection(),
                
                const SizedBox(height: 32),
                
                // Ödüller
                if (!_isWaiting) _buildRewardsSection(),
                
                const SizedBox(height: 40),
                
                // Butonlar
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    ],
    ),
    );
  }

  Widget _buildResultCard() {
    if (_isWaiting) {
      return _buildWaitingCard();
    }

    final resultColor = _isWinner 
        ? Colors.green 
        : (_isDraw ? Colors.amber : Colors.red);
    
    final resultIcon = _isWinner 
        ? Icons.emoji_events 
        : (_isDraw ? Icons.handshake : Icons.sentiment_dissatisfied);
    
    final resultText = _isWinner 
        ? 'Kazandın!' 
        : (_isDraw ? 'Beraberlik!' : 'Kaybettin');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            resultColor.withOpacity(0.2),
            resultColor.withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: resultColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          // İkon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: resultColor.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: resultColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(resultIcon, color: resultColor, size: 56),
          ),
          const SizedBox(height: 20),
          
          // Sonuç metni
          Text(
            resultText,
            style: TextStyle(
              color: resultColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingCard() {
    // Player 1 (challenge başlatan) mı yoksa Player 2 mi?
    final userId = _authService.currentUserId;
    final isPlayer1 = _challenge?.player1.userId == userId;
    final hasPlayer2 = _challenge?.player2 != null;

    // Player 1 ve henüz rakip yoksa: "Aktif challenge'lere eklendi"
    final isWaitingForOpponent = isPlayer1 && !hasPlayer2;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isWaitingForOpponent ? Colors.green : Colors.blue).withOpacity(0.2),
            (isWaitingForOpponent ? Colors.green : Colors.blue).withOpacity(0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (isWaitingForOpponent ? Colors.green : Colors.blue).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // İkon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isWaitingForOpponent ? Colors.green : Colors.blue).withOpacity(0.2),
            ),
            child: Center(
              child: isWaitingForOpponent
                  ? const Icon(Icons.check_circle, color: Colors.green, size: 56)
                  : const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Başlık
          Text(
            isWaitingForOpponent ? 'Tamamlandı!' : 'Tamamlandı!',
            style: TextStyle(
              color: isWaitingForOpponent ? Colors.green : Colors.blue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Alt metin
          if (isWaitingForOpponent) ...[
            Text(
              '✅ Aktif challenge\'lere eklendi!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Arkadaşını davet et veya rastgele\nbir rakip seni bulacak.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ] else ...[
            Text(
              'Rakibinin bitirmesini bekliyoruz...',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sonuçlar daha sonra bildirilecek.',
              style: TextStyle(
                color: Colors.blue.shade400,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final accuracy = (widget.correctAnswers / widget.totalQuestions * 100).toStringAsFixed(0);
    final avgTime = (widget.totalTimeMs / widget.totalQuestions / 1000).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performansın',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  value: '${widget.correctAnswers}/${widget.totalQuestions}',
                  label: 'Doğru',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.percent,
                  color: Colors.blue,
                  value: '%$accuracy',
                  label: 'Başarı',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.timer,
                  color: Colors.orange,
                  value: '${avgTime}s',
                  label: 'Ort. Süre',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
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
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsSection() {
    final diamondReward = _isWinner 
        ? ChallengeService.winnerReward 
        : (_isDraw ? ChallengeService.drawReward : 0);
    
    final pointChange = _isWinner 
        ? ChallengeService.winPoints 
        : (_isDraw ? 0 : -ChallengeService.losePoints);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Ödüller',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Elmas
              Column(
                children: [
                  const Icon(Icons.diamond, color: Colors.amber, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    diamondReward > 0 ? '+$diamondReward' : '0',
                    style: TextStyle(
                      color: diamondReward > 0 ? Colors.amber : AppTheme.textMuted,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Elmas', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
              
              Container(width: 1, height: 50, color: AppTheme.dividerColor),
              
              // Puan
              Column(
                children: [
                  Icon(
                    pointChange >= 0 ? Icons.trending_up : Icons.trending_down,
                    color: pointChange >= 0 ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pointChange >= 0 ? '+$pointChange' : '$pointChange',
                    style: TextStyle(
                      color: pointChange >= 0 ? Colors.green : Colors.red,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Puan', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canRematch = widget.category != null && widget.difficulty != null;

    return Column(
      children: [
        // Rövanş (aynı kategori/zorlukta tekrar oyna)
        if (canRematch)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengeLobbyScreen(
                      initialCategory: widget.category,
                      initialDifficulty: widget.difficulty,
                      autoSearch: true,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.replay),
              label: const Text('Rövanş!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        if (canRematch) const SizedBox(height: 12),
        
        // Ana Sayfaya Dön
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            label: const Text('Ana Sayfaya Dön'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Yeni Challenge (Lobby)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChallengeLobbyScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Yeni Challenge'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
