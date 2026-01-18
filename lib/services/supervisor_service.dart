/// SOLICAP - Supervisor Service
/// Karşılayıcı AI (Router Agent) - Kullanıcı profilleme ve periyodik analiz

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'user_dna_service.dart';
import 'prompt_registry_service.dart';

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
  final PromptRegistryService _promptRegistry = PromptRegistryService();

  /// Servisi başlat
  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı!');
    }

    await _promptRegistry.initialize();

    final supervisorInstruction = Content.system(
      'Sen SOLICAP\'in "Supervisor" takip motorusun. '
      'Tüm yanıtlarını TÜRKÇE ve JSON formatında hazırlamalısın.'
    );

    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      systemInstruction: supervisorInstruction,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 4096,
        responseMimeType: 'application/json',
      ),
    );

    _isInitialized = true;
    debugPrint('✅ Supervisor servisi başlatıldı');
  }

  // 🎓 ONBOARDING EXTRACTION PROMPT
  String _buildOnboardingPrompt(String userText, String uiLanguage) {
    return _promptRegistry.getPrompt('onboarding_supervisor', variables: {
      'userText': userText,
      'uiLanguage': uiLanguage,
    });
  }

  // 📊 PERIODIC ANALYSIS PROMPT
  String _buildPeriodicAnalysisPrompt(
    Map<String, dynamic> currentProfile,
    List<Map<String, dynamic>> recentQuestions,
    String uiLanguage,
  ) {
    return _promptRegistry.getPrompt('periodic_analysis', variables: {
      'profileJson': jsonEncode(currentProfile),
      'questionsJson': jsonEncode(recentQuestions),
      'uiLanguage': uiLanguage,
    });
  }

  // 🏷️ AUTO-TAGGING PROMPT
  String _buildAutoTaggingPrompt(String questionContext) {
    return _promptRegistry.getPrompt('auto_tagging', variables: {
      'questionText': questionContext,
    });
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

      final jsonData = jsonDecode(text);
      debugPrint('✅ Profil çıkarıldı: ${jsonData['status']}');
      
      return ExtractedProfile.fromJson({
        ...jsonData,
        'status': 'complete', 
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

      final jsonData = jsonDecode(text);
      debugPrint('✅ Periyodik analiz tamamlandı');
      
      return PeriodicAnalysisResult.fromJson(jsonData);
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

      final jsonData = jsonDecode(text);
      debugPrint('✅ Soru etiketlendi: ${jsonData['subject']}/${jsonData['topic']}');
      
      return QuestionTags.fromJson(jsonData);
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
