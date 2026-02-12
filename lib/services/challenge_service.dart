/// SOLICAP - Challenge Service
/// Asenkron Düello Sistemi - Firestore CRUD & İş Mantığı

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/challenge_model.dart';
import '../models/challenge_question_model.dart';
import 'auth_service.dart';
import 'leaderboard_service.dart';
import 'points_service.dart';
import 'user_dna_service.dart';

class ChallengeService {
  static final ChallengeService _instance = ChallengeService._internal();
  factory ChallengeService() => _instance;
  ChallengeService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final PointsService _pointsService = PointsService();
  final UserDNAService _dnaService = UserDNAService();
  final LeaderboardService _leaderboardService = LeaderboardService();

  // Koleksiyon isimleri
  static const String _challengesCollection = 'challenges';
  static const String _questionsCollection = 'challenge_questions';
  static const String _statsCollection = 'user_challenge_stats';

  // Sabitler
  static const int questionsPerMatch = 10;
  static const int entryFee = 30;        // Giriş ücreti (elmas)
  static const int winnerReward = 15;    // Kazanan ödülü (elmas)
  static const int drawReward = 5;       // Beraberlik ödülü (elmas)
  static const int winPoints = 10;       // Kazanan challenge puanı (liderboard)
  static const int losePoints = 10;      // Kaybeden challenge puanı kaybı
  static const int winnerAppPoints = 20; // Kazanana uygulama puanı (liderlik)
  static const int loserAppPoints = 10;  // Kaybedene uygulama puanı (liderlik)
  static const int matchExpiryHours = 24; // Maç geçerlilik süresi

