/// SOLICAP - Micro Lesson Screen (v2)
/// Soru Çözüm Tüyoları - Kişiselleştirilmiş mikro dersler

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/points_service.dart';
import '../services/note_service.dart';
import '../services/auth_service.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_model.dart';

class MicroLessonScreen extends StatefulWidget {
  final String topic;
  final String subject;
  final int questionCount;
  final List<String>? questionSummaries;

  const MicroLessonScreen({
    super.key,
    required this.topic,
    required this.subject,
    this.questionCount = 1,
    this.questionSummaries,
  });

  @override
  State<MicroLessonScreen> createState() => _MicroLessonScreenState();
}

class _MicroLessonScreenState extends State<MicroLessonScreen> {
  final GeminiService _geminiService = GeminiService();
  final PointsService _pointsService = PointsService();
  final NoteService _noteService = NoteService();
  final AuthService _authService = AuthService();

  MicroLesson? _lesson;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Puan kontrolü
      final hasEnough = await _pointsService.hasEnoughPoints('micro_lesson');
      if (!hasEnough) {
        if (!mounted) return;
        final watched = await PointsService.showInsufficientPointsDialog(
          context,
          actionName: 'Mikro Ders',
          onPointsAdded: () {
            if (mounted) setState(() {});
          },
        );
        if (!watched) {
          if (mounted) Navigator.pop(context);
          return;
        }
      }

      final lesson = await _geminiService.generateMicroLesson(
        topic: widget.topic,
        subject: widget.subject,
        questionCount: widget.questionCount,
        questionSummaries: widget.questionSummaries,
      );

      if (lesson != null) {
        // 🏆 Liderlik Puanı Ekle (+20 mikro ders)
        await LeaderboardService().addPoints(
          LeaderboardPoints.microLesson,
          'micro_lesson',
        );
      }

      if (mounted) {
        setState(() {
          _lesson = lesson;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Mikro ders yükleme hatası: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveToNotes() async {
    if (_isSaving || _isSaved || _lesson == null) return;

    final userId = _authService.currentUserId;
    if (userId == null) return;

    setState(() => _isSaving = true);

    try {
      final noteId = await _noteService.saveNote(
        userId: userId,
        title: 'Mikro Ders: ${widget.topic}',
        content: _lesson!.coreExplanation,
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
          _isSaved = noteId != null;
        });

        if (noteId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not başarıyla kaydedildi! 📝'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not kaydedilemedi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? _buildLoadingState()
          : _lesson != null
              ? _buildLessonContent()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Soru çözüm tüyoları hazırlanıyor...',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.topic,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Ders yüklenemedi',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadLesson,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonContent() {
    final lesson = _lesson!;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lightbulb, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.subject} • ${widget.questionCount} soru çözüldü',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Greeting
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates, color: AppTheme.accentColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lesson.greeting,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Core Content (Markdown)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: MarkdownBody(
                data: lesson.coreExplanation,
                styleSheet: MarkdownStyleSheet(
                  h2: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 2,
                  ),
                  p: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    height: 1.7,
                  ),
                  listBullet: const TextStyle(color: AppTheme.textPrimary),
                  strong: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Analogy badge
        if (lesson.analogyUsed.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lesson.analogyUsed,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Save to notes button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaved ? null : (_isSaving ? null : _saveToNotes),
                icon: _isSaving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(_isSaved ? Icons.check : Icons.save_rounded),
                label: Text(_isSaved ? 'Kaydedildi' : 'Notlarıma Kaydet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSaved ? AppTheme.successColor : AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom spacing
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
