/// SOLICAP - Gemini Service
/// AI ile soru çözme ve benzer soru üretme - Master Solver Entegrasyonu

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:firebase_ai/firebase_ai.dart' as fb; // Gemini 2.5 Flash için (prefix ile)
import '../models/question_model.dart';
import 'user_dna_service.dart';
import 'points_service.dart';
import 'prompt_registry_service.dart';
import 'smart_memory_service.dart';
import 'answer_validation_service.dart';
import 'embedding_service.dart';

/// 💎 Yetersiz puan hatası - UI tarafından yakalanıp dialog gösterilecek
class InsufficientPointsException implements Exception {
  final String action;
  final int requiredPoints;
  final int currentPoints;
  
  InsufficientPointsException({
    required this.action,
    required this.requiredPoints,
    required this.currentPoints,
  });
  
  @override
  String toString() => 'Yetersiz puan: $action için $requiredPoints elmas gerekli, mevcut: $currentPoints';
}

class GeminiService {
  late GenerativeModel _model; // Tier 2: Gemini 2.5 Flash (Orta siklet)
  late GenerativeModel _proModel; // 💎 Gemini 2.5 Pro (Ağır siklet - Tier 1)
  late GenerativeModel _flashModel; // ⚡ Gemini 2.5 Flash-Lite (Ekonomik - Tier 3)
  late GenerativeModel _visionModel; // 🖼️ Flash Vision (basit görsel sorular)
  late GenerativeModel _proVisionModel; // 🧠 Pro Vision (karmaşık matematik/grafik)
  late GenerativeModel _textVisionModel; // 📝 Text Vision (not düzenleme - JSON yok)
  late GenerativeModel _libraryModel;    // 📚 Kütüphane - düz metin, JSON yok
  String? _apiKey; // not düzenleme için şema modelinde kullan
  bool _isInitialized = false;
  bool _useFirebaseAI = false; // ⚡ Firebase AI Logic aktif mi?
  
  final UserDNAService _dnaService = UserDNAService();
  final PointsService _pointsService = PointsService();
  final PromptRegistryService _promptRegistry = PromptRegistryService();
  final SmartMemoryService _memoryService = SmartMemoryService();
  final AnswerValidationService _validationService = AnswerValidationService();

  // 🔓 Erişimciler
  PromptRegistryService get promptRegistry => _promptRegistry;

  String? getPrompt(String key, {Map<String, String>? variables}) {
    return _promptRegistry.getPrompt(key, variables: variables);
  }

  // ═══════════════════════════════════════════════════════════════
  // 🧠 MASTER AI SEGMENT MOTORU (Token Tasarrufu & Derin DNA)
  // ═══════════════════════════════════════════════════════════════

  /// 🎯 PROMPT ENGINEERING: Öğrencinin "Bilişsel Haritası"nı (Global Context) oluşturur
  /// [filter] ile hangi alanların dahil edileceği seçilebilir (örn: 'solver', 'analyzer', 'note')
  /// [currentTopic] mevcut konuyla ilgili DNA detaylarını ekler
  Future<String> _getGlobalCognitiveContext({String? filter, String? currentTopic}) async {
    final dna = await _dnaService.getDNA();
    if (dna == null) return '# CONTEXT: Yeni Öğrenci (İlk deneyim, teşvik edici ol)';

    final buffer = StringBuffer();
    
    // 🎓 TEMEL PROFİL
    buffer.writeln('# 🎓 ÖĞRENCİ PROFİLİ:');
    buffer.writeln('- Seviye: ${dna.gradeLevel ?? 'Belirlenmedi'} | Hedef: ${dna.targetExam ?? 'Genel Gelişim'}');
    buffer.writeln('- Öğrenme Stili: ${dna.learningStyle ?? 'Görsel'} | Motivasyon: ${dna.motivationLevel ?? 'Orta'}');
    
    // 📊 PERFORMANS METRİKLERİ
    if (filter == 'analyzer' || filter == 'solver' || filter == null) {
      buffer.writeln('\n# 📊 PERFORMANS:');
      buffer.writeln('- Genel Başarı: %${(dna.overallSuccessRate * 100).toInt()} (${dna.totalQuestionsSolved} soru)');
      
      // Güçlü ve zayıf alanlar
      if (dna.strongTopics.isNotEmpty) {
        buffer.writeln('- ✅ Güçlü: ${dna.strongTopics.take(3).join(', ')}');
      }
      if (dna.weakTopics.isNotEmpty) {
        final weakList = dna.weakTopics.take(3).map((w) => '${w.subTopic} (%${(w.successRate * 100).toInt()})').join(', ');
        buffer.writeln('- ⚠️ Zayıf: $weakList');
      }
    }
    
    // 🎯 MEVCUT KONU ANALİZİ
    if (currentTopic != null && dna.subTopicPerformance.containsKey(currentTopic)) {
      final topicPerf = dna.subTopicPerformance[currentTopic]!;
      buffer.writeln('\n# 🎯 BU KONU İÇİN DNA:');
      buffer.writeln('- Ustalık: ${topicPerf.proficiencyLevel} (%${(topicPerf.weightedProficiency * 100).toInt()})');
      buffer.writeln('- Geçmiş: ${topicPerf.correct}/${topicPerf.totalQuestions} doğru');
      if (topicPerf.consecutiveCorrect >= 3) {
        buffer.writeln('- 🔥 Seri: ${topicPerf.consecutiveCorrect} ardışık doğru');
      }
    }
    
    // 🚨 HATA DESENLERİ (Çözücü için kritik)
    if (filter == 'solver' || filter == null) {
      if (dna.errorPatterns.isNotEmpty) {
        final patterns = dna.errorPatterns.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topErrors = patterns.take(2).map((e) => '${e.key}(${e.value}x)').join(', ');
        buffer.writeln('\n# 🚨 SIKÇA YAPILAN HATALAR:');
        buffer.writeln('- $topErrors');
        buffer.writeln('- 💡 İPUCU: Bu hata örüntülerine dikkat et, uyar.');
      }
    }
    
    // 🎭 PERSONA TALİMATLARI
    buffer.writeln('\n# 🎭 İLETİŞİM TARZI:');
    final successRate = dna.overallSuccessRate;
    if (successRate < 0.4) {
      buffer.writeln('- Öğrenci zorlanıyor → TEŞVİK EDİCİ ve basit anlatım kullan');
      buffer.writeln('- Küçük başarıları öv, adım adım ilerle');
    } else if (successRate < 0.7) {
      buffer.writeln('- Öğrenci gelişiyor → DENGELİ anlatım, püf noktaları paylaş');
      buffer.writeln('- Hataları nazikçe düzelt, alternatif yollar göster');
    } else {
      buffer.writeln('- Öğrenci başarılı → MEYDAN OKUYAN anlatım, ileri teknikler');
      buffer.writeln('- Kısa ve öz cevaplar ver, zamanı verimli kullan');
    }

    return buffer.toString();
  }

  /// Göreve özel persona segmentini döner (Registry üzerinden)
  Future<String> _getPersonaSegment(String level, {bool isSocratic = false}) async {
    final personaMode = isSocratic ? 'Sokratik Mentor' : 'Sınav Uzmanı';
    final personaDescription = isSocratic 
        ? 'Meraklı Mentör: Öğrenciyi sorgulatan, rehberlik eden, cevabı direkt vermeyen ton.'
        : 'Sınav Uzmanı: Net, taktiksel, sınav odaklı ve sonuç yönelimli ton.';
    
    return _promptRegistry.getPrompt('persona_registry', variables: {
      'userLevel': level,
      'personaMode': personaMode,
      'personaDescription': personaDescription,
    });
  }

  /// Öz-Denetim (Self-Correction) protokolü - Her promptun sonuna eklenir
  String _getSelfCorrectionAudit() {
    return '''
# ÖZ-DENETİM (SELF-CORRECTION) PROTOKOLÜ:
1. "Önce Düşün" (Chain of Thought): Yanıt vermeden önce soruyu analiz et.
2. "Hata Kontrolü": İşlem veya mantık hatası yapıp yapmadığını 2 kez sına.
3. "Müfredat Uyumu": Bilginin güncelliğinden emin değilsen belirt.
''';
  }

  // ═══════════════════════════════════════════════════════════════
  // 🌐 DİL ALGILAMA VE YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Soru dilini algıla, sonra DNA tercihlerine bak
  Future<String> _getUserLanguage({String? questionText}) async {
    // 1. ÖNCE: Soru metni varsa dil algıla (İngilizce soru → İngilizce cevap)
    if (questionText != null && questionText.isNotEmpty) {
      final detectedLang = _detectQuestionLanguage(questionText);
      // İngilizce veya Almanca soru tespit edilirse, o dilde cevap ver
      if (detectedLang != 'TR') {
        debugPrint('🌐 Soru dili algılandı: $detectedLang');
        return detectedLang;
      }
    }
    
    // 2. Soru Türkçe veya algılanamadıysa → DNA tercihlerini kontrol et
    final dna = await _dnaService.getDNA();
    
    // 3. DNA'da explanationLanguage tanımlıysa onu kullan
    if (dna?.explanationLanguage != null && dna!.explanationLanguage!.isNotEmpty) {
      return dna.explanationLanguage!;
    }
    
    // 4. DNA'da uiLanguage tanımlıysa onu kullan
    if (dna?.uiLanguage != null && dna!.uiLanguage!.isNotEmpty) {
      return dna.uiLanguage!;
    }
    
    // 5. Varsayılan: Türkçe
    return 'TR';
  }

  /// Soru metninden dil algıla
  String _detectQuestionLanguage(String text) {
    // Türkçe karakterler varsa Türkçe
    if (text.contains(RegExp(r'[çğıöşüÇĞİÖŞÜ]'))) return 'TR';
    
    // İngilizce anahtar kelimeler
    final englishKeywords = RegExp(
      r'\b(find|calculate|solve|what|which|if|then|given|when|where|how|prove|determine|express|simplify)\b',
      caseSensitive: false,
    );
    if (englishKeywords.hasMatch(text)) return 'EN';
    
    // Almanca anahtar kelimeler
    final germanKeywords = RegExp(
      r'\b(finde|berechne|löse|was|welche|wenn|dann|gegeben|wie|beweise|vereinfache)\b',
      caseSensitive: false,
    );
    if (germanKeywords.hasMatch(text)) return 'DE';
    
    // Varsayılan
    return 'TR';
  }

  /// Dil kodundan tam dil adını getir
  String _getLanguageName(String code) {
    switch (code.toUpperCase()) {
      case 'EN': return 'English';
      case 'DE': return 'German';
      case 'FR': return 'French';
      case 'TR':
      default: return 'Turkish';
    }
  }

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı!');
    }
    _apiKey = apiKey;

    await _promptRegistry.initialize();

    // 🌍 STRICT VISUAL MATH SOLVER - No fluff, just math (Gemini optimized)
    final systemInstruction = Content.system(
      'You are a strict Visual Math Solver. '
      'RULE 1: NO FLUFF. Do not talk about DNA, cognitive gaps, or marketing. Just solve the math. '
      'RULE 2: PIXEL COUNTING. Look at the grid. Identify exactly TWO points where the line crosses grid intersections PERFECTLY. '
      'RULE 3: CALCULATE SLOPE. Use the two points to calculate the slope (m). NEVER GUESS THE SLOPE (e.g. do not assume it is 1 or 2). '
      'RULE 4: OUTPUT JSON. Return the result in JSON format showing the coordinates you found.'
    );

    // 💎 Master Model (Tier 2 - Gemini 2.5 Flash)
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.0, 
        maxOutputTokens: 1536, // ⚡ Optimize: orta uzunluk çözüm
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '```', '---END---'],
      ),
    );

    // ⚡ Tier 3: Gemini 2.5 Flash-Lite (Ekonomik - Sözel dersler için)
    _flashModel = GenerativeModel(
      model: 'gemini-2.5-flash-lite', // En ucuz model - sözel dersler
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 1024, // ⚡ Optimize: kısa çözüm yeterli
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '```', '---END---'],
      ),
    );

    // 💎 Tier 1: Gemini 2.5 Pro (Ağır siklet - Türev/İntegral için)
    _proModel = GenerativeModel(
      model: 'gemini-2.5-pro', // En güçlü model - karmaşık matematik
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.0,
        maxOutputTokens: 2048, // ⚡ Optimize: detaylı ama öz
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '---END---'],
      ),
    );

    // 🖼️ Vision Model (Simple image tasks - Flash)
    _visionModel = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 1536, // ⚡ Optimize: orta uzunluk
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '```', '---END---'],
      ),
    );

    // 🧠 Pro Vision Model (Complex math/graph - Gemini 2.5 Pro)
    _proVisionModel = GenerativeModel(
      model: 'gemini-2.5-pro', // Karmaşık görsel sorular için Pro
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.0,
        maxOutputTokens: 2048, // ⚡ Optimize: detaylı ama öz
        topK: 1,
        responseMimeType: 'application/json',
      ),
    );

    // 📝 Text Vision Model (Not düzenleme - JSON yok, düz metin çıktı)
    _textVisionModel = GenerativeModel(
      model: 'gemini-2.5-flash', // Hızlı görsel işleme
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1, // Düşük - sadık kal
        maxOutputTokens: 4096, // 🔥 Uzun notlar için artırıldı
        // responseMimeType YOK - düz metin döner
        // stopSequences YOK - erken kesmesin
      ),
    );

    // 📚 Kütüphane Model (4.–12. sınıf Q&A - sadece düz metin, JSON yok)
    _libraryModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3,
        maxOutputTokens: 1000,
        // responseMimeType YOK - "Here is the JSON requested" önlenir
      ),
    );

    // ⚡ Gemini 2.5 Flash (Firebase AI ile - Chain of Thought için optimize)
    try {
      // Firebase AI Logic'i test et - başarılıysa flag'i true yap
      fb.FirebaseAI.googleAI(); // Sadece erişim kontrolü
      _useFirebaseAI = true;
      debugPrint('⚡ Firebase AI Logic aktif - Gemini 2.5 Flash kullanılabilir');
    } catch (e) {
      _useFirebaseAI = false;
      debugPrint('⚠️ Firebase AI Logic aktif değil: $e');
    }

    _isInitialized = true;
    debugPrint('✅ Gemini servisi başlatıldı');
  }