  // ═══════════════════════════════════════════════════════════════
  // SORU YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Kategori ve okul düzeyine göre rastgele sorular getir
  Future<List<ChallengeQuestion>> getRandomQuestions({
    required String category,
    required String difficulty,
    int count = questionsPerMatch,
  }) async {
    try {
      // Sadece bu kategori + düzey; bölümler arası soru geçişi yok
      final snapshot = await _firestore
          .collection(_questionsCollection)
          .where('category', isEqualTo: category)
          .where('difficulty', isEqualTo: difficulty)
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        debugPrint('⚠️ Bu kategoride soru yok: $category / $difficulty');
        return [];
      }

      final questions = snapshot.docs
          .map((doc) => ChallengeQuestion.fromFirestore(doc))
          .toList();

      questions.shuffle(Random());
      return questions.take(count).toList();
    } catch (e) {
      debugPrint('❌ Soru getirme hatası: $e');
      return [];
    }
  }

  /// Bu kategori + düzey için en az 10 soru var mı?
  Future<bool> hasEnoughQuestions(String category, String difficulty) async {
    try {
      final snapshot = await _firestore
          .collection(_questionsCollection)
          .where('category', isEqualTo: category)
          .where('difficulty', isEqualTo: difficulty)
          .where('isActive', isEqualTo: true)
          .limit(questionsPerMatch)
          .get();
      return snapshot.docs.length >= questionsPerMatch;
    } catch (e) {
      return false;
    }
  }

  /// Soru ID'lerine göre soruları getir
  Future<List<ChallengeQuestion>> getQuestionsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    try {
      final questions = <ChallengeQuestion>[];
      
      // Firestore 'whereIn' 10 limit var, parçala
      for (var i = 0; i < ids.length; i += 10) {
        final chunk = ids.skip(i).take(10).toList();
        final snapshot = await _firestore
            .collection(_questionsCollection)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        
        questions.addAll(
          snapshot.docs.map((doc) => ChallengeQuestion.fromFirestore(doc)),
        );
      }

      // Orijinal sırayı koru
      questions.sort((a, b) => ids.indexOf(a.id).compareTo(ids.indexOf(b.id)));
      return questions;
    } catch (e) {
      debugPrint('❌ Soru getirme hatası: $e');
      return [];
    }
  }

  /// Soruları toplu ekle (Admin için)
  Future<void> addQuestions(List<ChallengeQuestion> questions) async {
    try {
      final batch = _firestore.batch();
      for (final q in questions) {
        final docRef = _firestore.collection(_questionsCollection).doc();
        batch.set(docRef, q.toJson());
      }
      await batch.commit();
      debugPrint('✅ ${questions.length} soru eklendi');
    } catch (e) {
      debugPrint('❌ Soru ekleme hatası: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CHALLENGE YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Yeni meydan okuma oluştur
  Future<Challenge?> createChallenge({
    required String category,
    required String difficulty,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      // 1. Elmas kontrolü ve düşürme
      final hasEnough = await _pointsService.hasEnoughPoints('challenge_entry');
      if (!hasEnough) {
        debugPrint('⚠️ Yetersiz elmas');
        return null;
      }

      // 2. Rastgele sorular seç
      final questions = await getRandomQuestions(
        category: category,
        difficulty: difficulty,
      );

      if (questions.length < questionsPerMatch) {
        debugPrint('⚠️ Yeterli soru yok');
        return null;
      }

      // 3. Kullanıcı adını al
      final dna = await _dnaService.getDNA();
      final displayName = dna?.userName ?? 'Anonim';

      // 4. Challenge oluştur
      final now = DateTime.now();
      final challenge = Challenge(
        id: '',
        category: category,
        difficulty: difficulty,
        status: ChallengeStatus.waiting,
        player1: ChallengePlayer(
          userId: userId,
          displayName: displayName,
        ),
        questionIds: questions.map((q) => q.id).toList(),
        createdAt: now,
        expiresAt: now.add(Duration(hours: matchExpiryHours)),
      );

      // 5. Firestore'a kaydet
      final docRef = await _firestore
          .collection(_challengesCollection)
          .add(challenge.toJson());

      // 6. Elmas düş
      await _pointsService.spendPoints(
        'challenge_entry',
        description: 'Challenge giriş ücreti',
      );

      debugPrint('✅ Challenge oluşturuldu: ${docRef.id}');
      
      return Challenge(
        id: docRef.id,
        category: category,
        difficulty: difficulty,
        status: ChallengeStatus.waiting,
        player1: challenge.player1,
        questionIds: challenge.questionIds,
        createdAt: now,
        expiresAt: challenge.expiresAt,
      );
    } catch (e) {
      debugPrint('❌ Challenge oluşturma hatası: $e');
      return null;
    }
  }

  /// 10 soru tamamlandıktan sonra challenge oluştur (Solo mod)
  /// NOT: Elmas zaten Düello Start'a basınca düşürüldü
  Future<Challenge?> createChallengeWithQuestions({
    required String category,
    required String difficulty,
    required List<ChallengeQuestion> questions,
    required int correctAnswers,
    required int totalTimeMs,
    required List<int> answers,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      // Kullanıcı adını al
      final dna = await _dnaService.getDNA();
      final displayName = dna?.userName ?? 'Anonim';

      // 3. Skor hesapla
      final score = (correctAnswers * 100) + 
          ((questionsPerMatch * 15000 - totalTimeMs) ~/ 100).clamp(0, 150);

      // 4. Challenge oluştur (player1 tamamlanmış olarak)
      final now = DateTime.now();
      final challenge = Challenge(
        id: '',
        category: category,
        difficulty: difficulty,
        status: ChallengeStatus.waiting,
        player1: ChallengePlayer(
          userId: userId,
          displayName: displayName,
          score: score,
          correctAnswers: correctAnswers,
          totalTimeMs: totalTimeMs,
          hasCompleted: true,
          completedAt: now,
          answers: answers,
        ),
        questionIds: questions.map((q) => q.id).toList(),
        createdAt: now,
        expiresAt: now.add(Duration(hours: matchExpiryHours)),
      );

      // 5. Firestore'a kaydet
      final docRef = await _firestore
          .collection(_challengesCollection)
          .add(challenge.toJson());

      debugPrint('✅ Challenge oluşturuldu (10 soru sonrası): ${docRef.id}');

      // Tüm Zamanlar liderlik tablosuna +20 puan
      await _leaderboardService.addPoints(20, 'challenge_participation');
      
      return Challenge(
        id: docRef.id,
        category: category,
        difficulty: difficulty,
        status: ChallengeStatus.waiting,
        player1: challenge.player1,
        questionIds: challenge.questionIds,
        createdAt: now,
        expiresAt: challenge.expiresAt,
      );
    } catch (e) {
      debugPrint('❌ Challenge oluşturma hatası: $e');
      return null;
    }
  }

  /// Challenge'ı ID ile getir (sonuç ekranı için)
  Future<Challenge?> getChallenge(String challengeId) async {
    try {
      final doc = await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .get();
      if (!doc.exists) return null;
      return Challenge.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Challenge getirme hatası: $e');
      return null;
    }
  }

  /// Challenge değişikliklerini dinle (rakip bitirdiğinde sonucu göstermek için)
  Stream<Challenge?> getChallengeStream(String challengeId) {
    return _firestore
        .collection(_challengesCollection)
        .doc(challengeId)
        .snapshots()
        .map((doc) => doc.exists ? Challenge.fromFirestore(doc) : null);
  }

  /// Bekleyen bir challenge'a katıl
  Future<Challenge?> joinChallenge(String challengeId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      // 1. Elmas kontrolü
      final hasEnough = await _pointsService.hasEnoughPoints('challenge_entry');
      if (!hasEnough) {
        debugPrint('⚠️ Yetersiz elmas');
        return null;
      }

      // 2. Challenge'ı getir
      final doc = await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .get();

      if (!doc.exists) return null;

      final challenge = Challenge.fromFirestore(doc);

      // 3. Kontroller
      if (challenge.status != ChallengeStatus.waiting) {
        debugPrint('⚠️ Challenge beklemede değil');
        return null;
      }

      if (challenge.player1.userId == userId) {
        debugPrint('⚠️ Kendi challenge\'ına katılamazsın');
        return null;
      }

      if (challenge.expiresAt != null && 
          DateTime.now().isAfter(challenge.expiresAt!)) {
        debugPrint('⚠️ Challenge süresi dolmuş');
        return null;
      }

      // 4. Kullanıcı adını al
      final dna = await _dnaService.getDNA();
      final displayName = dna?.userName ?? 'Anonim';

      // 5. Player2 olarak ekle
      await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .update({
        'player2': ChallengePlayer(
          userId: userId,
          displayName: displayName,
        ).toJson(),
        'status': ChallengeStatus.inProgress.name,
      });

      // 6. Elmas düş
      await _pointsService.spendPoints(
        'challenge_entry',
        description: 'Challenge giriş ücreti',
      );

      debugPrint('✅ Challenge\'a katılındı: $challengeId');
      
      // Güncel hali getir
      final updatedDoc = await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .get();
      
      return Challenge.fromFirestore(updatedDoc);
    } catch (e) {
      debugPrint('❌ Challenge katılma hatası: $e');
      return null;
    }
  }

  /// Davet kodu ile challenge'a katıl (inviter elmas alır - limit kontrolü ile)
  Future<Challenge?> joinChallengeByInviteCode(String challengeId) async {
    final result = await joinChallenge(challengeId);
    if (result == null) return null;

    // Davet eden (player1) elmas hediye alır (günlük/toplam limit kontrolü ile)
    final inviterId = result.player1.userId;
    final rewardGiven = await _pointsService.giveInviteReward(inviterId);
    
    if (!rewardGiven) {
      debugPrint('⚠️ Davet ödülü verilemedi (limit aşıldı): $inviterId');
    }

    return result;
  }

  /// Rastgele bekleyen challenge bul (aynı kategori + okul düzeyi)
  Future<Challenge?> findWaitingChallenge({
    required String category,
    required String difficulty,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final snapshot = await _firestore
          .collection(_challengesCollection)
          .where('category', isEqualTo: category)
          .where('difficulty', isEqualTo: difficulty)
          .where('status', isEqualTo: ChallengeStatus.waiting.name)
          .where('expiresAt', isGreaterThan: Timestamp.now())
          .orderBy('expiresAt')
          .limit(10)
          .get();

      // Kendi challenge'ını hariç tut
      final available = snapshot.docs
          .map((doc) => Challenge.fromFirestore(doc))
          .where((c) => c.player1.userId != userId)
          .toList();

      if (available.isEmpty) return null;

      // Rastgele birini seç
      return available[Random().nextInt(available.length)];
    } catch (e) {
      debugPrint('❌ Challenge arama hatası: $e');
      return null;
    }
  }

  /// Oyuncu sonucunu kaydet
  Future<bool> submitPlayerResult({
    required String challengeId,
    required int correctAnswers,
    required int totalTimeMs,
    required List<int> answers,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;

    try {
      final doc = await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .get();

      if (!doc.exists) return false;

      final challenge = Challenge.fromFirestore(doc);
      final isPlayer1 = challenge.player1.userId == userId;
      final isPlayer2 = challenge.player2?.userId == userId;

      if (!isPlayer1 && !isPlayer2) return false;

      // Skor hesapla: Doğru × 100 + Kalan süre bonusu
      final score = (correctAnswers * 100) + 
          ((questionsPerMatch * 15000 - totalTimeMs) ~/ 100).clamp(0, 150);

      final playerField = isPlayer1 ? 'player1' : 'player2';

      await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .update({
        '$playerField.score': score,
        '$playerField.correctAnswers': correctAnswers,
        '$playerField.totalTimeMs': totalTimeMs,
        '$playerField.hasCompleted': true,
        '$playerField.completedAt': Timestamp.now(),
        '$playerField.answers': answers,
      });

      debugPrint('✅ Sonuç kaydedildi: $score puan');

      // Tüm Zamanlar liderlik tablosuna +20 puan
      await _leaderboardService.addPoints(20, 'challenge_participation');

      // Güncel challenge'ı oluştur (Firestore'dan tekrar okumadan)
      final updatedPlayer = ChallengePlayer(
        userId: isPlayer1 ? challenge.player1.userId : challenge.player2!.userId,
        displayName: isPlayer1 ? challenge.player1.displayName : challenge.player2!.displayName,
        score: score,
        correctAnswers: correctAnswers,
        totalTimeMs: totalTimeMs,
        hasCompleted: true,
        completedAt: DateTime.now(),
        answers: answers,
      );

      final updatedChallenge = Challenge(
        id: challenge.id,
        category: challenge.category,
        difficulty: challenge.difficulty,
        status: challenge.status,
        player1: isPlayer1 ? updatedPlayer : challenge.player1,
        player2: isPlayer2 ? updatedPlayer : challenge.player2,
        questionIds: challenge.questionIds,
        createdAt: challenge.createdAt,
        expiresAt: challenge.expiresAt,
        winnerId: challenge.winnerId,
        isDraw: challenge.isDraw,
      );

      // Her iki oyuncu da tamamladıysa sonuçlandır
      await _checkAndFinalizeMatch(challengeId, updatedChallenge);

      return true;
    } catch (e) {
      debugPrint('❌ Sonuç kaydetme hatası: $e');
      return false;
    }
  }

  /// Maçı sonuçlandır (güncel challenge objesi ile)
  Future<void> _checkAndFinalizeMatch(String challengeId, Challenge challenge) async {
    try {
      // Her iki oyuncu da tamamladı mı?
      if (!challenge.player1.hasCompleted) return;
      if (challenge.player2 == null || !challenge.player2!.hasCompleted) return;

      // Kazananı hesapla
      final winnerId = challenge.calculateWinner();
      final isDraw = winnerId == null;

      // Challenge'ı güncelle
      await _firestore
          .collection(_challengesCollection)
          .doc(challengeId)
          .update({
        'status': ChallengeStatus.completed.name,
        'winnerId': winnerId,
        'isDraw': isDraw,
      });

      // Ödülleri dağıt
      await _distributeRewards(challenge, winnerId, isDraw);

      debugPrint('✅ Maç sonuçlandı. Kazanan: ${winnerId ?? "Beraberlik"}');
    } catch (e) {
      debugPrint('❌ Maç sonuçlandırma hatası: $e');
    }
  }

  /// Ödülleri dağıt — Cloud Function (onChallengeCompleted) sunucuda dağıtıyor.
  /// Client'tan başka kullanıcıya yazma izni olmadığı için burada sadece log.
  Future<void> _distributeRewards(
    Challenge challenge,
    String? winnerId,
    bool isDraw,
  ) async {
    debugPrint('✅ Maç sonuçlandı. Ödüller Cloud Function ile dağıtılacak. Kazanan: ${winnerId ?? "Beraberlik"}');
  }

  /// Kullanıcıya elmas ekle
  Future<void> _addDiamondsToUser(String odaiUserId, int amount) async {
    try {
      await _firestore.collection('user_points').doc(odaiUserId).update({
        'balance': FieldValue.increment(amount),
        'totalEarned': FieldValue.increment(amount),
      });
    } catch (e) {
      debugPrint('❌ Elmas ekleme hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // İSTATİSTİKLER
  // ═══════════════════════════════════════════════════════════════

  /// Kullanıcı istatistiklerini güncelle
  Future<void> _updateStats(
    String odaiUserId, {
    bool isWin = false,
    bool isLoss = false,
    bool isDraw = false,
  }) async {
    try {
      final docRef = _firestore.collection(_statsCollection).doc(odaiUserId);
      final doc = await docRef.get();

      if (!doc.exists) {
        // İlk maç - doküman oluştur
        await docRef.set({
          'challengePoints': isWin ? winPoints : (isLoss ? -losePoints : 0),
          'totalMatches': 1,
          'wins': isWin ? 1 : 0,
          'losses': isLoss ? 1 : 0,
          'draws': isDraw ? 1 : 0,
          'currentWinStreak': isWin ? 1 : 0,
          'bestWinStreak': isWin ? 1 : 0,
          'lastMatchAt': Timestamp.now(),
        });
      } else {
        final data = doc.data()!;
        final currentStreak = data['currentWinStreak'] ?? 0;
        final bestStreak = data['bestWinStreak'] ?? 0;

        int newStreak = isWin ? currentStreak + 1 : 0;
        int newBest = newStreak > bestStreak ? newStreak : bestStreak;

        await docRef.update({
          'challengePoints': FieldValue.increment(
            isWin ? winPoints : (isLoss ? -losePoints : 0),
          ),
          'totalMatches': FieldValue.increment(1),
          'wins': FieldValue.increment(isWin ? 1 : 0),
          'losses': FieldValue.increment(isLoss ? 1 : 0),
          'draws': FieldValue.increment(isDraw ? 1 : 0),
          'currentWinStreak': newStreak,
          'bestWinStreak': newBest,
          'lastMatchAt': Timestamp.now(),
        });
      }
    } catch (e) {
      debugPrint('❌ İstatistik güncelleme hatası: $e');
    }
  }

  /// Kullanıcı istatistiklerini getir
  Future<UserChallengeStats?> getUserStats([String? userId]) async {
    final uid = userId ?? _authService.currentUserId;
    if (uid == null) return null;

    try {
      final doc = await _firestore.collection(_statsCollection).doc(uid).get();
      
      if (!doc.exists) {
        return UserChallengeStats(userId: uid);
      }
      
      return UserChallengeStats.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ İstatistik getirme hatası: $e');
      return null;
    }
  }

  /// Challenge Liderboard
  Future<List<UserChallengeStats>> getLeaderboard({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection(_statsCollection)
          .orderBy('challengePoints', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => UserChallengeStats.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Liderboard hatası: $e');
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // KULLANICI CHALLENGE'LARI
  // ═══════════════════════════════════════════════════════════════

  /// Bekleyen düelloları getir (herkes görsün; A kendi düellosunu da görür, B katılabilsin)
  /// Sunucudan taze alınır.
  Future<List<Challenge>> getWaitingChallenges() async {
    try {
      final snapshot = await _firestore
          .collection(_challengesCollection)
          .where('status', isEqualTo: ChallengeStatus.waiting.name)
          .where('expiresAt', isGreaterThan: Timestamp.now())
          .orderBy('expiresAt')
          .limit(30)
          .get(const GetOptions(source: Source.server));

      return snapshot.docs
          .map((doc) => Challenge.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('❌ Bekleyen challenge getirme hatası: $e');
      return [];
    }
  }

  /// Kullanıcının aktif challenge'larını getir
  Future<List<Challenge>> getMyActiveChallenges() async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      // Player1 olarak
      final p1Snapshot = await _firestore
          .collection(_challengesCollection)
          .where('player1.userId', isEqualTo: userId)
          .where('status', whereIn: [
            ChallengeStatus.waiting.name,
            ChallengeStatus.inProgress.name,
          ])
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      // Player2 olarak
      final p2Snapshot = await _firestore
          .collection(_challengesCollection)
          .where('player2.userId', isEqualTo: userId)
          .where('status', isEqualTo: ChallengeStatus.inProgress.name)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      final challenges = <Challenge>[];
      challenges.addAll(p1Snapshot.docs.map((d) => Challenge.fromFirestore(d)));
      challenges.addAll(p2Snapshot.docs.map((d) => Challenge.fromFirestore(d)));

      // Yarım bırakılan (10. soru cevaplanmamış) challenge'ları gösterme
      final filtered = challenges.where((c) {
        if (c.status == ChallengeStatus.waiting) {
          return c.player1.userId == userId; // Bekleyen challenge'ım
        }
        // inProgress veya completed: sadece benim 10 soruyu tamamladığım
        if (c.player1.userId == userId) return c.player1.hasCompleted;
        if (c.player2?.userId == userId) return c.player2!.hasCompleted;
        return false;
      }).toList();

      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    } catch (e) {
      debugPrint('❌ Aktif challenge getirme hatası: $e');
      return [];
    }
  }

  /// Kullanıcının geçmiş challenge'larını getir
  Future<List<Challenge>> getMyCompletedChallenges({int limit = 20}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection(_challengesCollection)
          .where('status', isEqualTo: ChallengeStatus.completed.name)
          .orderBy('createdAt', descending: true)
          .limit(limit * 2) // Fazla al, sonra filtrele
          .get();

      return snapshot.docs
          .map((d) => Challenge.fromFirestore(d))
          .where((c) => 
              c.player1.userId == userId || 
              c.player2?.userId == userId)
          .take(limit)
          .toList();
    } catch (e) {
      debugPrint('❌ Geçmiş challenge getirme hatası: $e');
      return [];
    }
  }
}
