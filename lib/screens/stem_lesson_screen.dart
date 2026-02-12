/// SOLICAP - STEM Lesson Screen
/// 5 Aşamalı Ders Akışı: Konu Anlatımı → Çözümlü Örnekler → Pratik → Hız Testi → Sınav

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/stem_models.dart';
import '../services/stem_learning_service.dart';
import '../services/points_service.dart';
import '../theme/app_theme.dart';

class StemLessonScreen extends StatefulWidget {
  final StemUnit unit;
  final GradeLevel gradeLevel;
  final StemSubject subject;
  final StemProgress initialProgress;

  const StemLessonScreen({
    super.key,
    required this.unit,
    required this.gradeLevel,
    required this.subject,
    required this.initialProgress,
  });

  @override
  State<StemLessonScreen> createState() => _StemLessonScreenState();
}

class _StemLessonScreenState extends State<StemLessonScreen> {
  final StemLearningService _service = StemLearningService();
  late StemProgress _progress;
  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress;
  }

  Future<void> _refresh() async {
    final p = await _service.getProgress(widget.gradeLevel, widget.subject);
    if (mounted) setState(() => _progress = p);
  }

  String _getPointsAction(StemLessonType type) {
    switch (type) {
      case StemLessonType.topicExplanation:
      case StemLessonType.solvedExamples:
        return 'stem_basic_lesson';
      case StemLessonType.practice:
        return 'stem_ai_lesson';
      case StemLessonType.speedTest:
      case StemLessonType.topicExam:
        return 'stem_exam';
    }
  }

  int _getDiamondCost(StemLessonType type) {
    final action = _getPointsAction(type);
    return PointsService.costs[action] ?? 0;
  }

  Future<void> _startLesson(StemLessonType type, StemUnitContent content) async {
    final unitProg = _progress.unitProgresses[widget.unit.id];
    final alreadyCompleted = unitProg?.isLessonCompleted(type) ?? false;

    if (!alreadyCompleted) {
      final pointsAction = _getPointsAction(type);
      final pointsService = PointsService();
      final ok = await pointsService.checkAndSpendPoints(context, pointsAction);
      if (!ok) return;
    }

    if (!mounted) return;

    Widget screen;
    switch (type) {
      case StemLessonType.topicExplanation:
        screen = _TopicExplanationFlow(
          unitId: widget.unit.id,
          content: content.topic,
          gradeLevel: widget.gradeLevel,
          subject: widget.subject,
        );
        break;
      case StemLessonType.solvedExamples:
        screen = _SolvedExamplesFlow(
          unitId: widget.unit.id,
          examples: content.solvedExamples,
          gradeLevel: widget.gradeLevel,
          subject: widget.subject,
        );
        break;
      case StemLessonType.practice:
        screen = _QuizFlow(
          unitId: widget.unit.id,
          questions: content.practiceQuestions,
          lessonType: StemLessonType.practice,
          title: 'Pratik Sorular',
          gradeLevel: widget.gradeLevel,
          subject: widget.subject,
        );
        break;
      case StemLessonType.speedTest:
        screen = _SpeedTestFlow(
          unitId: widget.unit.id,
          questions: content.speedTestQuestions,
          gradeLevel: widget.gradeLevel,
          subject: widget.subject,
        );
        break;
      case StemLessonType.topicExam:
        screen = _QuizFlow(
          unitId: widget.unit.id,
          questions: content.examQuestions,
          lessonType: StemLessonType.topicExam,
          title: 'Konu Sınavı',
          gradeLevel: widget.gradeLevel,
          subject: widget.subject,
        );
        break;
    }

    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final content = _service.getContent(widget.unit.id);
    if (content == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.unit.titleTr)),
        body: const Center(child: Text('İçerik bulunamadı')),
      );
    }

    final unitProg = _progress.unitProgresses[widget.unit.id];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.unit.titleTr, style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 14 : 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
        itemCount: widget.unit.lessonOrder.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final type = widget.unit.lessonOrder[index];
          final isLocked = _service.isLessonLocked(widget.unit.id, type, _progress);
          final isCompleted = unitProg?.isLessonCompleted(type) ?? false;
          final cost = _getDiamondCost(type);

          return _buildLessonTile(type, isLocked, isCompleted, cost, content);
        },
      ),
    );
  }

  Widget _buildLessonTile(StemLessonType type, bool isLocked, bool isCompleted, int cost, StemUnitContent content) {
    return Material(
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
          padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
          decoration: BoxDecoration(
            color: isLocked ? AppTheme.cardColor.withOpacity(0.5) : AppTheme.cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isLocked ? [] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
            border: isCompleted ? Border.all(color: const Color(0xFF81C784).withOpacity(0.5), width: 1) : null,
          ),
          child: Row(
            children: [
              Container(
                width: _isSmallScreen ? 36 : 44,
                height: _isSmallScreen ? 36 : 44,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.withOpacity(0.08)
                      : isCompleted
                          ? const Color(0xFF81C784).withOpacity(0.12)
                          : const Color(0xFF37474F).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: isLocked
                    ? const Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: 20)
                    : Text(type.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            type.label,
                            style: TextStyle(
                              fontSize: _isSmallScreen ? 13 : 15,
                              fontWeight: FontWeight.w600,
                              color: isLocked ? AppTheme.textMuted : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF81C784).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Tekrar', style: TextStyle(fontSize: 10, color: Color(0xFF388E3C), fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '+${type.baseXP} XP',
                          style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: isLocked ? AppTheme.textMuted : AppTheme.textSecondary),
                        ),
                        if (!isCompleted && cost > 0) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.diamond, size: 12, color: isLocked ? AppTheme.textMuted : Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '$cost',
                            style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: isLocked ? AppTheme.textMuted : Colors.amber.shade700, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Color(0xFF81C784), size: 20)
              else if (!isLocked)
                const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// KONU ANLATIMI FLOW
// ═══════════════════════════════════════════════════════════════

class _TopicExplanationFlow extends StatefulWidget {
  final String unitId;
  final TopicContent content;
  final GradeLevel gradeLevel;
  final StemSubject subject;

  const _TopicExplanationFlow({
    required this.unitId,
    required this.content,
    required this.gradeLevel,
    required this.subject,
  });

  @override
  State<_TopicExplanationFlow> createState() => _TopicExplanationFlowState();
}

class _TopicExplanationFlowState extends State<_TopicExplanationFlow> {
  final StemLearningService _service = StemLearningService();
  String? _aiExplanation;
  bool _loadingAI = false;
  bool _completed = false;
  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  Future<void> _enrichTopic() async {
    // Elmas kontrolü
    final pointsService = PointsService();
    final ok = await pointsService.checkAndSpendPoints(context, 'stem_ai_lesson');
    if (!ok || !mounted) return;

    setState(() => _loadingAI = true);
    final result = await _service.enrichTopicExplanation(widget.content.summary, widget.gradeLevel);
    if (mounted) {
      setState(() {
        _aiExplanation = result;
        _loadingAI = false;
      });
      // Hata mesajı
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI yanıt veremedi. Lütfen tekrar dene.'), duration: Duration(seconds: 3)),
        );
      }
    }
  }

  Future<void> _complete() async {
    await _service.completeLesson(
      gradeLevel: widget.gradeLevel,
      subject: widget.subject,
      unitId: widget.unitId,
      lessonType: StemLessonType.topicExplanation,
      correctCount: 1,
      totalCount: 1,
    );
    if (mounted) {
      setState(() => _completed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Konu Anlatımı', style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 13 : 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Özet
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded, color: const Color(0xFF37474F), size: _isSmallScreen ? 18 : 20),
                      SizedBox(width: _isSmallScreen ? 6 : 8),
                      Text('Konu Özeti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 13 : 16, color: AppTheme.textPrimary)),
                    ],
                  ),
                  SizedBox(height: _isSmallScreen ? 8 : 12),
                  Text(widget.content.summary, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textSecondary, height: 1.6)),
                ],
              ),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 14),
            // Temel Kural
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFF37474F).withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF37474F).withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: const Color(0xFF37474F), size: _isSmallScreen ? 18 : 20),
                      SizedBox(width: _isSmallScreen ? 6 : 8),
                      Text('Temel Kural', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: const Color(0xFF37474F))),
                    ],
                  ),
                  SizedBox(height: _isSmallScreen ? 8 : 10),
                  Text(widget.content.rule, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textPrimary, height: 1.5)),
                ],
              ),
            ),
            // Formüller
            if (widget.content.formulas.isNotEmpty) ...[
              SizedBox(height: _isSmallScreen ? 10 : 14),
              Container(
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.functions_rounded, color: const Color(0xFF37474F), size: _isSmallScreen ? 18 : 20),
                        SizedBox(width: _isSmallScreen ? 6 : 8),
                        Text('Formüller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: AppTheme.textPrimary)),
                      ],
                    ),
                    SizedBox(height: _isSmallScreen ? 8 : 10),
                    ...widget.content.formulas.map((f) => Padding(
                      padding: EdgeInsets.only(bottom: _isSmallScreen ? 4 : 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: const Color(0xFF37474F), fontWeight: FontWeight.bold)),
                          Expanded(child: Text(f, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textPrimary, height: 1.4))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
            // Anahtar Noktalar
            if (widget.content.keyPoints.isNotEmpty) ...[
              SizedBox(height: _isSmallScreen ? 10 : 14),
              Container(
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: _isSmallScreen ? 18 : 20),
                        SizedBox(width: _isSmallScreen ? 6 : 8),
                        Text('Anahtar Noktalar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: AppTheme.textPrimary)),
                      ],
                    ),
                    SizedBox(height: _isSmallScreen ? 8 : 10),
                    ...widget.content.keyPoints.map((kp) => Padding(
                      padding: EdgeInsets.only(bottom: _isSmallScreen ? 2 : 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('★ ', style: TextStyle(fontSize: _isSmallScreen ? 11 : 12, color: Colors.amber)),
                          Expanded(child: Text(kp, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textPrimary, height: 1.4))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
            // AI Zenginleştirme
            if (_aiExplanation != null) ...[
              SizedBox(height: _isSmallScreen ? 10 : 14),
              Container(
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: const Color(0xFF388E3C), size: _isSmallScreen ? 18 : 20),
                        SizedBox(width: _isSmallScreen ? 6 : 8),
                        Text('AI Açıklama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: const Color(0xFF388E3C))),
                      ],
                    ),
                    SizedBox(height: _isSmallScreen ? 8 : 10),
                    Text(_aiExplanation!, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textPrimary, height: 1.5)),
                  ],
                ),
              ),
            ],
            SizedBox(height: _isSmallScreen ? 14 : 20),
            // Butonlar
            Row(
              children: [
                if (_aiExplanation == null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _loadingAI ? null : _enrichTopic,
                      icon: _loadingAI
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.auto_awesome, size: 18),
                      label: Text(_loadingAI ? 'Yükleniyor...' : 'AI ile Açıkla'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF37474F),
                        padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                if (_aiExplanation == null) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _completed ? () => Navigator.pop(context) : _complete,
                    icon: Icon(_completed ? Icons.check : Icons.arrow_forward, size: 18),
                    label: Text(_completed ? 'Tamam' : 'Anladım, Devam Et'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF37474F),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: _isSmallScreen ? 24 : 40),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ÇÖZÜMLÜ ÖRNEKLER FLOW
// ═══════════════════════════════════════════════════════════════

class _SolvedExamplesFlow extends StatefulWidget {
  final String unitId;
  final List<SolvedExample> examples;
  final GradeLevel gradeLevel;
  final StemSubject subject;

  const _SolvedExamplesFlow({
    required this.unitId,
    required this.examples,
    required this.gradeLevel,
    required this.subject,
  });

  @override
  State<_SolvedExamplesFlow> createState() => _SolvedExamplesFlowState();
}

class _SolvedExamplesFlowState extends State<_SolvedExamplesFlow> {
  final StemLearningService _service = StemLearningService();
  int _currentIndex = 0;
  bool _showSteps = false;
  bool _completed = false;
  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  Future<void> _complete() async {
    await _service.completeLesson(
      gradeLevel: widget.gradeLevel,
      subject: widget.subject,
      unitId: widget.unitId,
      lessonType: StemLessonType.solvedExamples,
      correctCount: widget.examples.length,
      totalCount: widget.examples.length,
    );
    if (mounted) setState(() => _completed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return _StemResultView(
        title: 'Çözümlü Örnekler',
        message: '${widget.examples.length} örneği inceledim',
        xp: StemLessonType.solvedExamples.baseXP,
        onContinue: () => Navigator.pop(context),
      );
    }

    final example = widget.examples[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Örnek ${_currentIndex + 1}/${widget.examples.length}', style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 13 : 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlerleme
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / widget.examples.length,
                minHeight: 4,
                backgroundColor: Colors.grey.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF37474F)),
              ),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 16),
            // Soru
            Container(
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.quiz_outlined, color: const Color(0xFF37474F), size: _isSmallScreen ? 18 : 20),
                      SizedBox(width: _isSmallScreen ? 6 : 8),
                      Text('Soru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: AppTheme.textPrimary)),
                    ],
                  ),
                  SizedBox(height: _isSmallScreen ? 8 : 10),
                  Text(example.question, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textPrimary, height: 1.5)),
                ],
              ),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 14),
            // Çözüm Adımları
            if (!_showSteps)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _showSteps = true),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('Çözümü Göster'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF37474F),
                    padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            else ...[
              Container(
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.format_list_numbered, color: const Color(0xFF1565C0), size: _isSmallScreen ? 18 : 20),
                        SizedBox(width: _isSmallScreen ? 6 : 8),
                        Text('Çözüm Adımları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 15, color: const Color(0xFF1565C0))),
                      ],
                    ),
                    SizedBox(height: _isSmallScreen ? 8 : 12),
                    ...example.steps.asMap().entries.map((entry) => Padding(
                      padding: EdgeInsets.only(bottom: _isSmallScreen ? 6 : 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${entry.key + 1}', style: TextStyle(fontSize: _isSmallScreen ? 11 : 12, fontWeight: FontWeight.bold, color: const Color(0xFF1565C0))),
                          ),
                          SizedBox(width: _isSmallScreen ? 8 : 10),
                          Expanded(child: Text(entry.value, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textPrimary, height: 1.4))),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(height: _isSmallScreen ? 10 : 14),
              // Cevap
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF81C784).withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: const Color(0xFF388E3C), size: _isSmallScreen ? 18 : 20),
                    SizedBox(width: _isSmallScreen ? 6 : 8),
                    Text('Cevap: ${example.answer}', style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, fontWeight: FontWeight.bold, color: const Color(0xFF388E3C))),
                  ],
                ),
              ),
            ],
            SizedBox(height: _isSmallScreen ? 14 : 20),
            // Devam Et
            if (_showSteps)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_currentIndex < widget.examples.length - 1) {
                      setState(() {
                        _currentIndex++;
                        _showSteps = false;
                      });
                    } else {
                      _complete();
                    }
                  },
                  icon: Icon(_currentIndex < widget.examples.length - 1 ? Icons.arrow_forward : Icons.check, size: 18),
                  label: Text(_currentIndex < widget.examples.length - 1 ? 'Sonraki Örnek' : 'Tamamla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37474F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// QUİZ / SINAV FLOW (Pratik + Konu Sınavı)
// ═══════════════════════════════════════════════════════════════

class _QuizFlow extends StatefulWidget {
  final String unitId;
  final List<StemQuestion> questions;
  final StemLessonType lessonType;
  final String title;
  final GradeLevel gradeLevel;
  final StemSubject subject;

  const _QuizFlow({
    required this.unitId,
    required this.questions,
    required this.lessonType,
    required this.title,
    required this.gradeLevel,
    required this.subject,
  });

  @override
  State<_QuizFlow> createState() => _QuizFlowState();
}

class _QuizFlowState extends State<_QuizFlow> {
  final StemLearningService _service = StemLearningService();
  int _index = 0;
  int _correct = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _isComplete = false;
  String? _aiHint;
  bool _loadingHint = false;
  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  Future<void> _getHint() async {
    // Elmas kontrolü
    final pointsService = PointsService();
    final ok = await pointsService.checkAndSpendPoints(context, 'stem_ai_lesson');
    if (!ok || !mounted) return;

    setState(() => _loadingHint = true);
    final hint = await _service.generateHint(widget.questions[_index].question, widget.gradeLevel);
    if (mounted) {
      setState(() { _aiHint = hint; _loadingHint = false; });
      // Hata mesajı
      if (hint == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI yanıt veremedi. Lütfen tekrar dene.'), duration: Duration(seconds: 3)),
        );
      }
    }
  }

  void _answer(int idx) {
    if (_answered) return;
    final q = widget.questions[_index];
    final isCorrect = idx == q.correctIndex;
    setState(() {
      _selectedAnswer = idx;
      _answered = true;
      if (isCorrect) _correct++;
    });
  }

  void _next() {
    if (_index < widget.questions.length - 1) {
      setState(() {
        _index++;
        _selectedAnswer = null;
        _answered = false;
        _aiHint = null;
      });
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await _service.completeLesson(
      gradeLevel: widget.gradeLevel,
      subject: widget.subject,
      unitId: widget.unitId,
      lessonType: widget.lessonType,
      correctCount: _correct,
      totalCount: widget.questions.length,
    );
    if (mounted) setState(() => _isComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      final score = widget.questions.isNotEmpty ? (_correct / widget.questions.length * 100) : 0;
      return _StemResultView(
        title: widget.title,
        message: '$_correct / ${widget.questions.length} doğru (%${score.toInt()})',
        xp: widget.lessonType.baseXP,
        onContinue: () => Navigator.pop(context),
      );
    }

    final q = widget.questions[_index];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('${widget.title} (${_index + 1}/${widget.questions.length})', style: TextStyle(color: AppTheme.textPrimary, fontSize: _isSmallScreen ? 12 : 14)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlerleme
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_index + 1) / widget.questions.length,
                minHeight: 4,
                backgroundColor: Colors.grey.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF37474F)),
              ),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 16),
            // Soru
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Text(q.question, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary, height: 1.5)),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 14),
            // Seçenekler
            ...q.options.asMap().entries.map((entry) {
              final idx = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswer == idx;
              final isCorrectOption = idx == q.correctIndex;

              Color bgColor = AppTheme.cardColor;
              Color borderColor = Colors.transparent;
              if (_answered) {
                if (isCorrectOption) {
                  bgColor = const Color(0xFFE8F5E9);
                  borderColor = const Color(0xFF81C784);
                } else if (isSelected && !isCorrectOption) {
                  bgColor = const Color(0xFFFFEBEE);
                  borderColor = Colors.red.shade300;
                }
              } else if (isSelected) {
                bgColor = const Color(0xFF37474F).withOpacity(0.06);
                borderColor = const Color(0xFF37474F);
              }

              return Padding(
                padding: EdgeInsets.only(bottom: _isSmallScreen ? 6 : 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _answered ? null : () => _answer(idx),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor == Colors.transparent ? AppTheme.dividerColor : borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF37474F).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              String.fromCharCode(65 + idx),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 13, color: const Color(0xFF37474F)),
                            ),
                          ),
                          SizedBox(width: _isSmallScreen ? 8 : 12),
                          Expanded(child: Text(option, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textPrimary))),
                          if (_answered && isCorrectOption)
                            const Icon(Icons.check_circle, color: Color(0xFF388E3C), size: 20)
                          else if (_answered && isSelected && !isCorrectOption)
                            const Icon(Icons.cancel, color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            // Açıklama
            if (_answered && q.explanation != null) ...[
              SizedBox(height: _isSmallScreen ? 8 : 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: const Color(0xFF7B1FA2), size: _isSmallScreen ? 16 : 18),
                    SizedBox(width: _isSmallScreen ? 6 : 8),
                    Expanded(child: Text(q.explanation!, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: const Color(0xFF4A148C), height: 1.4))),
                  ],
                ),
              ),
            ],
            // AI İpucu
            if (!_answered && _aiHint == null)
              Padding(
                padding: EdgeInsets.only(top: _isSmallScreen ? 8 : 10),
                child: TextButton.icon(
                  onPressed: _loadingHint ? null : _getHint,
                  icon: _loadingHint
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.lightbulb_outline, size: 16),
                  label: Text(_loadingHint ? 'Yükleniyor...' : 'İpucu Al (AI)'),
                  style: TextButton.styleFrom(foregroundColor: Colors.amber.shade700),
                ),
              ),
            if (_aiHint != null) ...[
              SizedBox(height: _isSmallScreen ? 8 : 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(_isSmallScreen ? 10 : 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber, size: _isSmallScreen ? 16 : 18),
                    SizedBox(width: _isSmallScreen ? 6 : 8),
                    Expanded(child: Text(_aiHint!, style: TextStyle(fontSize: _isSmallScreen ? 11 : 13, color: AppTheme.textPrimary, height: 1.4))),
                  ],
                ),
              ),
            ],
            SizedBox(height: _isSmallScreen ? 10 : 16),
            // Devam Et
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _next,
                  icon: Icon(_index < widget.questions.length - 1 ? Icons.arrow_forward : Icons.check, size: 18),
                  label: Text(_index < widget.questions.length - 1 ? 'Sonraki Soru' : 'Bitir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37474F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: _isSmallScreen ? 10 : 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HIZ TESTİ FLOW
// ═══════════════════════════════════════════════════════════════

class _SpeedTestFlow extends StatefulWidget {
  final String unitId;
  final List<StemQuestion> questions;
  final GradeLevel gradeLevel;
  final StemSubject subject;

  const _SpeedTestFlow({
    required this.unitId,
    required this.questions,
    required this.gradeLevel,
    required this.subject,
  });

  @override
  State<_SpeedTestFlow> createState() => _SpeedTestFlowState();
}

class _SpeedTestFlowState extends State<_SpeedTestFlow> {
  final StemLearningService _service = StemLearningService();
  int _index = 0;
  int _correct = 0;
  bool _isComplete = false;
  late DateTime _startTime;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_isComplete) {
        setState(() => _elapsedSeconds = DateTime.now().difference(_startTime).inSeconds);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _answer(int idx) {
    final q = widget.questions[_index];
    if (idx == q.correctIndex) _correct++;

    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    _timer?.cancel();
    final elapsed = DateTime.now().difference(_startTime).inSeconds;
    await _service.completeLesson(
      gradeLevel: widget.gradeLevel,
      subject: widget.subject,
      unitId: widget.unitId,
      lessonType: StemLessonType.speedTest,
      correctCount: _correct,
      totalCount: widget.questions.length,
      timeSpentSeconds: elapsed,
    );
    if (mounted) setState(() { _isComplete = true; _elapsedSeconds = elapsed; });
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      final score = widget.questions.isNotEmpty ? (_correct / widget.questions.length * 100) : 0;
      return _StemResultView(
        title: 'Hız Testi',
        message: '$_correct / ${widget.questions.length} doğru (%${score.toInt()})\nSüre: ${_formatTime(_elapsedSeconds)}',
        xp: StemLessonType.speedTest.baseXP + (_elapsedSeconds < 60 ? 15 : _elapsedSeconds < 120 ? 10 : 0),
        onContinue: () => Navigator.pop(context),
      );
    }

    final q = widget.questions[_index];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.timer, color: Colors.red, size: _isSmallScreen ? 16 : 18),
            SizedBox(width: _isSmallScreen ? 4 : 6),
            Text(_formatTime(_elapsedSeconds), style: TextStyle(color: Colors.red, fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_index + 1}/${widget.questions.length}', style: TextStyle(color: AppTheme.textSecondary, fontSize: _isSmallScreen ? 12 : 14)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İlerleme
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: (_index + 1) / widget.questions.length,
                minHeight: 4,
                backgroundColor: Colors.grey.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 16),
            // Soru
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(_isSmallScreen ? 10 : 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: Text(q.question, style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary, height: 1.5)),
            ),
            SizedBox(height: _isSmallScreen ? 10 : 14),
            // Seçenekler
            ...q.options.asMap().entries.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: _isSmallScreen ? 6 : 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _answer(entry.key),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(_isSmallScreen ? 10 : 14),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            String.fromCharCode(65 + entry.key),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isSmallScreen ? 12 : 13, color: Colors.red),
                          ),
                        ),
                        SizedBox(width: _isSmallScreen ? 8 : 12),
                        Expanded(child: Text(entry.value, style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: AppTheme.textPrimary))),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SONUÇ EKRANI
// ═══════════════════════════════════════════════════════════════

class _StemResultView extends StatelessWidget {
  final String title;
  final String message;
  final int xp;
  final VoidCallback onContinue;

  const _StemResultView({
    required this.title,
    required this.message,
    required this.xp,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 64 : 80,
                height: isSmallScreen ? 64 : 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 32 : 40),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check_circle, color: const Color(0xFF388E3C), size: isSmallScreen ? 40 : 48),
              ),
              SizedBox(height: isSmallScreen ? 14 : 20),
              Text(title, style: TextStyle(fontSize: isSmallScreen ? 17 : 20, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(message, style: TextStyle(fontSize: isSmallScreen ? 13 : 15, color: AppTheme.textSecondary), textAlign: TextAlign.center),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 14 : 20, vertical: isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('⚡', style: TextStyle(fontSize: isSmallScreen ? 15 : 18)),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text('+$xp XP', style: TextStyle(fontSize: isSmallScreen ? 15 : 18, fontWeight: FontWeight.bold, color: const Color(0xFFF57F17))),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37474F),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Devam Et', style: TextStyle(fontSize: isSmallScreen ? 14 : 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
