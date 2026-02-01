/// Anket Doldur Tab - Aktif anketeri listele, doldur (+50 puan)

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/survey_model.dart';
import '../../../services/akademi_service.dart';
import '../survey_fill_screen.dart';

class SurveyFillTab extends StatelessWidget {
  const SurveyFillTab({super.key});

  @override
  Widget build(BuildContext context) {
    final akademiService = AkademiService();

    return StreamBuilder<List<Survey>>(
      stream: akademiService.getActiveSurveysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final surveys = snapshot.data ?? [];
        final activeSurveys = surveys.where((s) => s.isActive).toList();

        if (activeSurveys.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Şu an doldurulacak anket yok', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Yeni anketler burada görünecek', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeSurveys.length,
          itemBuilder: (context, index) {
            final s = activeSurveys[index];
            return _SurveyCard(survey: s);
          },
        );
      },
    );
  }
}

class _SurveyCard extends StatefulWidget {
  final Survey survey;

  const _SurveyCard({required this.survey});

  @override
  State<_SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<_SurveyCard> {
  final AkademiService _akademiService = AkademiService();
  bool _checking = false;
  bool _alreadyFilled = false;

  @override
  void initState() {
    super.initState();
    _checkFilled();
  }

  Future<void> _checkFilled() async {
    setState(() => _checking = true);
    final filled = await _akademiService.hasUserResponded(widget.survey.id);
    if (mounted) setState(() {
      _checking = false;
      _alreadyFilled = filled;
    });
  }

  String _formatRemaining(Duration d) {
    if (d.inDays > 0) return '${d.inDays}g ${d.inHours % 24}sa';
    if (d.inHours > 0) return '${d.inHours}sa ${d.inMinutes % 60}dk';
    return '${d.inMinutes}dk';
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.survey;
    final remaining = s.remaining;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: _checking || _alreadyFilled
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyFillScreen(survey: s),
                  ),
                ).then((_) => _checkFilled()),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  if (_alreadyFilled)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Dolduruldu', style: TextStyle(fontSize: 11, color: Colors.green)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(_formatRemaining(remaining), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('${s.responseCount} katılımcı', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('+50 puan kazan', style: TextStyle(fontSize: 11, color: Colors.amber)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
