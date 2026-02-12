/// SOLICAP - Points Service
/// Puan yönetimi servisi (Elmas Sistemi)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'auth_service.dart';
import 'analytics_service.dart';
import 'ad_service.dart';
import 'iap_service.dart';

class PointsService {
  static final PointsService _instance = PointsService._internal();
  factory PointsService() => _instance;
  PointsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Puan maliyetleri (Gemini 3 Pro & Flash Hibrid Yapı)
  static const Map<String, int> costs = {
    'standard_solve': 20,     // 🔴 Flash - Soru Çözümü
    'detailed_explain': 10,   // Flash - Arttırıldı
    'similar_question': 30,   // 💎 Pro - Soru Türetme (1 soru için)
    'personal_analysis': 40,  // 💎 Pro - Derin Sherlock Analizi (Premium)
    'coaching': 5,            // Flash
    'socratic_mode': 5,       // Flash
    'micro_lesson': 20,       // 💎 Pro - Konu Anlatımı
    'organize_note': 20,      // 💎 Pro - Not Düzenleme (15→20)
    'socratic_analysis': 4,   // Flash
    'generate_exam': 30,      // 💎 Pro - Özel Deneme Sınavı Oluşturma (10+ Soru)
    'exam_prep': 50,          // 💎 Pro - Sınava Hazırlık (Kampüs)
    'generate_flashcards': 30, // 💎 AI - Konu Kartı Üretimi (3x)
    'challenge_entry': 30,     // 🏆 Challenge - Yarışma giriş ücreti (elmas)
    'library_entry': 30,       // 📚 Kütüphane - Günlük 1 giriş
    'yoyo_test': 10,            // 🏃 YoYo Test - Hız antrenmanı giriş
    'yds_test': 15,            // 🌍 YDS - Test çözme (15 soru)
    'yds_analysis': 30,        // 🌍 YDS - Test analiz kartları (AI üretimi)
    'lang_basic_lesson': 5,    // 🌐 Dil Öğrenme - Grammar/Vocab dersi
    'lang_ai_lesson': 10,      // 🌐 Dil Öğrenme - AI zenginleştirilmiş ders (Reading/Speaking/Listening)
    'lang_exam': 10,           // 🌐 Dil Öğrenme - Quiz/Ünite sınavı
    'roadmap_analysis': 30,    // 🗺️ Gelişim - Kişisel Yol Haritası
    'checkin_analysis': 15,    // 📋 Gelişim - Haftalık Check-in AI
    'stem_basic_lesson': 5,    // 📐 STEM - Konu anlatımı / Çözümlü örnek
    'stem_ai_lesson': 10,      // 📐 STEM - AI destekli ders (ipucu/hata analizi)
    'stem_exam': 10,           // 📐 STEM - Hız testi / Konu sınavı
    'tyt_review': 3,           // 📝 TYT - Konu hatırlatma (review, daha ucuz)
    'tyt_mini_deneme': 8,      // 📝 TYT - Mini deneme (15 soru)
    'ayt_review': 3,           // 🎯 AYT - Konu hatırlatma (review, daha ucuz)
    'ayt_mini_deneme': 8,      // 🎯 AYT - Mini deneme (15 soru)
  };

  /// Başlangıç puanı (Yönetilebilir seviyeye çekildi)
  static const int initialPoints = 100;

  /// Davet ödülü - Arkadaşın davet koduyla katıldığında
  static const int inviteReward = 10;
  
  /// Davet limitleri (hile önleme)
  static const int dailyInviteLimit = 5;   // Günlük en fazla 5 davet ödülü
  static const int totalInviteLimit = 50;  // Toplamda en fazla 50 davet ödülü

  /// Kullanıcının mevcut puanını getir
  Future<int> getPoints() async {
    final userId = _authService.currentUserId;
    if (userId == null) return 0;

    try {
      final doc = await _firestore.collection('user_points').doc(userId).get();
      
      if (!doc.exists) {
        // Yeni kullanıcıya başlangıç puanı ver
        await _initializePoints(userId);
        return initialPoints;
      }
      
      return doc.data()?['balance'] ?? 0;
    } catch (e) {
      debugPrint('❌ Puan getirme hatası: $e');
      return 0;
    }
  }

  /// 🔄 Anlık puan akışını getir (Real-time sync)
  Stream<int> getPointsStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value(0);

