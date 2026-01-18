/// SOLICAP - Golden Question Model
/// Altın Veritabanı (Doğrulanmış Sorular) için model
/// Sadece Matematik, Fizik, Kimya soruları için kullanılır

import 'package:cloud_firestore/cloud_firestore.dart';

/// Doğrulanmış soru modeli - Kolektif hafızanın temel taşı
class GoldenQuestion {
  final String id;
  final String imageHash;           // SHA256 hash (tam eşleşme kontrolü)
  final List<double> embedding;     // 768-dim vector (benzerlik araması)
  final String questionText;        // OCR ile okunan soru metni
  final String correctAnswer;       // A, B, C, D veya E
  final String solution;            // Adım adım çözüm
  final String subject;             // Matematik, Fizik, Kimya
  final String topic;               // Türev, İntegral, Dinamik, vb.
  final String? source;             // "2021 KPSS", "2022 TYT", vb.
  final DateTime verifiedAt;        // Doğrulama zamanı
  final String verificationMethod;  // "internet_match", "manual", "usage_based"
  final int usageCount;             // Kaç kez kullanıldı
  final double confidenceScore;     // 0.0 - 1.0

  GoldenQuestion({
    required this.id,
    required this.imageHash,
    required this.embedding,
    required this.questionText,
    required this.correctAnswer,
    required this.solution,
    required this.subject,
    required this.topic,
    this.source,
    required this.verifiedAt,
    required this.verificationMethod,
    this.usageCount = 0,
    required this.confidenceScore,
  });

  /// Firestore'dan oluştur
  factory GoldenQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoldenQuestion(
      id: doc.id,
      imageHash: data['imageHash'] ?? '',
      embedding: (data['embedding'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? [],
      questionText: data['questionText'] ?? '',
      correctAnswer: data['correctAnswer'] ?? '',
      solution: data['solution'] ?? '',
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      source: data['source'],
      verifiedAt: (data['verifiedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      verificationMethod: data['verificationMethod'] ?? 'unknown',
      usageCount: data['usageCount'] ?? 0,
      confidenceScore: (data['confidenceScore'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Firestore'a kaydet
  Map<String, dynamic> toFirestore() {
    return {
      'imageHash': imageHash,
      'embedding': embedding,
      'questionText': questionText,
      'correctAnswer': correctAnswer,
      'solution': solution,
      'subject': subject,
      'topic': topic,
      'source': source,
      'verifiedAt': Timestamp.fromDate(verifiedAt),
      'verificationMethod': verificationMethod,
      'usageCount': usageCount,
      'confidenceScore': confidenceScore,
    };
  }

  /// Kullanım sayısını artır
  GoldenQuestion incrementUsage() {
    return GoldenQuestion(
      id: id,
      imageHash: imageHash,
      embedding: embedding,
      questionText: questionText,
      correctAnswer: correctAnswer,
      solution: solution,
      subject: subject,
      topic: topic,
      source: source,
      verifiedAt: verifiedAt,
      verificationMethod: verificationMethod,
      usageCount: usageCount + 1,
      confidenceScore: confidenceScore,
    );
  }
}
