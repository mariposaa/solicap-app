/// 📚 KAMPÜS MODÜLÜ - Ders Detay Ekranı
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/course_model.dart';
import '../models/exam_prep_model.dart';
import '../services/course_service.dart';
import '../services/exam_prep_service.dart';
import '../services/gemini_service.dart';
import '../services/points_service.dart';
import '../theme/app_theme.dart';
import '../widgets/locked_campus_widgets.dart'; // 🔒 Locked Section Import
import 'note_view_screen.dart';
import 'exam_prep_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final CourseService _courseService = CourseService();
  final ExamPrepService _examPrepService = ExamPrepService();
  final GeminiService _geminiService = GeminiService();
  bool _isPreparingExam = false;
  ExamPrep? _existingExamPrep; // Mevcut sınav hazırlığı varsa



  @override
  void initState() {
    super.initState();
    _loadExistingExamPrep();
  }

  /// Mevcut sınav hazırlığını yükle (varsa)
  Future<void> _loadExistingExamPrep() async {
    final existing = await _examPrepService.getExamPrep(widget.course.id);
    if (mounted && existing != null) {
      setState(() => _existingExamPrep = existing);
    }
  }

  /// 🚀 Sınava Hazırla - Gemini 2.5 Flash ile Study Guide + Flashcards üret
  Future<void> _prepareForExam() async {
    final notes = await _courseService.getAllNotes(widget.course.id);

    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Analiz için en az 1 not gerekli'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (notes.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('💡 En az 3 not olması önerilir, daha kapsamlı hazırlık için not ekleyin'),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // Puan kontrolü (Sınava Hazırlık = 50 elmas)
    final hasPoints = await PointsService().hasEnoughPoints('exam_prep');
    if (!hasPoints) {
      await PointsService.showInsufficientPointsDialog(context, actionName: 'Sınava Hazırlık');
      return;
    }

    setState(() => _isPreparingExam = true);
    
    // 🔄 Animasyonlu yükleme dialog'u göster
    _showPreparingDialog();

    try {
      // 🧠 ExamPrepService ile sınav hazırlığı üret
      final examPrep = await _examPrepService.generateExamPrep(
        notes: notes,
        course: widget.course,
      );

      // Dialog'u kapat
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      setState(() => _isPreparingExam = false);

      if (examPrep == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('❌ Notların sınav hazırlığı için yeterli veri içermiyor'),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        return;
      }

      // Puan harca (50 elmas)
      await PointsService().spendPoints('exam_prep', description: '${widget.course.name} Sınav Hazırlık');

      // State'i güncelle
      setState(() => _existingExamPrep = examPrep);

      // 🎉 Başarı mesajı ve yönlendirme
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${examPrep.chapterCount} bölüm ve ${examPrep.flashcardCount} ezber kartı hazır!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );

        // Sınav hazırlık ekranına git
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExamPrepScreen(examPrep: examPrep),
          ),
        );
      }
    } catch (e) {
      // Dialog'u kapat
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      debugPrint('❌ Sınav hazırlık hatası: $e');
      setState(() => _isPreparingExam = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Bir hata oluştu: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// 🔄 Animasyonlu hazırlık dialog'u
  void _showPreparingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dönen loading
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withOpacity(0.2),
                        Colors.orange.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Başlık
                const Text(
                  'Sınava Hazırlanıyor...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                
                // İpucu mesajı
                const _AnimatedPrepTipText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Mevcut ExamPrep'i görüntüle
  void _viewExistingExamPrep() {
    if (_existingExamPrep != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamPrepScreen(examPrep: _existingExamPrep!),
        ),
      );
    }
  }

  /// Not kartına tıklama - detay ve indirme
  void _showNoteDetail(CourseNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Başlık ve butonlar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.blue),
                    onPressed: () => _downloadNote(note),
                    tooltip: 'İndir',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNote(note),
                    tooltip: 'Sil',
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // İçerik
            Expanded(
              child: Markdown(
                controller: scrollController,
                data: note.content,
                padding: const EdgeInsets.all(16),
                styleSheet: MarkdownStyleSheet(
                  h2: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                  p: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadNote(CourseNote note) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${note.title.replaceAll(' ', '_')}.md');
      await file.writeAsString('# ${note.title}\n\n${note.content}');
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${note.title} - ${widget.course.name}',
      );
    } catch (e) {
      debugPrint('❌ İndirme hatası: $e');
    }
  }

  Future<void> _deleteNote(CourseNote note) async {
    Navigator.pop(context); // Bottom sheet'i kapat
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notu Sil'),
        content: Text('"${note.title}" notunu silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _courseService.deleteNote(note.id, widget.course.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          // Mevcut ExamPrep varsa "Görüntüle" butonu
          if (_existingExamPrep != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: _viewExistingExamPrep,
                icon: const Icon(Icons.menu_book, color: Colors.amber),
                tooltip: 'Mevcut Hazırlığı Görüntüle',
              ),
            ),
          // Sınava Hazırla butonu
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _isPreparingExam ? null : _prepareForExam,
              icon: _isPreparingExam 
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Icon(
                      _existingExamPrep != null ? Icons.refresh : Icons.school, 
                      size: 18,
                    ),
              label: Text(
                _isPreparingExam 
                    ? 'Hazırlanıyor...' 
                    : (_existingExamPrep != null ? 'Yeniden Hazırla' : 'Sınava Hazırla'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Not Tara Butonu
          LockedCampusScanSection(course: widget.course),
          // Notlar Grid
          Expanded(
            child: StreamBuilder<List<CourseNote>>(
              stream: _courseService.getNotesStream(widget.course.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return _buildEmptyState();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) => _buildNoteCard(notes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(CourseNote note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () => _showNoteDetail(note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Text(
                note.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              // İçerik önizleme
              Expanded(
                child: Text(
                  note.content.replaceAll(RegExp(r'[#*`\[\]]'), ''),
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ),
              // Tarih
              Text(
                DateFormat('dd/MM').format(note.createdAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.note_add_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz Not Yok',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yukarıdaki "Not Tara" butonuyla\nilk notunu ekle!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔄 Sınav hazırlığı için yanıp sönen ipucu mesajı
class _AnimatedPrepTipText extends StatefulWidget {
  const _AnimatedPrepTipText();

  @override
  State<_AnimatedPrepTipText> createState() => _AnimatedPrepTipTextState();
}

class _AnimatedPrepTipTextState extends State<_AnimatedPrepTipText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  int _currentTipIndex = 0;

  static const List<String> _tips = [
    '📚 Notların analiz ediliyor...',
    '🧠 Yapay zeka çalışma rehberi oluşturuyor...',
    '🃏 Ezber kartları hazırlanıyor...',
    '📖 Bölümler düzenleniyor...',
    '⚠️ Önemli uyarılar tespit ediliyor...',
    '✨ Son rötuşlar yapılıyor...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (mounted) {
          setState(() {
            _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
          });
        }
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        _tips[_currentTipIndex],
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
