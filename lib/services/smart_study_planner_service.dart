/// SOLICAP - Smart Study Planner Service V2
/// Kişiselleştirilmiş AI-powered çalışma planları
/// SM-2 Spaced Repetition + Hedef Takibi + Tamamlama İzleme

import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/learning_event_model.dart';
import '../models/question_session_model.dart';
import '../models/user_dna_model.dart';
import 'session_tracking_service.dart';
import 'user_dna_service.dart';
import 'learning_insights_service.dart';
import 'gemini_service.dart';
import 'prompt_registry_service.dart';
import 'auth_service.dart';

// ============================================================================
// MODELS
// ============================================================================

/// SM-2 Spaced Repetition Card
class SM2Card {
  final String id;
  final String topic;
  final String subTopic;
  final int repetitions; // Tekrar sayısı
  final double easeFactor; // Kolaylık faktörü (1.3 - 2.5)
  final int interval; // Gün olarak tekrar aralığı
  final DateTime nextReview; // Sonraki tekrar tarihi
  final DateTime lastReview;
  final int quality; // Son performans (0-5)

  SM2Card({
    required this.id,
    required this.topic,
    required this.subTopic,
    this.repetitions = 0,
    this.easeFactor = 2.5,
    this.interval = 1,
    required this.nextReview,
    required this.lastReview,
    this.quality = 3,
  });

  /// SM-2 algoritmasına göre kart güncelle
  SM2Card updateWithQuality(int newQuality) {
    // Quality: 0 = tam unutmuş, 5 = mükemmel hatırladı
    int newReps = repetitions;
    int newInterval = interval;
    double newEF = easeFactor;

    if (newQuality >= 3) {
      // Başarılı - aralığı artır
      if (repetitions == 0) {
        newInterval = 1;
      } else if (repetitions == 1) {
        newInterval = 6;
      } else {
        newInterval = (interval * easeFactor).round();
      }
      newReps = repetitions + 1;
    } else {
      // Başarısız - sıfırla
      newReps = 0;
      newInterval = 1;
    }

    // Ease Factor güncelle (SM-2 formülü)
    newEF = easeFactor + (0.1 - (5 - newQuality) * (0.08 + (5 - newQuality) * 0.02));
    newEF = max(1.3, newEF); // Minimum 1.3

    return SM2Card(
      id: id,
      topic: topic,
      subTopic: subTopic,
      repetitions: newReps,
      easeFactor: newEF,
      interval: newInterval,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
      lastReview: DateTime.now(),
      quality: newQuality,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'topic': topic,
    'subTopic': subTopic,
    'repetitions': repetitions,
    'easeFactor': easeFactor,
    'interval': interval,
    'nextReview': nextReview.toIso8601String(),
    'lastReview': lastReview.toIso8601String(),
    'quality': quality,
  };

  factory SM2Card.fromJson(Map<String, dynamic> json) => SM2Card(
    id: json['id'] ?? '',
    topic: json['topic'] ?? '',
    subTopic: json['subTopic'] ?? '',
    repetitions: json['repetitions'] ?? 0,
    easeFactor: (json['easeFactor'] ?? 2.5).toDouble(),
    interval: json['interval'] ?? 1,
    nextReview: DateTime.tryParse(json['nextReview'] ?? '') ?? DateTime.now(),
    lastReview: DateTime.tryParse(json['lastReview'] ?? '') ?? DateTime.now(),
    quality: json['quality'] ?? 3,
  );
}

/// Günlük çalışma hedefleri
class DailyGoals {
  final int targetQuestions;
  final int targetMinutes;
  final Map<String, int> difficultyMix; // {"easy": 30, "medium": 50, "hard": 20}
  
  DailyGoals({
    this.targetQuestions = 15,
    this.targetMinutes = 45,
    this.difficultyMix = const {"easy": 30, "medium": 50, "hard": 20},
  });

