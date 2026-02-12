/// SOLICAP - YDS Modelleri
/// Faz yapısı, soru modeli, test sonucu ve konu kartı modelleri

import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════════════
// FAZ TANIMLARI
// ═══════════════════════════════════════════════════════════════

/// YDS Faz bilgisi
class YdsFaz {
  final int fazNumber; // 1, 2, 3
  final String title;
  final String description;
  final List<String> topics;

  const YdsFaz({
    required this.fazNumber,
    required this.title,
    required this.description,
    required this.topics,
  });

  static const List<YdsFaz> allFazlar = [
    YdsFaz(
      fazNumber: 1,
      title: 'Temel Yapı ve Gramer',
      description: 'Foundation - YDS\'nin temel gramer soruları',
      topics: [
        'Zamanlar ve Modallar',
        'Bağlaçlar',
        'Edatlar ve Kelime Bilgisi',
        'Dilbilgisi Bütünlüğü',
      ],
    ),
    YdsFaz(
      fazNumber: 2,
      title: 'Cümle Analizi ve Teknik',
      description: 'Sentence Mechanics - Gramer kurallarını cümle içinde kullanma',
      topics: [
        'Cloze Test',
        'Cümle Tamamlama',
        'Çeviri',
      ],
    ),
    YdsFaz(
      fazNumber: 3,
      title: 'Okuma ve Mantık',
      description: 'Reading & Logic - Analiz yeteneği gerektiren sorular',
      topics: [
        'Paragraf Soruları',
        'Diyalog ve Yakın Anlam',
        'Anlam Bütünlüğü',
      ],
    ),
  ];

  static YdsFaz getFaz(int number) {
    return allFazlar.firstWhere((f) => f.fazNumber == number);
  }
}

// ═══════════════════════════════════════════════════════════════
// SORU MODELİ
// ═══════════════════════════════════════════════════════════════

/// YDS sorusu (5 şıklı)
class YdsQuestion {
  final String id;
  final int fazNumber;
  final String topic; // Hangi konu (Bağlaçlar, Zamanlar vb.)
  final String difficulty; // 'orta' | 'zor'
  final String questionText; // Soru metni
  final String? passage; // Varsa okuma parçası
  final List<String> options; // 5 şık (A-E)
  final int correctAnswer; // 0-4 (index)
  final String explanation; // Doğru cevap açıklaması

