/// SOLICAP - Profile Screen
/// Kullanıcı profil bilgilerini görüntüleme ve düzenleme
/// Onboarding tarzı form ile güncellenmiş versiyon

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/user_dna_service.dart';
import '../services/auth_service.dart';
import '../services/localization_service.dart';
import '../models/user_dna_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDNAService _dnaService = UserDNAService();
  final AuthService _authService = AuthService();
  
  UserDNA? _dna;
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Form değerleri
  String _gradeLevel = '';
  String _targetExam = '';
  String _learningStyle = '';
  List<String> _interests = [];
  
  // Orijinal değerler (değişiklik kontrolü için)
  String _originalGradeLevel = '';
  String _originalTargetExam = '';
  String _originalLearningStyle = '';
  
  // 🇹🇷 Türkiye Sınavları + 🌍 Genel Seviyeler
  final Map<String, List<String>> _examCategories = {
    '🇹🇷 Türkiye Sınavları': [
      'LGS', 
      'YKS TYT', 
      'YKS AYT (Sayısal)', 
      'YKS AYT (Eşit Ağırlık)', 
      'YKS AYT (Sözel)',
      'KPSS',
      'ALES',
      'DGS',
      'TUS',
      'DUS',
    ],
    '🌍 Genel Seviyeler': [
      'İlkokul Düzeyi',
      'Ortaokul Düzeyi',
      'Lise Düzeyi',
      'Üniversite Düzeyi',
      'Lisansüstü Düzeyi',
    ],
  };
  
  final List<String> _gradeLevels = [
    '4. Sınıf', '5. Sınıf', '6. Sınıf', '7. Sınıf', '8. Sınıf',
    '9. Sınıf', '10. Sınıf', '11. Sınıf', '12. Sınıf', 
    'Mezun', 'Üniversite', 'Lisansüstü'
  ];
  
  final List<String> _styles = [
    'Görsel (Şekil/Grafik)', 
    'İşitsel (Anlatım)', 
    'Okuyarak', 
    'Yaparak Öğrenme'
  ];
  
  final List<String> _interestOptions = [
    'Spor', 'Müzik', 'Oyunlar', 'Teknoloji', 
    'Sinema', 'Kitap', 'Doğa', 'Yemek'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final dna = await _dnaService.getDNA();
      if (mounted) {
        setState(() {
          _dna = dna;
          _gradeLevel = dna?.gradeLevel ?? '';
          _targetExam = dna?.targetExam ?? '';
          _learningStyle = dna?.learningStyle ?? '';
          // Orijinal değerleri sakla
          _originalGradeLevel = _gradeLevel;
          _originalTargetExam = _targetExam;
          _originalLearningStyle = _learningStyle;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  /// Değişiklik var mı kontrol et
  bool get _hasChanges {
    return _gradeLevel != _originalGradeLevel ||
           _targetExam != _originalTargetExam ||
           _learningStyle != _originalLearningStyle;
  }
  
  /// Form geçerli mi
  bool get _isFormValid => _gradeLevel.isNotEmpty && _targetExam.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),
                  
                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600), // Tablet için
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profil Kartı
                              _buildProfileCard(),
                          
                          const SizedBox(height: 24),
                          
                          // İstatistikler
                          _buildStatsCard(),
                          
                          const SizedBox(height: 16),
                          
                          // 💡 Bilgilendirme Notu
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 18),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    '💡 Bilgilerinizi değiştirdiğinizde kaydet butonu görünür.',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // 📚 Sınıf Seviyesi (Zorunlu)
                          _buildSectionTitle('📚 Sınıf Seviyesi', isRequired: true),
                          _buildGradeSelector(),
                          
                          const SizedBox(height: 24),
                          
                          // 🎯 Hedef Sınav (Zorunlu)
                          _buildSectionTitle('🎯 Hedef Sınav', isRequired: true),
                          _buildExamSelector(),
                          
                          const SizedBox(height: 24),
                          
                          // 🧠 Öğrenme Stili (İsteğe Bağlı)
                          _buildSectionTitle('🧠 Öğrenme Stili', isRequired: false),
                          _buildStyleSelector(),
                          
                          const SizedBox(height: 24),
                          
                          // 💡 İlgi Alanları (İsteğe Bağlı)
                          _buildSectionTitle('💡 İlgi Alanları', isRequired: false, hint: 'Örnek ve benzetmeler için'),
                          _buildInterestsSelector(),
                          
                              const SizedBox(height: 100), // Bottom padding for button
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Kaydet Butonu (sadece değişiklik varsa göster)
                  if (_hasChanges)
                    _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profilim',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Bilgilerini güncelleyebilirsin',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final user = _authService.currentUser;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              (_dna?.userName ?? 'Ö').substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dna?.userName ?? 'Öğrenci',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_gradeLevel.isNotEmpty ? _gradeLevel : "Belirlenmedi"} • ${_targetExam.isNotEmpty ? _targetExam : "Hedef yok"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 İstatistikler',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem('Çözülen Soru', '${_dna?.totalQuestionsSolved ?? 0}', Icons.check_circle),
              _buildStatItem('Doğru', '${_dna?.totalCorrect ?? 0}', Icons.thumb_up, color: AppTheme.successColor),
              _buildStatItem('Yanlış', '${_dna?.totalWrong ?? 0}', Icons.thumb_down, color: AppTheme.errorColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color ?? AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required bool isRequired, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold),
            ),
          if (hint != null) ...[
            const SizedBox(width: 8),
            Text(
              '($hint)',
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGradeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _gradeLevels.map((grade) {
        final isSelected = _gradeLevel == grade;
        return ChoiceChip(
          label: Text(grade),
          selected: isSelected,
          onSelected: (selected) => setState(() => _gradeLevel = grade),
          selectedColor: AppTheme.primaryColor,
          backgroundColor: AppTheme.surfaceColor,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExamSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _examCategories.entries.map((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                category.key,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: category.value.map((exam) {
                final isSelected = _targetExam == exam;
                return ChoiceChip(
                  label: Text(exam),
                  selected: isSelected,
                  onSelected: (selected) => setState(() => _targetExam = exam),
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.surfaceColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStyleSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _styles.map((style) {
        final isSelected = _learningStyle == style;
        return ChoiceChip(
          label: Text(style),
          selected: isSelected,
          onSelected: (selected) => setState(() => _learningStyle = selected ? style : ''),
          selectedColor: AppTheme.secondaryColor,
          backgroundColor: AppTheme.surfaceColor,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppTheme.secondaryColor : AppTheme.dividerColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInterestsSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _interestOptions.map((interest) {
        final isSelected = _interests.contains(interest);
        return FilterChip(
          label: Text(interest),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _interests.add(interest);
              } else {
                _interests.remove(interest);
              }
            });
          },
          selectedColor: AppTheme.accentColor,
          backgroundColor: AppTheme.surfaceColor,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppTheme.accentColor : AppTheme.dividerColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isFormValid)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '⚠️ Sınıf ve Hedef Sınav seçimi zorunludur',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 13,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isFormValid && !_isSaving ? _saveProfile : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.dividerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_outlined, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Değişiklikleri Kaydet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    
    try {
      // DNA'yı güncelle
      await _dnaService.updateProfile(
        gradeLevel: _gradeLevel,
        targetExam: _targetExam,
        learningStyle: _learningStyle.isNotEmpty ? _learningStyle : null,
      );
      
      // Orijinal değerleri güncelle (değişiklik yok gibi göstermek için)
      _originalGradeLevel = _gradeLevel;
      _originalTargetExam = _targetExam;
      _originalLearningStyle = _learningStyle;
      
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('✅ Profil güncellendi!'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
