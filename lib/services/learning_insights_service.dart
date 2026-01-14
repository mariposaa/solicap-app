/// SOLICAP - Learning Insights Service
/// Öğrenme verilerinden içgörüler çıkaran akıllı analiz servisi
/// Sprint 2 - Basic Intelligence

import 'package:flutter/foundation.dart';
import '../models/learning_event_model.dart';
import '../models/question_session_model.dart';
import 'session_tracking_service.dart';
import 'user_dna_service.dart';

/// Trend yönü
enum TrendDirection {
  rising,   // 📈 Yükseliyor
  falling,  // 📉 Düşüyor
  stable,   // ➡️ Stabil
  unknown,  // ❓ Yeterli veri yok
}

/// Öğrenme içgörüleri modeli
class LearningInsights {
  final TrendDirection weeklyTrend;
  final double weeklyChange;           // % değişim
  final List<int> peakHours;           // En verimli saatler [20, 21, 14]
  final String? dominantErrorType;     // En sık yapılan hata türü
  final int currentStreak;             // Günlük streak
  final double averageSessionDuration; // Ortalama oturum süresi (dk)
  final double thisWeekSuccessRate;
  final double lastWeekSuccessRate;
  final int thisWeekQuestions;
  final int lastWeekQuestions;
  final CognitiveLoadLevel? recentCognitiveLoad;
  final List<String> actionableInsights; // Aksiyon alınabilir öneriler

  LearningInsights({
    this.weeklyTrend = TrendDirection.unknown,
    this.weeklyChange = 0,
    this.peakHours = const [],
    this.dominantErrorType,
    this.currentStreak = 0,
    this.averageSessionDuration = 0,
    this.thisWeekSuccessRate = 0,
    this.lastWeekSuccessRate = 0,
    this.thisWeekQuestions = 0,
    this.lastWeekQuestions = 0,
    this.recentCognitiveLoad,
    this.actionableInsights = const [],
  });

  /// Trend emoji'si
  String get trendEmoji {
    switch (weeklyTrend) {
      case TrendDirection.rising: return '📈';
      case TrendDirection.falling: return '📉';
      case TrendDirection.stable: return '➡️';
      case TrendDirection.unknown: return '❓';
    }
  }

  /// Trend label'ı
  String get trendLabel {
    switch (weeklyTrend) {
      case TrendDirection.rising: return 'Yükseliyor';
      case TrendDirection.falling: return 'Düşüyor';
      case TrendDirection.stable: return 'Stabil';
      case TrendDirection.unknown: return 'Veri Bekleniyor';
    }
  }

  /// Peak hours formatı
  String get peakHoursFormatted {
    if (peakHours.isEmpty) return 'Henüz belirlenmedi';
    return peakHours.map((h) => '$h:00').join(', ');
  }
}

/// Öğrenme içgörüleri servisi
class LearningInsightsService {
  static final LearningInsightsService _instance = LearningInsightsService._internal();
  factory LearningInsightsService() => _instance;
  LearningInsightsService._internal();

  SessionTrackingService get _sessionTracker => SessionTrackingService();
  UserDNAService get _dnaService => UserDNAService();

