import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/note_service.dart';
import '../services/course_service.dart'; // 🆕 Course Service import
import '../services/auth_service.dart';
import '../services/spaced_repetition_service.dart';
import '../services/localization_service.dart';

class NoteViewScreen extends StatefulWidget {
  final String title;
  final String content;
  final Uint8List? imageBytes;
  final String? imageUrl;

  const NoteViewScreen({
    super.key,
    required this.title,
    required this.content,
    this.imageBytes,
    this.imageUrl,
    this.courseId,
  });

  final String? courseId; // 🆕 Opsiyonel Course ID

  @override
  State<NoteViewScreen> createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  final NoteService _noteService = NoteService();
  final CourseService _courseService = CourseService(); // 🆕 Course Service
  final GeminiService _geminiService = GeminiService();
  final SpacedRepetitionService _srService = SpacedRepetitionService();
  final AuthService _authService = AuthService();

  bool _isSaving = false;
  bool _isConverting = false;
  bool _isSaved = false;

  Future<void> _saveNote() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    setState(() => _isSaving = true);
    
    String? noteId;
    
    // 🆕 Eğer courseId varsa oraya kaydet, yoksa genel notlara
    if (widget.courseId != null) {
      final note = await _courseService.addNote(
        courseId: widget.courseId!,
        title: widget.title,
        content: widget.content,
        imageUrl: widget.imageUrl,
      );
      noteId = note?.id;
    } else {
      noteId = await _noteService.saveNote(
        userId: userId,
        title: widget.title,
        content: widget.content,
        imageUrl: widget.imageUrl,
      );
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
        if (noteId != null) {
          _isSaved = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not başarıyla kaydedildi! 📝')),
          );
        }
      });
    }
  }

  Future<void> _convertToFlashcards() async {
    setState(() => _isConverting = true);

    try {
      final cards = await _geminiService.generateFlashcardsFromNote(widget.content);

      if (cards != null && cards.isNotEmpty) {
        for (var card in cards) {
          await _srService.addCard(
            questionId: 'note_${DateTime.now().millisecondsSinceEpoch}',
            questionText: card['question'] ?? '',
            topic: 'Notlarım',
            subTopic: widget.title,
            correctAnswer: card['answer'] ?? '',
          );
        }

        if (mounted) {
          _showFlashcardSuccessDialog(cards.length);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashcard oluşturulamadı.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Flashcard error: $e');
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  void _showFlashcardSuccessDialog(int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tebrikler! 🎉'),
        content: Text('Bu nottan tam $count adet çalışma kartı oluşturuldu ve "Tekrar Kartlarım" bölümüne eklendi.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Harika!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header with Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.imageBytes != null)
                    Image.memory(widget.imageBytes!, fit: BoxFit.cover)
                  else if (widget.imageUrl != null)
                    Image.network(widget.imageUrl!, fit: BoxFit.cover)
                  else
                    Container(color: AppTheme.primaryColor),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Color(0xFF16A34A), size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'AI notu analiz etti ve en verimli hale getirdi.',
                            style: TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Markdown Content
                  MarkdownBody(
                    data: widget.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
                      h2: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 20),
                      p: const TextStyle(color: AppTheme.textSecondary, fontSize: 16, height: 1.6),
                      listBullet: const TextStyle(color: AppTheme.primaryColor, fontSize: 16),
                      blockquote: const TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                      blockquoteDecoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        border: const Border(left: BorderSide(color: AppTheme.primaryColor, width: 4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
             Expanded(
              child: OutlinedButton.icon(
                onPressed: _isSaved ? null : (_isSaving ? null : _saveNote),
                icon: _isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(_isSaved ? Icons.check : Icons.save_rounded),
                label: Text(_isSaved ? context.tr('success') : context.tr('note_save')),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: _isSaved ? AppTheme.successColor : AppTheme.primaryColor),
                  foregroundColor: _isSaved ? AppTheme.successColor : AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isConverting ? null : _convertToFlashcards,
                icon: _isConverting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.style_rounded),
                label: Text(context.tr('note_flashcard')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
