/// SOLICAP - Language Learning Service
/// İlerleme yönetimi, XP/streak, AI entegrasyonu, Firebase

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/language_models.dart';
import '../data/language_content_data.dart';
import 'auth_service.dart';
import 'leaderboard_service.dart';

class LanguageLearningService {
  static final LanguageLearningService _instance = LanguageLearningService._internal();
  factory LanguageLearningService() => _instance;
  LanguageLearningService._internal();

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
    debugPrint('✅ LanguageLearningService initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // İLERLEME YÖNETİMİ (Firebase)
  // ═══════════════════════════════════════════════════════════════

  CollectionReference get _progressCollection =>
      _firestore.collection('language_progress');

  CollectionReference get _lessonResultsCollection =>
      _firestore.collection('language_lesson_results');

  /// Kullanıcı ilerlemesini getir
  Future<LanguageProgress> getProgress() async {
    final userId = _authService.currentUserId;
    if (userId == null) return LanguageProgress(userId: '');

    try {
      final doc = await _progressCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return LanguageProgress.fromFirestore(data);
      }
      // İlk kez - yeni ilerleme oluştur
      final progress = LanguageProgress(userId: userId);
      await saveProgress(progress);
      return progress;
    } catch (e) {
      debugPrint('❌ Language Progress getirme hatası: $e');
      return LanguageProgress(userId: userId);
    }
  }

