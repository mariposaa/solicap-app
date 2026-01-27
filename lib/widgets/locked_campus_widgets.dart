// -----------------------------------------------------------------------------
// ⛔ YASAK BÖLGE - LOCKED SECTION ⛔
// 
// Bu dosya, Kampüs modülündeki 'Not Tara' fonksiyonunu içerir.
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
import '../models/course_model.dart';
import '../screens/note_view_screen.dart';

class LockedCampusScanSection extends StatefulWidget {
  final Course course;

  const LockedCampusScanSection({
    super.key,
    required this.course,
  });

  @override
  State<LockedCampusScanSection> createState() => _LockedCampusScanSectionState();
}

class _LockedCampusScanSectionState extends State<LockedCampusScanSection> {
  final ImagePicker _picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _isScanning ? null : _scanNote,
          icon: _isScanning
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.document_scanner, size: 24),
          label: Text(
            _isScanning ? 'Not Taranıyor...' : '📷 Not Tara',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }

  Future<void> _scanNote() async {
    // Kaynak seç dialogu (Kilitli mantık ile aynı)
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '📝 Not Tarayıcı',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ders notunun fotoğrafını çek veya yükle.',
              style: TextStyle(color: AppTheme.textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    color: const Color(0xFF22C55E),
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOptionButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    color: const Color(0xFF22C55E),
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920, // Kilitli mantık ile aynı kalite ayarı
      );

      if (image == null) return;

      if (mounted) setState(() => _isScanning = true);

      // Görüntüyü oku
      final Uint8List imageBytes = await image.readAsBytes();

      // AI ile not düzenle (ana sayfadaki aynı fonksiyon)
      final result = await _geminiService.organizeStudentNotes(imageBytes);

      if (result != null && mounted) {
        // 🆕 Kilitli Mantık: Sonuç ekranına git (Ama save için courseId ver)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteViewScreen(
              title: result['title'] ?? 'Düzenlenmiş Not',
              content: result['content'] ?? '',
              imageBytes: imageBytes,
              courseId: widget.course.id, // 🆕 Persistence için önemli detay
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('❌ Not düzenlenemedi. Lütfen fotoğrafın net olduğundan emin olun.'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Not tarama hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Hata: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
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
}
