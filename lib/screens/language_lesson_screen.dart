/// SOLICAP - Ünite Ders Listesi & Ders Akış Ekranları
/// Grammar, Vocabulary, Reading, Listening, Speaking, Mixed Quiz, Unit Exam

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../theme/app_theme.dart';
import '../models/language_models.dart';
import '../services/language_learning_service.dart';
import '../services/points_service.dart';
import '../data/language_content_data.dart';

// ═══════════════════════════════════════════════════════════════
// ÜNİTE DERS LİSTESİ EKRANI
// ═══════════════════════════════════════════════════════════════

class LanguageLessonScreen extends StatefulWidget {
  final LanguageUnit unit;
  final LanguageProgress initialProgress;

  const LanguageLessonScreen({super.key, required this.unit, required this.initialProgress});

  @override
  State<LanguageLessonScreen> createState() => _LanguageLessonScreenState();
}

class _LanguageLessonScreenState extends State<LanguageLessonScreen> {
  final LanguageLearningService _service = LanguageLearningService();
  late LanguageProgress _progress;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress;
  }

  Future<void> _refresh() async {
    final p = await _service.getProgress();
    if (mounted) setState(() => _progress = p);
  }

  @override
  Widget build(BuildContext context) {
    final content = _service.getContent(widget.unit.id);
    final unitProg = _progress.unitProgresses[widget.unit.id];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.unit.titleTr, style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 17)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: content == null
          ? const Center(child: Text('İçerik bulunamadı.'))
          : ListView(
              padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
              children: [
                // Ünite başlığı
                Text(
                  'Ünite ${widget.unit.order}: ${widget.unit.title}',
                  style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.unit.titleTr,
                  style: TextStyle(fontSize: _isSmallScreen ? 18 : 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 20),

                // Ders kartları
                ...widget.unit.lessonOrder.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lessonType = entry.value;
                  final isCompleted = unitProg?.isLessonCompleted(lessonType) ?? false;
                  final isLocked = _service.isLessonLocked(widget.unit.id, lessonType, _progress);

                  return _buildLessonTile(lessonType, index + 1, isCompleted, isLocked, content);
                }),
              ],
            ),
    );
  }

  Widget _buildLessonTile(LessonType type, int order, bool isCompleted, bool isLocked, UnitContent content) {
    final diamondCost = _getDiamondCost(type);

    return Container(
      margin: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isLocked
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Önceki dersi tamamla!'), duration: Duration(seconds: 2)),
                  )
              : () => _startLesson(type, content),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 14, vertical: _isSmallScreen ? 10 : 14),
            decoration: BoxDecoration(
              color: isLocked ? AppTheme.cardColor.withOpacity(0.5) : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isLocked ? [] : AppTheme.subtleShadow,
              border: isCompleted ? Border.all(color: const Color(0xFF4CAF50).withOpacity(0.4)) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: _isSmallScreen ? 36 : 44,
                  height: _isSmallScreen ? 36 : 44,
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.1)
                        : isCompleted
                            ? const Color(0xFF4CAF50).withOpacity(0.15)
                            : const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: isLocked
                      ? const Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: 20)
                      : Text(type.emoji, style: TextStyle(fontSize: _isSmallScreen ? 18 : 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.label,
                        style: TextStyle(
                          fontSize: _isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.w600,
                          color: isLocked ? AppTheme.textMuted : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${type.baseXP} XP',
                        style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: isLocked ? AppTheme.textMuted.withOpacity(0.6) : AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (diamondCost > 0 && !isCompleted && !isLocked) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('💎', style: TextStyle(fontSize: _isSmallScreen ? 10 : 12)),
                        const SizedBox(width: 3),
                        Text('$diamondCost', style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, fontWeight: FontWeight.w600, color: Colors.amber)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (isCompleted)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tekrar', style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: const Color(0xFF4CAF50).withOpacity(0.7))),
                      const SizedBox(width: 4),
                      Icon(Icons.check_circle, color: const Color(0xFF4CAF50), size: _isSmallScreen ? 18 : 22),
                    ],
                  )
                else if (!isLocked)
                  Icon(Icons.play_circle_filled_rounded, color: const Color(0xFF2E7D32).withOpacity(0.7), size: _isSmallScreen ? 18 : 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _getDiamondCost(LessonType type) {
    switch (type) {
      case LessonType.grammar:
      case LessonType.vocabulary:
        return 5;
      case LessonType.reading:
      case LessonType.listening:
      case LessonType.speaking:
        return 10;
      case LessonType.mixedQuiz:
      case LessonType.unitExam:
        return 10;
    }
  }

  String _getPointsAction(LessonType type) {
    switch (type) {
      case LessonType.grammar:
      case LessonType.vocabulary:
        return 'lang_basic_lesson';
      case LessonType.reading:
      case LessonType.listening:
      case LessonType.speaking:
        return 'lang_ai_lesson';
      case LessonType.mixedQuiz:
      case LessonType.unitExam:
        return 'lang_exam';
    }
  }

  Future<void> _startLesson(LessonType type, UnitContent content) async {
    // Tamamlanmış ders tekrar ücretsiz, ilk kez çözülüyorsa elmas al
    final unitProg = _progress.unitProgresses[widget.unit.id];
    final alreadyCompleted = unitProg?.isLessonCompleted(type) ?? false;

    if (!alreadyCompleted) {
      final pointsAction = _getPointsAction(type);
      final pointsService = PointsService();
      final ok = await pointsService.checkAndSpendPoints(context, pointsAction);
      if (!ok) return;
    }

    if (!mounted) return;

    Widget? screen;
    switch (type) {
      case LessonType.grammar:
        screen = _GrammarLessonFlow(unitId: widget.unit.id, content: content.grammar, level: _progress.currentLevel);
        break;
      case LessonType.vocabulary:
        screen = _VocabLessonFlow(unitId: widget.unit.id, words: content.vocabulary);
        break;
      case LessonType.reading:
        screen = _ReadingLessonFlow(unitId: widget.unit.id, content: content.reading, level: _progress.currentLevel);
        break;
      case LessonType.listening:
        screen = _ListeningLessonFlow(unitId: widget.unit.id, content: content.listening);
        break;
      case LessonType.speaking:
        screen = _SpeakingLessonFlow(unitId: widget.unit.id, content: content.speaking, level: _progress.currentLevel);
        break;
      case LessonType.mixedQuiz:
        screen = _QuizFlow(unitId: widget.unit.id, questions: content.mixedQuiz, lessonType: LessonType.mixedQuiz, title: 'Karma Quiz');
        break;
      case LessonType.unitExam:
        screen = _QuizFlow(unitId: widget.unit.id, questions: content.unitExam, lessonType: LessonType.unitExam, title: 'Ünite Sınavı');
        break;
    }

    if (screen != null) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
      _refresh();
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// GRAMMAR DERS AKIŞI
// ═══════════════════════════════════════════════════════════════

class _GrammarLessonFlow extends StatefulWidget {
  final String unitId;
  final GrammarContent content;
  final LanguageLevel level;

  const _GrammarLessonFlow({required this.unitId, required this.content, required this.level});

  @override
  State<_GrammarLessonFlow> createState() => _GrammarLessonFlowState();
}

class _GrammarLessonFlowState extends State<_GrammarLessonFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  bool _isTeaching = true; // İlk aşama: konu anlatımı
  int _quizIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _isComplete = false;
  String? _aiExplanation;
  bool _loadingAI = false;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _loadAI();
  }

  Future<void> _loadAI() async {
    setState(() => _loadingAI = true);
    final explanation = await _service.enrichGrammarExplanation(
      widget.content.topic,
      widget.content.rule,
      widget.level,
    );
    if (mounted) {
      setState(() {
        _aiExplanation = explanation;
        _loadingAI = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Dilbilgisi', style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 17)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isComplete ? _buildResultView() : (_isTeaching ? _buildTeachView() : _buildQuizView()),
    );
  }

  Widget _buildTeachView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Konu başlığı
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.content.topic, style: TextStyle(fontSize: _isSmallScreen ? 17 : 20, fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32))),
                const SizedBox(height: 4),
                Text(widget.content.topicTr, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kural
          Text('Kural', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
            decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.subtleShadow),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.content.rule, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textPrimary, height: 1.5)),
                const SizedBox(height: 8),
                Text(widget.content.ruleTr, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Örnekler
          Text('Örnekler', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          ...widget.content.examples.map((ex) => Padding(
                padding: EdgeInsets.only(bottom: _isSmallScreen ? 4 : 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(color: const Color(0xFF2E7D32), fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(ex, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textPrimary))),
                  ],
                ),
              )),

          // AI açıklama
          if (_loadingAI) ...[
            const SizedBox(height: 20),
            const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32)))),
          ] else if (_aiExplanation != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: _isSmallScreen ? 15 : 18),
                      const SizedBox(width: 6),
                      Text('AI Açıklama', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 12 : 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_aiExplanation!, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary, height: 1.5)),
                ],
              ),
            ),
          ],

          SizedBox(height: _isSmallScreen ? 20 : 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isTeaching = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Quize Geç', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final quiz = widget.content.quizzes[_quizIndex];
    final progress = (_quizIndex + 1) / widget.content.quizzes.length;

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 24),
          Text(quiz.question, style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 20),

          ...List.generate(quiz.options.length, (i) {
            final isSelected = _selectedOption == i;
            final isCorrect = i == quiz.correctIndex;
            Color? bgColor;
            Color? borderColor;

            if (_answered) {
              if (isCorrect) {
                bgColor = const Color(0xFF4CAF50).withOpacity(0.15);
                borderColor = const Color(0xFF4CAF50);
              } else if (isSelected && !isCorrect) {
                bgColor = Colors.red.withOpacity(0.1);
                borderColor = Colors.red;
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
              child: InkWell(
                onTap: _answered ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(
                    color: bgColor ?? (isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor ?? (isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2)), width: isSelected || _answered ? 2 : 1),
                  ),
                  child: Text(quiz.options[i], style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: AppTheme.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ),
              ),
            );
          }),

          if (_answered) ...[
            SizedBox(height: _isSmallScreen ? 10 : 12),
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
              decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(10)),
              child: Text(quiz.explanation, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textSecondary)),
            ),
          ],

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null
                  ? () {
                      if (!_answered) {
                        final correct = _selectedOption == quiz.correctIndex;
                        if (correct) _correctCount++;
                        setState(() => _answered = true);
                      } else {
                        // Sonraki soru veya bitir
                        if (_quizIndex < widget.content.quizzes.length - 1) {
                          setState(() {
                            _quizIndex++;
                            _selectedOption = null;
                            _answered = false;
                          });
                        } else {
                          _completeLesson();
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_answered ? (_quizIndex < widget.content.quizzes.length - 1 ? 'Sonraki' : 'Tamamla') : 'Kontrol Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeLesson() async {
    final total = widget.content.quizzes.length;
    await _service.completeLesson(
      unitId: widget.unitId,
      lessonType: LessonType.grammar,
      correctCount: _correctCount,
      totalCount: total,
    );
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final total = widget.content.quizzes.length;
    final score = total > 0 ? (_correctCount / total * 100) : 0.0;
    final isPerfect = score == 100;
    final xp = isPerfect ? LessonType.grammar.baseXP * 2 : LessonType.grammar.baseXP;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isPerfect ? '🌟' : '✅', style: TextStyle(fontSize: _isSmallScreen ? 44 : 56)),
            SizedBox(height: _isSmallScreen ? 12 : 20),
            Text(isPerfect ? 'Mükemmel!' : 'Ders Tamamlandı!', style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Text('$_correctCount/$total doğru', style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text('+$xp XP${isPerfect ? ' (2x Bonus!)' : ''}', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: Colors.amber, fontWeight: FontWeight.w600)),
            SizedBox(height: _isSmallScreen ? 20 : 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Devam Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// VOCABULARY DERS AKIŞI (Flashcard + Quiz)
// ═══════════════════════════════════════════════════════════════

class _VocabLessonFlow extends StatefulWidget {
  final String unitId;
  final List<VocabWord> words;

  const _VocabLessonFlow({required this.unitId, required this.words});

  @override
  State<_VocabLessonFlow> createState() => _VocabLessonFlowState();
}

class _VocabLessonFlowState extends State<_VocabLessonFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  bool _isFlashcard = true;
  int _cardIndex = 0;
  bool _showMeaning = false;

  // Quiz
  int _quizIndex = 0;
  int _correctCount = 0;
  int? _selectedOption;
  bool _answered = false;
  bool _isComplete = false;
  late List<_VocabQuizItem> _quizItems;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _generateQuiz();
  }

  void _generateQuiz() {
    final words = List<VocabWord>.from(widget.words)..shuffle();
    _quizItems = words.take(10).map((w) {
      final others = widget.words.where((o) => o.word != w.word).toList()..shuffle();
      final wrongOptions = others.take(3).map((o) => o.meaning).toList();
      final allOptions = [w.meaning, ...wrongOptions]..shuffle();
      return _VocabQuizItem(word: w.word, correctMeaning: w.meaning, options: allOptions);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_isFlashcard ? 'Kelime Kartları' : 'Kelime Quiz', style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 17)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: _isComplete ? _buildResultView() : (_isFlashcard ? _buildFlashcardView() : _buildQuizView()),
    );
  }

  Widget _buildFlashcardView() {
    final word = widget.words[_cardIndex];
    final progress = (_cardIndex + 1) / widget.words.length;

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32))),
          ),
          const SizedBox(height: 8),
          Text('${_cardIndex + 1}/${widget.words.length}', style: TextStyle(color: AppTheme.textMuted, fontSize: _isSmallScreen ? 11 : 13)),
          const Spacer(),

          // Kart
          GestureDetector(
            onTap: () => setState(() => _showMeaning = !_showMeaning),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
              decoration: BoxDecoration(
                color: _showMeaning ? const Color(0xFF2E7D32).withOpacity(0.08) : AppTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.subtleShadow,
                border: Border.all(color: _showMeaning ? const Color(0xFF2E7D32).withOpacity(0.3) : Colors.grey.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  Text(word.word, style: TextStyle(fontSize: _isSmallScreen ? 22 : 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                  if (word.pronunciation != null) ...[
                    const SizedBox(height: 4),
                    Text(word.pronunciation!, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textMuted)),
                  ],
                  SizedBox(height: _isSmallScreen ? 10 : 16),
                  if (_showMeaning) ...[
                    Text(word.meaning, style: TextStyle(fontSize: _isSmallScreen ? 18 : 22, fontWeight: FontWeight.w600, color: const Color(0xFF2E7D32))),
                    SizedBox(height: _isSmallScreen ? 8 : 12),
                    Text(word.exampleSentence, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
                    const SizedBox(height: 4),
                    Text(word.exampleTranslation, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textMuted)),
                  ] else ...[
                    Text('Çevirmek için dokun', style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textMuted)),
                  ],
                ],
              ),
            ),
          ),

          const Spacer(),

          // İleri butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_cardIndex < widget.words.length - 1) {
                  setState(() {
                    _cardIndex++;
                    _showMeaning = false;
                  });
                } else {
                  setState(() => _isFlashcard = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_cardIndex < widget.words.length - 1 ? 'Sonraki Kelime' : 'Quize Geç', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final item = _quizItems[_quizIndex];
    final progress = (_quizIndex + 1) / _quizItems.length;

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32))),
          ),
          const SizedBox(height: 24),
          Text('Bu kelimenin anlamı nedir?', style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          Text('"${item.word}"', style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 24),

          ...List.generate(item.options.length, (i) {
            final isSelected = _selectedOption == i;
            final isCorrect = item.options[i] == item.correctMeaning;
            Color? bgColor;
            Color? borderColor;

            if (_answered) {
              if (isCorrect) {
                bgColor = const Color(0xFF4CAF50).withOpacity(0.15);
                borderColor = const Color(0xFF4CAF50);
              } else if (isSelected && !isCorrect) {
                bgColor = Colors.red.withOpacity(0.1);
                borderColor = Colors.red;
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
              child: InkWell(
                onTap: _answered ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(
                    color: bgColor ?? (isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor ?? (isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2)), width: isSelected || _answered ? 2 : 1),
                  ),
                  child: Text(item.options[i], style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: AppTheme.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ),
              ),
            );
          }),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null
                  ? () {
                      if (!_answered) {
                        if (item.options[_selectedOption!] == item.correctMeaning) _correctCount++;
                        setState(() => _answered = true);
                      } else {
                        if (_quizIndex < _quizItems.length - 1) {
                          setState(() { _quizIndex++; _selectedOption = null; _answered = false; });
                        } else {
                          _completeLesson();
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(_answered ? (_quizIndex < _quizItems.length - 1 ? 'Sonraki' : 'Tamamla') : 'Kontrol Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeLesson() async {
    await _service.completeLesson(unitId: widget.unitId, lessonType: LessonType.vocabulary, correctCount: _correctCount, totalCount: _quizItems.length);
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final isPerfect = _correctCount == _quizItems.length;
    final xp = isPerfect ? LessonType.vocabulary.baseXP * 2 : LessonType.vocabulary.baseXP;
    return _LessonResultView(correct: _correctCount, total: _quizItems.length, xp: xp, isPerfect: isPerfect);
  }
}

class _VocabQuizItem {
  final String word;
  final String correctMeaning;
  final List<String> options;
  _VocabQuizItem({required this.word, required this.correctMeaning, required this.options});
}

// ═══════════════════════════════════════════════════════════════
// READING DERS AKIŞI
// ═══════════════════════════════════════════════════════════════

class _ReadingLessonFlow extends StatefulWidget {
  final String unitId;
  final ReadingContent content;
  final LanguageLevel level;

  const _ReadingLessonFlow({required this.unitId, required this.content, required this.level});

  @override
  State<_ReadingLessonFlow> createState() => _ReadingLessonFlowState();
}

class _ReadingLessonFlowState extends State<_ReadingLessonFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  bool _isReading = true;
  int _quizIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _isComplete = false;
  String? _passage;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _passage = widget.content.passage;
    if (_passage == null || _passage!.isEmpty) _loadAIPassage();
  }

  Future<void> _loadAIPassage() async {
    final p = await _service.generateReadingPassage(widget.content.topic, widget.content.keywords, widget.level);
    if (mounted) setState(() => _passage = p ?? 'Paragraf yüklenemedi.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Okuma', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: _isComplete ? _buildResultView() : (_isReading ? _buildReadView() : _buildQuizView()),
    );
  }

  Widget _buildReadView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.content.topicTr, style: TextStyle(fontSize: _isSmallScreen ? 17 : 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(widget.content.topic, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: const Color(0xFF2E7D32))),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
            decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(14), boxShadow: AppTheme.subtleShadow),
            child: _passage == null
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : Text(_passage!, style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: AppTheme.textPrimary, height: 1.7)),
          ),
          SizedBox(height: _isSmallScreen ? 20 : 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _passage != null ? () => setState(() => _isReading = false) : null,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text('Soruları Yanıtla', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final q = widget.content.questions[_quizIndex];
    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: (_quizIndex + 1) / widget.content.questions.length, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)))),
          SizedBox(height: _isSmallScreen ? 16 : 24),
          Text(q.question, style: TextStyle(fontSize: _isSmallScreen ? 14 : 17, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          SizedBox(height: _isSmallScreen ? 12 : 20),
          ...List.generate(q.options.length, (i) {
            final isSelected = _selectedOption == i;
            final isCorrect = i == q.correctIndex;
            Color? bgColor, borderColor;
            if (_answered) {
              if (isCorrect) { bgColor = const Color(0xFF4CAF50).withOpacity(0.15); borderColor = const Color(0xFF4CAF50); }
              else if (isSelected) { bgColor = Colors.red.withOpacity(0.1); borderColor = Colors.red; }
            }
            return Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
              child: InkWell(
                onTap: _answered ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity, padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(color: bgColor ?? (isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor), borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor ?? (isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2)), width: isSelected || _answered ? 2 : 1)),
                  child: Text(q.options[i], style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ),
              ),
            );
          }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null ? () {
                if (!_answered) { if (_selectedOption == q.correctIndex) _correctCount++; setState(() => _answered = true); }
                else { if (_quizIndex < widget.content.questions.length - 1) { setState(() { _quizIndex++; _selectedOption = null; _answered = false; }); } else { _complete(); } }
              } : null,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.withOpacity(0.3), padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(_answered ? (_quizIndex < widget.content.questions.length - 1 ? 'Sonraki' : 'Tamamla') : 'Kontrol Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _complete() async {
    await _service.completeLesson(unitId: widget.unitId, lessonType: LessonType.reading, correctCount: _correctCount, totalCount: widget.content.questions.length);
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final total = widget.content.questions.length;
    final isPerfect = _correctCount == total;
    final xp = isPerfect ? LessonType.reading.baseXP * 2 : LessonType.reading.baseXP;
    return _LessonResultView(correct: _correctCount, total: total, xp: xp, isPerfect: isPerfect);
  }
}

