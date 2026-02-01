/// SOLICAP - Leaderboard Model
/// Liderlik tablosu ve flag veri modelleri

import 'package:cloud_firestore/cloud_firestore.dart';

/// Yaş grubu enum
enum GradeGroup {
  elementary,  // İlkokul-Ortaokul (1-8)
  highSchool,  // Lise (9-12 + Mezun)
  university,  // Üniversite (lisans, yüksek lisans, KPSS, ALES, DGS, TUS, DUS)
}

/// gradeGroup string'e çevir
String gradeGroupToString(GradeGroup g) {
  return g == GradeGroup.elementary ? 'elementary'
      : g == GradeGroup.university ? 'university'
      : 'highSchool';
}

/// Yaş grubunu sınıf seviyesi, hedef sınav ve level'dan belirle
GradeGroup getGradeGroup(String? gradeLevel, {String? targetExam, String? level}) {
  // 0. UserDNA level kontrolü (üniversite düzeyi)
  if (level != null && level.toLowerCase() == 'university') {
    return GradeGroup.university;
  }
  
  // 1. targetExam: Türkiye Sınavları + Genel Seviyeler (UserDNA'da tutuluyor)
  if (targetExam != null && targetExam.isNotEmpty) {
    final lowerExam = targetExam.toLowerCase();
    if (lowerExam.contains('ilkokul') || lowerExam.contains('ortaokul')) {
      return GradeGroup.elementary;
    }
    // Üniversite: KPSS, ALES, DGS, TUS, DUS + Genel Seviyeler'den Üniversite Düzeyi, Lisansüstü Düzeyi
    if (lowerExam.contains('kpss') || lowerExam.contains('ales') ||
        lowerExam.contains('dgs') || lowerExam.contains('tus') ||
        lowerExam.contains('dus') || lowerExam.contains('lisansüstü') ||
        lowerExam.contains('üniversite düzeyi')) {
      return GradeGroup.university;
    }
    // Lise / YKS
    if (lowerExam.contains('lise düzeyi') || lowerExam.contains('lise') || 
        lowerExam.contains('yks')) {
      return GradeGroup.highSchool;
    }
    // LGS → İlkokul-Ortaokul (8. sınıf)
    if (lowerExam.contains('lgs')) {
      return GradeGroup.elementary;
    }
  }
  
  // 2. Sonra gradeLevel kontrol et
  if (gradeLevel != null && gradeLevel.isNotEmpty) {
    // Sınıf numarasını çıkar
    final match = RegExp(r'(\d+)').firstMatch(gradeLevel);
    if (match != null) {
      final grade = int.tryParse(match.group(1) ?? '') ?? 9;
      return grade <= 8 ? GradeGroup.elementary : GradeGroup.highSchool;
    }
    
    // Özel durumlar: Sınıf Seviyesi'nden Üniversite, Lisansüstü
    final lowerGrade = gradeLevel.toLowerCase();
    if (lowerGrade.contains('üniversite') || lowerGrade.contains('lisans') || 
        lowerGrade.contains('yüksek lisans') || lowerGrade.contains('doktora')) {
      return GradeGroup.university;
    }
    if (lowerGrade.contains('mezun')) {
      return GradeGroup.highSchool; // Lise mezunu
    }
  }
  
  // 3. Belirsiz → Lise grubu (default)
  return GradeGroup.highSchool;
}

/// Liderlik tablosu girişi
class LeaderboardEntry {
  final String userId;
  final String displayName;
  final int points;
  final GradeGroup gradeGroup;
  final DateTime lastUpdate;
  final String? weekStart; // Haftalık için

  LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.points,
    required this.gradeGroup,
    required this.lastUpdate,
    this.weekStart,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final g = data['gradeGroup'];
    final gradeGroup = g == 'elementary' ? GradeGroup.elementary
        : g == 'university' ? GradeGroup.university
        : GradeGroup.highSchool;
    return LeaderboardEntry(
      userId: doc.id,
      displayName: data['displayName'] ?? 'Anonim',
      points: data['points'] ?? 0,
      gradeGroup: gradeGroup,
      lastUpdate: (data['lastUpdate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      weekStart: data['weekStart'],
    );
  }

  Map<String, dynamic> toFirestore() {
    final g = gradeGroup == GradeGroup.elementary ? 'elementary'
        : gradeGroup == GradeGroup.university ? 'university'
        : 'highSchool';
    return {
      'displayName': displayName,
      'points': points,
      'gradeGroup': g,
      'lastUpdate': Timestamp.fromDate(lastUpdate),
      if (weekStart != null) 'weekStart': weekStart,
    };
  }
}

/// Kullanıcı flag bilgisi (hile önleme)
class UserFlags {
  final String userId;
  final int flagCount;
  final DateTime? lastFlagDate;
  final List<String> reasons;
  final bool isBanned;

  UserFlags({
    required this.userId,
    required this.flagCount,
    this.lastFlagDate,
    this.reasons = const [],
    this.isBanned = false,
  });

  factory UserFlags.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserFlags(
      userId: doc.id,
      flagCount: data['flagCount'] ?? 0,
      lastFlagDate: (data['lastFlagDate'] as Timestamp?)?.toDate(),
      reasons: List<String>.from(data['reasons'] ?? []),
      isBanned: data['isBanned'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'flagCount': flagCount,
      'lastFlagDate': lastFlagDate != null ? Timestamp.fromDate(lastFlagDate!) : null,
      'reasons': reasons,
      'isBanned': isBanned,
    };
  }

  /// Yeni flag eklenmiş kopya
  UserFlags addFlag(String reason) {
    return UserFlags(
      userId: userId,
      flagCount: flagCount + 1,
      lastFlagDate: DateTime.now(),
      reasons: [...reasons, reason],
      isBanned: (flagCount + 1) >= 20,
    );
  }
}

/// Puan türleri ve değerleri
class LeaderboardPoints {
  static const int questionSolve = 10;    // Soru çözümü
  static const int noteEdit = 5;          // Not düzenleme
  static const int microLesson = 20;      // Mikro ders
  static const int socraticSession = 20;  // Sokratik bölüm
  static const int flashcardReview = 20;  // Tekrar kartları
}
