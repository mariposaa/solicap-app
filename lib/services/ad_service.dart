/// SOLICAP - Ad Service
/// AdMob entegrasyonu - Ödüllü reklam yönetimi

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  /// Reklam yüklenme durumu
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  bool _isInitialized = false;

  // ═══════════════════════════════════════════════════════════════
  // REKLAM ID'LERİ
  // ═══════════════════════════════════════════════════════════════

  /// Android Rewarded Ad ID (Gerçek - Production)
  static const String _androidRewardedAdId = 'ca-app-pub-8177405180533300/8227748806';

  /// iOS Rewarded Ad ID (Gerçek - Production)
  static const String _iosRewardedAdId = 'ca-app-pub-8177405180533300/2749644110';

  /// Test modunda mı? (Debug build'lerde test reklamları kullan)
  static bool get _isTestMode => kDebugMode;

  /// Platform için uygun reklam ID'sini getir
  String get _rewardedAdUnitId {
    if (_isTestMode) {
      // Test modunda Google'ın test ID'lerini kullan
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'  // Android Test Rewarded
          : 'ca-app-pub-3940256099942544/1712485313'; // iOS Test Rewarded
    }
    
    // Production modunda gerçek ID'leri kullan
    return Platform.isAndroid ? _androidRewardedAdId : _iosRewardedAdId;
  }

  // ═══════════════════════════════════════════════════════════════
  // BAŞLATMA
  // ═══════════════════════════════════════════════════════════════

  /// AdMob'u başlat (main.dart'ta çağrılmalı)
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('✅ AdMob başlatıldı');
      
      // İlk reklamı önceden yükle
      await loadRewardedAd();
    } catch (e) {
      debugPrint('❌ AdMob başlatma hatası: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // ÖDÜLLÜ REKLAM
  // ═══════════════════════════════════════════════════════════════

  /// Ödüllü reklam yükle
  Future<void> loadRewardedAd() async {
    if (_isAdLoading || _rewardedAd != null) return;
    
    _isAdLoading = true;
    debugPrint('📺 Ödüllü reklam yükleniyor...');

    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Ödüllü reklam yüklendi');
          _rewardedAd = ad;
          _isAdLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Reklam yükleme hatası: ${error.message}');
          _rewardedAd = null;
          _isAdLoading = false;
        },
      ),
    );
  }

  /// Reklam hazır mı?
  bool get isAdReady => _rewardedAd != null;

  /// Ödüllü reklamı göster
  /// Başarılı olursa callback çağrılır
  Future<bool> showRewardedAd({
    required Function(int rewardAmount) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) async {
    if (_rewardedAd == null) {
      debugPrint('⚠️ Reklam henüz yüklenmedi, yükleniyor...');
      await loadRewardedAd();
      
      // Kısa bir bekleme
      await Future.delayed(const Duration(seconds: 2));
      
      if (_rewardedAd == null) {
        debugPrint('❌ Reklam yüklenemedi');
        onAdFailedToShow?.call();
        return false;
      }
    }

    bool rewardEarned = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('📺 Reklam gösterildi');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('📺 Reklam kapatıldı');
        ad.dispose();
        _rewardedAd = null;
        
        // Yeni reklam yükle (sonraki kullanım için)
        loadRewardedAd();
        
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ Reklam gösterme hatası: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdFailedToShow?.call();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('🎁 Ödül kazanıldı: ${reward.amount} ${reward.type}');
        rewardEarned = true;
        onUserEarnedReward(reward.amount.toInt());
      },
    );

    return rewardEarned;
  }

  /// Kaynakları temizle
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
