/// Forum Post Model
import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id;
  final String userId;
  final String displayName;
  final String? imageUrl;
  final String text; // max 150 (burs) veya 500 (erasmus)
  final String category; // burs_dayanisma, erasmus, soru_cevap, kariyer_staj
  final DateTime createdAt;
  final int commentCount;
  
  // Erasmus özel alanlar
  final String? contactInfo; // Instagram, WhatsApp vb.
  final bool isApproved; // Admin onayı (erasmus için)
  final DateTime? approvedAt;

  ForumPost({
    required this.id,
    required this.userId,
    required this.displayName,
    this.imageUrl,
    required this.text,
    required this.category,
    required this.createdAt,
    this.commentCount = 0,
    this.contactInfo,
    this.isApproved = true, // Burs için otomatik onaylı
    this.approvedAt,
  });

  factory ForumPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ForumPost(
      id: doc.id,
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? 'Anonim',
      imageUrl: data['imageUrl'],
      text: data['text'] ?? '',
      category: data['category'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      commentCount: data['commentCount'] ?? 0,
      contactInfo: data['contactInfo'],
      isApproved: data['isApproved'] ?? true,
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'text': text,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'commentCount': commentCount,
      'contactInfo': contactInfo,
      'isApproved': isApproved,
      if (approvedAt != null) 'approvedAt': Timestamp.fromDate(approvedAt!),
    };
  }
}

class ForumComment {
  final String id;
  final String postId;
  final String userId;
  final String displayName;
  final String text;
  final DateTime createdAt;

  ForumComment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.displayName,
    required this.text,
    required this.createdAt,
  });

  factory ForumComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ForumComment(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? 'Anonim',
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'displayName': displayName,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
