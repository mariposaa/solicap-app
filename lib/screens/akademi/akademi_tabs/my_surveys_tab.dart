/// Anketlerim Tab - Oluşturduğum anketeri listele, süre uzat, indir

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/app_theme.dart';
import '../../../models/survey_model.dart';
import '../../../services/akademi_service.dart';

class MySurveysTab extends StatelessWidget {
  const MySurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Survey>>(
      stream: AkademiService().getMySurveysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final surveys = snapshot.data ?? [];

        if (surveys.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list_alt, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Henüz anket oluşturmadınız', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Anket Oluştur sekmesinden başlayın', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: surveys.length,
          itemBuilder: (context, index) => _MySurveyCard(survey: surveys[index]),
        );
      },
    );
  }
}

class _MySurveyCard extends StatefulWidget {
  final Survey survey;

  const _MySurveyCard({required this.survey});

  @override
  State<_MySurveyCard> createState() => _MySurveyCardState();
}

class _MySurveyCardState extends State<_MySurveyCard> {
  bool _isDownloading = false;

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'Süre doldu';
    if (d.inDays > 0) return '${d.inDays}g ${d.inHours % 24}sa';
    if (d.inHours > 0) return '${d.inHours}sa ${d.inMinutes % 60}dk';
    return '${d.inMinutes}dk';
  }

  Future<void> _downloadSurvey() async {
    final s = widget.survey;
    setState(() => _isDownloading = true);
    try {
      final csv = await AkademiService().exportSurveyToCsv(s.id);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/anket_${s.id}_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv, encoding: utf8);
      if (!mounted) return;
      await Share.shareXFiles([XFile(file.path)], text: 'Anket verileri (SPSS uyumlu CSV)');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('İndirme hatası: $e')));
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.survey;
    final remaining = s.remaining;
    final isCompleted = remaining.isNegative || s.status == SurveyStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                _StatusChip(status: s.status, isPaid: s.isPaid),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(_formatRemaining(remaining), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(width: 16),
                Icon(Icons.people_outline, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('${s.responseCount}/50', style: TextStyle(fontSize: 12, color: s.responseCount < 50 ? Colors.orange : Colors.green)),
              ],
            ),
            if (s.isActive && s.responseCount < 50 && remaining.inHours < 24) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await AkademiService().extendSurvey(s.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Süre 1 gün uzatıldı')));
                  }
                },
                icon: const Icon(Icons.add_alarm, size: 16),
                label: const Text('Süre Uzat (1 gün)'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ],
            if (isCompleted && s.responseCount > 0) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isDownloading ? null : _downloadSurvey,
                  icon: _isDownloading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.download, size: 18),
                  label: Text(_isDownloading ? 'Hazırlanıyor...' : 'Verileri İndir (CSV)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
