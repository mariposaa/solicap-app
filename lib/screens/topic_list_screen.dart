/// SOLICAP - Topic List Screen (v2)
/// Bugün çözülen konuların listesi - Mikro Ders girişi

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/question_service.dart';
import '../services/auth_service.dart';
import '../models/question_model.dart';
import 'micro_lesson_screen.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

/// Bugünün konu grubu modeli
class TodayTopicGroup {
  final String subject;
  final String topic;
  final int questionCount;
  final List<QuestionSummary> questionSummaries;

  TodayTopicGroup({
    required this.subject,
    required this.topic,
    required this.questionCount,
    required this.questionSummaries,
  });
}

/// Soru özeti (AI'a gönderilecek)
class QuestionSummary {
  final String questionText;
  final bool? wasCorrect;

  QuestionSummary({required this.questionText, this.wasCorrect});
}

class _TopicListScreenState extends State<TopicListScreen> {
  final QuestionService _questionService = QuestionService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  List<TodayTopicGroup> _topicGroups = [];
  int _totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    _loadTodayTopics();
  }

  Future<void> _loadTodayTopics() async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final questions = await _questionService.getTodayQuestions(userId);

      // subject + topic bazında grupla + soru özetlerini topla
      final Map<String, List<QuestionSummary>> summariesMap = {};
      final Map<String, String> subjectMap = {};
      final Map<String, String> topicMap = {};

      for (final q in questions) {
        final key = '${q.subject}::${q.topic}';
        subjectMap[key] = q.subject;
        topicMap[key] = q.topic;
        summariesMap.putIfAbsent(key, () => []);
        // Maksimum 5 soru özeti al (token tasarrufu)
        if (summariesMap[key]!.length < 5) {
          summariesMap[key]!.add(QuestionSummary(
            questionText: q.questionText.length > 200
                ? '${q.questionText.substring(0, 200)}...'
                : q.questionText,
            wasCorrect: q.wasCorrect,
          ));
        }
      }

      final Map<String, TodayTopicGroup> groups = {};
      for (final key in summariesMap.keys) {
        groups[key] = TodayTopicGroup(
          subject: subjectMap[key]!,
          topic: topicMap[key]!,
          questionCount: summariesMap[key]!.length,
          questionSummaries: summariesMap[key]!,
        );
      }

      // Soru sayısına göre sırala (çok çözülen üstte)
      final sorted = groups.values.toList()
        ..sort((a, b) => b.questionCount.compareTo(a.questionCount));

      if (mounted) {
        setState(() {
          _topicGroups = sorted;
          _totalQuestions = questions.length;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Bugünün konuları yüklenemedi: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mikro Ders',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : _topicGroups.isEmpty
              ? _buildEmptyState()
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Üst bilgi kartı
        _buildHeaderCard(),
        const SizedBox(height: 8),
        // Konu listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _topicGroups.length,
            itemBuilder: (context, index) {
              return _buildTopicCard(_topicGroups[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.auto_stories, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bugün Çözdüğün Konular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bir konu seç, sana özel soru çözüm tüyoları al!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_totalQuestions soru',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(TodayTopicGroup group) {
    final subjectIcon = _getSubjectIcon(group.subject);
    final subjectColor = _getSubjectColor(group.subject);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _navigateToMicroLesson(group),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Sol ikon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: subjectColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(subjectIcon, color: subjectColor, size: 22),
                ),
                const SizedBox(width: 14),
                // Orta bilgi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.topic,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            group.subject,
                            style: TextStyle(
                              color: subjectColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${group.questionCount} soru',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Sağ buton
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Tüyo Al',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMicroLesson(TodayTopicGroup group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MicroLessonScreen(
          topic: group.topic,
          subject: group.subject,
          questionCount: group.questionCount,
          questionSummaries: group.questionSummaries
              .map((s) => '${s.wasCorrect == true ? "✅" : s.wasCorrect == false ? "❌" : "❓"} ${s.questionText}')
              .toList(),
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('matematik')) return Icons.calculate;
    if (lower.contains('fizik')) return Icons.bolt;
    if (lower.contains('kimya')) return Icons.science;
    if (lower.contains('biyoloji')) return Icons.biotech;
    if (lower.contains('türkçe') || lower.contains('edebiyat')) return Icons.menu_book;
    if (lower.contains('tarih')) return Icons.history_edu;
    if (lower.contains('coğrafya')) return Icons.public;
    if (lower.contains('geometri')) return Icons.hexagon;
    if (lower.contains('ingilizce') || lower.contains('english')) return Icons.translate;
    return Icons.school;
  }

  Color _getSubjectColor(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('matematik')) return Colors.blue;
    if (lower.contains('fizik')) return Colors.orange;
    if (lower.contains('kimya')) return Colors.green;
    if (lower.contains('biyoloji')) return Colors.teal;
    if (lower.contains('türkçe') || lower.contains('edebiyat')) return Colors.purple;
    if (lower.contains('tarih')) return Colors.brown;
    if (lower.contains('coğrafya')) return Colors.cyan;
    if (lower.contains('geometri')) return Colors.indigo;
    if (lower.contains('ingilizce') || lower.contains('english')) return Colors.red;
    return AppTheme.primaryColor;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories, size: 64, color: AppTheme.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'Bugün henüz soru çözmedin',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Soru çözdükçe burada konuların belirecek\nve sana özel tüyolar alabileceksin!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
