/// SOLICAP - Auth Service
/// Anonymous authentication with device recognition

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  /// Cihaz ID'sini al
  Future<String> _getDeviceId() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return webInfo.userAgent ?? 'web_user';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      print('Device ID alınamadı: $e');
    }
    return 'unknown_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Sessiz giriş - Cihazı tanı veya yeni kullanıcı oluştur
  Future<UserModel?> silentSignIn() async {
    try {
      final deviceId = await _getDeviceId();
      print('📱 Cihaz ID: $deviceId');

      // Önce bu cihaz ID'si ile kayıtlı kullanıcı var mı kontrol et
      final existingUser = await _findUserByDeviceId(deviceId);
      
      if (existingUser != null) {
        print('✅ Mevcut kullanıcı bulundu: ${existingUser.id}');
        
        // Firebase Auth'a anonim giriş yap (session için)
        if (_auth.currentUser == null) {
          await _auth.signInAnonymously();
        }
        
        return existingUser;
      }

      // Yeni kullanıcı oluştur
      print('🆕 Yeni kullanıcı oluşturuluyor...');
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Kullanıcı oluşturulamadı');
      }

      // Firestore'a kaydet
      final newUser = UserModel(
        id: user.uid,
        deviceId: deviceId,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toFirestore());
      
      print('✅ Yeni kullanıcı oluşturuldu: ${user.uid}');
      return newUser;
    } catch (e) {
      print('❌ Giriş hatası: $e');
      return null;
    }
  }

  /// Cihaz ID'sine göre kullanıcı bul
  Future<UserModel?> _findUserByDeviceId(String deviceId) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('deviceId', isEqualTo: deviceId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromFirestore(querySnapshot.docs.first);
      }
    } catch (e) {
      print('Kullanıcı arama hatası: $e');
    }
    return null;
  }

  /// Mevcut kullanıcı bilgilerini al
  Future<UserModel?> getCurrentUserData() async {
    final userId = currentUserId;
    if (userId == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Kullanıcı verisi alınamadı: $e');
    }
    return null;
  }

  /// Kullanıcı sınıfını güncelle
  Future<void> updateGrade(String grade) async {
    final userId = currentUserId;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).update({
      'grade': grade,
    });
  }

  /// Çıkış yap
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Hesabı sil (Firebase Auth kullanıcısını kaldır, ardından çıkış)
  Future<bool> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.delete();
      await _auth.signOut();
      return true;
    } catch (e) {
      debugPrint('Hesap silme hatası: $e');
      return false;
    }
  }
}
