// -----------------------------------------------------------------------------
// ⛔ YASAK BÖLGE - LOCKED SECTION ⛔
// 
// Bu dosya, uygulamanın kritik 'Soru Çöz' ve 'Not Düzenle' fonksiyonlarını içerir.
// Kullanıcının özel isteği üzerine KİLİTLENMİŞTİR.
//
// 🛑 BURADA İZİNSİZ DEĞİŞİKLİK YAPMAK KESİNLİKLE YASAKTIR.
// 🛑 DO NOT MODIFY THIS FILE WITHOUT EXPLICIT PERMISSION.
// -----------------------------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/points_service.dart';
import '../screens/note_view_screen.dart';

class LockedHomeActionCard extends StatefulWidget {
  final Future<void> Function(ImageSource) onCaptureQuestion;

  const LockedHomeActionCard({
    super.key,
    required this.onCaptureQuestion,
  });

  @override
  State<LockedHomeActionCard> createState() => _LockedHomeActionCardState();
}

class _LockedHomeActionCardState extends State<LockedHomeActionCard> {
  final ImagePicker _picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // 🔹 Soru Çöz Butonu (Mavi)
            Expanded(
              child: GestureDetector(
                onTap: () => _showCaptureOptions(isNote: false),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Soru Çöz',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Fotoğraf çek, AI çözsün!',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 🌿 Not Düzenle Butonu (Yeşil)
            Expanded(
              child: GestureDetector(
                onTap: () => _showCaptureOptions(isNote: true),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Not Düzenle',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Tahtayı/Defteri tara ve özetle!',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // ⚠️ Silik uyarı yazısı
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            '💡 Çözüm bazen hata verebilir. Tekrar çözdürme doğru sonuç verecektir.',
            style: TextStyle(
              color: AppTheme.textMuted,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // 🔄 İşlem Göstergesi (Eğer işlem yapılıyorsa)
        if (_isProcessing)
           Padding(
             padding: const EdgeInsets.only(top: 16),
             child: const LinearProgressIndicator(),
           ),
      ],
    );
  }

  void _showCaptureOptions({required bool isNote}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isNote ? '📝 Not Tarayıcı' : '🔍 Soru Çözücü',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isNote ? 'Ders notunun fotoğrafını çek veya yükle.' : 'Sorunun fotoğrafını çek veya yükle.',
              style: const TextStyle(color: AppTheme.textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    color: isNote ? const Color(0xFF22C55E) : AppTheme.primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      if (isNote) {
                        _organizeNote(ImageSource.camera);
                      } else {
                        widget.onCaptureQuestion(ImageSource.camera);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    color: isNote ? const Color(0xFF22C55E) : AppTheme.primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      if (isNote) {
                        _organizeNote(ImageSource.gallery);
                      } else {
                        widget.onCaptureQuestion(ImageSource.gallery);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _organizeNote(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image == null) return;

      if (mounted) setState(() => _isProcessing = true);

      final Uint8List imageBytes = await image.readAsBytes();
      
      final result = await _geminiService.organizeStudentNotes(imageBytes);

      if (result != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteViewScreen(
              title: result['title'] ?? 'Düzenlenmiş Not',
              content: result['content'] ?? '',
              imageBytes: imageBytes,
            ),
          ),
        );
      } else {
        _showError('Not düzenlenemedi. Lütfen fotoğrafın net olduğundan emin olun.');
      }
    } on InsufficientPointsException {
      if (mounted) {
        final watched = await PointsService.showInsufficientPointsDialog(
          context,
          actionName: PointsService.getCostDescription('organize_note'),
          onPointsAdded: () {},
        );
        
        if (watched && mounted) {
          _organizeNote(source);
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
      _showError('Bir hata oluştu: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
