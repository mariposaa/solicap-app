import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/points_service.dart';
import '../services/leaderboard_service.dart';
import '../models/leaderboard_model.dart';
import '../models/socratic_session_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SocraticTutorScreen extends StatefulWidget {
  const SocraticTutorScreen({super.key});

  @override
  State<SocraticTutorScreen> createState() => _SocraticTutorScreenState();
}

class _SocraticTutorScreenState extends State<SocraticTutorScreen> {
  final GeminiService _geminiService = GeminiService();
  final PointsService _pointsService = PointsService();
  final ImagePicker _picker = ImagePicker();

  // Session State
  Uint8List? _questionImage;
  int _currentStep = 0; // 0: Start, 1-3: Steps
  List<SocraticStep> _steps = [];
  bool _isLoading = false;
  bool _isSolved = false;

  // Timer State
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Süre Doldu! ⏳'),
        content: const Text('Düşünme süren bitti. Odaklanman için soruyu başa alıyoruz.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetSession();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _resetSession() {
    setState(() {
      _questionImage = null;
      _currentStep = 0;
      _steps = [];
      _isSolved = false;
      _secondsRemaining = 60;
    });
    _timer?.cancel();
  }

  Future<void> _pickQuestionImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _questionImage = bytes;
        _currentStep = 1;
      });
      _startTimer();
    }
  }

  Future<void> _pickWorkAndAnalyze() async {
    if (_questionImage == null) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final workBytes = await image.readAsBytes();

    setState(() => _isLoading = true);
    _timer?.cancel();

    try {
      final result = await _geminiService.analyzeSocraticWork(
        questionImage: _questionImage!,
        workImage: workBytes,
        stepNumber: _currentStep,
      );

      if (result != null) {
        final newStep = SocraticStep(
          number: _currentStep,
          studentWorkUrl: '', // URLs will be handled with Cloud Storage if needed later
          aiFeedback: result['evaluation'] ?? '',
          nextHint: result['next_hint'] ?? '',
          timestamp: DateTime.now(),
        );

        setState(() {
          _steps.add(newStep);
          _isSolved = result['is_solved'] ?? false;
          _isLoading = false;
          
          if (!_isSolved && _currentStep < 3) {
            _currentStep++;
            _startTimer();
          } else if (_currentStep >= 3 && !_isSolved) {
             _isSolved = true; // For now end if 3 steps reached or solve
          }
          
          // 🏆 Sokratik oturum tamamlandıysa puan ekle (+20)
          if (_isSolved) {
            LeaderboardService().addPoints(
              LeaderboardPoints.socraticSession,
              'socratic_session',
            );
          }
        });
      } else {
        setState(() => _isLoading = false);
        _startTimer(); // Resume if failed
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _startTimer();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sokratik Öğrenci Koçu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_questionImage == null) {
      return _buildIntro();
    }

    if (_isSolved) {
      return _buildSuccessState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildStageIndicator(),
          const SizedBox(height: 20),
          _buildTimerWidget(),
          const SizedBox(height: 20),
          _buildQuestionImagePreview(),
          const SizedBox(height: 20),
          _buildLastFeedback(),
          const SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology, size: 80, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 32),
            const Text(
              'Sokratik Koç Nedir?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ben sana cevabı direkt vermem. Soruyu adım adım beraber çözeriz. Sen her adımda çözümünü paylaşırsın, ben yaptığın hataları söyler ve yeni bir ipucu veririm.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 8),
            const Text(
              '⚠️ Her analiz 3💎 maliyetindedir ve 1 dakikalık düşünme süren vardır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.amber, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _pickQuestionImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Sorunun Fotoğrafını Çek'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final stepNum = index + 1;
        final isActive = _currentStep == stepNum;
        final isDone = _currentStep > stepNum;

        return Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive 
                    ? AppTheme.primaryColor 
                    : isDone ? Colors.green : AppTheme.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: isDone 
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '$stepNum',
                        style: TextStyle(
                          color: isActive || isDone ? Colors.white : AppTheme.textMuted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (index < 2)
              Container(
                width: 40,
                height: 2,
                color: isDone ? Colors.green : Colors.grey.withOpacity(0.3),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTimerWidget() {
    final color = _secondsRemaining < 10 ? Colors.red : Colors.amber;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            '00:${_secondsRemaining.toString().padLeft(2, '0')}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: MemoryImage(_questionImage!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Orijinal Soru',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildLastFeedback() {
    if (_steps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Text(
              'Haydi Başlayalım! 🚀',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            SizedBox(height: 12),
            Text(
              'Sorunun çözümü için kağıtta bir şeyler yapmaya başla. İstediğin bir aşamada karalamanı "Fotoğraf Çek" butonu ile bana gönder.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    final lastStep = _steps.last;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppTheme.primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text('AI Değerlendirmesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              MarkdownBody(
                data: lastStep.aiFeedback,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: AppTheme.textPrimary, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡 Yeni İpucu', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              const SizedBox(height: 8),
              Text(lastStep.nextHint, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _pickWorkAndAnalyze,
          icon: const Icon(Icons.camera_alt),
          label: Text('Çözümünü Gönder (Adım $_currentStep)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _resetSession,
          child: const Text('Soruyu Değiştir', style: TextStyle(color: AppTheme.textMuted)),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars, size: 100, color: Colors.green),
            const SizedBox(height: 32),
            const Text(
              'Tebrikler! 🎉',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Soruyu harika bir şekilde analiz edip çözüme ulaştın. Sokratik yöntemle öğrenmek her zaman daha kalıcıdır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Harika!', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
