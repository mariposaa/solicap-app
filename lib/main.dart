/// SOLICAP - Main Entry Point
/// AI Destekli Öğrenci Asistanı

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/admin_service.dart';
import 'services/ad_service.dart';

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
  
  // Yatay modu kapat
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
  
  // Firebase'i başlat
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase başlatıldı');
  } catch (e) {
    debugPrint('❌ Firebase hatası: $e');
  }
  
  // 🔔 Bildirim servisini başlat
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
  
  // 📺 AdMob başlat (Arka planda reklam yükle)
  try {
    await AdService().initialize();
    debugPrint('✅ AdMob başlatıldı');
  } catch (e) {
    debugPrint('⚠️ AdMob hatası: $e');
  }
  
  runApp(const SolicapApp());
}

class SolicapApp extends StatelessWidget {
  const SolicapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOLICAP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
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