// ═══════════════════════════════════════════════════════════════
// LISTENING DERS AKIŞI (TTS + Boşluk doldurma)
// ═══════════════════════════════════════════════════════════════

class _ListeningLessonFlow extends StatefulWidget {
  final String unitId;
  final ListeningContent content;

  const _ListeningLessonFlow({required this.unitId, required this.content});

  @override
  State<_ListeningLessonFlow> createState() => _ListeningLessonFlowState();
}

class _ListeningLessonFlowState extends State<_ListeningLessonFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  final FlutterTts _tts = FlutterTts();
  int _index = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _isComplete = false;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    _speakCurrent();
  }

  Future<void> _speakCurrent() async {
    final ex = widget.content.exercises[_index];
    await _tts.speak(ex.sentence);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Dinleme', style: TextStyle(color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.close, color: AppTheme.textPrimary), onPressed: () { _tts.stop(); Navigator.pop(context); })),
      body: _isComplete ? _buildResultView() : _buildExerciseView(),
    );
  }

  Widget _buildExerciseView() {
    final ex = widget.content.exercises[_index];
    final progress = (_index + 1) / widget.content.exercises.length;
    // Cümledeki boşluklu versiyon
    final blankedSentence = ex.sentence.replaceAll(ex.missingWord, '______');

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)))),
          const SizedBox(height: 24),
          Text('Cümleyi dinle ve boşluğu doldur:', style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textMuted)),
          SizedBox(height: _isSmallScreen ? 10 : 16),

          // Dinle butonu
          Center(
            child: GestureDetector(
              onTap: _speakCurrent,
              child: Container(
                padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
                decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.volume_up_rounded, color: const Color(0xFF2E7D32), size: _isSmallScreen ? 32 : 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(child: TextButton(onPressed: _speakCurrent, child: Text('Tekrar dinle', style: TextStyle(color: const Color(0xFF2E7D32), fontSize: _isSmallScreen ? 12 : 14)))),
          SizedBox(height: _isSmallScreen ? 10 : 16),

          // Boşluklu cümle
          Container(
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
            decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: AppTheme.subtleShadow),
            child: Text(blankedSentence, style: TextStyle(fontSize: _isSmallScreen ? 14 : 17, color: AppTheme.textPrimary, height: 1.5)),
          ),
          const SizedBox(height: 6),
          Text(ex.translation, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textMuted)),
          const SizedBox(height: 20),

          // Seçenekler
          ...List.generate(ex.options.length, (i) {
            final isSelected = _selectedOption == i;
            final isCorrect = i == ex.correctIndex;
            Color? bgColor, borderColor;
            if (_answered) {
              if (isCorrect) { bgColor = const Color(0xFF4CAF50).withOpacity(0.15); borderColor = const Color(0xFF4CAF50); }
              else if (isSelected) { bgColor = Colors.red.withOpacity(0.1); borderColor = Colors.red; }
            }
            return Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
              child: InkWell(
                onTap: _answered ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity, padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(color: bgColor ?? (isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor), borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor ?? (isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2)), width: isSelected || _answered ? 2 : 1)),
                  child: Text(ex.options[i], style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: AppTheme.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ),
              ),
            );
          }),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null ? () {
                if (!_answered) { if (_selectedOption == ex.correctIndex) _correctCount++; setState(() => _answered = true); }
                else { if (_index < widget.content.exercises.length - 1) { setState(() { _index++; _selectedOption = null; _answered = false; }); _speakCurrent(); } else { _complete(); } }
              } : null,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.withOpacity(0.3), padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(_answered ? (_index < widget.content.exercises.length - 1 ? 'Sonraki' : 'Tamamla') : 'Kontrol Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _complete() async {
    await _service.completeLesson(unitId: widget.unitId, lessonType: LessonType.listening, correctCount: _correctCount, totalCount: widget.content.exercises.length);
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final total = widget.content.exercises.length;
    final isPerfect = _correctCount == total;
    final xp = isPerfect ? LessonType.listening.baseXP * 2 : LessonType.listening.baseXP;
    return _LessonResultView(correct: _correctCount, total: total, xp: xp, isPerfect: isPerfect);
  }
}

