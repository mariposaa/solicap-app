/// 📚 SINAVA HAZIRLIK MODÜLÜ - Exam Prep Service
/// Solicap Exam Engine v2026 - Gemini 2.5 Flash Optimized
/// 
/// Görev: Tüm ders notlarını analiz edip Study Guide + Flashcards üret

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/exam_prep_model.dart';
import '../models/course_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';

class ExamPrepService {
  static final ExamPrepService _instance = ExamPrepService._internal();
  factory ExamPrepService() => _instance;
  ExamPrepService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  
  GenerativeModel? _examPrepModel;
  bool _isInitialized = false;

  // ═══════════════════════════════════════════════════════════════
  // 📐 SCHEMA TANIMI (Gemini 2.5 Flash için)
  // ═══════════════════════════════════════════════════════════════

  /// Sınav Hazırlık Şeması - JSON çıktı garantisi
  Schema get _examPrepSchema => Schema.object(
    properties: {
      // Part A: Çalışma Rehberi (Study Guide)
      'study_guide': Schema.object(
        properties: {
          'title': Schema.string(
            description: "Motive edici, açıklayıcı başlık (ör: 'Algoritmalar: Final Çalışma Paketi').",
          ),
          'estimated_study_time': Schema.string(
            description: "Materyali okuma ve öğrenme süresi tahmini (ör: '45 dk').",
          ),
          'chapters': Schema.array(
            description: "Dersin kronolojik veya mantıksal bölümleri.",
            items: Schema.object(
              properties: {
                'chapter_title': Schema.string(
                  description: "Bölüm başlığı.",
                ),
                'content_markdown': Schema.string(
                  description: "Markdown formatında detaylı açıklama. Önemli terimler için **kalın**, listeler için madde işareti kullan.",
                ),
                'critical_warnings': Schema.array(
                  description: "Notlardan çıkarılan önemli uyarılar (ör: 'Hoca burası kesin çıkar dedi').",
                  items: Schema.string(),
                ),
              },
              requiredProperties: ['chapter_title', 'content_markdown'],
            ),
          ),
        },
        requiredProperties: ['title', 'chapters', 'estimated_study_time'],
      ),

      // Part B: Ezber Kartları (Flashcards)
      'flashcards': Schema.array(
        description: "Flip-card UI için 15-30 adet Soru-Cevap çifti.",
        items: Schema.object(
          properties: {
            'front': Schema.string(description: "Soru, Terim veya Tarih."),
            'back': Schema.string(description: "Cevap, Tanım veya Olay."),
            'tag': Schema.enumString(
              enumValues: ['Tanım', 'Tarih', 'Formül', 'Kavram'],
              description: "Kartın kategorisi (UI filtreleme için).",
            ),
          },
          requiredProperties: ['front', 'back', 'tag'],
        ),
      ),
    },
    requiredProperties: ['study_guide', 'flashcards'],
  );

  // ═══════════════════════════════════════════════════════════════
  // 🚀 BAŞLATMA
  // ═══════════════════════════════════════════════════════════════

