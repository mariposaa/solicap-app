/// SOLICAP - Kelime Gezisi Oyunu
/// Harfleri birleştir, İngilizce kelimeler oluştur, Türkçe anlamlarını öğren

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../data/word_game_data.dart';
import '../services/leaderboard_service.dart';

class WordGameScreen extends StatefulWidget {
  const WordGameScreen({super.key});

  @override
  State<WordGameScreen> createState() => _WordGameScreenState();
}

class _WordGameScreenState extends State<WordGameScreen> with TickerProviderStateMixin {
  int _currentLevelIndex = 0;
  late WordGameLevel _level;
  final Set<String> _foundWords = {};
  bool _levelComplete = false;

  // Sürükleme
  final List<int> _selectedIndices = [];
  String _currentWord = '';
  Offset? _dragPosition;

  // Animasyon
  late AnimationController _celebrationController;
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  String? _lastFoundTranslation;
  bool _showTranslation = false;
  bool _wrongAttempt = false;
  int _hintUsed = 0; // Kullanılan ipucu sayısı

  // Harf pozisyonları
  List<Offset> _letterPositions = [];
  List<int> _letterOrder = []; // Shuffle için
  final GlobalKey _circleKey = GlobalKey();

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;
  double get _circleRadius => _isSmallScreen ? 75.0 : 95.0;
  double get _letterSize => _isSmallScreen ? 48.0 : 56.0;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000),
    );
    _shakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('word_game_level') ?? 0;
    setState(() {
      _currentLevelIndex = saved.clamp(0, wordGameLevels.length - 1);
      _level = wordGameLevels[_currentLevelIndex];
      _foundWords.clear();
      _levelComplete = false;
      _hintUsed = 0;
      _initLetterOrder();
      _calculateLetterPositions();
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('word_game_level', _currentLevelIndex);
  }

  void _initLetterOrder() {
    _letterOrder = List.generate(_level.letters.length, (i) => i);
  }

  void _calculateLetterPositions() {
    _letterPositions = [];
    final count = _level.letters.length;
    for (int i = 0; i < count; i++) {
      final angle = (2 * pi * i / count) - (pi / 2);
      _letterPositions.add(Offset(
        _circleRadius * cos(angle),
        _circleRadius * sin(angle),
      ));
    }
  }

  void _shuffleLetters() {
    setState(() {
      _letterOrder.shuffle();
      _calculateLetterPositions();
    });
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Sürükleme ──

  int? _hitTestLetter(Offset globalPos) {
    final RenderBox? box = _circleKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final localPos = box.globalToLocal(globalPos);
    final center = Offset(box.size.width / 2, box.size.height / 2);

    for (int i = 0; i < _letterPositions.length; i++) {
      final letterCenter = center + _letterPositions[i];
      if ((localPos - letterCenter).distance < _letterSize / 2 + 10) {
        return i;
      }
    }
    return null;
  }

  void _onPanStart(DragStartDetails details) {
    final idx = _hitTestLetter(details.globalPosition);
    if (idx != null) {
      setState(() {
        _selectedIndices.clear();
        _selectedIndices.add(idx);
        _currentWord = _level.letters[_letterOrder[idx]];
        _dragPosition = details.globalPosition;
        _wrongAttempt = false;
        _showTranslation = false;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_selectedIndices.isEmpty) return;
    setState(() => _dragPosition = details.globalPosition);

    final idx = _hitTestLetter(details.globalPosition);
    if (idx != null && !_selectedIndices.contains(idx)) {
      setState(() {
        _selectedIndices.add(idx);
        _currentWord += _level.letters[_letterOrder[idx]];
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_currentWord.length >= 3) {
      _checkWord(_currentWord);
    } else if (_currentWord.isNotEmpty) {
      _triggerShake();
    }
    setState(() {
      _selectedIndices.clear();
      _currentWord = '';
      _dragPosition = null;
    });
  }

  void _checkWord(String word) {
    final match = _level.words.where((w) => w.en == word.toUpperCase()).firstOrNull;

    if (match != null && !_foundWords.contains(match.en)) {
      setState(() {
        _foundWords.add(match.en);
        _lastFoundTranslation = '${match.en} = ${match.tr}';
        _showTranslation = true;
      });
      _celebrationController.forward(from: 0);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showTranslation = false);
      });

      if (_foundWords.length == _level.words.length) {
        Future.delayed(const Duration(milliseconds: 600), () => _onLevelComplete());
      }
    } else if (match == null) {
      _triggerShake();
    }
  }

  void _triggerShake() {
    setState(() => _wrongAttempt = true);
    _shakeController.forward(from: 0).then((_) {
      if (mounted) setState(() => _wrongAttempt = false);
    });
  }

  void _useHint() {
    // Bulunmamış bir kelimenin ilk harfini göster
    final notFound = _level.words.where((w) => !_foundWords.contains(w.en)).toList();
    if (notFound.isEmpty) return;

    final word = notFound[_hintUsed % notFound.length];
    setState(() {
      _hintUsed++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('💡 İpucu: "${word.en[0]}..." ile başlayan ${word.en.length} harfli bir kelime (${word.tr})',
          style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  int _getMilestoneBonus(int levelId) {
    if (levelId == 50) return 100; // Tüm seviyeleri bitirdi
    if (levelId % 10 == 0) return 25; // Her 10 seviyede bonus
    return 0;
  }

  Future<void> _onLevelComplete() async {
    setState(() => _levelComplete = true);

    final basePoints = 10;
    final milestone = _getMilestoneBonus(_level.id);
    final totalPoints = basePoints + milestone;

    try {
      await LeaderboardService().addPoints(totalPoints, 'word_game_level');
    } catch (_) {}

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Text(milestone > 0 ? '🏆' : '🎉', style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(milestone > 0 ? 'Milestone!' : 'Tebrikler!', textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Seviye ${_level.id} tamamlandı!',
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                      const SizedBox(width: 6),
                      Text('${_foundWords.length} kelime',
                        style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('+$basePoints Tüm Zamanlar Puanı 🏆',
                    style: const TextStyle(color: Colors.amber, fontSize: 15, fontWeight: FontWeight.w600)),
                  if (milestone > 0) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFF8F00), Color(0xFFFFB300)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _level.id == 50 ? '🎖️ +$milestone BONUS - TÜM SEVİYELER!' : '⭐ +$milestone BONUS (${_level.id}. Seviye)',
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          if (_currentLevelIndex < wordGameLevels.length - 1)
            ElevatedButton.icon(
              onPressed: () { Navigator.pop(ctx); _nextLevel(); },
              icon: const Icon(Icons.arrow_forward_rounded, size: 20),
              label: const Text('Sonraki Seviye'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tamam', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  void _nextLevel() {
    if (_currentLevelIndex < wordGameLevels.length - 1) {
      setState(() {
        _currentLevelIndex++;
        _level = wordGameLevels[_currentLevelIndex];
        _foundWords.clear();
        _levelComplete = false;
        _hintUsed = 0;
        _initLetterOrder();
        _calculateLetterPositions();
      });
      _saveProgress();
    }
  }

  // ── UI ──

  @override
  Widget build(BuildContext context) {
    if (_letterPositions.isEmpty || _letterPositions.length != _level.letters.length) {
      _calculateLetterPositions();
    }

    final found = _foundWords.length;
    final total = _level.words.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Text('🔤 ', style: TextStyle(fontSize: 20)),
            Text('Seviye ${_level.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 16 : 18)),
            const Spacer(),
            // İlerleme badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1B5E20).withOpacity(0.8), const Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text('$found/$total',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.grid_view_rounded, size: 22), onPressed: _showLevelPicker, tooltip: 'Seviyeler'),
        ],
      ),
      body: Stack(
        children: [
          // Arka plan dekorasyon
          _buildBackground(),

          // Ana içerik
          SafeArea(
            child: Column(
              children: [
                // İlerleme çubuğu
                _buildProgressBar(found, total),

                // Kelimeler (kompakt)
                _buildFoundWordsList(),

                // Orta alan - kelime gösterim + daire
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCurrentWordDisplay(),
                      const SizedBox(height: 8),
                      if (_showTranslation && _lastFoundTranslation != null)
                        _buildTranslationBanner(),
                      SizedBox(height: _isSmallScreen ? 8 : 16),
                      _buildLetterCircle(),
                    ],
                  ),
                ),

                // Alt butonlar
                _buildBottomButtons(),
                SizedBox(height: _isSmallScreen ? 8 : 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _BackgroundPainter(pulse: _pulseController.value),
        );
      },
    );
  }

  Widget _buildProgressBar(int found, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: total > 0 ? found / total : 0,
          backgroundColor: Colors.white.withOpacity(0.08),
          valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
          minHeight: 6,
        ),
      ),
    );
  }

  Widget _buildFoundWordsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 110),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: _level.words.map((word) {
            final isFound = _foundWords.contains(word.en);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: isFound
                    ? const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)])
                    : null,
                color: isFound ? null : Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFound ? const Color(0xFF4CAF50) : Colors.white.withOpacity(0.12),
                ),
                boxShadow: isFound ? [
                  BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.2), blurRadius: 6),
                ] : null,
              ),
              child: isFound
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(word.en,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('(${word.tr})',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                      ],
                    )
                  : Text('${'•' * word.en.length}  ${word.en.length}',
                      style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12, letterSpacing: 1)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrentWordDisplay() {
    if (_currentWord.isEmpty) return const SizedBox(height: 44);
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shake = _wrongAttempt ? sin(_shakeController.value * 3 * pi) * 10 : 0.0;
        return Transform.translate(offset: Offset(shake, 0), child: child);
      },
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: _wrongAttempt
              ? Colors.red.withOpacity(0.15)
              : const Color(0xFF4CAF50).withOpacity(0.1),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: _wrongAttempt
                ? Colors.redAccent.withOpacity(0.5)
                : const Color(0xFF4CAF50).withOpacity(0.4),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _currentWord,
          style: TextStyle(
            color: _wrongAttempt ? Colors.redAccent : const Color(0xFF66BB6A),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationBanner() {
    return AnimatedBuilder(
      animation: _celebrationController,
      builder: (context, child) {
        final scale = 1.0 + (1 - _celebrationController.value) * 0.1;
        return Transform.scale(scale: scale, child: Opacity(
          opacity: (1 - _celebrationController.value * 0.5).clamp(0.5, 1.0),
          child: child,
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 12),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✅ ', style: TextStyle(fontSize: 18)),
            Flexible(
              child: Text(_lastFoundTranslation ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterCircle() {
    final circleSize = _circleRadius * 2 + _letterSize + 24;

    return GestureDetector(
      onPanStart: _levelComplete ? null : _onPanStart,
      onPanUpdate: _levelComplete ? null : _onPanUpdate,
      onPanEnd: _levelComplete ? null : _onPanEnd,
      child: SizedBox(
        key: _circleKey,
        width: circleSize,
        height: circleSize,
        child: CustomPaint(
          painter: _LinePainter(
            selectedIndices: _selectedIndices,
            letterPositions: _letterPositions,
            center: Offset(circleSize / 2, circleSize / 2),
            dragPosition: _dragPosition != null ? _globalToLocal(_dragPosition!) : null,
          ),
          child: Stack(
            children: [
              // Dış halka
              Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final glow = 0.03 + _pulseController.value * 0.04;
                    return Container(
                      width: circleSize - 16,
                      height: circleSize - 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.15 + _pulseController.value * 0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF4CAF50).withOpacity(glow), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // İç halka
              Center(
                child: Container(
                  width: _circleRadius * 0.9,
                  height: _circleRadius * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.02),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                ),
              ),
              // Harfler
              for (int i = 0; i < _level.letters.length; i++)
                Positioned(
                  left: circleSize / 2 + _letterPositions[i].dx - _letterSize / 2,
                  top: circleSize / 2 + _letterPositions[i].dy - _letterSize / 2,
                  child: _buildLetterBubble(i),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Offset? _globalToLocal(Offset global) {
    final RenderBox? box = _circleKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;
    return box.globalToLocal(global);
  }

  Widget _buildLetterBubble(int index) {
    final isSelected = _selectedIndices.contains(index);
    final letter = _level.letters[_letterOrder[index]];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _letterSize,
      height: _letterSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                begin: Alignment.topLeft, end: Alignment.bottomRight)
            : const LinearGradient(
                colors: [Color(0xFF1B3A2D), Color(0xFF0D2818)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
        border: Border.all(
          color: isSelected ? Colors.greenAccent : Colors.white.withOpacity(0.2),
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.6), blurRadius: 16, spreadRadius: 2)
          else
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
          fontSize: isSelected ? 24 : 22,
          fontWeight: FontWeight.bold,
          shadows: isSelected ? [
            const Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ] : null,
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle butonu
          _buildActionButton(
            icon: Icons.shuffle_rounded,
            label: 'Karıştır',
            onTap: _shuffleLetters,
          ),
          // İpucu butonu
          _buildActionButton(
            icon: Icons.lightbulb_outline_rounded,
            label: 'İpucu',
            onTap: _useHint,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF4CAF50),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showLevelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('📖 Seviye Seç', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${_currentLevelIndex + 1}/50 tamamlandı', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, crossAxisSpacing: 10, mainAxisSpacing: 10,
                ),
                itemCount: wordGameLevels.length,
                itemBuilder: (ctx, i) {
                  final isCompleted = i < _currentLevelIndex;
                  final isCurrent = i == _currentLevelIndex;
                  final isLocked = i > _currentLevelIndex;
                  return GestureDetector(
                    onTap: isLocked ? null : () {
                      Navigator.pop(ctx);
                      setState(() {
                        _currentLevelIndex = i;
                        _level = wordGameLevels[i];
                        _foundWords.clear();
                        _levelComplete = false;
                        _hintUsed = 0;
                        _initLetterOrder();
                        _calculateLetterPositions();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isCompleted
                            ? const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)])
                            : isCurrent
                                ? const LinearGradient(colors: [Color(0xFF388E3C), Color(0xFF4CAF50)])
                                : null,
                        color: !isCompleted && !isCurrent ? Colors.white.withOpacity(0.05) : null,
                        borderRadius: BorderRadius.circular(14),
                        border: isCurrent ? Border.all(color: Colors.greenAccent, width: 2) : null,
                        boxShadow: isCurrent ? [
                          BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 8),
                        ] : null,
                      ),
                      alignment: Alignment.center,
                      child: isLocked
                          ? Icon(Icons.lock_rounded, color: Colors.white.withOpacity(0.15), size: 18)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isCompleted) const Text('✅', style: TextStyle(fontSize: 14)),
                                Text('${i + 1}',
                                  style: TextStyle(
                                    color: isCompleted || isCurrent ? Colors.white : Colors.white38,
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Arka Plan Dekorasyon ──

class _BackgroundPainter extends CustomPainter {
  final double pulse;
  _BackgroundPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    // Yumuşak gradient daireler
    final center = Offset(size.width / 2, size.height * 0.6);

    final paint1 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1B5E20).withOpacity(0.08 + pulse * 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 200 + pulse * 20));
    canvas.drawCircle(center, 200 + pulse * 20, paint1);

    final paint2 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF004D40).withOpacity(0.05 + pulse * 0.03),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.2, size.height * 0.3), radius: 150));
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 150, paint2);

    final paint3 = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF1B5E20).withOpacity(0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.85, size.height * 0.15), radius: 100));
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 100, paint3);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) => old.pulse != pulse;
}

// ── Harf Bağlantı Çizgileri ──

class _LinePainter extends CustomPainter {
  final List<int> selectedIndices;
  final List<Offset> letterPositions;
  final Offset center;
  final Offset? dragPosition;

  _LinePainter({
    required this.selectedIndices,
    required this.letterPositions,
    required this.center,
    this.dragPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedIndices.isEmpty) return;

    // Glow çizgi
    final glowPaint = Paint()
      ..color = const Color(0xFF4CAF50).withOpacity(0.2)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paint = Paint()
      ..color = const Color(0xFF66BB6A).withOpacity(0.8)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final firstPos = center + letterPositions[selectedIndices.first];
    path.moveTo(firstPos.dx, firstPos.dy);

    for (int i = 1; i < selectedIndices.length; i++) {
      final pos = center + letterPositions[selectedIndices[i]];
      path.lineTo(pos.dx, pos.dy);
    }

    if (dragPosition != null) {
      path.lineTo(dragPosition!.dx, dragPosition!.dy);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.selectedIndices != selectedIndices || old.dragPosition != dragPosition;
}
