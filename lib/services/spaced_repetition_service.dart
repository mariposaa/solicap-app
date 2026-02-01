/// SOLICAP - Spaced Repetition Service
/// Aralıklı tekrar sistemi - Leitner algoritması ile akıllı tekrar

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class SpacedRepetitionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Leitner kutuları - gün cinsinden tekrar aralıkları
  static const Map<int, int> _boxIntervals = {
    1: 1,   // Kutu 1: Her gün
    2: 2,   // Kutu 2: 2 günde bir
    3: 4,   // Kutu 3: 4 günde bir
    4: 7,   // Kutu 4: Haftada bir
    5: 14,  // Kutu 5: 2 haftada bir
    6: 30,  // Kutu 6: Ayda bir (ustalaştı)
  };

  /// Bugün tekrar edilecek soruları getir
  Future<List<ReviewCard>> getTodayReviews() async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      final now = DateTime.now();
      // BUG FIX: Artık gün başlangıcını değil, şimdiki zamanı kullanıyoruz.
      // Böylece bugün eklenen kartlar hemen görünür hale geliyor.
      final today = now;

      final snapshot = await _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('cards')
          .where('nextReviewDate', isLessThanOrEqualTo: Timestamp.fromDate(today))
          .orderBy('nextReviewDate')
          .limit(20)
          .get();

      return snapshot.docs.map((doc) => ReviewCard.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Review cards error: $e');
      return [];
    }
  }

  /// Yeni soru kartı ekle (yanlış yapılan sorulardan)
  Future<void> addCard({
    required String questionId,
    required String questionText,
    required String topic,
    required String subTopic,
    required String correctAnswer,
    String? imageUrl,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    // 🛑 KONU FİLTRESİ (Kullanıcı İsteği)
    // Sadece Sözel Dersler ve Biyoloji eklenecek.
    // Sayısal (Mat, Fizik, Kimya, Geo) engellenecek.
    final lowerTopic = topic.toLowerCase();
    
    // İzin verilen istisna: Biyoloji
    final bool isBiology = lowerTopic.contains('biyoloji') || lowerTopic.contains('biology');
    
    // Yasaklı Sayısal Dersler
    final bool isNumerical = lowerTopic.contains('matematik') || 
                             lowerTopic.contains('fizik') || 
                             lowerTopic.contains('kimya') || 
                             lowerTopic.contains('geometri');

    // Kural: Sayısal ise ve Biyoloji değilse -> EKLEME
    if (isNumerical && !isBiology) {
      debugPrint('⛔ Tekrar Kartı Engellendi (Sayısal Filtre): $topic');
      return; 
    }

    try {
      final cardId = '${topic}_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      await _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('cards')
          .doc(cardId)
          .set({
        'questionId': questionId,
        'questionText': questionText,
        'topic': topic,
        'subTopic': subTopic,
        'correctAnswer': correctAnswer,
        'imageUrl': imageUrl,
        'box': 1, // Başlangıç kutusu
        'createdAt': FieldValue.serverTimestamp(),
        'nextReviewDate': Timestamp.fromDate(now), // Hemen tekrar
        'totalReviews': 0,
        'correctStreak': 0,
      });

      debugPrint('✅ Review card added: $cardId');
    } catch (e) {
      debugPrint('❌ Add card error: $e');
    }
  }

  /// Kart cevaplandı - kutuyu güncelle
  Future<void> answerCard(String cardId, bool wasCorrect) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final docRef = _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('cards')
          .doc(cardId);

      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data()!;
      int currentBox = data['box'] ?? 1;
      int correctStreak = data['correctStreak'] ?? 0;

      int newBox;
      int newStreak;

      if (wasCorrect) {
        // Doğru - bir sonraki kutuya geç
        newBox = (currentBox < 6) ? currentBox + 1 : 6;
        newStreak = correctStreak + 1;
      } else {
        // Yanlış - ilk kutuya geri dön
        newBox = 1;
        newStreak = 0;
      }

      // Yeni tekrar tarihini hesapla
      final intervalDays = _boxIntervals[newBox] ?? 1;
      final nextReview = DateTime.now().add(Duration(days: intervalDays));

      await docRef.update({
        'box': newBox,
        'correctStreak': newStreak,
        'nextReviewDate': Timestamp.fromDate(nextReview),
        'totalReviews': FieldValue.increment(1),
        'lastReviewedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Card updated: Box $currentBox → $newBox, Next: $intervalDays days');
    } catch (e) {
      debugPrint('❌ Answer card error: $e');
    }
  }

  /// İstatistikleri getir
  Future<SpacedRepetitionStats> getStats() async {
    final userId = _authService.currentUserId;
    if (userId == null) return SpacedRepetitionStats.empty();

    try {
      final snapshot = await _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('cards')
          .get();

      if (snapshot.docs.isEmpty) return SpacedRepetitionStats.empty();

      int totalCards = snapshot.docs.length;
      int masteredCards = 0;
      int dueToday = 0;
      Map<int, int> boxDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

      final now = DateTime.now();
      final today = now;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final box = data['box'] ?? 1;
        
        boxDistribution[box] = (boxDistribution[box] ?? 0) + 1;
        
        if (box >= 5) masteredCards++;
        
        final nextReview = (data['nextReviewDate'] as Timestamp?)?.toDate();
        if (nextReview != null && !nextReview.isAfter(today)) {
          dueToday++;
        }
      }

      return SpacedRepetitionStats(
        totalCards: totalCards,
        masteredCards: masteredCards,
        dueToday: dueToday,
        boxDistribution: boxDistribution,
      );
    } catch (e) {
      debugPrint('❌ Stats error: $e');
      return SpacedRepetitionStats.empty();
    }
  }

  /// Kartı sil
  Future<void> deleteCard(String cardId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      await _firestore
          .collection('user_reviews')
          .doc(userId)
          .collection('cards')
          .doc(cardId)
          .delete();
          
      debugPrint('✅ Card deleted: $cardId');
    } catch (e) {
      debugPrint('❌ Delete card error: $e');
    }
  }
}

