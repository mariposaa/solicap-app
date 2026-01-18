/// SOLICAP - Gamification Service
/// Rozet ve başarı sistemi yönetimi

import 'dart:ui' show Color;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/badge_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();

  // 🏆 TÜM ROZETLER (Statik tanımlı)
  static const List<Badge> allBadges = [
    // 📊 SORU SAYISI
    Badge(
      id: 'first_10',
      name: 'İlk Adım',
      description: '10 soru çözüldü',
      emoji: '🎯',
      category: BadgeCategory.questionCount,
      targetValue: 10,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'first_50',
      name: 'Azimli Öğrenci',
      description: '50 soru çözüldü',
      emoji: '📚',
      category: BadgeCategory.questionCount,
      targetValue: 50,
      rarity: BadgeRarity.uncommon,
    ),
    Badge(
      id: 'first_100',
      name: 'Yüzlük Kulüp',
      description: '100 soru çözüldü',
      emoji: '💯',
      category: BadgeCategory.questionCount,
      targetValue: 100,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'first_500',
      name: 'Soru Canavarı',
      description: '500 soru çözüldü',
      emoji: '🦁',
      category: BadgeCategory.questionCount,
      targetValue: 500,
      rarity: BadgeRarity.legendary,
    ),
    
    // 🔥 SERİ
    Badge(
      id: 'streak_3',
      name: 'Isınma Turu',
      description: '3 gün üst üste çalış',
      emoji: '🔥',
      category: BadgeCategory.streak,
      targetValue: 3,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'streak_7',
      name: 'Hafta Savaşçısı',
      description: '7 gün üst üste çalış',
      emoji: '⚡',
      category: BadgeCategory.streak,
      targetValue: 7,
      rarity: BadgeRarity.uncommon,
    ),
    Badge(
      id: 'streak_30',
      name: 'Demir İrade',
      description: '30 gün üst üste çalış',
      emoji: '🏆',
      category: BadgeCategory.streak,
      targetValue: 30,
      rarity: BadgeRarity.legendary,
    ),
    
    // 🎯 BAŞARI ORANI
    Badge(
      id: 'accuracy_70',
      name: 'Dengeli',
      description: '%70 başarı oranı',
      emoji: '⚖️',
      category: BadgeCategory.accuracy,
      targetValue: 70,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'accuracy_85',
      name: 'Keskin Nişancı',
      description: '%85 başarı oranı',
      emoji: '🎯',
      category: BadgeCategory.accuracy,
      targetValue: 85,
      rarity: BadgeRarity.rare,
    ),
    Badge(
      id: 'accuracy_95',
      name: 'Mükemmeliyetçi',
      description: '%95 başarı oranı',
      emoji: '💎',
      category: BadgeCategory.accuracy,
      targetValue: 95,
      rarity: BadgeRarity.legendary,
    ),
    
    // 📖 KONU USTALIĞI
    Badge(
      id: 'topic_master_1',
      name: 'İlk Ustalık',
      description: 'Bir konuda %80+ başarı',
      emoji: '⭐',
      category: BadgeCategory.topicMastery,
      targetValue: 1,
      rarity: BadgeRarity.common,
    ),
    Badge(
      id: 'topic_master_5',
      name: 'Çok Yönlü',
      description: '5 konuda %80+ başarı',
      emoji: '🌟',
      category: BadgeCategory.topicMastery,
      targetValue: 5,
      rarity: BadgeRarity.rare,
    ),
  ];

  /// Kullanıcının rozet durumunu getir
  Future<List<BadgeProgress>> getBadgeProgress() async {
    final dna = await _dnaService.getDNA();
    final earnedBadges = await _getEarnedBadges();
    
    final progressList = <BadgeProgress>[];
    
    for (final badge in allBadges) {
      int currentValue = 0;
      
      // Kategori bazlı ilerleme hesapla
      switch (badge.category) {
        case BadgeCategory.questionCount:
          currentValue = dna?.totalQuestionsSolved ?? 0;
          break;
        case BadgeCategory.streak:
          currentValue = 0; // TODO: DNA modeline streak eklenince güncellenecek
          break;
        case BadgeCategory.accuracy:
          currentValue = ((dna?.overallSuccessRate ?? 0) * 100).toInt();
          break;
        case BadgeCategory.topicMastery:
          currentValue = dna?.strongTopics.length ?? 0;
          break;
        case BadgeCategory.special:
          currentValue = 0; // Özel etkinlikler için ayrı logic
          break;
      }
      
      final earnedBadge = earnedBadges.firstWhere(
        (e) => e.badgeId == badge.id,
        orElse: () => EarnedBadge(
          badgeId: '',
          earnedAt: DateTime.now(),
          valueAtEarning: 0,
        ),
      );
      
      final isEarned = earnedBadge.badgeId.isNotEmpty || currentValue >= badge.targetValue;
      
      progressList.add(BadgeProgress(
        badge: badge,
        currentValue: currentValue,
        isEarned: isEarned,
        earnedAt: isEarned ? earnedBadge.earnedAt : null,
      ));
    }
    
    return progressList;
  }

  /// Kazanılan rozetleri getir
  Future<List<EarnedBadge>> _getEarnedBadges() async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      final doc = await _firestore
          .collection('user_badges')
          .doc(userId)
          .get();
      
      if (!doc.exists) return [];
      
      final badges = doc.data()?['badges'] as List<dynamic>? ?? [];
      return badges.map((b) => EarnedBadge.fromMap(b)).toList();
    } catch (e) {
      debugPrint('❌ Rozet getirme hatası: $e');
      return [];
    }
  }

  /// Yeni rozet kazan
  Future<Badge?> checkAndAwardBadges() async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    final progress = await getBadgeProgress();
    final earnedBadges = await _getEarnedBadges();
    final earnedIds = earnedBadges.map((e) => e.badgeId).toSet();
    
    // Yeni kazanılan rozetleri bul
    for (final p in progress) {
      if (p.isEarned && !earnedIds.contains(p.badge.id)) {
        // Yeni rozet kazanıldı!
        await _saveBadge(userId, p.badge, p.currentValue);
        debugPrint('🏆 Yeni rozet kazanıldı: ${p.badge.name}');
        return p.badge;
      }
    }
    
    return null;
  }

  /// Rozeti kaydet
  Future<void> _saveBadge(String userId, Badge badge, int valueAtEarning) async {
    try {
      await _firestore
          .collection('user_badges')
          .doc(userId)
          .set({
            'badges': FieldValue.arrayUnion([
              {
                'badgeId': badge.id,
                'earnedAt': FieldValue.serverTimestamp(),
                'valueAtEarning': valueAtEarning,
              }
            ]),
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ Rozet kaydetme hatası: $e');
    }
  }

  /// Rozet nadirlik rengini getir
  static Color getRarityColor(BadgeRarity rarity) {
    switch (rarity) {
      case BadgeRarity.common:
        return const Color(0xFFCD7F32); // Bronz
      case BadgeRarity.uncommon:
        return const Color(0xFFC0C0C0); // Gümüş
      case BadgeRarity.rare:
        return const Color(0xFFFFD700); // Altın
      case BadgeRarity.legendary:
        return const Color(0xFF00D4FF); // Elmas
    }
  }
}
