/// SOLICAP - Pending Question Model
/// Geçici Hafıza (Henüz Doğrulanmamış Sorular) için model
/// Sadece Matematik, Fizik, Kimya soruları için kullanılır

import 'package:cloud_firestore/cloud_firestore.dart';

/// Geçici soru durumları
enum PendingStatus {
  pending,    // Doğrulama bekliyor
  conflict,   // AI ve internet cevabı çelişiyor
  verified,   // Doğrulandı, Altın DB'ye taşınmayı bekliyor
}

/// Henüz doğrulanmamış soru modeli
class PendingQuestion {
  final String id;
  final String imageHash;           // SHA256 hash
  final List<double> embedding;     // 768-dim vector
  final String questionText;        // OCR metni
  final String aiAnswer;            // AI'ın verdiği cevap (A-E)
  final String aiSolution;          // AI'ın çözümü
  final String subject;             // Matematik, Fizik, Kimya
  final String topic;               // Alt konu
  final double confidenceScore;     // 0.0 - 1.0
  final DateTime createdAt;         // Oluşturulma zamanı
  final int queryCount;             // Kaç kez soruldu
  final PendingStatus status;       // Durum
  final String? conflictReason;     // Çelişki varsa açıklama
  final String? internetAnswer;     // İnternetten bulunan cevap

  PendingQuestion({
    required this.id,
    required this.imageHash,
    required this.embedding,
    required this.questionText,
    required this.aiAnswer,
    required this.aiSolution,
    required this.subject,
    required this.topic,
    required this.confidenceScore,
    required this.createdAt,
    this.queryCount = 1,
    this.status = PendingStatus.pending,
    this.conflictReason,
    this.internetAnswer,
  });

  /// Firestore'dan oluştur
  factory PendingQuestion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendingQuestion(
      id: doc.id,
      imageHash: data['imageHash'] ?? '',
      embedding: (data['embedding'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ?? [],
      questionText: data['questionText'] ?? '',
      aiAnswer: data['aiAnswer'] ?? '',
      aiSolution: data['aiSolution'] ?? '',
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      confidenceScore: (data['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      queryCount: data['queryCount'] ?? 1,
      status: PendingStatus.values.firstWhere(
        (s) => s.name == (data['status'] ?? 'pending'),
        orElse: () => PendingStatus.pending,
      ),
      conflictReason: data['conflictReason'],
      internetAnswer: data['internetAnswer'],
    );
  }

  /// Firestore'a kaydet
  Map<String, dynamic> toFirestore() {
    return {
      'imageHash': imageHash,
      'embedding': embedding,
      'questionText': questionText,
      'aiAnswer': aiAnswer,
      'aiSolution': aiSolution,
      'subject': subject,
      'topic': topic,
      'confidenceScore': confidenceScore,
      'createdAt': Timestamp.fromDate(createdAt),
      'queryCount': queryCount,
      'status': status.name,
      'conflictReason': conflictReason,
      'internetAnswer': internetAnswer,
    };
  }

  /// Sorgu sayısını artır
  PendingQuestion incrementQuery() {
    return PendingQuestion(
      id: id,
      imageHash: imageHash,
      embedding: embedding,
      questionText: questionText,
      aiAnswer: aiAnswer,
      aiSolution: aiSolution,
      subject: subject,
      topic: topic,
      confidenceScore: confidenceScore,
      createdAt: createdAt,
      queryCount: queryCount + 1,
      status: status,
      conflictReason: conflictReason,
      internetAnswer: internetAnswer,
    );
  }

  /// Durumu güncelle
  PendingQuestion withStatus(PendingStatus newStatus, {String? reason}) {
    return PendingQuestion(
      id: id,
      imageHash: imageHash,
      embedding: embedding,
      questionText: questionText,
      aiAnswer: aiAnswer,
      aiSolution: aiSolution,
      subject: subject,
      topic: topic,
      confidenceScore: confidenceScore,
      createdAt: createdAt,
      queryCount: queryCount,
      status: newStatus,
      conflictReason: reason ?? conflictReason,
      internetAnswer: internetAnswer,
    );
  }

  /// GoldenQuestion'a dönüştür (doğrulama sonrası)
  Map<String, dynamic> toGoldenFirestore({
    required String verificationMethod,
    String? source,
  }) {
    return {
      'imageHash': imageHash,
      'embedding': embedding,
      'questionText': questionText,
      'correctAnswer': internetAnswer ?? aiAnswer,
      'solution': aiSolution,
      'subject': subject,
      'topic': topic,
      'source': source,
      'verifiedAt': Timestamp.now(),
      'verificationMethod': verificationMethod,
      'usageCount': queryCount,
      'confidenceScore': confidenceScore,
    };
  }
}
