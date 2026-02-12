/// SOLICAP - Seviye Belirleme Testi
/// 24 soruluk CEFR bazlı placement test (her seviye çift sayı soru)

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/language_models.dart';
import '../services/language_learning_service.dart';

class LanguagePlacementScreen extends StatefulWidget {
  const LanguagePlacementScreen({super.key});

  @override
  State<LanguagePlacementScreen> createState() => _LanguagePlacementScreenState();
}

class _LanguagePlacementScreenState extends State<LanguagePlacementScreen> {
  final LanguageLearningService _service = LanguageLearningService();
  late final List<PlacementQuestion> _questions;
  final List<bool> _answers = [];
  int _currentIndex = 0;
  int? _selectedOption;
  bool _showResult = false;
  LanguageProgress? _result;

  bool get _isSmallScreen => MediaQuery.of(context).size.width < 380;

  @override
  void initState() {
    super.initState();
    _questions = _service.getPlacementQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Seviye Belirleme', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _showResult ? _buildResultView() : _buildQuestionView(),
    );
  }

  Widget _buildQuestionView() {
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Padding(
      padding: EdgeInsets.all(_isSmallScreen ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İlerleme
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_currentIndex + 1}/${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Seviye: ${q.level.code}',
            style: TextStyle(fontSize: _isSmallScreen ? 10 : 12, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),

          // Soru
          Text(
            q.question,
            style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 24),

          // Seçenekler
          ...List.generate(q.options.length, (i) {
            final isSelected = _selectedOption == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => setState(() => _selectedOption = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2E7D32).withOpacity(0.1) : AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.withOpacity(0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      q.options[i],
                      style: TextStyle(
                        fontSize: _isSmallScreen ? 14 : 16,
                        color: isSelected ? const Color(0xFF2E7D32) : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // İleri butonu
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedOption != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _currentIndex < _questions.length - 1 ? 'Sonraki' : 'Tamamla',
                style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    final q = _questions[_currentIndex];
    _answers.add(_selectedOption == q.correctIndex);
    _selectedOption = null;

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _evaluateTest();
    }
  }

  Future<void> _evaluateTest() async {
    setState(() => _showResult = true);
    final result = await _service.evaluatePlacement(_answers);
    if (mounted) {
      setState(() => _result = result);
    }
  }

  Widget _buildResultView() {
    if (_result == null) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
    }

    final correct = _answers.where((a) => a).length;
    final level = _result!.currentLevel;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(_isSmallScreen ? 20 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
                ],
              ),
              child: Text(
                level.code,
                style: TextStyle(fontSize: _isSmallScreen ? 28 : 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Seviyen Belirlendi!',
              style: TextStyle(fontSize: _isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              '${level.code} - ${level.label}',
              style: TextStyle(fontSize: _isSmallScreen ? 15 : 18, color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              '$correct/${_questions.length} doğru cevap',
              style: TextStyle(fontSize: _isSmallScreen ? 13 : 15, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              '+100 XP kazandın!',
              style: TextStyle(fontSize: _isSmallScreen ? 12 : 14, color: Colors.amber, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _result),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Derslere Başla', style: TextStyle(fontSize: _isSmallScreen ? 14 : 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
