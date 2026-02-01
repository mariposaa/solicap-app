/// Admin: Akademi Anket Takibi
/// Kırmızı ibare: 50'ye yakın dolmamış, acil

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/survey_model.dart';
import '../../services/akademi_service.dart';

class AdminAkademiScreen extends StatelessWidget {
  const AdminAkademiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('📊 Akademi Takip'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Survey>>(
        stream: AkademiService().getAdminSurveysStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final surveys = snapshot.data ?? [];

          if (surveys.isEmpty) {
            return const Center(
              child: Text('Henüz anket yok'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final s = surveys[index];
              final needsUrgent = s.isActive && s.responseCount < 50 && s.remaining.inHours < 24;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: needsUrgent ? const BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (needsUrgent)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'ACİL DOLMASI GEREK - ${50 - s.responseCount} kişi daha',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(s.ownerName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const Spacer(),
                          Text('${s.responseCount}/50', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: s.responseCount < 50 ? Colors.orange : Colors.green)),
                          const SizedBox(width: 8),
                          Text(_formatRemaining(s.remaining), style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _StatusChip(status: s.status, isPaid: s.isPaid),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'Süre doldu';
    if (d.inDays > 0) return '${d.inDays}g';
    if (d.inHours > 0) return '${d.inHours}sa';
    return '${d.inMinutes}dk';
  }
}

class _StatusChip extends StatelessWidget {
  final SurveyStatus status;
  final bool isPaid;

  const _StatusChip({required this.status, required this.isPaid});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    if (!isPaid) {
      label = 'Ödeme Bekliyor';
      color = Colors.orange;
    } else if (status == SurveyStatus.active) {
      label = 'Yayında';
      color = Colors.green;
    } else if (status == SurveyStatus.extended) {
      label = 'Uzatıldı';
      color = Colors.blue;
    } else {
      label = 'Tamamlandı';
      color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
