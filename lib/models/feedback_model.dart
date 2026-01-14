import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  UserFeedback({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });

  factory UserFeedback.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserFeedback(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonim',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}
