/// SOLICAP - Socratic Mode Screen
/// Sokratik öğrenme modu - AI yönlendirici sorular sorar

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';

class SocraticModeScreen extends StatefulWidget {
  final String questionText;
  final String? questionImageUrl;

  const SocraticModeScreen({
    super.key,
    required this.questionText,
    this.questionImageUrl,
  });

  @override
  State<SocraticModeScreen> createState() => _SocraticModeScreenState();
}

class _SocraticModeScreenState extends State<SocraticModeScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _answerController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isSolved = false;
  int _currentStep = 1;
  int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    setState(() => _isLoading = true);
    
    // Soruyu ekle
    _messages.add(ChatMessage(
      text: widget.questionText,
      isUser: false,
      isQuestion: true,
    ));

    // İlk ipucunu al
    final session = await _geminiService.socraticHint(
      questionText: widget.questionText,
      currentStep: 1,
    );

    if (session != null) {
      setState(() {
        _messages.add(ChatMessage(
          text: session.tutorMessage,
          isUser: false,
        ));
        _currentStep = session.stepNumber;
        _totalSteps = session.totalStepsEstimated;
        _isSolved = session.isSolved;
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  Future<void> _sendAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) return;

    // Kullanıcı cevabını ekle
    setState(() {
      _messages.add(ChatMessage(text: answer, isUser: true));
      _isLoading = true;
    });
    _answerController.clear();
    _scrollToBottom();

    // Sohbet geçmişini hazırla
    final chatHistory = _messages
        .where((m) => !m.isQuestion)
        .map((m) => '${m.isUser ? "Öğrenci" : "Öğretmen"}: ${m.text}')
        .toList();

    // AI yanıtını al
    final session = await _geminiService.socraticHint(
      questionText: widget.questionText,
      chatHistory: chatHistory,
      currentStep: _currentStep + 1,
    );

    if (session != null) {
      setState(() {
        _messages.add(ChatMessage(
          text: session.tutorMessage,
          isUser: false,
        ));
        _currentStep = session.stepNumber;
        _totalSteps = session.totalStepsEstimated;
        _isSolved = session.isSolved;
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _giveUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text(
          'Pes Mi Ediyorsun?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Cevabı görmek istersen normal çözüm moduna geçeceğiz. Emin misin?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hayır, Devam'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, 'give_up'); // Çözüm moduna geç
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Evet, Cevabı Göster'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.psychology, color: AppTheme.accentColor),
            const SizedBox(width: 8),
            const Text(
              'Sokratik Mod',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            const Spacer(),
            // İlerleme göstergesi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Adım $_currentStep/$_totalSteps',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // İlerleme çubuğu
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            backgroundColor: AppTheme.surfaceColor,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
          ),
          
          // Sohbet alanı
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Alt bar
          if (!_isSolved)
            _buildInputBar()
          else
            _buildCompletedBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: message.isQuestion 
                  ? AppTheme.primaryColor 
                  : AppTheme.accentColor,
              radius: 16,
              child: Icon(
                message.isQuestion ? Icons.help : Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser 
                    ? AppTheme.primaryColor 
                    : message.isQuestion
                        ? AppTheme.cardColor
                        : AppTheme.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? null : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : null,
                ),
                border: message.isQuestion
                    ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: AppTheme.successColor,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Pes et butonu
            IconButton(
              onPressed: _giveUp,
              icon: const Icon(Icons.flag, color: AppTheme.warningColor),
              tooltip: 'Pes Et',
            ),
            const SizedBox(width: 8),
            // Cevap alanı
            Expanded(
              child: TextField(
                controller: _answerController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Cevabını yaz...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendAnswer(),
              ),
            ),
            const SizedBox(width: 8),
            // Gönder butonu
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _isLoading ? null : _sendAnswer,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: AppTheme.successColor.withOpacity(0.3)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.celebration, color: AppTheme.successColor),
                SizedBox(width: 8),
                Text(
                  'Tebrikler! Doğru cevabı buldun! 🎉',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'solved'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
              ),
              child: const Text('Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sohbet mesajı modeli
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isQuestion;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isQuestion = false,
  });
}
