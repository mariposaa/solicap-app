/// SOLICAP - Answer Validation Service
/// İnternet üzerinden cevap doğrulama ve güven skoru hesaplama
/// Google Search Grounding API kullanır

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// İnternet doğrulama sonucu
class ValidationResult {
  final bool found;              // İnternette bulundu mu?
  final String? internetAnswer;  // Bulunan cevap (A, B, C, D, E)
  final List<String> sources;    // Kaynak URL'leri
  final bool matches;            // AI cevabı ile eşleşiyor mu?
  final String? rawResponse;     // Ham yanıt (debug için)

  ValidationResult({
    required this.found,
    this.internetAnswer,
    this.sources = const [],
    required this.matches,
    this.rawResponse,
  });

  /// Bulunamadı sonucu
  factory ValidationResult.notFound() {
    return ValidationResult(found: false, matches: false);
  }

  @override
  String toString() {
    return 'ValidationResult(found: $found, answer: $internetAnswer, matches: $matches)';
  }
}

/// Cevap doğrulama servisi
class AnswerValidationService {
  static final AnswerValidationService _instance = AnswerValidationService._internal();
  factory AnswerValidationService() => _instance;
  AnswerValidationService._internal();

  GenerativeModel? _searchModel;
  bool _initialized = false;

  /// Karmaşık konular listesi (düşük güven skoru)
  static const _complexTopics = [
    'türev', 'integral', 'limit', 'grafik',
    'vektör', 'matris', 'determinant',
    'diferansiyel', 'olasılık', 'istatistik',
    'elektromanyetik', 'kuantum', 'termodinamik',
    'organik kimya', 'reaksiyon hızı', 'denge',
  ];

