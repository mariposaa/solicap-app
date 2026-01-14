/// SOLICAP - Why Wrong Analysis Screen
/// Neden yanlış yaptım analizi - Düşünce Dedektifi

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';

class WhyWrongScreen extends StatefulWidget {
  final String questionText;
  final String correctSolution;
  final String userWrongChoice;

  const WhyWrongScreen({
    super.key,
    required this.questionText,
    required this.correctSolution,
    required this.userWrongChoice,
  });

  @override
  State<WhyWrongScreen> createState() => _WhyWrongScreenState();
}

class _WhyWrongScreenState extends State<WhyWrongScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _explanationController = TextEditingController();
  
  CognitiveDiagnosis? _diagnosis;
  bool _isLoading = false;
  bool _hasSubmitted = false;

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _analyzeThinkin() async {
    final explanation = _explanationController.text.trim();
    if (explanation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen düşünce sürecini açıkla'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final diagnosis = await _geminiService.analyzeUserThinking(
      questionText: widget.questionText,
      correctSolution: widget.correctSolution,
      userWrongChoice: widget.userWrongChoice,
      userExplanation: explanation,
    );

    setState(() {
      _diagnosis = diagnosis;
      _isLoading = false;
      _hasSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.psychology_alt, color: AppTheme.warningColor),
            SizedBox(width: 8),
            Text(
              'Düşünce Dedektifi',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Soru özeti
            _buildQuestionSummary(),
            
            const SizedBox(height: 24),
            
            if (!_hasSubmitted) ...[
              // Açıklama girişi
              _buildExplanationInput(),
            ] else if (_diagnosis != null) ...[
              // Tanı sonucu
              _buildDiagnosisResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close,
                  color: AppTheme.errorColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Yanlış Cevapladığın Soru',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.questionText.length > 150
                ? '${widget.questionText.substring(0, 150)}...'
                : widget.questionText,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Senin cevabın: ${widget.userWrongChoice}',
                  style: const TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🤔 Şimdi bana anlat...',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bu soruyu çözerken ne düşündün? Hangi adımları takip ettin?',
          style: TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        
        TextField(
          controller: _explanationController,
          maxLines: 6,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Örn: "Önce parantez içini topladım, sonra 3 ile çarptım..."',
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            filled: true,
            fillColor: AppTheme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        
        const SizedBox(height: 20),
        
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _analyzeThinkin,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.search),
            label: Text(_isLoading ? 'Analiz ediliyor...' : 'Hatamı Bul'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiagnosisResult() {
    final diagnosis = _diagnosis!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hata tipi kartı
        _buildErrorTypeCard(diagnosis),
        
        const SizedBox(height: 20),
        
        // Onay mesajı
        if (diagnosis.validationText.isNotEmpty)
          _buildFeedbackCard(
            icon: Icons.check_circle,
            iconColor: AppTheme.successColor,
            title: 'Doğru Yaptığın',
            content: diagnosis.validationText,
          ),
        
        const SizedBox(height: 16),
        
        // Düzeltme mesajı
        if (diagnosis.correctionText.isNotEmpty)
          _buildFeedbackCard(
            icon: Icons.lightbulb,
            iconColor: AppTheme.accentColor,
            title: 'Aslında...',
            content: diagnosis.correctionText,
          ),
        
        const SizedBox(height: 16),
        
        // Koç ipucu
        if (diagnosis.coachTip.isNotEmpty)
          _buildFeedbackCard(
            icon: Icons.tips_and_updates,
            iconColor: AppTheme.primaryColor,
            title: 'Bir Dahaki Sefere',
            content: diagnosis.coachTip,
          ),
        
        const SizedBox(height: 24),
        
        // Butonlar
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _hasSubmitted = false;
                    _diagnosis = null;
                    _explanationController.clear();
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Tekrar Anlat'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, diagnosis),
                child: const Text('Anladım'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorTypeCard(CognitiveDiagnosis diagnosis) {
    Color typeColor;
    IconData typeIcon;
    
    switch (diagnosis.errorType) {
      case 'CALCULATION':
        typeColor = AppTheme.warningColor;
        typeIcon = Icons.calculate;
        break;
      case 'CONCEPT':
        typeColor = AppTheme.errorColor;
        typeIcon = Icons.school;
        break;
      case 'READING':
        typeColor = AppTheme.accentColor;
        typeIcon = Icons.visibility;
        break;
      case 'LOGIC':
        typeColor = AppTheme.primaryColor;
        typeIcon = Icons.psychology;
        break;
      default:
        typeColor = AppTheme.textMuted;
        typeIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withOpacity(0.2),
            typeColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: typeColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(typeIcon, color: typeColor, size: 48),
          const SizedBox(height: 12),
          Text(
            diagnosis.errorTypeDescription,
            style: TextStyle(
              color: typeColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (diagnosis.isLogicPartiallyCorrect)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_up, color: AppTheme.successColor, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Mantığın kısmen doğru!',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
