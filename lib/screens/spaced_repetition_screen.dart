/// SOLICAP - Spaced Repetition Screen
/// Aralıklı tekrar ekranı - Flashcard benzeri UI

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/spaced_repetition_service.dart';
import '../services/user_dna_service.dart';
import '../models/user_dna_model.dart';

class SpacedRepetitionScreen extends StatefulWidget {
  const SpacedRepetitionScreen({super.key});

  @override
  State<SpacedRepetitionScreen> createState() => _SpacedRepetitionScreenState();
}

class _SpacedRepetitionScreenState extends State<SpacedRepetitionScreen> {
  final SpacedRepetitionService _srService = SpacedRepetitionService();
  
  List<ReviewCard> _cards = [];
  SpacedRepetitionStats? _stats;
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _showAnswer = false;
  bool _sessionComplete = false;
  bool _isLocked = false;
  int _questionCount = 0;
  final UserDNAService _dnaService = UserDNAService();

  @override
  void initState() {
    super.initState();
    _checkLockAndLoad();
  }

  Future<void> _checkLockAndLoad() async {
    final dna = await _dnaService.getDNA();
    final count = dna?.questionCount ?? 0;
    
    if (count < 10) {
      if (mounted) {
        setState(() {
          _isLocked = true;
          _questionCount = count;
          _isLoading = false;
        });
      }
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final cards = await _srService.getTodayReviews();
    final stats = await _srService.getStats();
    
    setState(() {
      _cards = cards;
      _stats = stats;
      _isLoading = false;
      _currentIndex = 0;
      _showAnswer = false;
      _sessionComplete = cards.isEmpty;
    });
  }

  void _showAnswerCard() {
    setState(() => _showAnswer = true);
  }

  Future<void> _answerCard(bool wasCorrect) async {
    final card = _cards[_currentIndex];
    await _srService.answerCard(card.id, wasCorrect);

    if (_currentIndex < _cards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      setState(() => _sessionComplete = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      );
    }

    if (_isLocked) {
      return _buildLockedState();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.replay, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text(
              'Tekrar Kartları',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_stats != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_stats!.dueToday} kart',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessionComplete
              ? _buildSessionComplete()
              : _buildReviewSession(),
    );
  }

  Widget _buildReviewSession() {
    if (_cards.isEmpty) {
      return _buildEmptyState();
    }

    final card = _cards[_currentIndex];
    final progress = (_currentIndex + 1) / _cards.length;

    return Column(
      children: [
        // İlerleme çubuğu
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.surfaceColor,
          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
        
        // Kart sayısı
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${_cards.length}',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBoxColor(card.box).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  card.boxStatus,
                  style: TextStyle(
                    color: _getBoxColor(card.box),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Flashcard
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _showAnswer ? null : _showAnswerCard,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _showAnswer
                    ? _buildAnswerCard(card)
                    : _buildQuestionCard(card),
              ),
            ),
          ),
        ),

        // Butonlar
        if (_showAnswer)
          _buildAnswerButtons()
        else
          _buildShowAnswerButton(),
      ],
    );
  }

  Widget _buildQuestionCard(ReviewCard card) {
    return Container(
      key: const ValueKey('question'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${card.topic} > ${card.subTopic}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.quiz,
            color: AppTheme.accentColor,
            size: 48,
          ),
          const SizedBox(height: 24),
          Text(
            card.questionText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const Spacer(),
          const Text(
            'Cevabı görmek için dokun',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(ReviewCard card) {
    return Container(
      key: const ValueKey('answer'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.successColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lightbulb,
            color: AppTheme.successColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Doğru Cevap',
            style: TextStyle(
              color: AppTheme.successColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            card.correctAnswer,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowAnswerButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _showAnswerCard,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Cevabı Göster',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Bilmedim
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _answerCard(false),
                  icon: const Icon(Icons.close),
                  label: const Text('Bilmedim'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Bildim
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _answerCard(true),
                  icon: const Icon(Icons.check),
                  label: const Text('Bildim'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionComplete() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                color: AppTheme.successColor,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bugünlük Bu Kadar! 🎉',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _cards.isEmpty
                  ? 'Tekrar edilecek kart yok'
                  : '${_cards.length} kartı tamamladın',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            if (_stats != null) _buildStatsCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.done_all,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bugünlük Bu Kadar!',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tekrar edilecek soru kalmadı. Yanlış yaptığın yeni sorular buraya otomatik olarak eklenecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_person,
                  size: 64,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tekrar Kartları Kilitli',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sana özel tekrar kartları oluşturabilmemiz için en az 10 soru çözmelisin. Şu an $_questionCount soru çözdün.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              LinearProgressIndicator(
                value: _questionCount / 10,
                backgroundColor: AppTheme.surfaceColor,
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
                minHeight: 12,
              ),
              const SizedBox(height: 12),
              Text(
                'İlerleme: %${(_questionCount * 10).toInt()}',
                style: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Geri Dön ve Soru Çöz'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final stats = _stats!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Toplam', '${stats.totalCards}', Icons.layers),
              _buildStatItem('Ustalaştı', '${stats.masteredCards}', Icons.star),
              _buildStatItem('Oran', '%${(stats.masteryRate * 100).toInt()}', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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

  Color _getBoxColor(int box) {
    switch (box) {
      case 1: return AppTheme.errorColor;
      case 2: return AppTheme.warningColor;
      case 3: return AppTheme.accentColor;
      case 4: return AppTheme.primaryColor;
      case 5: return AppTheme.successColor;
      case 6: return Colors.amber;
      default: return AppTheme.textMuted;
    }
  }
}