  factory DailyGoals.fromJson(Map<String, dynamic> json) => DailyGoals(
    targetQuestions: json['target_questions'] ?? 15,
    targetMinutes: json['target_minutes'] ?? 45,
    difficultyMix: Map<String, int>.from(json['difficulty_mix'] ?? {}),
  );
}

/// Çalışma bloğu
class StudyBlock {
  final int order;
  final String topic;
  final String subTopic;
  final String type; // weak_topic, spaced_rep, strengthen, new_topic
  final int questionCount;
  final int estimatedMinutes;
  final String reason;
  final String emoji;
  bool isCompleted;
  int questionsCompleted;
  DateTime? completedAt;

  StudyBlock({
    required this.order,
    required this.topic,
    required this.subTopic,
    required this.type,
    required this.questionCount,
    required this.estimatedMinutes,
    required this.reason,
    this.emoji = '📚',
    this.isCompleted = false,
    this.questionsCompleted = 0,
    this.completedAt,
  });

  factory StudyBlock.fromJson(Map<String, dynamic> json) => StudyBlock(
    order: json['order'] ?? 0,
    topic: json['topic'] ?? '',
    subTopic: json['sub_topic'] ?? '',
    type: json['type'] ?? 'strengthen',
    questionCount: json['question_count'] ?? 5,
    estimatedMinutes: json['estimated_minutes'] ?? 15,
    reason: json['reason'] ?? '',
    emoji: json['emoji'] ?? '📚',
    isCompleted: json['isCompleted'] ?? false,
    questionsCompleted: json['questionsCompleted'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'order': order,
    'topic': topic,
    'sub_topic': subTopic,
    'type': type,
    'question_count': questionCount,
    'estimated_minutes': estimatedMinutes,
    'reason': reason,
    'emoji': emoji,
    'isCompleted': isCompleted,
    'questionsCompleted': questionsCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };

  /// İlerleme yüzdesi
  double get progressPercent => questionCount > 0 
      ? (questionsCompleted / questionCount).clamp(0.0, 1.0) 
      : 0.0;
}

/// Mola önerisi
class BreakSuggestion {
  final int afterBlock;
  final int durationMinutes;
  final String suggestion;

  BreakSuggestion({
    required this.afterBlock,
    required this.durationMinutes,
    required this.suggestion,
  });

  factory BreakSuggestion.fromJson(Map<String, dynamic> json) => BreakSuggestion(
    afterBlock: json['after_block'] ?? 0,
    durationMinutes: json['duration_minutes'] ?? 5,
    suggestion: json['suggestion'] ?? 'Kısa bir mola ver',
  );
}

/// Günlük çalışma planı V2
class DailyStudyPlan {
  final DateTime date;
  final DailyGoals goals;
  final List<StudyBlock> studyBlocks;
  final List<BreakSuggestion> breaks;
  final String motivationalMessage;
  final String dailyTip;
  final String streakMessage;
  final String? optimalStartTime;
  final bool shouldTakeBreak;
  final String? breakReason;
  final bool isAIGenerated;

  DailyStudyPlan({
    required this.date,
    DailyGoals? goals,
    this.studyBlocks = const [],
    this.breaks = const [],
    this.motivationalMessage = '',
    this.dailyTip = '',
    this.streakMessage = '',
    this.optimalStartTime,
    this.shouldTakeBreak = false,
    this.breakReason,
    this.isAIGenerated = false,
  }) : goals = goals ?? DailyGoals();

  /// Tamamlanan blok sayısı
  int get completedBlocks => studyBlocks.where((b) => b.isCompleted).length;

  /// Toplam ilerleme yüzdesi
  double get overallProgress {
    if (studyBlocks.isEmpty) return 0.0;
    final totalQuestions = studyBlocks.fold(0, (sum, b) => sum + b.questionCount);
    final completedQuestions = studyBlocks.fold(0, (sum, b) => sum + b.questionsCompleted);
    return totalQuestions > 0 ? completedQuestions / totalQuestions : 0.0;
  }

