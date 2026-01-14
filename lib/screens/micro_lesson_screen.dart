/// SOLICAP - Micro Lesson Screen
/// Nokta Atışı Konu Anlatımı - Kişiselleştirilmiş mikro dersler

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/analytics_service.dart';
import '../services/user_dna_service.dart';
import '../models/user_dna_model.dart';

class MicroLessonScreen extends StatefulWidget {
  final String topic;
  final List<String>? strugglePoints;

  const MicroLessonScreen({
    super.key,
    required this.topic,
    this.strugglePoints,
  });

  @override
  State<MicroLessonScreen> createState() => _MicroLessonScreenState();
}

class _MicroLessonScreenState extends State<MicroLessonScreen> {
  final GeminiService _geminiService = GeminiService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final UserDNAService _dnaService = UserDNAService();
  
  MicroLesson? _lesson;
  bool _isLoading = true;
  String? _userAnswer;
  String? _errorMessage;
  bool _showQuizResult = false;
  UserDNA? _dna;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _dna = await _dnaService.getDNA();
      
      final lesson = await _geminiService.generateMicroLesson(
        topic: widget.topic,
        strugglePoints: widget.strugglePoints ?? _dna?.weakTopics.map((w) => w.subTopic).toList(),
        knownConcepts: _dna?.strongTopics,
        interests: _dna?.interests,
      );

      // 📊 Analytics: Mikro ders görüntülendi
      if (lesson != null) {
        await _analyticsService.logMicroLessonViewed(
          subject: lesson.title.split(' ').first, // basit subject çıkarımı
          topic: widget.topic,
        );
      }

      if (mounted) {
        setState(() {
          _lesson = lesson;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Mikro ders yükleme hatası: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? _buildLoadingState()
          : _lesson != null
              ? _buildLessonContent()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sana özel ders hazırlanıyor...',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.topic,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 64),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Ders yüklenemedi',
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadLesson,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonContent() {
    final lesson = _lesson!;
    
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: AppTheme.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_fix_high,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lesson.analogyUsed,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.accentColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.waving_hand,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          lesson.greeting,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Ana anlatım
                const Text(
                  '📚 Ders',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    lesson.coreExplanation,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      height: 1.8,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Kontrol sorusu
                if (lesson.quickCheckQuestion.isNotEmpty) ...[
                  const Text(
                    '🎯 Hızlı Kontrol',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuickCheck(lesson.quickCheckQuestion),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickCheck(String question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successColor.withOpacity(0.1),
            AppTheme.successColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (!_showQuizResult) ...[
            TextField(
              onChanged: (value) => _userAnswer = value,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Cevabını yaz...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                filled: true,
                fillColor: AppTheme.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _showQuizResult = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                ),
                child: const Text('Kontrol Et'),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.successColor,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Harika! Konuyu anladığını gösterdin. 🎉',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Derse Devam Et'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
