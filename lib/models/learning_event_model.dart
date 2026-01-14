/// SOLICAP - Learning Event Model
/// Öğrenme olayları stream sistemi
/// Sprint 1 - Data Foundation

import 'package:cloud_firestore/cloud_firestore.dart';

/// Öğrenme olayı türleri
enum LearningEventType {
  // ═══════════════════════════════════════════════════════════════
  // 📸 SORU YAŞAM DÖNGÜSÜ
  // ═══════════════════════════════════════════════════════════════
  questionStarted,        // Soru görüntülendi
  questionImageCaptured,  // Fotoğraf çekildi
  questionPaused,         // Uygulama arka plana gitti
  questionResumed,        // Uygulama geri geldi
  hintRequested,          // İpucu istendi
  socraticStepCompleted,  // Sokratik adım tamamlandı
  answerSubmitted,        // Cevap gönderildi
  solutionViewed,         // Çözüm görüntülendi
  questionAbandoned,      // Vazgeçildi
  
  // ═══════════════════════════════════════════════════════════════
  // 📚 ÖĞRENME EYLEMLERİ
  // ═══════════════════════════════════════════════════════════════
  microLessonStarted,     // Mikro ders başladı
  microLessonCompleted,   // Mikro ders tamamlandı
  similarQuestionStarted, // Benzer soru başladı
  similarQuestionCompleted,
  spacedRepetitionReviewed, // Tekrar kartı incelendi
  pdfExamGenerated,       // PDF deneme oluşturuldu
  
  // ═══════════════════════════════════════════════════════════════
  // 📊 ANALİZ EYLEMLERİ
  // ═══════════════════════════════════════════════════════════════
  progressViewed,         // İlerleme ekranı görüntülendi
  aiAnalysisRequested,    // AI analizi istendi
  whyWrongAnalyzed,       // "Neden yanlış" analizi yapıldı
  
  // ═══════════════════════════════════════════════════════════════
  // 💎 ENGAGEMENT SİNYALLERİ
  // ═══════════════════════════════════════════════════════════════
  appOpened,              // Uygulama açıldı
  appBackgrounded,        // Arka plana gitti
  sessionStarted,         // Çalışma oturumu başladı
  sessionEnded,           // Çalışma oturumu bitti
  dailyGoalSet,           // Günlük hedef belirlendi
  dailyGoalAchieved,      // Günlük hedef ulaşıldı
  streakContinued,        // Streak devam etti
  streakBroken,           // Streak kırıldı
  
  // ═══════════════════════════════════════════════════════════════
  // 💰 PARA BİRİMİ
  // ═══════════════════════════════════════════════════════════════
  pointsEarned,           // Puan kazanıldı
  pointsSpent,            // Puan harcandı
  adWatched,              // Reklam izlendi
}

/// Tek bir öğrenme olayı
class LearningEvent {
  final String eventId;
  final LearningEventType type;
  final String userId;
  final DateTime timestamp;
  
  /// Olayla ilgili ek veriler
  final Map<String, dynamic> metadata;
  
  /// İlişkili oturum ID'si (varsa)
  final String? sessionId;
  
  /// İlişkili soru ID'si (varsa)
  final String? questionId;
  
  /// İlişkili konu
  final String? subject;
  final String? topic;

  LearningEvent({
    required this.eventId,
    required this.type,
    required this.userId,
    required this.timestamp,
    this.metadata = const {},
    this.sessionId,
    this.questionId,
    this.subject,
    this.topic,
  });

  /// Firestore'dan oku
  factory LearningEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return LearningEvent(
      eventId: doc.id,
      type: _parseEventType(data['type']),
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      sessionId: data['sessionId'],
      questionId: data['questionId'],
      subject: data['subject'],
      topic: data['topic'],
    );
  }

  /// Firestore'a yaz
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
      'sessionId': sessionId,
      'questionId': questionId,
      'subject': subject,
      'topic': topic,
    };
  }

  /// Event type parse
  static LearningEventType _parseEventType(String? value) {
    if (value == null) return LearningEventType.appOpened;
    
    try {
      return LearningEventType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => LearningEventType.appOpened,
      );
    } catch (_) {
      return LearningEventType.appOpened;
    }
  }

  /// Hızlı oluşturucu factory'ler
  factory LearningEvent.questionStarted({
    required String userId,
    required String sessionId,
    String? subject,
    String? topic,
  }) {
    return LearningEvent(
      eventId: '',
      type: LearningEventType.questionStarted,
      userId: userId,
      timestamp: DateTime.now(),
      sessionId: sessionId,
      subject: subject,
      topic: topic,
    );
  }

  factory LearningEvent.hintRequested({
    required String userId,
    required String sessionId,
    required int hintNumber,
  }) {
    return LearningEvent(
      eventId: '',
      type: LearningEventType.hintRequested,
      userId: userId,
      timestamp: DateTime.now(),
      sessionId: sessionId,
      metadata: {'hintNumber': hintNumber},
    );
  }

  factory LearningEvent.answerSubmitted({
    required String userId,
    required String sessionId,
    required bool isCorrect,
    required int timeSpentMs,
  }) {
    return LearningEvent(
      eventId: '',
      type: LearningEventType.answerSubmitted,
      userId: userId,
      timestamp: DateTime.now(),
      sessionId: sessionId,
      metadata: {
        'isCorrect': isCorrect,
        'timeSpentMs': timeSpentMs,
      },
    );
  }

  factory LearningEvent.questionAbandoned({
    required String userId,
    required String sessionId,
    required int timeSpentMs,
    String? abandonReason,
  }) {
    return LearningEvent(
      eventId: '',
      type: LearningEventType.questionAbandoned,
      userId: userId,
      timestamp: DateTime.now(),
      sessionId: sessionId,
      metadata: {
        'timeSpentMs': timeSpentMs,
        'abandonReason': abandonReason,
      },
    );
  }
}