  /// Eski API uyumu
  List<StudyRecommendation> get recommendations => studyBlocks.map((b) => 
    StudyRecommendation(
      type: _mapType(b.type),
      title: b.topic,
      description: b.reason,
      topic: b.subTopic,
      subject: b.topic,
      priority: b.order,
      estimatedTime: Duration(minutes: b.estimatedMinutes),
      reason: b.reason,
    )
  ).toList();

  List<StudyRecommendation> get topPriority => recommendations.take(3).toList();
  Duration get estimatedTime => Duration(minutes: goals.targetMinutes);
  int get totalActivities => studyBlocks.length;

  RecommendationType _mapType(String type) {
    switch (type) {
      case 'spaced_rep': return RecommendationType.spacedRepetition;
      case 'weak_topic': return RecommendationType.weakTopic;
      case 'new_topic': return RecommendationType.newTopic;
      case 'review_mistakes': return RecommendationType.reviewMistakes;
      default: return RecommendationType.practiceMore;
    }
  }
}

/// Tekil çalışma önerisi (eski API uyumu için korunuyor)
class StudyRecommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final String? topic;
  final String? subject;
  final int priority;
  final Duration estimatedTime;
  final String? reason;
  final DateTime? dueDate;

  StudyRecommendation({
    required this.type,
    required this.title,
    required this.description,
    this.topic,
    this.subject,
    this.priority = 3,
    this.estimatedTime = const Duration(minutes: 10),
    this.reason,
    this.dueDate,
  });

  String get emoji {
    switch (type) {
      case RecommendationType.spacedRepetition: return '🔄';
      case RecommendationType.weakTopic: return '📚';
      case RecommendationType.newTopic: return '✨';
      case RecommendationType.practiceMore: return '💪';
      case RecommendationType.reviewMistakes: return '🔍';
      case RecommendationType.takeBreak: return '☕';
    }
  }
}

/// Öneri türleri
enum RecommendationType {
  spacedRepetition,
  weakTopic,
  newTopic,
  practiceMore,
  reviewMistakes,
  takeBreak,
}

// ============================================================================
// SERVICE
// ============================================================================

/// Akıllı Çalışma Planlayıcı Servisi V2
class SmartStudyPlannerService {
  static final SmartStudyPlannerService _instance = SmartStudyPlannerService._internal();
  factory SmartStudyPlannerService() => _instance;
  SmartStudyPlannerService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  
  SessionTrackingService get _sessionTracker => SessionTrackingService();
  UserDNAService get _dnaService => UserDNAService();
  LearningInsightsService get _insightsService => LearningInsightsService();
  GeminiService get _geminiService => GeminiService();
  PromptRegistryService get _promptRegistry => PromptRegistryService();

  // Cache
  DailyStudyPlan? _cachedPlan;
  DateTime? _cacheTime;
  static const _cacheValidityMinutes = 30;

  // =========================================================================
  // PUBLIC API
  // =========================================================================

  /// 🎯 Bugün için AI-powered çalışma planı oluştur
  Future<DailyStudyPlan> generateDailyPlan({bool forceRefresh = false}) async {
    try {
      // Cache kontrolü
      if (!forceRefresh && _cachedPlan != null && _cacheTime != null) {
        final cacheAge = DateTime.now().difference(_cacheTime!).inMinutes;
        if (cacheAge < _cacheValidityMinutes) {
          debugPrint('📋 Cached plan kullanılıyor (${_cacheValidityMinutes - cacheAge} dk geçerli)');
          return _cachedPlan!;
        }
      }

      final dna = await _dnaService.getDNA();
      final insights = await _insightsService.calculateInsights();
      final recentSessions = await _sessionTracker.getRecentSessions(limit: 10);
      
      // 1. Kalibrasyon Kontrolü
      if (dna == null || dna.totalQuestionsSolved < 10) {
        return DailyStudyPlan(
          date: DateTime.now(),
          motivationalMessage: '10 soru çözdükten sonra kişiselleştirilmiş plan hazırlanacak.',
          streakMessage: 'Şimdilik herhangi bir konuda pratik yapabilirsin! 🚀',
        );
      }

      // 2. Bilişsel Yük Kontrolü
      final shouldBreak = _shouldSuggestBreak(insights, recentSessions);
      if (shouldBreak != null) {
        return DailyStudyPlan(
          date: DateTime.now(),
          shouldTakeBreak: true,
          breakReason: shouldBreak,
          motivationalMessage: 'Biraz dinlen, sonra daha verimli çalışırsın! 💪',
        );
      }

      // 3. SM-2 Kartlarını Al
      final dueCards = await _getDueSM2Cards();

      // 4. AI ile Plan Üret
      DailyStudyPlan plan;
      try {
        plan = await _generateAIPlan(dna, insights, dueCards);
        debugPrint('✅ AI plan oluşturuldu');
      } catch (e) {
        debugPrint('⚠️ AI plan hatası, fallback kullanılıyor: $e');
        plan = await _generateFallbackPlan(dna, insights, dueCards);
      }

      // 5. Cache ve kaydet
      _cachedPlan = plan;
      _cacheTime = DateTime.now();
      await _saveTodayPlan(plan);

      return plan;
    } catch (e) {
      debugPrint('❌ Daily plan hatası: $e');
      return _createFallbackPlan();
    }
  }

