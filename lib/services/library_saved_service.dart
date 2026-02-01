/// SOLICAP - Kütüphane kayıtlı yanıtlar servisi

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/library_saved_answer_model.dart';
import 'auth_service.dart';

class LibrarySavedService {
  static final LibrarySavedService _instance = LibrarySavedService._internal();
  factory LibrarySavedService() => _instance;
  LibrarySavedService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  static const String _collection = 'library_saved_answers';

  /// Yanıt kaydet
  Future<bool> saveAnswer({required String question, required String answer}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;
    if (question.trim().isEmpty || answer.trim().isEmpty) return false;

    try {
      await _firestore.collection(_collection).add({
        'userId': userId,
        'question': question,
        'answer': answer,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      debugPrint('❌ Library saved answer hatası: $e');
      return false;
    }
  }

  /// Kayıtlı yanıtlar stream (kullanıcıya göre, en yeni önce)
  Stream<List<LibrarySavedAnswer>> getSavedStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => LibrarySavedAnswer.fromFirestore(d)).toList());
  }

  /// Kayıtlı yanıt sil
  Future<void> deleteSaved(String id) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && (doc.data()?['userId'] == userId)) {
        await _firestore.collection(_collection).doc(id).delete();
      }
    } catch (e) {
      debugPrint('❌ Library saved delete hatası: $e');
    }
  }
}
