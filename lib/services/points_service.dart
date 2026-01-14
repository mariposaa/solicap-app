/// SOLICAP - Points Service
/// Puan yönetimi servisi (Elmas Sistemi)

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'analytics_service.dart';

class PointsService {
  static final PointsService _instance = PointsService._internal();
  factory PointsService() => _instance;
  PointsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// Puan maliyetleri
  static const Map<String, int> costs = {
    'standard_solve': 3,      // Standart soru çözümü
    'detailed_explain': 7,    // Detaylı anlatım / Neden yanlış
    'similar_question': 5,    // Benzer soru üretimi
    'personal_analysis': 15,  // Kişisel analiz raporu
    'coaching': 5,            // Koçluk tavsiyesi
    'socratic_mode': 5,       // Sokratik mod
    'micro_lesson': 10,       // Konu anlatımı
    'organize_note': 10,      // Not düzenleme
    'socratic_analysis': 3,   // Sokratik her bir analiz/ipucu adımı
  };

  /// Başlangıç puanı
  static const int initialPoints = 100;

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

    try {
      await _firestore.collection('user_points').doc(userId).update({
        'balance': FieldValue.increment(amount),
        'totalEarned': FieldValue.increment(amount),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      await _logTransaction(userId, amount, 'earn', reason);
      
      debugPrint('✅ $amount puan eklendi ($reason)');
    } catch (e) {
      debugPrint('❌ Puan ekleme hatası: $e');
    }
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
      case 'organize_note':
        return 'Not Düzenleme ($cost puan)';
      default:
        return '$action ($cost puan)';
    }
  }

  /// Reklam izleme ödülü
  static const int adRewardAmount = 30;

  /// 💎 Yetersiz puan dialogu göster - Her yerden çağrılabilir
  /// Kullanıcı "Reklam İzle" derse reklam gösterilir ve 30 elmas kazanır
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
      builder: (context) => AlertDialog(
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
        content: Column(
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
                    'Mevcut: $currentPoints elmas',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (actionName != null)
              Text(
                '"$actionName" için yeterli elmasın yok.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else
              Text(
                'Bu işlem için yeterli elmasın yok.',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            const SizedBox(height: 8),
            const Text(
              '📺 Kısa bir reklam izleyerek 30 elmas kazanabilirsin!',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Vazgeç',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.play_circle_filled, size: 20),
            label: const Text('Reklam İzle (+30 💎)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      // Kullanıcı reklam izlemeyi kabul etti
      // TODO: Gerçek reklam entegrasyonu (AdMob) eklenecek
      // Şimdilik simüle ediyoruz
      await _simulateAdWatch(context, pointsService, onPointsAdded);
      return true;
    }
    
    return false;
  }

  /// Reklam izleme simülasyonu (AdMob entegre edilene kadar)
  static Future<void> _simulateAdWatch(
    BuildContext context,
    PointsService pointsService,
    VoidCallback? onPointsAdded,
  ) async {
    // Loading göster
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

    // Simüle edilmiş reklam süresi (gerçek AdMob'da otomatik olacak)
    await Future.delayed(const Duration(seconds: 2));

    // Puanları ekle
    await pointsService.addPoints(adRewardAmount, 'Reklam izleme ödülü');
    
    // 📊 Analytics: Reklam izlendi
    AnalyticsService().logAdWatched(rewardAmount: adRewardAmount);

    // Loading kapat
    if (context.mounted) Navigator.pop(context);

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
