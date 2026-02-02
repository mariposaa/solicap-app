/// SOLICAP - IAP Service
/// Android (Google Play) ve iOS (App Store) elmas paketleri: bağlantı, ürün çekme, satın al.
/// Android'de consume, iOS'da sadece completePurchase ile teslim.
///
/// IAP / "Elmas Satın Al" UI'ın çıktığı yerler:
/// - Ana sayfa: elmas bakiyesi (💎) tıklanınca → Elmas mağazası bottom sheet
/// - Yetersiz elmas dialogu (PointsService.showInsufficientPointsDialog): Reklam İzle + "Ya da elmas satın al" (100/250 paket)
///   → Kütüphane girişi, mikro ders, challenge başlat, yarışmalar, çözüm ekranı, kampüs kilidi, kurs detay vb.

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'auth_service.dart';
import 'points_service.dart';
import 'analytics_service.dart';

/// Tek seferlik (consumable) ürün ID'leri – hem Google Play hem App Store Connect'te aynı tanımlanmalı.
/// Android: Google Play Console → In-app products → bu ID'ler.
/// iOS: App Store Connect → Uygulama → In-App Purchases → Consumable → bu ID'ler.
const Set<String> kDiamondProductIds = {
  'elmas_100_paket',
  'elmas_250_paket',
  'elmas_500_paket',
  'elmas_1000_paket',
};

/// Product ID -> elmas miktarı (Android ve iOS ortak)
const Map<String, int> kProductIdToDiamonds = {
  'elmas_100_paket': 100,
  'elmas_250_paket': 250,
  'elmas_500_paket': 500,
  'elmas_1000_paket': 1000,
};

/// Sıralı ürün ID listesi (UI’da hep aynı sırada gösterilir)
const List<String> kDiamondProductIdsOrdered = [
  'elmas_100_paket',
  'elmas_250_paket',
  'elmas_500_paket',
  'elmas_1000_paket',
];

/// Mağaza yanıt vermediğinde gösterilecek placeholder fiyatlar (Android benzeri, ekran görüntüsü için)
const Map<String, String> kProductIdToFallbackPrice = {
  'elmas_100_paket': '₺19,99',
  'elmas_250_paket': '₺39,99',
  'elmas_500_paket': '₺74,99',
  'elmas_1000_paket': '₺139,99',
};

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final AuthService _authService = AuthService();
  final PointsService _pointsService = PointsService();

  bool _isAvailable = false;
  bool _initialized = false;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Mağaza kullanılabilir mi (Google Play / App Store)
  bool get isAvailable => _isAvailable;

  /// Bağlantı başlat: uygulama açıldığında veya ilk kullanımda çağrılır
  Future<bool> init() async {
    if (_initialized) return _isAvailable;

    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      debugPrint('⚠️ IAP: Mağaza kullanılamıyor');
      _initialized = true;
      return false;
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (e) => debugPrint('❌ IAP purchaseStream error: $e'),
    );
    _initialized = true;
    debugPrint('✅ IAP: Bağlantı hazır');
    return true;
  }

  /// Satın alma güncellemelerini işle: teslim et + consume
  void _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        // Bekleyen ödeme - UI'da gösterebilirsin
        continue;
      }
      if (purchase.status == PurchaseStatus.error) {
        debugPrint('❌ IAP hata: ${purchase.error?.message}');
        continue;
      }
      if (purchase.status == PurchaseStatus.canceled) continue;

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final productId = purchase.productID;
        final amount = kProductIdToDiamonds[productId];
        if (amount == null) {
          debugPrint('⚠️ IAP: Bilinmeyen ürün $productId');
          _inAppPurchase.completePurchase(purchase);
          continue;
        }

        final userId = _authService.currentUserId;
        if (userId == null) {
          debugPrint('⚠️ IAP: Kullanıcı yok, elmas eklenemedi');
          _inAppPurchase.completePurchase(purchase);
          continue;
        }

        // 1) Elması teslim et
        await _pointsService.addPointsToUser(
          userId,
          amount,
          'Uygulama içi satın alma ($productId)',
        );
        AnalyticsService().logIAPDelivered(productId: productId, amount: amount);

        // 2) Android'de consume et (tekrar satın alınabilir olsun). iOS'ta consumable zaten completePurchase ile biter.
        if (Platform.isAndroid) {
          final androidAddition = _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchase);
        }

        // 3) Teslim edildi olarak işaretle (Android + iOS ortak)
        await _inAppPurchase.completePurchase(purchase);
        debugPrint('✅ IAP: $amount elmas teslim edildi ve tüketildi');
      }
    }
  }

  /// Ürünleri çek: fiyat ve isim Google/Apple API'den
  Future<List<ProductDetails>> getProducts() async {
    if (!_initialized) await init();
    if (!_isAvailable) return [];

    final response = await _inAppPurchase.queryProductDetails(kDiamondProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('⚠️ IAP bulunamayan ID’ler: ${response.notFoundIDs}');
    }
    return response.productDetails;
  }

  /// Satın almayı başlat: kullanıcı butona bastığında Google ödeme penceresi açılır
  Future<bool> buy(ProductDetails product, {VoidCallback? onSuccess}) async {
    if (!_isAvailable) {
      debugPrint('⚠️ IAP: Mağaza kullanılamıyor');
      return false;
    }

    final param = PurchaseParam(productDetails: product);
    final success = await _inAppPurchase.buyConsumable(
      purchaseParam: param,
      autoConsume: false,
    );
    if (!success) debugPrint('❌ IAP: buyConsumable false döndü');
    return success;
  }

  /// Belirli ID'ye göre ürün detayı (liste içinden)
  ProductDetails? productById(List<ProductDetails> products, String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