    return _firestore
        .collection('user_points')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            // Document yoksa arkada oluşturulacak, şimdilik 0 dön
            return 0;
          }
          return doc.data()?['balance'] ?? 0;
        });
  }

  /// Yeni kullanıcı için puan başlat
  Future<void> _initializePoints(String userId) async {
    await _firestore.collection('user_points').doc(userId).set({
      'balance': initialPoints,
      'totalEarned': initialPoints,
      'totalSpent': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
    debugPrint('✅ Başlangıç puanı verildi: $initialPoints');
  }

  /// Puan yeterli mi kontrol et
  Future<bool> hasEnoughPoints(String action) async {
    final cost = costs[action] ?? 0;
    final balance = await getPoints();
    return balance >= cost;
  }

  /// Puan harca
  Future<bool> spendPoints(String action, {String? description}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;

    final cost = costs[action] ?? 0;
    if (cost == 0) return true;

    try {
      final docRef = _firestore.collection('user_points').doc(userId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        final currentBalance = doc.data()?['balance'] ?? 0;
        
        if (currentBalance < cost) {
          throw Exception('Yetersiz puan');
        }
        
        transaction.update(docRef, {
          'balance': currentBalance - cost,
          'totalSpent': FieldValue.increment(cost),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });

      // İşlem geçmişine kaydet
      await _logTransaction(userId, -cost, action, description);
      
      // 📊 Analytics: Puan harcandı
      AnalyticsService().logPointSpent(action: action, amount: cost);
      
      debugPrint('✅ $cost puan harcandı ($action)');
      return true;
    } catch (e) {
      debugPrint('❌ Puan harcama hatası: $e');
      return false;
    }
  }

  /// Puan ekle (reklam izleme, başarı, vb.)
  Future<void> addPoints(int amount, String reason) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    await addPointsToUser(userId, amount, reason);
  }

  /// Belirli kullanıcıya puan ekle (davet ödülü vb.)
  Future<void> addPointsToUser(String userId, int amount, String reason) async {
    try {
      final docRef = _firestore.collection('user_points').doc(userId);
      final doc = await docRef.get();

      if (doc.exists) {
        await docRef.update({
          'balance': FieldValue.increment(amount),
          'totalEarned': FieldValue.increment(amount),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.set({
          'balance': amount,
          'totalEarned': amount,
          'totalSpent': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }

      await _logTransaction(userId, amount, 'earn', reason);
      debugPrint('✅ $amount elmas eklendi ($reason) - $userId');
    } catch (e) {
      debugPrint('❌ Puan ekleme hatası: $e');
    }
  }

  /// Davet ödülü ver (limit kontrolü ile)
  /// Dönüş: true = ödül verildi, false = limit aşıldı
  Future<bool> giveInviteReward(String inviterUserId) async {
    try {
      final docRef = _firestore.collection('user_points').doc(inviterUserId);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Kullanıcı yoksa oluştur ve ilk ödülü ver
        await docRef.set({
          'balance': inviteReward,
          'totalEarned': inviteReward,
          'totalSpent': 0,
          'inviteTotalCount': 1,
          'inviteTodayCount': 1,
          'inviteLastDate': _getTodayString(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        await _logTransaction(inviterUserId, inviteReward, 'invite_reward', 'Arkadaş daveti ödülü');
        debugPrint('✅ Davet ödülü verildi: $inviterUserId +$inviteReward elmas (ilk)');
        return true;
      }

      final data = doc.data()!;
      final totalCount = data['inviteTotalCount'] ?? 0;
      final todayCount = data['inviteTodayCount'] ?? 0;
      final lastDate = data['inviteLastDate'] ?? '';
      final today = _getTodayString();

      // Toplam limit kontrolü
      if (totalCount >= totalInviteLimit) {
        debugPrint('⚠️ Toplam davet limiti aşıldı: $inviterUserId ($totalCount/$totalInviteLimit)');
        return false;
      }

      // Günlük limit kontrolü
      int newTodayCount;
      if (lastDate == today) {
        if (todayCount >= dailyInviteLimit) {
          debugPrint('⚠️ Günlük davet limiti aşıldı: $inviterUserId ($todayCount/$dailyInviteLimit)');
          return false;
        }
        newTodayCount = todayCount + 1;
      } else {
        // Yeni gün, sayacı sıfırla
        newTodayCount = 1;
      }

      // Ödülü ver
      await docRef.update({
        'balance': FieldValue.increment(inviteReward),
        'totalEarned': FieldValue.increment(inviteReward),
        'inviteTotalCount': FieldValue.increment(1),
        'inviteTodayCount': newTodayCount,
        'inviteLastDate': today,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      await _logTransaction(inviterUserId, inviteReward, 'invite_reward', 'Arkadaş daveti ödülü');
      debugPrint('✅ Davet ödülü verildi: $inviterUserId +$inviteReward elmas (günlük: $newTodayCount/$dailyInviteLimit, toplam: ${totalCount + 1}/$totalInviteLimit)');
      return true;
    } catch (e) {
      debugPrint('❌ Davet ödülü hatası: $e');
      return false;
    }
  }

  /// Bugünün tarihini YYYY-MM-DD formatında döndür
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// İşlem geçmişine kaydet
  Future<void> _logTransaction(
    String userId, 
    int amount, 
    String type, 
    String? description,
  ) async {
    await _firestore
        .collection('user_points')
        .doc(userId)
        .collection('transactions')
        .add({
      'amount': amount,
      'type': type,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Son işlemleri getir
  Future<List<Map<String, dynamic>>> getTransactionHistory({int limit = 20}) async {
    final userId = _authService.currentUserId;
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('user_points')
          .doc(userId)
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('❌ İşlem geçmişi hatası: $e');
      return [];
    }
  }

  /// Maliyet açıklaması
  static String getCostDescription(String action) {
    final cost = costs[action] ?? 0;
    switch (action) {
      case 'standard_solve':
        return 'Soru Çözümü ($cost puan)';
      case 'detailed_explain':
        return 'Detaylı Anlatım ($cost puan)';
      case 'similar_question':
        return 'Benzer Soru ($cost puan)';
      case 'personal_analysis':
        return 'Kişisel Analiz ($cost puan)';
      case 'coaching':
        return 'Koçluk Tavsiyesi ($cost puan)';
      case 'socratic_mode':
        return 'İpucu Modu ($cost puan)';
      case 'micro_lesson':
        return 'Konu Anlatımı ($cost puan)';
      case 'roadmap_analysis':
        return 'Yol Haritası ($cost puan)';
      case 'checkin_analysis':
        return 'Haftalık Check-in ($cost puan)';
      case 'organize_note':
        return 'Not Düzenleme ($cost puan)';
      case 'generate_exam':
        return 'Deneme Sınavı Oluşturma ($cost puan)';
      case 'exam_prep':
        return 'Sınava Hazırlık ($cost puan)';
      case 'generate_flashcards':
        return 'Akıllı Kart Üretimi ($cost puan)';
      case 'challenge_entry':
        return 'Challenge Giriş ($cost puan)';
      case 'yoyo_test':
        return 'YoYo Test Giriş ($cost puan)';
      case 'yds_test':
        return 'YDS Test ($cost puan)';
      case 'yds_analysis':
        return 'YDS Test Analiz ($cost puan)';
      case 'lang_basic_lesson':
        return 'Dil Dersi ($cost puan)';
      case 'lang_ai_lesson':
        return 'AI Dil Dersi ($cost puan)';
      case 'lang_exam':
        return 'Dil Sınavı ($cost puan)';
      case 'stem_basic_lesson':
        return 'STEM Ders ($cost puan)';
      case 'stem_ai_lesson':
        return 'AI STEM Ders ($cost puan)';
      case 'stem_exam':
        return 'STEM Sınav ($cost puan)';
      case 'tyt_review':
        return 'TYT Konu Hatırlatma ($cost puan)';
      case 'tyt_mini_deneme':
        return 'TYT Mini Deneme ($cost puan)';
      case 'ayt_review':
        return 'AYT Konu Hatırlatma ($cost puan)';
      case 'ayt_mini_deneme':
        return 'AYT Mini Deneme ($cost puan)';
      default:
        return '$action ($cost puan)';
    }
  }

  /// Reklam izleme ödülü
  static const int adRewardAmount = 40;

  /// 💎 Yetersiz puan dialogu göster - Reklam İzle + 100/250 elmas Satın Al (API fiyatı)
  static Future<bool> showInsufficientPointsDialog(
    BuildContext context, {
    String? actionName,
    VoidCallback? onPointsAdded,
  }) async {
    final pointsService = PointsService();
    final currentPoints = await pointsService.getPoints();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _InsufficientPointsDialogContent(
        currentPoints: currentPoints,
        actionName: actionName,
        adRewardAmount: adRewardAmount,
      ),
    );

    if (result == true) {
      await _showRewardedAd(context, pointsService, onPointsAdded);
      return true;
    }
    return false;
  }

  /// Gerçek AdMob ödüllü reklamını göster
  static Future<void> _showRewardedAd(
    BuildContext context,
    PointsService pointsService,
    VoidCallback? onPointsAdded,
  ) async {
    final adService = AdService();
    
    // Reklam yüklenmemişse loading göster
    if (!adService.isAdReady) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.amber),
                  SizedBox(height: 16),
                  Text('Reklam yükleniyor...', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Reklam yüklenene kadar bekle
      await adService.loadRewardedAd();
      await Future.delayed(const Duration(seconds: 2));
      
      // Loading'i kapat
      if (context.mounted) Navigator.pop(context);
    }

    // Reklamı göster
    await adService.showRewardedAd(
      onUserEarnedReward: (rewardAmount) async {
        // Puanları ekle (sabit 40 elmas)
        await pointsService.addPoints(adRewardAmount, 'Reklam izleme ödülü');
        
        // 📊 Analytics: Reklam izlendi
        AnalyticsService().logAdWatched(rewardAmount: adRewardAmount);
        
        // Başarı mesajı
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.diamond, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text('+$adRewardAmount elmas kazandın! 🎉'),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          
          // Callback çağır (UI güncellemesi için)
          onPointsAdded?.call();
        }
      },
      onAdFailedToShow: () {
        // Reklam gösterilemedi - hata mesajı
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Reklam yüklenemedi, lütfen tekrar deneyin.'),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
    );
  }

  /// Puan kontrolü ile işlem yap - Yetersizse dialog göster
  Future<bool> checkAndSpendPoints(
    BuildContext context,
    String action, {
    String? description,
    VoidCallback? onPointsAdded,
  }) async {
    final hasEnough = await hasEnoughPoints(action);
    
    if (!hasEnough) {
      final actionName = getCostDescription(action);
      final watched = await showInsufficientPointsDialog(
        context,
        actionName: actionName,
        onPointsAdded: onPointsAdded,
      );
      
      if (!watched) return false;
      
      // Reklam izledikten sonra tekrar kontrol et
      final hasEnoughNow = await hasEnoughPoints(action);
      if (!hasEnoughNow) return false;
    }
    
    return await spendPoints(action, description: description);
  }
}

/// Yetersiz puan dialog içeriği: Reklam İzle + 100/250 elmas Satın Al (API fiyatı)
class _InsufficientPointsDialogContent extends StatefulWidget {
  final int currentPoints;
  final String? actionName;
  final int adRewardAmount;

  const _InsufficientPointsDialogContent({
    required this.currentPoints,
    this.actionName,
    required this.adRewardAmount,
  });

  @override
  State<_InsufficientPointsDialogContent> createState() => _InsufficientPointsDialogContentState();
}

class _InsufficientPointsDialogContentState extends State<_InsufficientPointsDialogContent> {
  ProductDetails? _product100;
  ProductDetails? _product250;
  bool _loadingIap = true;
  String? _purchasingId;

  @override
  void initState() {
    super.initState();
    _loadIapProducts();
  }

  Future<void> _loadIapProducts() async {
    final iap = IAPService();
    if (!iap.isAvailable) {
      if (mounted) setState(() => _loadingIap = false);
      return;
    }
    final list = await iap.getProducts();
    if (mounted) {
      setState(() {
        _product100 = iap.productById(list, 'elmas_100_paket');
        _product250 = iap.productById(list, 'elmas_250_paket');
        _loadingIap = false;
      });
    }
  }

  Future<void> _buy(ProductDetails product) async {
    if (_purchasingId != null) return;
    setState(() => _purchasingId = product.id);
    final ok = await IAPService().buy(product);
    if (mounted) {
      setState(() => _purchasingId = null);
      if (ok) Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.diamond, color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Elmas Yetersiz! 💎',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.diamond, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Mevcut: ${widget.currentPoints} elmas',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (widget.actionName != null)
              Text(
                '"${widget.actionName}" için yeterli elmasın yok.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else
              Text(
                'Bu işlem için yeterli elmasın yok.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            const SizedBox(height: 12),
            Text(
              '📺 Kısa bir reklam izleyerek ${widget.adRewardAmount} elmas kazanabilirsin!',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (!_loadingIap && (_product100 != null || _product250 != null)) ...[
              const SizedBox(height: 16),
              Text(
                'Ya da elmas satın al (KDV dahil, mağaza fiyatı):',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              if (_product100 != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.diamond, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('100 Elmas – ${_product100!.price}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      FilledButton(
                        onPressed: _purchasingId != null ? null : () => _buy(_product100!),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: _purchasingId == _product100!.id
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Satın Al'),
                      ),
                    ],
                  ),
                ),
              if (_product250 != null)
                Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('250 Elmas – ${_product250!.price}', style: const TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    FilledButton(
                      onPressed: _purchasingId != null ? null : () => _buy(_product250!),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: _purchasingId == _product250!.id
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Satın Al'),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Vazgeç', style: TextStyle(color: Colors.grey.shade600)),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.play_circle_filled, size: 20),
          label: Text('Reklam İzle (+${widget.adRewardAmount} 💎)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