  /// Tüm içgörüleri hesapla
  Future<LearningInsights> calculateInsights() async {
    try {
      // Son 14 günün snapshot'larını al
      final snapshots = await _sessionTracker.getRecentSnapshots(days: 14);
      
      if (snapshots.isEmpty) {
        return LearningInsights(
          weeklyTrend: TrendDirection.unknown,
          actionableInsights: ['Henüz yeterli veri yok. Birkaç soru çözerek başla! 🚀'],
        );
      }

      // Bu hafta ve geçen hafta ayır
      final now = DateTime.now();
      final thisWeekStart = now.subtract(Duration(days: 7));
      
      final thisWeek = snapshots.where((s) => s.date.isAfter(thisWeekStart)).toList();
      final lastWeek = snapshots.where((s) => s.date.isBefore(thisWeekStart)).toList();

      // Başarı oranlarını hesapla
      final thisWeekSuccess = _calculateAverageSuccess(thisWeek);
      final lastWeekSuccess = _calculateAverageSuccess(lastWeek);
      
      final thisWeekTotal = thisWeek.fold(0, (sum, s) => sum + s.questionsAttempted);
      final lastWeekTotal = lastWeek.fold(0, (sum, s) => sum + s.questionsAttempted);

      // Trend hesapla
      final trend = _calculateTrend(thisWeekSuccess, lastWeekSuccess, thisWeek.length);
      final change = lastWeekSuccess > 0 
          ? ((thisWeekSuccess - lastWeekSuccess) / lastWeekSuccess) * 100 
          : 0.0;

      // Peak hours hesapla
      final peakHours = await _calculatePeakHours();

      // Dominant error type
      final dominantError = await _findDominantErrorType();

      // Streak hesapla
      final streak = _calculateStreak(snapshots);

      // Ortalama oturum süresi
      final avgDuration = _calculateAverageSessionDuration(thisWeek);

      // Son bilişsel yük
      final recentLoad = await _getRecentCognitiveLoad();

      // Aksiyon önerileri
      final insights = _generateActionableInsights(
        trend: trend,
        peakHours: peakHours,
        dominantError: dominantError,
        recentLoad: recentLoad,
        streak: streak,
      );

      return LearningInsights(
        weeklyTrend: trend,
        weeklyChange: change,
        peakHours: peakHours,
        dominantErrorType: dominantError,
        currentStreak: streak,
        averageSessionDuration: avgDuration,
        thisWeekSuccessRate: thisWeekSuccess,
        lastWeekSuccessRate: lastWeekSuccess,
        thisWeekQuestions: thisWeekTotal,
        lastWeekQuestions: lastWeekTotal,
        recentCognitiveLoad: recentLoad,
        actionableInsights: insights,
      );
    } catch (e) {
      debugPrint('❌ Insights hesaplama hatası: $e');
      return LearningInsights();
    }
  }

  /// Ortalama başarı oranı hesapla
  double _calculateAverageSuccess(List<DailyLearningSnapshot> snapshots) {
    if (snapshots.isEmpty) return 0;
    
    int totalAttempted = 0;
    int totalCorrect = 0;
    
    for (final s in snapshots) {
      totalAttempted += s.questionsAttempted;
      totalCorrect += s.questionsCorrect;
    }
    
    return totalAttempted > 0 ? totalCorrect / totalAttempted : 0;
  }

  /// Trend yönünü hesapla
  TrendDirection _calculateTrend(double thisWeek, double lastWeek, int dataPoints) {
    // Yeterli veri yoksa unknown
    if (dataPoints < 2) return TrendDirection.unknown;
    
    // Geçen hafta verisi yoksa
    if (lastWeek == 0) {
      return thisWeek > 0.5 ? TrendDirection.rising : TrendDirection.stable;
    }
    
    final diff = thisWeek - lastWeek;
    
    // %5'ten fazla artış = yükseliş
    if (diff > 0.05) return TrendDirection.rising;
    // %5'ten fazla düşüş = düşüş
    if (diff < -0.05) return TrendDirection.falling;
    // Arada = stabil
    return TrendDirection.stable;
  }

