/// SOLICAP - Kütüphane kayıtlı yanıt modeli

import 'package:cloud_firestore/cloud_firestore.dart';

class LibrarySavedAnswer {
  final String id;
  final String userId;
  final String question;
  final String answer;
  final DateTime createdAt;

  LibrarySavedAnswer({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  factory LibrarySavedAnswer.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return LibrarySavedAnswer(
      id: doc.id,
      userId: d['userId'] ?? '',
      question: d['question'] ?? '',
      answer: d['answer'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'question': question,
        'answer': answer,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
