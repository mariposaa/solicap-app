import 'package:cloud_firestore/cloud_firestore.dart';

class SocraticSession {
  final String id;
  final String userId;
  final String originalQuestionUrl; // Orijinal sorunun resmi
  final String subject;
  final String topic;
  final List<SocraticStep> steps; // Aşama detayları
  final bool isSolved;
  final DateTime createdAt;

  SocraticSession({
    required this.id,
    required this.userId,
    required this.originalQuestionUrl,
    required this.subject,
    required this.topic,
    required this.steps,
    this.isSolved = false,
    required this.createdAt,
  });

  factory SocraticSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SocraticSession(
      id: doc.id,
      userId: data['userId'] ?? '',
      originalQuestionUrl: data['originalQuestionUrl'] ?? '',
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      steps: (data['steps'] as List? ?? [])
          .map((s) => SocraticStep.fromMap(s))
          .toList(),
      isSolved: data['isSolved'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'originalQuestionUrl': originalQuestionUrl,
      'subject': subject,
      'topic': topic,
      'steps': steps.map((s) => s.toMap()).toList(),
      'isSolved': isSolved,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class SocraticStep {
  final int number; // 1, 2, 3
  final String? studentWorkUrl; // Öğrencinin karalamasının resmi
  final String aiFeedback; // AI'nın o aşamadaki değerlendirmesi
  final String nextHint; // Bir sonraki ipucu
  final DateTime timestamp;

  SocraticStep({
    required this.number,
    this.studentWorkUrl,
    required this.aiFeedback,
    required this.nextHint,
    required this.timestamp,
  });

  factory SocraticStep.fromMap(Map<String, dynamic> map) {
    return SocraticStep(
      number: map['number'] ?? 1,
      studentWorkUrl: map['studentWorkUrl'],
      aiFeedback: map['aiFeedback'] ?? '',
      nextHint: map['nextHint'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'studentWorkUrl': studentWorkUrl,
      'aiFeedback': aiFeedback,
      'nextHint': nextHint,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