  /// En verimli saatleri hesapla
  Future<List<int>> _calculatePeakHours() async {
    try {
      final dna = await _dnaService.getDNA();
      if (dna == null || dna.activeHours.isEmpty) return [];
      
      // En yüksek aktiviteli 3 saati bul
      final sortedHours = dna.activeHours.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      return sortedHours
          .take(3)
          .map((e) => int.tryParse(e.key) ?? 0)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Dominant hata türünü bul
  Future<String?> _findDominantErrorType() async {
    try {
      final dna = await _dnaService.getDNA();
      if (dna == null || dna.errorPatterns.isEmpty) return null;
      
      // En sık yapılan hatayı bul
      String? dominant;
      int maxCount = 0;
      
      dna.errorPatterns.forEach((type, count) {
        if (count > maxCount) {
          maxCount = count;
          dominant = type;
        }
      });
      
      return dominant;
    } catch (e) {
      return null;
    }
  }

  /// Streak hesapla
  int _calculateStreak(List<DailyLearningSnapshot> snapshots) {
    if (snapshots.isEmpty) return 0;
    
    // Tarihe göre sırala (en yeniden eskiye)
    final sorted = List<DailyLearningSnapshot>.from(snapshots)
      ..sort((a, b) => b.date.compareTo(a.date));
    
    int streak = 0;
    DateTime? lastDate;
    
    for (final snap in sorted) {
      if (snap.questionsAttempted == 0) continue;
      
      if (lastDate == null) {
        // İlk gün
        final today = DateTime.now();
        final diffFromToday = today.difference(snap.date).inDays;
        if (diffFromToday > 1) break; // Bugün veya dün değilse streak yok
        streak = 1;
        lastDate = snap.date;
      } else {
        // Ardışık gün mü?
        final diff = lastDate.difference(snap.date).inDays;
        if (diff == 1) {
          streak++;
          lastDate = snap.date;
        } else {
          break;
        }
      }
    }
    
    return streak;
  }

  /// Ortalama oturum süresi (dakika)
  double _calculateAverageSessionDuration(List<DailyLearningSnapshot> snapshots) {
    if (snapshots.isEmpty) return 0;
    
    int totalMinutes = 0;
    int totalSessions = 0;
    
    for (final s in snapshots) {
      totalMinutes += s.totalStudyMinutes;
      totalSessions += s.questionsAttempted; // Her soru bir mini-session
    }
    
    return totalSessions > 0 ? totalMinutes / totalSessions : 0;
  }

  /// Son bilişsel yük durumu
  Future<CognitiveLoadLevel?> _getRecentCognitiveLoad() async {
    try {
      final sessions = await _sessionTracker.getRecentSessions(limit: 5);
      if (sessions.isEmpty) return null;
      
      // Son 5 oturumun ortalama yükünü hesapla
      int loadScore = 0;
      int count = 0;
      
      for (final s in sessions) {
        if (s.cognitiveLoadLevel != null) {
          switch (s.cognitiveLoadLevel!) {
            case CognitiveLoadLevel.low: loadScore += 1; break;
            case CognitiveLoadLevel.medium: loadScore += 2; break;
            case CognitiveLoadLevel.high: loadScore += 3; break;
            case CognitiveLoadLevel.overload: loadScore += 4; break;
          }
          count++;
        }
      }
      
      if (count == 0) return null;
      
      final avg = loadScore / count;
      if (avg <= 1.5) return CognitiveLoadLevel.low;
      if (avg <= 2.5) return CognitiveLoadLevel.medium;
      if (avg <= 3.5) return CognitiveLoadLevel.high;
      return CognitiveLoadLevel.overload;
    } catch (e) {
      return null;
    }
  }

  /// Aksiyon önerileri oluştur
  List<String> _generateActionableInsights({
    required TrendDirection trend,
    required List<int> peakHours,
    String? dominantError,
    CognitiveLoadLevel? recentLoad,
    required int streak,
  }) {
    final insights = <String>[];

    // Trend bazlı
    if (trend == TrendDirection.rising) {
      insights.add('🎉 Harika gidiyorsun! Bu haftaki performansın geçen haftadan daha iyi.');
    } else if (trend == TrendDirection.falling) {
      insights.add('💪 Performansın biraz düştü. Pes etme, birkaç kolay soruyla başla!');
    }

    // Peak hours
    if (peakHours.isNotEmpty) {
      final bestHour = peakHours.first;
      insights.add('⏰ En verimli çalışma saatin: $bestHour:00 civarı.');
    }

    // Dominant error
    if (dominantError != null) {
      final errorLabel = _getErrorLabel(dominantError);
      insights.add('🎯 En sık hata türün: $errorLabel. Bu konuya odaklan!');
    }

    // Cognitive load
    if (recentLoad == CognitiveLoadLevel.overload) {
      insights.add('😓 Son sorularda zorlandın. Biraz mola vermeyi düşün!');
    } else if (recentLoad == CognitiveLoadLevel.high) {
      insights.add('🤔 Zorlu sorularla uğraşıyorsun. Gerekirse ipucu kullan.');
    }

    // Streak
    if (streak >= 7) {
      insights.add('🔥 $streak gün üstü üste çalıştın! Harika streak!');
    } else if (streak >= 3) {
      insights.add('✨ $streak günlük seriye ulaştın. Devam et!');
    } else if (streak == 0) {
      insights.add('🚀 Bugün çalışma yapmadın. Bir soruyla başla!');
    }

    return insights;
  }

  String _getErrorLabel(String errorType) {
    switch (errorType) {
      case 'konu_eksigi': return 'Konu Eksikliği';
      case 'dikkatsizlik': return 'Dikkatsizlik';
      case 'zaman_yetersiz': return 'Zaman Yönetimi';
      case 'anlama_sorunu': return 'Anlama Sorunu';
      case 'hesaplama_hatasi': return 'Hesaplama Hatası';
      case 'kavram_eksik': return 'Kavram Eksikliği';
      default: return errorType;
    }
  }
}
