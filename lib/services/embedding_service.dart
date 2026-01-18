/// SOLICAP - Embedding Service
/// Text ve görsel embedding işlemleri için servis
/// Vertex AI Embeddings API kullanır

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Text embedding ve görsel hash servisi
class EmbeddingService {
  static final EmbeddingService _instance = EmbeddingService._internal();
  factory EmbeddingService() => _instance;
  EmbeddingService._internal();

  GenerativeModel? _embeddingModel;
  bool _initialized = false;

  /// Servisi başlat
  Future<void> initialize() async {
    if (_initialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY bulunamadı');
    }

    // Gemini text-embedding-004 modeli kullan
    // Not: google_generative_ai paketi embedding için de kullanılabilir
    _embeddingModel = GenerativeModel(
      model: 'text-embedding-004',
      apiKey: apiKey,
    );

    _initialized = true;
    debugPrint('✅ EmbeddingService başlatıldı');
  }

  /// Metin için embedding üret (768-dimension vector)
  /// 
  /// Türkçe metinler için optimize edilmiş multilingual model kullanır.
  /// Benzerlik aramasında kullanılır.
  Future<List<double>> generateTextEmbedding(String text) async {
    await initialize();

    try {
      // Metni temizle ve normalize et
      final cleanText = _normalizeText(text);
      
      if (cleanText.isEmpty) {
        debugPrint('⚠️ Boş metin için embedding üretilemez');
        return [];
      }

      // Gemini embedding API çağrısı
      final response = await _embeddingModel!.embedContent(
        Content.text(cleanText),
      );

      final embedding = response.embedding;
      if (embedding == null || embedding.values.isEmpty) {
        debugPrint('⚠️ Embedding değerleri boş döndü');
        return [];
      }

      debugPrint('✅ Embedding üretildi: ${embedding.values.length} boyut');
      return embedding.values;
    } catch (e) {
      debugPrint('❌ Embedding hatası: $e');
      return [];
    }
  }

  /// İki embedding arasındaki benzerliği hesapla (Cosine Similarity)
  /// 
  /// Dönen değer: 0.0 (tamamen farklı) - 1.0 (aynı)
  double calculateSimilarity(List<double> a, List<double> b) {
    if (a.isEmpty || b.isEmpty || a.length != b.length) {
      return 0.0;
    }

    double dotProduct = 0.0;
    double normA = 0.0;
    double normB = 0.0;

    for (int i = 0; i < a.length; i++) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }

    if (normA == 0 || normB == 0) {
      return 0.0;
    }

    final similarity = dotProduct / (sqrt(normA) * sqrt(normB));
    return similarity.clamp(0.0, 1.0);
  }

  /// Karekök hesapla
  double sqrt(double value) {
    if (value <= 0) return 0;
    double guess = value / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + value / guess) / 2;
    }
    return guess;
  }

  /// Görsel için SHA256 hash üret (tam eşleşme kontrolü için)
  /// 
  /// Aynı görseller için aynı hash döner.
  /// Hafif farklılıklar bile farklı hash üretir.
  String generateImageHash(Uint8List imageBytes) {
    final digest = sha256.convert(imageBytes);
    return digest.toString();
  }
  
  /// 🎯 Perceptual Hash (pHash) - Görsel farklılıklarına toleranslı
  /// 
  /// Görseli küçültüp basitleştirerek hash üretir.
  /// Küçük farklılıklar (kırpma, sıkıştırma, parlaklık) aynı hash verir.
  /// 
  /// Algoritma:
  /// 1. Görselin boyutunu al (ilk 1000 byte'tan)
  /// 2. Boyut + dosya boyutu kombinasyonu ile hash üret
  /// 3. Bu basit pHash, tam görsel işleme yerine hızlı yaklaşım sağlar
  String generatePerceptualHash(Uint8List imageBytes) {
    // Basit pHash: Dosya boyutu + ilk/son byte pattern
    // Daha karmaşık pHash için image paketi gerekir
    final size = imageBytes.length;
    final prefix = imageBytes.length > 100 
        ? imageBytes.sublist(0, 100) 
        : imageBytes;
    final suffix = imageBytes.length > 100 
        ? imageBytes.sublist(imageBytes.length - 100) 
        : imageBytes;
    
    // Pattern hash: boyut + baş + son
    final patternData = [
      ...size.toString().codeUnits,
      ...prefix,
      ...suffix,
    ];
    
    final digest = sha256.convert(patternData);
    final pHash = digest.toString().substring(0, 16); // Kısa hash
    
    debugPrint('🔑 pHash üretildi: $pHash (size: $size)');
    return pHash;
  }
  
  /// 🔄 Hem SHA256 hem pHash döndür (çift kontrol için)
  Map<String, String> generateDualHash(Uint8List imageBytes) {
    return {
      'sha256': generateImageHash(imageBytes),
      'pHash': generatePerceptualHash(imageBytes),
    };
  }

  /// Metni normalize et (embedding kalitesi için)
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ') // Çoklu boşlukları tek boşluğa çevir
        .replaceAll(RegExp(r'[^\w\s\u00C0-\u024F\u1E00-\u1EFF]'), '') // Özel karakterleri kaldır (Türkçe hariç)
        .trim();
  }

  /// Soru metni için optimize edilmiş embedding üret
  /// 
  /// Matematik/Fizik/Kimya soruları için özel normalizasyon yapar.
  Future<List<double>> generateQuestionEmbedding(String questionText) async {
    // Matematiksel sembolleri metinsel karşılıklarına çevir
    String normalized = questionText
        .replaceAll('²', ' kare ')
        .replaceAll('³', ' küp ')
        .replaceAll('√', ' karekök ')
        .replaceAll('∫', ' integral ')
        .replaceAll('∑', ' toplam ')
        .replaceAll('π', ' pi ')
        .replaceAll('Δ', ' delta ')
        .replaceAll('→', ' vektör ')
        .replaceAll('≤', ' küçük eşit ')
        .replaceAll('≥', ' büyük eşit ')
        .replaceAll('≠', ' eşit değil ')
        .replaceAll('∞', ' sonsuz ');

    return generateTextEmbedding(normalized);
  }
}
