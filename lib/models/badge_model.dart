/// SOLICAP - Badge Model
/// Rozet sistemi için veri modeli

class Badge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final BadgeCategory category;
  final int targetValue;        // Hedef değer (örn: 50 soru)
  final BadgeRarity rarity;
  
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.category,
    required this.targetValue,
    this.rarity = BadgeRarity.common,
  });
}

/// Rozet kategorileri
enum BadgeCategory {
  questionCount,    // Soru sayısı
  streak,           // Ardışık gün/soru
  topicMastery,     // Konu ustalığı
  accuracy,         // Başarı oranı
  special,          // Özel etkinlikler
}

/// Rozet nadirlik seviyesi
enum BadgeRarity {
  common,     // Yaygın (Bronz)
  uncommon,   // Nadir (Gümüş)
  rare,       // Çok Nadir (Altın)
  legendary,  // Efsanevi (Elmas)
}

/// Kullanıcının kazandığı rozet
class EarnedBadge {
  final String badgeId;
  final DateTime earnedAt;
  final int valueAtEarning;  // Kazanıldığındaki değer
  
  const EarnedBadge({
    required this.badgeId,
    required this.earnedAt,
    required this.valueAtEarning,
  });
  
  factory EarnedBadge.fromMap(Map<String, dynamic> map) {
    return EarnedBadge(
      badgeId: map['badgeId'] ?? '',
      earnedAt: map['earnedAt'] != null 
          ? (map['earnedAt'] as dynamic).toDate() 
          : DateTime.now(),
      valueAtEarning: map['valueAtEarning'] ?? 0,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'badgeId': badgeId,
      'earnedAt': earnedAt,
      'valueAtEarning': valueAtEarning,
    };
  }
}

/// Rozet ilerleme durumu
class BadgeProgress {
  final Badge badge;
  final int currentValue;
  final bool isEarned;
  final DateTime? earnedAt;
  
  const BadgeProgress({
    required this.badge,
    required this.currentValue,
    this.isEarned = false,
    this.earnedAt,
  });
  
  double get progressRatio => 
      (currentValue / badge.targetValue).clamp(0.0, 1.0);
  
  int get remainingValue => 
      (badge.targetValue - currentValue).clamp(0, badge.targetValue);
}
