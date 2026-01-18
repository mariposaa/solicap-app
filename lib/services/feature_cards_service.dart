import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Feature Card modeli
class FeatureCard {
  final String id;
  final String title;
  final String subtitle;
  final String iconName; // Icons enum adı (camera_alt_rounded gibi)
  final int colorValue; // Color.value
  final int order;
  final bool isActive;

  FeatureCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.colorValue,
    required this.order,
    this.isActive = true,
  });

  factory FeatureCard.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeatureCard(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      iconName: data['iconName'] ?? 'info_rounded',
      colorValue: data['colorValue'] ?? 0xFF3B82F6,
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'iconName': iconName,
      'colorValue': colorValue,
      'order': order,
      'isActive': isActive,
    };
  }

  FeatureCard copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? iconName,
    int? colorValue,
    int? order,
    bool? isActive,
  }) {
    return FeatureCard(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Icon adından IconData döndürür
  IconData get icon => iconMap[iconName] ?? Icons.info_rounded;
  
  /// Color value'dan Color döndürür
  Color get color => Color(colorValue);
  
  /// Desteklenen iconlar
  static const Map<String, IconData> iconMap = {
    'camera_alt_rounded': Icons.camera_alt_rounded,
    'psychology_rounded': Icons.psychology_rounded,
    'lightbulb_rounded': Icons.lightbulb_rounded,
    'auto_awesome_rounded': Icons.auto_awesome_rounded,
    'replay_rounded': Icons.replay_rounded,
    'insights_rounded': Icons.insights_rounded,
    'school_rounded': Icons.school_rounded,
    'quiz_rounded': Icons.quiz_rounded,
    'timer_rounded': Icons.timer_rounded,
    'star_rounded': Icons.star_rounded,
    'emoji_objects_rounded': Icons.emoji_objects_rounded,
    'science_rounded': Icons.science_rounded,
    'calculate_rounded': Icons.calculate_rounded,
    'menu_book_rounded': Icons.menu_book_rounded,
    'info_rounded': Icons.info_rounded,
  };
  
  static List<String> get availableIcons => iconMap.keys.toList();
}

/// Feature Cards Servisi
class FeatureCardsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'feature_cards';
  
  // Cache
  static List<FeatureCard>? _cachedCards;
  static DateTime? _lastFetch;
  static const Duration _cacheLifetime = Duration(minutes: 5);
  
  /// Varsayılan kartlar (Firestore boşsa kullanılır)
  static List<FeatureCard> get defaultCards => [
    FeatureCard(
      id: 'default_0',
      title: '💡 İlk Soru İpucu',
      subtitle: 'İlk soru biraz uzun sürebilir. Sorun olursa aynı soruyu tekrar gönder - AI daha iyi sonuç verir! Fotoğrafın net ve okunaklı olmasına dikkat et.',
      iconName: 'emoji_objects_rounded',
      colorValue: 0xFFEAB308, // Yellow
      order: 0,
    ),
    FeatureCard(
      id: 'default_1',
      title: '📸 AI Soru Çözücü',
      subtitle: 'Matematik, Fizik, Kimya, Biyoloji - her türlü sorunun fotoğrafını çek! Yapay zeka anında adım adım, detaylı çözüm sunar. Formüller ve işlem basamakları açıkça gösterilir.',
      iconName: 'camera_alt_rounded',
      colorValue: 0xFF3B82F6,
      order: 1,
    ),
    FeatureCard(
      id: 'default_2',
      title: '🧠 Akıllı Öğrenme DNA\'sı',
      subtitle: 'SOLICAP senin öğrenme stilini analiz eder. Hangi konularda zorlandığını, hangi saatlerde daha verimli çalıştığını öğrenir ve sana özel çalışma planı oluşturur.',
      iconName: 'psychology_rounded',
      colorValue: 0xFF8B5CF6,
      order: 2,
    ),
    FeatureCard(
      id: 'default_3',
      title: '🎯 Sokratik Öğretim Modu',
      subtitle: 'Gerçek öğretmen gibi! Cevabı direkt vermez, seni doğru cevaba yönlendiren sorular sorar. Böylece konuyu gerçekten anlarsın, sadece ezberlemezsin.',
      iconName: 'lightbulb_rounded',
      colorValue: 0xFFF59E0B,
      order: 3,
    ),
    FeatureCard(
      id: 'default_4',
      title: '📝 Benzer Soru Üretici',
      subtitle: 'Çözdüğün soruyu anladıysan pekiştir! AI aynı konudan farklı zorluk seviyelerinde sınırsız pratik sorusu üretir. Çözdükçe ustalaş!',
      iconName: 'auto_awesome_rounded',
      colorValue: 0xFF10B981,
      order: 4,
    ),
    FeatureCard(
      id: 'default_5',
      title: '🔄 Akıllı Tekrar Sistemi',
      subtitle: 'Yanlış yaptığın sorular unutulmaz! Spaced Repetition yöntemiyle optimum zamanlarda tekrar kartları çıkar. Bilimsel yöntemle kalıcı öğrenme sağla.',
      iconName: 'replay_rounded',
      colorValue: 0xFFEF4444,
      order: 5,
    ),
    FeatureCard(
      id: 'default_6',
      title: '📊 Detaylı İlerleme Analizi',
      subtitle: 'Haftalık ve aylık istatistiklerle gelişimini takip et. Hangi konularda güçlüsün, hangilerinde çalışman gerek? AI destekli analiz raporları al.',
      iconName: 'insights_rounded',
      colorValue: 0xFF06B6D4,
      order: 6,
    ),
    FeatureCard(
      id: 'default_7',
      title: '📚 Konu Anlatımı',
      subtitle: 'Bir konuyu baştan öğrenmek mi istiyorsun? Micro derslerle konuları parça parça, sindirerek öğren. Her ders sonunda mini quiz ile pekiştir!',
      iconName: 'school_rounded',
      colorValue: 0xFF6366F1,
      order: 7,
    ),
    FeatureCard(
      id: 'default_8',
      title: '📋 Deneme Sınavı Oluştur',
      subtitle: 'Yanlış yaptığın sorulardan özel deneme sınavı oluştur. Zayıf konularına odaklanmış PDF formatında sınav al, gerçek sınav deneyimi yaşa!',
      iconName: 'quiz_rounded',
      colorValue: 0xFFEC4899,
      order: 8,
    ),
    FeatureCard(
      id: 'default_9',
      title: '📓 Akıllı Not Düzenleyici',
      subtitle: 'Dağınık notlarının fotoğrafını çek, AI düzenli ve okunaklı notlara dönüştürsün. Başlıklar, alt başlıklar ve madde işaretleriyle organize et.',
      iconName: 'menu_book_rounded',
      colorValue: 0xFF14B8A6,
      order: 9,
    ),
    FeatureCard(
      id: 'default_10',
      title: '❌ Neden Yanlış Analizi',
      subtitle: 'Yanlış yaptığın her soru için detaylı "neden yanlış?" analizi al. Hangi kavramı kaçırdın, nerede hata yaptın? Bir daha aynı hatayı yapma!',
      iconName: 'science_rounded',
      colorValue: 0xFFF97316,
      order: 10,
    ),
    FeatureCard(
      id: 'default_11',
      title: '🎓 Günlük Çalışma Planı',
      subtitle: 'Her gün sana özel "bugün ne çalışmalısın?" önerileri al. AI senin performansına göre en verimli çalışma planını hazırlar.',
      iconName: 'timer_rounded',
      colorValue: 0xFF0EA5E9,
      order: 11,
    ),
    FeatureCard(
      id: 'default_12',
      title: '💎 Elmas Sistemi',
      subtitle: 'Sorular elmas ile çözülür. Her gün giriş yap, reklam izle veya arkadaşını davet et - ücretsiz elmas kazan! Premium ile sınırsız erişim.',
      iconName: 'star_rounded',
      colorValue: 0xFFA855F7,
      order: 12,
    ),
    FeatureCard(
      id: 'default_13',
      title: '🔢 Matematik + Görsel AI',
      subtitle: 'Grafik, şekil, geometri soruları? Sorun değil! Görsel matematik AI\'ı grafikleri okur, şekilleri analiz eder ve adım adım çözer.',
      iconName: 'calculate_rounded',
      colorValue: 0xFF22C55E,
      order: 13,
    ),
  ];
  
  /// Aktif feature kartlarını getir
  static Future<List<FeatureCard>> getCards() async {
    // Cache kontrolü
    if (_cachedCards != null && _lastFetch != null) {
      if (DateTime.now().difference(_lastFetch!) < _cacheLifetime) {
        return _cachedCards!;
      }
    }
    
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint('📢 Feature cards: Firestore boş, varsayılanlar kullanılıyor');
        _cachedCards = defaultCards;
      } else {
        _cachedCards = snapshot.docs.map((doc) => FeatureCard.fromFirestore(doc)).toList();
        debugPrint('📢 Feature cards: ${_cachedCards!.length} kart yüklendi');
      }
      
      _lastFetch = DateTime.now();
      return _cachedCards!;
    } catch (e) {
      debugPrint('❌ Feature cards yükleme hatası: $e');
      return defaultCards;
    }
  }
  
  /// Tüm kartları getir (admin için)
  static Future<List<FeatureCard>> getAllCards() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('order')
          .get();
      
      if (snapshot.docs.isEmpty) {
        return defaultCards;
      }
      
      return snapshot.docs.map((doc) => FeatureCard.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Feature cards yükleme hatası: $e');
      return defaultCards;
    }
  }
  
  /// Kart ekle/güncelle
  static Future<void> saveCard(FeatureCard card) async {
    try {
      if (card.id.startsWith('default_')) {
        // Yeni kart olarak ekle
        await _firestore.collection(_collection).add(card.toFirestore());
      } else {
        // Mevcut kartı güncelle
        await _firestore.collection(_collection).doc(card.id).set(card.toFirestore());
      }
      _cachedCards = null; // Cache'i temizle
      debugPrint('✅ Feature card kaydedildi: ${card.title}');
    } catch (e) {
      debugPrint('❌ Feature card kaydetme hatası: $e');
      rethrow;
    }
  }
  
  /// Kart sil
  static Future<void> deleteCard(String cardId) async {
    try {
      if (!cardId.startsWith('default_')) {
        await _firestore.collection(_collection).doc(cardId).delete();
      }
      _cachedCards = null;
      debugPrint('✅ Feature card silindi: $cardId');
    } catch (e) {
      debugPrint('❌ Feature card silme hatası: $e');
      rethrow;
    }
  }
  
  /// Varsayılanları Firestore'a yükle
  static Future<void> initializeDefaults() async {
    try {
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      
      if (snapshot.docs.isEmpty) {
        debugPrint('📢 Varsayılan feature kartları yükleniyor...');
        for (final card in defaultCards) {
          await _firestore.collection(_collection).add(card.toFirestore());
        }
        _cachedCards = null;
        debugPrint('✅ ${defaultCards.length} varsayılan kart yüklendi');
      }
    } catch (e) {
      debugPrint('❌ Varsayılan kart yükleme hatası: $e');
    }
  }
  
  /// Cache'i temizle
  static void clearCache() {
    _cachedCards = null;
    _lastFetch = null;
  }
  
  /// Tüm kartları silip varsayılanları yükle (admin için)
  static Future<void> resetToDefaults() async {
    try {
      debugPrint('🔄 Feature kartları sıfırlanıyor...');
      
      // Mevcut kartları sil
      final snapshot = await _firestore.collection(_collection).get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      debugPrint('🗑️ ${snapshot.docs.length} eski kart silindi');
      
      // Varsayılanları yükle
      for (final card in defaultCards) {
        await _firestore.collection(_collection).add(card.toFirestore());
      }
      
      _cachedCards = null;
      _lastFetch = null;
      debugPrint('✅ ${defaultCards.length} yeni kart yüklendi');
    } catch (e) {
      debugPrint('❌ Kart sıfırlama hatası: $e');
      rethrow;
    }
  }
}
