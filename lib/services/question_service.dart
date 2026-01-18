/// SOLICAP - Question Service
/// Soru kaydetme ve Firebase işlemleri + UserDNA entegrasyonu

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import 'gemini_service.dart';
import 'user_dna_service.dart';

class QuestionService {
  static final QuestionService _instance = QuestionService._internal();
  factory QuestionService() => _instance;
  QuestionService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UserDNAService get _dnaService => UserDNAService();

  /// Bellek içi geçmiş cache'i
  static List<QuestionModel> _cache = [];
  bool _isCacheLoaded = false;

  /// Soru görselini Firebase Storage'a yükle
  Future<String?> uploadQuestionImage(Uint8List imageBytes, String userId) async {
    try {
      final fileName = 'questions/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(fileName);
      
      await ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await ref.getDownloadURL();
      debugPrint('✅ Görsel yüklendi: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Görsel yükleme hatası: $e');
      return null;
    }
  }

  /// Çözülen soruyu kaydet ve DNA'ya ekle
  Future<QuestionModel?> saveQuestion({
    required String userId,
    required QuestionSolution solution,
    String? imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('questions').doc();
      
      final question = QuestionModel(
        id: docRef.id,
        userId: userId,
        imageUrl: imageUrl,
        subject: solution.subject,
        topic: solution.topic,
        questionText: solution.questionText,
        solution: solution.solution,
        createdAt: DateTime.now(),
        aiAnalysis: {
          'difficulty': solution.difficulty,
          'keyConceptsUsed': solution.keyConceptsUsed,
          'correctAnswer': solution.correctAnswer,
          'tips': solution.tips,
        },
      );

      await docRef.set(question.toFirestore());
      
      // 🚀 CACHE GÜNCELLEME: Anında listeye ekle
      _cache.insert(0, question);
      
      // Kullanıcının toplam soru sayısını güncelle
      await _updateUserQuestionCount(userId);
      
      // 🧬 UserDNA'ya kaydet (Sadece çözüm istendi, win/loss istatistiğini etkilemesin)
      await _dnaService.recordQuestionAttempt(
        topic: solution.subject,
        subTopic: solution.topic,
        isCorrect: null, // Puan artırma/azaltma yapmasın
        difficulty: solution.difficulty,
        questionText: solution.questionText,
        imageUrl: imageUrl,
        correctAnswer: solution.correctAnswer,
      );
      
      debugPrint('✅ Soru kaydedildi ve önbelleğe alındı: ${docRef.id}');
      return question;
    } catch (e) {
      debugPrint('❌ Soru kaydetme hatası: $e');
      return null;
    }
  }

  /// ❌ Çözülemeyen soruyu kaydet
  Future<QuestionModel?> saveFailedAttempt({
    required String userId,
    String? imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('questions').doc();
      
      final question = QuestionModel(
        id: docRef.id,
        userId: userId,
        imageUrl: imageUrl,
        subject: 'Bilinmiyor',
        topic: 'Çözülemedi',
        questionText: 'Görsel okunurken bir hata oluştu.',
        solution: 'Üzgünüm, bu soruyu şu an çözemiyorum. Lütfen görselin net olduğundan emin olup tekrar deneyin.',
        createdAt: DateTime.now(),
        wasCorrect: false,
        aiAnalysis: {'difficulty': 'unknown'},
      );

      await docRef.set(question.toFirestore());
      
      // Cache'e ekle
      _cache.insert(0, question);
      
      return question;
    } catch (e) {
      debugPrint('❌ Hatalı deneme kaydı başarısız: $e');
      return null;
    }
  }

