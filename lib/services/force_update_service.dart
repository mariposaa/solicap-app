/// 🔄 ZORUNLU GÜNCELLEME SERVİSİ
/// Firebase Remote Config + Store Yönlendirme
/// 
/// Kullanım:
/// 1. Firebase Remote Config'de "min_version" ve "latest_version" değerlerini ayarla
/// 2. Uygulama açılışında ForceUpdateService.checkForUpdate() çağır
/// 3. Güncelleme gerekiyorsa dialog gösterilir ve store'a yönlendirilir

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateService {
  static final ForceUpdateService _instance = ForceUpdateService._internal();
  factory ForceUpdateService() => _instance;
  ForceUpdateService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  // 🏪 Store URL'leri
  static const String _playStoreUrl = 'https://play.google.com/store/apps/details?id=com.solicap.solicap';
  static const String _appStoreUrl = 'https://apps.apple.com/app/solicap/id6757821914';

  /// Remote Config'i başlat
  Future<void> initialize() async {
    try {
      // Fetch ayarları
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1), // Production'da 1 saat
      ));

      // Varsayılan değerler
      await _remoteConfig.setDefaults({
        'min_version': '1.0.0',        // Zorunlu minimum versiyon
        'latest_version': '1.0.0',     // En son versiyon
        'update_message_tr': 'Yeni özellikler ve iyileştirmeler için güncelleme yapın.',
        'update_message_en': 'Update for new features and improvements.',
        'force_update': false,          // Zorunlu güncelleme aktif mi?
        'maintenance_mode': false,      // Bakım modu aktif mi?
        'maintenance_message_tr': 'Uygulama bakımda. Lütfen daha sonra tekrar deneyin.',
        'maintenance_message_en': 'App is under maintenance. Please try again later.',
      });

      // Remote Config'i fetch et
      await _remoteConfig.fetchAndActivate();
      debugPrint('✅ ForceUpdateService başlatıldı');
    } catch (e) {
      debugPrint('⚠️ Remote Config hatası: $e');
    }
  }

  /// Güncelleme kontrolü yap
  /// [context] - Dialog göstermek için BuildContext
  /// [uiLanguage] - Mesaj dili ('TR' veya 'EN')
  /// 
  /// Dönüş: true = devam et, false = güncelleme gerekli (uygulama kilitlendi)
  Future<bool> checkForUpdate(BuildContext context, {String uiLanguage = 'TR'}) async {
    try {
      // Bakım modu kontrolü
      final maintenanceMode = _remoteConfig.getBool('maintenance_mode');
      if (maintenanceMode) {
        await _showMaintenanceDialog(context, uiLanguage);
        return false;
      }

      // Versiyon bilgilerini al
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final minVersion = _remoteConfig.getString('min_version');
      final latestVersion = _remoteConfig.getString('latest_version');
      final forceUpdate = _remoteConfig.getBool('force_update');

      debugPrint('📱 Mevcut: $currentVersion | Min: $minVersion | Son: $latestVersion');

      // Versiyon karşılaştırması
      final currentParsed = _parseVersion(currentVersion);
      final minParsed = _parseVersion(minVersion);
      final latestParsed = _parseVersion(latestVersion);

      // Zorunlu güncelleme kontrolü
      if (_isVersionLower(currentParsed, minParsed) || forceUpdate) {
        await _showForceUpdateDialog(context, uiLanguage);
        return false; // Uygulama kilitli
      }

      // Opsiyonel güncelleme kontrolü
      if (_isVersionLower(currentParsed, latestParsed)) {
        await _showOptionalUpdateDialog(context, uiLanguage);
        // Kullanıcı devam edebilir
      }

      return true;
    } catch (e) {
      debugPrint('⚠️ Güncelleme kontrolü hatası: $e');
      return true; // Hata durumunda devam et
    }
  }

  /// Versiyon string'ini parse et (1.2.3 -> [1, 2, 3])
  List<int> _parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  /// Versiyon karşılaştırması (v1 < v2 mi?)
  bool _isVersionLower(List<int> v1, List<int> v2) {
    for (int i = 0; i < 3; i++) {
      final a = i < v1.length ? v1[i] : 0;
      final b = i < v2.length ? v2[i] : 0;
      if (a < b) return true;
      if (a > b) return false;
    }
    return false;
  }

  /// 🔴 Zorunlu güncelleme dialog'u (kapatılamaz)
  Future<void> _showForceUpdateDialog(BuildContext context, String uiLanguage) async {
    final isTurkish = uiLanguage.toUpperCase() == 'TR';
    final message = _remoteConfig.getString(
      isTurkish ? 'update_message_tr' : 'update_message_en',
    );

    await showDialog(
      context: context,
      barrierDismissible: false, // Kapatılamaz
      builder: (context) => PopScope(
        canPop: false, // Geri tuşu kapalı
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.system_update, color: Colors.red),
              ),
              const SizedBox(width: 12),
              Text(
                isTurkish ? 'Güncelleme Gerekli' : 'Update Required',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isTurkish
                            ? 'Uygulamayı kullanmaya devam etmek için güncelleme yapmanız gerekiyor.'
                            : 'You need to update to continue using the app.',
                        style: const TextStyle(fontSize: 12, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openStore(),
                icon: const Icon(Icons.download),
                label: Text(isTurkish ? 'Şimdi Güncelle' : 'Update Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🟡 Opsiyonel güncelleme dialog'u (kapatılabilir)
  Future<void> _showOptionalUpdateDialog(BuildContext context, String uiLanguage) async {
    final isTurkish = uiLanguage.toUpperCase() == 'TR';
    final message = _remoteConfig.getString(
      isTurkish ? 'update_message_tr' : 'update_message_en',
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.update, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Text(
              isTurkish ? 'Yeni Güncelleme' : 'New Update',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isTurkish ? 'Daha Sonra' : 'Later'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _openStore();
            },
            icon: const Icon(Icons.download, size: 18),
            label: Text(isTurkish ? 'Güncelle' : 'Update'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔧 Bakım modu dialog'u (kapatılamaz)
  Future<void> _showMaintenanceDialog(BuildContext context, String uiLanguage) async {
    final isTurkish = uiLanguage.toUpperCase() == 'TR';
    final message = _remoteConfig.getString(
      isTurkish ? 'maintenance_message_tr' : 'maintenance_message_en',
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.build, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Text(
                isTurkish ? 'Bakım Modu' : 'Maintenance',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Uygulamayı yeniden kontrol et
                  Navigator.pop(context);
                  checkForUpdate(context, uiLanguage: uiLanguage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isTurkish ? 'Tekrar Dene' : 'Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Store'u aç
  Future<void> _openStore() async {
    final url = Platform.isIOS ? _appStoreUrl : _playStoreUrl;
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('❌ Store açılamadı: $e');
    }
  }

  /// Mevcut versiyon bilgisini al
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Remote Config'den son versiyonu al
  String getLatestVersion() {
    return _remoteConfig.getString('latest_version');
  }

  /// Remote Config'den minimum versiyonu al
  String getMinVersion() {
    return _remoteConfig.getString('min_version');
  }
}