// ═══════════════════════════════════════════════════════════════
// SPEAKING DERS AKIŞI (Diyalog + AI değerlendirme)
// ═══════════════════════════════════════════════════════════════

class _SpeakingLessonFlow extends StatefulWidget {
  final String unitId;
  final SpeakingContent content;
  final LanguageLevel level;

  const _SpeakingLessonFlow({required this.unitId, required this.content, required this.level});

  @override
  State<_SpeakingLessonFlow> createState() => _SpeakingLessonFlowState();
}

class _SpeakingLessonFlowState extends State<_SpeakingLessonFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  final TextEditingController _textController = TextEditingController();
  int _turnIndex = 0;
  int _correctCount = 0;
  int _totalUserTurns = 0;
  bool _isComplete = false;
  bool _isEvaluating = false;
  Map<String, dynamic>? _feedback;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Konuşma', style: TextStyle(color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.close, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: _isComplete ? _buildResultView() : _buildDialogueView(),
    );
  }

  Widget _buildDialogueView() {
    final turns = widget.content.dialogue;
    final visibleTurns = turns.sublist(0, (_turnIndex + 1).clamp(0, turns.length));

    return Column(
      children: [
        // Senaryo
        Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(_isSmallScreen ? 12 : 20, 8, _isSmallScreen ? 12 : 20, 0),
          padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
          decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
          child: Text(widget.content.scenarioTr, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: const Color(0xFF2E7D32))),
        ),

        // Diyalog listesi
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
            itemCount: visibleTurns.length,
            itemBuilder: (context, i) {
              final turn = visibleTurns[i];
              final isUser = turn.speaker == 'user';
              final isCurrent = i == _turnIndex;

              if (isUser && isCurrent && !_isEvaluating && _feedback == null) {
                return _buildUserInput(turn);
              }

              return _buildChatBubble(turn, isUser);
            },
          ),
        ),

        // AI feedback
        if (_feedback != null)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 12 : 20),
            padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              color: (_feedback!['grammarOk'] == true && _feedback!['contextOk'] == true) ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_feedback!['feedback'] ?? 'Geri bildirim alınamadı.', style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textPrimary)),
                if (_feedback!['suggestion'] != null && (_feedback!['suggestion'] as String).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Öneri: ${_feedback!['suggestion']}', style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: const Color(0xFF2E7D32), fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),

        if (_feedback != null || (_turnIndex < turns.length && turns[_turnIndex].speaker == 'bot'))
          Padding(
            padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _feedback = null;
                    _turnIndex++;
                    if (_turnIndex >= turns.length) _complete();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: Text(_turnIndex >= turns.length - 1 ? 'Tamamla' : 'Devam Et', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ),

        if (_isEvaluating) Padding(padding: EdgeInsets.all(_isSmallScreen ? 12 : 20), child: const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))),
      ],
    );
  }

  Widget _buildChatBubble(DialogueTurn turn, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isUser ? 14 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 14),
          ),
          boxShadow: isUser ? [] : AppTheme.subtleShadow,
        ),
        child: Text(
          turn.text.isNotEmpty ? turn.text : _textController.text,
          style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: isUser ? const Color(0xFF2E7D32) : AppTheme.textPrimary),
        ),
      ),
    );
  }

  Widget _buildUserInput(DialogueTurn turn) {
    return Padding(
      padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (turn.hint != null) Text(turn.hint!, style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: AppTheme.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Cevabınızı yazın...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    filled: true,
                    fillColor: AppTheme.cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                    contentPadding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 14, vertical: _isSmallScreen ? 10 : 12),
                  ),
                  style: TextStyle(fontSize: _isSmallScreen ? 13 : 15),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _textController.text.trim().isNotEmpty ? _submitAnswer : null,
                icon: const Icon(Icons.send_rounded, color: Color(0xFF2E7D32)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitAnswer() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _totalUserTurns++;
    setState(() => _isEvaluating = true);

    final result = await _service.evaluateSpeakingResponse(
      widget.content.scenario,
      widget.content.dialogue[_turnIndex].hint ?? '',
      text,
      widget.level,
    );

    if (result != null && result['grammarOk'] == true && result['contextOk'] == true) {
      _correctCount++;
    }

    if (mounted) {
      setState(() {
        _isEvaluating = false;
        _feedback = result ?? {'feedback': 'Cevabın kaydedildi.', 'grammarOk': true, 'contextOk': true};
      });
    }
  }

  Future<void> _complete() async {
    final total = _totalUserTurns > 0 ? _totalUserTurns : 1;
    await _service.completeLesson(unitId: widget.unitId, lessonType: LessonType.speaking, correctCount: _correctCount, totalCount: total);
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final total = _totalUserTurns > 0 ? _totalUserTurns : 1;
    final isPerfect = _correctCount == total;
    final xp = isPerfect ? LessonType.speaking.baseXP * 2 : LessonType.speaking.baseXP;
    return _LessonResultView(correct: _correctCount, total: total, xp: xp, isPerfect: isPerfect);
  }
}

