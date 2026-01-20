import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/smart_note_service.dart';
import '../services/user_dna_service.dart'; // UserID için
import '../models/smart_note_model.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'smart_note_detail_screen.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  final SmartNoteService _noteService = SmartNoteService();
  final UserDNAService _dnaService = UserDNAService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final uid = await _dnaService.getUserId();
    if (mounted) {
      setState(() => _userId = uid);
    }
  }

  Future<void> _addNewNote() async {
    if (_userId == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() => _isLoading = true);

      // Phase 1: Sadece OCR (Şimdilik)
      // Phase 2: UI güncellenmesi
      // Phase 3: AI Analiz eklenecek
      
      final File imageFile = File(image.path);
      final smartNote = await _noteService.processNote(
        imageFile: imageFile, 
        userId: _userId!
      );

      if (smartNote != null) {
        await _noteService.saveSmartNote(smartNote);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Ders notu başarıyla tarandı ve kaydedildi!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Not işlenirken bir sorun oluştu.'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Kampüs Asistanı'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textPrimary),
            onPressed: () {}, // Gelecekte arama
          ),
        ],
      ),
      body: _userId == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<SmartNote>>(
              stream: _noteService.getUserSmartNotes(_userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Hata: ${snapshot.error}'),
                  );
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(notes[index]);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'campus_fab',
        onPressed: _isLoading ? null : _addNewNote,
        backgroundColor: AppTheme.primaryColor,
        icon: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.add_a_photo_outlined),
        label: Text(_isLoading ? 'İşleniyor...' : 'Not Tara'),
      ),
    );
  }

  Widget _buildNoteCard(SmartNote note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SmartNoteDetailScreen(note: note),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.school, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // AI başlık bulana kadar tarih göster
                          'Ders Notu - ${DateFormat('dd MMM HH:mm').format(note.createdAt)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          note.isProcessed ? '✅ Analiz Tamamlandı' : '⏳ İşleniyor...',
                          style: TextStyle(
                            color: note.isProcessed ? AppTheme.successColor : AppTheme.warningColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                note.ocrText.isEmpty ? 'Metin yok' : note.ocrText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (note.highlights.isNotEmpty)
                    _buildBadge(Icons.highlight, '${note.highlights.length} Önemli'),
                  if (note.summary.formulas.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: _buildBadge(Icons.functions, '${note.summary.formulas.length} Formül'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textMuted),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories_outlined, size: 80, color: AppTheme.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'Henüz not eklemedin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ders notlarının fotoğrafını çek,\nAI senin için düzenlesin.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}
