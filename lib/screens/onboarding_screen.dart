/// SOLICAP - Onboarding Screen
/// İlk giriş - Öğrenci bilgi toplama

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_dna_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final UserDNAService _dnaService = UserDNAService();
  
  int _currentPage = 0;
  final int _totalPages = 5;
  
  // Form verileri
  String _name = '';
  String _gradeLevel = '';
  List<String> _targetExams = [];
  String _learningStyle = '';
  List<String> _weakSubjects = [];
  
  // Seçenekler
  final List<String> _gradeLevels = [
    '4. Sınıf', '5. Sınıf', '6. Sınıf', '7. Sınıf', '8. Sınıf',
    '9. Sınıf', '10. Sınıf', '11. Sınıf', '12. Sınıf', 'Mezun', 'Üniversite'
  ];
  
  final List<String> _exams = [
    'LGS', 'TYT', 'AYT', 'YDS', 'KPSS', 'DGS', 'ALES', 'TUS', 'Yok'
  ];
  
  final List<String> _styles = [
    'Görsel (Şekil/Grafik)', 
    'İşitsel (Anlatım)', 
    'Okuyarak', 
    'Yaparak Öğrenme'
  ];
  
  final List<String> _subjects = [
    'Matematik', 'Fizik', 'Kimya', 'Biyoloji', 
    'Türkçe', 'Tarih', 'Coğrafya', 'Yabancı Dil'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNameStep(),
                  _buildGradeStep(),
                  _buildExamStep(),
                  _buildStyleStep(),
                  _buildWeakSubjectsStep(),
                ],
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adım ${_currentPage + 1}/$_totalPages',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: _skipOnboarding,
                child: const Text('Atla'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPages,
              backgroundColor: AppTheme.dividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: İsim
  Widget _buildNameStep() {
    return _buildStepContainer(
      icon: Icons.person_outline,
      title: 'Merhaba! 👋',
      subtitle: 'Seni tanıyalım',
      child: TextField(
        onChanged: (value) => _name = value,
        style: const TextStyle(fontSize: 18, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Adın nedir?',
          prefixIcon: const Icon(Icons.edit_outlined),
          filled: true,
          fillColor: AppTheme.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.dividerColor),
          ),
        ),
      ),
    );
  }

  // Step 2: Sınıf
  Widget _buildGradeStep() {
    return _buildStepContainer(
      icon: Icons.school_outlined,
      title: 'Hangi sınıftasın?',
      subtitle: 'Seviyene uygun anlatım yapalım',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _gradeLevels.map((grade) {
          final isSelected = _gradeLevel == grade;
          return ChoiceChip(
            label: Text(grade),
            selected: isSelected,
            onSelected: (selected) => setState(() => _gradeLevel = grade),
            selectedColor: AppTheme.primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Step 3: Hedef Sınav
  Widget _buildExamStep() {
    return _buildStepContainer(
      icon: Icons.emoji_events_outlined,
      title: 'Hedef sınavın hangisi?',
      subtitle: 'Birden fazla seçebilirsin',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _exams.map((exam) {
          final isSelected = _targetExams.contains(exam);
          return FilterChip(
            label: Text(exam),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _targetExams.add(exam);
                } else {
                  _targetExams.remove(exam);
                }
              });
            },
            selectedColor: AppTheme.primaryColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
          );
        }).toList(),
      ),
    );
  }

  // Step 4: Öğrenme Stili
  Widget _buildStyleStep() {
    return _buildStepContainer(
      icon: Icons.psychology_outlined,
      title: 'Nasıl öğrenirsin?',
      subtitle: 'Sana en uygun anlatımı seçelim',
      child: Column(
        children: _styles.map((style) {
          final isSelected = _learningStyle == style;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => setState(() => _learningStyle = style),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        style,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Step 5: Zayıf Konular
  Widget _buildWeakSubjectsStep() {
    return _buildStepContainer(
      icon: Icons.trending_up_outlined,
      title: 'Hangi dersler zor geliyor?',
      subtitle: 'Sana özel destek verelim',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _subjects.map((subject) {
          final isSelected = _weakSubjects.contains(subject);
          return FilterChip(
            label: Text(subject),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _weakSubjects.add(subject);
                } else {
                  _weakSubjects.remove(subject);
                }
              });
            },
            selectedColor: AppTheme.warningColor,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textPrimary,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepContainer({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 40, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final isLastPage = _currentPage == _totalPages - 1;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                child: const Text('Geri'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLastPage ? _completeOnboarding : _nextPage,
              child: Text(isLastPage ? 'Başla!' : 'Devam'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    // DNA'yı güncelle
    await _dnaService.updateProfile(
      gradeLevel: _gradeLevel,
      targetExam: _targetExams.join(', '),
      learningStyle: _learningStyle,
    );
    
    // TODO: Zayıf konuları da kaydet
    
    _goToHome();
  }

  void _skipOnboarding() {
    _goToHome();
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}
