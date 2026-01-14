/// SOLICAP - Supervisor Service
/// Karşılayıcı AI (Router Agent) - Kullanıcı profilleme ve periyodik analiz

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'user_dna_service.dart';

/// Supervisor AI tarafından çıkarılan profil
class ExtractedProfile {
  final String status;           // "complete" | "incomplete"
  final List<String> missingInfo;
  final String? followUpQuestion;
  final String? level;           // "k12" | "university" | "professional"
  final String? grade;
  final String? department;
  final String? targetExam;
  final String? studyLanguage;
  final String? explanationLanguage;
  final List<String> interests;
  final List<String> struggles;

  ExtractedProfile({
    required this.status,
    this.missingInfo = const [],
    this.followUpQuestion,
    this.level,
    this.grade,
    this.department,
    this.targetExam,
    this.studyLanguage,
    this.explanationLanguage,
    this.interests = const [],
    this.struggles = const [],
  });

  bool get isComplete => status == 'complete';

  factory ExtractedProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>? ?? {};
    return ExtractedProfile(
      status: json['status'] ?? 'incomplete',
      missingInfo: List<String>.from(json['missing_info'] ?? []),
      followUpQuestion: json['follow_up_question'],
      level: profile['level'],
      grade: profile['grade'],
      department: profile['department'],
      targetExam: profile['target_exam'],
      studyLanguage: profile['study_language'],
      explanationLanguage: profile['explanation_language'],
      interests: List<String>.from(profile['interests'] ?? []),
      struggles: List<String>.from(profile['struggles'] ?? []),
    );
  }
}

/// Periyodik analiz sonucu
class PeriodicAnalysisResult {
  final List<String> newTopics;
  final List<String> weakAreas;
  final List<String> strongAreas;
  final bool isCalibrated;
  final String? insight;

  PeriodicAnalysisResult({
    this.newTopics = const [],
    this.weakAreas = const [],
    this.strongAreas = const [],
    this.isCalibrated = false,
    this.insight,
  });

  factory PeriodicAnalysisResult.fromJson(Map<String, dynamic> json) {
    final updates = json['profile_updates'] as Map<String, dynamic>? ?? {};
    return PeriodicAnalysisResult(
      newTopics: List<String>.from(updates['new_topics'] ?? []),
      weakAreas: List<String>.from(updates['weak_areas'] ?? []),
      strongAreas: List<String>.from(updates['strong_areas'] ?? []),
      isCalibrated: updates['is_calibrated'] ?? false,
      insight: json['insight'],
    );
  }
}

/// Auto-tagging sonucu
class QuestionTags {
  final String subject;
  final String topic;
  final String subTopic;
  final String difficulty;
  final String questionType;
  final String language;

  QuestionTags({
    required this.subject,
    required this.topic,
    required this.subTopic,
    required this.difficulty,
    required this.questionType,
    required this.language,
  });

  factory QuestionTags.fromJson(Map<String, dynamic> json) {
    return QuestionTags(
      subject: json['subject'] ?? 'General',
      topic: json['topic'] ?? 'Unknown',
      subTopic: json['sub_topic'] ?? 'General',
      difficulty: json['difficulty'] ?? 'medium',
      questionType: json['question_type'] ?? 'multiple_choice',
      language: json['language'] ?? 'TR',
    );
  }
}

class SupervisorService {
  static final SupervisorService _instance = SupervisorService._internal();
  factory SupervisorService() => _instance;
  SupervisorService._internal();

