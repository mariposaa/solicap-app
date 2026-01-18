/// SOLICAP - Splash Screen
/// Açık tema ile başlatma ekranı + Onboarding kontrolü

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_dna_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  String _statusText = 'Başlatılıyor...';

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
      ),
    );
    
    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      setState(() => _statusText = 'Giriş yapılıyor...');
      
      final user = await _authService.silentSignIn();
      
      if (!mounted) return;
      
      if (user != null) {
        setState(() => _statusText = 'Profil kontrol ediliyor...');
        
        // DNA kontrol et - onboarding gerekli mi?
        final dna = await _dnaService.getDNA();
        // Onboarding tamamlandı mı? gradeLevel VEYA targetExam dolduysa tamamlanmış sayılır
        final needsOnboarding = dna == null || 
            (dna.gradeLevel == null || dna.gradeLevel!.isEmpty) &&
            (dna.targetExam == null || dna.targetExam!.isEmpty);
        
        // 📉 DNA DECAY: Mevcut kullanıcı için unutma eğrisini uygula
        if (!needsOnboarding) {
          await _dnaService.applyDNADecay();
          debugPrint('📉 DNA Decay uygulandı (uygulama başlangıcı)');
        }
        
        if (!mounted) return;
        setState(() => _statusText = 'Hoş geldin! 🎓');
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          if (needsOnboarding) {
            // İlk kez giriş - Universal Onboarding göster
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          } else {
            // Mevcut kullanıcı - Ana ekrana git
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        }
      } else {
        // Giriş yapılamadı - yine de onboarding'e yönlendir
        setState(() => _statusText = 'Hazırlanıyor...');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    } catch (e) {
      debugPrint('Splash hata: $e');
      if (!mounted) return;
      setState(() => _statusText = 'Hata: $e');
      
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.backgroundColor,
              Color(0xFFE0F2FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppTheme.elevatedShadow,
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ShaderMask(
                        shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                        child: const Text(
                          'SOLICAP',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI Destekli Öğrenme Asistanı',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 60),
                      SizedBox(
                        width: 180,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                backgroundColor: AppTheme.dividerColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryColor,
                                ),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _statusText,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
