/// SOLICAP - Session Tracking Service
/// Soru çözüm oturumlarını takip eden merkezi servis
/// Sprint 1 - Data Foundation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/question_session_model.dart';
import '../models/learning_event_model.dart';
import 'auth_service.dart';

class SessionTrackingService {
  static final SessionTrackingService _instance = SessionTrackingService._internal();
  factory SessionTrackingService() => _instance;
  SessionTrackingService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Aktif oturum
  QuestionSession? _currentSession;
  DateTime? _sessionStartTime;
  int _hintCount = 0;
  int _socraticSteps = 0;

  /// Aktif oturum var mı?
  bool get hasActiveSession => _currentSession != null;

  /// Aktif oturum ID'si
  String? get currentSessionId => _currentSession?.sessionId;

  // ═══════════════════════════════════════════════════════════════
  // 🚀 OTURUM YAŞAM DÖNGÜSÜ
  // ═══════════════════════════════════════════════════════════════

  /// Yeni oturum başlat
  Future<String> startSession({
    String? questionId,
    String? subject,
    String? topic,
    String? subTopic,
    String? difficulty,
    String? questionTargetLevel,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Kullanıcı oturum açmamış');

    // Eğer önceki oturum varsa kapat
    if (_currentSession != null) {
      await endSession(wasAbandoned: true);
    }

    // Yeni oturum oluştur
    _sessionStartTime = DateTime.now();
    _hintCount = 0;
    _socraticSteps = 0;

    final sessionId = _firestore.collection('question_sessions').doc().id;

    _currentSession = QuestionSession(
      sessionId: sessionId,
      questionId: questionId,
      userId: userId,
      startTime: _sessionStartTime!,
      subject: subject,
      topic: topic,
      subTopic: subTopic,
      difficulty: difficulty,
      questionTargetLevel: questionTargetLevel,
    );

    // Event log
    await _logEvent(LearningEventType.questionStarted, {
      'subject': subject,
      'topic': topic,
    });

    debugPrint('📊 Oturum başlatıldı: $sessionId');
    return sessionId;
  }

  /// Oturumu sonlandır
  Future<QuestionSession?> endSession({
    bool wasAbandoned = false,
    bool? isCorrect,
    String? selectedAnswer,
    String? correctAnswer,
    String? errorCategory,
    List<String>? misconceptions,
  }) async {
    if (_currentSession == null || _sessionStartTime == null) {
      debugPrint('⚠️ Aktif oturum yok');
      return null;
    }

    final endTime = DateTime.now();
    final totalTimeMs = endTime.difference(_sessionStartTime!).inMilliseconds;

    // Bilişsel yük seviyesini hesapla
    final cognitiveLoad = _calculateCognitiveLoad(
      totalTimeMs: totalTimeMs,
      hintCount: _hintCount,
      wasAbandoned: wasAbandoned,
    );

    // Oturumu güncelle
    final completedSession = _currentSession!.copyWith(
      endTime: endTime,
      totalTimeMs: totalTimeMs,
      hintRequestCount: _hintCount,
      socraticStepsUsed: _socraticSteps,
      wasAbandoned: wasAbandoned,
      endReason: wasAbandoned ? SessionEndReason.abandoned : SessionEndReason.completed,
      isCorrect: isCorrect,
      selectedAnswer: selectedAnswer,
      correctAnswer: correctAnswer,
      errorCategory: errorCategory,
      misconceptions: misconceptions ?? [],
      cognitiveLoadLevel: cognitiveLoad,
    );

    // Firestore'a kaydet
    try {
      await _firestore
          .collection('question_sessions')
          .doc(completedSession.sessionId)
          .set(completedSession.toFirestore());

      // Event log
      if (wasAbandoned) {
        await _logEvent(LearningEventType.questionAbandoned, {
          'timeSpentMs': totalTimeMs,
        });
      } else {
        await _logEvent(LearningEventType.answerSubmitted, {
          'isCorrect': isCorrect,
          'timeSpentMs': totalTimeMs,
        });
      }

      // Günlük snapshot'ı güncelle
      await _updateDailySnapshot(completedSession);

      debugPrint('✅ Oturum tamamlandı: ${completedSession.sessionId} (${completedSession.durationFormatted})');
    } catch (e) {
      debugPrint('❌ Oturum kayıt hatası: $e');
    }

    // Oturumu temizle
    _currentSession = null;
    _sessionStartTime = null;
    _hintCount = 0;
    _socraticSteps = 0;

    return completedSession;
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 ETKİLEŞİM TAKİBİ
  // ═══════════════════════════════════════════════════════════════

  /// İpucu istendi
  Future<void> recordHintRequest() async {
    _hintCount++;
    
    await _logEvent(LearningEventType.hintRequested, {
      'hintNumber': _hintCount,
    });
    
    debugPrint('💡 İpucu istendi (#$_hintCount)');
  }

  /// Sokratik adım tamamlandı
  Future<void> recordSocraticStep() async {
    _socraticSteps++;
    
    await _logEvent(LearningEventType.socraticStepCompleted, {
      'stepNumber': _socraticSteps,
    });
    
    debugPrint('🦉 Sokratik adım (#$_socraticSteps)');
  }

  /// Çözüm görüntülendi
  Future<void> recordSolutionViewed() async {
    await _logEvent(LearningEventType.solutionViewed, {});
  }

  // ═══════════════════════════════════════════════════════════════
  // 🧠 BİLİŞSEL YÜK HESAPLAMA
  // ═══════════════════════════════════════════════════════════════

  CognitiveLoadLevel _calculateCognitiveLoad({
    required int totalTimeMs,
    required int hintCount,
    required bool wasAbandoned,
  }) {
    // Basit heuristik, daha sonra ML ile geliştirilebilir
    
    // Vazgeçtiyse → overload
    if (wasAbandoned && hintCount >= 2) {
      return CognitiveLoadLevel.overload;
    }
    
    // 3+ ipucu → high
    if (hintCount >= 3) {
      return CognitiveLoadLevel.high;
    }
    
    // 5 dakikadan fazla → high
    if (totalTimeMs > 300000) {
      return CognitiveLoadLevel.high;
    }
    
    // 1-2 ipucu veya 2-5 dakika → medium
    if (hintCount >= 1 || totalTimeMs > 120000) {
      return CognitiveLoadLevel.medium;
    }
    
    // Hızlı ve ipucusuz → low
    return CognitiveLoadLevel.low;
  }

  // ═══════════════════════════════════════════════════════════════
  // 📊 GÜNLÜK SNAPSHOT GÜNCELLEME
  // ═══════════════════════════════════════════════════════════════

  Future<void> _updateDailySnapshot(QuestionSession session) async {
    final userId = session.userId;
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final snapshotId = '${userId}_$dateKey';

    final docRef = _firestore.collection('daily_snapshots').doc(snapshotId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      
      DailyLearningSnapshot snapshot;
      
      if (doc.exists) {
        snapshot = DailyLearningSnapshot.fromFirestore(doc);
      } else {
        snapshot = DailyLearningSnapshot.empty(userId);
      }

      // Metrikleri güncelle
      final newAttempted = snapshot.questionsAttempted + (session.isCorrect != null ? 1 : 0);
      final newCorrect = snapshot.questionsCorrect + (session.isCorrect == true ? 1 : 0);
      final newWrong = snapshot.questionsWrong + (session.isCorrect == false ? 1 : 0);
      final newHints = snapshot.hintsUsed + session.hintRequestCount;
      final newAbandoned = snapshot.questionsAbandoned + (session.wasAbandoned ? 1 : 0);
      
      // Ortalama süre güncelle
      final totalTime = (snapshot.averageTimePerQuestionMs * snapshot.questionsAttempted) + session.totalTimeMs;
      final newAvgTime = totalTime / newAttempted;
      
      // Konu skorları güncelle
      final topicScores = Map<String, double>.from(snapshot.topicScores);
      if (session.subject != null && session.isCorrect != null) {
        final key = session.subject!;
        final currentScore = topicScores[key] ?? 0.5;
        // Exponential moving average
        topicScores[key] = currentScore * 0.7 + (session.isCorrect! ? 1.0 : 0.0) * 0.3;
      }

      transaction.set(docRef, {
        'userId': userId,
        'date': Timestamp.fromDate(DateTime(today.year, today.month, today.day)),
        'questionsAttempted': newAttempted,
        'questionsCorrect': newCorrect,
        'questionsWrong': newWrong,
        'totalStudyMinutes': snapshot.totalStudyMinutes + (session.totalTimeMs ~/ 60000),
        'hintsUsed': newHints,
        'questionsAbandoned': newAbandoned,
        'averageTimePerQuestionMs': newAvgTime,
        'topicScores': topicScores,
        'dominantTopic': session.subject ?? snapshot.dominantTopic,
        'dominantErrorType': session.errorCategory ?? snapshot.dominantErrorType,
      });
    });

    debugPrint('📊 Günlük snapshot güncellendi: $snapshotId');
  }

  // ═══════════════════════════════════════════════════════════════
  // 📈 VERİ SORGULAMA
  // ═══════════════════════════════════════════════════════════════

  /// Son N günün snapshot'larını getir
  Future<List<DailyLearningSnapshot>> getRecentSnapshots({int days = 7}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    final startDate = DateTime.now().subtract(Duration(days: days));

    try {
      final query = await _firestore
          .collection('daily_snapshots')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('date', descending: true)
          .limit(days)
          .get();

      return query.docs.map((doc) => DailyLearningSnapshot.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Snapshot sorgulama hatası: $e');
      return [];
    }
  }

  /// Bugünün snapshot'ını getir
  Future<DailyLearningSnapshot?> getTodaySnapshot() async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final snapshotId = '${userId}_$dateKey';

    try {
      final doc = await _firestore.collection('daily_snapshots').doc(snapshotId).get();
      
      if (doc.exists) {
        return DailyLearningSnapshot.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Today snapshot hatası: $e');
      return null;
    }
  }

  /// Son N oturumu getir
  Future<List<QuestionSession>> getRecentSessions({int limit = 10}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      final query = await _firestore
          .collection('question_sessions')
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) => QuestionSession.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Session sorgulama hatası: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 📝 EVENT LOGGING
  // ═══════════════════════════════════════════════════════════════

  Future<void> _logEvent(LearningEventType type, Map<String, dynamic> metadata) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      await _firestore.collection('learning_events').add({
        'type': type.name,
        'userId': userId,
        'timestamp': Timestamp.now(),
        'sessionId': _currentSession?.sessionId,
        'subject': _currentSession?.subject,
        'topic': _currentSession?.topic,
        'metadata': metadata,
      });
    } catch (e) {
      debugPrint('⚠️ Event log hatası: $e');
    }
  }

  /// Genel event log (oturum dışı)
  Future<void> logEvent(LearningEventType type, {Map<String, dynamic>? metadata}) async {
    await _logEvent(type, metadata ?? {});
  }
}