/// Tekrar kartı modeli
class ReviewCard {
  final String id;
  final String questionId;
  final String questionText;
  final String topic;
  final String subTopic;
  final String correctAnswer;
  final String? imageUrl;
  final int box;
  final DateTime? nextReviewDate;
  final int totalReviews;
  final int correctStreak;

  ReviewCard({
    required this.id,
    required this.questionId,
    required this.questionText,
    required this.topic,
    required this.subTopic,
    required this.correctAnswer,
    this.imageUrl,
    required this.box,
    this.nextReviewDate,
    required this.totalReviews,
    required this.correctStreak,
  });

  factory ReviewCard.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewCard(
      id: doc.id,
      questionId: data['questionId'] ?? '',
      questionText: data['questionText'] ?? '',
      topic: data['topic'] ?? '',
      subTopic: data['subTopic'] ?? '',
      correctAnswer: data['correctAnswer'] ?? '',
      imageUrl: data['imageUrl'],
      box: data['box'] ?? 1,
      nextReviewDate: (data['nextReviewDate'] as Timestamp?)?.toDate(),
      totalReviews: data['totalReviews'] ?? 0,
      correctStreak: data['correctStreak'] ?? 0,
    );
  }

  /// Kutu durumu açıklaması
  String get boxStatus {
    switch (box) {
      case 1: return 'Yeni';
      case 2: return 'Öğreniliyor';
      case 3: return 'Pekiştiriliyor';
      case 4: return 'Hatırlıyor';
      case 5: return 'Neredeyse Ustalaştı';
      case 6: return 'Ustalaştı ⭐';
      default: return 'Bilinmiyor';
    }
  }
}

/// Spaced Repetition istatistikleri
class SpacedRepetitionStats {
  final int totalCards;
  final int masteredCards;
  final int dueToday;
  final Map<int, int> boxDistribution;

  SpacedRepetitionStats({
    required this.totalCards,
    required this.masteredCards,
    required this.dueToday,
    required this.boxDistribution,
  });

  factory SpacedRepetitionStats.empty() {
    return SpacedRepetitionStats(
      totalCards: 0,
      masteredCards: 0,
      dueToday: 0,
      boxDistribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0},
    );
  }

  double get masteryRate => totalCards > 0 ? masteredCards / totalCards : 0.0;
}
