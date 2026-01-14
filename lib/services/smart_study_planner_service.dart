/// SOLICAP - Smart Study Planner Service
/// Kişiselleştirilmiş çalışma planları ve proaktif öneriler
/// Sprint 3 - Smart Recommendations

import 'package:flutter/foundation.dart';
import '../models/learning_event_model.dart';
import '../models/question_session_model.dart';
import '../models/user_dna_model.dart';
import 'session_tracking_service.dart';
import 'user_dna_service.dart';
import 'learning_insights_service.dart';

/// Günlük çalışma planı
class DailyStudyPlan {
  final DateTime date;
  final List<StudyRecommendation> recommendations;
  final Duration estimatedTime;
  final String? optimalStartTime; // "20:00"
  final String? motivationalMessage;
  final bool shouldTakeBreak;
  final String? breakReason;

  DailyStudyPlan({
    required this.date,
    this.recommendations = const [],
    this.estimatedTime = Duration.zero,
    this.optimalStartTime,
    this.motivationalMessage,
    this.shouldTakeBreak = false,
    this.breakReason,
  });

  /// Toplam önerilen aktivite sayısı
  int get totalActivities => recommendations.length;

  /// En önemli öneriler (ilk 3)
  List<StudyRecommendation> get topPriority => recommendations.take(3).toList();
}

/// Tekil çalışma önerisi
class StudyRecommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final String? topic;
  final String? subject;
  final int priority;           // 1 = en önemli
  final Duration estimatedTime;
  final String? reason;         // Neden bu öneri yapılıyor
  final DateTime? dueDate;      // Spaced repetition için

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
      case RecommendationType.spacedRepetition:
        return '🔄';
      case RecommendationType.weakTopic:
        return '📚';
      case RecommendationType.newTopic:
        return '✨';
      case RecommendationType.practiceMore:
        return '💪';
      case RecommendationType.reviewMistakes:
        return '🔍';
      case RecommendationType.takeBreak:
        return '☕';
    }
  }
}

/// Öneri türleri
enum RecommendationType {
  spacedRepetition,  // Tekrar zamanı geldi
  weakTopic,         // Zayıf konu çalışması
  newTopic,          // Yeni konu keşfi
  practiceMore,      // Daha fazla pratik
  reviewMistakes,    // Hataları gözden geçir
  takeBreak,         // Mola ver
}

/// Akıllı Çalışma Planlayıcı Servisi
class SmartStudyPlannerService {
  static final SmartStudyPlannerService _instance = SmartStudyPlannerService._internal();
  factory SmartStudyPlannerService() => _instance;
  SmartStudyPlannerService._internal();

  SessionTrackingService get _sessionTracker => SessionTrackingService();
  UserDNAService get _dnaService => UserDNAService();
  LearningInsightsService get _insightsService => LearningInsightsService();

  /// Bugün için çalışma planı oluştur
  Future<DailyStudyPlan> generateDailyPlan() async {
    try {
      final dna = await _dnaService.getDNA();
      final insights = await _insightsService.calculateInsights();
      final recentSessions = await _sessionTracker.getRecentSessions(limit: 10);
      
      final recommendations = <StudyRecommendation>[];
      
      // 1. Kalibrasyon Kontrolü - 10 soru barajı
      if (dna == null || dna.totalQuestionsSolved < 10) {
        return DailyStudyPlan(
          date: DateTime.now(),
          recommendations: [],
          motivationalMessage: '10 soru çözdükten sonra eksik olduğun konular için anlatım özelliği açılacak.',
        );
      }

      // 1. Bilişsel yük kontrolü - mola gerekli mi?
      final shouldBreak = _shouldSuggestBreak(insights, recentSessions);
      if (shouldBreak != null) {
        return DailyStudyPlan(
          date: DateTime.now(),
          shouldTakeBreak: true,
          breakReason: shouldBreak,
          motivationalMessage: 'Biraz dinlen, sonra daha verimli çalışırsın! 💪',
        );
      }

      // 2. Spaced Repetition - tekrar zamanı gelen konular
      final spacedReps = await _getSpacedRepetitionRecommendations(dna);
      recommendations.addAll(spacedReps);

      // 3. Zayıf konular - iyileştirme önerileri
      final weakTopics = _getWeakTopicRecommendations(dna);
      recommendations.addAll(weakTopics);

      // 4. Hata tekrarı - yanlış yapılan sorular
      final mistakeReview = _getMistakeReviewRecommendations(dna);
      recommendations.addAll(mistakeReview);

      // Önceliğe göre sırala
      recommendations.sort((a, b) => a.priority.compareTo(b.priority));

      // Toplam süre hesapla
      final totalTime = recommendations.fold<Duration>(
        Duration.zero,
        (sum, r) => sum + r.estimatedTime,
      );

      // Optimal başlangıç saati
      final optimalHour = insights.peakHours.isNotEmpty 
          ? '${insights.peakHours.first}:00' 
          : null;

      // Motivasyon mesajı
      final message = _getMotivationalMessage(insights);

      return DailyStudyPlan(
        date: DateTime.now(),
        recommendations: recommendations,
        estimatedTime: totalTime,
        optimalStartTime: optimalHour,
        motivationalMessage: message,
      );
    } catch (e) {
      debugPrint('❌ Daily plan hatası: $e');
      return DailyStudyPlan(
        date: DateTime.now(),
        recommendations: [
          StudyRecommendation(
            type: RecommendationType.practiceMore,
            title: 'Bugün Pratik Yap',
            description: 'Herhangi bir konuda soru çözerek başla!',
            priority: 1,
          ),
        ],
        motivationalMessage: 'Her gün bir soru bile fark yaratır! 🚀',
      );
    }
  }

