import 'package:cloud_firestore/cloud_firestore.dart';

/// 📚 KAMPÜS MODÜLÜ - Ders Modeli
class Course {
  final String id;
  final String userId;
  final String name;          // Ders adı (Biyoloji, Termodinamik vb.)
  final DateTime createdAt;
  final int noteCount;        // İçindeki not sayısı

  Course({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    this.noteCount = 0,
  });

  factory Course.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      noteCount: data['noteCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'createdAt': Timestamp.fromDate(createdAt),
      'noteCount': noteCount,
    };
  }
}

/// 📝 Ders Notu Modeli (Basitleştirilmiş)
class CourseNote {
  final String id;
  final String courseId;
  final String userId;
  final String title;
  final String content;       // Düzenlenmiş markdown içerik
  final String? imageUrl;     // Orijinal görsel (opsiyonel)
  final DateTime createdAt;

  CourseNote({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory CourseNote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseNote(
      id: doc.id,
      courseId: data['courseId'] ?? '',
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': courseId,
      'userId': userId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
