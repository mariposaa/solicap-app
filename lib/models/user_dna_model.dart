/// SOLICAP - User DNA Model
/// Kullanıcının tüm öğrenme verilerini tutan merkezi veri bankası

import 'package:cloud_firestore/cloud_firestore.dart';

/// Ana User DNA modeli - Tüm kullanıcı verilerini içerir
class UserDNA {
  final String userId;
  
  // ═══════════════════════════════════════════════════════════════
  // PROFİL VERİLERİ (ESKİ)
  // ═══════════════════════════════════════════════════════════════
  final String? userName;             // 👤 Kullanıcı ismi
  final String? gradeLevel;           // Sınıf seviyesi (9, 10, 11, 12, Mezun)
  final String? targetExam;           // Hedef sınav (YKS, LGS, KPSS, DGS, vb.)
  final String? learningStyle;        // Öğrenme stili (görsel, işitsel, kinestetik)
  final String? motivationLevel;      // Motivasyon durumu (yüksek, orta, düşük)
  final String? difficultyPreference; // Zorluk tercihi (kolay, orta, zor, karışık)
  
  /// Ödül kazanırsa ulaşmak için (opsiyonel)
  final String? prizeContactEmail;
  final String? prizeContactPhone;
  
  // ═══════════════════════════════════════════════════════════════
  // 🌍 EVRENSEL PROFİL VERİLERİ (YENİ)
  // ═══════════════════════════════════════════════════════════════
  final String? level;                // "k12" | "university" | "professional"
  final String? department;           // Serbest metin: "Tıp", "Computer Science", "Hukuk"
  final String? uiLanguage;           // UI dili (telefondan): "TR", "EN", "DE"
  final String? studyLanguage;        // Ders dili: "EN", "TR", "DE"
  final String? explanationLanguage;  // Açıklama dili: "TR", "EN"
  final String? onboardingRawText;    // Kullanıcının ilk yazdığı metin (arşiv)
  
  // ═══════════════════════════════════════════════════════════════
  // 🎯 KALİBRASYON VERİLERİ (YENİ)
  // ═══════════════════════════════════════════════════════════════
  final int questionCount;            // Toplam soru sayısı (kalibrasyon sayaç)
  final bool isCalibrated;            // 10+ soru = true
  final int lastSupervisorCheck;      // Son supervisor kontrolü hangi soruda yapıldı
  
  // ═══════════════════════════════════════════════════════════════
  // 🏷️ AUTO-DISCOVERED TOPICS (YENİ)
  // ═══════════════════════════════════════════════════════════════
  final List<String> discoveredTopics;  // AI tarafından keşfedilen konular
  final List<String> interests;         // Kullanıcının ilgi alanları
  final List<String> struggles;         // Zorlandığı alanlar (onboarding'den)
  
  // ═══════════════════════════════════════════════════════════════
  // AKADEMİK İSTATİSTİKLER
  // ═══════════════════════════════════════════════════════════════
  final int totalQuestionsSolved;     // Toplam çözülen soru
  final int totalCorrect;             // Toplam doğru
  final int totalWrong;               // Toplam yanlış
  final double overallSuccessRate;    // Genel başarı oranı
  
  // ═══════════════════════════════════════════════════════════════
  // KONU BAZLI VERİLER
  // ═══════════════════════════════════════════════════════════════
  /// Konu bazlı performans: {"Matematik": TopicPerformance, ...}
  final Map<String, TopicPerformance> topicPerformance;
  
  /// Alt konu bazlı performans: {"Türev": SubTopicPerformance, ...}
  final Map<String, SubTopicPerformance> subTopicPerformance;
  
  /// Zayıf konular listesi (AI tarafından belirlenen)
  final List<WeakTopic> weakTopics;
  
  /// Güçlü konular listesi
  final List<String> strongTopics;
  
