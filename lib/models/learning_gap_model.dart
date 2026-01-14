/// SOLICAP - Learning Gap Model
/// Öğrencinin zayıf noktalarını ve önerilerini tutar

class LearningGap {
  final String subject;
  final String topic;
  final int totalAttempts;
  final int correctAttempts;
  final double successRate;
  final String proficiencyLevel; // 'weak', 'medium', 'strong'
  final List<String> recommendations;

  LearningGap({
    required this.subject,
    required this.topic,
    required this.totalAttempts,
    required this.correctAttempts,
    required this.successRate,
    required this.proficiencyLevel,
    this.recommendations = const [],
  });

  factory LearningGap.fromJson(Map<String, dynamic> json) {
    return LearningGap(
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      totalAttempts: json['totalAttempts'] ?? 0,
      correctAttempts: json['correctAttempts'] ?? 0,
      successRate: (json['successRate'] ?? 0).toDouble(),
      proficiencyLevel: json['proficiencyLevel'] ?? 'medium',
      recommendations: List<String>.from(json['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'topic': topic,
      'totalAttempts': totalAttempts,
      'correctAttempts': correctAttempts,
      'successRate': successRate,
      'proficiencyLevel': proficiencyLevel,
      'recommendations': recommendations,
    };
  }

  /// Başarı oranına göre renk kodu
  String get colorHex {
    if (successRate >= 0.7) return '#4CAF50'; // Yeşil
    if (successRate >= 0.4) return '#FFC107'; // Sarı
    return '#F44336'; // Kırmızı
  }

  /// Kullanıcı dostu yeterlilik açıklaması
  String get proficiencyText {
    switch (proficiencyLevel) {
      case 'strong':
        return 'Güçlü';
      case 'medium':
        return 'Orta';
      case 'weak':
        return 'Geliştirilmeli';
      default:
        return 'Belirsiz';
    }
  }
}

/// Öğrenci genel analiz özeti
class StudentAnalytics {
  final int totalQuestionsSolved;
  final int totalCorrectAnswers;
  final double overallSuccessRate;
  final List<LearningGap> weakAreas;
  final List<LearningGap> strongAreas;
  final Map<String, int> subjectDistribution;

  StudentAnalytics({
    required this.totalQuestionsSolved,
    required this.totalCorrectAnswers,
    required this.overallSuccessRate,
    this.weakAreas = const [],
    this.strongAreas = const [],
    this.subjectDistribution = const {},
  });

  factory StudentAnalytics.empty() {
    return StudentAnalytics(
      totalQuestionsSolved: 0,
      totalCorrectAnswers: 0,
      overallSuccessRate: 0.0,
    );
  }
}
