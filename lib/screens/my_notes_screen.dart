import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/note_service.dart';
import '../services/auth_service.dart';
import '../models/note_model.dart';
import 'note_view_screen.dart';

class MyNotesScreen extends StatefulWidget {
  const MyNotesScreen({super.key});

  @override
  State<MyNotesScreen> createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  final NoteService _noteService = NoteService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUserId;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notlarım', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: userId == null
          ? const Center(child: Text('Lütfen giriş yapın.'))
          : StreamBuilder<List<StudyNote>>(
              stream: _noteService.getUserNotes(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_alt_outlined, size: 64, color: AppTheme.textMuted.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'Henüz kaydedilmiş bir notun yok.',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ders notlarını tarayıp buraya kaydedebilirsin.',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return _buildNoteCard(note);
                  },
                );
              },
            ),
    );
  }

  Widget _buildNoteCard(StudyNote note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: note.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(note.imageUrl!, fit: BoxFit.cover),
                )
              : const Icon(Icons.description_outlined, color: AppTheme.primaryColor),
        ),
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          note.content.split('\n').first.replaceAll('#', '').trim(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteViewScreen(
                title: note.title,
                content: note.content,
                imageUrl: note.imageUrl,
              ),
            ),
          );
        },
      ),
    );
  }
}
