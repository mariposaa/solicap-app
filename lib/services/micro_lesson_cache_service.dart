/// SOLICAP - Micro Lesson Cache Service
/// Mikro dersleri Firestore'a kaydet ve cache'le

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'gemini_service.dart';

class MicroLessonCacheService {
  static final MicroLessonCacheService _instance = MicroLessonCacheService._internal();
  factory MicroLessonCacheService() => _instance;
  MicroLessonCacheService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Koleksiyon referansı
  CollectionReference get _collection => _firestore.collection('user_micro_lessons');

  /// Kullanıcının tüm kayıtlı mikro derslerini getir
  Future<List<SavedMicroLesson>> getSavedLessons({DateFilter? filter}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      Query query = _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      // Tarih filtresi uygula
      if (filter != null && filter != DateFilter.all) {
        final cutoffDate = _getCutoffDate(filter);
        query = query.where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoffDate));
      }

      final snapshot = await query.limit(100).get();
      return snapshot.docs.map((doc) => SavedMicroLesson.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Mikro ders listesi hatası: $e');
      return [];
    }
  }

  /// Belirli bir topic için kayıtlı ders var mı?
  Future<SavedMicroLesson?> getCachedLesson(String topic) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('topic', isEqualTo: topic)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return SavedMicroLesson.fromFirestore(snapshot.docs.first);
    } catch (e) {
      debugPrint('❌ Cache kontrol hatası: $e');
      return null;
    }
  }

  /// Mikro dersi kaydet
  Future<SavedMicroLesson?> saveLesson({
    required String topic,
    required MicroLesson lesson,
    List<String>? strugglePoints,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      // Önce aynı topic için kayıt var mı kontrol et
      final existing = await getCachedLesson(topic);
      if (existing != null) {
        // Güncelle
        await _collection.doc(existing.id).update({
          'lesson': lesson.toJson(),
          'strugglePoints': strugglePoints,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return existing.copyWith(lesson: lesson);
      }

      // Yeni kayıt oluştur
      final docRef = await _collection.add({
        'userId': userId,
        'topic': topic,
        'lesson': lesson.toJson(),
        'strugglePoints': strugglePoints,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Mikro ders kaydedildi: $topic');

      return SavedMicroLesson(
        id: docRef.id,
        userId: userId,
        topic: topic,
        lesson: lesson,
        strugglePoints: strugglePoints,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('❌ Mikro ders kaydetme hatası: $e');
      return null;
    }
  }

  /// Kayıtlı topic'lerin listesini getir (yeşil tik için)
  Future<Set<String>> getSavedTopics() async {
    final userId = _authService.currentUserId;
    if (userId == null) return {};

    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) => data['topic'] as String)
          .toSet();
    } catch (e) {
      debugPrint('❌ Saved topics hatası: $e');
      return {};
    }
  }

  /// Tarih filtresi için cutoff tarihi hesapla
  DateTime _getCutoffDate(DateFilter filter) {
    final now = DateTime.now();
    switch (filter) {
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day);
      case DateFilter.week:
        return now.subtract(const Duration(days: 7));
      case DateFilter.threeMonths:
        return now.subtract(const Duration(days: 90));
      case DateFilter.sixMonths:
        return now.subtract(const Duration(days: 180));
      case DateFilter.all:
        return DateTime(2020);
    }
  }
}

/// Tarih filtresi enum
enum DateFilter {
  today,
  week,
  threeMonths,
  sixMonths,
  all,
}

extension DateFilterExt on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.today:
        return 'Bugün';
      case DateFilter.week:
        return 'Bu Hafta';
      case DateFilter.threeMonths:
        return '3 Ay';
      case DateFilter.sixMonths:
        return '6 Ay';
      case DateFilter.all:
        return 'Tümü';
    }
  }
}

/// Kayıtlı mikro ders modeli
class SavedMicroLesson {
  final String id;
  final String userId;
  final String topic;
  final MicroLesson lesson;
  final List<String>? strugglePoints;
  final DateTime createdAt;

  SavedMicroLesson({
    required this.id,
    required this.userId,
    required this.topic,
    required this.lesson,
    this.strugglePoints,
    required this.createdAt,
  });

  factory SavedMicroLesson.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavedMicroLesson(
      id: doc.id,
      userId: data['userId'] ?? '',
      topic: data['topic'] ?? '',
      lesson: MicroLesson.fromJson(data['lesson'] ?? {}),
      strugglePoints: (data['strugglePoints'] as List<dynamic>?)?.cast<String>(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  SavedMicroLesson copyWith({MicroLesson? lesson}) {
    return SavedMicroLesson(
      id: id,
      userId: userId,
      topic: topic,
      lesson: lesson ?? this.lesson,
      strugglePoints: strugglePoints,
      createdAt: createdAt,
    );
  }
}
