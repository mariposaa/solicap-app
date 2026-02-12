/// SOLICAP - Dil Öğrenme Modeli
/// CEFR bazlı İngilizce öğrenme veri yapıları

import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════════════
// CEFR SEVİYELERİ
// ═══════════════════════════════════════════════════════════════

enum LanguageLevel {
  a1('A1', 'Başlangıç', 0),
  a2('A2', 'Temel', 1),
  b1('B1', 'Orta', 2),
  b2('B2', 'Orta Üstü', 3),
  c1('C1', 'İleri', 4);

  final String code;
  final String label;
  final int levelIndex;
  const LanguageLevel(this.code, this.label, this.levelIndex);

  static LanguageLevel fromCode(String code) {
    return LanguageLevel.values.firstWhere(
      (l) => l.code == code,
      orElse: () => LanguageLevel.a1,
    );
  }

  LanguageLevel? get next {
    final i = LanguageLevel.values.indexOf(this);
    if (i < LanguageLevel.values.length - 1) return LanguageLevel.values[i + 1];
    return null;
  }
}

// ═══════════════════════════════════════════════════════════════
// DERS TÜRLERİ
// ═══════════════════════════════════════════════════════════════

enum LessonType {
  grammar('Grammar', 'Dilbilgisi', '📝', 20),
  vocabulary('Vocabulary', 'Kelime', '📖', 20),
  reading('Reading', 'Okuma', '📰', 20),
  listening('Listening', 'Dinleme', '🎧', 20),
  speaking('Speaking', 'Konuşma', '🗣️', 20),
  mixedQuiz('Mixed Quiz', 'Karma Quiz', '🎯', 30),
  unitExam('Unit Exam', 'Ünite Sınavı', '🏆', 50);

  final String name;
  final String label;
  final String emoji;
  final int baseXP;
  const LessonType(this.name, this.label, this.emoji, this.baseXP);
}

// ═══════════════════════════════════════════════════════════════
// ÜNİTE MODELİ
// ═══════════════════════════════════════════════════════════════

class LanguageUnit {
  final String id;
  final LanguageLevel level;
  final int order; // 1-6
  final String title;
  final String titleTr;
  final String icon;
  final List<LessonType> lessonOrder;

  const LanguageUnit({
    required this.id,
    required this.level,
    required this.order,
    required this.title,
    required this.titleTr,
    required this.icon,
    this.lessonOrder = const [
      LessonType.grammar,
      LessonType.vocabulary,
      LessonType.reading,
      LessonType.listening,
      LessonType.speaking,
      LessonType.mixedQuiz,
      LessonType.unitExam,
    ],
  });
}

// ═══════════════════════════════════════════════════════════════
// GRAMMAR İSKELET İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class GrammarContent {
  final String topic;
  final String topicTr;
  final String rule;
  final String ruleTr;
  final List<String> examples;
  final List<GrammarQuiz> quizzes;

  const GrammarContent({
    required this.topic,
    required this.topicTr,
    required this.rule,
    required this.ruleTr,
    required this.examples,
    required this.quizzes,
  });
}

class GrammarQuiz {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const GrammarQuiz({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// ═══════════════════════════════════════════════════════════════
// VOCABULARY İSKELET İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class VocabWord {
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;
  final String category;
  final String? pronunciation;

  const VocabWord({
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.category,
    this.pronunciation,
  });
}

// ═══════════════════════════════════════════════════════════════
// READING İSKELET İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class ReadingContent {
  final String topic;
  final String topicTr;
  final List<String> keywords;
  final String? passage; // AI üretecek veya hazır
  final List<ReadingQuestion> questions;

  const ReadingContent({
    required this.topic,
    required this.topicTr,
    required this.keywords,
    this.passage,
    required this.questions,
  });
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// ═══════════════════════════════════════════════════════════════
// SPEAKING İSKELET İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class SpeakingContent {
  final String scenario;
  final String scenarioTr;
  final List<DialogueTurn> dialogue;

  const SpeakingContent({
    required this.scenario,
    required this.scenarioTr,
    required this.dialogue,
  });
}

class DialogueTurn {
  final String speaker; // 'bot' veya 'user'
  final String text;
  final String? hint; // user turn için ipucu

  const DialogueTurn({
    required this.speaker,
    required this.text,
    this.hint,
  });
}

// ═══════════════════════════════════════════════════════════════
// LISTENING İSKELET İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class ListeningContent {
  final String topic;
  final String topicTr;
  final List<ListeningExercise> exercises;

  const ListeningContent({
    required this.topic,
    required this.topicTr,
    required this.exercises,
  });
}