  // ═══════════════════════════════════════════════════════════════
  // DAVRANIŞSAL VERİLER
  // ═══════════════════════════════════════════════════════════════
  final double similarQuestionCompletionRate; // Benzer soru çözme oranı (%)
  final List<AbandonmentPoint> abandonmentPoints; // Bırakma noktaları
  final Map<String, int> activeHours;         // Aktif saatler {"14": 5, "15": 8}
  final int totalStudyMinutes;                // Toplam çalışma süresi (dakika)
  
  // ═══════════════════════════════════════════════════════════════
  // VERİ MADENCİLİĞİ - SORU BANKASI
  // ═══════════════════════════════════════════════════════════════
  /// Çözemediği/yanlış yaptığı sorular (hazine!)
  final List<FailedQuestion> failedQuestions;
  
  /// Hata pattern'leri: {"dikkatsizlik": 15, "konu_eksigi": 23, ...}
  final Map<String, int> errorPatterns;
  
  // ═══════════════════════════════════════════════════════════════
  // 🎯 HEDEF & DENEME VERİLERİ
  // ═══════════════════════════════════════════════════════════════
  final int? targetNetScore;           // Hedef net (örn: 100)
  final String? targetNetDetail;       // "TYT 100 net" detay açıklaması
  final int? lastMockNetScore;         // Son deneme neti
  final DateTime? lastMockDate;        // Son deneme tarihi
  final List<MockExamEntry> mockHistory; // Tüm deneme geçmişi (gelişim için)
  final DateTime? lastRoadmapDate;      // Son yol haritası tarihi
  final String? lastRoadmapText;        // Son yol haritası metni

  // ═══════════════════════════════════════════════════════════════
  // META VERİLER
  // ═══════════════════════════════════════════════════════════════
  final DateTime createdAt;
  final DateTime lastUpdated;
  final int totalAIInteractions;      // Toplam AI etkileşimi

  UserDNA({
    required this.userId,
    this.userName,
    this.gradeLevel,
    this.targetExam,
    this.learningStyle,
    this.motivationLevel,
    this.difficultyPreference,
    this.prizeContactEmail,
    this.prizeContactPhone,
    // Yeni evrensel alanlar
    this.level,
    this.department,
    this.uiLanguage,
    this.studyLanguage,
    this.explanationLanguage,
    this.onboardingRawText,
    // Kalibrasyon
    this.questionCount = 0,
    this.isCalibrated = false,
    this.lastSupervisorCheck = 0,
    // Auto-discovered
    this.discoveredTopics = const [],
    this.interests = const [],
    this.struggles = const [],
    // Eski alanlar
    this.totalQuestionsSolved = 0,
    this.totalCorrect = 0,
    this.totalWrong = 0,
    this.overallSuccessRate = 0.0,
    this.topicPerformance = const {},
    this.subTopicPerformance = const {},
    this.weakTopics = const [],
    this.strongTopics = const [],
    this.similarQuestionCompletionRate = 0.0,
    this.abandonmentPoints = const [],
    this.activeHours = const {},
    this.totalStudyMinutes = 0,
    this.failedQuestions = const [],
    this.errorPatterns = const {},
    // Hedef & deneme
    this.targetNetScore,
    this.targetNetDetail,
    this.lastMockNetScore,
    this.lastMockDate,
    this.mockHistory = const [],
    this.lastRoadmapDate,
    this.lastRoadmapText,
    required this.createdAt,
    required this.lastUpdated,
    this.totalAIInteractions = 0,
  });

