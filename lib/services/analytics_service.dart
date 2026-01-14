/// SOLICAP - Analytics Service
/// Firebase Analytics + UserDNA senkronizasyonu için merkezi servis

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'user_dna_service.dart';
// GeminiService importu dairesel bağımlılığı (Analytics -> Gemini -> Points -> Analytics) kırmak için kaldırıldı
import '../models/learning_gap_model.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  UserDNAService get _dnaService => UserDNAService();

  // ═══════════════════════════════════════════════════════════════
  // 📊 CORE EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Soru çözüldüğünde
  Future<void> logQuestionSolved({
    required String subject,
    required String topic,
    required String difficulty,
    required bool isCorrect,
  }) async {
    try {
      // Firebase Analytics
      await _analytics.logEvent(
        name: 'question_solved',
        parameters: {
          'subject': subject,
          'topic': topic,
          'difficulty': difficulty,
          'is_correct': isCorrect,
        },
      );

      // UserDNA güncelle
      final dna = await _dnaService.getDNA();
      if (dna != null) {
        final updatedDna = dna.copyWith(
          totalQuestionsSolved: dna.totalQuestionsSolved + 1,
          totalCorrect: isCorrect ? dna.totalCorrect + 1 : dna.totalCorrect,
          totalWrong: !isCorrect ? dna.totalWrong + 1 : dna.totalWrong,
        );
        await _dnaService.saveDNA(updatedDna);
      }

      debugPrint('📊 Event: question_solved ($subject/$topic)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Benzer soru üretildiğinde
  Future<void> logSimilarQuestionsGenerated({
    required String subject,
    required int count,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'similar_questions_generated',
        parameters: {
          'subject': subject,
          'count': count,
        },
      );
      debugPrint('📊 Event: similar_questions_generated ($count soru)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Mikro ders görüntülendiğinde
  Future<void> logMicroLessonViewed({
    required String subject,
    required String topic,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'micro_lesson_viewed',
        parameters: {
          'subject': subject,
          'topic': topic,
        },
      );

      // DNA'ya discovered topic ekle
      final dna = await _dnaService.getDNA();
      if (dna != null) {
        final topicPath = '$subject/$topic';
        if (!dna.discoveredTopics.contains(topicPath)) {
          final updatedDna = dna.copyWith(
            discoveredTopics: [...dna.discoveredTopics, topicPath],
          );
          await _dnaService.saveDNA(updatedDna);
        }
      }

      debugPrint('📊 Event: micro_lesson_viewed ($subject/$topic)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Sokratik mod başlatıldığında
  Future<void> logSocraticModeStarted({
    required String subject,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'socratic_mode_started',
        parameters: {
          'subject': subject,
        },
      );
      debugPrint('📊 Event: socratic_mode_started ($subject)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Onboarding tamamlandığında
  Future<void> logOnboardingCompleted({
    required String level,
    String? department,
    String? language,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'onboarding_completed',
        parameters: {
          'level': level,
          'department': department ?? 'unknown',
          'language': language ?? 'TR',
        },
      );
      debugPrint('📊 Event: onboarding_completed ($level)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Puan harcandığında
  Future<void> logPointSpent({
    required String action,
    required int amount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'point_spent',
        parameters: {
          'action': action,
          'amount': amount,
        },
      );

      // AI etkileşim sayısını artır
      final dna = await _dnaService.getDNA();
      if (dna != null) {
        final updatedDna = dna.copyWith(
          totalAIInteractions: dna.totalAIInteractions + 1,
        );
        await _dnaService.saveDNA(updatedDna);
      }

      debugPrint('📊 Event: point_spent ($action, $amount💎)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Reklam izlendiğinde
  Future<void> logAdWatched({
    required int rewardAmount,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'ad_watched',
        parameters: {
          'reward_amount': rewardAmount,
        },
      );
      debugPrint('📊 Event: ad_watched (+$rewardAmount💎)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 📈 ADVANCED EVENTS
  // ═══════════════════════════════════════════════════════════════

  /// Yanlış cevap verildiğinde (detaylı)
  Future<void> logWrongAnswer({
    required String subject,
    required String topic,
    String? errorType,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'wrong_answer',
        parameters: {
          'subject': subject,
          'topic': topic,
          'error_type': errorType ?? 'unknown',
        },
      );

      // errorPatterns güncelle
      if (errorType != null) {
        final dna = await _dnaService.getDNA();
        if (dna != null) {
          final patterns = Map<String, int>.from(dna.errorPatterns);
          patterns[errorType] = (patterns[errorType] ?? 0) + 1;
          final updatedDna = dna.copyWith(errorPatterns: patterns);
          await _dnaService.saveDNA(updatedDna);
        }
      }

      debugPrint('📊 Event: wrong_answer ($topic, $errorType)');
    } catch (e) {
      debugPrint('❌ Analytics hatası: $e');
    }
  }

  /// Aktif saat kaydı
  Future<void> logActiveHour() async {
    try {
      final hour = DateTime.now().hour.toString();
      
      final dna = await _dnaService.getDNA();
      if (dna != null) {
        final hours = Map<String, int>.from(dna.activeHours);
        hours[hour] = (hours[hour] ?? 0) + 1;
        final updatedDna = dna.copyWith(activeHours: hours);
        await _dnaService.saveDNA(updatedDna);
      }
    } catch (e) {
      debugPrint('❌ Active hour hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 📈 ANALYSIS METHODS (UI Entegrasyonu için)
  // ═══════════════════════════════════════════════════════════════

  /// Öğrenci verilerini analiz et ve StudentAnalytics modeline dönüştür
  /// ProgressScreen tarafından kullanılır
  Future<StudentAnalytics?> analyzeStudent(String userId) async {
    try {
      final dna = await _dnaService.getDNA();
      if (dna == null) return null;

      // Zayıf ve Güçlü alanları oluştur (TopicPerformance'dan)
      final List<LearningGap> weakAreas = [];
      final List<LearningGap> strongAreas = [];

      dna.topicPerformance.forEach((subject, performance) {
        final gap = LearningGap(
          subject: subject,
          topic: 'Genel',
          totalAttempts: performance.totalQuestions,
          correctAttempts: performance.correct,
          successRate: performance.successRate,
          proficiencyLevel: performance.successRate < 0.4 ? 'weak' : (performance.successRate < 0.7 ? 'medium' : 'strong'),
          recommendations: performance.successRate < 0.4 ? ['Bu konuyu tekrar gözden geçirmelisin.'] : ['Harika gidiyorsun!'],
        );

        if (performance.successRate < 0.5) {
          weakAreas.add(gap);
        } else {
          strongAreas.add(gap);
        }
      });

      return StudentAnalytics(
        totalQuestionsSolved: dna.totalQuestionsSolved,
        totalCorrectAnswers: dna.totalCorrect,
        overallSuccessRate: dna.overallSuccessRate,
        weakAreas: weakAreas,
        strongAreas: strongAreas,
        subjectDistribution: dna.topicPerformance.map((k, v) => MapEntry(k, v.totalQuestions)),
      );
    } catch (e) {
      debugPrint('❌ analyzeStudent hatası: $e');
      return null;
    }
  }


  // ═══════════════════════════════════════════════════════════════
  // 👤 USER PROPERTIES
  // ═══════════════════════════════════════════════════════════════

  /// Kullanıcı özelliklerini ayarla (segmentasyon için)
  Future<void> setUserProperties({
    String? level,
    String? department,
    String? language,
    bool? isCalibrated,
  }) async {
    try {
      if (level != null) {
        await _analytics.setUserProperty(name: 'user_level', value: level);
      }
      if (department != null) {
        await _analytics.setUserProperty(name: 'department', value: department);
      }
      if (language != null) {
        await _analytics.setUserProperty(name: 'language', value: language);
      }
      if (isCalibrated != null) {
        await _analytics.setUserProperty(
          name: 'is_calibrated',
          value: isCalibrated.toString(),
        );
      }
    } catch (e) {
      debugPrint('❌ User property hatası: $e');
    }
  }
}
