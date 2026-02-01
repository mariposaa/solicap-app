/// SOLICAP - Ödül Duyuru Servisi
/// Yarışmalar ekranında mor ekran ile sıralama bölümü arasında gösterilen duyuru

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AwardAnnouncement {
  final String title;
  final String body;
  final bool isActive;
  final DateTime? updatedAt;

  AwardAnnouncement({
    required this.title,
    required this.body,
    this.isActive = true,
    this.updatedAt,
  });

  factory AwardAnnouncement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final updatedAt = data['updatedAt'] as Timestamp?;
    return AwardAnnouncement(
      title: data['title'] as String? ?? 'Ödül Duyurusu',
      body: data['body'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      updatedAt: updatedAt?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'body': body,
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  AwardAnnouncement copyWith({
    String? title,
    String? body,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return AwardAnnouncement(
      title: title ?? this.title,
      body: body ?? this.body,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static AwardAnnouncement get defaultAnnouncement => AwardAnnouncement(
        title: '🏆 Ödül Duyurusu',
        body: 'En çok puan toplayan öğrencilerimiz ödüllendirilecektir. '
            'Haftalık ve tüm zamanlar sıralamalarında üst sıralara çıkmak için soru çözmeye devam edin!',
        isActive: true,
      );
}

class AwardAnnouncementService {
  static final AwardAnnouncementService _instance = AwardAnnouncementService._internal();
  factory AwardAnnouncementService() => _instance;
  AwardAnnouncementService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _docPath = 'configs/competitions_award';

  AwardAnnouncement? _cached;
  DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Ödül duyurusunu getir (cache'li)
  Future<AwardAnnouncement> get() async {
    if (_cached != null && _lastFetch != null && DateTime.now().difference(_lastFetch!) < _cacheDuration) {
      return _cached!;
    }
    try {
      final doc = await _firestore.doc(_docPath).get();
      if (doc.exists && doc.data() != null) {
        _cached = AwardAnnouncement.fromFirestore(doc);
      } else {
        _cached = AwardAnnouncement.defaultAnnouncement;
      }
      _lastFetch = DateTime.now();
      return _cached!;
    } catch (e) {
      debugPrint('❌ Ödül duyuru yükleme hatası: $e');
      return _cached ?? AwardAnnouncement.defaultAnnouncement;
    }
  }

  /// Admin: Duyuruyu kaydet
  Future<void> save(AwardAnnouncement announcement) async {
    try {
      await _firestore.doc(_docPath).set(announcement.toFirestore(), SetOptions(merge: true));
      _cached = null;
      _lastFetch = null;
      debugPrint('✅ Ödül duyurusu kaydedildi');
    } catch (e) {
      debugPrint('❌ Ödül duyuru kaydetme hatası: $e');
      rethrow;
    }
  }

  /// Cache temizle (admin düzenlemeden sonra yenileme için)
  void clearCache() {
    _cached = null;
    _lastFetch = null;
  }
}
