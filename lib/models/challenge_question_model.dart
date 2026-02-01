/// SOLICAP - Challenge Question Model
/// Yarışma soruları için veri modeli

import 'package:cloud_firestore/cloud_firestore.dart';

/// Çoktan seçmeli soru modeli
class ChallengeQuestion {
  final String id;
  final String category;      // matematik, fen, genel_kultur, turkce, tarih, etc.
  final String difficulty;    // ilkokul, ortaokul, lise
  final String questionText;  // Soru metni
  final List<String> options; // 4 şık (A, B, C, D)
  final int correctIndex;     // Doğru cevabın indexi (0-3)
  final int timeLimitSec;     // Soru başına süre (default 15)
  final String? explanation;  // Opsiyonel açıklama
  final String? imageUrl;     // Opsiyonel görsel
  final bool isActive;        // Aktif mi?
  final DateTime createdAt;

  ChallengeQuestion({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.timeLimitSec = 15,
    this.explanation,
    this.imageUrl,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChallengeQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChallengeQuestion(
      id: doc.id,
      category: data['category'] ?? 'genel_kultur',
      difficulty: data['difficulty'] ?? 'ortaokul',
      questionText: data['questionText'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctIndex: data['correctIndex'] ?? 0,
      timeLimitSec: data['timeLimitSec'] ?? 15,
      explanation: data['explanation'],
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ChallengeQuestion.fromJson(Map<String, dynamic> json, {String? id}) {
    return ChallengeQuestion(
      id: id ?? json['id'] ?? '',
      category: json['category'] ?? 'genel_kultur',
      difficulty: json['difficulty'] ?? 'ortaokul',
      questionText: json['questionText'] ?? json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? json['correct'] ?? 0,
      timeLimitSec: json['timeLimitSec'] ?? json['timeLimit'] ?? 15,
      explanation: json['explanation'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'questionText': questionText,
      'options': options,
      'correctIndex': correctIndex,
      'timeLimitSec': timeLimitSec,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Doğru cevap metni
  String get correctAnswer => options.isNotEmpty && correctIndex < options.length 
      ? options[correctIndex] 
      : '';

  /// Şık harfi (A, B, C, D)
  String getOptionLetter(int index) {
    const letters = ['A', 'B', 'C', 'D'];
    return index < letters.length ? letters[index] : '';
  }

  /// Cevap doğru mu kontrol et
  bool isCorrect(int selectedIndex) => selectedIndex == correctIndex;
}

/// Kategori sabitleri
class ChallengeCategories {
  static const String matematik = 'matematik';
  static const String fen = 'fen';
  static const String genelKultur = 'genel_kultur';
  static const String turkce = 'turkce';
  static const String tarih = 'tarih';
  static const String cografya = 'cografya';
  /// İlkokul 4-5: Tarih + Coğrafya birleşik
  static const String sosyalBilgiler = 'sosyal_bilgiler';
  static const String ingilizce = 'ingilizce';
  /// Lise 9-12: Fen Bilimleri ayrı ayrı
  static const String fizik = 'fizik';
  static const String kimya = 'kimya';
  static const String biyoloji = 'biyoloji';

  static const Map<String, String> displayNames = {
    matematik: 'Matematik',
    fen: 'Fen Bilimleri',
    genelKultur: 'Genel Kültür',
    turkce: 'Türkçe',
    tarih: 'Tarih',
    cografya: 'Coğrafya',
    sosyalBilgiler: 'Sosyal Bilgiler',
    ingilizce: 'İngilizce',
    fizik: 'Fizik',
    kimya: 'Kimya',
    biyoloji: 'Biyoloji',
  };

  static const Map<String, String> icons = {
    matematik: '🔢',
    fen: '🔬',
    genelKultur: '🌍',
    turkce: '📖',
    tarih: '📜',
    cografya: '🗺️',
    sosyalBilgiler: '🏛️',
    ingilizce: '🇬🇧',
    fizik: '⚛️',
    kimya: '🧪',
    biyoloji: '🧬',
  };

  static String getDisplayName(String category) => displayNames[category] ?? category;
  static String getIcon(String category) => icons[category] ?? '❓';

  /// Okul düzeyine göre lobby'de gösterilecek kategoriler
  /// İlkokul 4-5: Sosyal Bilgiler (Tarih+Coğrafya birleşik), Fen Bilimleri
  /// Ortaokul 6-8: Tarih, Coğrafya ayrı; Fen Bilimleri
  /// Lise 9-12: Tarih, Coğrafya ayrı; Fizik, Kimya, Biyoloji ayrı
  static List<String> categoriesForDifficulty(String difficulty) {
    switch (difficulty) {
      case 'ilkokul':
        return [genelKultur, matematik, fen, turkce, sosyalBilgiler, ingilizce];
      case 'ortaokul':
        return [genelKultur, matematik, fen, turkce, tarih, cografya, ingilizce];
      case 'lise':
        return [genelKultur, matematik, fizik, kimya, biyoloji, turkce, tarih, cografya, ingilizce];
      default:
        return [genelKultur, matematik, fen, turkce, sosyalBilgiler, ingilizce];
    }
  }
}

/// Zorluk sabitleri
class ChallengeDifficulties {
  static const String ilkokul = 'ilkokul';
  static const String ortaokul = 'ortaokul';
  static const String lise = 'lise';

  static const Map<String, String> displayNames = {
    ilkokul: 'İlkokul 4-5',
    ortaokul: 'Ortaokul 6-8',
    lise: 'Lise 9-12',
  };

  static String getDisplayName(String difficulty) => displayNames[difficulty] ?? difficulty;
}
