/// SOLICAP - Kütüphane Arkadaşın Olacak kriter formu
/// LGS, YKS TYT, YKS Sayısal/Sözel/Eşit Ağırlık, KPSS, ALES, DGS - max 2 seçim

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/library_buddy_model.dart';
import '../../services/library_buddy_service.dart';

class LibraryBuddyFormScreen extends StatefulWidget {
  const LibraryBuddyFormScreen({super.key});

  @override
  State<LibraryBuddyFormScreen> createState() => _LibraryBuddyFormScreenState();
}

class _LibraryBuddyFormScreenState extends State<LibraryBuddyFormScreen> {
  final LibraryBuddyService _service = LibraryBuddyService();
  final Set<String> _selected = {};
  bool _saving = false;

  static const int maxSelection = 2;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    final entry = await _service.getMyPoolEntry();
    if (entry != null && mounted) {
      setState(() {
        _selected.clear();
        _selected.addAll(entry.criteria.take(maxSelection));
      });
    }
  }

  void _toggle(String code) {
    setState(() {
      if (_selected.contains(code)) {
        _selected.remove(code);
      } else if (_selected.length < maxSelection) {
        _selected.add(code);
      }
    });
  }

  Future<void> _save() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En az 1 kriter seçin.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final ok = await _service.joinPool(_selected.toList());
      if (mounted) {
        setState(() => _saving = false);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Havuza eklendin. Eşleşince bildirim alacaksın.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kayıt yapılamadı.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Çalışma Arkadaşı Kriterleri', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hangi tür çalışma arkadaşı arıyorsun? (En fazla $maxSelection seç)',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Uygun arkadaş gelince bildirim alacaksın.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ...libraryBuddyCriteria.map((c) => CheckboxListTile(
                  value: _selected.contains(c.code),
                  onChanged: _selected.length >= maxSelection && !_selected.contains(c.code)
                      ? null
                      : (bool? _) => _toggle(c.code),
                  title: Text(c.label, style: const TextStyle(color: AppTheme.textPrimary)),
                  activeColor: AppTheme.primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _saving
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
