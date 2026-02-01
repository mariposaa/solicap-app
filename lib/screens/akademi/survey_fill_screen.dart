/// Anket Doldurma Ekranı - Soruları göster, yanıt topla, gönder (+50 puan)

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/survey_model.dart';
import '../../services/akademi_service.dart';

class SurveyFillScreen extends StatefulWidget {
  final Survey survey;

  const SurveyFillScreen({super.key, required this.survey});

  @override
  State<SurveyFillScreen> createState() => _SurveyFillScreenState();
}

class _SurveyFillScreenState extends State<SurveyFillScreen> {
  final AkademiService _akademiService = AkademiService();
  final Map<String, dynamic> _answers = {};
  int _currentIndex = 0;
  bool _isSubmitting = false;

  List<SurveyQuestion> get _questions => widget.survey.questions..sort((a, b) => a.order.compareTo(b.order));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.survey.title),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Bilgilendirme (kişi bilgisi tutulmuyor)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bu ankette kişi bilgileriniz tutulmamaktadır. Veriler sadece akademik araştırma için kullanılır.',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                  ),
                ),
              ],
            ),
          ),
          // Sayaç: 3 günlük + katılımcı sayısı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(_formatRemaining(widget.survey.remaining), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('${widget.survey.responseCount} kişi doldurdu', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Soru ${_currentIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 16),
          // Soru içeriği
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildQuestionWidget(_questions[_currentIndex]),
            ),
          ),
          // Navigasyon
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentIndex > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _currentIndex--),
                    child: const Text('Geri'),
                  ),
                if (_currentIndex > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            if (!_validateCurrent()) return;
                            if (_currentIndex < _questions.length - 1) {
                              setState(() => _currentIndex++);
                            } else {
                              await _submit();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(_currentIndex < _questions.length - 1 ? 'İleri' : 'Gönder (+50 puan)'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _validateCurrent() {
    final q = _questions[_currentIndex];
    if (!q.required) return true;
    final key = q.order.toString();
    final val = _answers[key];
    if (val == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bu soruyu yanıtlayın')));
      return false;
    }
    if (val is List && val.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('En az bir seçenek seçin')));
      return false;
    }
    return true;
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      await _akademiService.submitResponse(widget.survey.id, _answers);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Anket gönderildi! +50 puan kazandınız.')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildQuestionWidget(SurveyQuestion q) {
    final key = q.order.toString();
    switch (q.type) {
      case SurveyQuestionType.singleChoice:
        return _buildSingleChoice(q, key);
      case SurveyQuestionType.multipleChoice:
        return _buildMultipleChoice(q, key);
      case SurveyQuestionType.likert5:
      case SurveyQuestionType.likert7:
        return _buildLikert(q, key);
      case SurveyQuestionType.openText:
        return _buildOpenText(q, key);
      case SurveyQuestionType.matrix:
        return _buildMatrix(q, key);
    }
  }

  Widget _buildSingleChoice(SurveyQuestion q, String key) {
    final options = q.options ?? [];
    final selected = _answers[key] as int?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        ...options.map((o) => RadioListTile<int>(
              title: Text(o.label),
              value: o.code,
              groupValue: selected,
              onChanged: (v) => setState(() => _answers[key] = v),
            )),
      ],
    );
  }

  Widget _buildMultipleChoice(SurveyQuestion q, String key) {
    final options = q.options ?? [];
    final selected = (_answers[key] as List<dynamic>?)?.cast<int>() ?? <int>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        ...options.map((o) => CheckboxListTile(
              title: Text(o.label),
              value: selected.contains(o.code),
              onChanged: (v) {
                setState(() {
                  if (v == true) {
                    _answers[key] = [...selected, o.code];
                  } else {
                    _answers[key] = selected.where((x) => x != o.code).toList();
                  }
                });
              },
            )),
      ],
    );
  }

  Widget _buildLikert(SurveyQuestion q, String key) {
    final steps = q.type == SurveyQuestionType.likert5 ? 5 : 7;
    final scale = q.likertScale;
    final selected = _answers[key] as int?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        if (scale != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(scale.minLabel, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(scale.maxLabel, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: List.generate(steps, (i) {
            final value = i + 1;
            final isSelected = selected == value;
            return ChoiceChip(
              label: Text('$value'),
              selected: isSelected,
              onSelected: (v) => setState(() => _answers[key] = value),
              selectedColor: AppTheme.primaryColor.withOpacity(0.3),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOpenText(SurveyQuestion q, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        TextField(
          maxLines: 4,
          onChanged: (v) => _answers[key] = v,
          decoration: InputDecoration(
            hintText: 'Yanıtınızı yazın...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildMatrix(SurveyQuestion q, String key) {
    final rows = q.matrixRows ?? [];
    final selected = (_answers[key] as Map<String, dynamic>?) ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        ...rows.asMap().entries.map((entry) {
          final rowIndex = entry.key;
          final row = entry.value;
          final rowKey = '${key}_$rowIndex';
          final val = selected[rowKey] as int?;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: (row.options).map((o) {
                    final isSelected = val == o.code;
                    return ChoiceChip(
                      label: Text(o.label),
                      selected: isSelected,
                      onSelected: (v) => setState(() {
                        selected[rowKey] = o.code;
                        _answers[key] = Map<String, dynamic>.from(selected);
                      }),
                      selectedColor: AppTheme.primaryColor.withOpacity(0.3),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'Süre doldu';
    if (d.inDays > 0) return '${d.inDays}g ${d.inHours % 24}sa kaldı';
    if (d.inHours > 0) return '${d.inHours}sa ${d.inMinutes % 60}dk kaldı';
    return '${d.inMinutes}dk kaldı';
  }
}
