/// SOLICAP - App Theme
/// Profesyonel ve modern açık tema

import 'package:flutter/material.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════════
  // ANA RENKLER - Profesyonel ve Aydınlık
  // ═══════════════════════════════════════════════════════════════
  static const Color primaryColor = Color(0xFF2563EB);     // Mavi (Güvenilir)
  static const Color secondaryColor = Color(0xFF0EA5E9);   // Açık Mavi
  static const Color accentColor = Color(0xFF10B981);      // Yeşil (Başarı)
  
  // ═══════════════════════════════════════════════════════════════
  // ARKA PLAN RENKLERİ - Temiz ve Açık
  // ═══════════════════════════════════════════════════════════════
  static const Color backgroundColor = Color(0xFFF8FAFC);  // Açık gri-beyaz
  static const Color surfaceColor = Color(0xFFFFFFFF);     // Saf beyaz
  static const Color cardColor = Color(0xFFFFFFFF);        // Beyaz kart
  static const Color dividerColor = Color(0xFFE2E8F0);     // Çizgi rengi
  
  // ═══════════════════════════════════════════════════════════════
  // METİN RENKLERİ
  // ═══════════════════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFF1E293B);      // Koyu lacivert
  static const Color textSecondary = Color(0xFF64748B);    // Gri
  static const Color textMuted = Color(0xFF94A3B8);        // Açık gri
  
  // ═══════════════════════════════════════════════════════════════
  // DURUM RENKLERİ
  // ═══════════════════════════════════════════════════════════════
  static const Color successColor = Color(0xFF10B981);     // Yeşil
  static const Color warningColor = Color(0xFFF59E0B);     // Turuncu
  static const Color errorColor = Color(0xFFEF4444);       // Kırmızı
  static const Color infoColor = Color(0xFF3B82F6);        // Mavi
  
  // ═══════════════════════════════════════════════════════════════
  // KONU RENKLERİ
  // ═══════════════════════════════════════════════════════════════
  static const Map<String, Color> subjectColors = {
    'Matematik': Color(0xFF3B82F6),   // Mavi
    'Fizik': Color(0xFF8B5CF6),       // Mor
    'Kimya': Color(0xFFEC4899),       // Pembe
    'Biyoloji': Color(0xFF10B981),    // Yeşil
    'Türkçe': Color(0xFFF59E0B),      // Turuncu
    'Tarih': Color(0xFF6366F1),       // İndigo
    'Coğrafya': Color(0xFF14B8A6),    // Teal
    'Genel': Color(0xFF64748B),       // Gri
  };

  // ═══════════════════════════════════════════════════════════════
  // TEMA
  // ═══════════════════════════════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      
      // AppBar Teması
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      
      // Card Teması
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 1),
        ),
      ),
      
      // Elevated Button Teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      
      // Outlined Button Teması
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Input Teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: textMuted),
      ),
      
      // Text Teması
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: textMuted,
          fontSize: 12,
        ),
      ),
      
      // Bottom Navigation Teması
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Divider Teması
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
      ),
    );
  }
  
  // ═══════════════════════════════════════════════════════════════
  // GRADIENT'LER
  // ═══════════════════════════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════════════════════════
  // GÖLGELER
  // ═══════════════════════════════════════════════════════════════
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: primaryColor.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];
}