  /// Firestore'dan oku
  factory UserDNA.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return UserDNA(
      userId: doc.id,
      // Eski profil
      userName: data['userName'],
      gradeLevel: data['gradeLevel'],
      targetExam: data['targetExam'],
      learningStyle: data['learningStyle'],
      motivationLevel: data['motivationLevel'],
      difficultyPreference: data['difficultyPreference'],
      prizeContactEmail: data['prizeContactEmail'],
      prizeContactPhone: data['prizeContactPhone'],
      // Yeni evrensel alanlar
      level: data['level'],
      department: data['department'],
      uiLanguage: data['uiLanguage'],
      studyLanguage: data['studyLanguage'],
      explanationLanguage: data['explanationLanguage'],
      onboardingRawText: data['onboardingRawText'],
      // Kalibrasyon
      questionCount: data['questionCount'] ?? 0,
      isCalibrated: data['isCalibrated'] ?? false,
      lastSupervisorCheck: data['lastSupervisorCheck'] ?? 0,
      // Auto-discovered
      discoveredTopics: List<String>.from(data['discoveredTopics'] ?? []),
      interests: List<String>.from(data['interests'] ?? []),
      struggles: List<String>.from(data['struggles'] ?? []),
      // Eski istatistikler
      totalQuestionsSolved: data['totalQuestionsSolved'] ?? 0,
      totalCorrect: data['totalCorrect'] ?? 0,
      totalWrong: data['totalWrong'] ?? 0,
      overallSuccessRate: (data['overallSuccessRate'] ?? 0).toDouble(),
      topicPerformance: _parseTopicPerformance(data['topicPerformance']),
      subTopicPerformance: _parseSubTopicPerformance(data['subTopicPerformance']),
      weakTopics: _parseWeakTopics(data['weakTopics']),
      strongTopics: List<String>.from(data['strongTopics'] ?? []),
      similarQuestionCompletionRate: (data['similarQuestionCompletionRate'] ?? 0).toDouble(),
      abandonmentPoints: _parseAbandonmentPoints(data['abandonmentPoints']),
      activeHours: Map<String, int>.from(data['activeHours'] ?? {}),
      totalStudyMinutes: data['totalStudyMinutes'] ?? 0,
      failedQuestions: _parseFailedQuestions(data['failedQuestions']),
      errorPatterns: Map<String, int>.from(data['errorPatterns'] ?? {}),
      // Hedef & deneme
      targetNetScore: data['targetNetScore'],
      targetNetDetail: data['targetNetDetail'],
      lastMockNetScore: data['lastMockNetScore'],
      lastMockDate: (data['lastMockDate'] as Timestamp?)?.toDate(),
      mockHistory: _parseMockHistory(data['mockHistory']),
      lastRoadmapDate: (data['lastRoadmapDate'] as Timestamp?)?.toDate(),
      lastRoadmapText: data['lastRoadmapText'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalAIInteractions: data['totalAIInteractions'] ?? 0,
    );
  }

  /// Firestore'a yaz
  Map<String, dynamic> toFirestore() {
    return {
      // Eski profil
      'userName': userName,
      'gradeLevel': gradeLevel,
      'targetExam': targetExam,
      'learningStyle': learningStyle,
      'motivationLevel': motivationLevel,
      'difficultyPreference': difficultyPreference,
      'prizeContactEmail': prizeContactEmail,
      'prizeContactPhone': prizeContactPhone,
      // Yeni evrensel alanlar
      'level': level,
      'department': department,
      'uiLanguage': uiLanguage,
      'studyLanguage': studyLanguage,
      'explanationLanguage': explanationLanguage,
      'onboardingRawText': onboardingRawText,
      // Kalibrasyon
      'questionCount': questionCount,
      'isCalibrated': isCalibrated,
      'lastSupervisorCheck': lastSupervisorCheck,
      // Auto-discovered
      'discoveredTopics': discoveredTopics,
      'interests': interests,
      'struggles': struggles,
      // Eski istatistikler
      'totalQuestionsSolved': totalQuestionsSolved,
      'totalCorrect': totalCorrect,
      'totalWrong': totalWrong,
      'overallSuccessRate': overallSuccessRate,
      'topicPerformance': topicPerformance.map((k, v) => MapEntry(k, v.toMap())),
      'subTopicPerformance': subTopicPerformance.map((k, v) => MapEntry(k, v.toMap())),
      'weakTopics': weakTopics.map((w) => w.toMap()).toList(),
      'strongTopics': strongTopics,
      'similarQuestionCompletionRate': similarQuestionCompletionRate,
      'abandonmentPoints': abandonmentPoints.map((a) => a.toMap()).toList(),
      'activeHours': activeHours,
      'totalStudyMinutes': totalStudyMinutes,
      'failedQuestions': failedQuestions.map((f) => f.toMap()).toList(),
      'errorPatterns': errorPatterns,
      // Hedef & deneme
      'targetNetScore': targetNetScore,
      'targetNetDetail': targetNetDetail,
      'lastMockNetScore': lastMockNetScore,
      'lastMockDate': lastMockDate != null ? Timestamp.fromDate(lastMockDate!) : null,
      'mockHistory': mockHistory.map((m) => m.toMap()).toList(),
      'lastRoadmapDate': lastRoadmapDate != null ? Timestamp.fromDate(lastRoadmapDate!) : null,
      'lastRoadmapText': lastRoadmapText,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
      'totalAIInteractions': totalAIInteractions,
    };
  }

