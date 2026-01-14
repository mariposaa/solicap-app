/// SOLICAP - Notification Service
/// Yerel bildirimler: Streak koruma, tekrar hatırlatması, optimal saat
/// Sprint 4B - Local Notifications

import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'smart_study_planner_service.dart';
import 'learning_insights_service.dart';
import 'session_tracking_service.dart';

/// Bildirim türleri
enum NotificationType {
  streakWarning,      // Streak tehlikede
  optimalStudyTime,   // En verimli saat
  spacedRepetition,   // Tekrar zamanı geldi
  dailyReminder,      // Günlük hatırlatma
}

/// Yerel Bildirim Servisi
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FlutterLocalNotificationsPlugin? _notificationsField;
  FlutterLocalNotificationsPlugin get _notifications => _notificationsField ??= FlutterLocalNotificationsPlugin();
  
  LearningInsightsService get _insightsService => LearningInsightsService();
  SessionTrackingService get _sessionTracker => SessionTrackingService();

  bool _isInitialized = false;

  // Notification IDs
  static const int _streakWarningId = 1001;
  static const int _optimalTimeId = 1002;
  static const int _dailyReminderId = 1003;
  static const int _spacedRepBaseId = 2000;

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Timezone verilerini yükle
    tz_data.initializeTimeZones();

    // Android ayarları
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // iOS ayarları
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    debugPrint('🔔 NotificationService initialized');
  }

  /// Bildirime tıklanınca
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    // Burada navigation yapılabilir
  }

  /// İzin iste (iOS için)
  Future<bool> requestPermission() async {
    if (!_isInitialized) await initialize();

    // iOS için izin iste
    final iosImpl = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    // Android 13+ için izin iste
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔥 STREAK KORUMA BİLDİRİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Streak koruma bildirimi zamanla
  Future<void> scheduleStreakWarning() async {
    if (!_isInitialized) await initialize();

    // Bugün çalışma var mı kontrol et
    final today = await _sessionTracker.getTodaySnapshot();
    final insights = await _insightsService.calculateInsights();

    // Streak > 0 ve bugün çalışma yoksa 20:00'da uyar
    if (insights.currentStreak > 0 && (today?.questionsAttempted ?? 0) == 0) {
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, 20, 0);
      
      // Eğer saat 20:00'ı geçtiyse, bildirimi atlayalım
      if (now.hour >= 20) {
        debugPrint('🔔 Saat 20:00 geçti, streak uyarısı atlandı');
        return;
      }

      await _notifications.zonedSchedule(
        _streakWarningId,
        '🔥 Serinizi Koruyun!',
        '${insights.currentStreak} günlük serininiz tehlikede! Bugün bir soru çözün.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        _buildNotificationDetails(
          channelId: 'streak_warning',
          channelName: 'Streak Uyarıları',
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'streak_warning',
      );

      debugPrint('🔔 Streak uyarısı zamanlandı: $scheduledTime');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ⏰ OPTİMAL ÇALIŞMA SAATİ
  // ═══════════════════════════════════════════════════════════════

  /// Optimal çalışma saatinde hatırlatma
  Future<void> scheduleOptimalTimeReminder() async {
    if (!_isInitialized) await initialize();

    final insights = await _insightsService.calculateInsights();
    
    if (insights.peakHours.isEmpty) return;

    final bestHour = insights.peakHours.first;
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, bestHour, 0);

    // Eğer saat geçtiyse yarın için zamanla
    if (now.hour >= bestHour) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      _optimalTimeId,
      '⚡ En Verimli Saatiniz!',
      'Şu an çalışmak için en iyi zaman. Bir soru çözelim mi?',
      tz.TZDateTime.from(scheduledTime, tz.local),
      _buildNotificationDetails(
        channelId: 'optimal_time',
        channelName: 'Çalışma Hatırlatıcı',
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'optimal_time',
    );

    debugPrint('🔔 Optimal saat hatırlatması zamanlandı: $scheduledTime');
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔄 SPACED REPETITION - TEKRAR ZAMANI
  // ═══════════════════════════════════════════════════════════════

  /// Tekrar zamanı gelmiş konular için bildirim
  Future<void> scheduleSpacedRepetitionReminders() async {
    if (!_isInitialized) await initialize();

    final planner = SmartStudyPlannerService();
    final plan = await planner.generateDailyPlan();

    // Spaced repetition önerilerini bul
    final spacedReps = plan.recommendations
        .where((r) => r.type == RecommendationType.spacedRepetition)
        .toList();

    if (spacedReps.isEmpty) return;

    // Her öneri için bildirim zamanla (14:00, 15:00, 16:00...)
    int hour = 14;
    for (int i = 0; i < spacedReps.length && i < 3; i++) {
      final rec = spacedReps[i];
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, hour + i, 0);

      // Saat geçtiyse yarın için
      if (now.hour >= hour + i) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        _spacedRepBaseId + i,
        '🔄 Tekrar Zamanı: ${rec.topic ?? "Konu"}',
        rec.description,
        tz.TZDateTime.from(scheduledTime, tz.local),
        _buildNotificationDetails(
          channelId: 'spaced_repetition',
          channelName: 'Tekrar Hatırlatıcı',
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'spaced_rep_${rec.topic}',
      );

      debugPrint('🔔 Tekrar hatırlatması zamanlandı: ${rec.topic} @ $scheduledTime');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 📅 GÜNLÜK HATIRLATMA
  // ═══════════════════════════════════════════════════════════════

  /// Her gün belirli saatte hatırlatma (kullanıcı ayarlayabilir)
  Future<void> scheduleDailyReminder({int hour = 18, int minute = 0}) async {
    if (!_isInitialized) await initialize();

    // Önceki hatırlatmayı iptal et
    await _notifications.cancel(_dailyReminderId);

    await _notifications.zonedSchedule(
      _dailyReminderId,
      '📚 Günlük Çalışma',
      'Bugün hedeflerine bir adım daha yaklaş!',
      _nextInstanceOfTime(hour, minute),
      _buildNotificationDetails(
        channelId: 'daily_reminder',
        channelName: 'Günlük Hatırlatıcı',
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Her gün tekrarla
      payload: 'daily_reminder',
    );

    debugPrint('🔔 Günlük hatırlatma zamanlandı: $hour:${minute.toString().padLeft(2, '0')}');
  }

  /// Bir sonraki belirli saat
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  // ═══════════════════════════════════════════════════════════════
  // 🛠️ YARDIMCI METODLAR
  // ═══════════════════════════════════════════════════════════════

  /// Bildirim detayları oluştur
  NotificationDetails _buildNotificationDetails({
    required String channelId,
    required String channelName,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF6366F1), // Primary color
        enableVibration: true,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
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
      _buildNotificationDetails(
        channelId: 'instant',
        channelName: 'Anlık Bildirimler',
      ),
      payload: payload,
    );
  }

  /// Tüm bildirimleri iptal et
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('🔔 Tüm bildirimler iptal edildi');
  }

  /// Belirli bir bildirimi iptal et
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Bildirimleri güncelle (app açıldığında çağrılmalı)
  Future<void> refreshScheduledNotifications() async {
    try {
      await initialize();
      
      // Mevcut bildirimleri temizle
      await cancelAll();
      
      // Yeni bildirimleri zamanla (her biri ayrı try-catch ile)
      try {
        await scheduleStreakWarning();
      } catch (e) {
        debugPrint('⚠️ Streak warning hatası: $e');
      }
      
      try {
        await scheduleOptimalTimeReminder();
      } catch (e) {
        debugPrint('⚠️ Optimal time hatası: $e');
      }
      
      try {
        await scheduleSpacedRepetitionReminders();
      } catch (e) {
        debugPrint('⚠️ Spaced rep hatası: $e');
      }
      
      debugPrint('🔔 Bildirimler güncellendi');
    } catch (e) {
      debugPrint('❌ Bildirim güncelleme hatası: $e');
    }
  }
}
