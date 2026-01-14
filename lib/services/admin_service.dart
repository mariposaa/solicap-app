import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Admin yetkilendirme servisi - SOLICAP
class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _adminKey = 'is_admin_verified';
  static bool _isAdmin = false;

  /// Admin durumunu kontrol et (cache)
  static bool get isAdmin => _isAdmin;

  /// Admin durumunu başlat
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAdmin = prefs.getBool(_adminKey) ?? false;
      debugPrint('AdminService: Admin status = $_isAdmin');
    } catch (e) {
      debugPrint('AdminService init error: $e');
      _isAdmin = false;
    }
  }

  /// Admin kodunu doğrula
  /// ⚠️ GÜVENLİK: Admin kodu SADECE Firestore'dan alınır, hardcoded fallback YOK!
  /// ✅ Başarılı girişte UID otomatik olarak adminUIDs listesine eklenir
  static Future<bool> verifyAdminCode(String inputCode) async {
    try {
      // Firestore'dan admin kodunu al
      final doc = await _firestore.collection('configs').doc('settings').get();
      
      // ⚠️ Firestore'da config yoksa erişimi reddet
      if (!doc.exists) {
        debugPrint('AdminService: configs/settings dokümanı bulunamadı!');
        return false;
      }

      final data = doc.data();
      final correctCode = data?['adminCode'] as String?;
      
      // ⚠️ Admin kodu tanımlanmamışsa erişimi reddet
      if (correctCode == null || correctCode.isEmpty) {
        debugPrint('AdminService: adminCode alanı bulunamadı veya boş!');
        return false;
      }

      // Kodu karşılaştır
      if (inputCode.trim() == correctCode) {
        _isAdmin = true;
        
        // SharedPreferences'a kaydet
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_adminKey, true);
        
        // ✅ Mevcut UID'yi adminUIDs listesine ekle (Firestore kuralları için)
        await _registerAdminUID();
        
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('AdminService verify error: $e');
      return false;
    }
  }

  /// Mevcut kullanıcının UID'sini adminUIDs listesine ekle
  static Future<void> _registerAdminUID() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint('AdminService: Kullanıcı giriş yapmamış, UID kaydedilemedi');
        return;
      }

      final uid = currentUser.uid;
      
      // adminUIDs array'ine UID'yi ekle (zaten varsa tekrar eklemez)
      await _firestore.collection('configs').doc('settings').update({
        'adminUIDs': FieldValue.arrayUnion([uid]),
      });
      
      debugPrint('✅ Admin UID kaydedildi: $uid');
    } catch (e) {
      debugPrint('⚠️ Admin UID kaydetme hatası: $e');
      // Hata olsa bile admin girişi başarılı sayılır
    }
  }

  /// Admin oturumunu kapat
  static Future<void> logout() async {
    try {
      _isAdmin = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adminKey, false);
    } catch (e) {
      debugPrint('AdminService logout error: $e');
    }
  }
}
