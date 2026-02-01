/// SOLICAP - Challenge Model
/// Asenkron Düello Sistemi için veri modelleri

import 'package:cloud_firestore/cloud_firestore.dart';

/// Yarışma durumu
enum ChallengeStatus {
  waiting,    // Rakip bekleniyor
  inProgress, // Oyun devam ediyor
  completed,  // Oyun bitti
  expired,    // Süre doldu (24 saat)
}

/// Oyuncu bilgisi
class ChallengePlayer {
  final String userId;
  final String displayName;
  final int score;
  final int correctAnswers;
  final int totalTimeMs; // Toplam cevaplama süresi (ms)
  final bool hasCompleted;
  final DateTime? completedAt;
  final List<int> answers; // Her soru için seçilen şık indexi (-1 = boş)

  ChallengePlayer({
    required this.userId,
    required this.displayName,
    this.score = 0,
    this.correctAnswers = 0,
    this.totalTimeMs = 0,
    this.hasCompleted = false,
    this.completedAt,
    this.answers = const [],
  });

  factory ChallengePlayer.fromJson(Map<String, dynamic> json) {
    return ChallengePlayer(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? 'Anonim',
      score: json['score'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      totalTimeMs: json['totalTimeMs'] ?? 0,
      hasCompleted: json['hasCompleted'] ?? false,
      completedAt: json['completedAt'] != null 
          ? (json['completedAt'] as Timestamp).toDate() 
          : null,
      answers: List<int>.from(json['answers'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'score': score,
      'correctAnswers': correctAnswers,
      'totalTimeMs': totalTimeMs,
      'hasCompleted': hasCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'answers': answers,
    };
  }

  ChallengePlayer copyWith({
    String? userId,
    String? displayName,
    int? score,
    int? correctAnswers,
    int? totalTimeMs,
    bool? hasCompleted,
    DateTime? completedAt,
    List<int>? answers,
  }) {
    return ChallengePlayer(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalTimeMs: totalTimeMs ?? this.totalTimeMs,
      hasCompleted: hasCompleted ?? this.hasCompleted,
      completedAt: completedAt ?? this.completedAt,
      answers: answers ?? this.answers,
    );
  }
}

/// Ana Challenge modeli
class Challenge {
  final String id;
  final String category;        // Kategori (matematik, fen, genel_kultur)
  final String difficulty;      // Zorluk (ilkokul, ortaokul, lise)
  final ChallengeStatus status;
  final ChallengePlayer player1; // Meydan okuyan
  final ChallengePlayer? player2; // Rakip (null = bekliyor)
  final List<String> questionIds; // 10 soru ID'si
  final DateTime createdAt;
  final DateTime? expiresAt;     // 24 saat sonra
  final String? winnerId;        // Kazanan userId
  final bool isDraw;             // Beraberlik

  Challenge({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.status,
    required this.player1,
    this.player2,
    required this.questionIds,
    required this.createdAt,
    this.expiresAt,
    this.winnerId,
    this.isDraw = false,
  });

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Challenge(
      id: doc.id,
      category: data['category'] ?? 'genel_kultur',
      difficulty: data['difficulty'] ?? 'ortaokul',
      status: ChallengeStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ChallengeStatus.waiting,
      ),
      player1: ChallengePlayer.fromJson(data['player1'] ?? {}),
      player2: data['player2'] != null 
          ? ChallengePlayer.fromJson(data['player2']) 
          : null,
      questionIds: List<String>.from(data['questionIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
      winnerId: data['winnerId'],
      isDraw: data['isDraw'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'difficulty': difficulty,
      'status': status.name,
      'player1': player1.toJson(),
      'player2': player2?.toJson(),
      'questionIds': questionIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'winnerId': winnerId,
      'isDraw': isDraw,
    };
  }

  /// Her iki oyuncu da tamamladı mı?
  bool get isCompleted => 
      player1.hasCompleted && (player2?.hasCompleted ?? false);

  /// Kazananı hesapla
  String? calculateWinner() {
    if (!isCompleted) return null;
    
    final p1 = player1;
    final p2 = player2!;
    
    // 1. Doğru sayısı karşılaştır
    if (p1.correctAnswers > p2.correctAnswers) return p1.userId;
    if (p2.correctAnswers > p1.correctAnswers) return p2.userId;
    
    // 2. Aynı doğru → süre karşılaştır (düşük süre kazanır)
    if (p1.totalTimeMs < p2.totalTimeMs) return p1.userId;
    if (p2.totalTimeMs < p1.totalTimeMs) return p2.userId;
    
    // 3. Her şey eşit → beraberlik
    return null; // isDraw = true
  }
}

/// Kullanıcının Challenge istatistikleri
class UserChallengeStats {
  final String userId;
  final int challengePoints;    // Yarışma puanı (kazanınca +10, kaybedince -10)
  final int totalMatches;
  final int wins;
  final int losses;
  final int draws;
  final int currentWinStreak;
  final int bestWinStreak;
  final DateTime? lastMatchAt;

  UserChallengeStats({
    required this.userId,
    this.challengePoints = 0,
    this.totalMatches = 0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.currentWinStreak = 0,
    this.bestWinStreak = 0,
    this.lastMatchAt,
  });

  factory UserChallengeStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserChallengeStats(
      userId: doc.id,
      challengePoints: data['challengePoints'] ?? 0,
      totalMatches: data['totalMatches'] ?? 0,
      wins: data['wins'] ?? 0,
      losses: data['losses'] ?? 0,
      draws: data['draws'] ?? 0,
      currentWinStreak: data['currentWinStreak'] ?? 0,
      bestWinStreak: data['bestWinStreak'] ?? 0,
      lastMatchAt: (data['lastMatchAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'challengePoints': challengePoints,
      'totalMatches': totalMatches,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'currentWinStreak': currentWinStreak,
      'bestWinStreak': bestWinStreak,
      'lastMatchAt': lastMatchAt != null ? Timestamp.fromDate(lastMatchAt!) : null,
    };
  }

  double get winRate => totalMatches > 0 ? (wins / totalMatches) * 100 : 0;
}