  /// İlerlemeyi kaydet
  Future<void> saveProgress(LanguageProgress progress) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      await _progressCollection.doc(userId).set(
        progress.toFirestore(),
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('❌ Language Progress kaydetme hatası: $e');
    }
  }

  /// İlerleme stream'i
  Stream<LanguageProgress> getProgressStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value(LanguageProgress(userId: ''));

    return _progressCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return LanguageProgress.fromFirestore(data);
      }
      return LanguageProgress(userId: userId);
    });
  }

  /// İlerlemeyi sıfırla
  Future<void> resetProgress() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final fresh = LanguageProgress(userId: userId);
      await _progressCollection.doc(userId).set(fresh.toFirestore());
      debugPrint('🔄 Language Progress sıfırlandı');
    } catch (e) {
      debugPrint('❌ Language Progress sıfırlama hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SEVİYE BELİRLEME TESTİ
  // ═══════════════════════════════════════════════════════════════

  List<PlacementQuestion> getPlacementQuestions() => placementQuestions;

  /// Seviye belirleme testini değerlendir ve seviye ata
  Future<LanguageProgress> evaluatePlacement(List<bool> answers) async {
    final progress = await getProgress();

    // Seviye başına doğru sayısını hesapla
    final levelCorrect = <LanguageLevel, int>{};
    for (int i = 0; i < answers.length && i < placementQuestions.length; i++) {
      final q = placementQuestions[i];
      if (answers[i]) {
        levelCorrect[q.level] = (levelCorrect[q.level] ?? 0) + 1;
      }
    }

    // Atanacak seviyeyi belirle
    LanguageLevel assignedLevel = LanguageLevel.a1;

    // Yukarıdan aşağıya kontrol - en yüksek geçilen seviye
    for (final level in LanguageLevel.values.reversed) {
      final correct = levelCorrect[level] ?? 0;
      final total = placementQuestions.where((q) => q.level == level).length;
      final rate = total > 0 ? correct / total : 0.0;
      
      if (rate >= 0.5) {
        // Bu seviyeyi geçtiyse bir üst seviyeye ata
        assignedLevel = level.next ?? level;
        break;
      }
    }

    final totalCorrect = answers.where((a) => a).length;
    final xpEarned = 100; // Seviye belirleme XP'si

    final updated = progress.copyWith(
      currentLevel: assignedLevel,
      placementDone: true,
      totalXP: progress.totalXP + xpEarned,
      dailyXP: progress.dailyXP + xpEarned,
      lastActiveDate: DateTime.now(),
    );

    await saveProgress(updated);
    debugPrint('✅ Seviye belirleme: ${assignedLevel.code} (${totalCorrect}/${answers.length} doğru)');
    return updated;
  }

  // ═══════════════════════════════════════════════════════════════
  // ÜNİTE & DERS YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Seviyeye ait üniteleri getir
  List<LanguageUnit> getUnits(LanguageLevel level) => getUnitsForLevel(level);

  /// Ünite içeriğini getir
  UnitContent? getContent(String unitId) => getUnitContent(unitId);

  /// Ünite kilitli mi?
  bool isUnitLocked(String unitId, LanguageProgress progress) {
    final units = getUnits(progress.currentLevel);
    final unitIndex = units.indexWhere((u) => u.id == unitId);
    
    if (unitIndex <= 0) return false; // İlk ünite her zaman açık

    // Önceki ünitenin tamamlanmış olması gerekir
    final prevUnit = units[unitIndex - 1];
    final prevProgress = progress.unitProgresses[prevUnit.id];
    return prevProgress == null || !prevProgress.isCompleted;
  }

  /// Ders kilitli mi?
  bool isLessonLocked(String unitId, LessonType lessonType, LanguageProgress progress) {
    final content = getContent(unitId);
    if (content == null) return true;

    final allUnits = [...a1Units, ...a2Units, ...b1Units];
    final unit = allUnits.firstWhere((u) => u.id == unitId, orElse: () => allUnits.first);
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
  Future<LanguageProgress> completeLesson({
    required String unitId,
    required LessonType lessonType,
    required int correctCount,
    required int totalCount,
  }) async {
    var progress = await getProgress();
    final score = totalCount > 0 ? (correctCount / totalCount * 100) : 0.0;

    // XP hesapla
    int xp = lessonType.baseXP;
    if (score == 100) xp *= 2; // Perfect bonus

    // Ünite ilerlemesini güncelle
    final unitProg = progress.unitProgresses[unitId] ?? const UnitProgress();
    final updatedLessons = Map<String, bool>.from(unitProg.lessonsCompleted);
    updatedLessons[lessonType.name] = true;

    // Ünite sınavı ise skoru kaydet
    double? examScore = unitProg.examScore;
    bool isUnitCompleted = unitProg.isCompleted;

    if (lessonType == LessonType.unitExam) {
      examScore = score;
      if (score >= 60) {
        isUnitCompleted = true;
      }
    }

    final updatedUnitProg = unitProg.copyWith(
      lessonsCompleted: updatedLessons,
      examScore: examScore,
      isCompleted: isUnitCompleted,
      unlockedAt: unitProg.unlockedAt ?? DateTime.now(),
    );

    final updatedUnits = Map<String, UnitProgress>.from(progress.unitProgresses);
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
      // Aynı gün
      newDailyXP += xp;
    } else if (daysDiff == 1) {
      // Ertesi gün - streak devam
      if (progress.dailyXP >= progress.dailyGoal) {
        newStreak += 1;
      }
      newDailyXP = xp;
    } else {
      // Streak kırıldı
      newStreak = 0;
      newDailyXP = xp;
    }

    final bestStreak = newStreak > progress.bestStreak ? newStreak : progress.bestStreak;

    // Skill score güncelle
    final updatedSkills = Map<String, double>.from(progress.skillScores);
    final skillKey = _lessonTypeToSkillKey(lessonType);
    if (skillKey != null) {
      final prevScore = updatedSkills[skillKey] ?? 50.0;
      updatedSkills[skillKey] = (prevScore * 0.7 + score * 0.3).clamp(0, 100);
    }

    // Seviye atlama kontrolü
    final newTotalXP = progress.totalXP + xp;
    var newLevel = progress.currentLevel;
    // XP eşiğini geçtiyse seviye atla
    int consumedXP = 0;
    for (final l in LanguageLevel.values) {
      final threshold = LanguageProgress.levelUpXP[l] ?? 600;
      if (consumedXP + threshold <= newTotalXP && l != LanguageLevel.c1) {
        consumedXP += threshold;
        newLevel = l.next ?? l;
      } else {
        break;
      }
    }

    progress = progress.copyWith(
      currentLevel: newLevel,
      totalXP: newTotalXP,
      dailyXP: newDailyXP,
      currentStreak: newStreak,
      bestStreak: bestStreak,
      lastActiveDate: now,
      unitProgresses: updatedUnits,
      skillScores: updatedSkills,
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
    );

    // 🏆 Tüm Zamanlar liderboard puanı
    try {
      await LeaderboardService().addPoints(15, 'language_lesson_complete');
    } catch (_) {}

    debugPrint('✅ Ders tamamlandı: $unitId/${lessonType.name} - $xp XP');
    return progress;
  }

  Future<void> _saveLessonResult({
    required String unitId,
    required LessonType lessonType,
    required int correctCount,
    required int totalCount,
    required int xpEarned,
    required double score,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final result = LessonResult(
        id: '${unitId}_${lessonType.name}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        unitId: unitId,
        lessonType: lessonType,
        correctCount: correctCount,
        totalCount: totalCount,
        xpEarned: xpEarned,
        score: score,
      );

      await _lessonResultsCollection.add(result.toFirestore());
    } catch (e) {
      debugPrint('❌ Ders sonucu kaydetme hatası: $e');
    }
  }

  String? _lessonTypeToSkillKey(LessonType type) {
    switch (type) {
      case LessonType.grammar:
        return 'grammar';
      case LessonType.vocabulary:
        return 'vocabulary';
      case LessonType.reading:
        return 'reading';
      case LessonType.listening:
        return 'listening';
      case LessonType.speaking:
        return 'speaking';
      default:
        return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // AI ZENGİNLEŞTİRME
  // ═══════════════════════════════════════════════════════════════

  /// AI ile Grammar açıklamasını zenginleştir
  Future<String?> enrichGrammarExplanation(String topic, String rule, LanguageLevel level) async {
    if (_aiModel == null) return null;

    try {
      final prompt = '''
Sen bir İngilizce öğretmenisin. Seviye: ${level.code} (${level.label}).
Konu: $topic
Kural: $rule

Bu kuralı öğrenciye 3-4 cümleyle basit ve anlaşılır şekilde açıkla.
Sonra 2 ekstra örnek cümle ver (İngilizce + Türkçe çevirisi).
Kısa ve net ol. Emoji kullanma.
''';

      final response = await _aiModel!.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      debugPrint('❌ AI grammar enrichment hatası: $e');
      return null;
    }
  }

  /// AI ile Reading paragrafı üret
  Future<String?> generateReadingPassage(String topic, List<String> keywords, LanguageLevel level) async {
    if (_aiModel == null) return null;

    try {
      final prompt = '''
Sen bir İngilizce öğretmenisin. ${level.code} seviyesinde bir okuma paragrafı yaz.
Konu: $topic
Anahtar kelimeler: ${keywords.join(', ')}

Kurallar:
- ${level == LanguageLevel.a1 ? '60-80' : '100-150'} kelime olsun
- Basit ve anlaşılır cümleler kullan
- Seviyeye uygun kelime ve gramer kullan
- Sadece paragrafı yaz, başka bir şey ekleme
''';

      final response = await _aiModel!.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      debugPrint('❌ AI reading passage hatası: $e');
      return null;
    }
  }

  /// AI ile Speaking cevabını değerlendir
  Future<Map<String, dynamic>?> evaluateSpeakingResponse(
    String scenario,
    String expectedContext,
    String userResponse,
    LanguageLevel level,
  ) async {
    if (_aiModel == null) return null;

    try {
      final prompt = '''
Sen bir İngilizce öğretmenisin. Seviye: ${level.code}.
Senaryo: $scenario
Beklenen bağlam: $expectedContext
Öğrencinin cevabı: "$userResponse"

Değerlendir:
1. Gramer doğru mu? (evet/hayır)
2. Bağlama uygun mu? (evet/hayır)  
3. Kısa geri bildirim (1-2 cümle, Türkçe)
4. Düzeltilmiş/önerilen cevap (İngilizce)

JSON formatında yanıt ver:
{"grammarOk": true/false, "contextOk": true/false, "feedback": "...", "suggestion": "..."}
''';

      final response = await _aiModel!.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      
      // Basit JSON parse
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}');
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        final jsonStr = text.substring(jsonStart, jsonEnd + 1);
        // Manual parse for safety
        return {
          'grammarOk': jsonStr.contains('"grammarOk": true') || jsonStr.contains('"grammarOk":true'),
          'contextOk': jsonStr.contains('"contextOk": true') || jsonStr.contains('"contextOk":true'),
          'feedback': _extractJsonValue(jsonStr, 'feedback'),
          'suggestion': _extractJsonValue(jsonStr, 'suggestion'),
        };
      }
      return null;
    } catch (e) {
      debugPrint('❌ AI speaking evaluation hatası: $e');
      return null;
    }
  }

  String _extractJsonValue(String json, String key) {
    final pattern = '"$key": "';
    final altPattern = '"$key":"';
    var start = json.indexOf(pattern);
    if (start >= 0) {
      start += pattern.length;
    } else {
      start = json.indexOf(altPattern);
      if (start >= 0) {
        start += altPattern.length;
      } else {
        return '';
      }
    }
    final end = json.indexOf('"', start);
    if (end > start) return json.substring(start, end);
    return '';
  }
}
