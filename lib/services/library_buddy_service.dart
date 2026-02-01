/// SOLICAP - Kütüphane Arkadaşın Olacak servisi
/// Havuz, eşleşme, kriter formu

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/library_buddy_model.dart';
import '../models/library_buddy_message_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';

class LibraryBuddyService {
  static final LibraryBuddyService _instance = LibraryBuddyService._internal();
  factory LibraryBuddyService() => _instance;
  LibraryBuddyService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();

  static const String _poolCollection = 'library_buddy_pool';
  static const String _matchesCollection = 'library_buddy_matches';
  static const int maxCriteria = 2;

  /// Havuza ekle veya güncelle (kriterlerle)
  Future<bool> joinPool(List<String> criteria) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;
    if (criteria.isEmpty || criteria.length > maxCriteria) return false;

    try {
      final dna = await _dnaService.getDNA();
      final displayName = dna?.userName ?? 'Anonim';
      final now = DateTime.now();

      await _firestore.collection(_poolCollection).doc(userId).set({
        'displayName': displayName,
        'criteria': criteria,
        'createdAt': Timestamp.fromDate(now),
        'lastActiveAt': Timestamp.fromDate(now),
      });

      // Eşleşme Cloud Function (onLibraryBuddyPoolCreated/Updated) ile sunucuda yapılıyor.
      return true;
    } catch (e) {
      debugPrint('❌ Library buddy pool join hatası: $e');
      return false;
    }
  }

  /// Havuzdan çık
  Future<void> leavePool() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    try {
      await _firestore.collection(_poolCollection).doc(userId).delete();
    } catch (e) {
      debugPrint('❌ Library buddy pool leave hatası: $e');
    }
  }

  /// Son aktiflik zamanını güncelle
  Future<void> updateLastActive() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    try {
      await _firestore.collection(_poolCollection).doc(userId).update({
        'lastActiveAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (_) {}
  }

  /// Benim havuz kaydım
  Future<LibraryBuddyPoolEntry?> getMyPoolEntry() async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;
    try {
      final doc = await _firestore.collection(_poolCollection).doc(userId).get();
      if (!doc.exists) return null;
      return LibraryBuddyPoolEntry.fromFirestore(doc);
    } catch (e) {
      debugPrint('❌ getMyPoolEntry hatası: $e');
      return null;
    }
  }

  /// Benim eşleşmelerim (stream) - en fazla 5
  Stream<List<LibraryBuddyMatch>> getMyMatchesStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection(_matchesCollection)
        .where('user1Id', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .asyncMap((snap1) async {
      final snap2 = await _firestore
          .collection(_matchesCollection)
          .where('user2Id', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();
      final ids = <String>{};
      final list = <LibraryBuddyMatch>[];
      for (final doc in snap1.docs) {
        if (ids.add(doc.id)) list.add(LibraryBuddyMatch.fromFirestore(doc));
      }
      for (final doc in snap2.docs) {
        if (ids.add(doc.id)) list.add(LibraryBuddyMatch.fromFirestore(doc));
      }
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list.take(5).toList();
    });
  }

  static const String _messagesSub = 'messages';
  static const Duration messageExpiry = Duration(minutes: 10);

  /// Mesajlar stream (eşleşme alt koleksiyonu, eskiden yeniye)
  Stream<List<LibraryBuddyMessage>> getMessagesStream(String matchId) {
    return _firestore
        .collection(_matchesCollection)
        .doc(matchId)
        .collection(_messagesSub)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => LibraryBuddyMessage.fromFirestore(d)).toList());
  }

  /// Mesaj gönder; son görülme zamanını günceller
  Future<bool> sendMessage(String matchId, String text) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;
    if (text.trim().isEmpty) return false;
    try {
      final now = DateTime.now();
      await _firestore
          .collection(_matchesCollection)
          .doc(matchId)
          .collection(_messagesSub)
          .add({
        'senderId': userId,
        'text': text.trim(),
        'createdAt': Timestamp.fromDate(now),
      });
      await updateMatchLastSeen(matchId);
      return true;
    } catch (e) {
      debugPrint('❌ sendMessage hatası: $e');
      return false;
    }
  }

  /// 10 dakikadan eski mesajları sil (açılışta çağrılır)
  Future<void> deleteMessagesOlderThan(String matchId, [Duration? duration]) async {
    final d = duration ?? messageExpiry;
    final cutoff = DateTime.now().subtract(d);
    try {
      final snap = await _firestore
          .collection(_matchesCollection)
          .doc(matchId)
          .collection(_messagesSub)
          .where('createdAt', isLessThan: Timestamp.fromDate(cutoff))
          .get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('❌ deleteMessagesOlderThan hatası: $e');
    }
  }

  /// Eşleşme dokümanında benim lastSeen alanımı güncelle
  Future<void> updateMatchLastSeen(String matchId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    try {
      final doc = await _firestore.collection(_matchesCollection).doc(matchId).get();
      if (!doc.exists) return;
      final d = doc.data()!;
      final now = Timestamp.fromDate(DateTime.now());
      if (d['user1Id'] == userId) {
        await doc.reference.update({'user1LastSeenAt': now});
      } else if (d['user2Id'] == userId) {
        await doc.reference.update({'user2LastSeenAt': now});
      }
    } catch (e) {
      debugPrint('❌ updateMatchLastSeen hatası: $e');
    }
  }
}
