import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/award_announcement_service.dart';

/// Admin: Yarışmalar ekranındaki ödül duyurusunu düzenle (mor ekran ile sıralama arası)
class AdminAwardAnnouncementScreen extends StatefulWidget {
  const AdminAwardAnnouncementScreen({super.key});

  @override
  State<AdminAwardAnnouncementScreen> createState() => _AdminAwardAnnouncementScreenState();
}

class _AdminAwardAnnouncementScreenState extends State<AdminAwardAnnouncementScreen> {
  final AwardAnnouncementService _service = AwardAnnouncementService();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    _service.clearCache();
    final announcement = await _service.get();
    if (mounted) {
      _titleController.text = announcement.title;
      _bodyController.text = announcement.body;
      _isActive = announcement.isActive;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Başlık veya açıklama girin')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await _service.save(AwardAnnouncement(
        title: title.isEmpty ? 'Ödül Duyurusu' : title,
        body: body,
        isActive: _isActive,
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Ödül duyurusu kaydedildi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Hata: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('🏆 Ödül Duyurusu'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _isLoading ? null : _load),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yarışmalar ekranında mor özet kartı ile "İlkokul - Ortaokul" bölümü arasında gösterilir.',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Başlık',
                      hintText: '🏆 Ödül Duyurusu',
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bodyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Açıklama',
                      hintText: 'En çok puan toplayan öğrencilerimiz ödüllendirilecektir...',
                      filled: true,
                      fillColor: AppTheme.backgroundColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Duyuruyu göster'),
                    subtitle: const Text('Kapalıysa yarışmalar ekranında görünmez'),
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    activeColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isSaving ? 'Kaydediliyor...' : 'Kaydet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
