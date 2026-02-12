/// SOLICAP - Leaderboard Service
/// Liderlik tablosu, puan yönetimi ve hile önleme

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/leaderboard_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  
  // Rate limiting
  DateTime? _lastActionTime;
  static const Duration _rateLimit = Duration(seconds: 30);
  
  // Oturum takibi
  DateTime? _sessionStart;
  static const Duration _maxSessionDuration = Duration(minutes: 60);
  
  /// Singleton
  static final LeaderboardService _instance = LeaderboardService._internal();
  factory LeaderboardService() => _instance;
  LeaderboardService._internal() {
    _sessionStart = DateTime.now();
  }

  /// Kullanıcı ID'si
  String? get _userId => _authService.currentUser?.uid;

  // ══════════════════════════════════════════════════════════════════════════
  // PUAN YÖNETİMİ
  // ══════════════════════════════════════════════════════════════════════════

  /// Puan ekle (rate limit ve flag kontrolü ile)
  Future<bool> addPoints(int points, String actionType) async {
    if (_userId == null) return false;
    
    // Rate limit kontrolü
    if (!await _checkRateLimit()) {
      debugPrint('⚠️ Rate limit: 30sn beklenmeli');
      await _addFlag('rate_limit_exceeded');
      return false;
    }
    
    // Oturum süresi kontrolü
    await _checkSessionDuration();
    
    // Ban kontrolü
    if (await _isUserBanned()) {
      debugPrint('🚫 Kullanıcı liderlikten yasaklı');
      return false;
    }
    
    try {
      final dna = await _dnaService.getDNA();
      final displayName = dna?.userName ?? 'Öğrenci';
      final gradeGroup = getGradeGroup(
        dna?.gradeLevel,
        targetExam: dna?.targetExam,
        level: dna?.level,
      );
      final weekStart = _getCurrentWeekStart();
      
      // Tüm zamanlar güncelle
      await _updatePoints(
        collection: 'leaderboard/allTime/entries',
        displayName: displayName,
        points: points,
        gradeGroup: gradeGroup,
      );
      
      // Haftalık güncelle
      await _updatePoints(
        collection: 'leaderboard/weekly/entries',
        displayName: displayName,
        points: points,
        gradeGroup: gradeGroup,
        weekStart: weekStart,
      );
      
      _lastActionTime = DateTime.now();
      debugPrint('✅ +$points puan eklendi ($actionType)');
      return true;
    } catch (e) {
      debugPrint('❌ Puan ekleme hatası: $e');
      return false;
    }
  }

  /// 🔄 Profil değiştiğinde leaderboard gradeGroup'unu güncelle
  Future<void> updateGradeGroup() async {
    if (_userId == null) return;
    try {
      final dna = await _dnaService.getDNA();
      final gradeGroup = getGradeGroup(
        dna?.gradeLevel,
        targetExam: dna?.targetExam,
        level: dna?.level,
      );
      final gradeGroupStr = gradeGroupToString(gradeGroup);

      // Tüm zamanlar tablosunu güncelle
      final allTimeRef = _firestore.collection('leaderboard/allTime/entries').doc(_userId);
      final allTimeDoc = await allTimeRef.get();
      if (allTimeDoc.exists) {
        await allTimeRef.update({'gradeGroup': gradeGroupStr});
      }

      // Haftalık tabloyu güncelle
      final weeklyRef = _firestore.collection('leaderboard/weekly/entries').doc(_userId);
      final weeklyDoc = await weeklyRef.get();
      if (weeklyDoc.exists) {
        await weeklyRef.update({'gradeGroup': gradeGroupStr});
      }

      debugPrint('✅ Leaderboard gradeGroup güncellendi: $gradeGroupStr');
    } catch (e) {
      debugPrint('❌ GradeGroup güncelleme hatası: $e');
    }
  }

  /// Belirli bir kullanıcıya uygulama puanı ekle (Challenge kazanan/kaybeden için)
  /// Rate limit yok; challenge sonucu sunucu tarafı dağıtımı.
  Future<bool> addPointsToUser(String targetUserId, int points, String actionType) async {
    try {
      final dnaDoc = await _firestore.collection('user_dna').doc(targetUserId).get();
      final data = dnaDoc.data();
      final displayName = data?['userName'] as String? ?? 'Öğrenci';
      final gradeGroup = getGradeGroup(
        data?['gradeLevel'] as String?,
        targetExam: data?['targetExam'] as String?,
        level: data?['level'] as String?,
      );
      final weekStart = _getCurrentWeekStart();

      await _updatePointsForUser(
        targetUserId: targetUserId,
        collection: 'leaderboard/allTime/entries',
        displayName: displayName,
        points: points,
        gradeGroup: gradeGroup,
      );
      await _updatePointsForUser(
        targetUserId: targetUserId,
        collection: 'leaderboard/weekly/entries',
        displayName: displayName,
        points: points,
        gradeGroup: gradeGroup,
        weekStart: weekStart,
      );
      debugPrint('✅ +$points uygulama puanı eklendi: $targetUserId ($actionType)');
      return true;
    } catch (e) {
      debugPrint('❌ addPointsToUser hatası: $e');
      return false;
    }
  }

  /// Puan güncelle (internal) - giriş yapan kullanıcı
  Future<void> _updatePoints({
    required String collection,
    required String displayName,
    required int points,
    required GradeGroup gradeGroup,
    String? weekStart,
  }) async {
    final docRef = _firestore.collection(collection).doc(_userId);
    
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      
      if (doc.exists) {
        // Haftalık için: farklı hafta ise sıfırla
        if (weekStart != null) {
          final existingWeekStart = doc.data()?['weekStart'];
          if (existingWeekStart != weekStart) {
            // Yeni hafta, sıfırdan başla
            transaction.set(docRef, {
              'displayName': displayName,
              'points': points,
              'gradeGroup': gradeGroupToString(gradeGroup),
              'lastUpdate': FieldValue.serverTimestamp(),
              'weekStart': weekStart,
            });
            return;
          }
        }
        
        // Mevcut puana ekle
        final currentPoints = doc.data()?['points'] ?? 0;
        transaction.update(docRef, {
          'displayName': displayName,
          'points': currentPoints + points,
          'lastUpdate': FieldValue.serverTimestamp(),
        });
      } else {
        // Yeni kayıt
        transaction.set(docRef, {
          'displayName': displayName,
          'points': points,
          'gradeGroup': gradeGroupToString(gradeGroup),
          'lastUpdate': FieldValue.serverTimestamp(),
          if (weekStart != null) 'weekStart': weekStart,
        });
      }
    });
  }

  /// Puan güncelle (internal) - belirli userId için (Challenge ödülü)
  Future<void> _updatePointsForUser({
    required String targetUserId,
    required String collection,
    required String displayName,
    required int points,
    required GradeGroup gradeGroup,
    String? weekStart,
  }) async {
    final docRef = _firestore.collection(collection).doc(targetUserId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);

      if (doc.exists) {
        if (weekStart != null) {
          final existingWeekStart = doc.data()?['weekStart'];
          if (existingWeekStart != weekStart) {
            transaction.set(docRef, {
              'displayName': displayName,
              'points': points,
              'gradeGroup': gradeGroupToString(gradeGroup),
              'lastUpdate': FieldValue.serverTimestamp(),
              'weekStart': weekStart,
            });
            return;
          }
        }
        final currentPoints = doc.data()?['points'] ?? 0;
        transaction.update(docRef, {
          'displayName': displayName,
          'points': currentPoints + points,
          'lastUpdate': FieldValue.serverTimestamp(),
        });
      } else {
        transaction.set(docRef, {
          'displayName': displayName,
          'points': points,
          'gradeGroup': gradeGroupToString(gradeGroup),
          'lastUpdate': FieldValue.serverTimestamp(),
          if (weekStart != null) 'weekStart': weekStart,
        });
      }
    });
  }

  /// Kullanıcının toplam puanını al
  Future<int> getUserPoints({bool weekly = false}) async {
    if (_userId == null) return 0;
    
    try {
      final collection = weekly ? 'leaderboard/weekly/entries' : 'leaderboard/allTime/entries';
      final doc = await _firestore.collection(collection).doc(_userId).get();
      
      if (doc.exists) {
        final data = doc.data();
        
        // Haftalık için hafta kontrolü
        if (weekly && data != null) {
          final weekStart = data['weekStart'];
          if (weekStart != _getCurrentWeekStart()) {
            return 0; // Farklı hafta, sıfır göster
          }
        }
        
        return data?['points'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('❌ Puan okuma hatası: $e');
      return 0;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LİDERLİK TABLOSU
  // ══════════════════════════════════════════════════════════════════════════

  /// Tüm zamanların liderlik tablosunu getir (iki grup birlikte)
  Future<Map<GradeGroup, List<LeaderboardEntry>>> getAllTimeLeaderboard() async {
    try {
      final snapshot = await _firestore
          .collection('leaderboard/allTime/entries')
          .orderBy('points', descending: true)
          .limit(100) // Her gruptan max 10 almak için fazla çek
          .get();
      
      final entries = snapshot.docs.map((doc) => LeaderboardEntry.fromFirestore(doc)).toList();
      
      // Gruplara ayır ve ilk 10'u al
      final elementary = entries.where((e) => e.gradeGroup == GradeGroup.elementary).take(10).toList();
      final highSchool = entries.where((e) => e.gradeGroup == GradeGroup.highSchool).take(10).toList();
      final university = entries.where((e) => e.gradeGroup == GradeGroup.university).take(10).toList();
      
      return {
        GradeGroup.elementary: elementary,
        GradeGroup.highSchool: highSchool,
        GradeGroup.university: university,
      };
    } catch (e) {
      debugPrint('❌ Tüm zamanlar liderlik hatası: $e');
      return {
        GradeGroup.elementary: [],
        GradeGroup.highSchool: [],
        GradeGroup.university: [],
      };
    }
  }

  /// Kullanıcının sıralamasını getir
  Future<int> getUserRank({bool weekly = false, GradeGroup? gradeGroup}) async {
    if (_userId == null) return -1;
    
    try {
      final userPoints = await getUserPoints(weekly: weekly);
      if (userPoints == 0) return -1;
      
      final collection = weekly ? 'leaderboard/weekly/entries' : 'leaderboard/allTime/entries';
      
      Query query = _firestore.collection(collection).where('points', isGreaterThan: userPoints);
      
      if (weekly && gradeGroup != null) {
        final gradeGroupStr = gradeGroupToString(gradeGroup);
        query = query.where('gradeGroup', isEqualTo: gradeGroupStr);
      }
      
      final count = await query.count().get();
      return (count.count ?? 0) + 1;
    } catch (e) {
      debugPrint('❌ Sıralama hatası: $e');
      return -1;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HİLE ÖNLEME
  // ══════════════════════════════════════════════════════════════════════════

  /// Rate limit kontrolü
  Future<bool> _checkRateLimit() async {
    if (_lastActionTime == null) return true;
    
    final elapsed = DateTime.now().difference(_lastActionTime!);
    return elapsed >= _rateLimit;
  }

  /// Oturum süresi kontrolü
  Future<void> _checkSessionDuration() async {
    if (_sessionStart == null) {
      _sessionStart = DateTime.now();
      return;
    }
    
    final elapsed = DateTime.now().difference(_sessionStart!);
    if (elapsed >= _maxSessionDuration) {
      await _addFlag('long_session');
      _sessionStart = DateTime.now(); // Reset
    }
  }

  /// Flag ekle
  Future<void> _addFlag(String reason) async {
    if (_userId == null) return;
    
    try {
      final docRef = _firestore.collection('leaderboard/flags/users').doc(_userId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        if (doc.exists) {
          final currentCount = doc.data()?['flagCount'] ?? 0;
          final newCount = currentCount + 1;
          
          transaction.update(docRef, {
            'flagCount': newCount,
            'lastFlagDate': FieldValue.serverTimestamp(),
            'reasons': FieldValue.arrayUnion([reason]),
            'isBanned': newCount >= 20,
          });
          
          if (newCount >= 20) {
            debugPrint('🔴 KIRMIZI KART: Kullanıcı liderlikten yasaklandı');
          }
        } else {
          transaction.set(docRef, {
            'flagCount': 1,
            'lastFlagDate': FieldValue.serverTimestamp(),
            'reasons': [reason],
            'isBanned': false,
          });
        }
      });
      
      debugPrint('🚩 Flag eklendi: $reason');
    } catch (e) {
      debugPrint('❌ Flag ekleme hatası: $e');
    }
  }

  /// Kullanıcı yasaklı mı?
  Future<bool> _isUserBanned() async {
    if (_userId == null) return false;
    
    try {
      final doc = await _firestore
          .collection('leaderboard/flags/users')
          .doc(_userId)
          .get();
      
      return doc.data()?['isBanned'] ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Kullanıcının flag sayısını getir
  Future<int> getUserFlagCount() async {
    if (_userId == null) return 0;
    
    try {
      final doc = await _firestore
          .collection('leaderboard/flags/users')
          .doc(_userId)
          .get();
      
      return doc.data()?['flagCount'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ADMIN İŞLEMLERİ
  // ══════════════════════════════════════════════════════════════════════════

  /// Tüm flag'leri getir (admin için)
  Future<List<UserFlags>> getAllFlags() async {
    try {
      final snapshot = await _firestore
          .collection('leaderboard/flags/users')
          .where('flagCount', isGreaterThan: 0)
          .orderBy('flagCount', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => UserFlags.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Flag listesi hatası: $e');
      return [];
    }
  }

  /// Kullanıcıyı temize al (admin)
  Future<void> clearUserFlags(String userId) async {
    try {
      await _firestore.collection('leaderboard/flags/users').doc(userId).delete();
      debugPrint('✅ Kullanıcı flag\'leri temizlendi: $userId');
    } catch (e) {
      debugPrint('❌ Flag temizleme hatası: $e');
    }
  }

  /// Kullanıcıyı yasakla (admin)
  Future<void> banUser(String userId) async {
    try {
      await _firestore.collection('leaderboard/flags/users').doc(userId).update({
        'isBanned': true,
      });
      debugPrint('🚫 Kullanıcı yasaklandı: $userId');
    } catch (e) {
      debugPrint('❌ Ban hatası: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // YARDIMCI METODLAR
  // ══════════════════════════════════════════════════════════════════════════

  /// Mevcut haftanın başlangıç tarihi (Pazartesi)
  String _getCurrentWeekStart() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  /// Oturumu sıfırla (uygulama açılışında)
  void resetSession() {
    _sessionStart = DateTime.now();
    _lastActionTime = null;
  }
}
