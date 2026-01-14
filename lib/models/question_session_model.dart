/// SOLICAP - Question Session Model
/// Her soru çözümü için detaylı oturum verisi
/// Sprint 1 - Data Foundation

import 'package:cloud_firestore/cloud_firestore.dart';

/// Soru çözüm oturumu - Zaman metrikleri ve etkileşim verileri
class QuestionSession {
  final String sessionId;
  final String? questionId;
  final String userId;
  
  // ═══════════════════════════════════════════════════════════════
  // ⏱️ ZAMAN METRİKLERİ
  // ═══════════════════════════════════════════════════════════════
  final DateTime startTime;
  final DateTime? endTime;
  final int totalTimeMs;                // Toplam süre (milisaniye)
  final int? timeToFirstInteractionMs;  // İlk etkileşime kadar süre
  final int? thinkingTimeMs;            // Düşünme süresi (scroll/tıklama yok)
  
  // ═══════════════════════════════════════════════════════════════
  // 🎯 ETKİLEŞİM METRİKLERİ
  // ═══════════════════════════════════════════════════════════════
  final int hintRequestCount;           // Kaç ipucu istendi
  final int socraticStepsUsed;          // Sokratik adım sayısı
  final bool wasAbandoned;              // Vazgeçildi mi?
  final int? abandonedAtStep;           // Hangi adımda bırakıldı?
  final SessionEndReason endReason;     // Nasıl sonlandı?
  
  // ═══════════════════════════════════════════════════════════════
  // 📊 SONUÇ METRİKLERİ
  // ═══════════════════════════════════════════════════════════════
  final bool? isCorrect;
  final String? selectedAnswer;
  final String? correctAnswer;
  final double? confidenceScore;        // Kullanıcı ne kadar emin (0.0-1.0)
  
  // ═══════════════════════════════════════════════════════════════
  // 🧠 BİLİŞSEL METRİKLER (AI tarafından tespit edilen)
  // ═══════════════════════════════════════════════════════════════
  final CognitiveLoadLevel? cognitiveLoadLevel;
  final String? errorCategory;          // conceptual/procedural/careless/time
  final List<String> misconceptions;    // Tespit edilen kavram yanılgıları
  
  // ═══════════════════════════════════════════════════════════════
  // 🔗 SORU BAĞLAMI
  // ═══════════════════════════════════════════════════════════════
  final String? questionTargetLevel;    // İlkokul 4 / Lise 10 / Üniversite 2
  final String? subject;                // Matematik, Fizik, vb.
  final String? topic;                  // Türev, Alan, vb.
  final String? subTopic;               // Alt konu
  final String? difficulty;             // easy/medium/hard
  final String? questionType;           // multiple_choice/open_ended/calculation

  QuestionSession({
    required this.sessionId,
    this.questionId,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.totalTimeMs = 0,
    this.timeToFirstInteractionMs,
    this.thinkingTimeMs,
    this.hintRequestCount = 0,
    this.socraticStepsUsed = 0,
    this.wasAbandoned = false,
    this.abandonedAtStep,
    this.endReason = SessionEndReason.completed,
    this.isCorrect,
    this.selectedAnswer,
    this.correctAnswer,
    this.confidenceScore,
    this.cognitiveLoadLevel,
    this.errorCategory,
    this.misconceptions = const [],
    this.questionTargetLevel,
    this.subject,
    this.topic,
    this.subTopic,
    this.difficulty,
    this.questionType,
  });

  /// Firestore'dan oku
  factory QuestionSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return QuestionSession(
      sessionId: doc.id,
      questionId: data['questionId'],
      userId: data['userId'] ?? '',
      startTime: (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (data['endTime'] as Timestamp?)?.toDate(),
      totalTimeMs: data['totalTimeMs'] ?? 0,
      timeToFirstInteractionMs: data['timeToFirstInteractionMs'],
      thinkingTimeMs: data['thinkingTimeMs'],
      hintRequestCount: data['hintRequestCount'] ?? 0,
      socraticStepsUsed: data['socraticStepsUsed'] ?? 0,
      wasAbandoned: data['wasAbandoned'] ?? false,
      abandonedAtStep: data['abandonedAtStep'],
      endReason: SessionEndReason.fromString(data['endReason']),
      isCorrect: data['isCorrect'],
      selectedAnswer: data['selectedAnswer'],
      correctAnswer: data['correctAnswer'],
      confidenceScore: (data['confidenceScore'] as num?)?.toDouble(),
      cognitiveLoadLevel: CognitiveLoadLevel.fromString(data['cognitiveLoadLevel']),
      errorCategory: data['errorCategory'],
      misconceptions: List<String>.from(data['misconceptions'] ?? []),
      questionTargetLevel: data['questionTargetLevel'],
      subject: data['subject'],
      topic: data['topic'],
      subTopic: data['subTopic'],
      difficulty: data['difficulty'],
      questionType: data['questionType'],
    );
  }