/*
 # SOLICAP Master AI & Study Recommendations

## 🎯 Current Focus: Master AI Engine Implementation
- [x] Implement Segmented Prompting for Token Efficiency
- [x] Integrate Deep UserDNA into all AI Modules
- [x] Implement Self-Correction (Öz-Denetim) Protocols
- [x] Implement "Master Solver" Bulletproof Parser 3.0
- [x] Fix "No Material Widget" UI Crash in History/Progress Screens
- [x] Upgrade AI to "Deep Logic" 3.0 (Detailed Solutions)
- [ ] Final Verification and User Walkthrough

## 🚀 Secondary Phase: Smart Note Organizer
- [/] Side-by-side Button Layout on Home Screen
- [x] Organize Note Logic in GeminiService
- [ ] Note Storage & Spaced Repetition Integration
*/

  /// 💎 İşlem öncesi puan kontrolü - Yetersizse exception fırlat
  Future<void> _checkPoints(String action) async {
    final cost = PointsService.costs[action] ?? 0;
    if (cost == 0) return; // Ücretsiz işlem
    
    final currentPoints = await _pointsService.getPoints();
    
    if (currentPoints < cost) {
      throw InsufficientPointsException(
        action: action,
        requiredPoints: cost,
        currentPoints: currentPoints,
      );
    }
  }

  /// 🎨 MASTER SOLVER PROMPT - Dinamik verilerle doldur
  /// ÖNEMLİ: Kullanıcı profil seviyesi ile sorunun seviyesi FARKLI kavramlardır!
  /// - Kullanıcı Profili: Mühendislik 2. sınıf öğrencisi olabilir
  /// - Soru Seviyesi: İlkokul 4. sınıf matematik sorusu olabilir
  /// AI, SORUNUN SEVİYESİNE göre anlatım yapmalı, kullanıcı profiline göre değil!
  Future<String> _buildMasterSolverPrompt({String uiLanguage = 'TR'}) async {
    // Fallback to legacy prompt for backward compatibility
    return _promptRegistry.getPrompt('master_solver_base');
  }

  /// 🎯 AKILLI PROMPT YÖNLENDİRİCİ - Konu ve sınava göre doğru prompt seç
  /// Bu fonksiyon mevcut akışı BOZMAZ, sadece daha akıllı prompt seçer
  Future<String> _buildSmartSolverPrompt({
    required String detectedSubject,
    String? questionText,
    String uiLanguage = 'TR',
  }) async {
    // 1. Kullanıcının hedef sınavını al
    final dna = await _dnaService.getDNA();
    final targetExam = dna?.targetExam?.toUpperCase() ?? 'YKS';
    
    // 2. Domain'i belirle (STEM, Verbal, Medical, KPSS, Language)
    final domain = _mapSubjectToDomain(detectedSubject, targetExam);
    
    // 3. Domain'e göre prompt seç
    final promptKey = _getPromptKeyForDomain(domain, targetExam);
    
    debugPrint('🎯 Prompt Router: Subject=$detectedSubject, Exam=$targetExam, Domain=$domain, Prompt=$promptKey');
    
    // 4. Prompt'u al (fallback zinciri ile)
    String? prompt = _promptRegistry.getPrompt(promptKey);
    
    if (prompt.isEmpty) {
      prompt = _promptRegistry.getPrompt('universal_solver');
    }
    
    if (prompt.isEmpty) {
      prompt = _promptRegistry.getPrompt('master_solver_base');
    }
    
    return prompt;
  }

  /// 🗂️ Konu → Domain eşlemesi
  String _mapSubjectToDomain(String subject, String targetExam) {
    // Önce sınav bazlı özel durumları kontrol et
    if (targetExam.contains('TUS') || targetExam.contains('DUS')) {
      // Tıp/Diş sınavları için her şey medical domain
      return 'MEDICAL';
    }
    
    if (targetExam.contains('KPSS')) {
      // KPSS'ye özgü konular
      if (_isKPSSSpecificSubject(subject)) {
        return 'KPSS';
      }
    }
    
    if (targetExam.contains('YDS') || targetExam.contains('YÖKDİL')) {
      return 'LANGUAGE';
    }
    
    // Genel konu bazlı eşleme
    final normalizedSubject = subject.toLowerCase();
    
    // STEM Domain
    if (['matematik', 'mathematics', 'fizik', 'physics', 
         'kimya', 'chemistry', 'biyoloji', 'biology',
         'fen', 'science'].any((s) => normalizedSubject.contains(s))) {
      return 'STEM';
    }
    
    // Verbal/Social Domain
    if (['türkçe', 'turkish', 'edebiyat', 'literature',
         'tarih', 'history', 'coğrafya', 'geography',
         'felsefe', 'philosophy', 'din', 'religion',
         'sosyal', 'social'].any((s) => normalizedSubject.contains(s))) {
      return 'VERBAL';
    }
    
    // Medical Domain (TUS dışında da tıp sorusu gelebilir)
    if (['anatomi', 'anatomy', 'fizyoloji', 'physiology',
         'patoloji', 'pathology', 'farmakoloji', 'pharmacology',
         'mikrobiyoloji', 'microbiology', 'biyokimya', 'biochemistry',
         'histoloji', 'histology', 'medicine', 'tıp'].any((s) => normalizedSubject.contains(s))) {
      return 'MEDICAL';
    }
    
    // English/Language Domain
    if (['ingilizce', 'english', 'almanca', 'german',
         'fransızca', 'french', 'yabancı dil'].any((s) => normalizedSubject.contains(s))) {
      return 'LANGUAGE';
    }
    
    // Law Domain  
    if (['hukuk', 'law', 'anayasa', 'constitution',
         'ceza', 'criminal', 'medeni', 'civil'].any((s) => normalizedSubject.contains(s))) {
      return 'KPSS'; // Hukuk soruları KPSS solver ile çözülür
    }
    
    // Varsayılan: STEM (matematik ağırlıklı eski davranış)
    return 'STEM';
  }

  /// KPSS'ye özgü konu mu?
  bool _isKPSSSpecificSubject(String subject) {
    final lower = subject.toLowerCase();
    return ['anayasa', 'vatandaşlık', 'kamu', 'idare',
            'güncel', 'current', 'constitution', 'citizenship'].any((s) => lower.contains(s));
  }

  /// 🔑 Domain → Prompt Key eşlemesi
  String _getPromptKeyForDomain(String domain, String targetExam) {
    switch (domain) {
      case 'STEM':
        return 'stem_solver';
      case 'VERBAL':
        return 'verbal_solver';
      case 'MEDICAL':
        return 'medicine_solver';
      case 'KPSS':
        return 'kpss_solver';
      case 'LANGUAGE':
        return 'language_solver';
      default:
        return 'universal_solver';
    }
  }

  /// 🧠 GENEL SORU ÇÖZÜCÜ - Görsel veya Metin (Master Solver)
  /// [useDeepAnalysis] true ise zorluğa bakılmaksızın Pro model kullanılır
  Future<QuestionSolution?> solveQuestion({
    Uint8List? imageBytes,
    String? manuallyEnteredText,
    String? uiLanguage,
    bool useDeepAnalysis = false, // 🧠 Kullanıcı zorlarsa Pro kullan
  }) async {
    await initialize();
    await _checkPoints('standard_solve');

    try {
      // 🌍 DNA'dan dili çek veya soru dilini algıla
      final targetLanguage = await _getUserLanguage(
        questionText: manuallyEnteredText,
      );

      // 🧠 AKILLI HAFIZA: Görsel hash kontrolü HER ZAMAN yapılır
      // Konu tespiti sadece embedding araması için gerekli
      String detectedSubject = 'Genel';
      MemoryCheckResult? memoryCheck;
      
      // Konu tahmini (metin varsa basit analiz)
      if (manuallyEnteredText != null) {
        detectedSubject = _detectSubjectFromText(manuallyEnteredText);
      }
      
      // 🚀 PARALEL ARAMA: Altın DB + İnternet aynı anda başlar
      // Altın DB bulursa hemen döndürür, bulamazsa internet sonucu AI ile kullanılır
      String? parallelInternetAnswer;
      String? questionTextForComplexity = manuallyEnteredText; // Tüm durumlar için
      
      if (imageBytes != null && imageBytes.isNotEmpty) {
        debugPrint('🚀 Altın DB kontrolü başlatılıyor (OCR öncesi)...');
        
        // ✅ ÖNCE: Altın DB kontrolü (hash + embedding) - OCR'dan önce!
        memoryCheck = await _memoryService.checkMemory(
          imageBytes: imageBytes,
          questionText: manuallyEnteredText,
          subject: detectedSubject,
        );
        
        // ✅ Altın DB'de bulundu - OCR'a gerek yok, direkt döndür
        if (memoryCheck.foundInGolden && memoryCheck.goldenMatch != null) {
          debugPrint('✅ Altın DB\'den çözüm bulundu! (OCR atlandı)');
          // 💎 Altın DB'den gelse bile elmas düşür
          await _pointsService.spendPoints('standard_solve', description: 'Soru Çözümü (Altın DB)');
          return QuestionSolution(
            subject: memoryCheck.goldenMatch!.subject,
            topic: memoryCheck.goldenMatch!.topic,
            questionText: memoryCheck.goldenMatch!.questionText,
            solution: memoryCheck.goldenMatch!.solution,
            difficulty: 'Orta',
            keyConceptsUsed: [],
            correctAnswer: memoryCheck.goldenMatch!.correctAnswer,
            tips: ['💡 Bu soru daha önce doğrulanmış çözümlerden getirildi.'],
            detectedIntent: null,
            source: 'GoldenDB',
            cost: 10.0,
          );
        }
        
        // ❌ Altın DB'de bulunamadı - ŞİMDİ OCR yap (maliyet sadece gerektiğinde)
        if (questionTextForComplexity == null || questionTextForComplexity.isEmpty) {
          // questionTextForComplexity zaten yukarıda tanımlı
          debugPrint('📝 Altın DB\'de bulunamadı - OCR başlatılıyor...');
          try {
            // ⚡ Firebase AI Gemini 2.5 Flash kullan
            if (_useFirebaseAI) {
              final fbModel = fb.FirebaseAI.googleAI().generativeModel(
                model: 'gemini-2.5-flash',
              );
              
              final ocrResponse = await fbModel.generateContent([
                fb.Content.multi([
                  fb.TextPart('''Bu görseldeki sınav sorusunun METNİNİ oku.
Sadece yazılı metni aynen yaz. JSON formatı kullanma.
Soruyu, şıkları ve verilen bilgileri düz metin olarak yaz.
Grafik varsa "Grafik: [kısa açıklama]" yaz.
Çözüm yapma, sadece oku.'''),
                  fb.InlineDataPart('image/jpeg', imageBytes),
                ]),
              ]).timeout(const Duration(seconds: 5));
              
              questionTextForComplexity = ocrResponse.text?.trim();
            } else {
              // Fallback: eski model
              final ocrResponse = await _model.generateContent([
                Content.multi([
                  TextPart('Bu görseldeki sınav sorusunun metnini oku. JSON kullanma, düz metin yaz.'),
                  DataPart('image/jpeg', imageBytes),
                ]),
              ]).timeout(const Duration(seconds: 4));
              questionTextForComplexity = ocrResponse.text?.trim();
            }
            
            if (questionTextForComplexity != null && questionTextForComplexity.isNotEmpty) {
              // JSON çıktısı gelirse at
              if (questionTextForComplexity.startsWith('[') || questionTextForComplexity.startsWith('{')) {
                debugPrint('⚠️ OCR JSON döndü, atlanıyor');
                questionTextForComplexity = null;
              } else {
                debugPrint('✅ OCR başarılı: ${questionTextForComplexity.length > 80 ? '${questionTextForComplexity.substring(0, 80)}...' : questionTextForComplexity}');
                // OCR sonrası subject güncelle
                detectedSubject = _detectSubjectFromText(questionTextForComplexity);
              }
            }
          } catch (e) {
            debugPrint('⚠️ OCR hatası: $e');
          }
        }
        
        // 🚫 İNTERNET ARAMASI KAPATILDI (Maliyet tasarrufu)
        parallelInternetAnswer = null;
      } 
      // Görsel yoksa sadece text embedding ile ara
      else if (_memoryService.isSubjectSupported(detectedSubject)) {
        debugPrint('🧠 Text embedding ile Altın DB kontrolü yapılıyor...');
        memoryCheck = await _memoryService.checkMemory(
          imageBytes: null,
          questionText: manuallyEnteredText,
          subject: detectedSubject,
        );
        
        if (memoryCheck.foundInGolden && memoryCheck.goldenMatch != null) {
          debugPrint('✅ Altın DB\'den çözüm bulundu!');
          // 💎 Altın DB'den gelse bile elmas düşür
          await _pointsService.spendPoints('standard_solve', description: 'Soru Çözümü (Altın DB)');
          return QuestionSolution(
            subject: memoryCheck.goldenMatch!.subject,
            topic: memoryCheck.goldenMatch!.topic,
            questionText: memoryCheck.goldenMatch!.questionText,
            solution: memoryCheck.goldenMatch!.solution,
            difficulty: 'Orta',
            keyConceptsUsed: [],
            correctAnswer: memoryCheck.goldenMatch!.correctAnswer,
            tips: ['💡 Bu soru daha önce doğrulanmış çözümlerden getirildi.'],
            detectedIntent: null,
            source: 'GoldenDB',
            cost: 10.0,
          );
        }
        
        // Text sorular için de internet araması yap
          // 🚫 MANUEL GİRİŞTE INTERNET ARAMASI KAPATILDI
          // parallelInternetAnswer = await _validationService.quickAnswerLookup(manuallyEnteredText);
          if (parallelInternetAnswer != null) {
            debugPrint('🌐 İnternet şık buldu: $parallelInternetAnswer');
          }
        }

      // 🎯 AKILLI PROMPT SEÇİMİ: Önce konuyu tespit et, sonra uygun prompt'u seç
      String promptSubject = detectedSubject;
      
      // OCR text varsa daha doğru konu tespiti yap
      if (questionTextForComplexity != null && questionTextForComplexity.isNotEmpty) {
        promptSubject = _detectSubjectFromText(questionTextForComplexity);
        detectedSubject = promptSubject; // Güncelle
      }
      
      final masterPrompt = await _buildSmartSolverPrompt(
        detectedSubject: promptSubject,
        questionText: questionTextForComplexity ?? '',
        uiLanguage: targetLanguage,
      );
      
      // Few-Shot: Benzer soru varsa AI'a örnek olarak ver
      String? fewShotExample;
      if (memoryCheck != null && memoryCheck.similarQuestions.isNotEmpty) {
        final similar = memoryCheck.similarQuestions.first;
        fewShotExample = '''
# ÖRNEK SORU (Benzer çözüm mantığı):
Soru: ${similar.questionText}
Doğru Cevap: ${similar.correctAnswer}
Çözüm: ${similar.solution}
---
''';
        debugPrint('📝 Few-Shot örnek eklendi (benzer soru)');
      }
      
      final List<Part> parts = [];
      if (fewShotExample != null) {
        parts.add(TextPart(fewShotExample));
      }
      parts.add(TextPart(masterPrompt));
      if (imageBytes != null) {
        parts.add(DataPart('image/jpeg', imageBytes));
      }
      if (questionTextForComplexity != null) {
        parts.add(TextPart('\n--- ÖĞRENCİ NOTU/SORU METNİ ---\n$questionTextForComplexity'));
      }

      final content = [Content.multi(parts)];
      
      // 🧠 AKILLI KONU BAZLI MODEL SEÇİMİ (ÖNCEKİ ÇALIŞAN SİSTEM):
      // Karmaşık konular (grafik, türev, integral, limit vb.) → Pro Vision
      // Basit konular (dört işlem, temel geometri) → Flash Vision
      final bool needsProModel = useDeepAnalysis || _isComplexTopic(questionTextForComplexity);
      
      // 🚀 GEMİNİ 2.5 FLASH TERCİH ET (Firebase AI aktifse)
      QuestionSolution? finalSolution;
      String? rawAiResponse;
      
      if (_useFirebaseAI && imageBytes != null) {
        try {
          debugPrint('⚡ Gemini 2.5 Flash deneniyor (Firebase AI)...');
          final fbModel = fb.FirebaseAI.googleAI().generativeModel(
            model: 'gemini-2.5-flash',
          );
          final fbParts = <fb.Part>[];
          if (fewShotExample != null) fbParts.add(fb.TextPart(fewShotExample));
          fbParts.add(fb.TextPart(masterPrompt));
          fbParts.add(fb.InlineDataPart('image/jpeg', imageBytes));
          if (questionTextForComplexity != null) fbParts.add(fb.TextPart('\n--- ÖĞRENCİ NOTU ---\n$questionTextForComplexity'));
          
          final fbContent = [fb.Content.multi(fbParts)];
          final fbResponse = await fbModel.generateContent(fbContent);
          final fbText = fbResponse.text;
          
          if (fbText != null && fbText.isNotEmpty) {
            debugPrint('✅ Gemini 2.5 Flash başarılı!');
            rawAiResponse = fbText;
            await _pointsService.spendPoints('standard_solve', description: 'Soru Çözümü');
            final parsedSolution = _parseMasterResponse(fbText);
            if (parsedSolution != null) {
              finalSolution = QuestionSolution(
                subject: parsedSolution.subject,
                topic: parsedSolution.topic,
                questionText: questionTextForComplexity ?? parsedSolution.questionText,
                solution: parsedSolution.solution,
                difficulty: parsedSolution.difficulty,
                keyConceptsUsed: [],
                correctAnswer: parsedSolution.correctAnswer,
                tips: parsedSolution.tips,
                detectedIntent: parsedSolution.detectedIntent,
              );
              // Subject'i güncelle (AI'dan gelen daha doğru olabilir)
              detectedSubject = parsedSolution.subject;
            }
          }
        } catch (e) {
          debugPrint('⚠️ Gemini 2.5 Flash hatası, fallback kullanılıyor: $e');
        }
      }
      
      // Fallback: Tiered Routing (Maliyet Optimizasyonu)
      if (finalSolution == null) {
        // 🎯 TIERED ROUTING: Ders ve zorluk seviyesine göre model seçimi
        final complexityScore = _calculateComplexityScore(questionTextForComplexity);
        final tier = _selectModelByTier(detectedSubject, complexityScore, isVisual: imageBytes != null);
        
        final GenerativeModel selectedModel;
        if (tier == 'pro') {
          // Tier 1: Gemini 2.5 Pro (Karmaşık matematik)
          selectedModel = imageBytes != null ? _proVisionModel : _proModel;
          debugPrint('🧠 Tier 1: Gemini 2.5 Pro seçildi (karmaşık soru)');
        } else if (tier == 'flash_lite') {
          // Tier 3: Gemini 2.5 Flash-Lite (Sözel dersler - ekonomik)
          selectedModel = _flashModel;
          debugPrint('⚡ Tier 3: Gemini 2.5 Flash-Lite seçildi (sözel/ekonomik)');
        } else {
          // Tier 2: Gemini 2.5 Flash (Varsayılan - orta)
          selectedModel = imageBytes != null ? _visionModel : _model;
          debugPrint('⚡ Tier 2: Gemini 2.5 Flash seçildi (orta)');
        }
        
        final response = await selectedModel.generateContent(content);
        final text = response.text;

        if (text == null || text.isEmpty) throw Exception('AI yanıt vermedi');

        rawAiResponse = text;
        await _pointsService.spendPoints('standard_solve', description: 'Soru Çözümü');
        
        final QuestionSolution? parsedSolution = _parseMasterResponse(text);
        if (parsedSolution == null) throw Exception('JSON ayrıştırma hatası');
        
        finalSolution = QuestionSolution(
          subject: parsedSolution.subject,
          topic: parsedSolution.topic,
          questionText: questionTextForComplexity ?? parsedSolution.questionText,
          solution: parsedSolution.solution,
          difficulty: parsedSolution.difficulty,
          keyConceptsUsed: [],
          correctAnswer: parsedSolution.correctAnswer,
          tips: parsedSolution.tips,
          detectedIntent: parsedSolution.detectedIntent,
          source: 'AI',
          cost: 0.02, // Tahmini ortalama maliyet
        );
        detectedSubject = parsedSolution.subject;
      }
      
      // 🧠 AKILLI HAFIZA: Çözümü kaydet (sadece desteklenen dersler)
      if (_memoryService.isSubjectSupported(detectedSubject) && 
          memoryCheck != null && 
          finalSolution != null &&
          finalSolution.correctAnswer != null) {
        
        // Güven skorunu hesapla
        final confidenceScore = _validationService.calculateConfidenceScore(
          solutionText: finalSolution.solution,
          topic: finalSolution.topic,
          isVisualQuestion: imageBytes != null,
        );
        

        
        debugPrint('📊 Güven skoru: $confidenceScore');
        
        // 🌐 PARALEL İNTERNET SONUCUNU KULLAN
        bool validated = false;
        String? internetAnswer = parallelInternetAnswer; // Paralelden gelen sonuç
        
        // Paralel aramadan geldiyse direkt karşılaştır
        if (parallelInternetAnswer != null) {
          validated = parallelInternetAnswer == finalSolution.correctAnswer;
          debugPrint('🌐 Paralel internet karşılaştırma: AI=${finalSolution.correctAnswer}, Net=$parallelInternetAnswer, Eşleşme=$validated');
          
          if (!validated) {
            debugPrint('⚠️ ÇELİŞKİ! AI yanlış cevap vermiş olabilir. Altın DB\'ye kaydedilmeyecek.');
          }
        }
        // 🚫 İNTERNET DOĞRULAMASI KAPATILDI (Maliyet tasarrufu)
        // Sadece güven skoruna göre doğrula
        else {
          // Yüksek güven → Doğrudan doğrulanmış kabul et
          validated = confidenceScore >= 0.85;
        }
        
        // 🌍 Subject'i İngilizce'ye çevir (global hafıza standardı)
        final normalizedSubject = _memoryService.normalizeSubjectToEnglish(detectedSubject);
        debugPrint('🌍 Subject: $detectedSubject → $normalizedSubject');
        debugPrint('📊 Validated: $validated, Confidence: $confidenceScore');
        
        // Hafızaya kaydet
        await _memoryService.saveToMemory(
          questionHash: memoryCheck.questionHash,
          embedding: memoryCheck.embedding,
          questionText: finalSolution.questionText,
          aiAnswer: finalSolution.correctAnswer!,
          aiSolution: finalSolution.solution,
          subject: normalizedSubject, // İngilizce ders ismi
          topic: finalSolution.topic,
          confidenceScore: confidenceScore,
          validated: validated,
          internetAnswer: internetAnswer,
        );
        debugPrint('✅ Hafızaya kayıt tamamlandı (Subject: $normalizedSubject, Validated: $validated)');
      }
      
      return finalSolution;
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Soru çözme hatası: $e');
      return null;
    }
  }

  /// 🃏 KONU KARTI ÜRET (Flash 2.5 ile)
  /// Verilen konu hakkında 3 adet kısa soru/cevap kartı üretir
  Future<List<Map<String, String>>> generateFlashcards(String subject, String topic) async {
    await initialize();
    await _checkPoints('generate_flashcards');

    try {
      // Prompt Hazırla
      final prompt = '''
Sen uzman bir öğretmensin. "$subject" dersinin "$topic" konusu hakkında öğrencilerin bilmesi gereken en kritik, hap bilgileri içeren 3 ADET bilgi kartı hazırla.

KURALLAR:
1. Tam olarak 3 kart üret.
2. Her kartta bir "soru" ve bir "cevap" olsun.
3. Cevaplar çok kısa, net ve akılda kalıcı olsun (1-3 kelime veya tek cümle).
4. Sorular merak uyandırıcı olsun.
5. Çıktı SADECE geçerli bir JSON array olsun.

ÖRNEK JSON FORMATI:
[
  {"question": "Nedim hangi dönem şairidir?", "answer": "Lale Devri"},
  {"question": "Şarkı nazım biçiminin en önemli temsilcisi kimdir?", "answer": "Nedim"},
  {"question": "Nedim'in asıl mesleği nedir?", "answer": "Müderris"}
]
''';

      // ⚡ Gemini 2.5 Flash Kullan
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) throw Exception('AI yanıt üretmedi');

      // JSON Parse
      final cleanedText = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final List<dynamic> jsonList = jsonDecode(cleanedText);

      // Puan Harca
      await _pointsService.spendPoints('generate_flashcards', description: 'Kart Üretimi: $topic');

      return jsonList.map((item) => {
        'question': item['question'].toString(),
        'answer': item['answer'].toString(),
      }).toList();

    } catch (e) {
      debugPrint('❌ Kart üretme hatası: $e');
      return [];
    }
  }

  /// 🧠 SMART VISION: Görseldeki metni (Matematik dahil) kusursuz oku
  /// Standart OCR'ın yapamadığı kesirli/kareköklü ifadeleri transkribe eder.
  Future<String> extractTextFromImage(Uint8List imageBytes) async {
    await initialize();
    // Admin işlemi olduğu için puan kontrolü yapma veya düşük puan
    
    try {
      debugPrint('🧠 Smart Vision başlatılıyor (Maliyet ~0.001 TL)...');

      final promptPart = TextPart('''
GÖREV: Bu görseldeki sınav sorusunun metnini birebir transkribe et.
KURALLAR:
1. Sadece metni yaz. Yorum, çözüm veya açıklama YAPMA.
2. Matematiksel ifadeleri (kesir, kök, üs) standart yazı formatında yaz (örn: 1/(8-37/8)).
3. Şıkları (A, B, C...) alt alta yaz.
4. JSON kullanma, sadece düz metin döndür.
''');

      final imagePart = DataPart('image/jpeg', imageBytes);
      
      // Flash Vision modeli yeterlidir ve hızlıdır
      final response = await _visionModel.generateContent([
        Content.multi([promptPart, imagePart])
      ]);

      if (response.text == null) throw Exception('AI metin okuyamadı');
      
      debugPrint('✅ Smart Vision Başarılı: ${response.text!.length} karakter');
      return response.text!.trim();

    } catch (e) {
      debugPrint('❌ Smart Vision Hatası: $e');
      throw Exception('Görsel okunamadı: $e');
    }
  }
  
  /// Metin içeriğinden konu tahmini yap
  /// 🌍 Metinden ders/konu tespiti - Ağırlıklandırılmış ve Optimize Edilmiş
  /// ✅ Sayısal dersler önce kontrol edilir (daha spesifik)
  /// ✅ Ağırlıklandırılmış tespit: En yüksek puanlı ders döndürülür
  String _detectSubjectFromText(String text) {
    final lower = text.toLowerCase();
    
    // Ağırlıklandırılmış tespit: Her ders için puan topla
    final Map<String, int> scores = {};
    
    // =============== SAYISAL DERSLER (ÖNCE KONTROL EDİLİR) ===============
    
    // MATEMATİK - Yüksek öncelikli keyword'ler
    int mathScore = 0;
    final mathHighPriority = ['türev', 'derivative', 'integral', '∫', 'limit', 'lim', 
                               'fonksiyon', 'function', 'f(x)', 'f\'(x)', 'f′(x)',
                               'denklem', 'equation', 'geometri', 'geometry',
                               'üçgen', 'triangle', 'çember', 'circle',
                               'olasılık', 'probability', 'permütasyon', 'permutation',
                               'kombinasyon', 'combination', 'faktoriyel', 'factorial',
                               'logaritma', 'logarithm', 'log', 'ln', 'üstel', 'exponential'];
    final mathMediumPriority = ['matematik', 'mathematics', 'math', 'sayı', 'number',
                                'x=', 'x =', 'y=', 'y =', 'polinom', 'polynomial',
                                'trigonometri', 'trigonometry', 'sin', 'cos', 'tan'];
    
    for (final keyword in mathHighPriority) {
      if (lower.contains(keyword)) mathScore += 50;
    }
    for (final keyword in mathMediumPriority) {
      if (lower.contains(keyword)) mathScore += 30;
    }
    if (mathScore > 0) scores['Matematik'] = mathScore;
    
    // FİZİK
    int physicsScore = 0;
    final physicsHighPriority = ['kuvvet', 'force', 'newton', 'hareket', 'motion',
                                  'enerji', 'energy', 'elektrik', 'electricity',
                                  'manyetik', 'magnetic', 'dalga', 'wave',
                                  'momentum', 'ivme', 'acceleration', 'hız', 'velocity',
                                  'optik', 'optics', 'ışık', 'light', 'termodinamik', 'thermodynamics'];
    final physicsMediumPriority = ['fizik', 'physics', 'newton', 'newton\'s law',
                                    'çembersel hareket', 'circular motion', 'modern fizik', 'modern physics'];
    
    for (final keyword in physicsHighPriority) {
      if (lower.contains(keyword)) physicsScore += 50;
    }
    for (final keyword in physicsMediumPriority) {
      if (lower.contains(keyword)) physicsScore += 30;
    }
    if (physicsScore > 0) scores['Fizik'] = physicsScore;
    
    // KİMYA
    int chemistryScore = 0;
    final chemistryHighPriority = ['element', 'bileşik', 'compound', 'reaksiyon', 'reaction',
                                    'mol', 'mole', 'asit', 'acid', 'baz', 'base',
                                    'organik', 'organic', 'ester', 'alkol', 'alcohol',
                                    'aldehit', 'aldehyde', 'keton', 'ketone', 'karboksil', 'carboxyl',
                                    'elektroliz', 'electrolysis', 'periyodik', 'periodic'];
    final chemistryMediumPriority = ['kimya', 'chemistry', 'chemical', 'atom', 'molecule',
                                      'molekül', 'iyon', 'ion', 'çözelti', 'solution',
                                      'derişim', 'concentration'];
    
    for (final keyword in chemistryHighPriority) {
      if (lower.contains(keyword)) chemistryScore += 50;
    }
    for (final keyword in chemistryMediumPriority) {
      if (lower.contains(keyword)) chemistryScore += 30;
    }
    if (chemistryScore > 0) scores['Kimya'] = chemistryScore;
    
    // BİYOLOJİ
    int biologyScore = 0;
    final biologyHighPriority = ['hücre', 'cell', 'mitoz', 'mitosis', 'mayoz', 'meiosis',
                                  'dna', 'rna', 'protein', 'enzim', 'enzyme',
                                  'fotosentez', 'photosynthesis', 'solunum', 'respiration',
                                  'gen', 'gene', 'kromozom', 'chromosome', 'kalıtım', 'heredity',
                                  'mutasyon', 'mutation', 'ekosistem', 'ecosystem'];
    final biologyMediumPriority = ['biyoloji', 'biology', 'besin zinciri', 'food chain'];
    
    for (final keyword in biologyHighPriority) {
      if (lower.contains(keyword)) biologyScore += 50;
    }
    for (final keyword in biologyMediumPriority) {
      if (lower.contains(keyword)) biologyScore += 30;
    }
    if (biologyScore > 0) scores['Biyoloji'] = biologyScore;
    
    // =============== SÖZEL DERSLER ===============
    
    // TÜRKÇE - Yüksek öncelikli keyword'ler (yazım soruları için)
    int turkishScore = 0;
    final turkishHighPriority = ['numaralanmış', 'numaralı', 'yazımında', 'yazım', 'yanlışlık',
                                 'yazım hatası', 'yazım yanlışı', 'imla hatası', 'imla',
                                 'anlatım bozukluğu', 'anlatım bozuklukları', 'dil bilgisi',
                                 'paragraf', 'parça', 'metin', 'cümle', 'sözcük', 'anlam',
                                 'özne', 'yüklem', 'türkçe'];
    final turkishMediumPriority = ['edat', 'bağlaç', 'fiil', 'sıfat', 'zamir', 'zarf',
                                   'anlam kayması', 'devrik cümle', 'kurallı cümle',
                                   'yan cümle', 'temel cümle', 'metin anlama', 'yazarın özelliği',
                                   'ana fikir', 'ana düşünce', 'yardımcı fikir',
                                   'okuma anlama', 'metnin konusu', 'noktalama'];
    
    for (final keyword in turkishHighPriority) {
      if (lower.contains(keyword)) turkishScore += 50; // Yazım soruları için yüksek puan
    }
    for (final keyword in turkishMediumPriority) {
      if (lower.contains(keyword)) turkishScore += 30;
    }
    if (lower.contains('metin') && (lower.contains('aşağıdaki') || lower.contains('yukarıdaki'))) {
      turkishScore += 20;
    }
    // "coğrafi" kelimesi Coğrafya ile eşleşmesin - Türkçe sorularda da geçebilir
    if (lower.contains('coğrafi') && (lower.contains('yazım') || lower.contains('numaralanmış'))) {
      turkishScore += 40; // Türkçe yazım sorusu olduğunu gösterir
    }
    if (turkishScore > 0) scores['Türkçe'] = turkishScore;
    
    // EDEBİYAT
    int literatureScore = 0;
    final literatureKeywords = ['şiir', 'roman', 'hikaye', 'divan', 'tanzimat',
                               'servet-i fünun', 'edebiyat', 'edebi', 'nazım', 'nesir',
                               'aruz', 'hece', 'masal', 'destan'];
    for (final keyword in literatureKeywords) {
      if (lower.contains(keyword)) literatureScore += 30;
    }
    if (literatureScore > 0) scores['Edebiyat'] = literatureScore;
    
    // TARİH
    int historyScore = 0;
    final historyKeywords = ['savaş', 'antlaşma', 'padişah', 'sultan', 'osmanlı',
                            'cumhuriyet', 'atatürk', 'inkılap', 'tarih', 'imparatorluk',
                            'fetih', 'milli mücadele', 'yüzyıl', '.yy', 'medeniyet', 'uygarlık'];
    for (final keyword in historyKeywords) {
      if (lower.contains(keyword)) historyScore += 30;
    }
    if (historyScore > 0) scores['Tarih'] = historyScore;
    
    // COĞRAFYA - "coğrafi" kelimesi tek başına yeterli değil (Türkçe sorularda da geçebilir)
    int geographyScore = 0;
    final geographyKeywords = ['iklim', 'nüfus', 'harita', 'koordinat', 'enlem', 'boylam',
                               'coğrafya', 'bölge', 'yeraltı', 'maden', 'göç', 'tarım',
                               'akarsu', 'dağ', 'ova', 'plato'];
    for (final keyword in geographyKeywords) {
      if (lower.contains(keyword)) geographyScore += 30;
    }
    // "coğrafi" sadece coğrafya dersi keyword'leriyle birlikte geçerse puan ver
    if (lower.contains('coğrafi') && !lower.contains('yazım') && !lower.contains('numaralanmış')) {
      // Coğrafya dersi bağlamında kullanılmış olabilir
      if (geographyScore > 0) {
        geographyScore += 20; // Ek puan
      }
    }
    if (geographyScore > 0) scores['Coğrafya'] = geographyScore;
    
    // FELSEFE
    int philosophyScore = 0;
    final philosophyKeywords = ['felsefe', 'etik', 'ahlak', 'varlık', 'epistemoloji',
                                'ontoloji', 'metafizik', 'düşünce', 'sokrates', 'platon',
                                'aristoteles', 'filozof'];
    for (final keyword in philosophyKeywords) {
      if (lower.contains(keyword)) philosophyScore += 30;
    }
    if (philosophyScore > 0) scores['Felsefe'] = philosophyScore;
    
    // DİN KÜLTÜRÜ
    int religionScore = 0;
    final religionKeywords = ['din', 'ibadet', 'kuran', 'ayet', 'hadis', 'peygamber',
                             'islam', 'namaz', 'oruç', 'hac'];
    for (final keyword in religionKeywords) {
      if (lower.contains(keyword)) religionScore += 30;
    }
    if (religionScore > 0) scores['Din Kültürü'] = religionScore;
    
    // İNGİLİZCE - Genişletilmiş keyword listesi
    int englishScore = 0;
    final englishHighPriority = ['which of the following', 'according to the passage',
                                'reading comprehension', 'passage', 'paragraph'];
    final englishMediumPriority = ['english', 'grammar', 'tense', 'vocabulary',
                                   'reading', 'writing', 'listening', 'speaking',
                                   'derivative', 'integral', 'calculate', 'find',
                                   'solve', 'determine', 'prove', 'express', 'simplify',
                                   'force', 'velocity', 'acceleration', 'energy',
                                   'reaction', 'molecule', 'element', 'compound'];
    
    for (final keyword in englishHighPriority) {
      if (lower.contains(keyword)) englishScore += 50;
    }
    for (final keyword in englishMediumPriority) {
      if (lower.contains(keyword)) englishScore += 30;
    }
    if (englishScore > 0) scores['İngilizce'] = englishScore;
    
    // En yüksek puanlı dersi döndür
    if (scores.isEmpty) return 'Genel';
    
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final bestMatch = sortedScores.first;
    debugPrint('📊 Konu tespiti: ${bestMatch.key} (Puan: ${bestMatch.value})');
    
    // Eğer en yüksek puan çok düşükse "Genel" döndür
    if (bestMatch.value < 30) return 'Genel';
    
    return bestMatch.key;
  }

  /// 🎯 Metinden alt konu tespiti
  String _detectTopicFromText(String text) {
    final lower = text.toLowerCase();
    
    // Kimya alt konuları
    if (lower.contains('ester') || lower.contains('karboksil')) return 'Organik Kimya - Esterler';
    if (lower.contains('alkol') || lower.contains('aldehit') || lower.contains('keton')) return 'Organik Kimya - Fonksiyonel Gruplar';
    if (lower.contains('asit') || lower.contains('baz')) return 'Asitler ve Bazlar';
    if (lower.contains('mol') || lower.contains('derişim')) return 'Mol Kavramı';
    if (lower.contains('reaksiyon') || lower.contains('denkleştir')) return 'Kimyasal Tepkimeler';
    
    // Matematik alt konuları
    if (lower.contains('türev')) return 'Türev';
    if (lower.contains('integral')) return 'İntegral';
    if (lower.contains('limit')) return 'Limit';
    if (lower.contains('fonksiyon')) return 'Fonksiyonlar';
    if (lower.contains('olasılık')) return 'Olasılık';
    if (lower.contains('geometri') || lower.contains('üçgen') || lower.contains('çember')) return 'Geometri';
    
    // Fizik alt konuları
    if (lower.contains('kuvvet') || lower.contains('newton')) return 'Kuvvet ve Hareket';
    if (lower.contains('elektrik')) return 'Elektrik';
    if (lower.contains('optik') || lower.contains('ışık')) return 'Optik';
    
    // Türkçe alt konuları
    if (lower.contains('paragraf')) return 'Paragraf';
    if (lower.contains('cümle')) return 'Cümle Bilgisi';
    if (lower.contains('sözcük') || lower.contains('anlam')) return 'Sözcükte Anlam';
    
    return 'Genel';
  }

  
  /// 🎯 Complexity Score Algoritması - Zorluk tespiti
  /// Score > 40 → Tier 1 (Pro), Score ≤ 40 → Tier 2 (Flash)
  int _calculateComplexityScore(String? text) {
    if (text == null || text.isEmpty) return 0; // Text yoksa varsayılan: basit
    
    final lowerText = text.toLowerCase();
    int score = 0;
    
    // 🔴 Yüksek Puanlılar (+50): En zor konular
    const highScoreKeywords = [
      'türev', 'derivative', 'f\'(x)', 'f′(x)', 'integral', '∫',
      'limit', 'lim', 'süreklilik', 'continuity',
      'logaritma', 'log', 'ln', 'üstel', 'exponential', 'e^',
      'çembersel hareket', 'modern fizik', 'organik kimya',
    ];
    
    // 🟡 Orta Puanlılar (+20): Orta zorluk
    const mediumScoreKeywords = [
      'fonksiyon', 'function', 'f(x)', 'g(x)', 'kompozit', 'ters fonksiyon',
      'polinom', 'hareket', 'enerji', 'mol', 'asit-baz',
      'grafik', 'graph', 'eğri', 'curve', 'koordinat',
      'maksimum', 'minimum', 'ekstremum', 'tepe', 'çukur',
    ];
    
    // Keyword taraması
    for (final keyword in highScoreKeywords) {
      if (lowerText.contains(keyword)) {
        score += 50;
        debugPrint('🎯 Yüksek puanlı keyword: $keyword (+50)');
      }
    }
    
    for (final keyword in mediumScoreKeywords) {
      if (lowerText.contains(keyword)) {
        score += 20;
        debugPrint('🎯 Orta puanlı keyword: $keyword (+20)');
      }
    }
    
    // LaTeX sembol yoğunluğu kontrolü
    final latexSymbols = ['\\int', '\\lim', '\\sum', '\\frac', '\\sqrt', '\\sin', '\\cos'];
    int latexCount = 0;
    for (final symbol in latexSymbols) {
      if (text.contains(symbol)) latexCount++;
    }
    if (latexCount >= 3) {
      score += 30; // Yoğun matematiksel sembol
      debugPrint('🎯 LaTeX yoğunluğu tespit edildi: $latexCount sembol (+30)');
    }
    
    // Metin uzunluğu kontrolü (çok kısa ama sembol yoğunsa zor)
    if (text.length < 100 && latexCount >= 2) {
      score += 20;
    }
    
    debugPrint('📊 Complexity Score: $score');
    return score;
  }

  /// 🎯 Karmaşık konu tespiti - Pro model gerektiren konular (Geriye uyumluluk)
  bool _isComplexTopic(String? text) {
    return _calculateComplexityScore(text) > 40;
  }

  /// 🎯 Tiered Routing: Ders ve zorluk seviyesine göre model seçimi
  /// Tier 3 (Ekonomik): Sözel dersler → Gemini 2.5 Flash-Lite
  /// Tier 2 (Orta): Sayısal temel → Gemini 2.5 Flash
  /// Tier 1 (Ağır): İleri matematik → Gemini 2.5 Pro
  String _selectModelByTier(String subject, int complexityScore, {bool isVisual = false}) {
    final lowerSubject = subject.toLowerCase();
    
    // Tier 3: Sözel dersler (Ekonomik)
    const tier3Subjects = [
      'türkçe', 'edebiyat', 'tarih', 'coğrafya', 'felsefe', 'din', 'biyoloji',
      'turkish', 'literature', 'history', 'geography', 'philosophy', 'religion', 'biology',
    ];
    
    if (tier3Subjects.any((s) => lowerSubject.contains(s))) {
      debugPrint('📊 Tier 3 seçildi: $subject → Gemini 2.5 Flash-Lite (Ekonomik)');
      return 'flash_lite';
    }
    
    // Tier 1: Yüksek karmaşıklık (Ağır siklet)
    // Tier 1: Yüksek karmaşıklık (Ağır siklet)
    if (complexityScore > 40) {
      debugPrint('📊 Tier 1 seçildi: Complexity Score $complexityScore → Gemini 2.5 Pro (Ağır)');
      return 'pro';
    }
    
    // Tier 2: Sayısal orta seviye (Varsayılan)
    debugPrint('📊 Tier 2 seçildi: $subject → Gemini 2.5 Flash (Orta)');
    return 'flash';
  }

  /// Görselden soru çöz - Master Solver ile (solveQuestion'a delegasyon)
  Future<QuestionSolution?> solveQuestionFromImage(Uint8List imageBytes) async {
    return solveQuestion(imageBytes: imageBytes);
  }

  /// Hızlı OCR - Sadece complexity score için
  Future<String?> _extractTextForComplexity(Uint8List imageBytes) async {
    try {
      if (_useFirebaseAI) {
        final fbModel = fb.FirebaseAI.googleAI().generativeModel(
          model: 'gemini-2.5-flash',
        );
        final ocrResponse = await fbModel.generateContent([
          fb.Content.multi([
            fb.TextPart('Bu görseldeki sınav sorusunun metnini oku. Sadece metni yaz, JSON kullanma.'),
            fb.InlineDataPart('image/jpeg', imageBytes),
          ]),
        ]).timeout(const Duration(seconds: 3));
        return ocrResponse.text?.trim();
      }
    } catch (e) {
      debugPrint('⚠️ Hızlı OCR hatası: $e');
    }
    return null;
  }

  /// Master Response'u parse et - Bulletproof 4.5 + Fallback
  QuestionSolution? _parseMasterResponse(String text) {
    try {
      final jsonMap = _extractJsonMap(text);
      
      // FALLBACK: JSON bulunamadıysa düz metni çözüm olarak kullan
      if (jsonMap == null) {
        debugPrint('⚠️ JSON bulunamadı, düz metin fallback kullanılıyor');
        
        // "Here is the JSON requested:" gibi gereksiz prefix'leri temizle
        String cleanText = text;
        cleanText = cleanText.replaceAll(RegExp(r'Here is the JSON requested:?', caseSensitive: false), '');
        cleanText = cleanText.replaceAll(RegExp(r'Here is the JSON:?', caseSensitive: false), '');
        cleanText = cleanText.replaceAll(RegExp(r'JSON requested:?', caseSensitive: false), '');
        cleanText = cleanText.replaceAll(RegExp(r'```json\s*', caseSensitive: false), '');
        cleanText = cleanText.replaceAll(RegExp(r'```\s*', caseSensitive: false), '');
        cleanText = cleanText.trim();
        
        // Eğer temizlenmiş metin boşsa, orijinal metni kullan
        if (cleanText.isEmpty) {
          cleanText = text.trim();
        }
        
        // Son satırdan cevabı çıkarmaya çalış (FINAL ANSWER: E gibi)
        String? extractedAnswer;
        final lines = cleanText.split('\n');
        for (final line in lines.reversed) {
          final upperLine = line.toUpperCase().trim();
          if (upperLine.contains('FINAL ANSWER') || upperLine.contains('CEVAP') || 
              upperLine.contains('ANSWER:') || upperLine.contains('DOĞRU CEVAP')) {
            final match = RegExp(r'[A-E]').firstMatch(upperLine);
            if (match != null) {
              extractedAnswer = match.group(0);
              break;
            }
          }
        }
        
        // Cevap bulunamadıysa, metinden şık aramaya çalış (A), B), C) gibi)
        if (extractedAnswer == null) {
          final answerMatch = RegExp(r'([A-E])[\)\.]').firstMatch(cleanText);
          if (answerMatch != null) {
            extractedAnswer = answerMatch.group(1);
          }
        }
        
        // 🌍 AKILLI KONU TESPİTİ: Metinden konuyu algıla
        final detectedSubject = _detectSubjectFromText(cleanText);
        final detectedTopic = _detectTopicFromText(cleanText);
        
        return QuestionSolution(
          subject: detectedSubject,
          topic: detectedTopic,
          questionText: '',
          solution: cleanText.isEmpty ? 'Çözüm üretilemedi. Lütfen tekrar deneyin.' : cleanText,
          difficulty: 'medium',
          keyConceptsUsed: [],
          correctAnswer: extractedAnswer,
          tips: [],
          detectedIntent: null,
        );
      }

      final systemData = jsonMap['system_data'] as Map<String, dynamic>? ?? 
                         jsonMap['system_info'] as Map<String, dynamic>? ?? 
                         jsonMap['data'] as Map<String, dynamic>? ?? {};
      
      // 🛡️ Tip Güvenliği: display_response her zaman string olmalı
      final dynamic rawSolution = jsonMap['display_response'] ?? 
                                 jsonMap['solution'] ?? 
                                 jsonMap['response'] ?? 
                                 jsonMap['answer'] ?? '';
      
      String solutionText = '';
      if (rawSolution is String) {
        solutionText = rawSolution;
      } else if (rawSolution != null) {
        solutionText = jsonEncode(rawSolution);
      }

      // 🧠 AKILLI KONU DOĞRULAMA: AI bazen yanlış veya İngilizce konu döndürüyor
      String aiSubject = (systemData['topic_main'] ?? systemData['subject'] ?? 'Genel').toString();
      String aiTopic = (systemData['topic_sub'] ?? systemData['topic'] ?? 'Genel').toString();
      
      // AI İngilizce konu döndürdüyse, metinden Türkçe tespit yap
      final englishSubjects = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'Turkish', 'Literature', 'History', 'Geography', 'Medicine', 'English'];
      if (englishSubjects.any((s) => aiSubject.toLowerCase() == s.toLowerCase())) {
        final detectedFromSolution = _detectSubjectFromText(solutionText);
        final detectedFromTopic = _detectSubjectFromText(aiTopic);
        // Eğer çözümden veya konu başlığından daha iyi bir tespit varsa onu kullan
        if (detectedFromSolution != 'Genel') {
          aiSubject = detectedFromSolution;
        } else if (detectedFromTopic != 'Genel') {
          aiSubject = detectedFromTopic;
        }
      }

      return QuestionSolution(
        subject: aiSubject,
        topic: aiTopic,
        questionText: '',
        solution: _cleanSolutionText(solutionText),
        difficulty: (systemData['difficulty'] ?? 'medium').toString(),
        keyConceptsUsed: [],
        correctAnswer: (systemData['correct_answer'] ?? systemData['answer'])?.toString(),
        tips: (jsonMap['master_tips'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        detectedIntent: systemData['detected_weakness']?.toString(),
      );
    } catch (e) {
      debugPrint('⚠️ _parseMasterResponse Hatası: $e');
      
      // HAFIZA SIZINTISI ENGELLEME: Fallback metninden "Düşünce" kısımlarını temizle
      // Model bazen JSON dışına taşırıyor.
      String cleanText = text;
      
      // Eğer JSON kümesi varsa, sadece onu almaya çalış (RegExp ile)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(cleanText);
      if (jsonMatch != null) {
          // Bulunan JSON bloğunu çözüm olarak kullanmayı dene (içindeki düşünceyi silebiliriz)
          cleanText = jsonMatch.group(0)!;
      } else {
        // JSON yoksa, bilinen düşünce prefixlerini sil
        cleanText = cleanText.replaceAll(RegExp(r'internal_thought|thought_process|Thinking:|Step 1:|STEP 1:', caseSensitive: false), '');
      }

      final detectedSubject = _detectSubjectFromText(cleanText);
      final detectedTopic = _detectTopicFromText(cleanText);
      
      return QuestionSolution(
        subject: detectedSubject,
        topic: detectedTopic,
        questionText: '',
        solution: cleanText, // Temizlenmiş metin
        difficulty: 'medium',
        keyConceptsUsed: [],
        correctAnswer: null,
        tips: [],
        detectedIntent: null,
      );
    }
  }

  // ⚠️ _parseMasterResponse ve türevi manuel parserlar artık kullanılmıyor. 
  // Schema desteği ile jsonDecode(text) doğrudan iş görüyor.

  /// Çözüm metnini temizle (escape karakterleri ve LaTeX sızıntılarını temizle)
  String _cleanSolutionText(String raw) {
    String cleaned = raw
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"')
        .replaceAll(r'\\', r'\')
        .replaceAll(r'\t', '\t');

    // 🛡️ LaTeX Safety Net: Eğer AI tırnak içinde $x$ gibi sızıntılar yaptıysa temizle
    // Not: \$ sembolünü koruyoruz ama $x$ veya $$x$$ şeklindeki sarmalamaları çözüyoruz.
    cleaned = cleaned.replaceAllMapped(RegExp(r'\$([^$]+)\$'), (match) => match.group(1)!);
    cleaned = cleaned.replaceAllMapped(RegExp(r'\\\(([^)]+)\\\)'), (match) => match.group(1)!); // \( x \) -> x
    cleaned = cleaned.replaceAll(r'$$', ''); // Kalan çift dolarları temizle

    return cleaned.trim();
  }

  /// 🤖 JSON Ayıklayıcı - Model yanıtından temiz JSON objesi çıkarır
  Map<String, dynamic>? _extractJsonMap(String? text) {
    if (text == null || text.isEmpty) return null;
    
    try {
      String cleanText = text.trim();
      
      // 1. Doğrudan deneme (JSON Mode aktifse genellikle burası çalışır)
      try {
        final decoded = jsonDecode(cleanText);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}

      // 2. Markdown bloklarını temizle
      if (cleanText.contains('```')) {
        final match = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(cleanText);
        if (match != null) cleanText = match.group(1)!.trim();
      }

      // 3. Braces aralığını bul (Daha derin tarama)
      final firstBrace = cleanText.indexOf('{');
      final lastBrace = cleanText.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
        final jsonCandidate = cleanText.substring(firstBrace, lastBrace + 1);
        try {
          final decoded = jsonDecode(jsonCandidate);
          if (decoded is Map<String, dynamic>) return decoded;
        } catch (_) {}
      }
      
      return null;
    } catch (e) {
      debugPrint('⚠️ JSON Ayıklama Hatası: $e');
      return null;
    }
  }

  /// 🎨 CLONE GENERATOR - Benzer sorular üret
  /// NOT: Burada kullanıcı profil seviyesi DEĞİL, orijinal sorunun seviyesi önemli!
  /// Mühendislik öğrencisi ilkokul sorusu çözdüyse, benzer sorular da ilkokul seviyesinde olmalı.
  /// 🧠 AKILLI HAFIZA: Önce Altın DB'de benzer sorular aranır, bulunamazsa AI üretir.
  Future<List<SimilarQuestion>> generateSimilarQuestions({
    required String subject,
    required String topic,
    required String originalQuestion,
    String? originalSolutionLogic,
    String? questionTargetLevel,
    int count = 1, // 🔴 2'den 1'e düşürüldü (maliyet optimizasyonu)
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    await _checkPoints('similar_question');
    
    final dna = await _dnaService.getDNA();
    final targetLevel = questionTargetLevel ?? dna?.gradeLevel ?? 'Belirlenmedi';

    try {
      // 🧠 AKILLI HAFIZA: Önce Altın DB'de benzer sorular ara
      List<SimilarQuestion> result = [];
      int neededFromAI = count;
      
      if (_memoryService.isSubjectSupported(subject)) {
        debugPrint('🧠 Altın DB\'de benzer sorular aranıyor...');
        
        // Orijinal soru için embedding üret
        final embeddingService = EmbeddingService();
        final embedding = await embeddingService.generateQuestionEmbedding(originalQuestion);
        
        if (embedding.isNotEmpty) {
          final goldenSimilars = await _memoryService.findSimilarQuestions(
            embedding: embedding,
            subject: subject,
            limit: count,
            minSimilarity: 0.75,
          );
          
          if (goldenSimilars.isNotEmpty) {
            debugPrint('✅ Altın DB\'den ${goldenSimilars.length} benzer soru bulundu!');
            
            // Golden DB'den gelen soruları SimilarQuestion'a dönüştür
            for (final golden in goldenSimilars) {
              result.add(SimilarQuestion(
                question: golden.questionText,
                correctAnswer: golden.correctAnswer,
                options: [], // Altın DB'de options saklanmıyor
                explanation: golden.solution,
              ));
            }
            
            neededFromAI = count - result.length;
            
            // Yeterli soru bulunduysa AI'a hiç sormadan dön
            if (neededFromAI <= 0) {
              debugPrint('✅ Tüm sorular Altın DB\'den karşılandı (AI çağrısı yapılmadı)');
              // Puan iadesi - AI kullanılmadı
              return result.take(count).toList();
            }
          }
        }
      }
      
      // 🎨 Eksik kalanı AI üretsin
      debugPrint('🤖 AI $neededFromAI soru üretecek...');
      
      // 1. ADIM: Soru Üretimi (Gemini 1.5 Pro ile)
      final generationPrompt = _promptRegistry.getPrompt('similar_question_generator', variables: {
        'targetLevel': targetLevel,
        'count': neededFromAI.toString(),
        'originalQuestion': originalQuestion,
        'originalSolutionLogic': originalSolutionLogic ?? 'Analiz et',
        'subject': subject,
        'topic': topic,
        'uiLanguage': uiLanguage,
      });

      final response = await _proModel.generateContent([Content.text(generationPrompt)]);
      final rawOutput = response.text;
      if (rawOutput == null || rawOutput.isEmpty) throw Exception('Üretim başarısız');

      // 🚨 CRITIQUE ADIMI KALDIRILDI - %50 TASARRUF
      // Eşleştirme ve doğrulama prompt içine dahil edildi
      final finalOutput = rawOutput;

      // ✅ İşlem başarılı
      await _pointsService.spendPoints('similar_question', description: '$topic konusu için Pro Model Soru Üretimi');

      final jsonData = _extractJsonMap(finalOutput);
      if (jsonData == null) throw Exception('JSON ayrıştırma hatası');
      
      final List<dynamic> clonedList = jsonData['cloned_questions'] ?? jsonData['questions'] ?? [];

      final aiGenerated = clonedList.map((item) => SimilarQuestion(
        question: item['text'] ?? '',
        correctAnswer: item['correct_answer'] ?? '',
        options: (item['options'] as List<dynamic>?)?.cast<String>() ?? [],
        explanation: item['explanation_short'] ?? '',
      )).toList();
      
      // Altın DB + AI sonuçlarını birleştir
      result.addAll(aiGenerated);
      
      return result.take(count).toList();
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Pro Soru Üretme Hatası: $e');
      rethrow; // Hatayı yukarı fırlat, UI'da gösterilsin
    }
  }

  /// 📊 MASTER ANALYST - Premium Sherlock Holmes Akademik Analiz
  Future<MasterAnalysis?> getAIAnalysis({
    required List<Map<String, dynamic>> activityLog,
    Map<String, double>? topicPerformance,
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('personal_analysis');
    
    final dna = await _dnaService.getDNA();
    if (dna == null) {
      debugPrint('⚠️ DNA verisi bulunamadı, analiz yapılamıyor');
      return null;
    }
    
    // 📋 TEMEL PROFİL BİLGİLERİ
    final userName = 'Öğrenci';
    final userLevel = dna.gradeLevel ?? '9. Sınıf';
    final targetExam = dna.targetExam ?? 'Genel Sınav';
    final learningStyle = dna.learningStyle ?? 'Görsel';
    final totalQuestions = dna.totalQuestionsSolved.toString();
    final overallSuccess = (dna.overallSuccessRate * 100).toInt().toString();
    
    // 📊 KONU BAZLI PERFORMANS (Gerçek DNA verileri)
    final topicPerfBuffer = StringBuffer();
    if (dna.topicPerformance.isNotEmpty) {
      dna.topicPerformance.forEach((topic, perf) {
        final successRate = (perf.successRate * 100).toInt();
        final trend = perf.consecutiveCorrect >= 3 ? '🔥' : '';
        topicPerfBuffer.writeln('- $topic: %$successRate ($trend${perf.correct}/${perf.totalQuestions} doğru)');
      });
    } else {
      topicPerfBuffer.writeln('Henüz konu verisi yok');
    }
    
    // 📝 HATALI SORULAR LOGU (Gerçek DNA verileri)
    final errorLogBuffer = StringBuffer();
    if (dna.failedQuestions.isNotEmpty) {
      for (final q in dna.failedQuestions.take(5)) {
        errorLogBuffer.writeln('- ${q.topic}/${q.subTopic}: ${q.failureReason ?? "Belirsiz hata"}');
        if (q.keyConceptsMissing != null && q.keyConceptsMissing!.isNotEmpty) {
          errorLogBuffer.writeln('  Eksik kavramlar: ${q.keyConceptsMissing!.join(", ")}');
        }
      }
    } else {
      errorLogBuffer.writeln('Henüz hatalı soru kaydı yok');
    }
    
    // 🚨 HATA DESENLERİ (Gerçek DNA verileri)
    final errorPatternsBuffer = StringBuffer();
    if (dna.errorPatterns.isNotEmpty) {
      final sortedPatterns = dna.errorPatterns.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final pattern in sortedPatterns.take(5)) {
        errorPatternsBuffer.writeln('- ${pattern.key}: ${pattern.value} kez');
      }
    } else {
      errorPatternsBuffer.writeln('Henüz hata deseni tespit edilmedi');
    }
    
    // ⚠️ ZAYIF KONULAR (Gerçek DNA verileri)
    final weakTopicsBuffer = StringBuffer();
    if (dna.weakTopics.isNotEmpty) {
      for (final weak in dna.weakTopics.take(5)) {
        final successRate = (weak.successRate * 100).toInt();
        weakTopicsBuffer.writeln('- ${weak.subTopic} (%$successRate) - ${weak.recommendations.isNotEmpty ? weak.recommendations.first : "Pratik gerekli"}');
      }
    } else {
      weakTopicsBuffer.writeln('Zayıf konu tespit edilmedi');
    }
    
    // ✅ GÜÇLÜ KONULAR (Gerçek DNA verileri)
    final strongTopicsBuffer = StringBuffer();
    if (dna.strongTopics.isNotEmpty) {
      strongTopicsBuffer.writeln(dna.strongTopics.take(5).join(', '));
    } else {
      strongTopicsBuffer.writeln('Henüz güçlü konu belirlenmedi');
    }

    try {
      final prompt = _promptRegistry.getPrompt('master_analysis', variables: {
        'userName': userName,
        'userLevel': userLevel,
        'targetExam': targetExam,
        'learningStyle': learningStyle,
        'totalQuestions': totalQuestions,
        'overallSuccess': overallSuccess,
        'topicPerformanceDetailed': topicPerfBuffer.toString(),
        'errorLog': errorLogBuffer.toString(),
        'errorPatterns': errorPatternsBuffer.toString(),
        'weakTopics': weakTopicsBuffer.toString(),
        'strongTopics': strongTopicsBuffer.toString(),
        'uiLanguage': uiLanguage,
      });

      final response = await _proModel.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('personal_analysis', description: 'Sherlock Holmes akademik analiz raporu');

      final jsonData = _extractJsonMap(text);
      if (jsonData == null) throw Exception('Ayrıştırılabilir JSON bulunamadı');
      
      final insight = jsonData['insight_card'] as Map<String, dynamic>? ?? {};
      final topicBreakdown = jsonData['topic_breakdown'] as List<dynamic>? ?? [];
      final actionPlanList = jsonData['action_plan'] as List<dynamic>? ?? [];
      final radarData = jsonData['radar_data'] as List<dynamic>? ?? [];

      // Topic Breakdown parse
      final topicBreakdownParsed = topicBreakdown.map((t) => TopicBreakdown(
        topic: t['topic'] ?? '',
        statusEmoji: t['status_emoji'] ?? '🔵',
        successRate: (t['success_rate'] ?? 0).toDouble(),
        comment: t['comment'] ?? '',
      )).toList();

      // Action Plan parse
      final actionPlanParsed = actionPlanList.map((a) => ActionStep(
        step: a['step'] ?? 1,
        task: a['task'] ?? '',
        durationMinutes: a['duration_minutes'] ?? 10,
        priority: a['priority'] ?? 'bugün',
        icon: a['icon'] ?? '📌',
      )).toList();

      // Radar chart parse
      final radarDataParsed = radarData.map((d) => ChartDataPoint(
        label: d['category'] ?? '',
        value: (d['score'] ?? 0).toDouble(),
      )).toList();

      return MasterAnalysis(
        headline: insight['headline'] ?? '',
        headlineEmoji: insight['headline_emoji'] ?? '🔍',
        deepAnalysis: insight['deep_analysis'] ?? '',
        rootCauseTag: insight['root_cause_tag'] ?? '',
        confidenceScore: insight['confidence_score'] ?? 0,
        analysisQuality: insight['analysis_quality'] ?? 'medium',
        topicBreakdown: topicBreakdownParsed,
        actionPlan: actionPlanParsed,
        motivationQuote: jsonData['motivation_quote'] ?? '',
        radarChartData: radarDataParsed,
        nextReviewDate: jsonData['next_review_date'] ?? '',
        studentLevelTag: jsonData['student_level_tag'] ?? '',
        // Backward compatibility
        progressChartData: [],
      );
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Master analiz hatası: $e');
      return null;
    }
  }

  /// 🦉 SOCRATIC TUTOR - Yol Gösterici / İpucu Modu
  Future<SocraticSession?> socraticHint({
    required String questionText,
    List<String>? chatHistory,
    int currentStep = 1,
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('socratic_mode');
    
    final dna = await _dnaService.getDNA();
    final userLevel = dna?.gradeLevel ?? '9. Sınıf';
    
    final historyText = chatHistory?.join('\n') ?? 'İlk adım';

    final cognitiveContext = await _getGlobalCognitiveContext(filter: 'solver');
    final persona = await _getPersonaSegment(userLevel, isSocratic: true);
    final selfCorrection = _getSelfCorrectionAudit();

    try {
      final prompt = _promptRegistry.getPrompt('socratic_hint', variables: {
        'cognitiveContext': cognitiveContext,
        'persona': persona,
        'questionText': questionText,
        'historyText': historyText,
        'currentStep': currentStep.toString(),
        'selfCorrection': selfCorrection,
        'uiLanguage': uiLanguage,
      });

      final response = await _model.generateContent([Content.text(prompt)]); // ⚡ Flash 2.5 (Pro gereksiz)
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('socratic_mode', description: 'Sokratik mod ipucu');

      final jsonData = _extractJsonMap(text);
      if (jsonData == null) throw Exception('Ayrıştırılabilir JSON bulunamadı');
      final status = jsonData['session_status'] as Map<String, dynamic>? ?? {};

      return SocraticSession(
        isSolved: status['is_solved'] ?? false,
        stepNumber: status['step_number'] ?? 1,
        totalStepsEstimated: status['total_steps_estimated'] ?? 4,
        hintType: status['hint_type'] ?? 'question',
        tutorMessage: jsonData['tutor_message'] ?? '',
      );
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Sokratik ipucu hatası: $e');
      return null;
    }
  }

  /// 🧠 ORTAK PROBLEM TESPİTİ - Aynı konudaki 3+ soruda ortak hata bulma
  /// Bu metod mikro ders öncesinde çağrılır ve öğrencinin spesifik takılma noktasını tespit eder.
  Future<CommonStruggleResult?> analyzeCommonStruggle({
    required String topic,
    required String subTopic,
    required List<String> questionSummaries,
  }) async {
    await initialize();
    
    if (questionSummaries.length < 3) {
      debugPrint('⚠️ Ortak analiz için en az 3 soru gerekli');
      return null;
    }

    try {
      final prompt = _promptRegistry.getPrompt('common_struggle_analyzer', variables: {
        'topic': topic,
        'subTopic': subTopic,
        'questionSummaries': questionSummaries.asMap().entries
            .map((e) => '${e.key + 1}. ${e.value}')
            .join('\n'),
      });

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        return null;
      }

      final jsonData = _extractJsonMap(text);
      if (jsonData == null) return null;
      
      final struggle = jsonData['common_struggle'] as Map<String, dynamic>? ?? {};

      return CommonStruggleResult(
        specificWeakness: struggle['specific_weakness']?.toString() ?? '',
        patternDetected: struggle['pattern_detected']?.toString() ?? '',
        microLessonFocus: struggle['micro_lesson_focus']?.toString() ?? subTopic,
      );
    } catch (e) {
      debugPrint('❌ Ortak problem analizi hatası: $e');
      return null;
    }
  }

  /// 💊 MICRO-LESSON GENERATOR - Nokta Atışı Ders Anlatıcısı
  Future<MicroLesson?> generateMicroLesson({
    required String topic,
    List<String>? knownConcepts,
    List<String>? strugglePoints,
    List<String>? interests,
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('micro_lesson');
    
    final dna = await _dnaService.getDNA();
    
    final userInterests = interests ?? dna?.interests ?? ['spor', 'oyunlar', 'günlük hayat'];
    final studentLevel = dna?.gradeLevel ?? 'Lise';
    final examTarget = dna?.targetExam ?? 'Genel';

    try {
      // 🔬 Konu + Seviye + İlgi alanları - kusursuz harmanlama
      final prompt = _promptRegistry.getPrompt('micro_lesson', variables: {
        'topic': topic,
        'interests': userInterests.join(', '),
        'studentLevel': studentLevel,
        'targetExam': examTarget,
        'uiLanguage': uiLanguage,
        'focus_areas': strugglePoints != null && strugglePoints.isNotEmpty 
            ? strugglePoints.join(', ') 
            : 'Genel tekrar ve eksik kapatma',
        'known_concepts': knownConcepts != null && knownConcepts.isNotEmpty 
            ? knownConcepts.join(', ') 
            : 'Belirtilmedi',
      });

      final response = await _proModel.generateContent([Content.text(prompt)]);
      final text = response.text;

      debugPrint('🔍 MICRO-LESSON RAW RESPONSE:\n$text\n-----------------------------------'); // DEBUG LOG

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      final jsonData = _extractJsonMap(text);
      if (jsonData == null) throw Exception('Ayrıştırılabilir JSON bulunamadı');
      final card = jsonData['lesson_card'] as Map<String, dynamic>? ?? {};

      // ✅ İşlem başarılı - şimdi puanı düş (Sadece başarılı çözümde)
      await _pointsService.spendPoints('micro_lesson', description: '$topic Micro-Lesson üretimi');

      return MicroLesson(
        title: card['title'] ?? topic,
        greeting: card['greeting'] ?? '',
        coreExplanation: card['core_explanation'] ?? '',
        analogyUsed: card['analogy_used'] ?? '',
        quickCheckQuestion: card['quick_check_question'] ?? '',
      );
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Micro-Lesson hatası: $e');
      return null;
    }
  }


  /// 🧠 COGNITIVE DIAGNOSTIC - Neden yanlış yaptım analizi
  Future<CognitiveDiagnosis?> analyzeUserThinking({
    required String questionText,
    required String correctSolution,
    required String userWrongChoice,
    required String userExplanation,
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('detailed_explain');
    
    final dna = await _dnaService.getDNA();

    final cognitiveContext = await _getGlobalCognitiveContext(filter: 'solver');
    final selfCorrection = _getSelfCorrectionAudit();

    try {
      final prompt = _promptRegistry.getPrompt('cognitive_diagnosis', variables: {
        'questionText': questionText,
        'correctSolution': correctSolution,
        'userExplanation': userExplanation,
        'cognitiveContext': cognitiveContext,
        'selfCorrection': selfCorrection,
        'uiLanguage': uiLanguage,
      });

      final response = await _proModel.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('detailed_explain', description: 'Düşünce dedektifi hata analizi');

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) throw Exception('Ayrıştırılabilir JSON bulunamadı');
      final jsonData = jsonDecode(jsonMatch.group(0)!);
      final diagnosis = jsonData['diagnosis'] as Map<String, dynamic>? ?? {};
      final feedback = jsonData['feedback'] as Map<String, dynamic>? ?? {};

      return CognitiveDiagnosis(
        errorType: diagnosis['error_type'] ?? 'UNKNOWN',
        isLogicPartiallyCorrect: diagnosis['is_logic_partially_correct'] ?? false,
        confidenceScore: diagnosis['confidence_score'] ?? 0,
        breakdownPoint: diagnosis['breakdown_point'] ?? '',
        validationText: feedback['validation_text'] ?? '',
        correctionText: feedback['correction_text'] ?? '',
        coachTip: feedback['coach_tip'] ?? '',
      );
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Bilişsel analiz hatası: $e');
      return null;
    }
  }

  /// 📝 NOTE ORGANIZER - Ders Notu Düzenleyici (v3 - KALE GİBİ SAĞLAM)
  /// 
  /// Bu sistem karmaşık el yazısı notlarını:
  /// 1. Madde madde ayrıştırır
  /// 2. Önemli kısımları **kalın** yapar
  /// 3. En sonda kısa özet verir
  Future<Map<String, String>?> organizeStudentNotes(Uint8List imageBytes, {String uiLanguage = 'TR'}) async {
    await initialize();
    await _checkPoints('organize_note');

    try {
      // 🔒 Şema tanımı (model bu iskeletin dışına çıkamaz)
      final noteAnalysisSchema = Schema.object(
        properties: {
          'baslik': Schema.string(
            description: "Notların genel konusu veya kağıdın başlığı (yoksa 'Genel Notlar' de)",
          ),
          'ozet': Schema.string(
            description: "Notlarda anlatılanların 1-2 cümlelik kısa, net özeti",
          ),
          'aksiyon_maddeleri': Schema.array(
            description: "Notlardan çıkarılan, yapılması gereken net görevler listesi",
            items: Schema.object(
              properties: {
                'kategori': Schema.string(
                  description: "Maddenin kategorisi (Örn: Yazılım, Pazarlama, Fikir, Hata)",
                ),
                'icerik': Schema.string(
                  description: "Maddenin temizlenmiş, anlaşılır metni",
                ),
                'oncelik': Schema.enumString(
                  description: "İçeriğe göre tahmin edilen önem derecesi",
                  enumValues: ['Yüksek', 'Orta', 'Düşük'],
                ),
              },
              requiredProperties: ['kategori', 'icerik'],
            ),
          ),
        },
        requiredProperties: ['baslik', 'aksiyon_maddeleri'],
      );

      // 🔑 API key (initialize sonrası dolu olmalı)
      final noteApiKey = _apiKey ?? dotenv.env['GEMINI_API_KEY'];
      if (noteApiKey == null || noteApiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY bulunamadı (note organizer)');
      }

      // 🧠 Şemalı model (yalnızca not düzenleme için)
      final noteModel = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: noteApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.1,
          responseMimeType: 'application/json',
          responseSchema: noteAnalysisSchema,
        ),
      );

      // 🏰 PROMPT v15 - START/END JSON AYRAÇLI (başka metin yok)
      final prompt = '''
Görseldeki el yazısı notlarını oku. TÜM yazıları oku, hiçbir satırı atlama.

Yazım hatalarını düzelt, önemli kelimeleri **kalın** yap, "1-", "2-", "3-" formatında düzenle.

YANIT: SADECE AŞAĞIDAKİ GİBİ JSON. START_JSON ve END_JSON ayraçları arasında ver, başka hiçbir metin ekleme.
START_JSON
{"title":"başlık","content":"1- madde\\n\\n2- madde\\n\\n3- madde","summary":"özet"}
END_JSON

"Here is the JSON requested" gibi cümleler yazma. Kod bloğu, etiket, açıklama ekleme. SADECE JSON ve sadece ayraç içinde.
Dil: $uiLanguage
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      // 🖼️ Şema kısıtlı model kullan
      final response = await noteModel.generateContent(content);
      String? rawText = response.text;
      
      if (rawText == null || rawText.isEmpty) {
        debugPrint('❌ Not düzenleme: Model boş yanıt döndü.');
        return null;
      }

      debugPrint('📥 Not düzenleme v3 - Yanıt (ilk 500 karakter): ${rawText.substring(0, rawText.length.clamp(0, 500))}');

      // 🧩 Şema tabanlı parse (baslik, ozet, aksiyon_maddeleri)
      Map<String, String>? finalResult;
      final schemaMap = _extractJsonMap(rawText);
      if (schemaMap != null && (schemaMap.containsKey('baslik') || schemaMap.containsKey('aksiyon_maddeleri'))) {
        try {
          finalResult = _buildNoteFromSchema(schemaMap);
          debugPrint('✅ Şema bazlı parse başarılı');
        } catch (e) {
          debugPrint('⚠️ Şema parse hatası: $e');
        }
      }

      // 🏰 Eski parser + fallback
      finalResult ??= _parseOrganizedNote(rawText);
      finalResult ??= {
        'title': 'Düzenlenmiş Not',
        'content': _defaultFallbackContent(rawText),
      };

      // ✅ İşlem başarılı - puan harca
      await _pointsService.spendPoints('organize_note', description: 'Ders Notu Düzenleme');
      debugPrint('✅ Not düzenleme başarılı! Başlık: ${finalResult['title']}');

      return finalResult;
    } catch (e) {
      debugPrint('❌ Not düzenleme hatası: $e');
      return null;
    }
  }

  /// 🏰 KALE GİBİ SAĞLAM PARSER - Not çıktısını parse eder
  Map<String, String>? _parseOrganizedNote(String rawText) {
    String title = 'Düzenlenmiş Not';
    String content = '';
    
    // 1️⃣ Temizlik - kod bloklarını temizle
    String cleanText = rawText
        .replaceAll(RegExp(r'^```\w*\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s*```\s*$', multiLine: true), '')
        .trim();
    
    // 2️⃣ JSON bul - önce START/END ayraçları
    String? jsonText;
    
    final markerMatch = RegExp(r'START_JSON\s*(\{[\s\S]*?\})\s*END_JSON', caseSensitive: false)
        .firstMatch(cleanText);
    if (markerMatch != null) {
      jsonText = markerMatch.group(1);
      debugPrint('🔍 JSON bulundu (marker içinde, ${jsonText?.length ?? 0} karakter)');
    }
    
    // Marker yoksa gereksiz prefix'leri temizleyerek ara
    String searchText = (jsonText == null ? cleanText : '')
        .replaceAll(RegExp(r'Here is the JSON requested:?', caseSensitive: false), '')
        .replaceAll(RegExp(r'Here is the JSON:?', caseSensitive: false), '')
        .replaceAll(RegExp(r'JSON requested:?', caseSensitive: false), '')
        .trim();
    
    // JSON'u bul - en uzun JSON objesini al (marker yoksa)
    if (jsonText == null && searchText.isNotEmpty) {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(searchText);
      if (jsonMatch != null) {
        jsonText = jsonMatch.group(0);
        debugPrint('🔍 JSON bulundu (${jsonText?.length ?? 0} karakter)');
      } else if (searchText.trim().startsWith('{')) {
        // Eğer başlangıçta { varsa, son }'a kadar al
        final lastBrace = searchText.lastIndexOf('}');
        if (lastBrace > 0) {
          jsonText = searchText.substring(0, lastBrace + 1);
          debugPrint('🔍 JSON bulundu (başlangıçtan, ${jsonText?.length ?? 0} karakter)');
        }
      }
    }
    
    // 3️⃣ JSON döndüyse parse et
    if (jsonText != null) {
      final textToParse = jsonText;
      try {
        final jsonMap = _extractJsonMap(textToParse);
        if (jsonMap != null) {
          debugPrint('🔍 JSON keys: ${jsonMap.keys.toList()}');
          
          // Dinamik key arama - her key'i kontrol et
          for (final key in jsonMap.keys) {
            final keyLower = key.toString().toLowerCase();
            final value = jsonMap[key]?.toString().trim() ?? '';
            
            if (value.isEmpty) continue;
            
            // Başlık key'leri
            if (keyLower.contains('başlık') || keyLower.contains('baslik') || keyLower == 'title') {
              title = value;
              debugPrint('✅ Başlık bulundu: $title');
            }
            
            // İçerik key'leri
            if (keyLower.contains('içerik') || keyLower.contains('icerik') || 
                keyLower.contains('madde') || keyLower.contains('content') ||
                keyLower.contains('organized')) {
              content = value;
              debugPrint('✅ İçerik bulundu (${value.length} karakter)');
            }
            
            // Özet key'leri
            if (keyLower.contains('özet') || keyLower.contains('ozet') || keyLower.contains('summary')) {
              if (content.isNotEmpty && !content.contains('ÖZET') && !content.contains('Özet')) {
                content += '\n\n---\n\n📌 **ÖZET:** $value';
              }
            }
          }
          
          if (content.isNotEmpty) {
            debugPrint('✅ JSON parse başarılı');
            // Maddeleri alt alta yap
            content = _formatContentWithNewlines(content);
            return {'title': _cleanTitle(title), 'content': content};
          }
        }
      } catch (e) {
        debugPrint('⚠️ JSON parse başarısız: $e');
      }
    }
    
    // 4️⃣ ---BAŞLIK--- ayracını ara
    final baslikMatch = RegExp(r'---BAŞLIK---\s*\n?(.+?)(?=\n---|\n\d+\.|\n•|$)', dotAll: true).firstMatch(cleanText);
    if (baslikMatch != null) {
      title = baslikMatch.group(1)?.trim() ?? title;
    }
    
    // 5️⃣ ---MADDELER--- bölümünü al
    final maddelerMatch = RegExp(r'---MADDELER---\s*\n?([\s\S]*?)(?=---ÖZET---|$)', dotAll: true).firstMatch(cleanText);
    if (maddelerMatch != null) {
      content = maddelerMatch.group(1)?.trim() ?? '';
    }
    
    // 6️⃣ ---ÖZET--- bölümünü al ve ekle
    final ozetMatch = RegExp(r'---ÖZET---\s*\n?(.+?)$', dotAll: true).firstMatch(cleanText);
    if (ozetMatch != null) {
      final ozet = ozetMatch.group(1)?.trim() ?? '';
      if (ozet.isNotEmpty) {
        content += '\n\n---\n📌 **ÖZET:** $ozet';
      }
    }
    
    // 7️⃣ Ayraçlar bulunamadıysa fallback
    if (content.isEmpty) {
      debugPrint('⚠️ Ayraçlar bulunamadı, fallback kullanılıyor...');
      
      // Numaralı maddeleri bul (1. 2. 3. ... veya 1- 2- 3- ...)
      final numberedDot = RegExp(r'^\d+\.\s*.+$', multiLine: true).allMatches(cleanText);
      final numberedDash = RegExp(r'^\d+-\s*.+$', multiLine: true).allMatches(cleanText);
      
      if (numberedDash.isNotEmpty) {
        content = numberedDash.map((m) => m.group(0)).join('\n\n');
        
        // İlk satırı başlık olarak al (numaralı değilse)
        final firstLine = cleanText.split('\n').first.trim();
        if (!firstLine.startsWith(RegExp(r'\d+-'))) {
          title = firstLine.replaceAll(RegExp(r'^[#*\-]+\s*'), '');
        }
      } else if (numberedDot.isNotEmpty) {
        content = numberedDot.map((m) => m.group(0)).join('\n\n');
        
        // İlk satırı başlık olarak al (numaralı değilse)
        final firstLine = cleanText.split('\n').first.trim();
        if (!firstLine.startsWith(RegExp(r'\d+\.'))) {
          title = firstLine.replaceAll(RegExp(r'^[#*\-]+\s*'), '');
        }
      } else {
        // Son çare: tüm metni al
        content = cleanText;
        final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (lines.isNotEmpty) {
          title = lines.first.replaceAll(RegExp(r'^[#•\-*]+\s*'), '').trim();
          if (lines.length > 1) {
            content = lines.sublist(1).join('\n').trim();
          }
        }
      }
    }
    
    // 8️⃣ İçerik kontrolü (fallback)
    if (content.isEmpty || content.length < 10) {
      debugPrint('❌ İçerik çok kısa veya boş, fallback format uygulanıyor');
      content = _defaultFallbackContent(cleanText);
    }
    
    // 9️⃣ Son temizlik
    content = _formatNoteContent(content);
    title = _cleanTitle(title);
    
    return {'title': title, 'content': content};
  }
  
  /// JSON gelmezse veya içerik boşsa basit fallback oluştur
  String _defaultFallbackContent(String raw) {
    final text = raw.trim();
    final lines = text.isEmpty
        ? <String>[]
        : text.split(RegExp(r'\n+')).where((l) => l.trim().isNotEmpty).toList();
    
    if (lines.isEmpty) {
      return '1- **Okuma başarısız** - Görselden metin alınamadı.\n\n---\n📌 **ÖZET:** Görsel okunamadı.';
    }
    
    final numbered = lines.asMap().entries.map((e) {
      final content = e.value.trim();
      final prefix = '${e.key + 1}- ';
      return '$prefix$content';
    }).join('\n\n');
    
    final summary = lines.take(2).join(' ').trim();
    final safeSummary = summary.isNotEmpty ? summary : 'Görsel okunamadı.';
    
    return '$numbered\n\n---\n📌 **ÖZET:** $safeSummary';
  }

  /// Şema tabanlı yanıtı UI için markdown içeriğe dönüştür
  Map<String, String> _buildNoteFromSchema(Map<String, dynamic> data) {
    final title = (data['baslik'] ?? 'Düzenlenmiş Not').toString().trim();
    final summary = data['ozet']?.toString().trim();
    final List<dynamic> items = data['aksiyon_maddeleri'] is List ? data['aksiyon_maddeleri'] as List : [];

    final buffer = StringBuffer();
    for (int i = 0; i < items.length; i++) {
      final item = items[i] as Map<String, dynamic>? ?? {};
      final kategori = (item['kategori'] ?? 'Görev').toString().trim();
      final icerik = (item['icerik'] ?? '').toString().trim();
      final oncelik = item['oncelik']?.toString().trim();

      buffer.write('${i + 1}- **$kategori**: $icerik');
      if (oncelik != null && oncelik.isNotEmpty) {
        buffer.write(' (Öncelik: $oncelik)');
      }
      if (i != items.length - 1) buffer.write('\n\n');
    }

    if (summary != null && summary.isNotEmpty) {
      buffer.write('\n\n---\n📌 **ÖZET:** $summary');
    }

    return {
      'title': title.isEmpty ? 'Düzenlenmiş Not' : title,
      'content': buffer.toString(),
    };
  }
  
  /// Başlığı temizle
  String _cleanTitle(String title) {
    return title
        .replaceAll(RegExp(r'^[#•\-*"]+\s*'), '')
        .replaceAll(RegExp(r'["]+$'), '')
        .replaceAll(RegExp(r'^\{'), '')
        .replaceAll(RegExp(r'\}$'), '')
        .replaceAll("'", '')
        .trim();
  }
  
  /// Not içeriğini formatla
  String _formatNoteContent(String content) {
    // Gereksiz boşlukları temizle
    String formatted = content
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    
    // ÖZET bölümünü güzelleştir (eğer düz yazıldıysa)
    if (!formatted.contains('📌') && formatted.contains(RegExp(r'ÖZET:', caseSensitive: false))) {
      formatted = formatted.replaceAllMapped(
        RegExp(r'ÖZET:\s*(.+?)$', caseSensitive: false, multiLine: true),
        (m) => '---\n📌 **ÖZET:** ${m.group(1)?.trim() ?? ""}',
      );
    }
    
    return formatted;
  }
  
  /// Maddeleri alt alta formatla (yan yana gelenleri ayır)
  String _formatContentWithNewlines(String content) {
    // Numaralı maddeleri alt alta yap: "1. xxx, 2. yyy" → "1. xxx\n\n2. yyy"
    // Veya "1- xxx, 2- yyy" → "1- xxx\n\n2- yyy"
    String formatted = content
        .replaceAllMapped(
          RegExp(r',\s*(\d+[\.-]\s)'),
          (m) => '\n\n${m.group(1)}',
        )
        .replaceAllMapped(
          RegExp(r'(\d+[\.-])\s*\n\s*(\d+[\.-])'),
          (m) => '${m.group(1)}\n\n${m.group(2)}',
        );
    
    // Bullet point'leri de alt alta yap
    formatted = formatted
        .replaceAllMapped(
          RegExp(r',\s*(•\s|[-*]\s)'),
          (m) => '\n\n${m.group(1)}',
        );
    
    // ## başlıklarından önce boşluk ekle
    formatted = formatted.replaceAllMapped(
      RegExp(r'([^\n])(##\s)'),
      (m) => '${m.group(1)}\n\n${m.group(2)}',
    );
    
    return formatted.trim();
  }

  /// 🃏 FLASHCARD GENERATOR - Notlardan Çalışma Kartı Üret
  Future<List<Map<String, String>>?> generateFlashcardsFromNote(String noteContent, {String uiLanguage = 'TR'}) async {
    await initialize();
    // 💎 Puan kontrolü (Benzer soru maliyetiyle aynı sayabiliriz)
    await _checkPoints('similar_question');

    try {
      final prompt = _promptRegistry.getPrompt('flashcard_generator', variables: {
        'noteContent': noteContent,
        'uiLanguage': uiLanguage,
      });

      final response = await _proModel.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) return null;

      final jsonMap = _extractJsonMap(text);
      if (jsonMap == null) return null;
      final List<dynamic> cards = jsonMap['flashcards'] ?? [];

      // İşlem başarılı - puan harca
      await _pointsService.spendPoints('similar_question', description: 'Not üzerinden flashcard üretimi');

      return cards.map((c) => {
        'question': (c['question'] as String? ?? ''),
        'answer': (c['answer'] as String? ?? ''),
      }).toList();
    } catch (e) {
      debugPrint('❌ Flashcard üretme hatası: $e');
      return null;
    }
  }

  /// 🧠 Sokratik Analiz - Öğrencinin karalamasını incele
  Future<Map<String, dynamic>?> analyzeSocraticWork({
    required Uint8List questionImage,
    required Uint8List workImage,
    required int stepNumber,
    String uiLanguage = 'TR',
  }) async {
    await initialize();
    await _checkPoints('socratic_analysis');

    try {
      final prompt = _promptRegistry.getPrompt('socratic_analysis', variables: {
        'stepNumber': stepNumber.toString(),
        'uiLanguage': uiLanguage,
      });

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', questionImage),
          DataPart('image/jpeg', workImage),
        ])
      ];

      final response = await _visionModel.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) return null;

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final data = jsonDecode(jsonMatch.group(0)!);
        await _pointsService.spendPoints('socratic_analysis', description: 'Sokratik Analiz Adım $stepNumber');
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Sokratik analiz hatası: $e');
      return null;
    }
  }

  // =========================================================================
  // HELPER METHODS FOR OTHER SERVICES
  // =========================================================================

  /// 📝 Genel metin üretme - Prompt ile AI'dan yanıt al
  Future<String?> generateContent(String prompt) async {
    try {
      await initialize();
      
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      debugPrint('❌ generateContent hatası: $e');
      return null;
    }
  }

  /// 📊 JSON yanıt üretme - Prompt ile AI'dan JSON al
  Future<Map<String, dynamic>?> generateContentJson(String prompt) async {
    try {
      await initialize();
      
      final response = await _model.generateContent([Content.text(prompt)]);
      final rawText = response.text;
      
      if (rawText == null || rawText.isEmpty) return null;
      
      // JSON ayıkla
      return _extractJsonMap(rawText);
    } catch (e) {
      debugPrint('❌ generateContentJson hatası: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 📚 KÜTÜPHANE - Gemini 2.5 Flash, 4.–12. sınıf müfredat, max 250 karakter
  // ═══════════════════════════════════════════════════════════════

  /// Kütüphane sorusu: Sadece 4.–12. sınıf müfredatı + KPSS genel kültür; max 250 karakter.
  /// Dışında: "Bu bilgiyi veremiyorum, sadece eğitim." (Gemini 2.5 Flash)
  Future<String> answerLibraryQuestion(String userQuestion) async {
    const fallbackMessage = 'Bu bilgiyi veremiyorum, sadece eğitim.';
    const maxLength = 250;

    if (userQuestion.trim().isEmpty) return fallbackMessage;

    try {
      await initialize();

      const systemPrompt = '''
Sen Türkiye eğitim müfredatına uygun bir kütüphane asistanısın. KESİN KURALLAR:

CEVAP VEREBİLECEĞİN ALANLAR (sadece bunlar):
1. 4, 5, 6, 7, 8, 9, 10, 11, 12. sınıf müfredatındaki eğitim konuları (matematik, fen, tarih, coğrafya, Türkçe, edebiyat, biyoloji, kimya, fizik vb.).
2. KPSS genel kültür alanı (tarih, coğrafya, vatandaşlık, güncel olayların eğitimle ilgili yönü, kültür-sanat temel bilgileri).

CEVAP VERMEYECEĞİN:
- Yukarıdaki alanlar dışındaki her şey (siyaset, kişisel tavsiye, müfredat dışı genel kültür, eğlence, sağlık tavsiyesi vb.).
- Bu durumda tek cümle yaz: "Bu bilgiyi veremiyorum, sadece eğitim."

DİĞER KURALLAR:
- Cevabı mutlaka tam ve açıklayıcı ver: tek kelime veya eksik bırakma. Soru ne soruyorsa (tanım, tarih, formül vb.) net cevapla.
- Cevabın kesinlikle 250 karakteri geçmesin. Kısa, net, eğitim odaklı yaz.
- Sadece Türkçe cevap ver.
''';

      final content = Content.text(
        '$systemPrompt\n\nKullanıcı sorusu: $userQuestion\n\nCevabın (max $maxLength karakter; müfredat/KPSS genel kültür dışıysa sadece: Bu bilgiyi veremiyorum, sadece eğitim.):',
      );

      final response = await _libraryModel.generateContent([content]);

      final text = response.text?.trim() ?? '';
      if (text.isEmpty) return fallbackMessage;
      // Model bazen "Here is the JSON requested:" gibi ön ek veriyorsa atla
      final clean = text.startsWith('Here is the JSON requested')
          ? text.replaceFirst(RegExp(r'^Here is the JSON requested[.:]?\s*', caseSensitive: false), '').trim()
          : text;
      if (clean.isEmpty) return fallbackMessage;

      if (clean.length > maxLength) return '${clean.substring(0, maxLength)}…';
      return clean;
    } catch (e) {
      debugPrint('❌ answerLibraryQuestion hatası: $e');
      return fallbackMessage;
    }
  }
}

/// Soru çözüm sonucu - Genişletilmiş
class QuestionSolution {
  final String subject;
  final String topic;
  final String questionText;
  final String solution;
  final String difficulty;
  final List<String> keyConceptsUsed;
  final String? correctAnswer;
  final List<String> tips;
  final String? detectedIntent; // Yeni: Tespit edilen niyet
  final String source; // 'AI' veya 'GoldenDB'
  final double cost; // Tahmini maliyet (TL)

  QuestionSolution({
    required this.subject,
    required this.topic,
    required this.questionText,
    required this.solution,
    required this.difficulty,
    required this.keyConceptsUsed,
    this.correctAnswer,
    this.tips = const [],
    this.detectedIntent,
    this.source = 'AI',
    this.cost = 0.0,
  });
}

/// 🧠 Düşünce Dedektifi - Bilişsel Tanı Sonucu
class CognitiveDiagnosis {
  final String errorType;           // CALCULATION, CONCEPT, READING, LOGIC
  final bool isLogicPartiallyCorrect;
  final int confidenceScore;        // 0-100
  final String breakdownPoint;      // Nerede hata yaptı?
  final String validationText;      // Doğru kısım onayı
  final String correctionText;      // Düzeltme açıklaması
  final String coachTip;            // Koçluk ipucu

  CognitiveDiagnosis({
    required this.errorType,
    required this.isLogicPartiallyCorrect,
    required this.confidenceScore,
    required this.breakdownPoint,
    required this.validationText,
    required this.correctionText,
    required this.coachTip,
  });

  /// Hata tipi açıklaması
  String get errorTypeDescription {
    switch (errorType) {
      case 'CALCULATION':
        return 'İşlem/Dikkatsizlik Hatası';
      case 'CONCEPT':
        return 'Kavram Yanılgısı';
      case 'READING':
        return 'Okuma/Anlama Hatası';
      case 'LOGIC':
        return 'Mantık/Yorum Hatası';
      default:
        return 'Belirsiz';
    }
  }
}

/// 🦉 Sokratik Öğretmen - Oturum Durumu
class SocraticSession {
  final bool isSolved;              // Öğrenci cevabı buldu mu?
  final int stepNumber;             // Kaçıncı adımdayız?
  final int totalStepsEstimated;    // Tahmini toplam adım
  final String hintType;            // question | encouragement | redirect
  final String tutorMessage;        // Yönlendirici soru/mesaj

  SocraticSession({
    required this.isSolved,
    required this.stepNumber,
    required this.totalStepsEstimated,
    required this.hintType,
    required this.tutorMessage,
  });

  /// İlerleme yüzdesi
  double get progressPercentage => 
      (stepNumber / totalStepsEstimated).clamp(0.0, 1.0);
}

/// 💊 Mikro Ders - Kişiselleştirilmiş Konu Anlatımı
class MicroLesson {
  final String title;               // Çarpıcı başlık
  final String greeting;            // Kişiselleştirilmiş giriş
  final String coreExplanation;     // Ana anlatım (Markdown)
  final String analogyUsed;         // Kullanılan metafor
  final String quickCheckQuestion;  // Kontrol sorusu

  MicroLesson({
    required this.title,
    required this.greeting,
    required this.coreExplanation,
    required this.analogyUsed,
    required this.quickCheckQuestion,
  });

  /// JSON'a çevir (Firestore kayıt için)
  Map<String, dynamic> toJson() => {
    'title': title,
    'greeting': greeting,
    'coreExplanation': coreExplanation,
    'analogyUsed': analogyUsed,
    'quickCheckQuestion': quickCheckQuestion,
  };

  /// JSON'dan oluştur (Firestore'dan okuma için)
  factory MicroLesson.fromJson(Map<String, dynamic> json) => MicroLesson(
    title: json['title'] ?? '',
    greeting: json['greeting'] ?? '',
    coreExplanation: json['coreExplanation'] ?? '',
    analogyUsed: json['analogyUsed'] ?? '',
    quickCheckQuestion: json['quickCheckQuestion'] ?? '',
  );
}

/// 🧠 Ortak Problem Analizi Sonucu
class CommonStruggleResult {
  final String specificWeakness;    // Spesifik takılma noktası
  final String patternDetected;     // Hangi sorularda görüldü
  final String microLessonFocus;    // Mikro dersin odaklanacağı konu

  CommonStruggleResult({
    required this.specificWeakness,
    required this.patternDetected,
    required this.microLessonFocus,
  });
}

/// 📊 Master Analysis - Premium Sherlock Holmes Akademik Analiz Raporu
class MasterAnalysis {
  // Temel alanlar
  final String headline;              // Çarpıcı başlık
  final String headlineEmoji;         // Başlık emojisi
  final String deepAnalysis;          // Detaylı analiz
  final String rootCauseTag;          // Kök neden etiketi
  final int confidenceScore;          // Güven skoru (0-100)
  final String analysisQuality;       // high, medium, low
  
  // Yeni premium alanlar
  final List<TopicBreakdown> topicBreakdown;  // Konu bazlı analiz
  final List<ActionStep> actionPlan;          // Zamanlı aksiyon planı
  final String motivationQuote;               // Motivasyon cümlesi
  final List<ChartDataPoint> radarChartData;  // Radar grafik verisi
  final String nextReviewDate;                // Sonraki tekrar tarihi
  final String studentLevelTag;               // Öğrenci seviye etiketi
  
  // Backward compatibility
  final List<ChartDataPoint> progressChartData;

  MasterAnalysis({
    required this.headline,
    this.headlineEmoji = '🔍',
    required this.deepAnalysis,
    required this.rootCauseTag,
    required this.confidenceScore,
    this.analysisQuality = 'medium',
    this.topicBreakdown = const [],
    this.actionPlan = const [],
    this.motivationQuote = '',
    required this.radarChartData,
    this.nextReviewDate = '',
    this.studentLevelTag = '',
    required this.progressChartData,
  });
}

/// 📈 Konu Bazlı Analiz
class TopicBreakdown {
  final String topic;
  final String statusEmoji;     // 🔴 🟡 🟢 🔥
  final double successRate;
  final String comment;

  TopicBreakdown({
    required this.topic,
    required this.statusEmoji,
    required this.successRate,
    required this.comment,
  });
}

/// 🎯 Aksiyon Adımı
class ActionStep {
  final int step;
  final String task;
  final int durationMinutes;
  final String priority;    // bugün, yarın, bu hafta
  final String icon;

  ActionStep({
    required this.step,
    required this.task,
    required this.durationMinutes,
    required this.priority,
    required this.icon,
  });
}

/// Grafik veri noktası
class ChartDataPoint {
  final String label;   // Etiket (Pzt, Matematik, vb.)
  final double value;   // Değer (0-100)

  ChartDataPoint({
    required this.label,
    required this.value,
  });
}
