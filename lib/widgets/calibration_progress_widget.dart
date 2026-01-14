/// SOLICAP - Calibration Progress Widget
/// İlk 10 soru için kalibrasyon ilerleme göstergesi

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CalibrationProgressWidget extends StatelessWidget {
  final int currentCount;
  final int targetCount;
  final String uiLanguage;

  const CalibrationProgressWidget({
    super.key,
    required this.currentCount,
    this.targetCount = 10,
    this.uiLanguage = 'TR',
  });

  /// Kalibrasyon tamamlandı mı?
  bool get isCalibrated => currentCount >= targetCount;

  /// Kalan soru sayısı
  int get remaining => targetCount - currentCount;

  /// İlerleme oranı (0.0 - 1.0)
  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    // Kalibrasyon tamamlandıysa gösterme
    if (isCalibrated) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Başlık
          Row(
            children: [
              Icon(
                Icons.psychology_rounded,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getTitle(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // İlerleme çubuğu
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(),
              ),
              minHeight: 8,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // İlerleme metni
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentCount/$targetCount',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _getMessage(),
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// İlerleme rengini belirle
  Color _getProgressColor() {
    if (progress < 0.3) return Colors.orange;
    if (progress < 0.7) return AppTheme.primaryColor;
    return Colors.green;
  }

  /// Başlık metnini dile göre al
  String _getTitle() {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return '🧠 Getting to know you...';
      case 'DE':
        return '🧠 Ich lerne dich kennen...';
      case 'FR':
        return '🧠 J\'apprends à te connaître...';
      case 'ES':
        return '🧠 Conociéndote...';
      default:
        return '🧠 Seni tanıyorum...';
    }
  }

  /// Mesajı dile göre al
  String _getMessage() {
    if (remaining <= 0) {
      return _getCompleteMessage();
    }

    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        if (remaining <= 2) return 'Almost there! 🔥';
        if (remaining <= 5) return '$remaining more for analysis 🎯';
        return '$remaining questions to first analysis';
      case 'DE':
        if (remaining <= 2) return 'Fast geschafft! 🔥';
        if (remaining <= 5) return 'Noch $remaining für die Analyse 🎯';
        return '$remaining Fragen bis zur ersten Analyse';
      case 'FR':
        if (remaining <= 2) return 'Presque terminé! 🔥';
        if (remaining <= 5) return 'Encore $remaining pour l\'analyse 🎯';
        return '$remaining questions avant la première analyse';
      case 'ES':
        if (remaining <= 2) return '¡Casi listo! 🔥';
        if (remaining <= 5) return 'Faltan $remaining para el análisis 🎯';
        return '$remaining preguntas para el primer análisis';
      default:
        if (remaining <= 2) return 'Neredeyse hazır! 🔥';
        if (remaining <= 5) return '$remaining soru daha ve analiz hazır 🎯';
        return 'İlk analizine $remaining soru kaldı';
    }
  }

  String _getCompleteMessage() {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return '🎉 First analysis ready!';
      case 'DE':
        return '🎉 Erste Analyse bereit!';
      case 'FR':
        return '🎉 Première analyse prête!';
      case 'ES':
        return '🎉 ¡Primer análisis listo!';
      default:
        return '🎉 İlk analiz hazır!';
    }
  }
}

/// Kalibrasyon tamamlandığında gösterilecek banner
class CalibrationCompleteBanner extends StatelessWidget {
  final VoidCallback onViewAnalysis;
  final VoidCallback onDismiss;
  final String uiLanguage;

  const CalibrationCompleteBanner({
    super.key,
    required this.onViewAnalysis,
    required this.onDismiss,
    this.uiLanguage = 'TR',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade400,
            Colors.teal.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.celebration_rounded,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getSubtitle(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_getButtonText()),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return 'Calibration Complete! 🎉';
      case 'DE':
        return 'Kalibrierung abgeschlossen! 🎉';
      default:
        return 'Kalibrasyon Tamamlandı! 🎉';
    }
  }

  String _getSubtitle() {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return 'Your first personalized analysis is ready';
      case 'DE':
        return 'Deine erste personalisierte Analyse ist bereit';
      default:
        return 'İlk kişisel analizin hazır';
    }
  }

  String _getButtonText() {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return 'View My Analysis';
      case 'DE':
        return 'Meine Analyse anzeigen';
      default:
        return 'Analizimi Gör';
    }
  }
}
