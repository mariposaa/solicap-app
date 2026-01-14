/// SOLICAP - User Model
/// Öğrenci profili ve öğrenme verilerini tutar

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String deviceId;
  final DateTime createdAt;
  final String? grade; // Sınıf seviyesi (örn: "9. sınıf")
  final int totalQuestions;
  final int correctAnswers;
  final Map<String, dynamic> learningProfile; // Konu bazlı analiz

  UserModel({
    required this.id,
    required this.deviceId,
    required this.createdAt,
    this.grade,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.learningProfile = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      deviceId: data['deviceId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      grade: data['grade'],
      totalQuestions: data['totalQuestions'] ?? 0,
      correctAnswers: data['correctAnswers'] ?? 0,
      learningProfile: data['learningProfile'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'deviceId': deviceId,
      'createdAt': Timestamp.fromDate(createdAt),
      'grade': grade,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'learningProfile': learningProfile,
    };
  }

  UserModel copyWith({
    String? id,
    String? deviceId,
    DateTime? createdAt,
    String? grade,
    int? totalQuestions,
    int? correctAnswers,
    Map<String, dynamic>? learningProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      grade: grade ?? this.grade,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      learningProfile: learningProfile ?? this.learningProfile,
    );
  }
}