  /// 🔥 Dinamik Motivasyon Mesajı Al
  Future<String> getDynamicMotivation({String? context}) async {
    try {
      final dna = await _dnaService.getDNA();
      final insights = await _insightsService.calculateInsights();
      final today = await _sessionTracker.getTodaySnapshot();

      final prompt = _promptRegistry.getPrompt('dynamic_motivation', variables: {
        'studentName': dna?.userName ?? 'Öğrenci',
        'currentStreak': insights.currentStreak.toString(),
        'weeklySuccess': (insights.thisWeekSuccessRate * 100).toInt().toString(),
        'trend': insights.weeklyTrend.name,
        'cognitiveLoad': insights.recentCognitiveLoad?.name ?? 'unknown',
        'todayQuestions': (today?.questionsAttempted ?? 0).toString(),
        'context': context ?? 'Günlük motivasyon',
      });

      await _geminiService.initialize();
      final response = await _geminiService.generateContent(prompt);
      
      return response ?? _getStaticMotivation(insights);
    } catch (e) {
      debugPrint('❌ Dinamik motivasyon hatası: $e');
      return _getStaticMotivation(await _insightsService.calculateInsights());
    }
  }

  /// ✅ Blok tamamlandı olarak işaretle
  Future<void> markBlockCompleted(int blockOrder, int questionsCompleted) async {
    if (_cachedPlan == null) return;

    final blockIndex = _cachedPlan!.studyBlocks.indexWhere((b) => b.order == blockOrder);
    if (blockIndex == -1) return;

    _cachedPlan!.studyBlocks[blockIndex].questionsCompleted = questionsCompleted;
    _cachedPlan!.studyBlocks[blockIndex].isCompleted = 
        questionsCompleted >= _cachedPlan!.studyBlocks[blockIndex].questionCount;
    _cachedPlan!.studyBlocks[blockIndex].completedAt = DateTime.now();

    // SM-2 kartını güncelle
    final block = _cachedPlan!.studyBlocks[blockIndex];
    final quality = _calculateQuality(questionsCompleted, block.questionCount);
    await _updateSM2Card(block.topic, block.subTopic, quality);

    // Firestore'a kaydet
    await _saveTodayPlan(_cachedPlan!);

    debugPrint('✅ Blok ${block.topic} tamamlandı: $questionsCompleted/${block.questionCount}');
  }

  /// 📊 Bugünkü ilerlemeyi al
  Future<Map<String, dynamic>> getTodayProgress() async {
    final plan = await generateDailyPlan();
    
    return {
      'targetQuestions': plan.goals.targetQuestions,
      'completedQuestions': plan.studyBlocks.fold(0, (sum, b) => sum + b.questionsCompleted),
      'progressPercent': plan.overallProgress,
      'completedBlocks': plan.completedBlocks,
      'totalBlocks': plan.studyBlocks.length,
    };
  }

  // =========================================================================
  // SM-2 SPACED REPETITION
  // =========================================================================