  /// Boş DNA oluştur
  factory UserDNA.empty(String userId) {
    return UserDNA(
      userId: userId,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Kopya ile güncelle
  UserDNA copyWith({
    // Eski profil
    String? userName,
    String? gradeLevel,
    String? targetExam,
    String? learningStyle,
    String? motivationLevel,
    String? difficultyPreference,
    String? prizeContactEmail,
    String? prizeContactPhone,
    // Yeni evrensel alanlar
    String? level,
    String? department,
    String? uiLanguage,
    String? studyLanguage,
    String? explanationLanguage,
    String? onboardingRawText,
    // Kalibrasyon
    int? questionCount,
    bool? isCalibrated,
    int? lastSupervisorCheck,
    // Auto-discovered
    List<String>? discoveredTopics,
    List<String>? interests,
    List<String>? struggles,
    // Eski istatistikler
    int? totalQuestionsSolved,
    int? totalCorrect,
    int? totalWrong,
    double? overallSuccessRate,
    Map<String, TopicPerformance>? topicPerformance,
    Map<String, SubTopicPerformance>? subTopicPerformance,
    List<WeakTopic>? weakTopics,
    List<String>? strongTopics,
    double? similarQuestionCompletionRate,
    List<AbandonmentPoint>? abandonmentPoints,
    Map<String, int>? activeHours,
    int? totalStudyMinutes,
    List<FailedQuestion>? failedQuestions,
    Map<String, int>? errorPatterns,
    // Hedef & deneme
    int? targetNetScore,
    String? targetNetDetail,
    int? lastMockNetScore,
    DateTime? lastMockDate,
    List<MockExamEntry>? mockHistory,
    DateTime? lastRoadmapDate,
    String? lastRoadmapText,
    int? totalAIInteractions,
  }) {
    return UserDNA(
      userId: userId,
      // Eski profil
      userName: userName ?? this.userName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      targetExam: targetExam ?? this.targetExam,
      learningStyle: learningStyle ?? this.learningStyle,
      motivationLevel: motivationLevel ?? this.motivationLevel,
      difficultyPreference: difficultyPreference ?? this.difficultyPreference,
      prizeContactEmail: prizeContactEmail ?? this.prizeContactEmail,
      prizeContactPhone: prizeContactPhone ?? this.prizeContactPhone,
      // Yeni evrensel alanlar
      level: level ?? this.level,
      department: department ?? this.department,
      uiLanguage: uiLanguage ?? this.uiLanguage,
      studyLanguage: studyLanguage ?? this.studyLanguage,
      explanationLanguage: explanationLanguage ?? this.explanationLanguage,
      onboardingRawText: onboardingRawText ?? this.onboardingRawText,
      // Kalibrasyon
      questionCount: questionCount ?? this.questionCount,
      isCalibrated: isCalibrated ?? this.isCalibrated,
      lastSupervisorCheck: lastSupervisorCheck ?? this.lastSupervisorCheck,
      // Auto-discovered
      discoveredTopics: discoveredTopics ?? this.discoveredTopics,
      interests: interests ?? this.interests,
      struggles: struggles ?? this.struggles,
      // Eski istatistikler
      totalQuestionsSolved: totalQuestionsSolved ?? this.totalQuestionsSolved,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      overallSuccessRate: overallSuccessRate ?? this.overallSuccessRate,
      topicPerformance: topicPerformance ?? this.topicPerformance,
      subTopicPerformance: subTopicPerformance ?? this.subTopicPerformance,
      weakTopics: weakTopics ?? this.weakTopics,
      strongTopics: strongTopics ?? this.strongTopics,
      similarQuestionCompletionRate: similarQuestionCompletionRate ?? this.similarQuestionCompletionRate,
      abandonmentPoints: abandonmentPoints ?? this.abandonmentPoints,
      activeHours: activeHours ?? this.activeHours,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      failedQuestions: failedQuestions ?? this.failedQuestions,
      errorPatterns: errorPatterns ?? this.errorPatterns,
      // Hedef & deneme
      targetNetScore: targetNetScore ?? this.targetNetScore,
      targetNetDetail: targetNetDetail ?? this.targetNetDetail,
      lastMockNetScore: lastMockNetScore ?? this.lastMockNetScore,
      lastMockDate: lastMockDate ?? this.lastMockDate,
      mockHistory: mockHistory ?? this.mockHistory,
      lastRoadmapDate: lastRoadmapDate ?? this.lastRoadmapDate,
      lastRoadmapText: lastRoadmapText ?? this.lastRoadmapText,
      createdAt: createdAt,
      lastUpdated: DateTime.now(),
      totalAIInteractions: totalAIInteractions ?? this.totalAIInteractions,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // PARSE HELPERS
  // ═══════════════════════════════════════════════════════════════
  
  static Map<String, TopicPerformance> _parseTopicPerformance(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, TopicPerformance.fromMap(v)));
  }

  static Map<String, SubTopicPerformance> _parseSubTopicPerformance(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, SubTopicPerformance.fromMap(v)));
  }

