/// 📚 SINAVA HAZIRLIK MODÜLÜ - Exam Prep Screen
/// Solicap Exam Engine v2026
/// 
/// Çalışma Rehberi (Study Guide) + Ezber Kartları (Flashcards) görüntüleme

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/exam_prep_model.dart';
import '../theme/app_theme.dart';

class ExamPrepScreen extends StatefulWidget {
  final ExamPrep examPrep;

  const ExamPrepScreen({super.key, required this.examPrep});

  @override
  State<ExamPrepScreen> createState() => _ExamPrepScreenState();
}

class _ExamPrepScreenState extends State<ExamPrepScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentChapterIndex = 0;
  
  // Flashcard state
  int _currentCardIndex = 0;
  bool _isFlipped = false;
  String? _selectedTag; // Filtre için

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Filtrelenmiş flashcardlar
  List<Flashcard> get _filteredFlashcards {
    if (_selectedTag == null) return widget.examPrep.flashcards;
    return widget.examPrep.flashcards
        .where((card) => card.tag == _selectedTag)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.examPrep.studyGuide.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textMuted,
          tabs: [
            Tab(
              icon: const Icon(Icons.menu_book, size: 20),
              text: 'Çalışma Rehberi (${widget.examPrep.chapterCount})',
            ),
            Tab(
              icon: const Icon(Icons.style, size: 20),
              text: 'Ezber Kartları (${widget.examPrep.flashcardCount})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStudyGuideTab(),
          _buildFlashcardsTab(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 📖 ÇALIŞMA REHBERİ TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStudyGuideTab() {
    final chapters = widget.examPrep.studyGuide.chapters;
    if (chapters.isEmpty) {
      return _buildEmptyState(
        icon: Icons.menu_book_outlined,
        title: 'Bölüm Bulunamadı',
        subtitle: 'Çalışma rehberi oluşturulamadı.',
      );
    }

    return Column(
      children: [
        // Üst Bilgi Kartı
        _buildInfoCard(),
        
        // Bölüm Seçici
        _buildChapterSelector(chapters),
        
        // Bölüm İçeriği
        Expanded(
          child: _buildChapterContent(chapters[_currentChapterIndex]),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tahmini Çalışma Süresi',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.examPrep.studyGuide.estimatedStudyTime,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Uyarı sayısı
          if (widget.examPrep.warningCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.examPrep.warningCount} uyarı',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChapterSelector(List<StudyChapter> chapters) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final isSelected = index == _currentChapterIndex;
          final chapter = chapters[index];
          final hasWarnings = chapter.criticalWarnings.isNotEmpty;

          return GestureDetector(
            onTap: () => setState(() => _currentChapterIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bölüm ${index + 1}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasWarnings) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.warning_amber,
                      size: 14,
                      color: isSelected ? Colors.white : Colors.amber,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChapterContent(StudyChapter chapter) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bölüm Başlığı
          Text(
            chapter.chapterTitle,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Kritik Uyarılar
          if (chapter.criticalWarnings.isNotEmpty) ...[
            _buildWarningsCard(chapter.criticalWarnings),
            const SizedBox(height: 16),
          ],

          // Markdown İçerik
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: MarkdownBody(
              data: chapter.contentMarkdown,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                h2: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                h3: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                p: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                strong: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                listBullet: const TextStyle(color: AppTheme.primaryColor),
                blockquote: TextStyle(
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      width: 4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 80), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildWarningsCard(List<String> warnings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_amber, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                '⚠️ Dikkat Edilmesi Gerekenler',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...warnings.map((warning) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    warning,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🃏 EZBER KARTLARI TAB
  // ═══════════════════════════════════════════════════════════════

  Widget _buildFlashcardsTab() {
    final flashcards = _filteredFlashcards;
    
    if (widget.examPrep.flashcards.isEmpty) {
      return _buildEmptyState(
        icon: Icons.style_outlined,
        title: 'Ezber Kartı Bulunamadı',
        subtitle: 'Notlardan ezber kartı oluşturulamadı.',
      );
    }

    return Column(
      children: [
        // Tag Filtresi
        _buildTagFilter(),
        
        // Kart Sayacı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_currentCardIndex + 1} / ${flashcards.length}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(Çevirmek için dokun)',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Flashcard
        Expanded(
          child: flashcards.isEmpty
              ? _buildEmptyState(
                  icon: Icons.filter_alt_outlined,
                  title: 'Kart Bulunamadı',
                  subtitle: 'Bu filtreye uygun kart yok.',
                )
              : GestureDetector(
                  onTap: () => setState(() => _isFlipped = !_isFlipped),
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity == null) return;
                    
                    if (details.primaryVelocity! < 0) {
                      // Sola kaydır - sonraki kart
                      _nextCard(flashcards.length);
                    } else if (details.primaryVelocity! > 0) {
                      // Sağa kaydır - önceki kart
                      _previousCard();
                    }
                  },
                  child: _buildFlashcard(flashcards[_currentCardIndex]),
                ),
        ),

        // Navigasyon Butonları
        if (flashcards.isNotEmpty)
          _buildCardNavigation(flashcards.length),
      ],
    );
  }

  Widget _buildTagFilter() {
    final tags = ['Tanım', 'Tarih', 'Formül', 'Kavram'];
    final tagColors = {
      'Tanım': Colors.blue,
      'Tarih': Colors.orange,
      'Formül': Colors.green,
      'Kavram': Colors.purple,
    };

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Tümü butonu
          GestureDetector(
            onTap: () => setState(() {
              _selectedTag = null;
              _currentCardIndex = 0;
              _isFlipped = false;
            }),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedTag == null
                    ? AppTheme.primaryColor
                    : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _selectedTag == null
                      ? AppTheme.primaryColor
                      : AppTheme.dividerColor,
                ),
              ),
              child: Text(
                'Tümü (${widget.examPrep.flashcards.length})',
                style: TextStyle(
                  color: _selectedTag == null ? Colors.white : AppTheme.textSecondary,
                  fontWeight: _selectedTag == null ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          // Tag butonları
          ...tags.map((tag) {
            final count = widget.examPrep.flashcards
                .where((card) => card.tag == tag)
                .length;
            if (count == 0) return const SizedBox.shrink();

            final isSelected = _selectedTag == tag;
            final color = tagColors[tag] ?? AppTheme.primaryColor;

            return GestureDetector(
              onTap: () => setState(() {
                _selectedTag = tag;
                _currentCardIndex = 0;
                _isFlipped = false;
              }),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : AppTheme.dividerColor,
                  ),
                ),
                child: Text(
                  '$tag ($count)',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFlashcard(Flashcard card) {
    final tagColors = {
      'Tanım': Colors.blue,
      'Tarih': Colors.orange,
      'Formül': Colors.green,
      'Kavram': Colors.purple,
    };
    final tagColor = tagColors[card.tag] ?? AppTheme.primaryColor;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey(_isFlipped),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _isFlipped
                ? [
                    tagColor.withOpacity(0.1),
                    tagColor.withOpacity(0.05),
                  ]
                : [
                    AppTheme.cardColor,
                    AppTheme.surfaceColor,
                  ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isFlipped
                ? tagColor.withOpacity(0.3)
                : AppTheme.dividerColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: (_isFlipped ? tagColor : Colors.black).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tag Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isFlipped ? Icons.lightbulb : Icons.help_outline,
                    size: 14,
                    color: tagColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isFlipped ? 'CEVAP' : 'SORU',
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // İçerik
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    _isFlipped ? card.back : card.front,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: _isFlipped ? 18 : 20,
                      fontWeight: _isFlipped ? FontWeight.normal : FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Alt Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: tagColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                card.tag,
                style: TextStyle(
                  color: tagColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardNavigation(int totalCards) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Önceki
          ElevatedButton.icon(
            onPressed: _currentCardIndex > 0 ? _previousCard : null,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Önceki'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceColor,
              foregroundColor: AppTheme.textPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppTheme.dividerColor),
              ),
            ),
          ),

          // Karıştır
          IconButton(
            onPressed: () => _shuffleCards(),
            icon: const Icon(Icons.shuffle),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              foregroundColor: AppTheme.primaryColor,
            ),
            tooltip: 'Karıştır',
          ),

          // Sonraki
          ElevatedButton.icon(
            onPressed: _currentCardIndex < totalCards - 1
                ? () => _nextCard(totalCards)
                : null,
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Sonraki'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextCard(int totalCards) {
    if (_currentCardIndex < totalCards - 1) {
      setState(() {
        _currentCardIndex++;
        _isFlipped = false;
      });
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      setState(() {
        _currentCardIndex--;
        _isFlipped = false;
      });
    }
  }

  void _shuffleCards() {
    setState(() {
      _currentCardIndex = 0;
      _isFlipped = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🔀 Kartlar karıştırıldı!'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎨 ORTAK WİDGETLAR
  // ═══════════════════════════════════════════════════════════════

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

