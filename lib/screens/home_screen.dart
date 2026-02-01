/// SOLICAP - Home Screen
/// Ana ekran - Soru çekme, duyurular ve navigasyon

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/locked_home_widgets.dart'; // 🔒 Locked Section Import
import '../services/auth_service.dart';
import '../services/gemini_service.dart'; // InsufficientPointsException burada tanımlı
import '../services/question_service.dart';
import '../services/announcement_service.dart';
import '../services/user_dna_service.dart';
import '../services/points_service.dart';
import '../services/supervisor_service.dart';
import '../services/session_tracking_service.dart';
import '../services/smart_study_planner_service.dart';
import '../services/feature_cards_service.dart';
import '../services/localization_service.dart';
import 'campus_screen.dart';
import '../models/announcement_model.dart';
import '../models/user_dna_model.dart';
import '../widgets/home_promo_card.dart';
import 'solution_screen.dart';
import 'history_screen.dart';
import 'progress_screen.dart';
import 'micro_lesson_screen.dart';
import 'spaced_repetition_screen.dart';
import 'topic_list_screen.dart';
import 'admin/admin_panel_screen.dart';
import '../services/admin_service.dart';
import 'feedback_screen.dart';
import 'note_view_screen.dart';
import 'my_notes_screen.dart';
import 'socratic_tutor_screen.dart';
import 'profile_screen.dart';
import 'competitions_screen.dart';
import 'akademi/akademi_screen.dart';
import 'library_screen.dart';
import '../services/leaderboard_service.dart';
import '../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();
  final QuestionService _questionService = QuestionService();
  final AuthService _authService = AuthService();
  final AnnouncementService _announcementService = AnnouncementService();
  final UserDNAService _dnaService = UserDNAService();
  final PointsService _pointsService = PointsService();
  final SupervisorService _supervisorService = SupervisorService();
  final SessionTrackingService _sessionTracker = SessionTrackingService();
  
  int _currentIndex = 0;
  int _akademiInitialTab = 0; // Promo kartından gelince 1 (Doldur)
  bool _isProcessing = false;
  List<Announcement> _announcements = [];
  bool _isLoadingAnnouncements = true;
  
  // 🧠 Günlük Çalışma Planı
  final SmartStudyPlannerService _studyPlanner = SmartStudyPlannerService();
  DailyStudyPlan? _dailyPlan;

  // 🔐 Admin Girişi
  int _adminTapCount = 0;
  DateTime? _lastTapTime;
  
  // 📢 Bilgilendirme Kartları Carousel
  late PageController _featurePageController;
  int _currentFeaturePage = 0;
  Timer? _featureTimer;
  List<FeatureCard> _featureCards = [];

  @override
  void initState() {
    super.initState();
    _featurePageController = PageController(initialPage: 0);
    _loadAnnouncements();
    _loadDailyPlan();
    _loadFeatureCards();
  }
  
  Future<void> _loadFeatureCards() async {
    final cards = await FeatureCardsService.getCards();
    if (mounted) {
      setState(() => _featureCards = cards);
      _startFeatureCarouselTimer();
    }
  }
  
  @override
  void dispose() {
    _featurePageController.dispose();
    _featureTimer?.cancel();
    super.dispose();
  }
  
  void _startFeatureCarouselTimer() {
    _featureTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_featurePageController.hasClients) {
        _currentFeaturePage++;
        if (_currentFeaturePage >= _featureCards.length) {
          _currentFeaturePage = 0;
        }
        _featurePageController.animateToPage(
          _currentFeaturePage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadDailyPlan() async {
    try {
      final plan = await _studyPlanner.generateDailyPlan();
      if (mounted) {
        setState(() => _dailyPlan = plan);
      }
    } catch (e) {
      debugPrint('❗ Daily plan yüklenemedi: $e');
    }
  }



  Future<void> _loadAnnouncements() async {
    final announcements = await _announcementService.getAnnouncements();
    if (mounted) {
      setState(() {
        _announcements = announcements;
        _isLoadingAnnouncements = false;
      });
    }
  }


  Future<void> _refreshAnnouncements() async {
    final announcements = await _announcementService.refreshAnnouncements();
    if (mounted) {
      setState(() {
        _announcements = announcements;
      });
    }
  }

  /// 🧠 Soru sayısını artır ve kalibrasyon kontrolü yap
  Future<void> _incrementQuestionCount() async {
    try {
      final dna = await _dnaService.getDNA();
      if (dna == null) return;

      final newCount = dna.questionCount + 1;
      final wasCalibrated = dna.isCalibrated;
      final nowCalibrated = newCount >= 10;

      // DNA'yı güncelle
      final updatedDna = dna.copyWith(
        questionCount: newCount,
        isCalibrated: nowCalibrated,
      );
      await _dnaService.saveDNA(updatedDna);

      // Her 5 soruda supervisor kontrolü yap
      if (_supervisorService.shouldRunPeriodicCheck(newCount, dna.lastSupervisorCheck)) {
        debugPrint('🔄 Periyodik supervisor kontrolü başlatılıyor (soru #$newCount)');
        // Burada periyodik analiz yapılabilir
        // Arka planda çalışır, kullanıcı beklemez
        _runPeriodicSupervisorCheck(newCount);
      }

      // Kalibrasyon tamamlandı mı?
      if (!wasCalibrated && nowCalibrated) {
        debugPrint('🎉 Kalibrasyon tamamlandı!');
        // İlk analiz hazır bildirimi gösterilebilir
      }
    } catch (e) {
      debugPrint('❌ Question count artırma hatası: $e');
    }
  }

  /// Arka planda supervisor kontrolü çalıştır
  Future<void> _runPeriodicSupervisorCheck(int currentCount) async {
    try {
      // Son 5 sorunun verilerini al (basitleştirilmiş)
      final recentQuestions = <Map<String, dynamic>>[];
      
      final result = await _supervisorService.analyzeRecentActivity(
        recentQuestions,
        'TR', // TODO: Get from DNA if needed
      );

      if (result.insight != null) {
        debugPrint('📊 Supervisor insight: ${result.insight}');
      }

      // DNA'yı güncelle (lastSupervisorCheck)
      final dna = await _dnaService.getDNA();
      if (dna != null) {
        final updatedDna = dna.copyWith(
          lastSupervisorCheck: currentCount,
          isCalibrated: result.isCalibrated || dna.isCalibrated,
          // Yeni keşfedilen konuları ekle
          discoveredTopics: [...dna.discoveredTopics, ...result.newTopics],
        );
        await _dnaService.saveDNA(updatedDna);
      }
    } catch (e) {
      debugPrint('❌ Periyodik supervisor hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const CampusScreen(),
          _buildEmptyStatsTab(),
          AkademiScreen(key: ValueKey('akademi_$_akademiInitialTab'), initialTabIndex: _akademiInitialTab),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 ? _buildCameraFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeTab() {
    return StreamBuilder<UserDNA?>(
      stream: _dnaService.getDNAStream(),
      builder: (context, snapshot) {
        // 📱 Responsive başlat
        Responsive.init(context);
        
        final dna = snapshot.data;
        final questionCount = dna?.questionCount ?? 0;
        final isCalibrated = dna?.isCalibrated ?? false;
        final uiLanguage = dna?.uiLanguage ?? 'TR';
        
        final topWeakTopics = dna?.weakTopics
            .where((t) => t.wrongCount >= 3)
            .take(3)
            .toList() ?? [];
        final hasWeakTopics = topWeakTopics.isNotEmpty;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshAnnouncements,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // ✨ SMART PADDING: Üst kısımdan ekstra boşluk bırakarak çentik/status bar sıkışmasını önler
              padding: EdgeInsets.only(
                left: Responsive.value(small: 14.0, medium: 18.0, large: 20.0, tablet: 24.0),
                right: Responsive.value(small: 14.0, medium: 18.0, large: 20.0, tablet: 24.0),
                bottom: Responsive.value(small: 14.0, medium: 18.0, large: 20.0, tablet: 24.0),
                top: Responsive.value(small: 20.0, medium: 24.0, large: 28.0, tablet: 32.0), // Artırılmış üst boşluk
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 16),
                  
                  // 🎯 Anket / Yarışmalar Promo Kartı
                  HomePromoCard(
                    onNavigateToTab: (tabIndex, [akademiTab]) {
                      if (akademiTab != null) {
                        setState(() {
                          _akademiInitialTab = akademiTab;
                          _currentIndex = tabIndex;
                        });
                      } else {
                        setState(() => _currentIndex = tabIndex);
                      }
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Duyuru Paneli
                  _buildAnnouncementPanel(),
                  
                  const SizedBox(height: 24),
                  
                  // Ana Aksiyon Kartı
                  _buildMainActionCard(),
                  
                  const SizedBox(height: 24),
                  
                  // 🎯 Akıllı Konu Önerisi - UserDNA'dan
                  if (hasWeakTopics)
                    _buildSmartTopicCard(topWeakTopics),
                  
                  if (hasWeakTopics)
                    const SizedBox(height: 24),
                  
                  // 🏆 Puan Göstergesi
                  _buildPointsIndicator(),
                  
                  const SizedBox(height: 24),
                  
                  // Hızlı İşlemler
                  _buildQuickActions(questionCount),
                  
                  const SizedBox(height: 100), // FAB için boşluk
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // Hizalamayı düzelt
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Düzenlenebilir Kullanıcı Adı
              FutureBuilder<String>(
                future: _dnaService.getDisplayName(),
                builder: (context, snapshot) {
                  final name = snapshot.data ?? 'Öğrenci';
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // İsim - taşmayı önlemek için Flexible
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            // 5 kez hızlıca tıklanınca admin paneli
                            final now = DateTime.now();
                            if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
                              _adminTapCount = 1;
                            } else {
                              _adminTapCount++;
                            }
                            _lastTapTime = now;
                            
                            if (_adminTapCount >= 5) {
                              _adminTapCount = 0;
                              _showAdminPasswordDialog();
                            }
                          },
                          child: Text(
                            'Merhaba, $name! 👋',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              height: 1.2, // Satır yüksekliğini optimize et
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Düzenle ikonu
                      GestureDetector(
                        onTap: () => _showEditNameDialog(name),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Bugün hangi soruyu çözelim?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // 💎 Elmas Bakiyesi
        _buildDiamondBalance(),
      ],
    );
  }

  /// 👤 İsim düzenleme dialog'u
  Future<void> _showEditNameDialog(String currentName) async {
    final controller = TextEditingController(text: currentName);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.person_outline, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('İsmini Değiştir', style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'İsminizi girin',
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            filled: true,
            fillColor: AppTheme.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    
    if (result != null && result.isNotEmpty && result != currentName) {
      await _dnaService.updateDisplayName(result);
      setState(() {}); // UI'ı yenile
    }
  }

  /// 💎 Elmas bakiyesi widget'ı
  Widget _buildDiamondBalance() {
    return StreamBuilder<int>(
      stream: _pointsService.getPointsStream(),
      builder: (context, snapshot) {
        final balance = snapshot.data ?? 0;
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        return GestureDetector(
          onTap: () async {
            // Tıklanınca reklam izle dialog'u aç
            await PointsService.showInsufficientPointsDialog(
              context,
              actionName: 'Elmas Satın Al',
              onPointsAdded: () {}, // StreamBuilder olduğu için artık manuel yenileme gerekmez
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade400,
                  Colors.orange.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.diamond,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                if (isLoading && balance == 0)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  Text(
                    '$balance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.add_circle,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 📢 Bilgilendirme Kartları Carousel - Uygulama Özellikleri
  Widget _buildAnnouncementPanel() {
    if (_featureCards.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.tips_and_updates_outlined, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(
              'SOLICAP Neler Yapabilir?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: Responsive.value(small: 110.0, medium: 125.0, large: 130.0, tablet: 140.0),
          child: PageView.builder(
            itemCount: _featureCards.length,
            controller: _featurePageController,
            onPageChanged: (index) {
              setState(() => _currentFeaturePage = index);
            },
            itemBuilder: (context, index) {
              return _buildFeatureCard(_featureCards[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_featureCards.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentFeaturePage == index ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _currentFeaturePage == index 
                      ? _featureCards[index].color
                      : AppTheme.dividerColor,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeatureCard(FeatureCard feature) {
    final color = feature.color;
    return GestureDetector(
      onTap: () {
        if (feature.id == 'default_library' || feature.title.contains('Kütüphane')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LibraryScreen()),
          );
        } else {
          _showFeatureDetailDialog(feature);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    feature.title,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    feature.subtitle,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Detay için ok ikonu
            Icon(
              Icons.touch_app_rounded,
              color: color.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔍 Feature Card Detay Dialog - Büyütülmüş görünüm
  void _showFeatureDetailDialog(FeatureCard feature) {
    final color = feature.color;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Feature Detail',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Üst gradient banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.2),
                              color.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Kapatma butonu
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Büyük ikon
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                feature.icon,
                                color: color,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Başlık
                            Text(
                              feature.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // İçerik
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          feature.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      // Alt buton
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Anladım',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    Color bgColor;
    Color accentColor;
    IconData icon;
    
    switch (announcement.type) {
      case 'success':
        bgColor = const Color(0xFFECFDF5);
        accentColor = AppTheme.successColor;
        icon = Icons.check_circle_outline;
        break;
      case 'warning':
        bgColor = const Color(0xFFFFFBEB);
        accentColor = AppTheme.warningColor;
        icon = Icons.warning_amber_outlined;
        break;
      case 'promo':
        bgColor = const Color(0xFFF0F9FF);
        accentColor = AppTheme.secondaryColor;
        icon = Icons.local_offer_outlined;
        break;
      default: // info
        bgColor = const Color(0xFFEFF6FF);
        accentColor = AppTheme.primaryColor;
        icon = Icons.info_outline;
    }
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  announcement.title,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            announcement.content,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (announcement.actionText != null) ...[
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  announcement.actionText!,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: accentColor, size: 16),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainActionCard() {
    return LockedHomeActionCard(
      onCaptureQuestion: _captureQuestion,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isProcessing ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎯 Akıllı Konu Önerisi - UserDNA'dan takıldığı konuları gösterir
  Widget _buildSmartTopicCard(List<WeakTopic> weakTopics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: AppTheme.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 Sana Özel Ders Önerisi',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bu konularda takılıyorsun',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: weakTopics.map((topic) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MicroLessonScreen(
                        topic: topic.subTopic,
                        strugglePoints: [topic.subTopic],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        topic.subTopic,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${topic.wrongCount}x',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppTheme.accentColor,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(int questionCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Özellikler',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Grid yapısı - 3 sütun, kompakt kartlar
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.85,
          children: [
            _buildQuickActionCard(
              icon: Icons.history,
              title: context.tr('history_title'),
              subtitle: 'Çözülen sorular',
              color: AppTheme.primaryColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
            _buildQuickActionCard(
              icon: Icons.psychology_outlined,
              title: 'Sokratik Koç',
              subtitle: 'Birlikte çözelim',
              color: AppTheme.primaryColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SocraticTutorScreen()),
              ),
            ),
            _buildLibraryEntranceCard(),
            _buildQuickActionCard(
              icon: Icons.school_outlined,
              title: 'Konu Öğren',
              subtitle: 'Mikro dersler',
              color: AppTheme.primaryColor,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TopicListScreen()),
              ),
            ),
            _buildQuickActionCard(
              icon: Icons.replay,
              title: 'Tekrar Kartları',
              subtitle: 'Hafıza teknikleri',
              color: AppTheme.accentColor,
              onTap: () {
                if (questionCount < 10) {
                  _showLockedFeatureDialog(
                    title: 'Tekrar Kartları Kilitli',
                    message: 'Sana özel tekrar kartları oluşturabilmemiz için en az 10 soru çözmelisin. Şu an $questionCount soru çözdün.',
                    icon: Icons.replay,
                    progress: questionCount / 10,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SpacedRepetitionScreen()),
                  );
                }
              },
            ),
            _buildQuickActionCard(
              icon: Icons.tips_and_updates_outlined,
              title: 'İstek ve Öneri',
              subtitle: 'Bize yazın',
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackScreen()),
              ),
            ),
             _buildQuickActionCard(
              icon: Icons.note_alt_outlined,
              title: context.tr('home_my_notes'),
              subtitle: context.tr('history_notes'),
              color: const Color(0xFF22C55E),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyNotesScreen()),
              ),
            ),
            _buildQuickActionCard(
              icon: Icons.insights,
              title: 'Analiz Laboratuvarı',
              subtitle: 'Performans analizi',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 📚 Kütüphane kartı - giriş kapısı tarzı (beyaz kartlardan farklı)
  Widget _buildLibraryEntranceCard() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LibraryScreen()),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1e3a5f),
                const Color(0xFF2d5a87),
                const Color(0xFF1e3a5f),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xFF4a7ba7).withOpacity(0.5), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Colors.amber, size: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white.withOpacity(0.7), size: 14),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Kütüphane',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '4.–12. sınıf, AI yanıt',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏆 Yarışmalar Tab'ı
  Widget _buildEmptyStatsTab() {
    return const CompetitionsScreen();
  }

  /// ⭐ Parlak Puan Göstergesi
  Widget _buildPointsIndicator() {
    final leaderboardService = LeaderboardService();
    
    return FutureBuilder<List<int>>(
      future: Future.wait([
        leaderboardService.getUserPoints(weekly: false),
        leaderboardService.getUserPoints(weekly: true),
      ]),
      builder: (context, snapshot) {
        final totalPoints = snapshot.data?[0] ?? 0;
        final weeklyPoints = snapshot.data?[1] ?? 0;
        
        return GestureDetector(
          onTap: () => setState(() => _currentIndex = 2), // Yarışmalar tab'ına git
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade600,
                  Colors.orange.shade500,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol: Puan bilgisi
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$totalPoints',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bu hafta +$weeklyPoints',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // Sağ: Yarışmalar butonu
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.emoji_events, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Sıralama',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildCameraFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        shape: BoxShape.circle,
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: FloatingActionButton(
        heroTag: 'home_camera_fab',
        onPressed: _isProcessing ? null : () => _captureQuestion(ImageSource.camera),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.camera_alt, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            setState(() {
              _akademiInitialTab = 0; // Alt bardan gelince Oluştur sekmesi
              _currentIndex = index;
            });
          } else {
            setState(() => _currentIndex = index);
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: context.tr('home_title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_outlined),
            activeIcon: const Icon(Icons.school),
            label: context.tr('campus_title'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.emoji_events_outlined),
            activeIcon: const Icon(Icons.emoji_events),
            label: 'Yarışmalar',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_outlined),
            activeIcon: const Icon(Icons.menu_book),
            label: 'Akademi',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: context.tr('profile_title'),
          ),
        ],
      ),
    );
  }

  Future<void> _captureQuestion(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (image == null) return;

      setState(() => _isProcessing = true);
      
      // 🔄 Animasyonlu yükleme dialog'u göster
      _showSolvingDialog();

      final Uint8List imageBytes = await image.readAsBytes();
      
      // 📊 ANALYTICS: Oturum başlat
      String? sessionId;
      try {
        sessionId = await _sessionTracker.startSession();
        debugPrint('📊 Session started: $sessionId');
      } catch (e) {
        debugPrint('⚠️ Session start hatası: $e');
      }
      
      try {
        final solution = await _geminiService.solveQuestionFromImage(imageBytes);
        
        // Dialog'u kapat
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (solution != null) {
          final userId = _authService.currentUserId;
          String? imageUrl;
          
          if (userId != null) {
            imageUrl = await _questionService.uploadQuestionImage(imageBytes, userId);
            await _questionService.saveQuestion(
              userId: userId,
              solution: solution,
              imageUrl: imageUrl,
            );
          }

          // 📊 ANALYTICS: Oturumu güncelle ve kapat (başarılı)
          try {
            await _sessionTracker.endSession(
              isCorrect: null, // AI çözdü, öğrenci başarısı olarak sayma
              errorCategory: null,
            );
            
            // ✅ DNA kaydı artık question_service.saveQuestion() içinde yapılıyor
            // Çift kayıt önlemek için buradan kaldırıldı
            debugPrint('📊 Soru kaydedildi: ${solution.subject} → ${solution.topic}');
          } catch (e) {
            debugPrint('⚠️ Session kayıt hatası: $e');
          }

          if (mounted) {
            // 🧠 Kalibrasyon: Soru sayısını artır
            await _incrementQuestionCount();
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SolutionScreen(
                  solution: solution,
                  imageBytes: imageBytes,
                ),
              ),
            );
          }
        } else {
          // 📊 Geçmişe 'Başarısız' olarak kaydet (Bulanık fotoğraf vb. durumlar için)
          final userId = _authService.currentUserId;
          if (userId != null) {
            await _questionService.saveFailedAttempt(
              userId: userId,
              imageUrl: null, // Görsel yüklenebilir ama şu an için opsiyonel
            );
          }

          // 📊 ANALYTICS: Oturumu kapat (başarısız)
          try {
            await _sessionTracker.endSession(
              wasAbandoned: true,
              isCorrect: false,
            );
          } catch (e) {
            debugPrint('⚠️ Session end hatası: $e');
          }
          _showError('Soru çözülemedi. Lütfen fotoğrafın net olduğundan emin olup tekrar deneyin.');
        }
      } on InsufficientPointsException {
        // Dialog'u kapat
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        
        // 📊 ANALYTICS: Yetersiz puan - oturumu iptal et
        try {
          await _sessionTracker.endSession(wasAbandoned: true);
        } catch (e) {
          debugPrint('⚠️ Session end hatası: $e');
        }
        
        // 💎 Yetersiz puan - Reklam izle dialog'u göster
        if (mounted) {
          final watched = await PointsService.showInsufficientPointsDialog(
            context,
            actionName: PointsService.getCostDescription('standard_solve'),
            onPointsAdded: () {}, // StreamBuilder sayesinde otomatik güncellenir
          );
          
          if (watched && mounted) {
            // Reklam izlendi, işlemi tekrar dene
            _captureQuestion(source);
          }
        }
        return;
      }
    } catch (e) {
      // Dialog'u kapat
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // 📊 ANALYTICS: Hata durumunda oturumu kapat
      try {
        await _sessionTracker.endSession(wasAbandoned: true);
      } catch (_) {}
      
      debugPrint('Hata: $e');
      _showError('Bir hata oluştu: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  /// 🔄 Animasyonlu çözüm yükleme dialog'u
  void _showSolvingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dönen loading
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.2),
                        AppTheme.accentColor.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Başlık
                const Text(
                  'Soru Çözülüyor...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Yanıp sönen ipucu mesajı
                _AnimatedTipText(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  /// 🧠 Günlük Çalışma Planı Kartı
  Widget _buildDailyPlanCard(int questionCount) {
    final plan = _dailyPlan!;
    
    // 🔒 10 Soru Kilidi - Kalibrasyon bitmeden öneri gösterme
    if (plan.recommendations.isEmpty && !plan.shouldTakeBreak) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_clock,
                size: 32,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bugün Ne Çalışmalısın?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '10 soru çözdükten sonra eksik olduğun konular için anlatım özelliği açılacak.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Şu ana kadar: $questionCount soru',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    
    // Mola önerisi varsa farklı kart göster
    if (plan.shouldTakeBreak) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            const Text('☕', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            const Text(
              'Mola Zamanı!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plan.breakReason ?? 'Biraz dinlen!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bugün Ne Çalışmalısın?',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (plan.optimalStartTime != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⏰ ${plan.optimalStartTime}',
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Motivasyon mesajı
          if (plan.motivationalMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                plan.motivationalMessage!,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          
          // Öneriler
          ...plan.topPriority.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _handleRecommendationTap(rec),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(rec.emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rec.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rec.description,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppTheme.textMuted,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          )),

          // Tahmini süre
          if (plan.estimatedTime.inMinutes > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '⏱️ Tahmini süre: ${plan.estimatedTime.inMinutes} dakika',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Öneriye tıklanınca
  void _handleRecommendationTap(StudyRecommendation rec) {
    switch (rec.type) {
      case RecommendationType.spacedRepetition:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SpacedRepetitionScreen()),
        );
        break;
      case RecommendationType.weakTopic:
      case RecommendationType.newTopic:
        if (rec.topic != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MicroLessonScreen(
                topic: rec.topic!,
              ),
            ),
          );
        }
        break;
      case RecommendationType.reviewMistakes:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case RecommendationType.practiceMore:
        _captureQuestion(ImageSource.camera);
        break;
      case RecommendationType.takeBreak:
        // Mola kartı zaten gösteriliyor
        break;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLockedFeatureDialog({
    required String title,
    required String message,
    required IconData icon,
    required double progress,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: AppTheme.accentColor),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceColor,
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(10),
              minHeight: 12,
            ),
            const SizedBox(height: 12),
            Text(
              'İlerleme: %${(progress * 100).toInt()}',
              style: const TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anladım'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Soru çözme butonuna yönlendirebiliriz veya sadece kapatabiliriz
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Hadi Başla'),
          ),
        ],
      ),
    );
  }

  /// 🔐 Admin Girişi Yönetimi
  void _handleAdminTap() {
    final now = DateTime.now();
    if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _adminTapCount = 1;
    } else {
      _adminTapCount++;
    }
    _lastTapTime = now;

    if (_adminTapCount >= 6) {
      _adminTapCount = 0;
      _showAdminPasswordDialog();
    }
  }

  void _showAdminPasswordDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔐 Admin Girişi'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Admin Şifresi',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await AdminService.verifyAdminCode(controller.text);
              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hatalı şifre!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Giriş'),
          ),
        ],
      ),
    );
  }
}

/// 🔄 Yanıp sönen ipucu mesajı widget'ı
class _AnimatedTipText extends StatefulWidget {
  const _AnimatedTipText();

  @override
  State<_AnimatedTipText> createState() => _AnimatedTipTextState();
}

class _AnimatedTipTextState extends State<_AnimatedTipText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  int _currentTipIndex = 0;

  static const List<String> _tips = [
    '🔍 Sorunuz analiz ediliyor...',
    '🧠 Yapay zeka çözüm üretiyor...',
    '✨ Adım adım açıklama hazırlanıyor...',
    '📚 En iyi çözüm yolu belirleniyor...',
    '💡 İpuçları ve öneriler ekleniyor...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
        });
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        _tips[_currentTipIndex],
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
