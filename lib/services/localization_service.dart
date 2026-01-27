/// SOLICAP - Localization Service
/// Çoklu dil desteği (TR, EN, DE)
/// Telefon diline göre otomatik algılama

import 'package:flutter/material.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  // Desteklenen diller
  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'), // Türkçe (varsayılan)
    Locale('en', 'US'), // İngilizce
    Locale('de', 'DE'), // Almanca
  ];

  // Aktif dil kodu
  String _currentLanguage = 'tr';
  String get currentLanguage => _currentLanguage;

  /// Telefon diline göre dili ayarla
  void setLocale(Locale locale) {
    final langCode = locale.languageCode.toLowerCase();
    if (['tr', 'en', 'de'].contains(langCode)) {
      _currentLanguage = langCode;
    } else {
      _currentLanguage = 'en'; // Bilinmeyen diller için İngilizce
    }
    debugPrint('🌍 Dil ayarlandı: $_currentLanguage');
  }

  /// Çeviri al
  String get(String key) {
    return _translations[_currentLanguage]?[key] ?? 
           _translations['en']?[key] ?? 
           key;
  }

  /// Çeviriler
  static const Map<String, Map<String, String>> _translations = {
    // ═══════════════════════════════════════════════════════════════
    // TÜRKÇE (TR)
    // ═══════════════════════════════════════════════════════════════
    'tr': {
      // Ana Sayfa
      'home_title': 'Ana Sayfa',
      'home_greeting': 'Merhaba',
      'home_solve_question': 'Soru Çöz',
      'home_organize_notes': 'Not Düzenle',
      'home_my_notes': 'Notlarım',
      'home_history': 'Geçmiş',
      'home_campus': 'Kampüs',
      'home_profile': 'Profil',
      'home_daily_goal': 'Günlük Hedef',
      'home_streak': 'Seri',
      'home_points': 'Puan',
      'home_level': 'Seviye',
      
      // Soru Çözüm
      'solve_title': 'Soru Çöz',
      'solve_take_photo': 'Fotoğraf Çek',
      'solve_gallery': 'Galeriden Seç',
      'solve_solving': 'Çözülüyor...',
      'solve_result': 'Çözüm',
      'solve_similar': 'Benzer Soru Üret',
      'solve_save': 'Kaydet',
      'solve_share': 'Paylaş',
      
      // Not Düzenleme
      'note_title': 'Not Düzenle',
      'note_organizing': 'Düzenleniyor...',
      'note_save': 'Notlarıma Kaydet',
      'note_flashcard': 'Flashcard Yap',
      'note_organized': 'AI notu analiz etti ve en verimli hale getirdi.',
      
      // Geçmiş
      'history_title': 'Geçmiş',
      'history_empty': 'Henüz çözülmüş soru yok',
      'history_questions': 'Sorular',
      'history_notes': 'Notlar',
      
      // Profil
      'profile_title': 'Profil',
      'profile_edit': 'Düzenle',
      'profile_stats': 'İstatistikler',
      'profile_achievements': 'Başarılar',
      'profile_settings': 'Ayarlar',
      'profile_logout': 'Çıkış Yap',
      
      // Kampüs
      'campus_title': 'Kampüs',
      'campus_courses': 'Kurslar',
      'campus_practice': 'Pratik',
      'campus_leaderboard': 'Sıralama',
      
      // Genel
      'loading': 'Yükleniyor...',
      'error': 'Hata',
      'success': 'Başarılı',
      'cancel': 'İptal',
      'confirm': 'Onayla',
      'save': 'Kaydet',
      'delete': 'Sil',
      'edit': 'Düzenle',
      'close': 'Kapat',
      'retry': 'Tekrar Dene',
      'yes': 'Evet',
      'no': 'Hayır',
      'ok': 'Tamam',
      'back': 'Geri',
      'next': 'İleri',
      'done': 'Bitti',
      'search': 'Ara',
      'filter': 'Filtre',
      'sort': 'Sırala',
      'all': 'Tümü',
      'today': 'Bugün',
      'yesterday': 'Dün',
      'this_week': 'Bu Hafta',
      'this_month': 'Bu Ay',
      
      // Hatalar
      'error_network': 'İnternet bağlantısı yok',
      'error_unknown': 'Beklenmeyen bir hata oluştu',
      'error_invalid_image': 'Geçersiz görsel',
      'error_no_question': 'Soru tespit edilemedi',
      
      // Puanlar
      'points_earned': 'puan kazandın!',
      'points_spent': 'puan harcandı',
      'points_insufficient': 'Yetersiz puan',
      
      // Onboarding
      'onboarding_welcome': 'Hoş Geldin!',
      'onboarding_skip': 'Atla',
      'onboarding_start': 'Başla',
    },

    // ═══════════════════════════════════════════════════════════════
    // ENGLISH (EN)
    // ═══════════════════════════════════════════════════════════════
    'en': {
      // Home
      'home_title': 'Home',
      'home_greeting': 'Hello',
      'home_solve_question': 'Solve Question',
      'home_organize_notes': 'Organize Notes',
      'home_my_notes': 'My Notes',
      'home_history': 'History',
      'home_campus': 'Campus',
      'home_profile': 'Profile',
      'home_daily_goal': 'Daily Goal',
      'home_streak': 'Streak',
      'home_points': 'Points',
      'home_level': 'Level',
      
      // Question Solving
      'solve_title': 'Solve Question',
      'solve_take_photo': 'Take Photo',
      'solve_gallery': 'Choose from Gallery',
      'solve_solving': 'Solving...',
      'solve_result': 'Solution',
      'solve_similar': 'Generate Similar',
      'solve_save': 'Save',
      'solve_share': 'Share',
      
      // Note Organization
      'note_title': 'Organize Notes',
      'note_organizing': 'Organizing...',
      'note_save': 'Save to My Notes',
      'note_flashcard': 'Create Flashcard',
      'note_organized': 'AI analyzed and optimized your notes.',
      
      // History
      'history_title': 'History',
      'history_empty': 'No solved questions yet',
      'history_questions': 'Questions',
      'history_notes': 'Notes',
      
      // Profile
      'profile_title': 'Profile',
      'profile_edit': 'Edit',
      'profile_stats': 'Statistics',
      'profile_achievements': 'Achievements',
      'profile_settings': 'Settings',
      'profile_logout': 'Log Out',
      
      // Campus
      'campus_title': 'Campus',
      'campus_courses': 'Courses',
      'campus_practice': 'Practice',
      'campus_leaderboard': 'Leaderboard',
      
      // General
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'close': 'Close',
      'retry': 'Retry',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'back': 'Back',
      'next': 'Next',
      'done': 'Done',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'all': 'All',
      'today': 'Today',
      'yesterday': 'Yesterday',
      'this_week': 'This Week',
      'this_month': 'This Month',
      
      // Errors
      'error_network': 'No internet connection',
      'error_unknown': 'An unexpected error occurred',
      'error_invalid_image': 'Invalid image',
      'error_no_question': 'No question detected',
      
      // Points
      'points_earned': 'points earned!',
      'points_spent': 'points spent',
      'points_insufficient': 'Insufficient points',
      
      // Onboarding
      'onboarding_welcome': 'Welcome!',
      'onboarding_skip': 'Skip',
      'onboarding_start': 'Start',
    },

    // ═══════════════════════════════════════════════════════════════
    // DEUTSCH (DE)
    // ═══════════════════════════════════════════════════════════════
    'de': {
      // Startseite
      'home_title': 'Startseite',
      'home_greeting': 'Hallo',
      'home_solve_question': 'Frage lösen',
      'home_organize_notes': 'Notizen ordnen',
      'home_my_notes': 'Meine Notizen',
      'home_history': 'Verlauf',
      'home_campus': 'Campus',
      'home_profile': 'Profil',
      'home_daily_goal': 'Tagesziel',
      'home_streak': 'Serie',
      'home_points': 'Punkte',
      'home_level': 'Stufe',
      
      // Frage lösen
      'solve_title': 'Frage lösen',
      'solve_take_photo': 'Foto aufnehmen',
      'solve_gallery': 'Aus Galerie wählen',
      'solve_solving': 'Lösen...',
      'solve_result': 'Lösung',
      'solve_similar': 'Ähnliche erstellen',
      'solve_save': 'Speichern',
      'solve_share': 'Teilen',
      
      // Notizen
      'note_title': 'Notizen ordnen',
      'note_organizing': 'Ordnen...',
      'note_save': 'In Notizen speichern',
      'note_flashcard': 'Flashcard erstellen',
      'note_organized': 'KI hat Ihre Notizen analysiert und optimiert.',
      
      // Verlauf
      'history_title': 'Verlauf',
      'history_empty': 'Noch keine gelösten Fragen',
      'history_questions': 'Fragen',
      'history_notes': 'Notizen',
      
      // Profil
      'profile_title': 'Profil',
      'profile_edit': 'Bearbeiten',
      'profile_stats': 'Statistiken',
      'profile_achievements': 'Erfolge',
      'profile_settings': 'Einstellungen',
      'profile_logout': 'Abmelden',
      
      // Campus
      'campus_title': 'Campus',
      'campus_courses': 'Kurse',
      'campus_practice': 'Übung',
      'campus_leaderboard': 'Rangliste',
      
      // Allgemein
      'loading': 'Laden...',
      'error': 'Fehler',
      'success': 'Erfolgreich',
      'cancel': 'Abbrechen',
      'confirm': 'Bestätigen',
      'save': 'Speichern',
      'delete': 'Löschen',
      'edit': 'Bearbeiten',
      'close': 'Schließen',
      'retry': 'Wiederholen',
      'yes': 'Ja',
      'no': 'Nein',
      'ok': 'OK',
      'back': 'Zurück',
      'next': 'Weiter',
      'done': 'Fertig',
      'search': 'Suchen',
      'filter': 'Filter',
      'sort': 'Sortieren',
      'all': 'Alle',
      'today': 'Heute',
      'yesterday': 'Gestern',
      'this_week': 'Diese Woche',
      'this_month': 'Dieser Monat',
      
      // Fehler
      'error_network': 'Keine Internetverbindung',
      'error_unknown': 'Ein unerwarteter Fehler ist aufgetreten',
      'error_invalid_image': 'Ungültiges Bild',
      'error_no_question': 'Keine Frage erkannt',
      
      // Punkte
      'points_earned': 'Punkte verdient!',
      'points_spent': 'Punkte ausgegeben',
      'points_insufficient': 'Nicht genügend Punkte',
      
      // Onboarding
      'onboarding_welcome': 'Willkommen!',
      'onboarding_skip': 'Überspringen',
      'onboarding_start': 'Starten',
    },
  };
}

/// Extension for easy access
extension LocalizationExtension on BuildContext {
  String tr(String key) => LocalizationService().get(key);
}