  late GenerativeModel _model;
  bool _isInitialized = false;
  final UserDNAService _dnaService = UserDNAService();

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı!');
    }

    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.3, // Düşük sıcaklık = daha tutarlı profil çıkarımı
        maxOutputTokens: 1024,
      ),
    );

    _isInitialized = true;
    debugPrint('✅ Supervisor servisi başlatıldı');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎓 ONBOARDING EXTRACTION PROMPT
  // ═══════════════════════════════════════════════════════════════════════════
  
  String _buildOnboardingPrompt(String userText, String uiLanguage) {
    return '''
# GÖREV: ÖĞRENCİ PROFİL ÇIKARIMI (ONBOARDING SUPERVISOR)

Sen SOLICAP uygulamasının "Karşılayıcı AI"sısın. Görevin soru çözmek DEĞİL, sadece öğrenciyi tanımak ve profil oluşturmaktır.

## GİRDİ VERİLERİ
- **Kullanıcının Yazdığı Metin:** "$userText"
- **Arayüz Dili (Telefondan):** $uiLanguage

## ÇIKARIM KURALLARI

### 1. SEVİYE BELİRLEME (level)
Önce öğrencinin eğitim seviyesini belirle:

| Anahtar Kelimeler | Seviye |
|-------------------|--------|
| ilkokul, ortaokul, lise, sınıf, LGS, YKS, KPSS, Abitur, GCSE, SAT, ACT, Baccalaureate | "k12" |
| üniversite, fakülte, semester, dönem, vize, final, mühendislik, tıp, hukuk, college, university | "university" |
| mezun, TUS, DUS, ALES, USMLE, board exam, bar exam, profesyonel sınav | "professional" |

### 2. BÖLÜM/ALAN ÇIKARIMI (department)
- K12 için: Sayısal/Sözel/Eşit Ağırlık veya alan (Fen, Sosyal, Dil)
- Üniversite için: Bölüm adı (Tıp, Hukuk, Mühendislik, vs.)
- Profesyonel için: Sınav alanı (Tıp, Diş, Hukuk, vs.)

### 3. DİL TERCİHLERİ
- **study_language:** Derslerin hangi dilde olduğu (EN, TR, DE, FR, vs.)
  - İpuçları: "İngilizce eğitim", "English medium", "Almanca ders"
  - Varsayılan: Arayüz diliyle aynı
- **explanation_language:** Açıklamaları hangi dilde istediği
  - İpuçları: "Türkçe anlat", "explain in English", "auf Deutsch"
  - Varsayılan: Arayüz diliyle aynı

### 4. EKSİK BİLGİ KONTROLÜ
Aşağıdaki bilgilerden biri belirsizse bile "complete" yapmaya çalış, tahmin edemediğin alanları null bırak:
- level (ZORUNLU - Belirlenemezse "k12" varsay)
- grade veya department (Belirlenemezse null bırak)

Status her zaman "complete" olmalıdır, kullanıcıyı döngüye sokma.
Eksik bilgi varsa, yine de "complete" yap ve profile objesini doldurabildiğin kadar doldur.

### 5. ÇOK DİLLİ DAVRANIM
- Kullanıcı hangi dilde yazdıysa, follow_up_question'ı o dilde yaz
- Türkçe yazıyorsa Türkçe sor
- İngilizce yazıyorsa İngilizce sor
- Almanca yazıyorsa Almanca sor

## ÇIKTI FORMATI (STRICT JSON)
```json
{
  "status": "complete" | "incomplete",
  "missing_info": ["level", "grade"],
  "follow_up_question": "Hangi sınıftasın? / What grade are you in?",
  "profile": {
    "level": "k12" | "university" | "professional",
    "grade": "9. Sınıf" | "3. Semester" | null,
    "department": "Sayısal" | "Tıp Fakültesi" | null,
    "target_exam": "LGS" | "YKS" | "TUS" | "SAT" | null,
    "study_language": "TR" | "EN" | "DE",
    "explanation_language": "TR" | "EN" | "DE",
    "interests": ["matematik", "fizik"],
    "struggles": ["geometri", "kimya"]
  }
}
```

## ÖRNEK ÇIKARIMLAR

**Örnek 1:** "LGS'ye hazırlanıyorum, matematikte zorlanıyorum"
```json
{"status": "complete", "profile": {"level": "k12", "grade": "8. Sınıf", "target_exam": "LGS", "study_language": "TR", "explanation_language": "TR", "struggles": ["matematik"]}}
```

**Örnek 2:** "I'm a med student, 2nd year, struggling with anatomy"
```json
{"status": "complete", "profile": {"level": "university", "grade": "2nd Year", "department": "Medicine", "study_language": "EN", "explanation_language": "EN", "struggles": ["anatomy"]}}
```

**Örnek 3:** "Makine mühendisliği okuyorum" (eksik: sınıf bilgisi)
```json
{"status": "incomplete", "missing_info": ["grade"], "follow_up_question": "Kaçıncı sınıf veya dönemdesin?", "profile": {"level": "university", "department": "Makine Mühendisliği", "study_language": "TR", "explanation_language": "TR"}}
```

## ÖNEMLİ KURALLAR
1. SADECE JSON çıktı ver, başka hiçbir şey yazma
2. Profil bilgilerini asla tahmin etme, belirsizse "incomplete" yap
3. Her zaman kullanıcının dilinde follow_up_question yaz
4. level belirlenemediyse kesinlikle "incomplete" yap
''';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📊 PERIODIC ANALYSIS PROMPT (Her 5 Soruda)
  // ═══════════════════════════════════════════════════════════════════════════
  
  String _buildPeriodicAnalysisPrompt(
    Map<String, dynamic> currentProfile,
    List<Map<String, dynamic>> recentQuestions,
    String uiLanguage,
  ) {
    final profileJson = jsonEncode(currentProfile);
    final questionsJson = jsonEncode(recentQuestions);
    
    return '''
# GÖREV: PERİYODİK PROFİL GÜNCELLEMESİ (SUPERVISOR AGENT)

Sen SOLICAP'in "Profil Güncelleme AI"sısın. Görevin son 5 sorunun verilerini analiz edip kullanıcı profilini güncellemektir.

## GİRDİ VERİLERİ
- **Mevcut Profil:** $profileJson
- **Son 5 Soru Verisi:** $questionsJson
- **Arayüz Dili:** $uiLanguage

## ANALİZ KURALLARI

### 1. YENİ KONU TESPİTİ (new_topics)
Sorularda geçen ama mevcut profilde olmayan konuları listele.
Evrensel formatta yaz: Math -> Calculus -> Derivatives

### 2. ZAYIF ALAN TESPİTİ (weak_areas)
En az 2 kez yanlış yapılan konuları tespit et.
Örnek: Kullanıcı 3 geometri sorusundan 2'sini yanlış yaptı → "Geometri" zayıf alan

### 3. GÜÇLÜ ALAN TESPİTİ (strong_areas)
%80+ doğru oranına sahip konuları tespit et.

### 4. KALİBRASYON KONTROLÜ (is_calibrated)
Toplam soru sayısı 10 veya üzeriyse → true
Altındaysa → false

### 5. İÇGÖRÜ (insight)
Kısa, motive edici bir analiz cümlesi yaz.
- Kullanıcının ana diline göre yaz
- 1-2 cümle, pozitif tonlu

## ÇIKTI FORMATI (STRICT JSON)
```json
{
  "profile_updates": {
    "new_topics": ["Physics/Thermodynamics/Entropy"],
    "weak_areas": ["Geometry", "Organic Chemistry"],
    "strong_areas": ["Calculus", "Algebra"],
    "is_calibrated": true
  },
  "insight": "Fizik konularına yoğunlaşıyorsun ve Termodinamik'te ilerliyorsun! Geometri'de biraz daha pratik yapmayı düşünebilirsin."
}
```

## KURALLAR
1. SADECE JSON çıktı ver
2. insight kısmını kullanıcının arayüz diline göre yaz
3. Veri yetersizse boş liste dön, tahmin etme
''';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏷️ AUTO-TAGGING PROMPT (Her Soru İçin)
  // ═══════════════════════════════════════════════════════════════════════════
  
  String _buildAutoTaggingPrompt(String questionContext) {
    return '''
# GÖREV: SORU ETİKETLEME (AUTO-TAGGER)

Sen SOLICAP'in "Soru Etiketleme AI"sısın. Görevin soruyu analiz edip kategorize etmektir.

## GİRDİ
**Soru/Bağlam:** $questionContext

## ETİKETLEME KURALLARI

### 1. SUBJECT (Ana Ders)
Evrensel ders adları kullan:
- Mathematics, Physics, Chemistry, Biology
- History, Geography, Literature, Philosophy
- Computer Science, Medicine, Law, Engineering
- Economics, Psychology, Sociology

### 2. TOPIC (Konu)
Evrensel konu adları kullan:
- Math: Algebra, Calculus, Geometry, Statistics, Number Theory
- Physics: Mechanics, Thermodynamics, Electromagnetism, Optics
- Medicine: Anatomy, Physiology, Pathology, Pharmacology

### 3. SUB_TOPIC (Alt Konu)
Daha spesifik alt konu.
Örnek: Calculus → Derivatives, Integrals, Limits

### 4. DIFFICULTY
- "easy": Temel kavram, düz hesaplama
- "medium": Birden fazla adım, orta düzey
- "hard": Karmaşık, çok adımlı, analitik düşünme gerektiren

### 5. QUESTION_TYPE
- "multiple_choice": Şıklı soru
- "open_ended": Açık uçlu, yorum gerektiren
- "proof": İspat sorusu
- "calculation": Hesaplama ağırlıklı
- "conceptual": Kavramsal anlayış

### 6. LANGUAGE
Sorunun dili: TR, EN, DE, FR, ES, AR, vb.

## ÇIKTI FORMATI (STRICT JSON)
```json
{
  "subject": "Mathematics",
  "topic": "Calculus",
  "sub_topic": "Derivatives",
  "difficulty": "medium",
  "question_type": "calculation",
  "language": "TR"
}
```

## KURALLAR
1. SADECE JSON çıktı ver
2. Evrensel İngilizce konu adları kullan (dil bağımsız analiz için)
3. Belirsiz durumlarda "General" veya "Unknown" kullan, tahmin etme
''';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Onboarding metinden profil çıkar
  Future<ExtractedProfile> extractProfileFromText(
    String userText,
    String uiLanguage,
  ) async {
    await initialize();

    try {
      final prompt = _buildOnboardingPrompt(userText, uiLanguage);
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      // JSON parse
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      debugPrint('✅ Profil çıkarıldı: ${json['status']}');
      
      // 🚀 ZORUNLU ONAY: Kullanıcı deneyimi için her zaman complete dönelim
      return ExtractedProfile.fromJson({
        ...json,
        'status': 'complete', // Her zaman geçişe izin ver
      });
    } catch (e) {
      debugPrint('❌ Profil çıkarma hatası: $e');
      return ExtractedProfile(
        status: 'incomplete',
        missingInfo: ['level', 'grade'],
        followUpQuestion: _getDefaultFollowUp(uiLanguage),
      );
    }
  }

  /// Periyodik profil analizi (her 5 soruda çağrılır)
  Future<PeriodicAnalysisResult> analyzeRecentActivity(
    List<Map<String, dynamic>> recentQuestions,
    String uiLanguage,
  ) async {
    await initialize();

    try {
      final dna = await _dnaService.getDNA();
      final currentProfile = {
        'level': dna?.level,
        'department': dna?.department,
        'discovered_topics': dna?.discoveredTopics ?? [],
        'question_count': dna?.questionCount ?? 0,
      };

      final prompt = _buildPeriodicAnalysisPrompt(
        currentProfile,
        recentQuestions,
        uiLanguage,
      );

      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      debugPrint('✅ Periyodik analiz tamamlandı');
      
      return PeriodicAnalysisResult.fromJson(json);
    } catch (e) {
      debugPrint('❌ Periyodik analiz hatası: $e');
      return PeriodicAnalysisResult();
    }
  }

  /// Sorudan otomatik etiket çıkar
  Future<QuestionTags> extractQuestionTags(String questionContext) async {
    await initialize();

    try {
      final prompt = _buildAutoTaggingPrompt(questionContext);
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception('AI yanıt vermedi');
      }

      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        throw Exception('JSON bulunamadı');
      }

      final json = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
      debugPrint('✅ Soru etiketlendi: ${json['subject']}/${json['topic']}');
      
      return QuestionTags.fromJson(json);
    } catch (e) {
      debugPrint('❌ Auto-tagging hatası: $e');
      return QuestionTags(
        subject: 'General',
        topic: 'Unknown',
        subTopic: 'General',
        difficulty: 'medium',
        questionType: 'unknown',
        language: 'TR',
      );
    }
  }

  /// Varsayılan takip sorusu (dile göre)
  String _getDefaultFollowUp(String uiLanguage) {
    switch (uiLanguage.toUpperCase()) {
      case 'EN':
        return 'Could you tell me which grade or level you are studying at?';
      case 'DE':
        return 'Könntest du mir sagen, in welcher Klasse oder auf welchem Niveau du lernst?';
      case 'FR':
        return 'Pourriez-vous me dire à quel niveau vous étudiez?';
      case 'ES':
        return '¿Podrías decirme en qué grado o nivel estás estudiando?';
      default:
        return 'Hangi sınıfta veya seviyede olduğunu söyleyebilir misin?';
    }
  }

  /// Supervisor çalışması gerekiyor mu? (Her 5 soruda)
  bool shouldRunPeriodicCheck(int currentQuestionCount, int lastCheckCount) {
    return (currentQuestionCount - lastCheckCount) >= 5;
  }
}
