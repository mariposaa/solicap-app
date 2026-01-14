import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _feedbackCollection => _firestore.collection('user_feedbacks');

  /// Yeni bir istek/öneri gönder
  Future<bool> sendFeedback({
    required String userId,
    required String userName,
    required String content,
  }) async {
    try {
      await _feedbackCollection.add({
        'userId': userId,
        'userName': userName,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      return true;
    } catch (e) {
      debugPrint('❌ Feedback gönderme hatası: $e');
      return false;
    }
  }

  /// Tüm bildirimleri getir (Admin için)
  Stream<List<UserFeedback>> getFeedbacks() {
    return _feedbackCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserFeedback.fromFirestore(doc)).toList();
    });
  }

  /// Bildirimi okundu olarak işaretle
  Future<void> markAsRead(String feedbackId) async {
    try {
      await _feedbackCollection.doc(feedbackId).update({'isRead': true});
    } catch (e) {
      debugPrint('❌ Feedback güncelleme hatası: $e');
    }
  }

  /// Bildirimi sil
  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await _feedbackCollection.doc(feedbackId).delete();
    } catch (e) {
      debugPrint('❌ Feedback silme hatası: $e');
    }
  }
}
