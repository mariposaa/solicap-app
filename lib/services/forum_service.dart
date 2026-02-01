/// Forum Service - Paylaşım ve yorum işlemleri
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/forum_post_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';

class ForumService {
  static final ForumService _instance = ForumService._internal();
  factory ForumService() => _instance;
  ForumService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();

  static const String _postsCollection = 'forum_posts';
  static const String _commentsCollection = 'forum_comments';

  // ════════════════════════════════════════════════════════════════
  // PAYLAŞIMLAR
  // ════════════════════════════════════════════════════════════════

  /// Kategoriye göre paylaşımları getir (stream) - Erasmus için sadece onaylılar
  Stream<List<ForumPost>> getPostsStream(String category) {
    Query query = _firestore
        .collection(_postsCollection)
        .where('category', isEqualTo: category);
    
    // Erasmus için sadece onaylıları göster (diğerleri zaten isApproved: true)
    if (category == 'erasmus') {
      query = query.where('isApproved', isEqualTo: true);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ForumPost.fromFirestore(doc)).toList());
  }

  /// Admin: Onay bekleyen paylaşımları getir (stream)
  Stream<List<ForumPost>> getPendingPostsStream() {
    return _firestore
        .collection(_postsCollection)
        .where('isApproved', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ForumPost.fromFirestore(doc)).toList());
  }

  /// Admin: Paylaşımı onayla
  Future<void> approvePost(String postId) async {
    await _firestore.collection(_postsCollection).doc(postId).update({
      'isApproved': true,
      'approvedAt': FieldValue.serverTimestamp(),
    });
    debugPrint('✅ Paylaşım onaylandı: $postId');
  }

  /// Admin: Paylaşımı reddet/sil
  Future<void> rejectPost(String postId) async {
    await deletePost(postId);
    debugPrint('✅ Paylaşım reddedildi: $postId');
  }

  /// Yeni paylaşım ekle (erasmus için isApproved: false, diğerleri için true)
  Future<void> addPost({
    required String text,
    required String category,
    Uint8List? imageBytes,
    String? contactInfo,
    int maxLength = 150,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Giriş yapılmamış');

    if (text.length > maxLength) {
      throw Exception('Yazı $maxLength karakteri geçemez');
    }

    final dna = await _dnaService.getDNA();
    final displayName = dna?.userName ?? 'Öğrenci';

    String? imageUrl;
    if (imageBytes != null) {
      imageUrl = await _uploadImage(imageBytes, userId);
    }

    // Erasmus için admin onayı gerekiyor
    final needsApproval = category == 'erasmus';

    final post = ForumPost(
      id: '',
      userId: userId,
      displayName: displayName,
      imageUrl: imageUrl,
      text: text,
      category: category,
      createdAt: DateTime.now(),
      commentCount: 0,
      contactInfo: contactInfo,
      isApproved: !needsApproval, // Erasmus false, diğerleri true
    );

    await _firestore.collection(_postsCollection).add(post.toFirestore());
    debugPrint('✅ Forum paylaşımı eklendi: $category (onay: ${post.isApproved})');
  }

  /// Resim yükle
  Future<String> _uploadImage(Uint8List imageBytes, String userId) async {
    final fileName = 'forum_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('forum_images/$fileName');
    
    final uploadTask = await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    
    return await uploadTask.ref.getDownloadURL();
  }

  /// Paylaşım sil (sadece kendi paylaşımı)
  Future<void> deletePost(String postId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    final doc = await _firestore.collection(_postsCollection).doc(postId).get();
    if (doc.exists && doc.data()?['userId'] == userId) {
      // Yorumları da sil
      final comments = await _firestore
          .collection(_commentsCollection)
          .where('postId', isEqualTo: postId)
          .get();
      for (final c in comments.docs) {
        await c.reference.delete();
      }
      await _firestore.collection(_postsCollection).doc(postId).delete();
      debugPrint('✅ Forum paylaşımı silindi: $postId');
    }
  }

  // ════════════════════════════════════════════════════════════════
  // YORUMLAR
  // ════════════════════════════════════════════════════════════════

  /// Paylaşıma ait yorumları getir (stream)
  Stream<List<ForumComment>> getCommentsStream(String postId) {
    return _firestore
        .collection(_commentsCollection)
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ForumComment.fromFirestore(doc)).toList());
  }

  /// Yorum ekle
  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Giriş yapılmamış');

    final dna = await _dnaService.getDNA();
    final displayName = dna?.userName ?? 'Öğrenci';

    final comment = ForumComment(
      id: '',
      postId: postId,
      userId: userId,
      displayName: displayName,
      text: text,
      createdAt: DateTime.now(),
    );

    await _firestore.collection(_commentsCollection).add(comment.toFirestore());

    // Yorum sayısını artır
    await _firestore.collection(_postsCollection).doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });

    debugPrint('✅ Yorum eklendi: $postId');
  }

  /// Yorum sil (sadece kendi yorumu)
  Future<void> deleteComment(String commentId, String postId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    final doc = await _firestore.collection(_commentsCollection).doc(commentId).get();
    if (doc.exists && doc.data()?['userId'] == userId) {
      await _firestore.collection(_commentsCollection).doc(commentId).delete();
      
      // Yorum sayısını azalt
      await _firestore.collection(_postsCollection).doc(postId).update({
        'commentCount': FieldValue.increment(-1),
      });
      
      debugPrint('✅ Yorum silindi: $commentId');
    }
  }
}
