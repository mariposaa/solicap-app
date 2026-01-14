/// SOLICAP - Gemini Service
/// AI ile soru çözme ve benzer soru üretme - Master Solver Entegrasyonu

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/question_model.dart';
import 'user_dna_service.dart';
import 'points_service.dart';

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
  late GenerativeModel _visionModel;
  bool _isInitialized = false;
  
  final UserDNAService _dnaService = UserDNAService();
  final PointsService _pointsService = PointsService();

  // ═══════════════════════════════════════════════════════════════
  // 🧠 MASTER AI SEGMENT MOTORU (Token Tasarrufu & Derin DNA)
  // ═══════════════════════════════════════════════════════════════

  /// Öğrencinin "Bilişsel Haritası"nı (Global Context) oluşturur
  Future<String> _getGlobalCognitiveContext() async {
    final dna = await _dnaService.getDNA();
    if (dna == null) return '# CONTEXT: Yeni Öğrenci';

    final now = DateTime.now();
    final hour = now.hour;
    
    // Zaman bazlı bağlam (Günün saati AI tonunu etkiler)
    String timeContext = 'Gündüz (Aktif Öğrenme)';
    if (hour >= 22 || hour <= 5) timeContext = 'Gece (Odaklanmış/Dingin Öğrenme)';
    else if (hour >= 18) timeContext = 'Akşam (Tekrar/Pekiştirme)';

    // Atomik Bilgi Haritası Özeti
    final strong = dna.strongTopics.take(3).join(', ');
    final weak = dna.weakTopics.map((w) => w.subTopic).take(3).join(', ');
    final patterns = dna.errorPatterns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topError = patterns.isNotEmpty ? patterns.first.key : 'Belirlenmedi';

    return '''
# BİLİŞSEL PROFİL:
- Seviye: ${dna.gradeLevel ?? 'Belirlenmedi'} (${dna.targetExam ?? 'Genel'})
- Dominant Stil: ${dna.learningStyle ?? 'Görsel'} | Motivasyon: ${dna.motivationLevel ?? 'Normal'}
- Başarı: %${(dna.overallSuccessRate * 100).toInt()} (Soru: ${dna.totalQuestionsSolved})
- Güçlü Alanlar: [$strong] | Zayıf Alanlar: [$weak]
- Kritik Hata Deseni: $topError
- Zaman Bağlamı: $timeContext
''';
  }

  /// Göreve özel persona segmentini döner (Token tasarrufu için modüler)
  String _getPersonaSegment(String level, {bool isSocratic = false}) {
    // Seviyeyi standardize et
    final l = level.toLowerCase();
    
    if (isSocratic) {
      if (l.contains('ilkokul') || l.contains('ortaokul')) {
        return 'PERSONA: "Meraklı Dedektif" | Tarz: Oyunlaştırılmış, somutlaştırıcı, çok sabırlı.';
      } else if (l.contains('üniversite') || l.contains('akademik')) {
        return 'PERSONA: "Sokratik Mentör" | Tarz: Terminolojik, hipotez kurduran, derin mantık sorgulayan.';
      }
      return 'PERSONA: "Stratejik Koç" | Tarz: Sınav odaklı, hatırlatıcı, "Recall" tetikleyici.';
    }

    if (l.contains('ilkokul') || l.contains('ortaokul')) {
      return 'PERSONA: "Oyun Arkadaşı" | Ton: Enerjik, basit emojili, metaforik (Elma/Pasta).';
    } else if (l.contains('üniversite') || l.contains('akademik')) {
      return 'PERSONA: "Akademik Rehber" | Ton: Profesyonel, ciddi, neden-sonuç temelli.';
    }
    return 'PERSONA: "Sınav Uzmanı" | Ton: Net, taktiksel, "Burası çıkar" odaklı.';
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

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı!');
    }

    _model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 2048,
      ),
    );

    _visionModel = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.5,
        maxOutputTokens: 4096,
      ),
    );

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
  Future<String> _buildMasterSolverPrompt() async {
    final cognitiveContext = await _getGlobalCognitiveContext();
    final selfCorrection = _getSelfCorrectionAudit();

    return '''
GÖREV TANIMI: Sen SOLICAP CORE INTELLIGENCE motorusun. Görevin, gönderilen soruyu çözmek ve öğrencinin DNA'sındaki bilişsel boşlukları kapatacak şekilde anlatmaktır.

$cognitiveContext

#GÖREV: Sen SOLICAP'in "Master Soru Çözücü" osun.
STRATEJİ:
1. "DEEP LOGIC": Soruyu sadece çözme, bir öğretmen gibi her adımı (formül, mantık, sadeleşme) tane tane açıkla. Kısa kesme, kapsamlı bir Markdown anlatımı oluştur.
2. "CONTEXTUAL VISION": Görseldeki her detayı (ızgara kareleri, renkler, grafiklerin eğimi) matematiksel veriye dönüştür. Eksenler yoksa birim kareleri koordinat sistemiymiş gibi kullan.
3. "DOUBLE-CHECK": Yanıtı vermeden önce mutlaka Öz-Denetim protokolünü çalıştır.
4. "UNCERTAINTY HANDLING": Eğer görsel çok bulanıksa, veriler eksikse veya soruyu kesinlikle çözemiyorsan; "display_response" kısmına neden çözemediğini nazikçe açıkla ve kullanıcıya "Master Notu" olarak çözüm için neyin eksik olduğunu (örneğin: 'Grafiğin tepe noktası tam okunmuyor') belirt. Asla rastgele tahmin yapma.

# ÇIKTI FORMATI (JSON):
Cevabını SADECE geçerli bir JSON objesi olarak ver.
"display_response" alanına tüm çözüm sürecini baştan sona, adım adım, formülleri ve mantığı içerecek şekilde ZENGİN MARKDOWN formatında yaz.

{
  "system_data": {
    "topic_main": "Matematik",
    "topic_sub": "Türev",
    "target_level": "Lise 12",
    "difficulty": "medium",
    "detected_weakness": "Kök neden tespiti...",
    "correct_answer": "C"
  },
  "display_response": "### 🚀 Çözüm Yolculuğu\n\n1. **Adım:** ...\n2. **Adım:** ...\n\n**Sonuç:** ...",
  "master_tips": ["İpucu 1"]
}

$selfCorrection
''';
  }

  /// Görselden soru çöz - Master Solver ile
  Future<QuestionSolution?> solveQuestionFromImage(Uint8List imageBytes) async {
    await initialize();
    await _checkPoints('standard_solve');

    try {
      final masterPrompt = await _buildMasterSolverPrompt();
      
      final content = [
        Content.multi([
          TextPart(masterPrompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _visionModel.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) throw Exception('AI yanıt vermedi');

      await _pointsService.spendPoints('standard_solve', description: 'Görselden Soru Çözümü');
      
      return _parseMasterResponse(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Soru çözme hatası: $e');
      return null;
    }
  }

  /// Master Response'u parse et - Bulletproof 4.0
  QuestionSolution? _parseMasterResponse(String text) {
    try {
      String cleanText = text.trim();
      
      // 1. Adım: Kod bloklarını ve gereksiz metinleri temizle
      if (cleanText.contains('```')) {
        final match = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```').firstMatch(cleanText);
        if (match != null) {
          cleanText = match.group(1)!.trim();
        }
      }

      // 2. Adım: JSON Ayıklama ve Decode
      Map<String, dynamic>? jsonMap;
      try {
        // En geniş süslü parantez aralığını bul
        final firstBrace = cleanText.indexOf('{');
        final lastBrace = cleanText.lastIndexOf('}');
        
        if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
          final jsonCandidate = cleanText.substring(firstBrace, lastBrace + 1);
          jsonMap = jsonDecode(jsonCandidate);
        }
      } catch (e) {
        debugPrint('⚠️ JSON Decode hatası (4.0): $e');
        
        // Alternatif: Gevşek temizleme dene (bazen sonda nokta veya ek karakter kalıyor)
        try {
          final looseMatch = RegExp(r'\{[\s\S]*\}').firstMatch(cleanText);
          if (looseMatch != null) {
            jsonMap = jsonDecode(looseMatch.group(0)!);
          }
        } catch (_) {}
      }

      // 3. Adım: Başarılı Decode Durumunda Veri Çıkarımı
      if (jsonMap != null) {
        final systemData = jsonMap['system_data'] as Map<String, dynamic>? ?? {};
        String sol = jsonMap['display_response'] ?? jsonMap['solution'] ?? '';
        
        // Eğer solution boşsa (veya decode içinde bulunamadıysa) manuel yakalamayı dene
        if (sol.isEmpty) {
          final solMatch = RegExp(r'"display_response"\s*:\s*"(.*)"', dotAll: true).firstMatch(cleanText);
          if (solMatch != null) sol = solMatch.group(1)!;
        }

        if (sol.isNotEmpty) {
          return QuestionSolution(
            subject: systemData['topic_main'] ?? 'Genel',
            topic: systemData['topic_sub'] ?? 'Genel',
            questionText: '',
            solution: _cleanSolutionText(sol),
            difficulty: systemData['difficulty'] ?? 'medium',
            keyConceptsUsed: [],
            correctAnswer: systemData['correct_answer'],
            tips: (jsonMap['master_tips'] as List<dynamic>?)?.cast<String>() ?? [],
            detectedIntent: systemData['detected_weakness'],
          );
        }
      }

      // 4. Adım: Manuel Fallback (Regex ile Best-Effort)
      debugPrint('🕵️ Manuel extraction deneniyor...');
      String solution = cleanText;
      String? subject;
      String? topic;
      String? correctAnswer;

      // Regex ile display_response çek
      final solMatch = RegExp(r'"display_response"\s*:\s*"(.*?)"(?=\s*,\s*"|\s*\})', dotAll: true).firstMatch(text);
      if (solMatch != null) {
        solution = _cleanSolutionText(solMatch.group(1)!);
      } else {
        // Eğer regexten de gelmiyorsa ama JSON formatındaysa, display_response etiketini manuel sil
        if (solution.contains('"display_response"')) {
          final parts = solution.split('"display_response"');
          if (parts.length > 1) {
            String raw = parts[1].trim();
            if (raw.startsWith(':')) raw = raw.substring(1).trim();
            if (raw.startsWith('"')) raw = raw.substring(1).trim();
            // Sona kadar al ama diğer anahtarları temizle
            int end = raw.lastIndexOf('",');
            if (end == -1) end = raw.lastIndexOf('"}');
            if (end != -1) raw = raw.substring(0, end);
            solution = _cleanSolutionText(raw);
          }
        }
      }

      // Diğer alanları çek
      subject = RegExp(r'"topic_main"\s*:\s*"(.*?)"').firstMatch(text)?.group(1);
      topic = RegExp(r'"topic_sub"\s*:\s*"(.*?)"').firstMatch(text)?.group(1);
      correctAnswer = RegExp(r'"correct_answer"\s*:\s*"(.*?)"').firstMatch(text)?.group(1);

      // 5. Final Güvenlik Kontrolü: Eğer hala JSON metadatası varsa temizle
      if (solution.contains('"system_data"') || solution.contains('{"')) {
        // JSON'u tamamen ayıkla, sadece metni bırak
        solution = solution.replaceAll(RegExp(r'\{"system_data"[\s\S]*?"display_response"\s*:\s*"'), '');
        solution = solution.replaceAll(RegExp(r'"\s*,\s*"master_tips"[\s\S]*?\}'), '');
        solution = solution.replaceAll(RegExp(r'"\s*\}'), '');
        solution = _cleanSolutionText(solution);
      }

      return QuestionSolution(
        subject: subject ?? 'Genel',
        topic: topic ?? 'Genel',
        questionText: '',
        solution: solution,
        difficulty: 'medium',
        keyConceptsUsed: [],
        correctAnswer: correctAnswer,
      );
    } catch (e) {
      debugPrint('🚨 Parser Error: $e');
      return QuestionSolution(
        subject: 'Genel', topic: 'Genel', questionText: '', solution: text, difficulty: 'medium', keyConceptsUsed: [],
      );
    }
  }

  /// Çözüm metnini temizle (escape karakterleri vs)
  String _cleanSolutionText(String raw) {
    return raw
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"')
        .replaceAll(r'\\', r'\')
        .replaceAll(r'\t', '\t')
        .trim();
  }

  /// 🎨 CLONE GENERATOR - Benzer sorular üret
  /// NOT: Burada kullanıcı profil seviyesi DEĞİL, orijinal sorunun seviyesi önemli!
  /// Mühendislik öğrencisi ilkokul sorusu çözdüyse, benzer sorular da ilkokul seviyesinde olmalı.
  Future<List<SimilarQuestion>> generateSimilarQuestions({
    required String subject,
    required String topic,
    required String originalQuestion,
    String? originalSolutionLogic,
    String? questionTargetLevel, // Orijinal sorunun tespit edilen seviyesi
    int count = 2,
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('similar_question');
    
    final dna = await _dnaService.getDNA();
    // Orijinal sorunun seviyesi verilmişse onu kullan, yoksa kullanıcı profilini fallback olarak kullan
    final targetLevel = questionTargetLevel ?? dna?.gradeLevel ?? 'Belirlenmedi';
    final weakSubjects = dna?.weakTopics.map((w) => w.subTopic).join(', ') ?? '';

    try {
      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in "Active Recall" (Aktif Hatırlama) motorusun. Görevin, sana verilen referans sorunun mantıksal iskeletini (algoritmasını) analiz etmek ve bu iskelet üzerine kurulu, ORİJİNAL SORUNUN SEVİYESİNE UYGUN $count ADET yeni, özgün soru türetmektir.

⚠️ KRİTİK KURAL: Üretilen benzer sorular ORİJİNAL SORUNUN SEVİYESİNDE olmalı!
Kullanıcının kendi eğitim seviyesi farklı olabilir (örn: Mühendislik öğrencisi ilkokul sorusu çözdürüyorsa).
Benzer sorular orijinal soruyla aynı zorluk ve seviyede olmalı.

GİRDİ VERİLERİ:
- Referans Soru: $originalQuestion
- Referans Çözüm Mantığı: ${originalSolutionLogic ?? 'Belirlenmedi'}
- Konu: $subject - $topic
- Orijinal Sorunun Hedef Seviyesi: $targetLevel
- Kullanıcının Zayıf Konuları (referans): $weakSubjects

ADAPTİF TÜRETME KURALLARI (ORİJİNAL SORUNUN SEVİYESİNE Göre):

Eğer Orijinal Soru "İlkokul/Ortaokul" Seviyesindeyse (1-6. Sınıf):

- Hikayeleştirme: Sorudaki objeleri değiştir (Örn: "Elma" yerine "Uzay Gemisi" veya "Futbol Topu").
- Sayılar: Sayıları değiştir ama işlem karmaşası yaratma (Tam bölünebilen sayılar seç).
- Amaç: Eğlenceli tekrar.

Eğer Orijinal Soru "LGS/TYT/AYT/KPSS" Seviyesindeyse (7-12. Sınıf):
- Şablon Koruma: ÖSYM tarzı soru kalıbını bozma.
- Varyasyon: Orijinal soru "X'i verip Y'yi istiyorsa", türettiğin sorulardan biri "Y'yi verip X'i istesin" (Tersine Mühendislik).
- Amaç: Sınav refleksi kazandırmak.

Eğer Orijinal Soru "Üniversite/TUS/Akademik" Seviyesindeyse:
- Parametre Değişimi: Klinik vakaysa hastanın yaşını/cinsiyetini veya semptomunu değiştir. Mühendislikse değişkenleri değiştir.
- Amaç: Mekanizma kavrama kontrolü.

SÖZEL SORU KLONLAMA TAKTİKLERİ (Türkçe/Tarih/Coğrafya/Felsefe):
Sözelde sayıları değiştiremeyeceğimiz için "Bağlam Değiştirme" tekniklerini kullan:

📖 YAPI KOPYALAMA (Türkçe Paragraf):
- Orijinal soru "Yardımcı Düşünce" sorusuysa; aynı uzunlukta, farklı bir konuda (Örn: Doğa yerine Uzay) yeni paragraf yaz ve aynı soru türünü sor.
- Paragraf yapısını koru ama içeriği değiştir.

📚 DÖNEM/KİŞİ DEĞİŞTİRME (Tarih):
- Orijinal soru "Osmanlı Yükselme Dönemi" ile ilgiliyse; aynı mantıkta (sebep-sonuç ilişkisi) "Duraklama Dönemi"nden veya farklı bir padişah/olay üzerinden benzer soru kurgula.

🗺️ KAVRAM EŞLEŞTİRME (Coğrafya/Felsefe):
- Orijinal soru "Ege Bölgesi iklimi" soruyorsa; Akdeniz Bölgesi'ni işaretle ve aynı iklim özelliği sorusunu sor.
- Kavramı koru, örneği değiştir.

ÇIKTI FORMATI (JSON): Yanıtı SADECE şu JSON formatında ver:
{
  "cloned_questions": [
    {
      "question_id": 1,
      "text": "Birinci türetilmiş sorunun tam metni",
      "correct_answer": "Doğru Cevap (Kısa)",
      "options": ["A) seçenek", "B) seçenek", "C) seçenek", "D) seçenek"],
      "explanation_short": "Tek cümlelik ipucu/çözüm"
    },
    {
      "question_id": 2,
      "text": "İkinci türetilmiş sorunun tam metni",
      "correct_answer": "Doğru Cevap (Kısa)",
      "options": ["A) seçenek", "B) seçenek", "C) seçenek", "D) seçenek"],
      "explanation_short": "Tek cümlelik ipucu/çözüm"
    }
  ]
}

KURALLAR:
- Türkçe olarak yanıt ver
- Soruları ORİJİNAL SORUNUN SEVİYESİNE ($targetLevel) uygun yap
- Her soru öğretici ve özgün olmalı
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('similar_question', description: '$topic konusu için benzer soru üretimi');

      return _parseClonedQuestions(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Benzer soru üretme hatası: $e');
      return [];
    }
  }

  /// Cloned Questions parse et
  List<SimilarQuestion> _parseClonedQuestions(String text) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      final List<dynamic> clonedList = json['cloned_questions'] ?? [];

      return clonedList.map((item) => SimilarQuestion(
        question: item['text'] ?? '',
        correctAnswer: item['correct_answer'] ?? '',
        options: (item['options'] as List<dynamic>?)?.cast<String>() ?? [],
        explanation: item['explanation_short'] ?? '',
      )).toList();
    } catch (e) {
      debugPrint('Clone parse hatası: $e');
      return [];
    }
  }

  /// 📊 MASTER ANALYST - Kök Neden Raporu ve Grafik Verisi
  Future<MasterAnalysis?> getAIAnalysis({
    required List<Map<String, dynamic>> activityLog,
    Map<String, double>? topicPerformance,
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('personal_analysis');
    
    final dna = await _dnaService.getDNA();
    final userName = 'Öğrenci'; // TODO: Add user name to DNA model
    final userLevel = dna?.gradeLevel ?? '9. Sınıf';
    final targetExam = dna?.targetExam ?? '';
    
    // Aktivite logunu string'e çevir
    final logText = activityLog.map((a) => 
      '${a['topic']}: ${a['result']} (${a['error_type'] ?? 'unknown'}) - ${a['date'] ?? 'today'}'
    ).join('\n');
    
    // Performans verisini string'e çevir
    final perfText = topicPerformance?.entries.map((e) => 
      '${e.key}: %${(e.value * 100).toInt()}'
    ).join(', ') ?? 'Veri yok';

    try {
      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in "Baş Veri Analisti ve Eğitim Koçu"sun. Görevin, sana verilen ham soru çözüm loglarını analiz ederek, öğrencinin başarısızlığının GÖRÜNMEYEN KÖK NEDENİNİ bulmak ve bunu hem sözel içgörü hem de sayısal grafik verisi olarak sunmaktır.

GİRDİ VERİLERİ (USER DNA):
- Kullanıcı: $userName
- Seviye: $userLevel
- Hedef Sınav: $targetExam

Aktivite Logu (Son 30 Gün):
$logText

Konu Performansı:
$perfText

ANALİZ ALGORİTMASI ("SHERLOCK HOLMES" LOGIC):

1. YÜZEYIN ALTINA İN:
- Sadece "Matematik kötü" deme. NEDEN kötü?
- Örnek: Hem "Problemler" hem "Paragraf" yanlışsa → teşhis: "Okuduğunu Anlama Eksikliği"
- Örnek: Zor konularda başarılı, kolay konularda hata → teşhis: "İşlem Dikkatsizliği"

2. TREND ANALİZİ:
- Son 7 günün verisini zaman eksenine oturt
- Yükseliş/düşüş tespiti yap

3. "X DEĞİL Y" PRENSİBİ:
- Kullanıcının sandığı sorunla gerçek sorunu ayırt et
- Kalıp: "Sen sorunun [X] olduğunu sanıyorsun ama asıl problemin [Y]"

ÇIKTI FORMATI (STRICT JSON):
{
  "insight_card": {
    "headline": "Çarpıcı Başlık",
    "deep_analysis": "Detaylı analiz metni. $userName'e hitap et. Verilere dayalı, spesifik ol.",
    "root_cause_tag": "Kök neden etiketi (Örn: Dikkat Eksikliği, Kavram Yanılgısı, Acelecilik)",
    "confidence_score": 85
  },
  "charts_data": {
    "progress_line_chart": [
      {"day": "Pzt", "score": 40},
      {"day": "Sal", "score": 55},
      {"day": "Çar", "score": 45},
      {"day": "Per", "score": 60},
      {"day": "Cum", "score": 70}
    ],
    "weakness_radar_chart": [
      {"subject": "Bilgi", "value": 80},
      {"subject": "Dikkat", "value": 50},
      {"subject": "Hız", "value": 65},
      {"subject": "Yorum", "value": 75}
    ]
  },
  "action_plan": {
    "step_1": "İlk adım önerisi",
    "step_2": "İkinci adım önerisi",
    "step_3": "Üçüncü adım önerisi"
  }
}

KURALLAR:
- Türkçe yanıt ver
- $userName'a ismiyle hitap et
- Motive edici ama gerçekçi ol
- Grafik verilerini aktivite loguna dayanarak oluştur
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('personal_analysis', description: 'Sherlock Holmes akademik analiz raporu');

      return _parseMasterAnalysis(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Master analiz hatası: $e');
      return null;
    }
  }

  /// Master Analysis parse et
  MasterAnalysis? _parseMasterAnalysis(String text) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      
      final insight = json['insight_card'] as Map<String, dynamic>? ?? {};
      final charts = json['charts_data'] as Map<String, dynamic>? ?? {};
      final action = json['action_plan'] as Map<String, dynamic>? ?? {};

      // Progress chart parse
      final progressData = (charts['progress_line_chart'] as List<dynamic>?)
          ?.map((d) => ChartDataPoint(
                label: d['day'] ?? '',
                value: (d['score'] ?? 0).toDouble(),
              ))
          .toList() ?? [];

      // Radar chart parse
      final radarData = (charts['weakness_radar_chart'] as List<dynamic>?)
          ?.map((d) => ChartDataPoint(
                label: d['subject'] ?? '',
                value: (d['value'] ?? 0).toDouble(),
              ))
          .toList() ?? [];

      // Action plan parse
      final actionSteps = <String>[];
      action.forEach((key, value) {
        if (value is String) actionSteps.add(value);
      });

      return MasterAnalysis(
        headline: insight['headline'] ?? '',
        deepAnalysis: insight['deep_analysis'] ?? '',
        rootCauseTag: insight['root_cause_tag'] ?? '',
        confidenceScore: insight['confidence_score'] ?? 0,
        progressChartData: progressData,
        radarChartData: radarData,
        actionPlan: actionSteps,
      );
    } catch (e) {
      return null;
    }
  }

  /// 🦉 SOCRATIC TUTOR - Yol Gösterici / İpucu Modu
  Future<SocraticSession?> socraticHint({
    required String questionText,
    List<String>? chatHistory,
    int currentStep = 1,
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('socratic_mode');
    
    final dna = await _dnaService.getDNA();
    final userLevel = dna?.gradeLevel ?? '9. Sınıf';
    final weakSubjects = dna?.weakTopics.map((w) => w.subTopic).join(', ') ?? '';
    
    final historyText = chatHistory?.join('\n') ?? 'İlk adım';

    final cognitiveContext = await _getGlobalCognitiveContext();
    final persona = _getPersonaSegment(userLevel, isSocratic: true);
    final selfCorrection = _getSelfCorrectionAudit();

    try {
      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in Sokratik Öğretmenisin. Görevin, öğrenciye cevabı söylemek DEĞİL, onu doğru düşünce yoluna sokmaktır.

$cognitiveContext
$persona

# KURALLAR:
1. TEK ADIM: Her seferinde sadece bir (1) küçük ipucu veya soru sor.
2. CEVABI SAKLA: Kullanıcı ısrar etse bile nihai sonucu söyleme.
3. DNA UYUMU: Kullanıcının zayıf olduğu konularda (örn: işlem hatası yapıyorsa) daha dikkatli olması için uyar.

# GİRDİ:
- Soru: $questionText
- Geçmiş: $historyText

# ÇIKTI (JSON):
Cevabını SADECE geçerli bir JSON objesi olarak ver. Anahtarlar ve değerler mutlaka ÇİFT TIRNAK (") ile sarmalanmalıdır. Asla tek tırnak kullanma. Yanıtında JSON dışında hiçbir metin bulunmasın.

{
  "session_status": { "is_solved": false, "step_number": $currentStep, "hint_type": "question" },
  "tutor_message": "Anlatım..."
}

$selfCorrection
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('socratic_mode', description: 'Sokratik mod ipucu');

      return _parseSocraticSession(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Sokratik ipucu hatası: $e');
      return null;
    }
  }

  /// Socratic Session parse et
  SocraticSession? _parseSocraticSession(String text) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      
      final status = json['session_status'] as Map<String, dynamic>? ?? {};

      return SocraticSession(
        isSolved: status['is_solved'] ?? false,
        stepNumber: status['step_number'] ?? 1,
        totalStepsEstimated: status['total_steps_estimated'] ?? 4,
        hintType: status['hint_type'] ?? 'question',
        tutorMessage: json['tutor_message'] ?? '',
      );
    } catch (e) {
      debugPrint('Socratic session parse hatası: $e');
      return null;
    }
  }

  /// 💊 MICRO-LESSON GENERATOR - Nokta Atışı Ders Anlatıcısı
  Future<MicroLesson?> generateMicroLesson({
    required String topic,
    List<String>? knownConcepts,
    List<String>? strugglePoints,
    List<String>? interests,
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('micro_lesson');
    
    final dna = await _dnaService.getDNA();
    final userName = dna?.userName ?? 'Öğrenci'; 
    final userLevel = dna?.gradeLevel ?? '9. Sınıf';
    
    // DNA'dan eksik verileri tamamla
    final known = knownConcepts ?? dna?.strongTopics ?? [];
    final struggles = strugglePoints ?? dna?.weakTopics.map((w) => w.subTopic).toList() ?? [];
    final userInterests = interests ?? dna?.interests ?? ['spor', 'oyunlar', 'günlük hayat'];

    final cognitiveContext = await _getGlobalCognitiveContext();
    final persona = _getPersonaSegment(userLevel);
    final selfCorrection = _getSelfCorrectionAudit();

    try {
      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in "Cerrahi Mikro-Ders Anlatıcısı"sın. Görevin öğrencinin spesifik hata yaptığı 'Atomik Konsept'i nokta atışı düzeltmektir.

$cognitiveContext
$persona

# GÖREV (SURGICAL PRECISION):
1. Konu: $topic
2. Yaklaşım: Tüm ana konuyu anlatma. Sadece bu atomik noktadaki mantık hatasını düzelt.
3. Analoji: Öğrencinin ilgisi olan (${userInterests.join(', ')}) üzerinden bir metafor kur.
4. Uzunluk: Maks 150 kelime. 

# ÇIKTI (JSON):
{
  "lesson_card": {
    "title": "Başlık",
    "greeting": "Kişiselleştirilmiş giriş...",
    "core_explanation": "Markdown anlatım...",
    "analogy_used": "Metafor adı",
    "quick_check_question": "Soru?"
  }
}

$selfCorrection
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('micro_lesson', description: '$topic mikro ders anlatımı');

      return _parseMicroLesson(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Mikro ders hatası: $e');
      return null;
    }
  }

  /// MicroLesson parse et
  MicroLesson? _parseMicroLesson(String text) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      
      final card = json['lesson_card'] as Map<String, dynamic>? ?? {};

      return MicroLesson(
        title: card['title'] ?? '',
        greeting: card['greeting'] ?? '',
        coreExplanation: card['core_explanation'] ?? '',
        analogyUsed: card['analogy_used'] ?? '',
        quickCheckQuestion: card['quick_check_question'] ?? '',
      );
    } catch (e) {
      debugPrint('MicroLesson parse hatası: $e');
      return null;
    }
  }
  List<SimilarQuestion> _parseSimilarQuestions(String text) {
    try {
      final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON array bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final List<dynamic> jsonList = jsonDecode(jsonStr);

      return jsonList.map((item) => SimilarQuestion.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Benzer soru parse hatası: $e');
      return [];
    }
  }

  /// 🧠 COGNITIVE DIAGNOSTIC - Neden yanlış yaptım analizi
  Future<CognitiveDiagnosis?> analyzeUserThinking({
    required String questionText,
    required String correctSolution,
    required String userWrongChoice,
    required String userExplanation,
  }) async {
    await initialize();
    
    // 💎 ÖNCE puan kontrolü
    await _checkPoints('detailed_explain');
    
    final dna = await _dnaService.getDNA();
    final userLevel = dna?.gradeLevel ?? '9. Sınıf';

    final cognitiveContext = await _getGlobalCognitiveContext();
    final selfCorrection = _getSelfCorrectionAudit();

    try {
      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in "Bilişsel Tanı Uzmanı"sın. Öğrencinin yanlışını analiz edip 'Kök Neden' tespiti yapmalısın.

$cognitiveContext

# ANALİZ:
- Soru: $questionText
- Doğru Çözüm: $correctSolution
- Öğrenci Açıklaması: "$userExplanation"

# GÖREV:
1. Öğrencinin raydan çıktığı tam 'Bilişsel Kırılma Noktası'nı bul.
2. Bunu DNA'daki 'Kritik Hata Deseni' ile kıyasla.
3. Yapıcı ve nokta atışı bir geri bildirim ver.

# ÇIKTI (JSON):
Cevabını SADECE geçerli bir JSON objesi olarak ver. Anahtarlar ve değerler mutlaka ÇİFT TIRNAK (") ile sarmalanmalıdır. Asla tek tırnak kullanma. Yanıtında JSON dışında hiçbir metin bulunmasın.

{
  "diagnosis": {
    "error_type": "CALCULATION | CONCEPT | READING | LOGIC",
    "is_logic_partially_correct": true,
    "confidence_score": 90,
    "breakdown_point": "Raydan çıkılan nokta..."
  },
  "feedback": {
    "validation_text": "Doğru kısımlar...",
    "correction_text": "Düzeltme...",
    "coach_tip": "Taktik önerisi..."
  }
}

$selfCorrection
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // ✅ İşlem başarılı - şimdi puanı düş
      await _pointsService.spendPoints('detailed_explain', description: 'Düşünce dedektifi hata analizi');

      return _parseCognitiveDiagnosis(text);
    } on InsufficientPointsException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Bilişsel analiz hatası: $e');
      return null;
    }
  }

  /// Cognitive Diagnosis parse et
  CognitiveDiagnosis? _parseCognitiveDiagnosis(String text) {
    try {
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final jsonStr = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      
      final diagnosis = json['diagnosis'] as Map<String, dynamic>? ?? {};
      final feedback = json['feedback'] as Map<String, dynamic>? ?? {};

      return CognitiveDiagnosis(
        errorType: diagnosis['error_type'] ?? 'UNKNOWN',
        isLogicPartiallyCorrect: diagnosis['is_logic_partially_correct'] ?? false,
        confidenceScore: diagnosis['confidence_score'] ?? 0,
        breakdownPoint: diagnosis['breakdown_point'] ?? '',
        validationText: feedback['validation_text'] ?? '',
        correctionText: feedback['correction_text'] ?? '',
        coachTip: feedback['coach_tip'] ?? '',
      );
    } catch (e) {
      debugPrint('Cognitive diagnosis parse hatası: $e');
      return null;
    }
  }

  /// 📝 NOTE ORGANIZER - Ders Notu Düzenleyici
  Future<Map<String, String>?> organizeStudentNotes(Uint8List imageBytes) async {
    await initialize();
    await _checkPoints('organize_note');

    try {
      final dna = await _dnaService.getDNA();
      final userName = dna?.userName ?? 'Öğrenci';
      final userLevel = dna?.gradeLevel ?? 'Belirlenmedi';

      final cognitiveContext = await _getGlobalCognitiveContext();

      final prompt = '''
GÖREV TANIMI: Sen SOLICAP'in "Zeki Not Düzenleyicisi"sin. Karmaşık notları 'Clean Code' mantığında tertemiz ders notlarına dönüştür.

$cognitiveContext

# KURALLAR:
1. OCR & YAPILANDIRMA: Metni oku, başlıklandır, maddeleştir.
2. ÖZET: Sadece en kritik 3-5 bilgiyi "🦉 Master Özeti" olarak ekle.
3. Markdown formatını kullan.

# ÇIKTI (JSON):
{ "title": "Başlık", "organized_content": "Markdown..." }
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _visionModel.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) return null;

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) return null;

      final jsonMap = jsonDecode(jsonMatch.group(0)!);
      
      // İşlem başarılı - puan harca
      await _pointsService.spendPoints('organize_note', description: 'Ders Notu Düzenleme');

      return {
        'title': jsonMap['title'] ?? 'Düzenlenmiş Not',
        'content': jsonMap['organized_content'] ?? '',
      };
    } catch (e) {
      debugPrint('❌ Not düzenleme hatası: $e');
      return null;
    }
  }

  /// 🃏 FLASHCARD GENERATOR - Notlardan Çalışma Kartı Üret
  Future<List<Map<String, String>>?> generateFlashcardsFromNote(String noteContent) async {
    await initialize();
    // 💎 Puan kontrolü (Benzer soru maliyetiyle aynı sayabiliriz)
    await _checkPoints('similar_question');

    try {
      final prompt = '''
GÖREV TANIMI: Sen bir "Öğrenme Uzmanı"sın. Aşağıdaki ders notunu analiz et ve bu nottaki en kritik bilgileri içeren 3 ile 5 adet arasında Soru-Cevap (Flashcard) çifti oluştur.

NOT İÇERİĞİ:
$noteContent

KURALLAR:
1. Sorular net ve tek bir bilgiye odaklı olmalı.
2. Cevaplar kısa ve öz olmalı.
3. Öğrencinin konuyu hatırlamasını (active recall) sağlamalı.

ÇIKTI FORMATI (JSON):
{
  "flashcards": [
    {
      "question": "Soru metni?",
      "answer": "Cevap metni"
    }
  ]
}

Dil: Türkçe
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) return null;

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) return null;

      final jsonMap = jsonDecode(jsonMatch.group(0)!);
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
  }) async {
    await initialize();
    await _checkPoints('socratic_analysis');

    try {
      final prompt = '''
# GÖREV: Sokratik Öğrenci Koçu
Kullanıcı bir soru paylaştı ve şu an bu soruyu kağıt üzerinde çözmeye çalışıyor. Senin görevin onun KARALAMASINI (workImage) incelemek ve yol göstermek.

# KURALLAR:
1. "DEEP VISION": Orijinal soru ile öğrencinin karalamasını kıyasla.
2. "CONSTRUCTIVE FEEDBACK": Öğrencinin doğru yaptığı kısımları takdir et. Yanlış yaptığı yeri net bir şekilde (örn: '2. satırda eksi hatası yapmışsın') belirt.
3. "SOCRATIC HINT": Cevabı SAKIN verme. Bir sonraki adımı bulması için ona minik bir ipucu ver. 
4. "SOLVED CHECK": Eğer öğrenci soruyu tamamen ve doğru çözdüyse "is_solved": true yap. Değilse false bırak.

# ÇIKTI (JSON):
Cevabını SADECE şu JSON formatında ver:
{
  "evaluation": "### 🔍 Değerlendirme\\n\\nŞu kısım harika... Ancak...",
  "is_solved": false,
  "next_hint": "Şimdi şu formülü hatırlamaya ne dersin?"
}
''';

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

/// 📊 Master Analysis - Kök Neden Raporu + Grafik Verisi
class MasterAnalysis {
  final String headline;              // Çarpıcı başlık
  final String deepAnalysis;          // Detaylı analiz
  final String rootCauseTag;          // Kök neden etiketi
  final int confidenceScore;          // Güven skoru (0-100)
  final List<ChartDataPoint> progressChartData;  // Gelişim grafiği
  final List<ChartDataPoint> radarChartData;     // Radar grafik
  final List<String> actionPlan;      // Aksiyon adımları

  MasterAnalysis({
    required this.headline,
    required this.deepAnalysis,
    required this.rootCauseTag,
    required this.confidenceScore,
    required this.progressChartData,
    required this.radarChartData,
    required this.actionPlan,
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