  /// Mola önerisi gerekiyor mu?
  String? _shouldSuggestBreak(LearningInsights insights, List<QuestionSession> recentSessions) {
    // 1. Son oturumlarda overload varsa
    if (insights.recentCognitiveLoad == CognitiveLoadLevel.overload) {
      return 'Son sorularda çok zorlandın. Beynin dinlenmeye ihtiyaç duyuyor.';
    }

    // 2. Son 30 dakikada 5+ soru çözüldüyse
    final now = DateTime.now();
    final last30Min = recentSessions.where((s) => 
      s.endTime != null && now.difference(s.endTime!).inMinutes < 30
    ).length;
    
    if (last30Min >= 5) {
      return '30 dakikada $last30Min soru çözdün! 5 dakika mola ver.';
    }

    // 3. Gece geç saatse (23:00+)
    if (now.hour >= 23) {
      return 'Saat geç oldu. Yarın taze bir zihinle devam et!';
    }

    return null;
  }

  /// Spaced Repetition önerileri
  Future<List<StudyRecommendation>> _getSpacedRepetitionRecommendations(UserDNA? dna) async {
    if (dna == null) return [];
    
    final recommendations = <StudyRecommendation>[];
    final now = DateTime.now();

    // Zayıf konuları tekrar zamanına göre kontrol et
    for (final weak in dna.weakTopics.take(3)) {
      // Her zayıf konu için 2-3 gün sonra tekrar öner
      // Gerçek uygulamada lastAttempt tarihine bakılır
      recommendations.add(StudyRecommendation(
        type: RecommendationType.spacedRepetition,
        title: 'Tekrar: ${weak.subTopic}',
        description: '${weak.wrongCount}x yanlış yaptın. Şimdi tekrar zamanı!',
        topic: weak.subTopic,
        subject: weak.topic,
        priority: 1,
        estimatedTime: const Duration(minutes: 15),
        reason: 'Spaced repetition algoritması bu konuyu tekrar etmeni öneriyor.',
        dueDate: now,
      ));
    }

    return recommendations;
  }

  /// Zayıf konu önerileri
  List<StudyRecommendation> _getWeakTopicRecommendations(UserDNA? dna) {
    if (dna == null || dna.weakTopics.isEmpty) return [];
    
    final recommendations = <StudyRecommendation>[];

    // En zayıf 2 konu
    for (final weak in dna.weakTopics.take(2)) {
      final successPercent = (weak.successRate * 100).toInt();
      
      recommendations.add(StudyRecommendation(
        type: RecommendationType.weakTopic,
        title: '${weak.subTopic} Güçlendir',
        description: 'Başarı oranın %$successPercent. Mikro dersle kavramları pekiştir.',
        topic: weak.subTopic,
        subject: weak.topic,
        priority: 2,
        estimatedTime: const Duration(minutes: 20),
        reason: 'Bu konuda zorlanıyorsun. Kısa bir ders faydalı olabilir.',
      ));
    }

    return recommendations;
  }

  /// Hata gözden geçirme önerileri
  List<StudyRecommendation> _getMistakeReviewRecommendations(UserDNA? dna) {
    if (dna == null || dna.failedQuestions.isEmpty) return [];

    // Son 5 yanlış soruyu al
    final recentMistakes = dna.failedQuestions
        .where((q) => !q.isReviewed)
        .take(5)
        .toList();

    if (recentMistakes.isEmpty) return [];

    // Konulara göre grupla
    final topicCounts = <String, int>{};
    for (final q in recentMistakes) {
      topicCounts[q.topic] = (topicCounts[q.topic] ?? 0) + 1;
    }

    // En çok hata yapılan konu
    final topErrorTopic = topicCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    return [
      StudyRecommendation(
        type: RecommendationType.reviewMistakes,
        title: 'Hataları Gözden Geçir',
        description: '${topErrorTopic.key} konusunda ${topErrorTopic.value} yanlışın var.',
        topic: topErrorTopic.key,
        priority: 2,
        estimatedTime: const Duration(minutes: 10),
        reason: 'Yanlış yaptığın soruları tekrar çözmek öğrenmeyi pekiştirir.',
      ),
    ];
  }

  // Statik öneriler kaldırıldı. Sadece gerçek veriye odaklıyız.
  StudyRecommendation? _getNewTopicRecommendation(UserDNA? dna) {
    return null;
  }

  /// Motivasyon mesajı
  String _getMotivationalMessage(LearningInsights insights) {
    final streak = insights.currentStreak;
    
    if (streak >= 7) {
      return '🔥 $streak gündür devam ediyorsun! Mükemmel disiplin!';
    } else if (streak >= 3) {
      return '✨ $streak günlük seri! Devam et, hedefine yaklaşıyorsun!';
    } else if (insights.weeklyTrend == TrendDirection.rising) {
      return '📈 Performansın yükseliyor! Harika gidiyorsun!';
    } else if (insights.weeklyTrend == TrendDirection.falling) {
      return '💪 Biraz düşüş var ama pes etme! Bugün telafi günü!';
    }
    
    return '🚀 Her gün ilerlemek seni hedefe yaklaştırır!';
  }

  /// Şu an çalışmalı mısın? (Optimal saat kontrolü)
  Future<bool> isOptimalStudyTime() async {
    final insights = await _insightsService.calculateInsights();
    final currentHour = DateTime.now().hour;
    
    return insights.peakHours.contains(currentHour);
  }

  /// Streak tehlikede mi? (Bugün hiç çalışma yok)
  Future<bool> isStreakAtRisk() async {
    final today = await _sessionTracker.getTodaySnapshot();
    final insights = await _insightsService.calculateInsights();
    
    // Streak > 0 ve bugün hiç soru çözülmedi
    return insights.currentStreak > 0 && (today?.questionsAttempted ?? 0) == 0;
  }
}