  static List<WeakTopic> _parseWeakTopics(dynamic data) {
    if (data == null) return [];
    return (data as List).map((e) => WeakTopic.fromMap(e)).toList();
  }

  static List<AbandonmentPoint> _parseAbandonmentPoints(dynamic data) {
    if (data == null) return [];
    return (data as List).map((e) => AbandonmentPoint.fromMap(e)).toList();
  }

  static List<FailedQuestion> _parseFailedQuestions(dynamic data) {
    if (data == null) return [];
    return (data as List).map((e) => FailedQuestion.fromMap(e)).toList();
  }

  static List<MockExamEntry> _parseMockHistory(dynamic data) {
    if (data == null) return [];
    return (data as List).map((e) => MockExamEntry.fromMap(e as Map<String, dynamic>)).toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════
// ALT MODELLER
// ═══════════════════════════════════════════════════════════════════════

/// Konu bazlı performans
class TopicPerformance {
  final String topic;
  final int totalQuestions;
  final int correct;
  final int wrong;
  final double successRate;
  final double weightedProficiency; // 🧪 0.0 - 1.0 arası ağırlıklı puan (YENİ)
  final int consecutiveCorrect;     // 🔥 Ardışık doğru sayısı (Mastery için)
  final DateTime lastAttempt;

  TopicPerformance({
    required this.topic,
    this.totalQuestions = 0,
    this.correct = 0,
    this.wrong = 0,
    this.successRate = 0.0,
    this.weightedProficiency = 0.0,
    this.consecutiveCorrect = 0,
    required this.lastAttempt,
  });

  factory TopicPerformance.fromMap(Map<String, dynamic> map) {
    return TopicPerformance(
      topic: map['topic'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correct: map['correct'] ?? 0,
      wrong: map['wrong'] ?? 0,
      successRate: (map['successRate'] ?? 0).toDouble(),
      weightedProficiency: (map['weightedProficiency'] ?? 0).toDouble(),
      consecutiveCorrect: map['consecutiveCorrect'] ?? 0,
      lastAttempt: (map['lastAttempt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'totalQuestions': totalQuestions,
      'correct': correct,
      'wrong': wrong,
      'successRate': successRate,
      'weightedProficiency': weightedProficiency,
      'consecutiveCorrect': consecutiveCorrect,
      'lastAttempt': Timestamp.fromDate(lastAttempt),
    };
  }
}

/// Alt konu bazlı performans
class SubTopicPerformance {
  final String parentTopic;     // Ana konu (Matematik)
  final String subTopic;        // Alt konu (Türev)
  final int totalQuestions;
  final int correct;
  final int wrong;
  final double successRate;
  final double weightedProficiency; // 🧪 0.0 - 1.0 arası ağırlıklı puan (YENİ)
  final int consecutiveCorrect;     // 🔥 Ardışık doğru sayısı
  final String proficiencyLevel;    // 'weak', 'medium', 'strong', 'mastered'
  final DateTime lastUpdate;        // 📅 Son güncellenme (Decay hesabı için)

  SubTopicPerformance({
    required this.parentTopic,
    required this.subTopic,
    this.totalQuestions = 0,
    this.correct = 0,
    this.wrong = 0,
    this.successRate = 0.0,
    this.weightedProficiency = 0.0,
    this.consecutiveCorrect = 0,
    this.proficiencyLevel = 'medium',
    required this.lastUpdate,
  });

  factory SubTopicPerformance.fromMap(Map<String, dynamic> map) {
    return SubTopicPerformance(
      parentTopic: map['parentTopic'] ?? '',
      subTopic: map['subTopic'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correct: map['correct'] ?? 0,
      wrong: map['wrong'] ?? 0,
      successRate: (map['successRate'] ?? 0).toDouble(),
      weightedProficiency: (map['weightedProficiency'] ?? 0).toDouble(),
      consecutiveCorrect: map['consecutiveCorrect'] ?? 0,
      proficiencyLevel: map['proficiencyLevel'] ?? 'medium',
      lastUpdate: (map['lastUpdate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentTopic': parentTopic,
      'subTopic': subTopic,
      'totalQuestions': totalQuestions,
      'correct': correct,
      'wrong': wrong,
      'successRate': successRate,
      'weightedProficiency': weightedProficiency,
      'consecutiveCorrect': consecutiveCorrect,
      'proficiencyLevel': proficiencyLevel,
      'lastUpdate': Timestamp.fromDate(lastUpdate),
    };
  }
}

/// Zayıf konu detayı
class WeakTopic {
  final String topic;
  final String subTopic;
  final double successRate;
  final String reason;          // "konu_eksigi", "dikkatsizlik", "zaman_yetersiz"
  final List<String> recommendations;
  final int priority;           // 1-5 (1 en acil)
  final int wrongCount;         // Kaç kez yanlış yapıldı

  WeakTopic({
    required this.topic,
    required this.subTopic,
    required this.successRate,
    required this.reason,
    this.recommendations = const [],
    this.priority = 3,
    this.wrongCount = 0,
  });

  factory WeakTopic.fromMap(Map<String, dynamic> map) {
    return WeakTopic(
      topic: map['topic'] ?? '',
      subTopic: map['subTopic'] ?? '',
      successRate: (map['successRate'] ?? 0).toDouble(),
      reason: map['reason'] ?? '',
      recommendations: List<String>.from(map['recommendations'] ?? []),
      priority: map['priority'] ?? 3,
      wrongCount: map['wrongCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'subTopic': subTopic,
      'successRate': successRate,
      'reason': reason,
      'recommendations': recommendations,
      'priority': priority,
      'wrongCount': wrongCount,
    };
  }
}

/// Bırakma noktası - Öğrenci nerede pes etti?
class AbandonmentPoint {
  final String topic;
  final String subTopic;
  final String screen;          // Hangi ekranda bıraktı?
  final String stage;           // "soru_cozum", "benzer_soru", "analiz"
  final DateTime timestamp;
  final int questionIndex;      // Kaçıncı soruda bıraktı?

  AbandonmentPoint({
    required this.topic,
    required this.subTopic,
    required this.screen,
    required this.stage,
    required this.timestamp,
    this.questionIndex = 0,
  });

  factory AbandonmentPoint.fromMap(Map<String, dynamic> map) {
    return AbandonmentPoint(
      topic: map['topic'] ?? '',
      subTopic: map['subTopic'] ?? '',
      screen: map['screen'] ?? '',
      stage: map['stage'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      questionIndex: map['questionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'subTopic': subTopic,
      'screen': screen,
      'stage': stage,
      'timestamp': Timestamp.fromDate(timestamp),
      'questionIndex': questionIndex,
    };
  }
}

/// Çözülemeyen soru - HAZİNE!
class FailedQuestion {
  final String questionId;
  final String topic;
  final String subTopic;
  final String questionText;
  final String? imageUrl;
  final String correctAnswer;
  final String? userAnswer;
  final String failureReason;   // "konu_eksigi", "dikkatsizlik", "zaman", "anlama_sorunu"
  final String difficulty;
  final DateTime timestamp;
  final bool isReviewed;        // Tekrar çözüldü mü?
  final List<String> keyConceptsMissing; // Eksik kavramlar

  FailedQuestion({
    required this.questionId,
    required this.topic,
    required this.subTopic,
    required this.questionText,
    this.imageUrl,
    required this.correctAnswer,
    this.userAnswer,
    required this.failureReason,
    required this.difficulty,
    required this.timestamp,
    this.isReviewed = false,
    this.keyConceptsMissing = const [],
  });

  factory FailedQuestion.fromMap(Map<String, dynamic> map) {
    return FailedQuestion(
      questionId: map['questionId'] ?? '',
      topic: map['topic'] ?? '',
      subTopic: map['subTopic'] ?? '',
      questionText: map['questionText'] ?? '',
      imageUrl: map['imageUrl'],
      correctAnswer: map['correctAnswer'] ?? '',
      userAnswer: map['userAnswer'],
      failureReason: map['failureReason'] ?? 'konu_eksigi',
      difficulty: map['difficulty'] ?? 'medium',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isReviewed: map['isReviewed'] ?? false,
      keyConceptsMissing: List<String>.from(map['keyConceptsMissing'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'topic': topic,
      'subTopic': subTopic,
      'questionText': questionText,
      'imageUrl': imageUrl,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'failureReason': failureReason,
      'difficulty': difficulty,
      'timestamp': Timestamp.fromDate(timestamp),
      'isReviewed': isReviewed,
      'keyConceptsMissing': keyConceptsMissing,
    };
  }
}

/// 📊 Deneme sınavı kaydı
class MockExamEntry {
  final int netScore;
  final String? examType; // "TYT", "AYT Sayısal" vs.
  final DateTime date;
  final String? note; // Opsiyonel not

  MockExamEntry({
    required this.netScore,
    this.examType,
    required this.date,
    this.note,
  });

  factory MockExamEntry.fromMap(Map<String, dynamic> map) {
    return MockExamEntry(
      netScore: map['netScore'] ?? 0,
      examType: map['examType'],
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'netScore': netScore,
      'examType': examType,
      'date': Timestamp.fromDate(date),
      'note': note,
    };
  }
}

/// Hata nedenleri enum
class FailureReasons {
  static const String topicGap = 'konu_eksigi';
  static const String carelessness = 'dikkatsizlik';
  static const String timeIssue = 'zaman_yetersiz';
  static const String comprehension = 'anlama_sorunu';
  static const String calculation = 'hesaplama_hatasi';
  static const String conceptMissing = 'kavram_eksik';
  
  static String getLabel(String reason) {
    switch (reason) {
      case topicGap: return 'Konu Eksiği';
      case carelessness: return 'Dikkatsizlik';
      case timeIssue: return 'Zaman Yetersizliği';
      case comprehension: return 'Anlama Sorunu';
      case calculation: return 'Hesaplama Hatası';
      case conceptMissing: return 'Kavram Eksikliği';
      default: return 'Bilinmiyor';
    }
  }
}
