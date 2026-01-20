/// SOLICAP - Question Model
/// Çözülen soruları ve analiz verilerini tutar

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final String id;
  final String userId;
  final String? imageUrl;
  final String subject; // Ana konu (Matematik, Fizik, vb.)
  final String topic; // Alt konu (Türev, Alan, vb.)
  final String questionText; // AI tarafından okunan soru metni
  final String solution; // AI çözümü
  final String? userAnswer; // Öğrencinin cevabı
  final bool? wasCorrect;
  final DateTime createdAt;
  final Map<String, dynamic> aiAnalysis; // Zorluk, konu detayları
  final String source; // 'AI', 'GoldenDB', 'Internet'
  final double cost; // Tahmini maliyet (TL)

  QuestionModel({
    required this.id,
    required this.userId,
    this.imageUrl,
    required this.subject,
    required this.topic,
    required this.questionText,
    required this.solution,
    this.userAnswer,
    this.wasCorrect,
    required this.createdAt,
    this.aiAnalysis = const {},
    this.source = 'AI',
    this.cost = 0.0,
  });

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'],
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      questionText: data['questionText'] ?? '',
      solution: data['solution'] ?? '',
      userAnswer: data['userAnswer'],
      wasCorrect: data['wasCorrect'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      aiAnalysis: data['aiAnalysis'] ?? {},
      source: data['source'] ?? 'AI',
      cost: (data['cost'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'subject': subject,
      'topic': topic,
      'questionText': questionText,
      'solution': solution,
      'userAnswer': userAnswer,
      'wasCorrect': wasCorrect,
      'createdAt': Timestamp.fromDate(createdAt),
      'aiAnalysis': aiAnalysis,
      'source': source,
      'cost': cost,
    };
  }
}

/// Benzer soru modeli
class SimilarQuestion {
  final String question;
  final String correctAnswer;
  final List<String> options; // Çoktan seçmeli için
  final String explanation;

  SimilarQuestion({
    required this.question,
    required this.correctAnswer,
    this.options = const [],
    required this.explanation,
  });

  factory SimilarQuestion.fromJson(Map<String, dynamic> json) {
    return SimilarQuestion(
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'correctAnswer': correctAnswer,
      'options': options,
      'explanation': explanation,
    };
  }
}
