/// SOLICAP - STEM Learning Service
/// İlerleme yönetimi, XP/streak, AI entegrasyonu, Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/stem_models.dart';
import '../data/stem_content_data.dart';
import 'auth_service.dart';
import 'leaderboard_service.dart';
import 'notification_service.dart';

class StemLearningService {
  static final StemLearningService _instance = StemLearningService._internal();
  factory StemLearningService() => _instance;
  StemLearningService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  GenerativeModel? _aiModel;
  bool _isInitialized = false;

  // ═══════════════════════════════════════════════════════════════
  // BAŞLATMA
  // ═══════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      _aiModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 2048,
        ),
      );
    }

    _isInitialized = true;
    debugPrint('✅ StemLearningService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // İLERLEME YÖNETİMİ (Firebase)
  // ═══════════════════════════════════════════════════════════════

  /// Firestore doc ID: userId_gradeCode_subjectCode
  String _progressDocId(String userId, GradeLevel grade, StemSubject subject) =>
      '${userId}_${grade.code}_${subject.code}';

  CollectionReference get _progressCollection =>
      _firestore.collection('stem_progress');

  CollectionReference get _lessonResultsCollection =>
      _firestore.collection('stem_lesson_results');

  /// Kullanıcı ilerlemesini getir
  Future<StemProgress> getProgress(GradeLevel grade, StemSubject subject) async {
    final userId = _authService.currentUserId;
    if (userId == null) {
      return StemProgress(userId: '', gradeLevel: grade, subject: subject);
    }

    try {
      final docId = _progressDocId(userId, grade, subject);
      final doc = await _progressCollection.doc(docId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return StemProgress.fromFirestore(data);
      }
      // İlk kez - yeni ilerleme oluştur
      final progress = StemProgress(userId: userId, gradeLevel: grade, subject: subject);
      await saveProgress(progress);
      return progress;
    } catch (e) {
      debugPrint('❌ STEM Progress getirme hatası: $e');
      return StemProgress(userId: userId, gradeLevel: grade, subject: subject);
    }
  }

  /// İlerlemeyi kaydet
  Future<void> saveProgress(StemProgress progress) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final docId = _progressDocId(userId, progress.gradeLevel, progress.subject);
      await _progressCollection.doc(docId).set(
        progress.toFirestore(),
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('❌ STEM Progress kaydetme hatası: $e');
    }
  }

  /// İlerleme stream'i
  Stream<StemProgress> getProgressStream(GradeLevel grade, StemSubject subject) {
    final userId = _authService.currentUserId;
    if (userId == null) {
      return Stream.value(StemProgress(userId: '', gradeLevel: grade, subject: subject));
    }

    final docId = _progressDocId(userId, grade, subject);
    return _progressCollection.doc(docId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return StemProgress.fromFirestore(data);
      }
      return StemProgress(userId: userId, gradeLevel: grade, subject: subject);
    });
  }

  /// İlerlemeyi sıfırla
  Future<void> resetProgress(GradeLevel grade, StemSubject subject) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final docId = _progressDocId(userId, grade, subject);
      final fresh = StemProgress(userId: userId, gradeLevel: grade, subject: subject);
      await _progressCollection.doc(docId).set(fresh.toFirestore());
      debugPrint('🔄 STEM Progress sıfırlandı: ${grade.code}/${subject.code}');
    } catch (e) {
      debugPrint('❌ STEM Progress sıfırlama hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ÜNİTE & DERS YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Sınıf ve derse ait üniteleri getir
  List<StemUnit> getUnits(GradeLevel grade, StemSubject subject) =>
      getStemUnitsForGradeSubject(grade, subject);

  /// Ünite içeriğini getir
  StemUnitContent? getContent(String unitId) => getStemUnitContent(unitId);

  /// Ünite kilitli mi?
  bool isUnitLocked(String unitId, StemProgress progress) {
    final units = getUnits(progress.gradeLevel, progress.subject);
    final unitIndex = units.indexWhere((u) => u.id == unitId);

    if (unitIndex <= 0) return false; // İlk ünite her zaman açık

    // Önceki ünitenin tamamlanmış olması gerekir
    final prevUnit = units[unitIndex - 1];
    final prevProgress = progress.unitProgresses[prevUnit.id];
    return prevProgress == null || !prevProgress.isCompleted;
  }

  /// Ders kilitli mi?
  bool isLessonLocked(String unitId, StemLessonType lessonType, StemProgress progress) {
    final units = getUnits(progress.gradeLevel, progress.subject);
    final unit = units.firstWhere(
      (u) => u.id == unitId,
      orElse: () => units.first,
    );
    final lessonOrder = unit.lessonOrder;
    final lessonIndex = lessonOrder.indexOf(lessonType);

    if (lessonIndex <= 0) return false; // İlk ders her zaman açık

    // Önceki dersin tamamlanmış olması gerekir
    final prevLesson = lessonOrder[lessonIndex - 1];
    final unitProgress = progress.unitProgresses[unitId];
    return unitProgress == null || !unitProgress.isLessonCompleted(prevLesson);
  }

  // ═══════════════════════════════════════════════════════════════
  // DERS TAMAMLAMA & XP
  // ═══════════════════════════════════════════════════════════════

  /// Ders sonucunu işle: XP ekle, ilerleme güncelle, streak kontrol
  Future<StemProgress> completeLesson({
    required GradeLevel gradeLevel,
    required StemSubject subject,
    required String unitId,
    required StemLessonType lessonType,
    required int correctCount,
    required int totalCount,
    int? timeSpentSeconds,
  }) async {
    var progress = await getProgress(gradeLevel, subject);
    final score = totalCount > 0 ? (correctCount / totalCount * 100) : 0.0;

    // XP hesapla
    int xp = lessonType.baseXP;
    if (score == 100) xp = (xp * 1.5).round(); // Perfect bonus
    // Hız testi bonusu
    if (lessonType == StemLessonType.speedTest && timeSpentSeconds != null) {
      if (timeSpentSeconds < 60) {
        xp += 15; // 1 dakikadan kısa
      } else if (timeSpentSeconds < 120) {
        xp += 10; // 2 dakikadan kısa
      }
    }

    // Ünite ilerlemesini güncelle
    // TYT/AYT ünitelerinde 3 aşama, standart ünitelerde 5 aşama
    final units = getUnits(gradeLevel, subject);
    final unit = units.firstWhere((u) => u.id == unitId, orElse: () => units.first);
    final unitProg = progress.unitProgresses[unitId] ?? StemUnitProgress(totalLessons: unit.lessonOrder.length);
    final updatedLessons = Map<String, bool>.from(unitProg.lessonsCompleted);
    updatedLessons[lessonType.name] = true;

    // Sınav ise skoru kaydet
    double? examScore = unitProg.examScore;
    double? bestExamScore = unitProg.bestExamScore;
    bool isUnitCompleted = unitProg.isCompleted;
    int attempts = unitProg.attempts;

    if (lessonType == StemLessonType.topicExam) {
      examScore = score;
      attempts += 1;
      if (bestExamScore == null || score > bestExamScore) {
        bestExamScore = score;
      }
      if (score >= 60) {
        isUnitCompleted = true;
      }
    }

    final updatedUnitProg = unitProg.copyWith(
      lessonsCompleted: updatedLessons,
      examScore: examScore,
      bestExamScore: bestExamScore,
      isCompleted: isUnitCompleted,
      attempts: attempts,
      unlockedAt: unitProg.unlockedAt ?? DateTime.now(),
    );

    final updatedUnits = Map<String, StemUnitProgress>.from(progress.unitProgresses);
    updatedUnits[unitId] = updatedUnitProg;

    // Streak kontrolü
    final now = DateTime.now();
    final lastActive = progress.lastActiveDate;
    final daysDiff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(lastActive.year, lastActive.month, lastActive.day))
        .inDays;

    int newStreak = progress.currentStreak;
    int newDailyXP = progress.dailyXP;

    if (daysDiff == 0) {
      newDailyXP += xp;
    } else if (daysDiff == 1) {
      if (progress.dailyXP >= progress.dailyGoal) {
        newStreak += 1;
      }
      newDailyXP = xp;
    } else {
      newStreak = 0;
      newDailyXP = xp;
    }

    final bestStreak = newStreak > progress.bestStreak ? newStreak : progress.bestStreak;

    progress = progress.copyWith(
      totalXP: progress.totalXP + xp,
      dailyXP: newDailyXP,
      currentStreak: newStreak,
      bestStreak: bestStreak,
      lastActiveDate: now,
      unitProgresses: updatedUnits,
    );

    await saveProgress(progress);

    // Ders sonucunu kaydet
    await _saveLessonResult(
      unitId: unitId,
      lessonType: lessonType,
      correctCount: correctCount,
      totalCount: totalCount,
      xpEarned: xp,
      score: score,
      timeSpentSeconds: timeSpentSeconds,
    );

    // 🏆 Tüm Zamanlar liderboard puanı
    try {
      await LeaderboardService().addPoints(15, 'stem_lesson_complete');
    } catch (_) {}

    // 🔔 Bildirim hook'ları
    try {
      final notifService = NotificationService();
      if (lessonType == StemLessonType.practice) {
        // Pratik bitti ama sınav henüz çözülmedi -> yarım ünite
        await notifService.markIncompleteUnit(unit.titleTr);
      } else if (lessonType == StemLessonType.topicExam && isUnitCompleted) {
        // Sınav başarıyla geçildi -> yarım ünite kaydını temizle
        await notifService.clearIncompleteUnit();
      }
    } catch (_) {}

    debugPrint('✅ STEM Ders tamamlandı: $unitId/${lessonType.name} - $xp XP');
    return progress;
  }

  Future<void> _saveLessonResult({
    required String unitId,
    required StemLessonType lessonType,
    required int correctCount,
    required int totalCount,
    required int xpEarned,
    required double score,
    int? timeSpentSeconds,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final result = StemLessonResult(
        id: '${unitId}_${lessonType.name}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        unitId: unitId,
        lessonType: lessonType,
        correctCount: correctCount,
        totalCount: totalCount,
        xpEarned: xpEarned,
        score: score,
        timeSpentSeconds: timeSpentSeconds,
      );

      await _lessonResultsCollection.add(result.toFirestore());
    } catch (e) {
      debugPrint('❌ STEM Ders sonucu kaydetme hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // AI FONKSİYONLARI
  // ═══════════════════════════════════════════════════════════════

  /// AI ile ipucu üret (30 sn timeout)
  Future<String?> generateHint(String question, GradeLevel grade) async {
    if (_aiModel == null) return null;

    try {
      final prompt = '''
Sen bir ${grade.label} matematik öğretmenisin.
Soru: $question

Bu soru için kısa bir ipucu ver. Cevabı direkt söyleme, sadece çözüme yönlendir.
1-2 cümle ile ipucu ver. Öğrenci seviyesine uygun ol.
''';

      final response = await _aiModel!.generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 30));
      return response.text;
    } catch (e) {
      debugPrint('❌ AI ipucu hatası: $e');
      return null;
    }
  }

  /// AI ile konu zenginleştirme (30 sn timeout)
  Future<String?> enrichTopicExplanation(String topicSummary, GradeLevel grade) async {
    if (_aiModel == null) return null;

    try {
      final prompt = '''
Sen bir ${grade.label} matematik öğretmenisin.
Konu: $topicSummary

Bu konuyu öğrenciye 4-5 cümleyle daha anlaşılır şekilde açıkla.
Günlük hayattan 1-2 örnek ver.
Kısa ve net ol. Emoji kullanma.
''';

      final response = await _aiModel!.generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 30));
      return response.text;
    } catch (e) {
      debugPrint('❌ AI konu zenginleştirme hatası: $e');
      return null;
    }
  }
}