  const YdsQuestion({
    required this.id,
    required this.fazNumber,
    required this.topic,
    required this.difficulty,
    required this.questionText,
    this.passage,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory YdsQuestion.fromJson(Map<String, dynamic> json) {
    return YdsQuestion(
      id: json['id'] ?? '',
      fazNumber: json['fazNumber'] ?? 1,
      topic: json['topic'] ?? '',
      difficulty: json['difficulty'] ?? 'orta',
      questionText: json['questionText'] ?? '',
      passage: json['passage'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fazNumber': fazNumber,
    'topic': topic,
    'difficulty': difficulty,
    'questionText': questionText,
    'passage': passage,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
  };
}

// ═══════════════════════════════════════════════════════════════
// TEST SONUCU MODELİ
// ═══════════════════════════════════════════════════════════════

/// Tek bir sorunun cevap kaydı
class YdsAnswer {
  final String questionId;
  final String topic;
  final int selectedAnswer; // 0-4
  final int correctAnswer; // 0-4
  final bool isCorrect;

  const YdsAnswer({
    required this.questionId,
    required this.topic,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'topic': topic,
    'selectedAnswer': selectedAnswer,
    'correctAnswer': correctAnswer,
    'isCorrect': isCorrect,
  };

  factory YdsAnswer.fromJson(Map<String, dynamic> json) {
    return YdsAnswer(
      questionId: json['questionId'] ?? '',
      topic: json['topic'] ?? '',
      selectedAnswer: json['selectedAnswer'] ?? 0,
      correctAnswer: json['correctAnswer'] ?? 0,
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}

/// Test sonucu (15 sorunun tamamı)
class YdsTestResult {
  final String id;
  final String userId;
  final int fazNumber;
  final String testType; // 'baslangic' | 'bitirme'
  final List<YdsAnswer> answers;
  final int totalCorrect;
  final int totalWrong;
  final double score; // 0-100
  final List<String> wrongTopics; // Yanlış yapılan konular (unique)
  final DateTime completedAt;

  YdsTestResult({
    required this.id,
    required this.userId,
    required this.fazNumber,
    required this.testType,
    required this.answers,
    required this.totalCorrect,
    required this.totalWrong,
    required this.score,
    required this.wrongTopics,
    required this.completedAt,
  });

  factory YdsTestResult.fromAnswers({
    required String userId,
    required int fazNumber,
    required String testType,
    required List<YdsAnswer> answers,
  }) {
    final correct = answers.where((a) => a.isCorrect).length;
    final wrong = answers.where((a) => !a.isCorrect).length;
    final wrongTopicSet = answers
        .where((a) => !a.isCorrect)
        .map((a) => a.topic)
        .toSet()
        .toList();

    return YdsTestResult(
      id: '${fazNumber}_${testType}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      fazNumber: fazNumber,
      testType: testType,
      answers: answers,
      totalCorrect: correct,
      totalWrong: wrong,
      score: answers.isNotEmpty ? (correct / answers.length) * 100 : 0,
      wrongTopics: wrongTopicSet,
      completedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'fazNumber': fazNumber,
    'testType': testType,
    'answers': answers.map((a) => a.toJson()).toList(),
    'totalCorrect': totalCorrect,
    'totalWrong': totalWrong,
    'score': score,
    'wrongTopics': wrongTopics,
    'completedAt': Timestamp.fromDate(completedAt),
  };

  factory YdsTestResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return YdsTestResult.fromMap(data, id: doc.id);
  }

  /// Nested map'ten oluştur (Progress içinde gömülü veri için)
  factory YdsTestResult.fromMap(Map<String, dynamic> data, {String? id}) {
    return YdsTestResult(
      id: id ?? data['id'] ?? '',
      userId: data['userId'] ?? '',
      fazNumber: data['fazNumber'] ?? 1,
      testType: data['testType'] ?? 'baslangic',
      answers: (data['answers'] as List<dynamic>? ?? [])
          .map((a) => YdsAnswer.fromJson(a as Map<String, dynamic>))
          .toList(),
      totalCorrect: data['totalCorrect'] ?? 0,
      totalWrong: data['totalWrong'] ?? 0,
      score: (data['score'] ?? 0).toDouble(),
      wrongTopics: List<String>.from(data['wrongTopics'] ?? []),
      completedAt: data['completedAt'] is Timestamp
          ? (data['completedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// KONU KARTI MODELİ (AI tarafından üretilen eğitim kartı)
// ═══════════════════════════════════════════════════════════════

/// AI tarafından üretilen konu anlatım kartı
class YdsTopicCard {
  final String topic;
  final String explanation; // AI tarafından üretilen kısa anlatım
  final bool isCompleted; // Kullanıcı "Öğrendim" dedi mi?

  const YdsTopicCard({
    required this.topic,
    required this.explanation,
    this.isCompleted = false,
  });

  YdsTopicCard copyWith({bool? isCompleted}) {
    return YdsTopicCard(
      topic: topic,
      explanation: explanation,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// KULLANICI İLERLEME MODELİ (Firebase'e kaydedilir)
// ═══════════════════════════════════════════════════════════════

/// Kullanıcının YDS modülündeki genel ilerlemesi
class YdsProgress {
  final String userId;
  final int currentFaz; // 1, 2, 3
  final String currentStage; // 'baslangic_test' | 'baslangic_analiz' | 'bitirme_test' | 'bitirme_analiz' | 'completed'
  final Map<int, YdsFazProgress> fazProgresses; // {1: FazProgress, 2: ..., 3: ...}

  YdsProgress({
    required this.userId,
    this.currentFaz = 1,
    this.currentStage = 'baslangic_test',
    this.fazProgresses = const {},
  });

  /// Aktif faz tamamlandı mı?
  bool isFazCompleted(int fazNumber) {
    return fazProgresses[fazNumber]?.isCompleted ?? false;
  }

  /// Test Analiz sekmesi açık mı?
  bool get isAnalysisUnlocked {
    // Stage baslangic_test ise henüz test çözülmedi = kilitli
    // Diğer tüm durumlarda en az bir test çözülmüş demektir
    return currentStage != 'baslangic_test';
  }

  /// Sonraki aşamaya geçir
  YdsProgress advanceStage() {
    switch (currentStage) {
      case 'baslangic_test':
        return _copyWith(currentStage: 'baslangic_analiz');
      case 'baslangic_analiz':
        return _copyWith(currentStage: 'bitirme_test');
      case 'bitirme_test':
        return _copyWith(currentStage: 'bitirme_analiz');
      case 'bitirme_analiz':
        if (currentFaz < 3) {
          return _copyWith(
            currentFaz: currentFaz + 1,
            currentStage: 'baslangic_test',
          );
        }
        return _copyWith(currentStage: 'completed');
      default:
        return this;
    }
  }

  YdsProgress _copyWith({int? currentFaz, String? currentStage, Map<int, YdsFazProgress>? fazProgresses}) {
    return YdsProgress(
      userId: userId,
      currentFaz: currentFaz ?? this.currentFaz,
      currentStage: currentStage ?? this.currentStage,
      fazProgresses: fazProgresses ?? this.fazProgresses,
    );
  }

  YdsProgress updateFazProgress(int fazNumber, YdsFazProgress progress) {
    final newMap = Map<int, YdsFazProgress>.from(fazProgresses);
    newMap[fazNumber] = progress;
    return _copyWith(fazProgresses: newMap);
  }

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'currentFaz': currentFaz,
    'currentStage': currentStage,
    'fazProgresses': fazProgresses.map(
      (k, v) => MapEntry(k.toString(), v.toFirestore()),
    ),
  };

  factory YdsProgress.fromFirestore(Map<String, dynamic> data) {
    final fazMap = <int, YdsFazProgress>{};
    final rawFaz = data['fazProgresses'] as Map<String, dynamic>? ?? {};
    rawFaz.forEach((key, value) {
      fazMap[int.parse(key)] = YdsFazProgress.fromFirestore(value as Map<String, dynamic>);
    });

    return YdsProgress(
      userId: data['userId'] ?? '',
      currentFaz: data['currentFaz'] ?? 1,
      currentStage: data['currentStage'] ?? 'baslangic_test',
      fazProgresses: fazMap,
    );
  }
}

/// Tek bir fazın ilerleme bilgisi
class YdsFazProgress {
  final YdsTestResult? baslangicTestResult;
  final YdsTestResult? bitirmeTestResult;
  final bool baslangicCardsCompleted; // Başlangıç test analiz kartları bitti mi?
  final bool bitirmeCardsCompleted; // Bitirme test analiz kartları bitti mi?
  final bool isCompleted; // Faz tamamen bitti mi?

  const YdsFazProgress({
    this.baslangicTestResult,
    this.bitirmeTestResult,
    this.baslangicCardsCompleted = false,
    this.bitirmeCardsCompleted = false,
    this.isCompleted = false,
  });

  YdsFazProgress copyWith({
    YdsTestResult? baslangicTestResult,
    YdsTestResult? bitirmeTestResult,
    bool? baslangicCardsCompleted,
    bool? bitirmeCardsCompleted,
    bool? isCompleted,
  }) {
    return YdsFazProgress(
      baslangicTestResult: baslangicTestResult ?? this.baslangicTestResult,
      bitirmeTestResult: bitirmeTestResult ?? this.bitirmeTestResult,
      baslangicCardsCompleted: baslangicCardsCompleted ?? this.baslangicCardsCompleted,
      bitirmeCardsCompleted: bitirmeCardsCompleted ?? this.bitirmeCardsCompleted,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'baslangicTestResult': baslangicTestResult?.toFirestore(),
    'bitirmeTestResult': bitirmeTestResult?.toFirestore(),
    'baslangicCardsCompleted': baslangicCardsCompleted,
    'bitirmeCardsCompleted': bitirmeCardsCompleted,
    'isCompleted': isCompleted,
  };

  factory YdsFazProgress.fromFirestore(Map<String, dynamic> data) {
    return YdsFazProgress(
      baslangicTestResult: data['baslangicTestResult'] != null
          ? YdsTestResult.fromMap(data['baslangicTestResult'] as Map<String, dynamic>)
          : null,
      bitirmeTestResult: data['bitirmeTestResult'] != null
          ? YdsTestResult.fromMap(data['bitirmeTestResult'] as Map<String, dynamic>)
          : null,
      baslangicCardsCompleted: data['baslangicCardsCompleted'] ?? false,
      bitirmeCardsCompleted: data['bitirmeCardsCompleted'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}
