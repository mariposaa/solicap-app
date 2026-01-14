/// SOLICAP - User DNA Service
/// Merkezi veri bankası servisi - Uygulamanın her yerinden erişilebilir

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_dna_model.dart';
import 'auth_service.dart';

class UserDNAService {
  static final UserDNAService _instance = UserDNAService._internal();
  factory UserDNAService() => _instance;
  UserDNAService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Bellekte tutulan DNA (hızlı erişim için)
  UserDNA? _cachedDNA;
  
  /// DNA koleksiyon referansı
  CollectionReference get _dnaCollection => _firestore.collection('user_dna');

  // ═══════════════════════════════════════════════════════════════
  // TEMEL İŞLEMLER
  // ═══════════════════════════════════════════════════════════════

  /// Kullanıcının DNA'sını al (cache'li)
  Future<UserDNA?> getDNA() async {
    if (_cachedDNA != null) return _cachedDNA;
    
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final doc = await _dnaCollection.doc(userId).get();
      
      if (doc.exists) {
        _cachedDNA = UserDNA.fromFirestore(doc);
      } else {
        // Yeni DNA oluştur
        _cachedDNA = UserDNA.empty(userId);
        await saveDNA(_cachedDNA!);
      }
      
      return _cachedDNA;
    } catch (e) {
      debugPrint('❌ DNA getirme hatası: $e');
      return null;
    }
  }

  /// DNA'yı kaydet
  Future<void> saveDNA(UserDNA dna) async {
    try {
      await _dnaCollection.doc(dna.userId).set(dna.toFirestore());
      _cachedDNA = dna;
      debugPrint('✅ DNA kaydedildi');
    } catch (e) {
      debugPrint('❌ DNA kaydetme hatası: $e');
    }
  }

  /// Cache'i temizle (çıkış yapıldığında)
  void clearCache() {
    _cachedDNA = null;
  }

  // ═══════════════════════════════════════════════════════════════
  // PROFİL GÜNCELLEMELERİ
  // ═══════════════════════════════════════════════════════════════

  /// Profil bilgilerini güncelle
  Future<void> updateProfile({
    String? gradeLevel,
    String? targetExam,
    String? learningStyle,
    String? motivationLevel,
    String? difficultyPreference,
  }) async {
    final dna = await getDNA();
    if (dna == null) return;

    final updated = dna.copyWith(
      gradeLevel: gradeLevel ?? dna.gradeLevel,
      targetExam: targetExam ?? dna.targetExam,
      learningStyle: learningStyle ?? dna.learningStyle,
      motivationLevel: motivationLevel ?? dna.motivationLevel,
      difficultyPreference: difficultyPreference ?? dna.difficultyPreference,
    );

    await saveDNA(updated);
  }

  // ═══════════════════════════════════════════════════════════════
  // SORU ÇÖZÜM VERİSİ TOPLAMA
  // ═══════════════════════════════════════════════════════════════

  /// Çözülen soruyu kaydet ve DNA'yı güncelle
  Future<void> recordQuestionAttempt({
    required String topic,
    required String subTopic,
    bool? isCorrect, // Null ise sadece çözüm istendi, Win/Loss yok
    required String difficulty,
    String? questionText,
    String? imageUrl,
    String? correctAnswer,
    String? userAnswer,
    String? failureReason,
    List<String>? keyConceptsMissing,
  }) async {
    final dna = await getDNA();
    if (dna == null) return;

    // Konu performansını güncelle
    final topicPerf = Map<String, TopicPerformance>.from(dna.topicPerformance);
    final existingTopic = topicPerf[topic];
    
    topicPerf[topic] = TopicPerformance(
      topic: topic,
      totalQuestions: (existingTopic?.totalQuestions ?? 0) + (isCorrect != null ? 1 : 0),
      correct: (existingTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0),
      wrong: (existingTopic?.wrong ?? 0) + (isCorrect == false ? 1 : 0),
      successRate: _calculateSuccessRate(
        (existingTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0),
        (existingTopic?.totalQuestions ?? 0) + (isCorrect != null ? 1 : 0),
      ),
      lastAttempt: DateTime.now(),
    );

    // Alt konu performansını güncelle
    final subTopicPerf = Map<String, SubTopicPerformance>.from(dna.subTopicPerformance);
    final existingSubTopic = subTopicPerf[subTopic];
    final subTopicCorrect = (existingSubTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0);
    final subTopicTotal = (existingSubTopic?.totalQuestions ?? 0) + (isCorrect != null ? 1 : 0);
    final subTopicRate = _calculateSuccessRate(subTopicCorrect, subTopicTotal);
    
    subTopicPerf[subTopic] = SubTopicPerformance(
      parentTopic: topic,
      subTopic: subTopic,
      totalQuestions: subTopicTotal,
      correct: subTopicCorrect,
      wrong: (existingSubTopic?.wrong ?? 0) + (isCorrect == false ? 1 : 0),
      successRate: subTopicRate,
      proficiencyLevel: _getProficiencyLevel(subTopicRate),
    );

    // Yanlış cevapları hazineye ekle
    List<FailedQuestion> failedQuestions = List.from(dna.failedQuestions);
    Map<String, int> errorPatterns = Map.from(dna.errorPatterns);
    
    if (isCorrect == false && questionText != null) {
      final reason = failureReason ?? FailureReasons.topicGap;
      
      failedQuestions.add(FailedQuestion(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        topic: topic,
        subTopic: subTopic,
        questionText: questionText,
        imageUrl: imageUrl,
        correctAnswer: correctAnswer ?? '',
        userAnswer: userAnswer,
        failureReason: reason,
        difficulty: difficulty,
        timestamp: DateTime.now(),
        keyConceptsMissing: keyConceptsMissing ?? [],
      ));

      // Hata pattern'ini güncelle
      errorPatterns[reason] = (errorPatterns[reason] ?? 0) + 1;
    }

    // Zayıf konuları belirle
    final weakTopics = _identifyWeakTopics(subTopicPerf);
    final strongTopics = _identifyStrongTopics(subTopicPerf);

    // Aktif saati kaydet
    final hour = DateTime.now().hour.toString();
    final activeHours = Map<String, int>.from(dna.activeHours);
    activeHours[hour] = (activeHours[hour] ?? 0) + 1;

    // 📊 Genel istatistikleri güncelle (Sadece isCorrect null değilse başarıyı etkiler)
    int totalCorrect = dna.totalCorrect;
    int totalWrong = dna.totalWrong;
    
    if (isCorrect != null) {
      if (isCorrect) {
        totalCorrect += 1;
      } else {
        totalWrong += 1;
      }
    }

    final totalQuestions = dna.totalQuestionsSolved + 1;

    final updated = dna.copyWith(
      totalQuestionsSolved: totalQuestions,
      totalCorrect: totalCorrect,
      totalWrong: totalWrong,
      overallSuccessRate: _calculateSuccessRate(totalCorrect, totalQuestions),
      topicPerformance: topicPerf,
      subTopicPerformance: subTopicPerf,
      weakTopics: weakTopics,
      strongTopics: strongTopics,
      failedQuestions: failedQuestions,
      errorPatterns: errorPatterns,
      activeHours: activeHours,
      totalAIInteractions: dna.totalAIInteractions + 1,
    );

    await saveDNA(updated);
  }

  // ═══════════════════════════════════════════════════════════════
  // BENZER SORU VERİSİ
  // ═══════════════════════════════════════════════════════════════

  /// Benzer soru pratiği tamamlandığında
  Future<void> recordPracticeSession({
    required String topic,
    required String subTopic,
    required int totalQuestions,
    required int correctAnswers,
    required bool completed,  // Tamamlandı mı yoksa bırakıldı mı?
    int? abandonedAtQuestion, // Kaçıncı soruda bırakıldı?
  }) async {
    final dna = await getDNA();
    if (dna == null) return;

    // Benzer soru tamamlama oranını güncelle
    final currentRate = dna.similarQuestionCompletionRate;
    final sessionRate = completed ? 100.0 : (abandonedAtQuestion ?? 0) / totalQuestions * 100;
    final newRate = (currentRate + sessionRate) / 2;

    // Bırakma noktasını kaydet
    List<AbandonmentPoint> abandonmentPoints = List.from(dna.abandonmentPoints);
    if (!completed && abandonedAtQuestion != null) {
      abandonmentPoints.add(AbandonmentPoint(
        topic: topic,
        subTopic: subTopic,
        screen: 'practice_screen',
        stage: 'benzer_soru',
        timestamp: DateTime.now(),
        questionIndex: abandonedAtQuestion,
      ));
    }

    final updated = dna.copyWith(
      similarQuestionCompletionRate: newRate,
      abandonmentPoints: abandonmentPoints,
    );

    await saveDNA(updated);
  }

  // ═══════════════════════════════════════════════════════════════
  // ÇALIŞMA SÜRESİ TAKİBİ
  // ═══════════════════════════════════════════════════════════════

  /// Çalışma süresi ekle (dakika)
  Future<void> addStudyTime(int minutes) async {
    final dna = await getDNA();
    if (dna == null) return;

    final updated = dna.copyWith(
      totalStudyMinutes: dna.totalStudyMinutes + minutes,
    );

    await saveDNA(updated);
  }

  // ═══════════════════════════════════════════════════════════════
  // ANALİZ VE ÖNERİLER
  // ═══════════════════════════════════════════════════════════════

  /// En zayıf konuları getir (öncelik sırasına göre)
  Future<List<WeakTopic>> getTopWeakTopics({int limit = 5}) async {
    final dna = await getDNA();
    if (dna == null) return [];

    final sorted = List<WeakTopic>.from(dna.weakTopics)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    
    return sorted.take(limit).toList();
  }

  /// Tekrar çözülmesi gereken soruları getir
  Future<List<FailedQuestion>> getQuestionsToReview({
    String? topic,
    int limit = 10,
  }) async {
    final dna = await getDNA();
    if (dna == null) return [];

    var questions = dna.failedQuestions.where((q) => !q.isReviewed);
    
    if (topic != null) {
      questions = questions.where((q) => q.topic == topic);
    }

    return questions.take(limit).toList();
  }

  /// Hata pattern özetini getir
  Future<Map<String, double>> getErrorPatternSummary() async {
    final dna = await getDNA();
    if (dna == null) return {};

    final total = dna.errorPatterns.values.fold(0, (a, b) => a + b);
    if (total == 0) return {};

    return dna.errorPatterns.map((key, value) => 
      MapEntry(key, value / total * 100)
    );
  }

  /// Öğrenme raporu için özet
  Future<Map<String, dynamic>> getLearningReport() async {
    final dna = await getDNA();
    if (dna == null) return {};

    return {
      'totalQuestions': dna.totalQuestionsSolved,
      'successRate': dna.overallSuccessRate,
      'weakTopics': dna.weakTopics.length,
      'strongTopics': dna.strongTopics.length,
      'studyTimeHours': dna.totalStudyMinutes / 60,
      'practiceCompletionRate': dna.similarQuestionCompletionRate,
      'topErrorPattern': _getTopErrorPattern(dna.errorPatterns),
    };
  }

  // ═══════════════════════════════════════════════════════════════
  // YARDIMCI FONKSİYONLAR
  // ═══════════════════════════════════════════════════════════════

  double _calculateSuccessRate(int correct, int total) {
    if (total == 0) return 0.0;
    return correct / total;
  }

  String _getProficiencyLevel(double rate) {
    if (rate >= 0.7) return 'strong';
    if (rate >= 0.4) return 'medium';
    return 'weak';
  }

  List<WeakTopic> _identifyWeakTopics(Map<String, SubTopicPerformance> subTopics) {
    return subTopics.entries
        .where((e) => e.value.successRate < 0.5 && e.value.totalQuestions >= 3)
        .map((e) => WeakTopic(
          topic: e.value.parentTopic,
          subTopic: e.value.subTopic,
          successRate: e.value.successRate,
          reason: FailureReasons.topicGap,
          priority: e.value.successRate < 0.3 ? 1 : 2,
          recommendations: _generateRecommendations(e.value),
        ))
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  List<String> _identifyStrongTopics(Map<String, SubTopicPerformance> subTopics) {
    return subTopics.entries
        .where((e) => e.value.successRate >= 0.7 && e.value.totalQuestions >= 3)
        .map((e) => e.value.subTopic)
        .toList();
  }

  List<String> _generateRecommendations(SubTopicPerformance perf) {
    final recommendations = <String>[];
    
    if (perf.successRate < 0.3) {
      recommendations.add('${perf.subTopic} konusunda temel kavramları tekrar gözden geçir.');
      recommendations.add('Bu konuda video ders izlemeni öneririm.');
    } else if (perf.successRate < 0.5) {
      recommendations.add('${perf.subTopic} konusunda daha fazla pratik yap.');
      recommendations.add('Yanlış yaptığın soruları tekrar çöz.');
    }
    
    return recommendations;
  }

  String? _getTopErrorPattern(Map<String, int> patterns) {
    if (patterns.isEmpty) return null;
    
    return patterns.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
