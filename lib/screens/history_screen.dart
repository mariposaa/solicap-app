/// SOLICAP - History Screen
/// Çözülen sorular geçmişi

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/question_model.dart';
import '../services/auth_service.dart';
import '../models/question_model.dart';
import '../services/question_service.dart';
import '../theme/app_theme.dart';

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _dateFilter = 'Tümü'; // Tümü, Bugün, Bu Hafta, Bu Ay

  final List<String> _dateFilters = ['Tümü', 'Bugün', 'Bu Hafta', 'Bu Ay'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            
            // 🔍 Arama Çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Soru veya konu ara...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 📅 Tarih Filtresi
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dateFilters.length,
                itemBuilder: (context, index) {
                  final filter = _dateFilters[index];
                  final isSelected = _dateFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => _dateFilter = filter),
                      backgroundColor: AppTheme.surfaceColor,
                      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      checkmarkColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // 📚 Ders Filtresi
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
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
                        limit: 100, // 🆕 Limit artırıldı (100 soru)
                        subject: _selectedSubject,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Hata: ${snapshot.error}'));
                        }

                        // 🔥 CLIENT-SIDE FILTRELEME
                        var questions = snapshot.data ?? [];
                        
                        // 1. Arama Filtresi
                        if (_searchQuery.isNotEmpty) {
                          questions = questions.where((q) {
                            return q.questionText.toLowerCase().contains(_searchQuery) ||
                                   q.topic.toLowerCase().contains(_searchQuery) ||
                                   q.subject.toLowerCase().contains(_searchQuery);
                          }).toList();
                        }
                        
                        // 2. Tarih Filtresi
                        if (_dateFilter != 'Tümü') {
                          final now = DateTime.now();
                          questions = questions.where((q) {
                            final date = q.createdAt;
                            if (_dateFilter == 'Bugün') {
                              return date.year == now.year && date.month == now.month && date.day == now.day;
                            } else if (_dateFilter == 'Bu Hafta') {
                              return now.difference(date).inDays < 7;
                            } else if (_dateFilter == 'Bu Ay') {
                              return date.year == now.year && date.month == now.month;
                            }
                            return true;
                          }).toList();
                        }

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
                

                
                // 🏷️ Metadata Rozetleri (Maliyet ve Kaynak)
                Row(
                  children: [
                    _buildMetadataBadge(
                      label: question.source == 'GoldenDB' ? 'Altın DB' : 'Yapay Zeka',
                      icon: question.source == 'GoldenDB' ? Icons.storage : Icons.auto_awesome,
                      color: question.source == 'GoldenDB' ? Colors.amber : Colors.purple,
                    ),
                    if (question.cost > 0) ...[
                      const SizedBox(width: 8),
                      _buildMetadataBadge(
                        label: '≈${question.cost} TL',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                
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
                  MarkdownBody(
                    data: _formatSolutionText(question.solution),
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: AppTheme.textPrimary, height: 1.6, fontSize: 16),
                      strong: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                      h3: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
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

  /// 📝 Çözüm metnini Markdown formatına çevir
  String _formatSolutionText(String raw) {
    if (raw.isEmpty) return 'Çözüm bulunamadı.';

    String formatted = raw;

    // 1. Adım Başlıklarını Kalınlaştır
    // "1. Adım:", "Adım 1:", "Step 1:" gibi ifadeleri bulup ** ** içine al
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?:^|\n)(\d+\.\s*Adım|Adım\s*\d+|Step\s*\d+)(?::|\s)', caseSensitive: false),
      (match) => '\n\n### ${match.group(1)}\n',
    );

    // 2. Anahtar kelimeleri vurgula (Cevap, Sonuç, Uyarı)
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?:^|\n)(Cevap|Yanıt|Sonuç|Uyarı|Not|Dikkat|İpucu)(?::|\s)', caseSensitive: false),
      (match) => '\n\n**${match.group(1)}** ',
    );

    // 3. Madde işaretlerini düzelt (- veya * ile başlayanları alt satıra al)
    formatted = formatted.replaceAllMapped(
      RegExp(r'(?<!\n)([•\-\*])\s+'), 
      (match) => '\n${match.group(1)} ',
    );

    // 4. LaTeX benzeri matematik ifadeleri (basit)
    // $x$ formatını koru ama etrafına boşluk bırak
    // (Flutter Markdown basit matematik desteği vermez ama en azından düzgün görünür)

    return formatted.trim();
  }

  // 🏷️ Metadata Rozeti Helper
  Widget _buildMetadataBadge({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
