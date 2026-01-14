/// SOLICAP - Announcement Model
/// Duyuru modeli

import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final String type;         // 'info', 'success', 'warning', 'promo'
  final String? actionUrl;   // Tıklanınca gidilecek link
  final String? actionText;  // Buton metni
  final bool isActive;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int priority;        // Sıralama için

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.type = 'info',
    this.actionUrl,
    this.actionText,
    this.isActive = true,
    required this.createdAt,
    this.expiresAt,
    this.priority = 0,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      type: data['type'] ?? 'info',
      actionUrl: data['actionUrl'],
      actionText: data['actionText'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      priority: data['priority'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'type': type,
      'actionUrl': actionUrl,
      'actionText': actionText,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'priority': priority,
    };
  }

  /// Süresi dolmuş mu?
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Gösterilebilir mi?
  bool get canShow => isActive && !isExpired;
}
