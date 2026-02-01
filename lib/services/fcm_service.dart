/// SOLICAP - Firebase Cloud Messaging (FCM) Servisi
/// Push bildirimler: güncelleme, duyuru, bilgilendirme.
/// Token Firestore'da user_fcm_tokens/{userId} olarak saklanır.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

/// Arka planda gelen mesaj (top-level fonksiyon olmalı)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 FCM arka plan: ${message.notification?.title}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  static const String _collection = 'user_fcm_tokens';
  bool _initialized = false;

  /// FCM başlat: izin, dinleyiciler, token dinleme
  Future<void> initialize() async {
    if (_initialized) return;

    // Arka plan mesaj handler (Android)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // İzin (iOS, web, Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('🔔 FCM izin: ${settings.authorizationStatus}');

    // Foreground mesaj
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Bildirime tıklanınca (uygulama arka plandan açılır)
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Token yenilendiğinde Firestore'a yaz (giriş yapmış kullanıcı varsa)
    _messaging.onTokenRefresh.listen((_) => saveTokenForCurrentUser());

    _initialized = true;
    debugPrint('🔔 FCM servisi hazır');

    // Giriş yapmış kullanıcı varsa token'ı kaydet
    await saveTokenForCurrentUser();
  }

  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 FCM foreground: ${message.notification?.title}');
    // İstersen burada yerel bildirim gösterilebilir (flutter_local_notifications)
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('🔔 FCM tıklandı: ${message.notification?.title}');
    // payload ile ekrana yönlendirme yapılabilir (data.screen vs.)
  }

  /// Uygulama kapalıyken bildirimle açıldıysa
  Future<RemoteMessage?> getInitialMessage() async {
    return _messaging.getInitialMessage();
  }

  /// Mevcut FCM token'ını al
  Future<String?> getToken() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) return null;
    }
    return _messaging.getToken();
  }

  /// Giriş yapmış kullanıcının token'ını Firestore'a yaz (güncelleme/duyuru için)
  /// Giriş yapmamışsa bir şey yapmaz. Login veya Splash sonrası çağrılmalı.
  Future<void> saveTokenForCurrentUser() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return;

      await _firestore.collection(_collection).doc(userId).set({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('🔔 FCM token Firestore’a yazıldı');
    } catch (e) {
      debugPrint('❌ FCM token kaydetme hatası: $e');
    }
  }

  /// Çıkış yapıldığında token dokümanını sil (opsiyonel)
  Future<void> deleteTokenForCurrentUser() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      debugPrint('❌ FCM token silme hatası: $e');
    }
  }
}
