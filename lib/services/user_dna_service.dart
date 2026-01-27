/// SOLICAP - User DNA Service
/// Merkezi veri bankası servisi - Uygulamanın her yerinden erişilebilir

import 'dart:math' as math;
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

  /// Kullanıcı ID'sini getir
  Future<String?> getUserId() async {
    return _authService.currentUserId;
  }

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
        // 📉 Her açılışta veya fetch işleminde decay kontrolü yap
        await applyDNADecay();
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

  /// 🔄 Anlık DNA akışını getir (Real-time sync)
  Stream<UserDNA?> getDNAStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value(null);

    return _dnaCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final dna = UserDNA.fromFirestore(doc);
      _cachedDNA = dna; // Bellek içi cache'i de taze tutalım
      return dna;
    });
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
  // 👤 KULLANICI İSİM YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Kullanıcının görünen ismini getir (yoksa otomatik kod üret)
  Future<String> getDisplayName() async {
    final dna = await getDNA();
    if (dna == null) return 'Öğrenci';
    
    // İsim varsa döndür
    if (dna.userName != null && dna.userName!.isNotEmpty) {
      return dna.userName!;
    }
    
    // Yoksa yeni kod üret ve kaydet
    final newName = await _generateUniqueCode();
    await updateDisplayName(newName);
    return newName;
  }

  /// Kullanıcının görünen ismini güncelle
  Future<void> updateDisplayName(String name) async {
    final dna = await getDNA();
    if (dna == null) return;

    final updated = dna.copyWith(userName: name);
    await saveDNA(updated);
    debugPrint('👤 İsim güncellendi: $name');
  }

  /// Benzersiz öğrenci kodu üret (Öğrenci T1, T2, T3...)
  Future<String> _generateUniqueCode() async {
    try {
      // Firestore'da mevcut en yüksek numarayı bul
      final snapshot = await _firestore
          .collection('user_dna')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .get();

      int maxNumber = 0;
      final regex = RegExp(r'Öğrenci T(\d+)');
      
      for (final doc in snapshot.docs) {
        final name = doc.data()['userName'] as String?;
        if (name != null) {
          final match = regex.firstMatch(name);
          if (match != null) {
            final num = int.tryParse(match.group(1) ?? '0') ?? 0;
            if (num > maxNumber) maxNumber = num;
          }
        }
      }

      return 'Öğrenci T${maxNumber + 1}';
    } catch (e) {
      debugPrint('⚠️ Kod üretme hatası: $e');
      // Fallback: rastgele kod
      return 'Öğrenci T${DateTime.now().millisecondsSinceEpoch % 10000}';
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SORU ÇÖZÜM VERİSİ TOPLAMA
  // ═══════════════════════════════════════════════════════════════

  /// 🔄 SubTopic'i normalize et: Parantez içindeki detayları kaldır
  /// Örnek: "Yazım Kuralları (ki'nin Yazımı)" → "Yazım Kuralları"
  String _normalizeSubTopic(String subTopic) {
    // Parantez içindeki kısmı kaldır
    final normalized = subTopic.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();
    return normalized.isNotEmpty ? normalized : subTopic;
  }

  /// 🔄 Topic'i normalize et: İngilizce ders adlarını Türkçe'ye çevir
  /// Örnek: "Turkish" → "Türkçe", "Mathematics" → "Matematik"
  String _normalizeTopic(String topic) {
    const Map<String, String> translations = {
      'Turkish': 'Türkçe',
      'turkish': 'Türkçe',
      'Mathematics': 'Matematik',
      'mathematics': 'Matematik',
      'Physics': 'Fizik',
      'physics': 'Fizik',
      'Chemistry': 'Kimya',
      'chemistry': 'Kimya',
      'Biology': 'Biyoloji',
      'biology': 'Biyoloji',
      'History': 'Tarih',
      'history': 'Tarih',
      'Geography': 'Coğrafya',
      'geography': 'Coğrafya',
      'Literature': 'Edebiyat',
      'literature': 'Edebiyat',
      'Philosophy': 'Felsefe',
      'philosophy': 'Felsefe',
      'Religion': 'Din Kültürü',
      'religion': 'Din Kültürü',
      'English': 'İngilizce',
      'english': 'İngilizce',
    };
    return translations[topic] ?? topic;
  }

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

    // 🔄 Topic ve SubTopic'i normalize et
    final normalizedTopic = _normalizeTopic(topic);
    final normalizedSubTopic = _normalizeSubTopic(subTopic);

    // 🧪 Ağırlıklı performans ve ardışık doğru sayısını hesapla
    final isWin = isCorrect == true;
    final isLoss = isCorrect == false;
    
    // Alt konu performansını güncelle
    final subTopicPerf = Map<String, SubTopicPerformance>.from(dna.subTopicPerformance);
    final existingSubTopic = subTopicPerf[normalizedSubTopic];
    
    // 🔧 Her soru çözüldüğünde totalQuestions artmalı (isCorrect null olsa bile)
    final subTopicTotal = (existingSubTopic?.totalQuestions ?? 0) + 1;
    final subTopicCorrect = (existingSubTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0);
    final subTopicRate = _calculateSuccessRate(subTopicCorrect, subTopicTotal);
    
    // Ardışık doğru sayısını güncelle
    int newConsecutive = existingSubTopic?.consecutiveCorrect ?? 0;
    if (isWin) {
      newConsecutive += 1;
    } else if (isLoss) {
      newConsecutive = 0;
    }

    // Ağırlıklı Puan (Recursive Weighted Average)
    double newWeighted = existingSubTopic?.weightedProficiency ?? 0.5; // Başlangıç nötr
    if (isCorrect != null) {
      const double alpha = 0.15; // Öğrenme katsayısı
      final double result = isWin ? 1.0 : 0.0;
      newWeighted = (newWeighted * (1 - alpha)) + (result * alpha);
    }
    
    // Mastery ve Seviye Kontrolü
    String newLevel = _getProficiencyLevel(newWeighted);
    if (newConsecutive >= 5 && (difficulty == 'hard' || difficulty == 'medium')) {
      newLevel = 'mastered';
    }

    subTopicPerf[normalizedSubTopic] = SubTopicPerformance(
      parentTopic: normalizedTopic,
      subTopic: normalizedSubTopic,
      totalQuestions: subTopicTotal,
      correct: subTopicCorrect,
      wrong: (existingSubTopic?.wrong ?? 0) + (isCorrect == false ? 1 : 0),
      successRate: subTopicRate,
      weightedProficiency: newWeighted,
      consecutiveCorrect: newConsecutive,
      proficiencyLevel: newLevel,
      lastUpdate: DateTime.now(),
    );

    // Ana konu performansını güncelle
    final topicPerf = Map<String, TopicPerformance>.from(dna.topicPerformance);
    final existingTopic = topicPerf[normalizedTopic];
    
    // Ana konu puanı, alt konuların ağırlıklı ortalaması olsun
    final relatedSubTopics = subTopicPerf.values.where((s) => s.parentTopic == normalizedTopic);
    final avgWeighted = relatedSubTopics.isEmpty 
        ? newWeighted 
        : relatedSubTopics.map((s) => s.weightedProficiency).reduce((a, b) => a + b) / relatedSubTopics.length;

    topicPerf[normalizedTopic] = TopicPerformance(
      topic: normalizedTopic,
      totalQuestions: (existingTopic?.totalQuestions ?? 0) + 1,
      correct: (existingTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0),
      wrong: (existingTopic?.wrong ?? 0) + (isCorrect == false ? 1 : 0),
      successRate: _calculateSuccessRate(
        (existingTopic?.correct ?? 0) + (isCorrect == true ? 1 : 0),
        (existingTopic?.totalQuestions ?? 0) + 1,
      ),
      weightedProficiency: avgWeighted,
      consecutiveCorrect: 0, // Ana konu için takip edilmiyor
      lastAttempt: DateTime.now(),
    );

    // Çözüm istenen veya yanlış yapılan soruları kaydet (mikro ders analizi için)
    List<FailedQuestion> failedQuestions = List.from(dna.failedQuestions);
    Map<String, int> errorPatterns = Map.from(dna.errorPatterns);
    
    // isCorrect == null: Öğrenci çözemedi, AI'a çözdürdü (struggle göstergesi)
    // isCorrect == false: Öğrenci yanlış yaptı
    if ((isCorrect == null || isCorrect == false) && questionText != null) {
      final reason = isCorrect == null 
          ? 'AI çözümü istendi' 
          : (failureReason ?? FailureReasons.topicGap);
      
      failedQuestions.add(FailedQuestion(
        questionId: DateTime.now().millisecondsSinceEpoch.toString(),
        topic: normalizedTopic,
        subTopic: normalizedSubTopic,
        questionText: questionText,
        imageUrl: imageUrl,
        correctAnswer: correctAnswer ?? '',
        userAnswer: userAnswer,
        failureReason: reason,
        difficulty: difficulty,
        timestamp: DateTime.now(),
        keyConceptsMissing: keyConceptsMissing ?? [],
      ));

      // Hata pattern'ini güncelle (sadece gerçek yanlışlar için)
      if (isCorrect == false) {
        errorPatterns[reason] = (errorPatterns[reason] ?? 0) + 1;
      }
    }

    // Listeleri güncelle
    final weakTopics = _identifyWeakTopics(subTopicPerf);
    final strongTopics = _identifyStrongTopics(subTopicPerf);

    // Aktif saati kaydet
    final hour = DateTime.now().hour.toString();
    final activeHours = Map<String, int>.from(dna.activeHours);
    activeHours[hour] = (activeHours[hour] ?? 0) + 1;

    // 📊 Genel istatistikleri güncelle
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
    if (rate >= 0.8) return 'strong';
    if (rate >= 0.5) return 'medium';
    return 'weak';
  }

  /// 📉 Ebbinghaus Unutma Eğrisi Uygula (DNA Decay)
  /// Bu metot her DNA getirme işleminde veya periyodik olarak çağrılabilir.
  Future<void> applyDNADecay() async {
    final dna = await getDNA();
    if (dna == null) return;

    final subTopicPerf = Map<String, SubTopicPerformance>.from(dna.subTopicPerformance);
    bool changed = false;
    final now = DateTime.now();

    subTopicPerf.forEach((key, perf) {
      final daysSince = now.difference(perf.lastUpdate).inDays;
      
      // 3 günden az ise decay başlatma (Mola payı)
      if (daysSince >= 3) {
        // Mastery durumuna göre lambda (decay hızı) belirle
        // Normal: 0.05 (Hızlı unutma), Mastered: 0.01 (%80 daha yavaş)
        final isMastered = perf.proficiencyLevel == 'mastered';
        final double lambda = isMastered ? 0.01 : 0.05;
        
        // P = P * e^(-lambda * t) - Ebbinghaus Unutma Eğrisi
        final double decayFactor = math.exp(-lambda * (daysSince - 3));
        final newWeighted = (perf.weightedProficiency * decayFactor).clamp(0.0, 1.0);
        
        if ((perf.weightedProficiency - newWeighted).abs() > 0.01) {
          subTopicPerf[key] = SubTopicPerformance(
            parentTopic: perf.parentTopic,
            subTopic: perf.subTopic,
            totalQuestions: perf.totalQuestions,
            correct: perf.correct,
            wrong: perf.wrong,
            successRate: perf.successRate,
            weightedProficiency: newWeighted,
            consecutiveCorrect: isMastered ? perf.consecutiveCorrect : 0, 
            proficiencyLevel: isMastered ? 'mastered' : _getProficiencyLevel(newWeighted),
            lastUpdate: now,
          );
          changed = true;
        }
      }
    });

    if (changed) {
      // Ana konuları da güncelle
      final topicPerf = Map<String, TopicPerformance>.from(dna.topicPerformance);
      topicPerf.forEach((topicName, perf) {
        final related = subTopicPerf.values.where((s) => s.parentTopic == topicName);
        if (related.isNotEmpty) {
          final avg = related.map((s) => s.weightedProficiency).reduce((a, b) => a + b) / related.length;
          topicPerf[topicName] = TopicPerformance(
            topic: perf.topic,
            totalQuestions: perf.totalQuestions,
            correct: perf.correct,
            wrong: perf.wrong,
            successRate: perf.successRate,
            weightedProficiency: avg,
            consecutiveCorrect: perf.consecutiveCorrect,
            lastAttempt: perf.lastAttempt,
          );
        }
      });

      final updated = dna.copyWith(
        subTopicPerformance: subTopicPerf,
        topicPerformance: topicPerf,
        weakTopics: _identifyWeakTopics(subTopicPerf),
        strongTopics: _identifyStrongTopics(subTopicPerf),
      );
      await saveDNA(updated);
      debugPrint('📉 DNA Decay applied to topics that haven\'t been studied.');
    }
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