  /// Servisi başlat - Gemini 2.5 Flash modelini hazırla
  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı!');
    }

    // 🧠 Gemini 2.5 Flash - Schema kısıtlı model
    _examPrepModel = GenerativeModel(
      model: 'gemini-2.5-flash', // 2026 Standard
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json', // JSON çıktı zorla
        responseSchema: _examPrepSchema, // Şema kilidi
        temperature: 0.0, // Sıfır yaratıcılık = Sıfır halüsinasyon
      ),
    );

    _isInitialized = true;
    debugPrint('✅ ExamPrepService başlatıldı (Gemini 2.5 Flash)');
  }

  // ═══════════════════════════════════════════════════════════════
  // 📝 MASTER PROMPT (Dinamik dil desteği)
  // ═══════════════════════════════════════════════════════════════

  /// Dinamik prompt - dil parametresi ile
  String _getMasterPrompt(String uiLanguage) {
    final languageName = _getLanguageName(uiLanguage);
    
    return '''
**ROLE & OBJECTIVE:**
You are "Solicap AI," an advanced academic tutor. Your task is to process a semester's worth of raw, unstructured lecture notes and convert them into a structured "Exam Prep Kit" consisting of a Study Guide and Flashcards.

**STRICT GUIDELINES:**

1.  **LANGUAGE (CRITICAL):**
    * FIRST: Auto-detect the language of the RAW NOTES provided below.
    * OUTPUT LANGUAGE: All output content (titles, summaries, questions, answers) MUST be in the **SAME LANGUAGE as the notes**.
    * If notes are mixed-language, use the DOMINANT language.
    * FALLBACK: If detection fails, use **$languageName**.
    * Keep the tone professional, encouraging, and academic.

2.  **DATA INTEGRITY (Anti-Hallucination):**
    * Stick strictly to the information provided in the "RAW NOTES".
    * Do NOT invent dates, formulas, or facts not present in the source text.
    * If the notes are disjointed, bridge the gaps logically using general knowledge ONLY for context, not for specific data points.

3.  **TASK A: STUDY GUIDE GENERATION:**
    * Synthesize the notes into logical chapters.
    * Use **Markdown** formatting extensively to make it readable on mobile screens (Bold key terms, use bullet points).
    * Highlight any text where the user noted importance (e.g., "important", "önemli", "sınavda çıkar", "will be on exam").

4.  **TASK B: FLASHCARD GENERATION:**
    * Extract specific, testable facts.
    * Avoid vague cards. (Bad: "Info about X", Good: "What are the 3 articles of X Law?").
    * Create between 15 and 30 cards based on data density.

**INPUT DATA STARTS BELOW:**
''';
  }

  /// UI dil kodunu tam dil adına çevir
  String _getLanguageName(String code) {
    switch (code.toUpperCase()) {
      case 'TR': return 'TURKISH';
      case 'EN': return 'ENGLISH';
      case 'DE': return 'GERMAN';
      case 'FR': return 'FRENCH';
      case 'ES': return 'SPANISH';
      case 'AR': return 'ARABIC';
      default: return 'TURKISH';
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🎯 ANA FONKSİYON: Sınav Hazırlık Paketi Üret
  // ═══════════════════════════════════════════════════════════════

  /// Notlardan Sınav Hazırlık Paketi üret
  /// 
  /// [notes] - Dersin tüm notları (CourseNote listesi)
  /// [course] - Ders bilgisi
  /// 
  /// Dönüş: ExamPrep objesi veya null (hata durumunda)
  Future<ExamPrep?> generateExamPrep({
    required List<CourseNote> notes,
    required Course course,
  }) async {
    if (notes.isEmpty) {
      debugPrint('⚠️ Sınav hazırlık için not bulunamadı');
      return null;
    }

    final userId = _authService.currentUserId;
    if (userId == null) {
      debugPrint('❌ Kullanıcı girişi gerekli');
      return null;
    }

    try {
      await initialize();

      // 🌐 Kullanıcı dilini al
      final dna = await _dnaService.getDNA();
      final uiLanguage = dna?.uiLanguage ?? 'TR';

      // 📝 Notları birleştir - [Hafta X] formatında
      final concatenatedNotes = _concatenateNotes(notes);
      
      if (concatenatedNotes.length < 100) {
        debugPrint('⚠️ Notlar çok kısa, en az 100 karakter gerekli');
        return null;
      }

      debugPrint('📚 Sınav hazırlık başlatıldı: ${course.name}');
      debugPrint('📊 Toplam ${notes.length} not, ${concatenatedNotes.length} karakter');
      debugPrint('🌐 UI Dili: $uiLanguage');

      // 🧠 Gemini'ye gönder (dinamik dil ile)
      final masterPrompt = _getMasterPrompt(uiLanguage);
      final prompt = Content.text('$masterPrompt\n\nRAW NOTES:\n$concatenatedNotes');
      
      final response = await _examPrepModel!.generateContent([prompt]).timeout(
        const Duration(seconds: 45), // 2.5 Flash çok hızlı
        onTimeout: () {
          throw Exception('Zaman aşımı (45 saniye)');
        },
      );

      final jsonText = response.text;
      if (jsonText == null || jsonText.isEmpty) {
        debugPrint('❌ AI boş yanıt döndü');
        return null;
      }

      debugPrint('✅ AI yanıtı alındı (${jsonText.length} karakter)');

      // 📊 JSON parse et
      final Map<String, dynamic> jsonData;
      try {
        jsonData = jsonDecode(jsonText) as Map<String, dynamic>;
      } catch (e) {
        debugPrint('❌ JSON parse hatası: $e');
        debugPrint('Raw: ${jsonText.substring(0, jsonText.length.clamp(0, 500))}...');
        return null;
      }

      // 🎉 ExamPrep oluştur
      final examPrep = ExamPrep(
        id: '', // Firestore'dan gelecek
        courseId: course.id,
        userId: userId,
        courseName: course.name,
        studyGuide: StudyGuide.fromJson(jsonData['study_guide'] ?? {}),
        flashcards: (jsonData['flashcards'] as List<dynamic>?)
                ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        createdAt: DateTime.now(),
        noteCount: notes.length,
      );

      // 💾 Firestore'a kaydet
      final savedExamPrep = await _saveExamPrep(examPrep);
      
      debugPrint('🎉 Sınav hazırlık paketi oluşturuldu!');
      debugPrint('   📖 ${savedExamPrep?.chapterCount ?? 0} bölüm');
      debugPrint('   🃏 ${savedExamPrep?.flashcardCount ?? 0} flashcard');
      
      return savedExamPrep;

    } catch (e) {
      debugPrint('❌ Sınav hazırlık hatası: $e');
      return null;
    }
  }

  /// Notları birleştir - [Hafta X] formatında
  String _concatenateNotes(List<CourseNote> notes) {
    final buffer = StringBuffer();
    
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      buffer.writeln('[Not ${i + 1}]: ${note.title}');
      buffer.writeln(note.content);
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // 💾 FIRESTORE İŞLEMLERİ
  // ═══════════════════════════════════════════════════════════════

  /// ExamPrep'i Firestore'a kaydet
  Future<ExamPrep?> _saveExamPrep(ExamPrep examPrep) async {
    try {
      final docRef = await _firestore.collection('exam_preps').add(examPrep.toJson());
      
      debugPrint('✅ ExamPrep kaydedildi: ${docRef.id}');
      
      return ExamPrep(
        id: docRef.id,
        courseId: examPrep.courseId,
        userId: examPrep.userId,
        courseName: examPrep.courseName,
        studyGuide: examPrep.studyGuide,
        flashcards: examPrep.flashcards,
        createdAt: examPrep.createdAt,
        noteCount: examPrep.noteCount,
      );
    } catch (e) {
      debugPrint('❌ ExamPrep kayıt hatası: $e');
      return null;
    }
  }

  /// Dersin mevcut ExamPrep'ini getir (varsa)
  Future<ExamPrep?> getExamPrep(String courseId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return null;

    try {
      final snapshot = await _firestore
          .collection('exam_preps')
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return ExamPrep.fromFirestore(snapshot.docs.first);
    } catch (e) {
      debugPrint('❌ ExamPrep getirme hatası: $e');
      return null;
    }
  }

  /// Kullanıcının tüm ExamPrep'lerini getir
  Stream<List<ExamPrep>> getExamPrepsStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('exam_preps')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ExamPrep.fromFirestore(doc)).toList());
  }

  /// ExamPrep sil
  Future<bool> deleteExamPrep(String examPrepId) async {
    try {
      await _firestore.collection('exam_preps').doc(examPrepId).delete();
      debugPrint('✅ ExamPrep silindi: $examPrepId');
      return true;
    } catch (e) {
      debugPrint('❌ ExamPrep silme hatası: $e');
      return false;
    }
  }

  /// Dersin ExamPrep'i var mı kontrol et
  Future<bool> hasExamPrep(String courseId) async {
    final examPrep = await getExamPrep(courseId);
    return examPrep != null;
  }
}