  /// SM-2 kartlarından bugün tekrarı gerekenleri al
  Future<List<SM2Card>> _getDueSM2Cards() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sm2_cards')
          .where('nextReview', isLessThanOrEqualTo: DateTime.now().toIso8601String())
          .orderBy('nextReview')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => SM2Card.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('❌ SM-2 kartları alınamadı: $e');
      return [];
    }
  }

  /// SM-2 kartını güncelle
  Future<void> _updateSM2Card(String topic, String subTopic, int quality) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final cardId = '${topic}_$subTopic'.replaceAll(' ', '_').toLowerCase();
      final cardRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sm2_cards')
          .doc(cardId);

      final existing = await cardRef.get();
      
      SM2Card updatedCard;
      if (existing.exists) {
        final oldCard = SM2Card.fromJson(existing.data()!);
        updatedCard = oldCard.updateWithQuality(quality);
      } else {
        updatedCard = SM2Card(
          id: cardId,
          topic: topic,
          subTopic: subTopic,
          nextReview: DateTime.now().add(Duration(days: quality >= 3 ? 1 : 0)),
          lastReview: DateTime.now(),
          quality: quality,
        ).updateWithQuality(quality);
      }

      await cardRef.set(updatedCard.toJson());
      debugPrint('🔄 SM-2 kart güncellendi: $cardId (interval: ${updatedCard.interval} gün)');
    } catch (e) {
      debugPrint('❌ SM-2 kart güncelleme hatası: $e');
    }
  }

  /// Performansa göre quality hesapla (0-5)
  int _calculateQuality(int completed, int total) {
    if (total == 0) return 3;
    final ratio = completed / total;
    
    if (ratio >= 0.9) return 5; // Mükemmel
    if (ratio >= 0.8) return 4; // İyi
    if (ratio >= 0.6) return 3; // Orta
    if (ratio >= 0.4) return 2; // Zayıf
    if (ratio >= 0.2) return 1; // Çok zayıf
    return 0; // Tamamen unutmuş
  }

  // =========================================================================
  // AI PLAN GENERATION
  // =========================================================================

  /// AI ile plan üret
  Future<DailyStudyPlan> _generateAIPlan(
    UserDNA dna, 
    LearningInsights insights,
    List<SM2Card> dueCards,
  ) async {
    final now = DateTime.now();
    final weekdays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];

    // Zayıf konuları formatla
    final weakTopicsStr = dna.weakTopics.take(5).map((w) => 
      '- ${w.topic}/${w.subTopic}: %${(w.successRate * 100).toInt()} başarı, ${w.wrongCount}x yanlış'
    ).join('\n');

    // Güçlü konuları formatla (List<String>)
    final strongTopicsStr = dna.strongTopics.take(3).map((s) => 
      '- $s: güçlü'
    ).join('\n');

    // SM-2 tekrar konularını formatla
    final spacedRepStr = dueCards.take(5).map((c) => 
      '- ${c.topic}/${c.subTopic}: ${c.interval} gün aralıkla tekrar (EF: ${c.easeFactor.toStringAsFixed(1)})'
    ).join('\n');

    // Günlük ortalama hesapla
    final dailyAvg = dna.totalQuestionsSolved > 0 
        ? (dna.totalQuestionsSolved / max(1, now.difference(dna.lastUpdated ?? now).inDays.abs() + 1)).round()
        : 10;

    final prompt = _promptRegistry.getPrompt('daily_study_plan_generator', variables: {
      'studentName': dna.userName ?? 'Öğrenci',
      'gradeLevel': dna.gradeLevel ?? 'Belirlenmedi',
      'targetExam': dna.targetExam ?? 'Belirlenmedi',
      'daysToExam': '120', // TODO: Gerçek sınav tarihi
      'learningStyle': dna.learningStyle ?? 'Belirlenmedi',
      'totalQuestions': dna.totalQuestionsSolved.toString(),
      'overallSuccess': (dna.overallSuccessRate * 100).toInt().toString(),
      'thisWeekQuestions': insights.thisWeekQuestions.toString(),
      'dailyAverage': dailyAvg.toString(),
      'weakTopics': weakTopicsStr.isNotEmpty ? weakTopicsStr : 'Henüz belirlenmedi',
      'strongTopics': strongTopicsStr.isNotEmpty ? strongTopicsStr : 'Henüz belirlenmedi',
      'spacedRepetitionTopics': spacedRepStr.isNotEmpty ? spacedRepStr : 'Tekrar gereken konu yok',
      'dayOfWeek': weekdays[now.weekday - 1],
      'currentHour': now.hour.toString(),
      'peakHours': insights.peakHoursFormatted,
      'currentStreak': insights.currentStreak.toString(),
    });

    await _geminiService.initialize();
    final response = await _geminiService.generateContentJson(prompt);
    
    if (response == null) throw Exception('AI yanıt üretemedi');

    // JSON'dan plan oluştur
    final dailyPlanJson = response['daily_plan'] ?? {};
    final studyBlocksJson = response['study_blocks'] as List? ?? [];
    final breaksJson = response['breaks'] as List? ?? [];

    return DailyStudyPlan(
      date: now,
      goals: DailyGoals.fromJson(dailyPlanJson),
      studyBlocks: studyBlocksJson.map((b) => StudyBlock.fromJson(b)).toList(),
      breaks: breaksJson.map((b) => BreakSuggestion.fromJson(b)).toList(),
      motivationalMessage: response['motivational_message'] ?? '',
      dailyTip: response['daily_tip'] ?? '',
      streakMessage: response['streak_message'] ?? '',
      optimalStartTime: (insights.peakHours.isNotEmpty) ? '${insights.peakHours.first}:00' : null,
      isAIGenerated: true,
    );
  }

  /// Fallback plan (AI başarısız olursa)
  Future<DailyStudyPlan> _generateFallbackPlan(
    UserDNA dna, 
    LearningInsights insights,
    List<SM2Card> dueCards,
  ) async {
    final blocks = <StudyBlock>[];
    int order = 1;

    // 1. SM-2 tekrar kartları
    for (final card in dueCards.take(2)) {
      blocks.add(StudyBlock(
        order: order++,
        topic: card.topic,
        subTopic: card.subTopic,
        type: 'spaced_rep',
        questionCount: 5,
        estimatedMinutes: 15,
        reason: 'Spaced repetition algoritması bu konuyu tekrar etmeni öneriyor.',
        emoji: '🔄',
      ));
    }

    // 2. Zayıf konular
    for (final weak in dna.weakTopics.take(2)) {
      blocks.add(StudyBlock(
        order: order++,
        topic: weak.topic,
        subTopic: weak.subTopic,
        type: 'weak_topic',
        questionCount: 5,
        estimatedMinutes: 15,
        reason: 'Bu konuda %${(weak.successRate * 100).toInt()} başarın var. Güçlendirelim!',
        emoji: '📚',
      ));
    }

    if (dna.failedQuestions.isNotEmpty) {
      final errorTopic = dna.failedQuestions.first.topic;
      blocks.add(StudyBlock(
        order: order++,
        topic: errorTopic,
        subTopic: 'Hata Tekrarı',
        type: 'review_mistakes',
        questionCount: 3,
        estimatedMinutes: 10,
        reason: 'Yanlış yaptığın soruları tekrar çöz.',
        emoji: '🔍',
      ));
    }

    return DailyStudyPlan(
      date: DateTime.now(),
      goals: DailyGoals(
        targetQuestions: blocks.fold(0, (sum, b) => sum + b.questionCount),
        targetMinutes: blocks.fold(0, (sum, b) => sum + b.estimatedMinutes),
      ),
      studyBlocks: blocks,
      breaks: [
        BreakSuggestion(afterBlock: 2, durationMinutes: 5, suggestion: '5 dakika mola ver'),
      ],
      motivationalMessage: _getStaticMotivation(insights),
      dailyTip: 'Düzenli çalışma başarının anahtarı!',
      streakMessage: insights.currentStreak > 0 
          ? '🔥 ${insights.currentStreak} günlük serin var!' 
          : 'Bugün yeni bir seri başlat! 🚀',
      optimalStartTime: (insights.peakHours.isNotEmpty) ? '${insights.peakHours.first}:00' : null,
      isAIGenerated: false,
    );
  }

  /// Minimum fallback plan
  DailyStudyPlan _createFallbackPlan() {
    return DailyStudyPlan(
      date: DateTime.now(),
      studyBlocks: [
        StudyBlock(
          order: 1,
          topic: 'Genel',
          subTopic: 'Pratik',
          type: 'practiceMore',
          questionCount: 10,
          estimatedMinutes: 30,
          reason: 'Herhangi bir konuda soru çözerek başla!',
          emoji: '💪',
        ),
      ],
      motivationalMessage: 'Her gün bir soru bile fark yaratır! 🚀',
    );
  }

  // =========================================================================
  // HELPERS
  // =========================================================================

  /// Mola önerisi gerekiyor mu?
  String? _shouldSuggestBreak(LearningInsights insights, List<QuestionSession> recentSessions) {
    if (insights.recentCognitiveLoad == CognitiveLoadLevel.overload) {
      return 'Son sorularda çok zorlandın. Beynin dinlenmeye ihtiyaç duyuyor.';
    }

    final now = DateTime.now();
    final last30Min = recentSessions.where((s) => 
      s.endTime != null && now.difference(s.endTime!).inMinutes < 30
    ).length;
    
    if (last30Min >= 5) {
      return '30 dakikada $last30Min soru çözdün! 5 dakika mola ver.';
    }

    if (now.hour >= 23) {
      return 'Saat geç oldu. Yarın taze bir zihinle devam et!';
    }

    return null;
  }

  /// Statik motivasyon mesajı
  String _getStaticMotivation(LearningInsights insights) {
    final streak = insights.currentStreak;
    
    if (streak >= 7) return '🔥 $streak gündür devam ediyorsun! Mükemmel disiplin!';
    if (streak >= 3) return '✨ $streak günlük seri! Devam et, hedefine yaklaşıyorsun!';
    if (insights.weeklyTrend == TrendDirection.rising) return '📈 Performansın yükseliyor! Harika gidiyorsun!';
    if (insights.weeklyTrend == TrendDirection.falling) return '💪 Biraz düşüş var ama pes etme! Bugün telafi günü!';
    
    return '🚀 Her gün ilerlemek seni hedefe yaklaştırır!';
  }

  /// Bugünkü planı Firestore'a kaydet
  Future<void> _saveTodayPlan(DailyStudyPlan plan) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('daily_plans')
          .doc(dateKey)
          .set({
            'date': plan.date.toIso8601String(),
            'goals': {
              'targetQuestions': plan.goals.targetQuestions,
              'targetMinutes': plan.goals.targetMinutes,
              'difficultyMix': plan.goals.difficultyMix,
            },
            'studyBlocks': plan.studyBlocks.map((b) => b.toJson()).toList(),
            'motivationalMessage': plan.motivationalMessage,
            'dailyTip': plan.dailyTip,
            'streakMessage': plan.streakMessage,
            'isAIGenerated': plan.isAIGenerated,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      debugPrint('💾 Günlük plan kaydedildi: $dateKey');
    } catch (e) {
      debugPrint('❌ Plan kaydetme hatası: $e');
    }
  }

  /// Şu an çalışmalı mısın? (Optimal saat kontrolü)
  Future<bool> isOptimalStudyTime() async {
    final insights = await _insightsService.calculateInsights();
    final currentHour = DateTime.now().hour;
    return insights.peakHours.contains(currentHour);
  }

  /// Streak tehlikede mi?
  Future<bool> isStreakAtRisk() async {
    final today = await _sessionTracker.getTodaySnapshot();
    final insights = await _insightsService.calculateInsights();
    return insights.currentStreak > 0 && (today?.questionsAttempted ?? 0) == 0;
  }
}
