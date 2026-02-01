/// Ana sayfa promosyon kartı
/// Aktif anket varsa: Anket Doldur +50 puan
/// Anket yoksa: Yarışmalar tanıtımı (haftalık + tüm sezon ödülleri)

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/survey_model.dart';
import '../services/akademi_service.dart';

class HomePromoCard extends StatelessWidget {
  /// [onNavigateToTab] - (tabIndex, [akademiTab]). tabIndex: 2=Yarışmalar, 3=Akademi. akademiTab: 0=Oluştur, 1=Doldur, 2=Anketlerim
  final void Function(int tabIndex, [int? akademiTab]) onNavigateToTab;

  const HomePromoCard({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Survey>>(
      stream: AkademiService().getActiveSurveysStream(),
      builder: (context, snapshot) {
        final surveys = snapshot.data ?? [];
        final activeSurveys = surveys.where((s) => s.isActive).toList();
        final hasSurvey = activeSurveys.isNotEmpty;

        return GestureDetector(
          onTap: () => hasSurvey
              ? onNavigateToTab(3, 1) // Akademi, Doldur sekmesi
              : onNavigateToTab(2),   // Yarışmalar
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasSurvey
                    ? [
                        Colors.teal.shade400.withOpacity(0.15),
                        Colors.blue.shade400.withOpacity(0.15),
                      ]
                    : [
                        Colors.amber.shade400.withOpacity(0.15),
                        Colors.orange.shade400.withOpacity(0.15),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasSurvey
                    ? Colors.teal.shade300.withOpacity(0.5)
                    : Colors.amber.shade300.withOpacity(0.5),
              ),
            ),
            child: hasSurvey ? _buildSurveyCard(activeSurveys.first) : _buildYarismaCard(),
          ),
        );
      },
    );
  }

  Widget _buildSurveyCard(Survey survey) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.assignment, color: Colors.teal.shade700, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Anket Doldur • 50 Puan Kazan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                survey.title,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.teal.shade700),
      ],
    );
  }

  Widget _buildYarismaCard() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.emoji_events, color: Colors.amber.shade800, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yarışmalar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Haftalık ve tüm sezonu kapsayan ödüller. Detaylı bilgi yarışmalar sekmesinde.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.amber.shade800),
      ],
    );
  }
}