  /// Firestore'a yaz
  Map<String, dynamic> toFirestore() {
    return {
      'questionId': questionId,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'totalTimeMs': totalTimeMs,
      'timeToFirstInteractionMs': timeToFirstInteractionMs,
      'thinkingTimeMs': thinkingTimeMs,
      'hintRequestCount': hintRequestCount,
      'socraticStepsUsed': socraticStepsUsed,
      'wasAbandoned': wasAbandoned,
      'abandonedAtStep': abandonedAtStep,
      'endReason': endReason.name,
      'isCorrect': isCorrect,
      'selectedAnswer': selectedAnswer,
      'correctAnswer': correctAnswer,
      'confidenceScore': confidenceScore,
      'cognitiveLoadLevel': cognitiveLoadLevel?.name,
      'errorCategory': errorCategory,
      'misconceptions': misconceptions,
      'questionTargetLevel': questionTargetLevel,
      'subject': subject,
      'topic': topic,
      'subTopic': subTopic,
      'difficulty': difficulty,
      'questionType': questionType,
    };
  }

  /// Kopya ile güncelle
  QuestionSession copyWith({
    String? sessionId,
    String? questionId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? totalTimeMs,
    int? timeToFirstInteractionMs,
    int? thinkingTimeMs,
    int? hintRequestCount,
    int? socraticStepsUsed,
    bool? wasAbandoned,
    int? abandonedAtStep,
    SessionEndReason? endReason,
    bool? isCorrect,
    String? selectedAnswer,
    String? correctAnswer,
    double? confidenceScore,
    CognitiveLoadLevel? cognitiveLoadLevel,
    String? errorCategory,
    List<String>? misconceptions,
    String? questionTargetLevel,
    String? subject,
    String? topic,
    String? subTopic,
    String? difficulty,
    String? questionType,
  }) {
    return QuestionSession(
      sessionId: sessionId ?? this.sessionId,
      questionId: questionId ?? this.questionId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalTimeMs: totalTimeMs ?? this.totalTimeMs,
      timeToFirstInteractionMs: timeToFirstInteractionMs ?? this.timeToFirstInteractionMs,
      thinkingTimeMs: thinkingTimeMs ?? this.thinkingTimeMs,
      hintRequestCount: hintRequestCount ?? this.hintRequestCount,
      socraticStepsUsed: socraticStepsUsed ?? this.socraticStepsUsed,
      wasAbandoned: wasAbandoned ?? this.wasAbandoned,
      abandonedAtStep: abandonedAtStep ?? this.abandonedAtStep,
      endReason: endReason ?? this.endReason,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      cognitiveLoadLevel: cognitiveLoadLevel ?? this.cognitiveLoadLevel,
      errorCategory: errorCategory ?? this.errorCategory,
      misconceptions: misconceptions ?? this.misconceptions,
      questionTargetLevel: questionTargetLevel ?? this.questionTargetLevel,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      subTopic: subTopic ?? this.subTopic,
      difficulty: difficulty ?? this.difficulty,
      questionType: questionType ?? this.questionType,
    );
  }

  /// Süreyi hesapla (saniye)
  double get durationSeconds => totalTimeMs / 1000.0;

  /// Süreyi insan-okunur formatta al
  String get durationFormatted {
    final seconds = totalTimeMs ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '$minutes dk ${remainingSeconds} sn';
    }
    return '$seconds sn';
  }

  /// Zorlandı mı? (ipucu istedi veya uzun sürdü)
  bool get showedStruggle => hintRequestCount > 0 || wasAbandoned;
}

// ═══════════════════════════════════════════════════════════════════════════
// ENUM'LAR
// ═══════════════════════════════════════════════════════════════════════════

/// Oturum bitiş nedeni
enum SessionEndReason {
  completed,      // Normal tamamlandı
  abandoned,      // Vazgeçildi
  appClosed,      // Uygulama kapatıldı
  timeout,        // Zaman aşımı
  skipped,        // Atlandı
  unknown;        // Bilinmiyor

  static SessionEndReason fromString(String? value) {
    switch (value) {
      case 'completed': return SessionEndReason.completed;
      case 'abandoned': return SessionEndReason.abandoned;
      case 'appClosed': return SessionEndReason.appClosed;
      case 'timeout': return SessionEndReason.timeout;
      case 'skipped': return SessionEndReason.skipped;
      default: return SessionEndReason.unknown;
    }
  }
}

/// Bilişsel yük seviyesi
enum CognitiveLoadLevel {
  low,        // Rahat, hızlı çözüyor
  medium,     // Normal
  high,       // Zorlanıyor ama devam ediyor
  overload;   // Bunalmış, müdahale gerekebilir

  static CognitiveLoadLevel? fromString(String? value) {
    switch (value) {
      case 'low': return CognitiveLoadLevel.low;
      case 'medium': return CognitiveLoadLevel.medium;
      case 'high': return CognitiveLoadLevel.high;
      case 'overload': return CognitiveLoadLevel.overload;
      default: return null;
    }
  }

  String get label {
    switch (this) {
      case CognitiveLoadLevel.low: return 'Düşük';
      case CognitiveLoadLevel.medium: return 'Normal';
      case CognitiveLoadLevel.high: return 'Yüksek';
      case CognitiveLoadLevel.overload: return 'Aşırı Yük';
    }
  }

  String get emoji {
    switch (this) {
      case CognitiveLoadLevel.low: return '😊';
      case CognitiveLoadLevel.medium: return '🤔';
      case CognitiveLoadLevel.high: return '😓';
      case CognitiveLoadLevel.overload: return '😵';
    }
  }
}
