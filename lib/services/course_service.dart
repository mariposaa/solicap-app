/// 📚 KAMPÜS MODÜLÜ - Ders Servisi
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import 'auth_service.dart';

class CourseService {
  static final CourseService _instance = CourseService._internal();
  factory CourseService() => _instance;
  CourseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // ═══════════════════════════════════════════════════════════════
  // DERS İŞLEMLERİ
  // ═══════════════════════════════════════════════════════════════

  /// Yeni ders ekle
  Future<Course?> addCourse(String name) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final docRef = await _firestore.collection('courses').add({
        'userId': userId,
        'name': name.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'noteCount': 0,
      });

      debugPrint('✅ Ders eklendi: $name');
      return Course(
        id: docRef.id,
        userId: userId,
        name: name.trim(),
        createdAt: DateTime.now(),
        noteCount: 0,
      );
    } catch (e) {
      debugPrint('❌ Ders ekleme hatası: $e');
      return null;
    }
  }

  /// Kullanıcının derslerini getir (Stream)
  Stream<List<Course>> getCoursesStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('courses')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList());
  }

  /// Ders sil
  Future<bool> deleteCourse(String courseId) async {
    try {
      // Önce dersteki tüm notları sil
      final notes = await _firestore
          .collection('course_notes')
          .where('courseId', isEqualTo: courseId)
          .get();
      
      for (final doc in notes.docs) {
        await doc.reference.delete();
      }

      // Sonra dersi sil
      await _firestore.collection('courses').doc(courseId).delete();
      debugPrint('✅ Ders silindi: $courseId');
      return true;
    } catch (e) {
      debugPrint('❌ Ders silme hatası: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // NOT İŞLEMLERİ
  // ═══════════════════════════════════════════════════════════════

  /// Derse not ekle
  Future<CourseNote?> addNote({
    required String courseId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final docRef = await _firestore.collection('course_notes').add({
        'courseId': courseId,
        'userId': userId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Not sayısını güncelle
      await _firestore.collection('courses').doc(courseId).update({
        'noteCount': FieldValue.increment(1),
      });

      debugPrint('✅ Not eklendi: $title');
      return CourseNote(
        id: docRef.id,
        courseId: courseId,
        userId: userId,
        title: title,
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('❌ Not ekleme hatası: $e');
      return null;
    }
  }

  /// Dersin notlarını getir (Stream)
  Stream<List<CourseNote>> getNotesStream(String courseId) {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('course_notes')
        .where('courseId', isEqualTo: courseId)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => CourseNote.fromFirestore(doc)).toList());
  }

  /// Dersin tüm notlarını getir (tek seferlik - Sınava Hazırla için)
  Future<List<CourseNote>> getAllNotes(String courseId) async {
    try {
      final snapshot = await _firestore
          .collection('course_notes')
          .where('courseId', isEqualTo: courseId)
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => CourseNote.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Not getirme hatası: $e');
      return [];
    }
  }

  /// Not sil
  Future<bool> deleteNote(String noteId, String courseId) async {
    try {
      await _firestore.collection('course_notes').doc(noteId).delete();
      
      // Not sayısını güncelle
      await _firestore.collection('courses').doc(courseId).update({
        'noteCount': FieldValue.increment(-1),
      });

      debugPrint('✅ Not silindi: $noteId');
      return true;
    } catch (e) {
      debugPrint('❌ Not silme hatası: $e');
      return false;
    }
  }
}