class ListeningExercise {
  final String sentence;
  final String translation;
  final String missingWord;
  final List<String> options;
  final int correctIndex;

  const ListeningExercise({
    required this.sentence,
    required this.translation,
    required this.missingWord,
    required this.options,
    required this.correctIndex,
  });
}

// ═══════════════════════════════════════════════════════════════
// MIXED QUIZ & UNIT EXAM İÇERİĞİ
// ═══════════════════════════════════════════════════════════════

class MixedQuizQuestion {
  final LessonType sourceType;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const MixedQuizQuestion({
    required this.sourceType,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}

// ═══════════════════════════════════════════════════════════════
// UNITE İÇERİK PAKETİ
// ═══════════════════════════════════════════════════════════════

class UnitContent {
  final String unitId;
  final GrammarContent grammar;
  final List<VocabWord> vocabulary;
  final ReadingContent reading;
  final ListeningContent listening;
  final SpeakingContent speaking;
  final List<MixedQuizQuestion> mixedQuiz;
  final List<MixedQuizQuestion> unitExam;

  const UnitContent({
    required this.unitId,
    required this.grammar,
    required this.vocabulary,
    required this.reading,
    required this.listening,
    required this.speaking,
    required this.mixedQuiz,
    required this.unitExam,
  });
}

// ═══════════════════════════════════════════════════════════════
// SEVİYE BELİRLEME TESTİ SORUSU
// ═══════════════════════════════════════════════════════════════

class PlacementQuestion {
  final String id;
  final LanguageLevel level;
  final String question;
  final List<String> options;
  final int correctIndex;

  const PlacementQuestion({
    required this.id,
    required this.level,
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// ═══════════════════════════════════════════════════════════════
// KULLANICI İLERLEME MODELİ (Firebase)
// ═══════════════════════════════════════════════════════════════

class LanguageProgress {
  final String userId;
  final LanguageLevel currentLevel;
  final int totalXP;
  final int dailyXP;
  final int dailyGoal; // 30, 50, 100
  final int currentStreak;
  final int bestStreak;
  final DateTime lastActiveDate;
  final bool placementDone;
  final Map<String, UnitProgress> unitProgresses; // unitId -> UnitProgress
  final Map<String, double> skillScores; // grammar, vocabulary, reading, listening, speaking -> 0-100

  LanguageProgress({
    required this.userId,
    this.currentLevel = LanguageLevel.a1,
    this.totalXP = 0,
    this.dailyXP = 0,
    this.dailyGoal = 50,
    this.currentStreak = 0,
    this.bestStreak = 0,
    DateTime? lastActiveDate,
    this.placementDone = false,
    this.unitProgresses = const {},
    this.skillScores = const {},
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  // XP ile seviye atlama eşikleri
  static const Map<LanguageLevel, int> levelUpXP = {
    LanguageLevel.a1: 600,   // 6 ünite x ~100 XP
    LanguageLevel.a2: 600,
    LanguageLevel.b1: 600,
    LanguageLevel.b2: 600,
    LanguageLevel.c1: 600,
  };

  int get xpForCurrentLevel {
    int consumed = 0;
    for (final l in LanguageLevel.values) {
      if (l == currentLevel) break;
      consumed += levelUpXP[l] ?? 600;
    }
    return totalXP - consumed;
  }

  int get xpNeededForLevelUp => levelUpXP[currentLevel] ?? 600;

  double get levelProgress {
    final needed = xpNeededForLevelUp;
    if (needed == 0) return 1.0;
    return (xpForCurrentLevel / needed).clamp(0.0, 1.0);
  }

  bool get shouldLevelUp => xpForCurrentLevel >= xpNeededForLevelUp;

  LanguageProgress copyWith({
    LanguageLevel? currentLevel,
    int? totalXP,
    int? dailyXP,
    int? dailyGoal,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
    bool? placementDone,
    Map<String, UnitProgress>? unitProgresses,
    Map<String, double>? skillScores,
  }) {
    return LanguageProgress(
      userId: userId,
      currentLevel: currentLevel ?? this.currentLevel,
      totalXP: totalXP ?? this.totalXP,
      dailyXP: dailyXP ?? this.dailyXP,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      placementDone: placementDone ?? this.placementDone,
      unitProgresses: unitProgresses ?? this.unitProgresses,
      skillScores: skillScores ?? this.skillScores,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'currentLevel': currentLevel.code,
    'totalXP': totalXP,
    'dailyXP': dailyXP,
    'dailyGoal': dailyGoal,
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'lastActiveDate': Timestamp.fromDate(lastActiveDate),
    'placementDone': placementDone,
    'unitProgresses': unitProgresses.map((k, v) => MapEntry(k, v.toFirestore())),
    'skillScores': skillScores,
  };

  factory LanguageProgress.fromFirestore(Map<String, dynamic> data) {
    final unitMap = <String, UnitProgress>{};
    final rawUnits = data['unitProgresses'] as Map<String, dynamic>? ?? {};
    rawUnits.forEach((key, value) {
      unitMap[key] = UnitProgress.fromFirestore(value as Map<String, dynamic>);
    });

    final rawSkills = data['skillScores'] as Map<String, dynamic>? ?? {};
    final skillMap = rawSkills.map((k, v) => MapEntry(k, (v as num).toDouble()));

    return LanguageProgress(
      userId: data['userId'] ?? '',
      currentLevel: LanguageLevel.fromCode(data['currentLevel'] ?? 'A1'),
      totalXP: data['totalXP'] ?? 0,
      dailyXP: data['dailyXP'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? 50,
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
      lastActiveDate: data['lastActiveDate'] is Timestamp
          ? (data['lastActiveDate'] as Timestamp).toDate()
          : DateTime.now(),
      placementDone: data['placementDone'] ?? false,
      unitProgresses: unitMap,
      skillScores: skillMap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ÜNİTE İLERLEME MODELİ
// ═══════════════════════════════════════════════════════════════

class UnitProgress {
  final Map<String, bool> lessonsCompleted; // lessonType.name -> bool
  final double? examScore;
  final bool isCompleted;
  final DateTime? unlockedAt;

  const UnitProgress({
    this.lessonsCompleted = const {},
    this.examScore,
    this.isCompleted = false,
    this.unlockedAt,
  });

  bool isLessonCompleted(LessonType type) =>
      lessonsCompleted[type.name] ?? false;

  int get completedCount => lessonsCompleted.values.where((v) => v).length;
  int get totalLessons => 7; // 5 skill + mixed + exam

  double get progressPercent =>
      totalLessons > 0 ? completedCount / totalLessons : 0;

  UnitProgress copyWith({
    Map<String, bool>? lessonsCompleted,
    double? examScore,
    bool? isCompleted,
    DateTime? unlockedAt,
  }) {
    return UnitProgress(
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      examScore: examScore ?? this.examScore,
      isCompleted: isCompleted ?? this.isCompleted,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'lessonsCompleted': lessonsCompleted,
    'examScore': examScore,
    'isCompleted': isCompleted,
    'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
  };

  factory UnitProgress.fromFirestore(Map<String, dynamic> data) {
    final rawLessons = data['lessonsCompleted'] as Map<String, dynamic>? ?? {};
    return UnitProgress(
      lessonsCompleted: rawLessons.map((k, v) => MapEntry(k, v as bool)),
      examScore: (data['examScore'] as num?)?.toDouble(),
      isCompleted: data['isCompleted'] ?? false,
      unlockedAt: data['unlockedAt'] is Timestamp
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DERS SONUCU MODELİ
// ═══════════════════════════════════════════════════════════════

class LessonResult {
  final String id;
  final String userId;
  final String unitId;
  final LessonType lessonType;
  final int correctCount;
  final int totalCount;
  final int xpEarned;
  final double score;
  final DateTime completedAt;

  LessonResult({
    required this.id,
    required this.userId,
    required this.unitId,
    required this.lessonType,
    required this.correctCount,
    required this.totalCount,
    required this.xpEarned,
    required this.score,
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
    'completedAt': Timestamp.fromDate(completedAt),
  };
}

// ═══════════════════════════════════════════════════════════════
// VOCAB MASTERY MODELİ (Spaced Repetition)
// ═══════════════════════════════════════════════════════════════

class VocabMastery {
  final String word;
  final int box; // Leitner kutusu 1-6
  final DateTime nextReview;
  final int reviewCount;

  const VocabMastery({
    required this.word,
    this.box = 1,
    required this.nextReview,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toFirestore() => {
    'word': word,
    'box': box,
    'nextReview': Timestamp.fromDate(nextReview),
    'reviewCount': reviewCount,
  };

  factory VocabMastery.fromFirestore(Map<String, dynamic> data) {
    return VocabMastery(
      word: data['word'] ?? '',
      box: data['box'] ?? 1,
      nextReview: data['nextReview'] is Timestamp
          ? (data['nextReview'] as Timestamp).toDate()
          : DateTime.now(),
      reviewCount: data['reviewCount'] ?? 0,
    );
  }
}
