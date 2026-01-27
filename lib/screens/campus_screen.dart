/// 📚 KAMPÜS MODÜLÜ - Ana Ekran (Ders Listesi)
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../theme/app_theme.dart';
import 'course_detail_screen.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  final CourseService _courseService = CourseService();
  final TextEditingController _courseNameController = TextEditingController();

  @override
  void dispose() {
    _courseNameController.dispose();
    super.dispose();
  }

  /// Ders Ekleme Dialogu
  Future<void> _showAddCourseDialog() async {
    _courseNameController.clear();
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.school, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            const Text('Ders Ekle'),
          ],
        ),
        content: TextField(
          controller: _courseNameController,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Ders adı (ör: Biyoloji, Fizik)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.book_outlined),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_courseNameController.text.trim().isNotEmpty) {
                Navigator.pop(context, _courseNameController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _courseService.addCourse(result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📚 "$result" dersi eklendi'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title: const Text('📚 Kampüs', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: StreamBuilder<List<Course>>(
        stream: _courseService.getCoursesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) => _buildCourseCard(courses[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCourseDialog,
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Ders Ekle'),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(course: course),
            ),
          );
        },
        onLongPress: () => _showDeleteDialog(course),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // İkon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _getCourseIcon(course.name),
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Bilgiler
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.noteCount} not',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Ok ikonu
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCourseIcon(String courseName) {
    final name = courseName.toLowerCase();
    if (name.contains('matematik') || name.contains('math')) return Icons.calculate;
    if (name.contains('fizik') || name.contains('physics')) return Icons.speed;
    if (name.contains('kimya') || name.contains('chemistry')) return Icons.science;
    if (name.contains('biyoloji') || name.contains('biology')) return Icons.biotech;
    if (name.contains('tarih') || name.contains('history')) return Icons.history_edu;
    if (name.contains('coğrafya') || name.contains('geography')) return Icons.public;
    if (name.contains('edebiyat') || name.contains('literature')) return Icons.menu_book;
    if (name.contains('türkçe') || name.contains('turkish')) return Icons.text_fields;
    if (name.contains('ingilizce') || name.contains('english')) return Icons.translate;
    return Icons.school;
  }

  Future<void> _showDeleteDialog(Course course) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dersi Sil'),
        content: Text('"${course.name}" dersini ve tüm notlarını silmek istediğinize emin misiniz?'),
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
      await _courseService.deleteCourse(course.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🗑️ "${course.name}" silindi'),
            backgroundColor: Colors.orange.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Henüz Ders Eklenmemiş',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Derslerini ekleyerek notlarını düzenle,\nsınavlara hazır ol!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddCourseDialog,
              icon: const Icon(Icons.add),
              label: const Text('İlk Dersini Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
