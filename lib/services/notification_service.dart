/// SOLICAP - Notification Service v2
/// Akıllı bildirimler: Analiz yenileme, yarım ünite, haftalık özet, yeni içerik
/// Kural: Günde maksimum 1 bildirim. Öncelik sırası uygulanır.

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Bildirim türleri (öncelik sırasına göre)
enum NotificationType {
  newContent,          // 1. Yeni içerik (en yüksek öncelik)
  analysisReminder,    // 2. 7 günlük analiz yenileme
  incompleteUnit,      // 3. Yarım kalan ünite (2 gün sonra)
  weeklySummary,       // 4. Haftalık özet (Pazar akşamı)
}

/// Yerel Bildirim Servisi
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notificationsField;
  FlutterLocalNotificationsPlugin get _notifications =>
      _notificationsField ??= FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Notification IDs
  static const int _analysisReminderId = 3001;
  static const int _incompleteUnitId = 3002;
  static const int _weeklySummaryId = 3003;
  static const int _newContentId = 3004;

  // SharedPreferences keys
  static const String _keyLastAnalysisDate = 'notif_last_analysis_date';
  static const String _keyLastIncompleteUnit = 'notif_last_incomplete_unit';
  static const String _keyLastIncompleteUnitDate = 'notif_last_incomplete_unit_date';
  static const String _keyLastNotifDate = 'notif_last_notification_date';
  static const String _keyNewContentVersion = 'notif_new_content_version';
  static const String _keyNewContentShown = 'notif_new_content_shown';

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('⚠️ Timezone hatası: $e');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('🔔 NotificationService v2 hazır');
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Bildirime tıklandı: ${response.payload}');
  }

  /// İzin iste
  Future<bool> requestPermission() async {
    if (!_isInitialized) await initialize();

    final iosImpl = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      return await iosImpl.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }

    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      return await androidImpl.requestNotificationsPermission() ?? false;
    }

    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // 📊 ANALİZ YENİLEME HATIRLATMASI (7 gün)
  // ═══════════════════════════════════════════════════════════════

  /// Analiz tarihini kaydet (analiz yapıldığında çağrılır)
  Future<void> markAnalysisDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastAnalysisDate, DateTime.now().toIso8601String());
    debugPrint('🔔 Analiz tarihi kaydedildi');
  }

  /// 7 gün geçtiyse analiz hatırlatması zamanla
  Future<bool> _scheduleAnalysisReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final lastStr = prefs.getString(_keyLastAnalysisDate);
    if (lastStr == null) return false; // Hiç analiz yapılmamış, hatırlatma

    final lastDate = DateTime.tryParse(lastStr);
    if (lastDate == null) return false;

    final daysSince = DateTime.now().difference(lastDate).inDays;
    if (daysSince < 7) return false; // Henüz 7 gün olmamış

    // Yarın saat 19:00'da hatırlat
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final scheduledTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 19, 0);

    await _scheduleNotification(
      id: _analysisReminderId,
      title: '📊 Haftalık Analizin Hazır',
      body: 'Son analizinden $daysSince gün geçti. Gelişimini görmek için analizi yenile!',
      scheduledTime: scheduledTime,
      channelId: 'analysis_reminder',
      channelName: 'Analiz Hatırlatıcı',
      payload: 'analysis_reminder',
    );

    debugPrint('🔔 Analiz hatırlatması zamanlandı ($daysSince gün geçmiş)');
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // 📚 YARIM ÜNİTE HATIRLATMASI (2 gün sonra)
  // ═══════════════════════════════════════════════════════════════

  /// Yarım kalan üniteyi kaydet (ünite pratiği bitip sınav çözülmediğinde çağrılır)
  Future<void> markIncompleteUnit(String unitTitle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastIncompleteUnit, unitTitle);
    await prefs.setString(_keyLastIncompleteUnitDate, DateTime.now().toIso8601String());
    debugPrint('🔔 Yarım ünite kaydedildi: $unitTitle');
  }

  /// Yarım ünite kaydını temizle (ünite tamamlandığında çağrılır)
  Future<void> clearIncompleteUnit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLastIncompleteUnit);
    await prefs.remove(_keyLastIncompleteUnitDate);
  }

  /// 2 gün geçtiyse yarım ünite hatırlatması
  Future<bool> _scheduleIncompleteUnitReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final unitTitle = prefs.getString(_keyLastIncompleteUnit);
    final dateStr = prefs.getString(_keyLastIncompleteUnitDate);
    if (unitTitle == null || dateStr == null) return false;

    final lastDate = DateTime.tryParse(dateStr);
    if (lastDate == null) return false;

    final daysSince = DateTime.now().difference(lastDate).inDays;
    if (daysSince < 2) return false; // Henüz 2 gün olmamış

    // Yarın saat 18:00'da hatırlat
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final scheduledTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18, 0);

    await _scheduleNotification(
      id: _incompleteUnitId,
      title: '📚 Yarım Kalan Üniten Var',
      body: '$unitTitle ünitesinde sınavın kaldı. Tamamla ve bir sonrakine geç!',
      scheduledTime: scheduledTime,
      channelId: 'incomplete_unit',
      channelName: 'Ünite Hatırlatıcı',
      payload: 'incomplete_unit',
    );

    debugPrint('🔔 Yarım ünite hatırlatması zamanlandı: $unitTitle ($daysSince gün)');
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // 📅 HAFTALIK ÖZET (Pazar akşamı)
  // ═══════════════════════════════════════════════════════════════

  /// Haftalık özet bildirimini zamanla
  Future<bool> _scheduleWeeklySummary({int weeklyQuestionCount = 0}) async {
    // Sadece Pazar gününe zamanla
    final now = DateTime.now();
    
    // Bir sonraki Pazar'ı bul
    int daysUntilSunday = DateTime.sunday - now.weekday;
    if (daysUntilSunday <= 0) daysUntilSunday += 7; // Bu Pazar geçtiyse gelecek hafta
    
    final nextSunday = now.add(Duration(days: daysUntilSunday));
    final scheduledTime = DateTime(nextSunday.year, nextSunday.month, nextSunday.day, 20, 0);

    final body = weeklyQuestionCount > 0
        ? 'Bu hafta $weeklyQuestionCount soru çözdün. Devam et!'
        : 'Bu hafta henüz soru çözmedin. 5 dakika yeter, bir dene!';

    await _scheduleNotification(
      id: _weeklySummaryId,
      title: '📅 Haftalık Özet',
      body: body,
      scheduledTime: scheduledTime,
      channelId: 'weekly_summary',
      channelName: 'Haftalık Özet',
      payload: 'weekly_summary',
    );

    debugPrint('🔔 Haftalık özet zamanlandı: $scheduledTime');
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // 🆕 YENİ İÇERİK BİLDİRİMİ (Local banner desteği)
  // ═══════════════════════════════════════════════════════════════

  /// Yeni içerik versiyonunu kaydet (uygulama güncellemesinde)
  /// contentVersion: "matematik_v1", "tarih_v1" gibi benzersiz bir string
  Future<void> setNewContentVersion(String contentVersion) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNewContentVersion, contentVersion);
    await prefs.setBool(_keyNewContentShown, false);
  }

  /// Yeni içerik banner'ı gösterilmeli mi?
  Future<bool> shouldShowNewContentBanner() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getString(_keyNewContentVersion);
    final shown = prefs.getBool(_keyNewContentShown) ?? true;
    return version != null && !shown;
  }

  /// Yeni içerik başlığını getir
  Future<String?> getNewContentVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNewContentVersion);
  }

  /// Banner gösterildi olarak işaretle
  Future<void> markNewContentBannerShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNewContentShown, true);
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔄 ANA ZAMANLAMA - Günde max 1 bildirim kuralı
  // ═══════════════════════════════════════════════════════════════

  /// Tüm bildirimleri öncelik sırasına göre zamanla
  /// Günde sadece 1 bildirim gönderilir.
  /// Öncelik: Yeni İçerik > Analiz > Yarım Ünite > Haftalık Özet
  Future<void> refreshScheduledNotifications({int weeklyQuestionCount = 0}) async {
    try {
      if (!_isInitialized) await initialize();

      // Mevcut bildirimleri temizle
      await _notifications.cancelAll();

      // Bugün zaten bildirim gönderildi mi?
      final prefs = await SharedPreferences.getInstance();
      final lastNotifStr = prefs.getString(_keyLastNotifDate);
      if (lastNotifStr != null) {
        final lastNotifDate = DateTime.tryParse(lastNotifStr);
        if (lastNotifDate != null && _isSameDay(lastNotifDate, DateTime.now())) {
          debugPrint('🔔 Bugün zaten bildirim zamanlanmış, atlanıyor');
          return;
        }
      }

      // Öncelik sırasıyla dene (ilk başarılı olan kazanır)
      bool scheduled = false;

      // 1. Analiz yenileme (7 gün)
      if (!scheduled) {
        scheduled = await _scheduleAnalysisReminder();
      }

      // 2. Yarım ünite (2 gün)
      if (!scheduled) {
        scheduled = await _scheduleIncompleteUnitReminder();
      }

      // 3. Haftalık özet (Pazar)
      if (!scheduled) {
        scheduled = await _scheduleWeeklySummary(weeklyQuestionCount: weeklyQuestionCount);
      }

      if (scheduled) {
        await prefs.setString(_keyLastNotifDate, DateTime.now().toIso8601String());
      }

      debugPrint('🔔 Bildirim zamanlaması tamamlandı (zamanlandı: $scheduled)');
    } catch (e) {
      debugPrint('❌ Bildirim zamanlama hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🛠️ YARDIMCI METODLAR
  // ═══════════════════════════════════════════════════════════════

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
    required String channelName,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    // Geçmiş zaman kontrolü
    if (scheduledTime.isBefore(DateTime.now())) {
      debugPrint('⚠️ Bildirim zamanı geçmiş, atlanıyor: $scheduledTime');
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6366F1),
          enableVibration: true,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Anında bildirim göster
  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'instant',
          'Anlık Bildirimler',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF6366F1),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Tüm bildirimleri iptal et
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Belirli bir bildirimi iptal et
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