  /// Kullanıcının soru sayısını güncelle
  Future<void> _updateUserQuestionCount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'totalQuestions': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('Kullanıcı soru sayısı güncellenemedi: $e');
    }
  }

  /// 🔄 Anlık çözüm geçmişi akışı (Real-time sync)
  Stream<List<QuestionModel>> getUserQuestionsStream(
    String userId, {
    int limit = 20,
    String? subject,
  }) {
    Query query = _firestore
        .collection('questions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (subject != null) {
      query = query.where('subject', isEqualTo: subject);
    }

    return query.limit(limit).snapshots().map((snapshot) {
      final results = snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc))
          .toList();
      
      // Cache'i de güncelle (opsiyonel ama tutarlılık için iyi)
      if (subject == null) {
        _cache = results;
        _isCacheLoaded = true;
      }
      
      return results;
    });
  }

  /// Kullanıcının çözüm geçmişini getir
  Future<List<QuestionModel>> getUserQuestions(
    String userId, {
    int limit = 20,
    String? subject,
    bool forceRefresh = false,
  }) async {
    // 🚀 Cache varsa ve yenileme istenmiyorsa direkt cache'i dön
    if (_isCacheLoaded && !forceRefresh && _cache.isNotEmpty) {
      if (subject != null) {
        return _cache.where((q) => q.subject == subject).take(limit).toList();
      }
      return _cache.take(limit).toList();
    }

    try {
      Query query = _firestore
          .collection('questions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (subject != null) {
        query = query.where('subject', isEqualTo: subject);
      }

      final snapshot = await query.limit(limit).get();
      
      final results = snapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc))
          .toList();

      // Genel listeyi cache'le (sadece filtresiz halini ana cache yapalım)
      if (subject == null) {
        _cache = results;
        _isCacheLoaded = true;
      }
      
      return results;
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        debugPrint('⚠️ INDEX EXCEPTION: Soru geçmişi için composite index gerekiyor.');
        debugPrint('Lütfen Firebase Console üzerinden şu indexi oluşturun:');
        debugPrint('Koleksiyon: questions, Alanlar: userId (Asc), createdAt (Desc)');
      }
      debugPrint('❌ Soru geçmişi alınamadı: $e');
      return [];
    } catch (e) {
      debugPrint('❌ Soru geçmişi alınamadı: $e');
      return [];
    }
  }

  /// Konu bazlı istatistikler
  Future<Map<String, Map<String, int>>> getSubjectStats(String userId) async {
    try {
      final questions = await getUserQuestions(userId, limit: 100);
      
      final stats = <String, Map<String, int>>{};
      
      for (final q in questions) {
        if (!stats.containsKey(q.subject)) {
          stats[q.subject] = {'total': 0, 'correct': 0};
        }
        stats[q.subject]!['total'] = (stats[q.subject]!['total'] ?? 0) + 1;
        if (q.wasCorrect == true) {
          stats[q.subject]!['correct'] = (stats[q.subject]!['correct'] ?? 0) + 1;
        }
      }
      
      return stats;
    } catch (e) {
      debugPrint('❌ İstatistik hatası: $e');
      return {};
    }
  }

  /// Belirli bir soruyu getir
  Future<QuestionModel?> getQuestion(String questionId) async {
    try {
      final doc = await _firestore.collection('questions').doc(questionId).get();
      if (doc.exists) {
        return QuestionModel.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('❌ Soru getirme hatası: $e');
    }
    return null;
  }

  /// Kullanıcının cevabını kaydet ve DNA'yı güncelle
  Future<void> saveUserAnswer({
    required String questionId,
    required String userAnswer,
    required bool wasCorrect,
    String? failureReason, // 🆕 Hata nedeni
    List<String>? keyConceptsMissing, // 🆕 Eksik kavramlar
  }) async {
    try {
      // Soruyu al
      final question = await getQuestion(questionId);
      if (question == null) return;

      // Firestore'u güncelle
      await _firestore.collection('questions').doc(questionId).update({
        'userAnswer': userAnswer,
        'wasCorrect': wasCorrect,
      });
      
      // Eğer doğruysa kullanıcının doğru sayısını artır
      if (wasCorrect) {
        await _firestore.collection('users').doc(question.userId).update({
          'correctAnswers': FieldValue.increment(1),
        });
      }

      // 🧬 UserDNA'yı güncelle - VERİ MADENCİLİĞİ!
      await _dnaService.recordQuestionAttempt(
        topic: question.subject,
        subTopic: question.topic,
        isCorrect: wasCorrect,
        difficulty: question.aiAnalysis['difficulty'] ?? 'medium',
        questionText: question.questionText,
        imageUrl: question.imageUrl,
        correctAnswer: question.aiAnalysis['correctAnswer'],
        userAnswer: userAnswer,
        failureReason: wasCorrect ? null : failureReason,
        keyConceptsMissing: keyConceptsMissing,
      );
      
      debugPrint('✅ Cevap kaydedildi, DNA güncellendi');
    } catch (e) {
      debugPrint('❌ Cevap kaydetme hatası: $e');
    }
  }

  /// 🆕 Benzer soru pratiği tamamlandığında DNA'yı güncelle
  Future<void> recordPracticeCompletion({
    required String topic,
    required String subTopic,
    required int totalQuestions,
    required int correctAnswers,
    required bool completed,
    int? abandonedAtQuestion,
  }) async {
    await _dnaService.recordPracticeSession(
      topic: topic,
      subTopic: subTopic,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      completed: completed,
      abandonedAtQuestion: abandonedAtQuestion,
    );
  }
}
