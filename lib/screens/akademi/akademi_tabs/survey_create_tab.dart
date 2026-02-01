/// Anket Oluştur Tab - Yükle, AI Parse, Düzenle, Ödeme

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../../models/survey_model.dart';
import '../../../services/akademi_service.dart';
import 'survey_editor_sheet.dart';

class SurveyCreateTab extends StatefulWidget {
  const SurveyCreateTab({super.key});

  @override
  State<SurveyCreateTab> createState() => _SurveyCreateTabState();
}

class _SurveyCreateTabState extends State<SurveyCreateTab> {
  final AkademiService _akademiService = AkademiService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Anketini Yükle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fotoğraf veya Word dosyası yükleyin. Yapay zeka anketi tıklanabilir forma çevirecek.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Fotoğraf yükle
          _buildUploadCard(
            icon: Icons.camera_alt,
            title: 'Fotoğraf ile Yükle',
            subtitle: 'Anketin fotoğrafını çekin veya galeriden seçin',
            color: Colors.blue,
            onTap: _uploadPhoto,
          ),
          const SizedBox(height: 12),

          // Belge görseli yükle (Word/PDF ekran görüntüsü veya fotoğrafı)
          _buildUploadCard(
            icon: Icons.description,
            title: 'Belge Görseli ile Yükle',
            subtitle: 'Word/PDF ekran görüntüsü veya fotoğrafı',
            color: Colors.indigo,
            onTap: _uploadDocumentImage,
          ),

          if (_isLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: TextStyle(color: Colors.red.shade900))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadPhoto() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final xfile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (xfile == null) {
        setState(() => _isLoading = false);
        return;
      }
      final bytes = await xfile.readAsBytes();
      final questions = await _akademiService.parseSurveyFromImage(bytes);
      if (!mounted) return;
      _openEditor(questions, null);
    } catch (e) {
      if (mounted) setState(() => _error = 'Parse hatası: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadDocumentImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final xfile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (xfile == null) {
        setState(() => _isLoading = false);
        return;
      }
      final bytes = await xfile.readAsBytes();
      final questions = await _akademiService.parseSurveyFromImage(bytes);
      if (!mounted) return;
      _openEditor(questions, null);
    } catch (e) {
      if (mounted) setState(() => _error = 'Parse hatası: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openEditor(List<SurveyQuestion> questions, String? title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SurveyEditorSheet(
        initialQuestions: questions,
        initialTitle: title ?? 'Anket',
        onSave: _onEditorSave,
      ),
    );
  }

  Future<void> _onEditorSave(String title, List<SurveyQuestion> questions, bool includeDemographics) async {
    Navigator.pop(context);
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final surveyId = await _akademiService.createSurvey(
        title: title,
        questions: questions,
        includeDemographics: includeDemographics,
      );
      if (!mounted) return;
      _showPaymentSheet(surveyId, title, questions.length + (includeDemographics ? 3 : 0));
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Kayıt hatası: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPaymentSheet(String surveyId, String title, int questionCount) {
    final price = AkademiService.calculatePrice(questionCount);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Ödeme', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('$title', style: const TextStyle(fontSize: 16)),
            Text('$questionCount soru • ₺$price', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Anketiniz 3 gün yayında kalacak. En az 50 katılımcı hedeflenir. Dolduranlara 50 puan verilir.',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _akademiService.completePayment(surveyId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Ödeme tamamlandı! Anketiniz yayında.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Ödeme Yap (Uygulama İçi Satın Alma)', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Text(
              'Not: Gerçek IAP entegrasyonu yapılandırılacak',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
