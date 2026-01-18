/// SOLICAP - Responsive Utils
/// Ekran boyutuna göre dinamik ölçeklendirme

import 'package:flutter/material.dart';

/// Ekran boyutu sınıflandırması
enum ScreenSize { small, medium, large, tablet }

/// Responsive yardımcı sınıfı
class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;
  static late ScreenSize screenSize;

  /// Context ile başlat (Her build'de çağrılmalı)
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // Referans: iPhone 14 Pro (393 x 852)
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;

    // Ekran boyutu sınıflandırması
    if (screenWidth < 360) {
      screenSize = ScreenSize.small;   // iPhone SE, küçük Android
    } else if (screenWidth < 414) {
      screenSize = ScreenSize.medium;  // iPhone 14, standart Android
    } else if (screenWidth < 600) {
      screenSize = ScreenSize.large;   // iPhone 14 Pro Max, büyük Android
    } else {
      screenSize = ScreenSize.tablet;  // iPad, Android tablet
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // BOYUT METODLARI
  // ═══════════════════════════════════════════════════════════════

  /// Genişlik yüzdesi (0-100)
  static double wp(double percentage) {
    return screenWidth * (percentage / 100);
  }

  /// Yükseklik yüzdesi (0-100)
  static double hp(double percentage) {
    return screenHeight * (percentage / 100);
  }

  /// Ölçeklendirilmiş piksel (sp) - Font için
  static double sp(double size) {
    // Ekran yoğunluğuna göre ölçekle
    final scaleFactor = screenWidth / 393; // iPhone 14 Pro referans
    return size * scaleFactor.clamp(0.8, 1.3); // Min 80%, Max 130%
  }

  /// Dinamik boyut (dp) - Padding, margin, boyutlar için
  static double dp(double size) {
    final scaleFactor = screenWidth / 393;
    return size * scaleFactor.clamp(0.85, 1.4);
  }

  // ═══════════════════════════════════════════════════════════════
  // KOŞULLU DEĞERLER
  // ═══════════════════════════════════════════════════════════════

  /// Ekran boyutuna göre değer seç
  static T value<T>({
    required T small,
    T? medium,
    T? large,
    T? tablet,
  }) {
    switch (screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium ?? small;
      case ScreenSize.large:
        return large ?? medium ?? small;
      case ScreenSize.tablet:
        return tablet ?? large ?? medium ?? small;
    }
  }

  /// Tablet mi kontrolü
  static bool get isTablet => screenSize == ScreenSize.tablet;

  /// Küçük ekran mı kontrolü
  static bool get isSmallScreen => screenSize == ScreenSize.small;

  /// Büyük ekran mı kontrolü
  static bool get isLargeScreen => 
      screenSize == ScreenSize.large || screenSize == ScreenSize.tablet;

  // ═══════════════════════════════════════════════════════════════
  // LAYOUT YARDIMCILARI
  // ═══════════════════════════════════════════════════════════════

  /// Grid için sütun sayısı
  static int get gridColumns => value(small: 2, medium: 2, large: 3, tablet: 4);

  /// Liste öğesi yüksekliği
  static double get listItemHeight => value(small: 70, medium: 80, large: 90, tablet: 100);

  /// Kart yüksekliği
  static double get cardHeight => value(small: 120, medium: 140, large: 160, tablet: 180);

  /// İçerik maksimum genişliği (tablet için ortalama)
  static double get maxContentWidth => isTablet ? 700 : screenWidth;

  /// Yatay padding
  static double get horizontalPadding => value(small: 12, medium: 16, large: 20, tablet: 32);

  /// Dikey padding
  static double get verticalPadding => value(small: 12, medium: 16, large: 20, tablet: 24);

  /// Border radius
  static double get borderRadius => value(small: 12, medium: 16, large: 20, tablet: 24);

  // ═══════════════════════════════════════════════════════════════
  // FONT BOYUTLARI
  // ═══════════════════════════════════════════════════════════════

  /// Başlık 1 (H1)
  static double get h1 => value(small: 22, medium: 24, large: 28, tablet: 32);

  /// Başlık 2 (H2)
  static double get h2 => value(small: 18, medium: 20, large: 22, tablet: 26);

  /// Başlık 3 (H3)
  static double get h3 => value(small: 15, medium: 16, large: 18, tablet: 20);

  /// Normal metin
  static double get body => value(small: 13, medium: 14, large: 15, tablet: 16);

  /// Küçük metin
  static double get caption => value(small: 11, medium: 12, large: 13, tablet: 14);

  /// Düğme metni
  static double get button => value(small: 14, medium: 15, large: 16, tablet: 18);

  // ═══════════════════════════════════════════════════════════════
  // İKON BOYUTLARI
  // ═══════════════════════════════════════════════════════════════

  /// Küçük ikon
  static double get iconSmall => value(small: 16, medium: 18, large: 20, tablet: 24);

  /// Normal ikon
  static double get iconMedium => value(small: 20, medium: 24, large: 28, tablet: 32);

  /// Büyük ikon
  static double get iconLarge => value(small: 28, medium: 32, large: 40, tablet: 48);
}

/// Responsive wrapper widget - İçeriği ortalayarak tablet görünümü sağlar
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? Responsive.maxContentWidth,
        ),
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding,
        ),
        child: child,
      ),
    );
  }
}

/// Responsive Builder widget - Ekran boyutuna göre farklı widget'lar
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return builder(context, Responsive.screenSize);
  }
}