/// Günlük öğrenme özeti (snapshot)
class DailyLearningSnapshot {
  final String oderId;
  final String oderId2; // oderId + date combo
  final DateTime date;
  
  // ═══════════════════════════════════════════════════════════════
  // 📊 TEMEL METRİKLER
  // ═══════════════════════════════════════════════════════════════
  final int questionsAttempted;
  final int questionsCorrect;
  final int questionsWrong;
  final int totalStudyMinutes;
  final int totalSessions;
  
  // ═══════════════════════════════════════════════════════════════
  // ⏱️ ZAMAN METRİKLERİ
  // ═══════════════════════════════════════════════════════════════
  final double averageTimePerQuestionMs;
  final int fastestQuestionMs;
  final int slowestQuestionMs;
  
  // ═══════════════════════════════════════════════════════════════
  // 🎯 ETKİLEŞİM
  // ═══════════════════════════════════════════════════════════════
  final int hintsUsed;
  final int questionsAbandoned;
  final int microLessonsCompleted;
  final int similarQuestionsAttempted;
  
  // ═══════════════════════════════════════════════════════════════
  // 📈 KONU BAZLI
  // ═══════════════════════════════════════════════════════════════
  /// {konu: başarı oranı}
  final Map<String, double> topicScores;
  
  /// O gün en çok çalışılan konu
  final String? dominantTopic;
  
  /// O gün en çok yapılan hata türü
  final String? dominantErrorType;

  DailyLearningSnapshot({
    required this.oderId,
    required this.oderId2,
    required this.date,
    this.questionsAttempted = 0,
    this.questionsCorrect = 0,
    this.questionsWrong = 0,
    this.totalStudyMinutes = 0,
    this.totalSessions = 0,
    this.averageTimePerQuestionMs = 0,
    this.fastestQuestionMs = 0,
    this.slowestQuestionMs = 0,
    this.hintsUsed = 0,
    this.questionsAbandoned = 0,
    this.microLessonsCompleted = 0,
    this.similarQuestionsAttempted = 0,
    this.topicScores = const {},
    this.dominantTopic,
    this.dominantErrorType,
  });

  /// Başarı oranı
  double get successRate {
    if (questionsAttempted == 0) return 0.0;
    return questionsCorrect / questionsAttempted;
  }

  /// Firestore'dan oku
  factory DailyLearningSnapshot.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return DailyLearningSnapshot(
      oderId: data['userId'] ?? '',
      oderId2: doc.id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      questionsAttempted: data['questionsAttempted'] ?? 0,
      questionsCorrect: data['questionsCorrect'] ?? 0,
      questionsWrong: data['questionsWrong'] ?? 0,
      totalStudyMinutes: data['totalStudyMinutes'] ?? 0,
      totalSessions: data['totalSessions'] ?? 0,
      averageTimePerQuestionMs: (data['averageTimePerQuestionMs'] as num?)?.toDouble() ?? 0,
      fastestQuestionMs: data['fastestQuestionMs'] ?? 0,
      slowestQuestionMs: data['slowestQuestionMs'] ?? 0,
      hintsUsed: data['hintsUsed'] ?? 0,
      questionsAbandoned: data['questionsAbandoned'] ?? 0,
      microLessonsCompleted: data['microLessonsCompleted'] ?? 0,
      similarQuestionsAttempted: data['similarQuestionsAttempted'] ?? 0,
      topicScores: Map<String, double>.from(
        (data['topicScores'] as Map<String, dynamic>? ?? {}).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      ),
      dominantTopic: data['dominantTopic'],
      dominantErrorType: data['dominantErrorType'],
    );
  }

  /// Firestore'a yaz
  Map<String, dynamic> toFirestore() {
    return {
      'userId': oderId,
      'date': Timestamp.fromDate(date),
      'questionsAttempted': questionsAttempted,
      'questionsCorrect': questionsCorrect,
      'questionsWrong': questionsWrong,
      'totalStudyMinutes': totalStudyMinutes,
      'totalSessions': totalSessions,
      'averageTimePerQuestionMs': averageTimePerQuestionMs,
      'fastestQuestionMs': fastestQuestionMs,
      'slowestQuestionMs': slowestQuestionMs,
      'hintsUsed': hintsUsed,
      'questionsAbandoned': questionsAbandoned,
      'microLessonsCompleted': microLessonsCompleted,
      'similarQuestionsAttempted': similarQuestionsAttempted,
      'topicScores': topicScores,
      'dominantTopic': dominantTopic,
      'dominantErrorType': dominantErrorType,
    };
  }

  /// Boş snapshot
  factory DailyLearningSnapshot.empty(String oderId) {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    return DailyLearningSnapshot(
      oderId: oderId,
      oderId2: '${oderId}_$dateKey',
      date: DateTime(now.year, now.month, now.day),
    );
  }
}
