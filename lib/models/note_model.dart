import 'package:cloud_firestore/cloud_firestore.dart';

class StudyNote {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;

  StudyNote({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.timestamp,
  });

  factory StudyNote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudyNote(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'Başlıksız Not',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      timestamp: (data['timestamp'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