// ═══════════════════════════════════════════════════════════════
// MIXED QUIZ & UNIT EXAM AKIŞI
// ═══════════════════════════════════════════════════════════════

class _QuizFlow extends StatefulWidget {
  final String unitId;
  final List<MixedQuizQuestion> questions;
  final LessonType lessonType;
  final String title;

  const _QuizFlow({required this.unitId, required this.questions, required this.lessonType, required this.title});

  @override
  State<_QuizFlow> createState() => _QuizFlowState();
}

class _QuizFlowState extends State<_QuizFlow> {
  final LanguageLearningService _service = LanguageLearningService();
  int _index = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;
  bool _isComplete = false;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(widget.title, style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 17)), backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(icon: const Icon(Icons.close, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: _isComplete ? _buildResultView() : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    final q = widget.questions[_index];
    final progress = (_index + 1) / widget.questions.length;
    final isExam = widget.lessonType == LessonType.unitExam;

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: Colors.grey.withOpacity(0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32))))),
              SizedBox(width: _isSmallScreen ? 8 : 12),
              Text('${_index + 1}/${widget.questions.length}', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 10 : 12)),
            ],
          ),
          SizedBox(height: _isSmallScreen ? 6 : 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(q.sourceType.label, style: TextStyle(fontSize: _isSmallScreen ? 10 : 11, color: AppTheme.textMuted)),
          ),
          SizedBox(height: _isSmallScreen ? 12 : 20),
          Text(q.question, style: TextStyle(fontSize: _isSmallScreen ? 14 : 17, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, height: 1.4)),
          SizedBox(height: _isSmallScreen ? 12 : 20),
          ...List.generate(q.options.length, (i) {
            final isSelected = _selectedOption == i;
            final isCorrect = i == q.correctIndex;
            Color? bgColor, borderColor;
            if (_answered && !isExam) {
              if (isCorrect) { bgColor = const Color(0xFF4CAF50).withOpacity(0.15); borderColor = const Color(0xFF4CAF50); }
              else if (isSelected) { bgColor = Colors.red.withOpacity(0.1); borderColor = Colors.red; }
            }
            return Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 8 : 10),
              child: InkWell(
                onTap: _answered ? null : () => setState(() => _selectedOption = i),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity, padding: EdgeInsets.symmetric(horizontal: _isSmallScreen ? 10 : 16, vertical: _isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(color: bgColor ?? (isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor), borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor ?? (isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2)), width: isSelected || _answered ? 2 : 1)),
                  child: Text(q.options[i], style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ),
              ),
            );
          }),
          if (_answered && q.explanation != null && !isExam) ...[
            SizedBox(height: _isSmallScreen ? 6 : 8),
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(color: AppTheme.cardColor, borderRadius: BorderRadius.circular(10)),
              child: Text(q.explanation!, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textSecondary)),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null ? () {
                if (!_answered) {
                  if (_selectedOption == q.correctIndex) _correctCount++;
                  if (isExam) {
                    // Sınavda feedback yok, direkt sonraki
                    if (_index < widget.questions.length - 1) { setState(() { _index++; _selectedOption = null; }); }
                    else { _complete(); }
                  } else {
                    setState(() => _answered = true);
                  }
                } else {
                  if (_index < widget.questions.length - 1) { setState(() { _index++; _selectedOption = null; _answered = false; }); }
                  else { _complete(); }
                }
              } : null,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.withOpacity(0.3), padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: Text(
                isExam ? (_index < widget.questions.length - 1 ? 'Sonraki' : 'Tamamla') : (_answered ? (_index < widget.questions.length - 1 ? 'Sonraki' : 'Tamamla') : 'Kontrol Et'),
                style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _complete() async {
    await _service.completeLesson(unitId: widget.unitId, lessonType: widget.lessonType, correctCount: _correctCount, totalCount: widget.questions.length);
    if (mounted) setState(() => _isComplete = true);
  }

  Widget _buildResultView() {
    final total = widget.questions.length;
    final isPerfect = _correctCount == total;
    final xp = isPerfect ? widget.lessonType.baseXP * 2 : widget.lessonType.baseXP;
    final isExam = widget.lessonType == LessonType.unitExam;
    final score = total > 0 ? (_correctCount / total * 100) : 0.0;
    final passed = score >= 60;

    if (isExam) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(passed ? '🎉' : '😔', style: TextStyle(fontSize: _isSmallScreen ? 44 : 56)),
              SizedBox(height: _isSmallScreen ? 12 : 20),
              Text(passed ? 'Ünite Tamamlandı!' : 'Başarısız', style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              SizedBox(height: _isSmallScreen ? 10 : 12),
              Text('$_correctCount/$total doğru (%${score.toStringAsFixed(0)})', style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, color: AppTheme.textSecondary)),
              if (!passed) ...[
                SizedBox(height: _isSmallScreen ? 6 : 8),
                Text('Geçme notu: %60. Tekrar dene!', style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: Colors.orange)),
              ],
              SizedBox(height: _isSmallScreen ? 6 : 8),
              Text('+$xp XP', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, color: Colors.amber, fontWeight: FontWeight.w600)),
              SizedBox(height: _isSmallScreen ? 20 : 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: Text(passed ? 'Devam Et' : 'Geri Dön', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _LessonResultView(correct: _correctCount, total: total, xp: xp, isPerfect: isPerfect);
  }
}

// ═══════════════════════════════════════════════════════════════
// ORTAK SONUÇ WIDGET'I
// ═══════════════════════════════════════════════════════════════

class _LessonResultView extends StatelessWidget {
  final int correct;
  final int total;
  final int xp;
  final bool isPerfect;

  const _LessonResultView({required this.correct, required this.total, required this.xp, required this.isPerfect});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isPerfect ? '🌟' : '✅', style: TextStyle(fontSize: isSmallScreen ? 44 : 56)),
            SizedBox(height: isSmallScreen ? 12 : 20),
            Text(isPerfect ? 'Mükemmel!' : 'Ders Tamamlandı!', style: TextStyle(fontSize: isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Text('$correct/$total doğru', style: TextStyle(fontSize: isSmallScreen ? 15 : 18, color: AppTheme.textSecondary)),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text('+$xp XP${isPerfect ? ' (2x Bonus!)' : ''}', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Colors.amber, fontWeight: FontWeight.w600)),
            SizedBox(height: isSmallScreen ? 20 : 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: Text('Devam Et', style: TextStyle(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
