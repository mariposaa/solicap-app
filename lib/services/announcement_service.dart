/// SOLICAP - Announcement Service
/// Duyuru servisi - Firebase + Cache

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/announcement_model.dart';

class AnnouncementService {
  static final AnnouncementService _instance = AnnouncementService._internal();
  factory AnnouncementService() => _instance;
  AnnouncementService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Cache
  List<Announcement>? _cachedAnnouncements;
  DateTime? _lastFetchTime;
  
  /// Cache süresi (dakika)
  static const int _cacheDurationMinutes = 5;

  /// Duyuruları getir (cache'li)
  Future<List<Announcement>> getAnnouncements({bool forceRefresh = false}) async {
    // Cache kontrolü
    if (!forceRefresh && _cachedAnnouncements != null && _lastFetchTime != null) {
      final cacheAge = DateTime.now().difference(_lastFetchTime!);
      if (cacheAge.inMinutes < _cacheDurationMinutes) {
        debugPrint('📋 Duyurular cache\'den alındı');
        return _cachedAnnouncements!;
      }
    }

    try {
      // Basit sorgu - index gerektirmez
      final snapshot = await _firestore
          .collection('announcements')
          .limit(20)
          .get();

      debugPrint('🔍 Firestore\'dan ${snapshot.docs.length} duyuru döndü');

      final announcements = snapshot.docs
          .map((doc) {
            debugPrint('📄 Duyuru: ${doc.id} - ${doc.data()}');
            return Announcement.fromFirestore(doc);
          })
          .where((a) => a.isActive) // Aktif olanlar
          .where((a) => a.canShow)  // Süresi dolmayanlar
          .toList();

      // Client-side sıralama
      announcements.sort((a, b) {
        final priorityCompare = b.priority.compareTo(a.priority);
        if (priorityCompare != 0) return priorityCompare;
        return b.createdAt.compareTo(a.createdAt);
      });

      // Cache'e kaydet
      _cachedAnnouncements = announcements.take(10).toList();
      _lastFetchTime = DateTime.now();
      
      debugPrint('✅ ${_cachedAnnouncements!.length} aktif duyuru yüklendi');
      return _cachedAnnouncements!;
    } catch (e) {
      debugPrint('❌ Duyuru yükleme hatası: $e');
      return _cachedAnnouncements ?? [];
    }
  }

  /// Cache'i temizle (pull-to-refresh için)
  void clearCache() {
    _cachedAnnouncements = null;
    _lastFetchTime = null;
  }

  /// Duyuruları yenile
  Future<List<Announcement>> refreshAnnouncements() async {
    clearCache();
    return getAnnouncements(forceRefresh: true);
  }

  /// Ana duyuruyu getir (en yüksek öncelikli)
  Future<Announcement?> getMainAnnouncement() async {
    final announcements = await getAnnouncements();
    if (announcements.isEmpty) return null;
    return announcements.first;
  }
}
