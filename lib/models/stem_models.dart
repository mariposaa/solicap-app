/// SOLICAP - STEM Öğrenme Modeli
/// Matematik, Fen Bilimleri, Fizik, Kimya, Biyoloji veri yapıları

import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════════════
// SINIF SEVİYELERİ
// ═══════════════════════════════════════════════════════════════

enum GradeLevel {
  sinif5('sinif5', '5. Sınıf', 0),
  sinif8_lgs('sinif8_lgs', '8. Sınıf / LGS', 1),
  sinif12('sinif12', '12. Sınıf', 2),
  tyt('tyt', 'TYT', 3),
  ayt('ayt', 'AYT', 4),
  kpssLise('kpsslise', 'KPSS Lise', 5),
  kpssOnlisans('kpssonlisans', 'KPSS Önlisans', 6),
  kpssLisans('kpsslisans', 'KPSS Lisans', 7);

  final String code;
  final String label;
  final int gradeIndex;
  const GradeLevel(this.code, this.label, this.gradeIndex);

  static GradeLevel fromCode(String code) {
    return GradeLevel.values.firstWhere(
      (g) => g.code == code,
      orElse: () => GradeLevel.sinif5,
    );
  }

  /// Bu seviyede hangi dersler var
  List<StemSubject> get availableSubjects {
    switch (this) {
      case GradeLevel.sinif5:
      case GradeLevel.sinif8_lgs:
        return [StemSubject.matematik, StemSubject.fenBilimleri];
      case GradeLevel.sinif12:
        return [StemSubject.matematik, StemSubject.fizik, StemSubject.kimya];
      case GradeLevel.tyt:
        return [StemSubject.matematik, StemSubject.fizik, StemSubject.kimya, StemSubject.biyoloji];
      case GradeLevel.ayt:
        return [StemSubject.matematik, StemSubject.fizik, StemSubject.kimya];
      case GradeLevel.kpssLise:
      case GradeLevel.kpssOnlisans:
      case GradeLevel.kpssLisans:
        return [StemSubject.turkce, StemSubject.matematik, StemSubject.tarih, StemSubject.cografyaVatandaslik];
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// DERS ALANLARI
// ═══════════════════════════════════════════════════════════════

enum StemSubject {
  matematik('matematik', 'Matematik', '📐'),
  fenBilimleri('fen_bilimleri', 'Fen Bilimleri', '🔬'),
  fizik('fizik', 'Fizik', '⚛️'),
  kimya('kimya', 'Kimya', '🧪'),
  biyoloji('biyoloji', 'Biyoloji', '🧬'),
  turkce('turkce', 'Türkçe', '📝'),
  tarih('tarih', 'Tarih', '🏛️'),
  cografyaVatandaslik('cografya_vatandaslik', 'Coğrafya & Vatandaşlık', '🗺️');

  final String code;
  final String label;
  final String emoji;
  const StemSubject(this.code, this.label, this.emoji);

  static StemSubject fromCode(String code) {
    return StemSubject.values.firstWhere(
      (s) => s.code == code,
      orElse: () => StemSubject.matematik,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DERS TÜRLERİ (5 Aşamalı Akış)
// ═══════════════════════════════════════════════════════════════

enum StemLessonType {
  topicExplanation('Konu Anlatımı', '📖', 15),
  solvedExamples('Çözümlü Örnekler', '✍️', 15),
  practice('Pratik Sorular', '🎯', 25),
  speedTest('Hız Testi', '⚡', 30),
  topicExam('Konu Sınavı', '🏆', 40);

  final String label;
  final String emoji;
  final int baseXP;
  const StemLessonType(this.label, this.emoji, this.baseXP);
}

// ═══════════════════════════════════════════════════════════════
// ÜNİTE MODELİ
// ═══════════════════════════════════════════════════════════════

class StemUnit {
  final String id; // Örn: 's5_mat_u1'
  final GradeLevel gradeLevel;
  final StemSubject subject;
  final int order; // 1-6
  final String title;
  final String titleTr;
  final String icon;
  final List<StemLessonType> lessonOrder;

  const StemUnit({
    required this.id,
    required this.gradeLevel,
    required this.subject,
    required this.order,
    required this.title,
    required this.titleTr,
    required this.icon,
    this.lessonOrder = const [
      StemLessonType.topicExplanation,
      StemLessonType.solvedExamples,
      StemLessonType.practice,
      StemLessonType.speedTest,
      StemLessonType.topicExam,
    ],
  });
}

// ═══════════════════════════════════════════════════════════════
// KONU ANLATIMI İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class TopicContent {
  final String summary;       // Konu özeti
  final String rule;          // Temel kural / formül
  final List<String> formulas; // Formül listesi (metin olarak)
  final List<String> keyPoints; // Anahtar noktalar

  const TopicContent({
    required this.summary,
    required this.rule,
    this.formulas = const [],
    this.keyPoints = const [],
  });
}

// ═══════════════════════════════════════════════════════════════
// ÇÖZÜMLÜ ÖRNEK
// ═══════════════════════════════════════════════════════════════

class SolvedExample {
  final String question;
  final List<String> steps; // Adım adım çözüm
  final String answer;

  const SolvedExample({
    required this.question,
    required this.steps,
    required this.answer,
  });
}

// ═══════════════════════════════════════════════════════════════
// STEM SORUSU (Pratik, Hız Testi, Sınav)
// ═══════════════════════════════════════════════════════════════

class StemQuestion {
  final String question;
  final List<String> options; // 4 seçenek (A, B, C, D)
  final int correctIndex;    // 0-3
  final String? explanation; // Çözüm açıklaması (opsiyonel)
  final int difficulty;      // 1: kolay, 2: orta, 3: zor

  const StemQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.difficulty = 2,
  });
}

// ═══════════════════════════════════════════════════════════════
// ÜNİTE İÇERİK PAKETİ
// ═══════════════════════════════════════════════════════════════

class StemUnitContent {
  final String unitId;
  final TopicContent topic;               // Konu anlatımı
  final List<SolvedExample> solvedExamples; // 3-5 çözümlü örnek
  final List<StemQuestion> practiceQuestions; // 10 pratik soru
  final List<StemQuestion> speedTestQuestions; // 5 hız testi sorusu
  final List<StemQuestion> examQuestions;     // 15 sınav sorusu
  final List<String> formulaCards;           // Formül kartları (spaced repetition)

  const StemUnitContent({
    required this.unitId,
    required this.topic,
    required this.solvedExamples,
    required this.practiceQuestions,
    this.speedTestQuestions = const [],
    required this.examQuestions,
    this.formulaCards = const [],
  });
}

// ═══════════════════════════════════════════════════════════════
// KULLANICI İLERLEME MODELİ (Firebase)
// ═══════════════════════════════════════════════════════════════

class StemProgress {
  final String userId;
  final GradeLevel gradeLevel;
  final StemSubject subject;
  final int totalXP;
  final int dailyXP;
  final int dailyGoal;
  final int currentStreak;
  final int bestStreak;
  final DateTime lastActiveDate;
  final Map<String, StemUnitProgress> unitProgresses; // unitId -> progress

  StemProgress({
    required this.userId,
    required this.gradeLevel,
    required this.subject,
    this.totalXP = 0,
    this.dailyXP = 0,
    this.dailyGoal = 50,
    this.currentStreak = 0,
    this.bestStreak = 0,
    DateTime? lastActiveDate,
    this.unitProgresses = const {},
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  // XP ile seviye ilerleme (her seviyede 6 ünite x ~125 XP = ~750 XP)
  static const int xpPerLevel = 750;

  int get completedUnitCount =>
      unitProgresses.values.where((u) => u.isCompleted).length;

  double get overallProgress {
    if (unitProgresses.isEmpty) return 0;
    final total = unitProgresses.values.fold<double>(
      0, (prev, u) => prev + u.progressPercent,
    );
    return total / unitProgresses.length;
  }

  StemProgress copyWith({
    int? totalXP,
    int? dailyXP,
    int? dailyGoal,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
    Map<String, StemUnitProgress>? unitProgresses,
  }) {
    return StemProgress(
      userId: userId,
      gradeLevel: gradeLevel,
      subject: subject,
      totalXP: totalXP ?? this.totalXP,
      dailyXP: dailyXP ?? this.dailyXP,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unitProgresses: unitProgresses ?? this.unitProgresses,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'gradeLevel': gradeLevel.code,
    'subject': subject.code,
    'totalXP': totalXP,
    'dailyXP': dailyXP,
    'dailyGoal': dailyGoal,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'lastActiveDate': Timestamp.fromDate(lastActiveDate),
    'unitProgresses': unitProgresses.map((k, v) => MapEntry(k, v.toFirestore())),
  };

  factory StemProgress.fromFirestore(Map<String, dynamic> data) {
    final unitMap = <String, StemUnitProgress>{};
    final rawUnits = data['unitProgresses'] as Map<String, dynamic>? ?? {};
    rawUnits.forEach((key, value) {
      unitMap[key] = StemUnitProgress.fromFirestore(value as Map<String, dynamic>);
    });

    return StemProgress(
      userId: data['userId'] ?? '',
      gradeLevel: GradeLevel.fromCode(data['gradeLevel'] ?? 'sinif5'),
      subject: StemSubject.fromCode(data['subject'] ?? 'matematik'),
      totalXP: data['totalXP'] ?? 0,
      dailyXP: data['dailyXP'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? 50,
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
      lastActiveDate: data['lastActiveDate'] is Timestamp
          ? (data['lastActiveDate'] as Timestamp).toDate()
          : DateTime.now(),
      unitProgresses: unitMap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ÜNİTE İLERLEME MODELİ
// ═══════════════════════════════════════════════════════════════

class StemUnitProgress {
  final Map<String, bool> lessonsCompleted; // lessonType.name -> bool
  final double? examScore;
  final double? bestExamScore;
  final bool isCompleted;
  final int attempts;
  final DateTime? unlockedAt;
  final int totalLessons; // 5 for standard, 3 for TYT/AYT

  const StemUnitProgress({
    this.lessonsCompleted = const {},
    this.examScore,
    this.bestExamScore,
    this.isCompleted = false,
    this.attempts = 0,
    this.unlockedAt,
    this.totalLessons = 5,
  });

  bool isLessonCompleted(StemLessonType type) =>
      lessonsCompleted[type.name] ?? false;

  int get completedCount => lessonsCompleted.values.where((v) => v).length;

  double get progressPercent =>
      totalLessons > 0 ? completedCount / totalLessons : 0;

  StemUnitProgress copyWith({
    Map<String, bool>? lessonsCompleted,
    double? examScore,
    double? bestExamScore,
    bool? isCompleted,
    int? attempts,
    DateTime? unlockedAt,
    int? totalLessons,
  }) {
    return StemUnitProgress(
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      examScore: examScore ?? this.examScore,
      bestExamScore: bestExamScore ?? this.bestExamScore,
      isCompleted: isCompleted ?? this.isCompleted,
      attempts: attempts ?? this.attempts,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      totalLessons: totalLessons ?? this.totalLessons,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'lessonsCompleted': lessonsCompleted,
    'examScore': examScore,
    'bestExamScore': bestExamScore,
    'isCompleted': isCompleted,
    'attempts': attempts,
    'totalLessons': totalLessons,
    'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
  };

  factory StemUnitProgress.fromFirestore(Map<String, dynamic> data) {
    final rawLessons = data['lessonsCompleted'] as Map<String, dynamic>? ?? {};
    return StemUnitProgress(
      lessonsCompleted: rawLessons.map((k, v) => MapEntry(k, v as bool)),
      examScore: (data['examScore'] as num?)?.toDouble(),
      bestExamScore: (data['bestExamScore'] as num?)?.toDouble(),
      isCompleted: data['isCompleted'] ?? false,
      attempts: data['attempts'] ?? 0,
      totalLessons: data['totalLessons'] ?? 5,
      unlockedAt: data['unlockedAt'] is Timestamp
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DERS SONUCU MODELİ
// ═══════════════════════════════════════════════════════════════

class StemLessonResult {
  final String id;
  final String userId;
  final String unitId;
  final StemLessonType lessonType;
  final int correctCount;
  final int totalCount;
  final int xpEarned;
  final double score;
  final int? timeSpentSeconds; // Hız testi için
  final DateTime completedAt;

  StemLessonResult({
    required this.id,
    required this.userId,
    required this.unitId,
    required this.lessonType,
    required this.correctCount,
    required this.totalCount,
    required this.xpEarned,
    required this.score,
    this.timeSpentSeconds,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'unitId': unitId,
    'lessonType': lessonType.name,
    'correctCount': correctCount,
    'totalCount': totalCount,
    'xpEarned': xpEarned,
    'score': score,
    'timeSpentSeconds': timeSpentSeconds,
    'completedAt': Timestamp.fromDate(completedAt),
  };
}
