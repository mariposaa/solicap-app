/// SOLICAP - Kütüphane Arkadaşın Olacak modelleri

import 'package:cloud_firestore/cloud_firestore.dart';

/// Kriter kodları (max 2 seçim)
const List<LibraryBuddyCriterion> libraryBuddyCriteria = [
  LibraryBuddyCriterion('lgs', 'LGS'),
  LibraryBuddyCriterion('yks_tyt', 'YKS TYT'),
  LibraryBuddyCriterion('yks_sayisal', 'YKS Sayısal'),
  LibraryBuddyCriterion('yks_sozel', 'YKS Sözel'),
  LibraryBuddyCriterion('yks_esit_agirlik', 'YKS Eşit Ağırlık'),
  LibraryBuddyCriterion('kpss', 'KPSS'),
  LibraryBuddyCriterion('ales', 'ALES'),
  LibraryBuddyCriterion('dgs', 'DGS'),
];

class LibraryBuddyCriterion {
  final String code;
  final String label;
  const LibraryBuddyCriterion(this.code, this.label);
}

/// Havuz kaydı: library_buddy_pool/{userId}
class LibraryBuddyPoolEntry {
  final String userId;
  final String displayName;
  final List<String> criteria;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  LibraryBuddyPoolEntry({
    required this.userId,
    required this.displayName,
    required this.criteria,
    required this.createdAt,
    required this.lastActiveAt,
  });

  factory LibraryBuddyPoolEntry.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return LibraryBuddyPoolEntry(
      userId: doc.id,
      displayName: d['displayName'] ?? 'Anonim',
      criteria: List<String>.from(d['criteria'] ?? []),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveAt: (d['lastActiveAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'criteria': criteria,
        'createdAt': Timestamp.fromDate(createdAt),
        'lastActiveAt': Timestamp.fromDate(lastActiveAt),
      };
}

/// Eşleşme: library_buddy_matches/{matchId}
class LibraryBuddyMatch {
  final String id;
  final String user1Id;
  final String user2Id;
  final String user1Name;
  final String user2Name;
  final List<String> criteria;
  final DateTime createdAt;
  final DateTime? user1LastSeenAt;
  final DateTime? user2LastSeenAt;

  LibraryBuddyMatch({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    required this.criteria,
    required this.createdAt,
    this.user1LastSeenAt,
    this.user2LastSeenAt,
  });

  factory LibraryBuddyMatch.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return LibraryBuddyMatch(
      id: doc.id,
      user1Id: d['user1Id'] ?? '',
      user2Id: d['user2Id'] ?? '',
      user1Name: d['user1Name'] ?? 'Anonim',
      user2Name: d['user2Name'] ?? 'Anonim',
      criteria: List<String>.from(d['criteria'] ?? []),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      user1LastSeenAt: (d['user1LastSeenAt'] as Timestamp?)?.toDate(),
      user2LastSeenAt: (d['user2LastSeenAt'] as Timestamp?)?.toDate(),
    );
  }

  String otherUserId(String myUserId) =>
      user1Id == myUserId ? user2Id : user1Id;

  String otherDisplayName(String myUserId) =>
      user1Id == myUserId ? user2Name : user1Name;

  /// Karşı tarafın son görülme zamanı (mesaj/chat için)
  DateTime? otherLastSeenAt(String myUserId) =>
      user1Id == myUserId ? user2LastSeenAt : user1LastSeenAt;
}
