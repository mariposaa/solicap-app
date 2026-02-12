/// SOLICAP - Main Entry Point
/// AI Destekli Öğrenci Asistanı

import 'io_platform_stub.dart' if (dart.library.io) 'io_platform.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/fcm_service.dart';
import 'services/admin_service.dart';
import 'services/ad_service.dart';
import 'services/localization_service.dart';
import 'services/force_update_service.dart';
import 'services/iap_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Sistem UI ayarları - Açık tema için
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surfaceColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Yatay modu kapat (hızlı, beklemeli)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // .env dosyasını yükle (hata olursa devam et)
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('✅ .env yüklendi');
  } catch (e) {
    debugPrint('⚠️ .env yüklenemedi: $e');
  }
  
  // Firebase'i başlat (zorunlu - diğer servisler buna bağlı)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase başlatıldı');
  } catch (e) {
    debugPrint('❌ Firebase hatası: $e');
  }

  // HEMEN runApp çağır - iOS beyaz ekranı önlemek için
  runApp(const SolicapApp());

  // iOS: native launch overlay'ı ilk frame çizilince kaldır
  if (io.Platform.isIOS) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const MethodChannel('solicap/launch').invokeMethod('removeOverlay');
    });
  }

  // Ağır servisleri arka planda başlat (UI engellemeden)
  _initializeServicesInBackground();
}

/// Ağır servisleri arka planda başlat (splash screen görünürken)
Future<void> _initializeServicesInBackground() async {
  // 🔔 FCM (push bildirim) başlat
  try {
    await FcmService().initialize();
    debugPrint('✅ FCM başlatıldı');
  } catch (e) {
    debugPrint('⚠️ FCM hatası: $e');
  }
  
  // 🔔 Yerel bildirim servisini başlat
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.requestPermission();
    await notificationService.refreshScheduledNotifications();
    debugPrint('✅ Bildirimler başlatıldı');
  } catch (e) {
    debugPrint('⚠️ Bildirim hatası: $e');
  }

  // 🔐 Admin servisi başlat
  await AdminService.initialize();
  
  // 📺 AdMob başlat
  try {
    await AdService().initialize();
    debugPrint('✅ AdMob başlatıldı');
  } catch (e) {
    debugPrint('⚠️ AdMob hatası: $e');
  }
  
  // 🔄 Force Update servisi başlat
  try {
    await ForceUpdateService().initialize();
    debugPrint('✅ ForceUpdate başlatıldı');
  } catch (e) {
    debugPrint('⚠️ ForceUpdate hatası: $e');
  }

  // 💎 IAP bağlantısını başlat
  try {
    await IAPService().init();
  } catch (e) {
    debugPrint('⚠️ IAP hatası: $e');
  }
}

class SolicapApp extends StatelessWidget {
  const SolicapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOLICAP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // 🌍 Çoklu dil desteği
      supportedLocales: LocalizationService.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Telefon diline göre dil ayarla
        if (locale != null) {
          LocalizationService().setLocale(locale);
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        // Varsayılan: Türkçe
        return const Locale('tr', 'TR');
      },
      
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        );
      },
      home: const SplashScreen(),
    );
  }
}
