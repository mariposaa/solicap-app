/// Anket düzenleyici - Soruları göster/düzenle, demografik ekle

import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/survey_model.dart';

class SurveyEditorSheet extends StatefulWidget {
  final List<SurveyQuestion> initialQuestions;
  final String initialTitle;
  final void Function(String title, List<SurveyQuestion> questions, bool includeDemographics) onSave;

  const SurveyEditorSheet({
    super.key,
    required this.initialQuestions,
    required this.initialTitle,
    required this.onSave,
  });

  @override
  State<SurveyEditorSheet> createState() => _SurveyEditorSheetState();
}

class _SurveyEditorSheetState extends State<SurveyEditorSheet> {
  late List<SurveyQuestion> _questions;
  late TextEditingController _titleController;
  bool _includeDemographics = false;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.initialQuestions);
    _titleController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text('Anket Önizleme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => widget.onSave(_titleController.text, _questions, _includeDemographics),
                    child: const Text('Kaydet ve Devam'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Anket Başlığı',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: const Text('Demografik sorular ekle'),
                    subtitle: const Text('Yaş, eğitim, cinsiyet (başta sorulur)'),
                    value: _includeDemographics,
                    onChanged: (v) => setState(() => _includeDemographics = v),
                  ),
                  const SizedBox(height: 24),
                  const Text('Sorular', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._questions.asMap().entries.map((e) => _buildQuestionCard(e.key, e.value)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index, SurveyQuestion q) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Soru ${index + 1}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Text(_typeLabel(q.type), style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(q.text, style: const TextStyle(fontSize: 14)),
            if (q.options != null && q.options!.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...q.options!.map((o) => Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text('• ${o.label} (kod: ${o.code})', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  String _typeLabel(SurveyQuestionType t) {
    switch (t) {
      case SurveyQuestionType.singleChoice:
        return 'Tek seçim';
      case SurveyQuestionType.multipleChoice:
        return 'Çoklu seçim';
      case SurveyQuestionType.likert5:
        return 'Likert 1-5';
      case SurveyQuestionType.likert7:
        return 'Likert 1-7';
      case SurveyQuestionType.openText:
        return 'Açık uçlu';
      case SurveyQuestionType.matrix:
        return 'Matris';
    }
  }
}
