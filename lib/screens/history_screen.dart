/// SOLICAP - History Screen
/// Çözülen sorular geçmişi

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/question_service.dart';
import '../services/auth_service.dart';
import '../models/question_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final QuestionService _questionService = QuestionService();
  final AuthService _authService = AuthService();
  
  String? _selectedSubject;

  final List<String> _subjects = [
    'Tümü',
    'Matematik',
    'Fizik',
    'Kimya',
    'Biyoloji',
    'Türkçe',
    'Tarih',
    'Coğrafya',
  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUserId;

    return Material(
      color: AppTheme.backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Çözüm Geçmişi',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

          // Filtre
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final isSelected = _selectedSubject == subject ||
                    (subject == 'Tümü' && _selectedSubject == null);

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSubject = subject == 'Tümü' ? null : subject;
                      });
                    },
                    backgroundColor: AppTheme.surfaceColor,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                    ),
                    checkmarkColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Soru Listesi
          Expanded(
            child: userId == null 
                ? const Center(child: Text('Lütfen giriş yapın.'))
                : StreamBuilder<List<QuestionModel>>(
                    stream: _questionService.getUserQuestionsStream(
                      userId,
                      subject: _selectedSubject,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Hata: ${snapshot.error}'));
                      }

                      final questions = snapshot.data ?? [];

                      if (questions.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildQuestionList(questions);
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Henüz soru çözmediniz',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bir soru fotoğrafı çekip çözmeye başlayın!',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionList(List<QuestionModel> questions) {
    return RefreshIndicator(
      onRefresh: () async {
        // Stream zaten her değişikliği takip eder, ama manuel yenileme de snapshota düşer
        setState(() {});
      },
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return _buildQuestionCard(question);
        },
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    final subjectColor =
        AppTheme.subjectColors[question.subject] ?? AppTheme.primaryColor;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showQuestionDetail(question),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Konu İkonu
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subjectColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getSubjectIcon(question.subject),
                    color: subjectColor,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Detaylar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.topic,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        question.subject,
                        style: TextStyle(
                          color: subjectColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(question.createdAt),
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Durum
                if (question.wasCorrect != null)
                  Icon(
                    question.wasCorrect!
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: question.wasCorrect!
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showQuestionDetail(QuestionModel question) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.textMuted,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Başlık
                Text(
                  question.topic,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '${question.subject} • ${_formatDate(question.createdAt)}',
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
                
                const SizedBox(height: 24),
                
                // Soru Görseli
                if (question.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      question.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.broken_image, color: AppTheme.errorColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Soru
                if (question.questionText.isNotEmpty) ...[
                  const Text(
                    'Soru',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.questionText,
                    style: const TextStyle(color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 24),
                ],
                
                // Çözüm
                const Text(
                  'Çözüm',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question.solution,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematik':
        return Icons.calculate;
      case 'fizik':
        return Icons.science;
      case 'kimya':
        return Icons.biotech;
      case 'biyoloji':
        return Icons.eco;
      case 'türkçe':
        return Icons.menu_book;
      case 'tarih':
        return Icons.history_edu;
      case 'coğrafya':
        return Icons.public;
      default:
        return Icons.school;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Az önce';
    if (diff.inHours < 1) return '${diff.inMinutes} dk önce';
    if (diff.inDays < 1) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';

    return '${date.day}.${date.month}.${date.year}';
  }
}