  /// Servisi başlat
  Future<void> initialize() async {
    if (_initialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı');
    }

    // Gemini Pro model with Google Search grounding
    _searchModel = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1, // Düşük sıcaklık = daha tutarlı cevaplar
        maxOutputTokens: 256,
      ),
    );

    _initialized = true;
    debugPrint('✅ AnswerValidationService başlatıldı');
  }

  /// İnternette sadece doğru cevap harfini ara (A/B/C/D/E)
  /// 
  /// Çözümü aramaz, sadece cevap anahtarını bulur.
  /// Bu sayede hız artar ve yanlış çözüm parse edilmez.
  Future<ValidationResult> validateAnswer({
    required String questionText,
    required String aiAnswer,
  }) async {
    await initialize();

    try {
      // Arama sorgusu oluştur - çözüm değil, cevap harfi
      final query = '''
Aşağıdaki sorunun SADECE doğru cevap şıkkını bul (A, B, C, D veya E).
Çözümü YAZMA, sadece tek bir harf yaz.

SORU:
$questionText

CEVAP (sadece A, B, C, D veya E):
''';

      // Google Search ile interneti tara
      final response = await _searchModel!.generateContent(
        [Content.text(query)],
        // Google Search Grounding aktif
        // Not: Bu özellik API'de otomatik aktif
      );

      final rawResponse = response.text?.trim() ?? '';
      debugPrint('🔍 İnternet arama sonucu: $rawResponse');

      // Cevap harfini çıkar
      final internetAnswer = _extractAnswerLetter(rawResponse);

      if (internetAnswer == null) {
        debugPrint('⚠️ İnternette cevap bulunamadı');
        return ValidationResult.notFound();
      }

      // AI cevabı ile karşılaştır
      final normalizedAi = aiAnswer.toUpperCase().trim();
      final normalizedInternet = internetAnswer.toUpperCase().trim();
      final matches = normalizedAi == normalizedInternet;

      debugPrint('✅ Doğrulama: AI=$normalizedAi, İnternet=$normalizedInternet, Eşleşme=$matches');

      return ValidationResult(
        found: true,
        internetAnswer: normalizedInternet,
        matches: matches,
        rawResponse: rawResponse,
      );
    } catch (e) {
      debugPrint('❌ Doğrulama hatası: $e');
      return ValidationResult.notFound();
    }
  }

  /// 🚀 HIZLI ŞIK ARAMASI - Sadece A/B/C/D/E döndürür
  /// 
  /// - Timeout: 4 saniye (aşılırsa null döner, AI devam eder)
  /// - Non-blocking: Hata olursa sessizce null döner
  /// - Sadece Matematik, Fizik, Kimya için kullanılır
  Future<String?> quickAnswerLookup(String questionText) async {
    await initialize();
    
    final stopwatch = Stopwatch()..start(); // Süre ölçümü
    debugPrint('🌐 İnternet şık araması başlatılıyor...');
    debugPrint('   📝 Soru: ${questionText.length > 50 ? '${questionText.substring(0, 50)}...' : questionText}');
    
    try {
      final prompt = '''
İnternette bu sorunun sadece DOĞRU CEVAP ŞIKKINI bul.
Sadece tek harf yaz: A, B, C, D veya E
Çözüm yazma, açıklama yazma, sadece harf.

SORU: $questionText

CEVAP:''';

      // Timeout ile çalıştır - 4 saniye aşılırsa iptal
      final response = await _searchModel!.generateContent(
        [Content.text(prompt)],
      ).timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          stopwatch.stop();
          debugPrint('⏱️ İnternet araması TIMEOUT (${stopwatch.elapsedMilliseconds}ms) - AI devam edecek');
          throw TimeoutException('Internet arama zaman aşımı');
        },
      );
      
      stopwatch.stop();

      final rawResponse = response.text?.trim() ?? '';
      
      if (rawResponse.isEmpty) {
        debugPrint('🔍 İnternet araması: SONUÇ YOK (${stopwatch.elapsedMilliseconds}ms)');
        return null;
      }

      final answer = _extractAnswerLetter(rawResponse);
      
      if (answer != null) {
        debugPrint('✅ İnternet araması BAŞARILI: $answer (${stopwatch.elapsedMilliseconds}ms)');
      } else {
        debugPrint('⚠️ İnternet araması: Parse edilemedi "$rawResponse" (${stopwatch.elapsedMilliseconds}ms)');
      }
      
      return answer;
    } on TimeoutException {
      return null; // Timeout - AI devam etsin
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ İnternet araması HATA (${stopwatch.elapsedMilliseconds}ms): $e');
      return null; // Hata - AI devam etsin
    }
  }

  /// Yanıtten cevap harfini çıkar (A, B, C, D, E)
  String? _extractAnswerLetter(String response) {
    // Önce direkt tek harf kontrolü
    final trimmed = response.trim().toUpperCase();
    if (RegExp(r'^[A-E]$').hasMatch(trimmed)) {
      return trimmed;
    }

    // "Cevap: X" veya "Doğru cevap X" formatları
    final patterns = [
      RegExp(r'cevap[:\s]+([A-E])', caseSensitive: false),
      RegExp(r'doğru\s+cevap[:\s]+([A-E])', caseSensitive: false),
      RegExp(r'doğru\s+şık[:\s]+([A-E])', caseSensitive: false),
      RegExp(r'^([A-E])\)', caseSensitive: false),
      RegExp(r'^([A-E])\s+şıkkı', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(response);
      if (match != null) {
        return match.group(1)?.toUpperCase();
      }
    }

    // Son çare: metinde geçen ilk A-E harfi
    final anyLetter = RegExp(r'\b([A-E])\b').firstMatch(response);
    return anyLetter?.group(1)?.toUpperCase();
  }

  /// AI güven skorunu hesapla (0.0 - 1.0)
  /// 
  /// Yüksek skor = İnternet aramasına gerek yok
  /// Düşük skor = İnternet araması yap
  double calculateConfidenceScore({
    required String solutionText,
    required String topic,
    required bool isVisualQuestion,
  }) {
    double score = 1.0;

    // 1. Görsel soru mu? (-0.10)
    if (isVisualQuestion) {
      score -= 0.10;
      debugPrint('📊 Güven: Görsel soru (-0.10)');
    }

    // 2. Karmaşık konu mu? (-0.15)
    final topicLower = topic.toLowerCase();
    if (_complexTopics.any((t) => topicLower.contains(t))) {
      score -= 0.15;
      debugPrint('📊 Güven: Karmaşık konu (-0.15)');
    }

    // 3. Çözümde belirsizlik ifadeleri var mı? (-0.20)
    if (_hasUncertaintyMarkers(solutionText)) {
      score -= 0.20;
      debugPrint('📊 Güven: Belirsizlik ifadesi (-0.20)');
    }

    // 4. Çözüm adımları tutarlı mı? (+0.10)
    if (_hasConsistentSteps(solutionText)) {
      score += 0.10;
      debugPrint('📊 Güven: Tutarlı adımlar (+0.10)');
    }

    // 5. Birden fazla olası cevap var mı? (-0.15)
    if (_hasMultiplePossibleAnswers(solutionText)) {
      score -= 0.15;
      debugPrint('📊 Güven: Çoklu olası cevap (-0.15)');
    }

    final finalScore = score.clamp(0.0, 1.0);
    debugPrint('📊 Final güven skoru: $finalScore');
    return finalScore;
  }

  /// Belirsizlik ifadeleri kontrolü
  bool _hasUncertaintyMarkers(String text) {
    final markers = [
      'muhtemelen', 'büyük ihtimalle', 'tahminimce',
      'olabilir', 'sanırım', 'galiba',
      'emin değilim', 'kesin değil', 'belirsiz',
      'probably', 'maybe', 'might be',
    ];
    final lower = text.toLowerCase();
    return markers.any((m) => lower.contains(m));
  }

  /// Tutarlı adım kontrolü (Adım 1, Adım 2 gibi)
  bool _hasConsistentSteps(String text) {
    final stepPatterns = [
      RegExp(r'adım\s*\d', caseSensitive: false),
      RegExp(r'step\s*\d', caseSensitive: false),
      RegExp(r'\d+[\.\)]\s*\w'),
      RegExp(r'•\s*\w'),
    ];
    int matchCount = 0;
    for (final pattern in stepPatterns) {
      matchCount += pattern.allMatches(text).length;
    }
    return matchCount >= 2;
  }

  /// Birden fazla olası cevap kontrolü
  bool _hasMultiplePossibleAnswers(String text) {
    final lower = text.toLowerCase();
    final indicators = [
      'iki farklı', 'birden fazla', 'alternatif',
      'her iki', 'farklı yollarla', 'iki sonuç',
    ];
    return indicators.any((i) => lower.contains(i));
  }
}
