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
  late GenerativeModel _model;
  late GenerativeModel _proModel; // 💎 Gemini 3 Pro (Mantık ve Test üretimi için)
  late GenerativeModel _visionModel; // 🖼️ Flash Vision (basit görsel sorular)
  late GenerativeModel _proVisionModel; // 🧠 Pro Vision (karmaşık matematik/grafik)
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

    await _promptRegistry.initialize();

    // 🌍 STRICT VISUAL MATH SOLVER - No fluff, just math (Gemini optimized)
    final systemInstruction = Content.system(
      'You are a strict Visual Math Solver. '
      'RULE 1: NO FLUFF. Do not talk about DNA, cognitive gaps, or marketing. Just solve the math. '
      'RULE 2: PIXEL COUNTING. Look at the grid. Identify exactly TWO points where the line crosses grid intersections PERFECTLY. '
      'RULE 3: CALCULATE SLOPE. Use the two points to calculate the slope (m). NEVER GUESS THE SLOPE (e.g. do not assume it is 1 or 2). '
      'RULE 4: OUTPUT JSON. Return the result in JSON format showing the coordinates you found.'
    );

    // 💎 Master Model (General tasks - Gemini 2.0 Flash)
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.0, 
        maxOutputTokens: 2048, // ✅ Makul limit
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '```', '---END---'], // ⚡ Token tasarrufu
      ),
    );

    // 💎 Pro Model (Logic heavy tasks - Gemini 2.5 Flash for high reasoning)
    _proModel = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      // systemInstruction: systemInstruction, // 🚨 İptal: Micro-Lesson için temiz bağlam
      generationConfig: GenerationConfig(
        temperature: 0.0,
        maxOutputTokens: 3072, // Yeterli uzunluk
        // ⚠️ RELAXED MODE: JSON zorlaması kaldırıldı (Truncation sorununu çözmek için)
        // responseMimeType: 'application/json',
        // stopSequences: ['}\n\n', '---END---'],
      ),
    );

    // 🖼️ Vision Model (Simple image tasks - Flash)
    _visionModel = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 2048, // 🚨 4096'dan düşürüldü
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '```', '---END---'],
      ),
    );

    // 🧠 Pro Vision Model (Complex math/graph - Gemini 2.5 Flash)
    _proVisionModel = GenerativeModel(
      model: 'gemini-2.5-flash', 
      apiKey: apiKey,
      systemInstruction: systemInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.0,
        maxOutputTokens: 4096,
        topK: 1,
        responseMimeType: 'application/json',
        stopSequences: ['}\n\n', '---END---'], // JSON bittiğinde dur
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
      
      if (imageBytes != null && imageBytes.isNotEmpty) {
        debugPrint('🚀 Paralel arama başlatılıyor: Altın DB + İnternet');
        
        // Paralel olarak hem hafıza kontrolü hem internet araması başlat
        final memoryFuture = _memoryService.checkMemory(
          imageBytes: imageBytes,
          questionText: manuallyEnteredText,
          subject: detectedSubject,
        );
        
        // İnternet araması - soru metni varsa veya OCR ile çıkarılırsa başlat
        Future<String?> internetFuture = Future.value(null);
        String? questionTextForSearch = manuallyEnteredText;
        
        // 📝 Soru metni yoksa hızlı OCR yap (görsel sorular için)
        if ((questionTextForSearch == null || questionTextForSearch.isEmpty) && imageBytes != null) {
          debugPrint('📝 Görsel soru - Hızlı OCR başlatılıyor...');
          try {
            // ⚡ Firebase AI Gemini 2.5 Flash kullan - mevcut modeller JSON'a zorlanmış
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
              
              questionTextForSearch = ocrResponse.text?.trim();
            } else {
              // Fallback: eski model
              final ocrResponse = await _model.generateContent([
                Content.multi([
                  TextPart('Bu görseldeki sınav sorusunun metnini oku. JSON kullanma, düz metin yaz.'),
                  DataPart('image/jpeg', imageBytes),
                ]),
              ]).timeout(const Duration(seconds: 4));
              questionTextForSearch = ocrResponse.text?.trim();
            }
            
            if (questionTextForSearch != null && questionTextForSearch.isNotEmpty) {
              // JSON çıktısı gelirse at
              if (questionTextForSearch.startsWith('[') || questionTextForSearch.startsWith('{')) {
                debugPrint('⚠️ OCR JSON döndü, atlanıyor');
                questionTextForSearch = null;
              } else {
                debugPrint('✅ OCR başarılı: ${questionTextForSearch.length > 80 ? '${questionTextForSearch.substring(0, 80)}...' : questionTextForSearch}');
              }
            }
          } catch (e) {
            debugPrint('⚠️ Hızlı OCR hatası: $e');
          }
        }
        
        // Şimdi internet aramasını başlat
        if (questionTextForSearch != null && questionTextForSearch.isNotEmpty) {
          // 🔍 GÜVENLİK VE MALİYET GÜNCELLEMESİ:
          // Google Search (1.22 TL) yerine Gemini 1.5 Pro "Şeytanın Avukatı" (0.07 TL) kullanılıyor
          // Sadece Matematik/Fizik/Kimya için
          
          if (['Mathematics', 'Physics', 'Chemistry'].contains(detectedSubject) ||
              ['Matematik', 'Fizik', 'Kimya'].contains(detectedSubject)) {
             try {
                // Paralel olarak Pro Model Doğrulamasını başlat (Search yerine)
                internetFuture = _validationService.verifyWithProModel(
                  questionText: questionTextForSearch,
                  aiAnswer: '', // AI cevabı henüz yok, sadece doğrulama için metin gönderiliyor
                  subject: detectedSubject,
                );
             } catch (e) {
               debugPrint('⚠️ Pro Model doğrulama başlatılamadı: $e');
             }
          }
        }
        
        // Altın DB sonucunu bekle
        memoryCheck = await memoryFuture;
        
        // ✅ Altın DB'de bulundu - internet sonucu beklenmeden direkt döndür
        if (memoryCheck.foundInGolden && memoryCheck.goldenMatch != null) {
          debugPrint('✅ Altın DB\'den çözüm bulundu! (Maliyet: 0)');
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
            cost: 0.0,
          );
        }
        
        // Altın DB'de bulunamadı - internet sonucunu al (varsa)
        parallelInternetAnswer = await internetFuture;
        if (parallelInternetAnswer != null) {
          debugPrint('🌐 İnternet şık buldu: $parallelInternetAnswer (paralel arama)');
        }
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
          debugPrint('✅ Altın DB\'den çözüm bulundu! (Maliyet: 0)');
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
            cost: 0.0,
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
      // Bu, mevcut akışı BOZMAZ - sadece daha akıllı prompt seçimi yapar
      String promptSubject = detectedSubject;
      
      // OCR text varsa daha doğru konu tespiti yap
      final textForDetection = manuallyEnteredText ?? '';
      if (textForDetection.isNotEmpty) {
        promptSubject = _detectSubjectFromText(textForDetection);
      }
      
      final masterPrompt = await _buildSmartSolverPrompt(
        detectedSubject: promptSubject,
        questionText: textForDetection,
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
      if (manuallyEnteredText != null) {
        parts.add(TextPart('\n--- ÖĞRENCİ NOTU/SORU METNİ ---\n$manuallyEnteredText'));
      }

      final content = [Content.multi(parts)];
      
      // 🧠 AKILLI KONU BAZLI MODEL SEÇİMİ:
      // Karmaşık konular (grafik, türev, integral, limit vb.) → Pro
      // Basit konular (dört işlem, temel geometri) → Flash
      final bool needsProModel = useDeepAnalysis || _isComplexTopic(manuallyEnteredText);
      
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
          if (manuallyEnteredText != null) fbParts.add(fb.TextPart('\n--- ÖĞRENCİ NOTU ---\n$manuallyEnteredText'));
          
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
                questionText: manuallyEnteredText ?? parsedSolution.questionText,
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
      
      // Fallback: Mevcut modeller
      if (finalSolution == null) {
        final GenerativeModel selectedModel;
        if (imageBytes != null && needsProModel) {
          selectedModel = _proVisionModel;
          debugPrint('🧠 Pro Vision Model seçildi (karmaşık görsel soru)');
        } else if (imageBytes != null) {
          selectedModel = _visionModel;
          debugPrint('⚡ Flash Vision Model seçildi (basit görsel soru)');
        } else {
          selectedModel = _model;
          debugPrint('⚡ Flash Model seçildi (metin soru)');
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
          questionText: manuallyEnteredText ?? parsedSolution.questionText,
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
        // Paralelden gelmediyse ve güven düşükse eski yöntemle doğrula
        else if (confidenceScore < 0.85 && finalSolution.questionText.isNotEmpty) {
          debugPrint('🔍 Düşük güven, internet doğrulaması yapılıyor...');
          final validation = await _validationService.validateAnswer(
            questionText: finalSolution.questionText,
            aiAnswer: finalSolution.correctAnswer!,
          );
          
          if (validation.found) {
            internetAnswer = validation.internetAnswer;
            validated = validation.matches;
            debugPrint('🌐 İnternet: ${validation.internetAnswer}, Eşleşme: ${validation.matches}');
            
            if (!validation.matches && validation.internetAnswer != null) {
              debugPrint('⚠️ Çelişki! AI: ${finalSolution.correctAnswer}, İnternet: ${validation.internetAnswer}');
            }
          }
        } else {
          // Yüksek güven → Doğrudan doğrulanmış kabul et
          validated = confidenceScore >= 0.85;
        }
        
        // 🌍 Subject'i İngilizce'ye çevir (global hafıza standardı)
        final normalizedSubject = _memoryService.normalizeSubjectToEnglish(detectedSubject);
        debugPrint('🌍 Subject: $detectedSubject → $normalizedSubject');
        
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
      }
      
      return finalSolution;
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Soru çözme hatası: $e');
      return null;
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
  /// 🌍 Metinden ders/konu tespiti - Genişletilmiş
  String _detectSubjectFromText(String text) {
    final lower = text.toLowerCase();
    
    // =============== SAYISAL DERSLER ===============
    
    // MATEMATİK
    if (lower.contains('türev') || lower.contains('integral') || 
        lower.contains('limit') || lower.contains('fonksiyon') ||
        lower.contains('denklem') || lower.contains('geometri') ||
        lower.contains('üçgen') || lower.contains('çember') ||
        lower.contains('matematik') || lower.contains('sayı') ||
        lower.contains('x=') || lower.contains('x =') ||
        lower.contains('olasılık') || lower.contains('permütasyon') ||
        lower.contains('kombinasyon') || lower.contains('faktoriyel')) {
      return 'Matematik';
    }
    
    // FİZİK
    if (lower.contains('kuvvet') || lower.contains('hareket') || 
        lower.contains('enerji') || lower.contains('elektrik') ||
        lower.contains('manyetik') || lower.contains('dalga') ||
        lower.contains('fizik') || lower.contains('newton') ||
        lower.contains('ivme') || lower.contains('hız') ||
        lower.contains('momentum') || lower.contains('optik') ||
        lower.contains('ışık') || lower.contains('termodinamik')) {
      return 'Fizik';
    }
    
    // KİMYA
    if (lower.contains('element') || lower.contains('bileşik') || 
        lower.contains('reaksiyon') || lower.contains('mol') ||
        lower.contains('asit') || lower.contains('baz') ||
        lower.contains('kimya') || lower.contains('atom') ||
        lower.contains('molekül') || lower.contains('iyon') ||
        lower.contains('organik') || lower.contains('ester') ||
        lower.contains('alkol') || lower.contains('aldehit') ||
        lower.contains('keton') || lower.contains('karboksil') ||
        lower.contains('periyodik') || lower.contains('elektroliz') ||
        lower.contains('çözelti') || lower.contains('derişim') ||
        lower.contains('chemistry') || lower.contains('chemical')) {
      return 'Kimya';
    }
    
    // BİYOLOJİ
    if (lower.contains('hücre') || lower.contains('mitoz') || 
        lower.contains('mayoz') || lower.contains('dna') ||
        lower.contains('rna') || lower.contains('protein') ||
        lower.contains('enzim') || lower.contains('fotosentez') ||
        lower.contains('solunum') || lower.contains('biyoloji') ||
        lower.contains('gen') || lower.contains('kromozom') ||
        lower.contains('kalıtım') || lower.contains('mutasyon') ||
        lower.contains('ekosistem') || lower.contains('besin zinciri')) {
      return 'Biyoloji';
    }
    
    // =============== SÖZEL DERSLER ===============
    
    // TÜRKÇE
    if (lower.contains('paragraf') || lower.contains('anlam') || 
        lower.contains('cümle') || lower.contains('sözcük') ||
        lower.contains('özne') || lower.contains('yüklem') ||
        lower.contains('dil bilgisi') || lower.contains('imla') ||
        lower.contains('noktalama') || lower.contains('türkçe') ||
        lower.contains('edat') || lower.contains('bağlaç') ||
        lower.contains('fiil') || lower.contains('sıfat') ||
        lower.contains('zamir') || lower.contains('zarf') ||
        lower.contains('anlatım bozukluğu') || lower.contains('yazım') ||
        lower.contains('metin') && (lower.contains('aşağıdaki') || lower.contains('yukarıdaki'))) {
      return 'Türkçe';
    }
    
    // EDEBİYAT
    if (lower.contains('şiir') || lower.contains('roman') || 
        lower.contains('hikaye') || lower.contains('divan') ||
        lower.contains('tanzimat') || lower.contains('servet-i fünun') ||
        lower.contains('edebiyat') || lower.contains('edebi') ||
        lower.contains('nazım') || lower.contains('nesir') ||
        lower.contains('aruz') || lower.contains('hece') ||
        lower.contains('masal') || lower.contains('destan')) {
      return 'Edebiyat';
    }
    
    // TARİH
    if (lower.contains('savaş') || lower.contains('antlaşma') || 
        lower.contains('padişah') || lower.contains('sultan') ||
        lower.contains('osmanlı') || lower.contains('cumhuriyet') ||
        lower.contains('atatürk') || lower.contains('inkılap') ||
        lower.contains('tarih') || lower.contains('imparatorluk') ||
        lower.contains('fetih') || lower.contains('milli mücadele') ||
        lower.contains('yüzyıl') || lower.contains('.yy') ||
        lower.contains('medeniyet') || lower.contains('uygarlık')) {
      return 'Tarih';
    }
    
    // COĞRAFYA
    if (lower.contains('iklim') || lower.contains('nüfus') || 
        lower.contains('harita') || lower.contains('koordinat') ||
        lower.contains('enlem') || lower.contains('boylam') ||
        lower.contains('coğrafya') || lower.contains('bölge') ||
        lower.contains('yeraltı') || lower.contains('maden') ||
        lower.contains('göç') || lower.contains('tarım') ||
        lower.contains('akarsu') || lower.contains('dağ') ||
        lower.contains('ova') || lower.contains('plato')) {
      return 'Coğrafya';
    }
    
    // FELSEFE
    if (lower.contains('felsefe') || lower.contains('etik') || 
        lower.contains('ahlak') || lower.contains('varlık') ||
        lower.contains('epistemoloji') || lower.contains('ontoloji') ||
        lower.contains('metafizik') || lower.contains('düşünce') ||
        lower.contains('sokrates') || lower.contains('platon') ||
        lower.contains('aristoteles') || lower.contains('filozof')) {
      return 'Felsefe';
    }
    
    // DİN KÜLTÜRÜ
    if (lower.contains('din') || lower.contains('ibadet') || 
        lower.contains('kuran') || lower.contains('ayet') ||
        lower.contains('hadis') || lower.contains('peygamber') ||
        lower.contains('islam') || lower.contains('namaz') ||
        lower.contains('oruç') || lower.contains('hac')) {
      return 'Din Kültürü';
    }
    
    // İNGİLİZCE
    if (lower.contains('english') || lower.contains('grammar') || 
        lower.contains('tense') || lower.contains('vocabulary') ||
        lower.contains('reading') || lower.contains('writing') ||
        lower.contains('which of the following') ||
        lower.contains('according to the passage')) {
      return 'İngilizce';
    }
    
    return 'Genel';
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

  
  /// 🎯 Karmaşık konu tespiti - Pro model gerektiren konular
  bool _isComplexTopic(String? text) {
    if (text == null || text.isEmpty) return true; // Görsel soru, varsayılan karmaşık
    
    final lowerText = text.toLowerCase();
    
    // 🔴 PRO MODEL GEREKTİREN KONULAR (Karmaşık muhakeme)
    const complexKeywords = [
      // Türev ve İntegral
      'türev', 'derivative', 'f\'(x)', 'f′(x)', 'integral', '∫',
      'limit', 'lim', 'süreklilik', 'continuity',
      // Grafik Analizi
      'grafik', 'graph', 'eğri', 'curve', 'koordinat', 'ızgara', 'grid',
      'maksimum', 'minimum', 'ekstremum', 'tepe', 'çukur',
      // Fonksiyon Analizi  
      'fonksiyon', 'function', 'f(x)', 'g(x)', 'kompozit', 'ters fonksiyon',
      'asimptot', 'asymptote', 'süreksizlik',
      // Trigonometri (ileri)
      'trigonometr', 'sin', 'cos', 'tan', 'cot', 'arcsin', 'arccos',
      // Logaritma ve Üstel
      'logaritma', 'log', 'ln', 'üstel', 'exponential', 'e^',
      // Analitik Geometri (ileri)
      'elips', 'hiperbol', 'parabol', 'konik', 'conic',
      // Diziler ve Seriler
      'dizi', 'seri', 'sequence', 'series', 'yakınsama', 'ıraksama',
      // Olasılık (ileri)
      'permütasyon', 'kombinasyon', 'binom', 'poisson', 'normal dağılım',
    ];
    
    for (final keyword in complexKeywords) {
      if (lowerText.contains(keyword)) {
        debugPrint('🎯 Karmaşık konu tespit edildi: $keyword');
        return true;
      }
    }
    
    return false; // Basit konu - Flash yeterli
  }

  /// Görselden soru çöz - Master Solver ile (solveQuestion'a delegasyon)
  Future<QuestionSolution?> solveQuestionFromImage(Uint8List imageBytes) async {
    return solveQuestion(imageBytes: imageBytes);
  }

  /// Master Response'u parse et - Bulletproof 4.5 + Fallback
  QuestionSolution? _parseMasterResponse(String text) {
    try {
      final jsonMap = _extractJsonMap(text);
      
      // FALLBACK: JSON bulunamadıysa düz metni çözüm olarak kullan
      if (jsonMap == null) {
        debugPrint('⚠️ JSON bulunamadı, düz metin fallback kullanılıyor');
        
        // Son satırdan cevabı çıkarmaya çalış (FINAL ANSWER: E gibi)
        String? extractedAnswer;
        final lines = text.split('\n');
        for (final line in lines.reversed) {
          final upperLine = line.toUpperCase().trim();
          if (upperLine.contains('FINAL ANSWER') || upperLine.contains('CEVAP') || upperLine.contains('ANSWER:')) {
            final match = RegExp(r'[A-E]').firstMatch(upperLine);
            if (match != null) {
              extractedAnswer = match.group(0);
              break;
            }
          }
        }
        
        // 🌍 AKILLI KONU TESPİTİ: Metinden konuyu algıla
        final detectedSubject = _detectSubjectFromText(text);
        final detectedTopic = _detectTopicFromText(text);
        
        return QuestionSolution(
          subject: detectedSubject,
          topic: detectedTopic,
          questionText: '',
          solution: text,
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

      return QuestionSolution(
        subject: (systemData['topic_main'] ?? systemData['subject'] ?? 'Genel').toString(),
        topic: (systemData['topic_sub'] ?? systemData['topic'] ?? 'Genel').toString(),
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

  /// 📝 NOTE ORGANIZER - Ders Notu Düzenleyici
  Future<Map<String, String>?> organizeStudentNotes(Uint8List imageBytes, {String uiLanguage = 'TR'}) async {
    await initialize();
    await _checkPoints('organize_note');

    try {
      final cognitiveContext = await _getGlobalCognitiveContext(filter: 'note');

      final prompt = _promptRegistry.getPrompt('note_organizer', variables: {
        'cognitiveContext': cognitiveContext,
        'uiLanguage': uiLanguage,
      });

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes), // imageQuality kullanıldığı için jpeg göndermek en doğrusu
        ])
      ];

      final response = await _visionModel.generateContent(content);
      final rawText = response.text;
      
      if (rawText == null || rawText.isEmpty) {
        debugPrint('❌ Not düzenleme: Model boş yanıt döndü.');
        return null;
      }

      final jsonData = _extractJsonMap(rawText);
      
      // 🧠 AKILLI AYRIŞTIRMA MANTIĞI:
      // Eğer JSON ayrıştırılamazsa veya beklenen anahtarlar yoksa, 
      // ham metni 'content' olarak kullan.
      String title = 'Düzenlenmiş Not';
      String finalContent = '';

      if (jsonData != null) {
        title = (jsonData['title'] ?? 
                 jsonData['baslik'] ?? 
                 jsonData['subject'] ?? 
                 'Düzenlenmiş Not').toString();
        
        final dynamic rawContent = jsonData['organized_content'] ?? 
                                  jsonData['content'] ?? 
                                  jsonData['icerik'] ??
                                  jsonData['not_icerigi'] ??
                                  jsonData['message'] ??
                                  jsonData['display_response'] ??
                                  jsonData['text'];
        
        if (rawContent != null) {
          if (rawContent is String) {
            finalContent = rawContent;
          } else {
            // Eğer içerik bir nesne veya listeyse JSON string'e çevir veya join et
            finalContent = jsonEncode(rawContent);
          }
        }

        // Eğer hala boşsa ve model tüm JSON'ı bir özet gibi verdiyse
        if (finalContent.isEmpty && jsonData.length > 2) {
          finalContent = jsonData.values.map((v) => v.toString()).join('\n\n');
        }
      }

      // Eğer hala boşsa, ham metni temizle ve kullan (JSON değilse bile)
      if (finalContent.isEmpty && rawText.isNotEmpty) {
        // Eğer rawText JSON ise ama içinden veri çıkmadıysa, 
        // rawText'in kendisini content'e yazmak yerine başlığı bulmaya çalışalım
        if (rawText.trim().startsWith('{')) {
          finalContent = rawText; // En azından bir şey gösterelim
        } else {
          finalContent = rawText;
        }
      }
      
      // İşlem başarılı - puan harca
      await _pointsService.spendPoints('organize_note', description: 'Ders Notu Düzenleme');

      return {
        'title': title,
        'content': finalContent,
      };
    } catch (e) {
      debugPrint('❌ Not düzenleme hatası: $e');
      return null;
    }
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
