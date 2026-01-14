/// SOLICAP - Universal Onboarding Screen
/// Evrensel karşılama ekranı - Sohbet tarzı profil oluşturma

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_theme.dart';
import '../services/supervisor_service.dart';
import '../services/user_dna_service.dart';
import '../services/analytics_service.dart';
import 'home_screen.dart';

class UniversalOnboardingScreen extends StatefulWidget {
  const UniversalOnboardingScreen({super.key});

  @override
  State<UniversalOnboardingScreen> createState() => _UniversalOnboardingScreenState();
}

class _UniversalOnboardingScreenState extends State<UniversalOnboardingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final SupervisorService _supervisorService = SupervisorService();
  final UserDNAService _dnaService = UserDNAService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isProcessing = false;
  bool _showInput = false;
  String _currentMessage = '';
  int _attemptCount = 0;
  
  // 💬 Konuşma geçmişi - tüm kullanıcı yanıtlarını biriktir
  final List<String> _conversationHistory = [];
  
  // Kullanıcının telefon dili
  late String _uiLanguage;

  @override
  void initState() {
    super.initState();
    
    // Telefon dilini al
    _uiLanguage = _getDeviceLanguage();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // Animasyonu başlat
    _animationController.forward();
    
    // Karşılama mesajını ayarla
    _setWelcomeMessage();
    
    // Input'u göster (delay ile)
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _showInput = true);
      }
    });
  }

  /// Cihaz dilini al
  String _getDeviceLanguage() {
    String locale = 'en';
    
    try {
      if (kIsWeb) {
        // Web için locale al (Basic fallback)
        locale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      } else {
        locale = Platform.localeName.toLowerCase();
      }
    } catch (e) {
      debugPrint('Locale alınamadı: $e');
    }

    if (locale.startsWith('tr')) return 'TR';
    if (locale.startsWith('de')) return 'DE';
    if (locale.startsWith('fr')) return 'FR';
    if (locale.startsWith('es')) return 'ES';
    if (locale.startsWith('ar')) return 'AR';
    return 'EN';
  }

  /// Karşılama mesajını dile göre ayarla
  void _setWelcomeMessage() {
    switch (_uiLanguage) {
      case 'DE':
        _currentMessage = 'Hallo! Ich bin Solicap, dein persönlicher Lernassistent.\n\nErzähl mir ein bisschen von dir, damit ich dir am besten helfen kann.\n\n💡 Beispiel: "Ich bin Medizinstudent im 3. Semester und habe Schwierigkeiten mit Anatomie"';
        break;
      case 'FR':
        _currentMessage = 'Bonjour! Je suis Solicap, ton assistant d\'apprentissage personnel.\n\nParle-moi un peu de toi pour que je puisse t\'aider au mieux.\n\n💡 Exemple: "Je suis étudiant en médecine en 3ème année et j\'ai des difficultés en anatomie"';
        break;
      case 'ES':
        _currentMessage = '¡Hola! Soy Solicap, tu asistente de aprendizaje personal.\n\nCuéntame un poco sobre ti para poder ayudarte mejor.\n\n💡 Ejemplo: "Soy estudiante de medicina en 3er año y tengo dificultades con anatomía"';
        break;
      case 'EN':
        _currentMessage = 'Hello! I\'m Solicap, your personal learning assistant.\n\nTell me a bit about yourself so I can help you best.\n\n💡 Example: "I\'m a 3rd year med student struggling with anatomy"';
        break;
      default: // TR
        _currentMessage = 'Merhaba! Ben Solicap, senin kişisel öğrenme asistanın.\n\nSana en iyi şekilde yardımcı olabilmem için kendinden biraz bahset.\n\n💡 Örnek: "LGS\'ye hazırlanıyorum, matematikte zorlanıyorum" veya "Tıp 3. sınıfım, anatomide takılıyorum"';
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Kullanıcı girdisini işle
  Future<void> _processInput() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      // Konuşma geçmişine ekle
      _conversationHistory.add(text);
      
      // Tüm geçmişi birleştirip gönder
      final fullConversation = _conversationHistory.join('\n---\n');
      debugPrint('💬 Konuşma geçmişi: ${_conversationHistory.length} mesaj');
      
      // Supervisor AI ile profil çıkar
      final profile = await _supervisorService.extractProfileFromText(
        fullConversation,
        _uiLanguage,
      );

      _attemptCount++;

      if (profile.isComplete) {
        // Profil tamamlandı - kaydet ve ana sayfaya git
        await _saveProfileAndNavigate(profile, text);
      } else {
        // Eksik bilgi var - takip sorusu sor
        setState(() {
          _currentMessage = profile.followUpQuestion ?? 
              _getDefaultFollowUp();
          _textController.clear();
          _isProcessing = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Onboarding hatası: $e');
      setState(() {
        _currentMessage = _getErrorMessage();
        _isProcessing = false;
      });
    }
  }

  /// Profili kaydet ve ana sayfaya git
  Future<void> _saveProfileAndNavigate(ExtractedProfile profile, String rawText) async {
    try {
      // DNA'yı güncelle
      final currentDna = await _dnaService.getDNA();
      if (currentDna != null) {
        final updatedDna = currentDna.copyWith(
          level: profile.level,
          gradeLevel: profile.grade,
          department: profile.department,
          targetExam: profile.targetExam,
          uiLanguage: _uiLanguage,
          studyLanguage: profile.studyLanguage ?? _uiLanguage,
          explanationLanguage: profile.explanationLanguage ?? _uiLanguage,
          onboardingRawText: rawText,
          interests: profile.interests,
          struggles: profile.struggles,
        );
        await _dnaService.saveDNA(updatedDna);
      }

      // 📊 Analytics: Onboarding tamamlandı
      await AnalyticsService().logOnboardingCompleted(
        level: profile.level ?? 'unknown',
        department: profile.department,
        language: _uiLanguage,
      );

      // Ana sayfaya git
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      debugPrint('❌ Profil kaydetme hatası: $e');
      setState(() {
        _currentMessage = _getErrorMessage();
        _isProcessing = false;
      });
    }
  }

  String _getDefaultFollowUp() {
    switch (_uiLanguage) {
      case 'EN':
        return 'I need a bit more information. Could you tell me what level you\'re studying at? (e.g., high school, university, or professional exam prep)';
      case 'DE':
        return 'Ich brauche etwas mehr Informationen. Könntest du mir sagen, auf welchem Niveau du lernst? (z.B. Gymnasium, Universität oder Berufsvorbereitung)';
      default:
        return 'Biraz daha bilgiye ihtiyacım var. Hangi seviyede olduğunu söyleyebilir misin? (lise, üniversite veya profesyonel sınav hazırlığı)';
    }
  }

  String _getErrorMessage() {
    switch (_uiLanguage) {
      case 'EN':
        return 'Something went wrong. Please try again.';
      case 'DE':
        return 'Etwas ist schief gelaufen. Bitte versuche es erneut.';
      default:
        return 'Bir şeyler yanlış gitti. Lütfen tekrar dene.';
    }
  }

  String _getInputHint() {
    switch (_uiLanguage) {
      case 'EN':
        return 'Tell me about yourself...';
      case 'DE':
        return 'Erzähl mir von dir...';
      case 'FR':
        return 'Parle-moi de toi...';
      case 'ES':
        return 'Cuéntame sobre ti...';
      default:
        return 'Kendinden bahset...';
    }
  }

  String _getSendButtonText() {
    switch (_uiLanguage) {
      case 'EN':
        return 'Continue';
      case 'DE':
        return 'Weiter';
      case 'FR':
        return 'Continuer';
      case 'ES':
        return 'Continuar';
      default:
        return 'Devam Et';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  
                  // Logo / Avatar
                  _buildAvatar(),
                  
                  const SizedBox(height: 32),
                  
                  // AI Mesajı
                  _buildMessageBubble(),
                  
                  const Spacer(flex: 1),
                  
                  // Input Alanı
                  if (_showInput) _buildInputSection(),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.psychology_rounded,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageBubble() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _currentMessage,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInputSection() {
    return AnimatedOpacity(
      opacity: _showInput ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Column(
        children: [
          // TextField
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: TextField(
              controller: _textController,
              maxLines: 4,
              minLines: 2,
              enabled: !_isProcessing,
              decoration: InputDecoration(
                hintText: _getInputHint(),
                hintStyle: TextStyle(color: AppTheme.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gönder Butonu
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getSendButtonText(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          ),
          
          // Deneme sayısı (debug için)
          if (_attemptCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text(
                  _getSkipText(),
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getSkipText() {
    switch (_uiLanguage) {
      case 'EN':
        return 'Skip and start learning';
      case 'DE':
        return 'Überspringen ve lernen';
      default:
        return 'Atla ve hemen başla';
    }
  }

  Future<void> _skipOnboarding() async {
    // Boş veya varsayılan bir DNA oluşturup devam et
    final profile = ExtractedProfile(status: 'complete', level: 'k12');
    await _saveProfileAndNavigate(profile, 'Skipped onboarding');
  }
}
