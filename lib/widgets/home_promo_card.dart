/// Ana sayfa promosyon kartı
/// Yarışmalar tanıtımı (haftalık + tüm sezon ödülleri)

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomePromoCard extends StatelessWidget {
  /// [onNavigateToTab] - tabIndex: 2=Yarışmalar
  final void Function(int tabIndex) onNavigateToTab;

  const HomePromoCard({super.key, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onNavigateToTab(2), // Yarışmalar
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.shade400.withOpacity(0.15),
              Colors.orange.shade400.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.shade300.withOpacity(0.5),
          ),
        ),
        child: Row(
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
        ),
      ),
    );
  }
}
