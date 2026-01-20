/// SOLICAP - Smart Memory Service
/// Akıllı Hafıza (RAG) sistemi ana orkestrasyon servisi
/// Sadece Mathematics, Physics, Chemistry soruları için aktif

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/golden_question_model.dart';
import '../models/pending_question_model.dart';
import 'embedding_service.dart';
import 'answer_validation_service.dart';

/// Hafıza kontrol sonucu
class MemoryCheckResult {
  final bool foundInGolden;           // Altın DB'de tam eşleşme var mı?
  final GoldenQuestion? goldenMatch;  // Bulunan Altın soru
  final List<GoldenQuestion> similarQuestions; // Benzer sorular
  final String questionHash;          // Görsel hash
  final List<double> embedding;       // Text embedding
  final bool shouldSkipAI;            // AI'a sormaya gerek var mı?

  MemoryCheckResult({
    this.foundInGolden = false,
    this.goldenMatch,
    this.similarQuestions = const [],
    required this.questionHash,
    required this.embedding,
    this.shouldSkipAI = false,
  });

  /// QuestionSolution döndür (Altın DB'den)
  QuestionSolution? get goldenSolution {
    if (goldenMatch == null) return null;
    return QuestionSolution(
      subject: goldenMatch!.subject,
      topic: goldenMatch!.topic,
      questionText: goldenMatch!.questionText,
      solution: goldenMatch!.solution,
      correctAnswer: goldenMatch!.correctAnswer,
      difficulty: 'Orta', // Varsayılan
      solvingApproach: 'Altın DB',
      isFromMemory: true,
    );
  }
}

/// Soru çözüm modeli (GeminiService ile uyumlu)
class QuestionSolution {
  final String subject;
  final String topic;
  final String questionText;
  final String solution;
  final String? correctAnswer;
  final String? difficulty;
  final String? solvingApproach;
  final bool isFromMemory;

  QuestionSolution({
    required this.subject,
    required this.topic,
    required this.questionText,
    required this.solution,
    this.correctAnswer,
    this.difficulty,
    this.solvingApproach,
    this.isFromMemory = false,
  });
}

/// Akıllı Hafıza Servisi
class SmartMemoryService {
  static final SmartMemoryService _instance = SmartMemoryService._internal();
  factory SmartMemoryService() => _instance;
  SmartMemoryService._internal();

  // 🎯 Desteklenen dersler - İngilizce (Global Hafıza için)
  static const supportedSubjectsEN = ['Mathematics', 'Physics', 'Chemistry'];
  
  // 🌍 Türkçe → İngilizce ders ismi dönüşüm haritası
  static const Map<String, String> _subjectTranslation = {
    'matematik': 'Mathematics',
    'mat': 'Mathematics',
    'math': 'Mathematics',
    'fizik': 'Physics',
    'fiz': 'Physics',
    'kimya': 'Chemistry',
    'kim': 'Chemistry',
    'chem': 'Chemistry',
  };

  // Bağımlılıklar
  final _db = FirebaseFirestore.instance;
  final _embeddingService = EmbeddingService();
  final _validationService = AnswerValidationService();

  // Collection referansları
  CollectionReference get _goldenRef => _db.collection('golden_questions');
  CollectionReference get _pendingRef => _db.collection('pending_questions');

  // Önbellek (performans için)
  final Map<String, GoldenQuestion> _hashCache = {};
  DateTime? _lastCacheRefresh;
  static const _cacheLifetime = Duration(minutes: 30);

  /// 🌍 Ders ismini İngilizce'ye çevir (Global Hafıza standardı)
  /// Matematik → Mathematics, Fizik → Physics, Kimya → Chemistry
  String normalizeSubjectToEnglish(String? subject) {
    if (subject == null || subject.isEmpty) return 'General';
    
    final lower = subject.toLowerCase().trim();
    
    // Direkt eşleşme
    if (_subjectTranslation.containsKey(lower)) {
      return _subjectTranslation[lower]!;
    }
    
    // Kısmi eşleşme (örn: "Temel Matematik" → "Mathematics")
    for (final entry in _subjectTranslation.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Zaten İngilizce mi kontrol et
    for (final en in supportedSubjectsEN) {
      if (lower == en.toLowerCase()) {
        return en;
      }
    }
    
    return 'General'; // Desteklenmeyen ders
  }

  /// Bu ders hafıza sistemini destekliyor mu?
  /// ART: Tüm dersler desteklenmeli (Hibrit Arama için)
  bool isSubjectSupported(String? subject) {
    return true; // 🔓 TÜM DERSLERİ AÇ
  }
  
  /// Cache lifetime kontrolü
  void _checkCacheLifetime() {
    if (_lastCacheRefresh != null && 
        DateTime.now().difference(_lastCacheRefresh!) > _cacheLifetime) {
      _hashCache.clear();
      _lastCacheRefresh = null;
      debugPrint('🗑️ Cache temizlendi (lifetime aşıldı)');
    }
  }

  /// Soru çözme öncesi hafıza kontrolü
  /// 
  /// 1. Görsel hash ile tam eşleşme ara (KONU BAĞIMSIZ)
  /// 2. Text embedding ile benzer sorular ara (konu bağımlı)
  /// 3. Sonuçları döndür
  Future<MemoryCheckResult> checkMemory({
    Uint8List? imageBytes,
    String? questionText,
    required String subject,
  }) async {
    try {
      // 1. Görsel hash oluştur
      String questionHash = '';
      if (imageBytes != null && imageBytes.isNotEmpty) {
        questionHash = _embeddingService.generateImageHash(imageBytes);
        debugPrint('🔑 Görsel hash: ${questionHash.substring(0, 16)}...');
      }

      // 2. HASH İLE TAM EŞLEŞME ARA (KONU BAĞIMSIZ!)
      // Bu kontrol TÜM sorular için yapılır
      if (questionHash.isNotEmpty) {
        final goldenMatch = await _findByHash(questionHash);
        if (goldenMatch != null) {
          debugPrint('✅ Altın DB\'de tam eşleşme bulundu: ${goldenMatch.id}');
          
          // Kullanım sayısını artır
          await _incrementUsage(goldenMatch.id);
          
          return MemoryCheckResult(
            foundInGolden: true,
            goldenMatch: goldenMatch,
            questionHash: questionHash,
            embedding: [],
            shouldSkipAI: true,
          );
        }
      }

      // 3. Konu desteklenmiyorsa embedding araması yapma, sadece hash sonucu döndür
      if (!isSubjectSupported(subject)) {
        debugPrint('ℹ️ $subject dersi için embedding araması desteklenmiyor');
        return MemoryCheckResult(
          questionHash: questionHash, 
          embedding: [],
          foundInGolden: false,
          shouldSkipAI: false,
        );
      }

      // 4. Text embedding oluştur (sadece desteklenen konular için)
      List<double> embedding = [];
      if (questionText != null && questionText.isNotEmpty) {
        embedding = await _embeddingService.generateQuestionEmbedding(questionText);
        debugPrint('📊 Embedding boyutu: ${embedding.length}');
      }

      // 5. Benzer sorular ara (embedding ile)
      List<GoldenQuestion> similarQuestions = [];
      if (embedding.isNotEmpty) {
        similarQuestions = await findSimilarQuestions(
          embedding: embedding,
          subject: subject,
          limit: 3,
          minSimilarity: 0.75, // 📉 Toleransı düşürdük (%75) - OCR hatalarını tolere etmesi için
        );
        debugPrint('🔍 ${similarQuestions.length} benzer soru bulundu (Tolerans: %75)');
      }

      return MemoryCheckResult(
        foundInGolden: false,
        similarQuestions: similarQuestions,
        questionHash: questionHash,
        embedding: embedding,
        shouldSkipAI: false,
      );
    } catch (e) {
      debugPrint('❌ Hafıza kontrolü hatası: $e');
      return MemoryCheckResult(questionHash: '', embedding: []);
    }
  }

  /// Hash ile Altın DB'de ara
  Future<GoldenQuestion?> _findByHash(String hash) async {
    // Cache lifetime kontrolü
    _checkCacheLifetime();
    
    // Önce cache'e bak
    if (_hashCache.containsKey(hash)) {
      debugPrint('💾 Cache hit: ${hash.substring(0, 16)}...');
      return _hashCache[hash];
    }

    try {
      final query = await _goldenRef
          .where('imageHash', isEqualTo: hash)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final golden = GoldenQuestion.fromFirestore(query.docs.first);
      _hashCache[hash] = golden; // Cache'e ekle
      return golden;
    } catch (e) {
      debugPrint('❌ Hash arama hatası: $e');
      return null;
    }
  }

  /// Kullanım sayısını artır
  Future<void> _incrementUsage(String questionId) async {
    try {
      await _goldenRef.doc(questionId).update({
        'usageCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('⚠️ Kullanım sayısı güncellenemedi: $e');
    }
  }

  /// Benzer sorular bul (Vector Search)
  /// 
  /// Firestore'da native vector search yoksa, client-side cosine similarity kullanılır.
  /// Not: Büyük veri setleri için Vertex AI Vector Search önerilir.
  Future<List<GoldenQuestion>> findSimilarQuestions({
    required List<double> embedding,
    String? subject,
    int limit = 5,
    double minSimilarity = 0.80,
  }) async {
    if (embedding.isEmpty) return [];

    try {
      // Subject filtresi ile sorgu
      Query query = _goldenRef;
      if (subject != null) {
        query = query.where('subject', isEqualTo: subject);
      }
      
      // Son 1000 soruyu al (performans için sınırlı)
      final snapshot = await query.limit(1000).get();

      if (snapshot.docs.isEmpty) return [];

      // Client-side similarity hesaplama
      final results = <MapEntry<GoldenQuestion, double>>[];

      for (final doc in snapshot.docs) {
        final golden = GoldenQuestion.fromFirestore(doc);
        if (golden.embedding.isEmpty) continue;

        final similarity = _embeddingService.calculateSimilarity(
          embedding,
          golden.embedding,
        );

        if (similarity >= minSimilarity) {
          results.add(MapEntry(golden, similarity));
        }
      }

      // Benzerliğe göre sırala ve limitle
      results.sort((a, b) => b.value.compareTo(a.value));
      
      return results.take(limit).map((e) => e.key).toList();
    } catch (e) {
      debugPrint('❌ Benzer soru arama hatası: $e');
      return [];
    }
  }

  /// Çözümü hafızaya kaydet
  /// 
  /// Güven skoruna göre Geçici veya Altın DB'ye kaydeder.
  /// Güven ≥ 0.85 ve doğrulandıysa → Altın DB
  /// Aksi halde → Geçici DB
  Future<void> saveToMemory({
    required String questionHash,
    required List<double> embedding,
    required String questionText,
    required String aiAnswer,
    required String aiSolution,
    required String subject,
    required String topic,
    required double confidenceScore,
    bool validated = false,
    String? internetAnswer,
  }) async {
    // 🌍 Ders ismini İngilizce'ye çevir (Global Hafıza standardı)
    final normalizedSubject = normalizeSubjectToEnglish(subject);
    
    // Desteklenmeyen ders
    if (!supportedSubjectsEN.contains(normalizedSubject)) {
      debugPrint('ℹ️ $subject → $normalizedSubject (desteklenmiyor, hafızaya kaydedilmedi)');
      return;
    }
    
    debugPrint('🌍 Ders standardizasyonu: $subject → $normalizedSubject');

    try {
      // Yüksek güven + doğrulandı → Altın DB
      if (validated && confidenceScore >= 0.85) {
        await _saveToGolden(
          questionHash: questionHash,
          embedding: embedding,
          questionText: questionText,
          correctAnswer: internetAnswer ?? aiAnswer,
          solution: aiSolution,
          subject: normalizedSubject,
          topic: topic,
          confidenceScore: confidenceScore,
          verificationMethod: 'internet_match',
        );
        debugPrint('✅ Altın DB\'ye kaydedildi');
      } else {
        // Geçici DB'ye kaydet
        await _saveToPending(
          questionHash: questionHash,
          embedding: embedding,
          questionText: questionText,
          aiAnswer: aiAnswer,
          aiSolution: aiSolution,
          subject: normalizedSubject,
          topic: topic,
          confidenceScore: confidenceScore,
          internetAnswer: internetAnswer,
          hasConflict: internetAnswer != null && internetAnswer != aiAnswer,
        );
        debugPrint('📝 Geçici DB\'ye kaydedildi');
      }
      
      // 🔄 Periyodik auto-promote kontrolü
      _maybeAutoPromote();
    } catch (e) {
      debugPrint('❌ Hafızaya kayıt hatası: $e');
    }
  }

  /// Altın DB'ye kaydet
  Future<void> _saveToGolden({
    required String questionHash,
    required List<double> embedding,
    required String questionText,
    required String correctAnswer,
    required String solution,
    required String subject,
    required String topic,
    required double confidenceScore,
    required String verificationMethod,
    String? source,
  }) async {
    await _goldenRef.add({
      'imageHash': questionHash,
      'embedding': embedding,
      'questionText': questionText,
      'correctAnswer': correctAnswer,
      'solution': solution,
      'subject': subject,
      'topic': topic,
      'source': source,
      'verifiedAt': Timestamp.now(),
      'verificationMethod': verificationMethod,
      'usageCount': 1,
      'confidenceScore': confidenceScore,
    });
  }

  /// Geçici DB'ye kaydet
  Future<void> _saveToPending({
    required String questionHash,
    required List<double> embedding,
    required String questionText,
    required String aiAnswer,
    required String aiSolution,
    required String subject,
    required String topic,
    required double confidenceScore,
    String? internetAnswer,
    bool hasConflict = false,
  }) async {
    // Aynı hash varsa sadece queryCount'u artır
    final existing = await _pendingRef
        .where('imageHash', isEqualTo: questionHash)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.update({
        'queryCount': FieldValue.increment(1),
      });
      return;
    }

    await _pendingRef.add({
      'imageHash': questionHash,
      'embedding': embedding,
      'questionText': questionText,
      'aiAnswer': aiAnswer,
      'aiSolution': aiSolution,
      'subject': subject,
      'topic': topic,
      'confidenceScore': confidenceScore,
      'createdAt': Timestamp.now(),
      'queryCount': 1,
      'status': hasConflict ? 'conflict' : 'pending',
      'conflictReason': hasConflict ? 'AI ve internet cevabı farklı' : null,
      'internetAnswer': internetAnswer,
    });
  }

  /// Geçici soruyu Altın DB'ye taşı
  Future<void> promoteToGolden(String pendingId, {String? source}) async {
    try {
      final pendingDoc = await _pendingRef.doc(pendingId).get();
      if (!pendingDoc.exists) {
        debugPrint('⚠️ Pending soru bulunamadı: $pendingId');
        return;
      }

      final pending = PendingQuestion.fromFirestore(pendingDoc);
      
      // Altın DB'ye ekle
      await _goldenRef.add(pending.toGoldenFirestore(
        verificationMethod: 'manual',
        source: source,
      ));

      // Geçici'den sil
      await _pendingRef.doc(pendingId).delete();

      debugPrint('✅ Soru Altın DB\'ye taşındı: $pendingId');
    } catch (e) {
      debugPrint('❌ Taşıma hatası: $e');
    }
  }

  /// Önbelleği temizle
  void clearCache() {
    _hashCache.clear();
    _lastCacheRefresh = null;
  }

  /// İstatistikler
  Future<Map<String, int>> getStats() async {
    try {
      final goldenCount = await _goldenRef.count().get();
      final pendingCount = await _pendingRef.count().get();
      
      return {
        'goldenQuestions': goldenCount.count ?? 0,
        'pendingQuestions': pendingCount.count ?? 0,
      };
    } catch (e) {
      debugPrint('❌ İstatistik hatası: $e');
      return {'goldenQuestions': 0, 'pendingQuestions': 0};
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // 🔄 AUTO-PROMOTE: Popüler soruları otomatik Altın DB'ye taşı
  // ═══════════════════════════════════════════════════════════════

  /// 🔄 Geçici DB'den Altın DB'ye otomatik taşıma
  /// 
  /// queryCount >= 5 olan sorular "popüler" kabul edilir.
  /// 
  /// ⚠️ GÜVENLİK FİLTRELERİ:
  /// - Conflict durumundaki sorular TAŞINMAZ
  /// - Güven skoru < 0.70 olan sorular TAŞINMAZ
  /// - İnternet cevabı AI ile çelişiyorsa TAŞINMAZ
  Future<int> checkAutoPromote() async {
    int promotedCount = 0;
    int skippedCount = 0;
    
    try {
      debugPrint('🔄 Auto-promote kontrolü başlatılıyor...');
      
      // queryCount >= 5 olan pending soruları bul (conflict olmayanlar)
      final candidates = await _pendingRef
          .where('queryCount', isGreaterThanOrEqualTo: 5)
          .where('status', isEqualTo: 'pending') // Conflict olanlar zaten hariç
          .limit(10)
          .get();
      
      if (candidates.docs.isEmpty) {
        debugPrint('ℹ️ Auto-promote: Taşınacak soru bulunamadı');
        return 0;
      }
      
      debugPrint('📋 ${candidates.docs.length} aday soru bulundu');
      
      for (final doc in candidates.docs) {
        try {
          final pending = PendingQuestion.fromFirestore(doc);
          
          // 🛡️ GÜVENLİK KONTROL 1: Güven skoru kontrolü
          if (pending.confidenceScore < 0.70) {
            debugPrint('⚠️ Düşük güven skoru, atlanıyor: ${doc.id} (${pending.confidenceScore})');
            skippedCount++;
            continue;
          }
          
          // 🛡️ GÜVENLİK KONTROL 2: İnternet çelişki kontrolü
          if (pending.internetAnswer != null && 
              pending.internetAnswer!.isNotEmpty &&
              pending.internetAnswer != pending.aiAnswer) {
            debugPrint('⚠️ İnternet çelişkisi, atlanıyor: ${doc.id} (AI: ${pending.aiAnswer}, Net: ${pending.internetAnswer})');
            
            // Status'u conflict'e çevir
            await _pendingRef.doc(doc.id).update({'status': 'conflict'});
            skippedCount++;
            continue;
          }
          
          // ✅ Tüm kontrolleri geçti - Altın DB'ye ekle
          await _goldenRef.add(pending.toGoldenFirestore(
            verificationMethod: 'auto_promote',
            source: 'popular_${pending.queryCount}x_conf${(pending.confidenceScore * 100).toInt()}',
          ));
          
          // Geçici DB'den sil
          await _pendingRef.doc(doc.id).delete();
          
          promotedCount++;
          debugPrint('✅ Auto-promoted: ${doc.id} (${pending.queryCount}x, conf: ${pending.confidenceScore})');
        } catch (e) {
          debugPrint('⚠️ Tek soru taşıma hatası: $e');
        }
      }
      
      if (promotedCount > 0 || skippedCount > 0) {
        debugPrint('🎉 Auto-promote: $promotedCount taşındı, $skippedCount atlandı');
      }
      
      return promotedCount;
    } catch (e) {
      debugPrint('❌ Auto-promote hatası: $e');
      return promotedCount;
    }
  }

  /// 🎲 Rastgele tetikleme (her 10 kayıtta 1)
  /// saveToMemory içinden çağrılır
  Future<void> _maybeAutoPromote() async {
    // %10 şansla auto-promote kontrol et (performans için)
    if (DateTime.now().millisecond % 10 == 0) {
      // Fire and forget - beklemeden arka planda çalıştır
      checkAutoPromote().catchError((e) {
        debugPrint('⚠️ Background auto-promote hatası: $e');
        return 0; // Error handler must return int
      });
    }
  }
  // ═══════════════════════════════════════════════════════════════
  // 🛠️ ADMIN TOOLS: Manüel Veri Girişi
  // ═══════════════════════════════════════════════════════════════

  /// 🛠️ Admin tarafından manüel soru ekleme (Data Engineer Precision 👷‍♂️)
  /// 
  /// Bu metod, dışarıdan gelen (hazır) soru ve çözümü sistem standartlarına
  /// uygun şekilde hash'ler, embed eder ve Altın DB'ye gömer.
  Future<void> saveManualGoldenQuestion({
    required Uint8List imageBytes,
    required String questionText,
    required String solution,
    required String correctAnswer,
    required String subject, // Girilen ham string (örn: "Matematik")
    required String topic,
    required String source,
  }) async {
    try {
      debugPrint('🛠️ Admin manüel kayıt başlatılıyor...');

      // 1. Görsel Hash (DNA) Üretimi
      // Bu adım kritiktir, öğrenci fotoğraf çektiğinde bu hash ile bulacağız.
      final imageHash = _embeddingService.generateImageHash(imageBytes);
      debugPrint('🔑 Görsel DNA (Hash): $imageHash');

      // 2. Metin Standardizasyonu
      // İleride metin bazlı arama için vector lazım.
      // DİKKAT: Admin "hazır çözüm" yapıştırsa bile, arama "soru metni" üzerinden yapılır.
      // Bu yüzden embedding "questionText" üzerinden üretilir.
      List<double> embedding = [];
      if (questionText.isNotEmpty) {
         // Embedding servisi maliyetlidir (Vertex AI), ama gereklidir.
         // Admin işlemidir, maliyeti ihmal edilebilir (tek seferlik).
         embedding = await _embeddingService.generateQuestionEmbedding(questionText);
         debugPrint('📊 Anlam Vektörü (Embedding) üretildi: ${embedding.length} boyut');
      }

      // 3. Konu Standardizasyonu (Global Dil Kuralı)
      // "Matematik" -> "Mathematics" çevrimi
      final normalizedSubject = normalizeSubjectToEnglish(subject);
      debugPrint('🌍 Dil Standardı: $subject -> $normalizedSubject');

      // 4. Mükerrer Kontrolü (Veri Hijyeni)
      // Aynı hash'e sahip başka soru var mı?
      final existing = await _goldenRef.where('imageHash', isEqualTo: imageHash).get();
      if (existing.docs.isNotEmpty) {
        debugPrint('⚠️ UYARI: Bu görsel zaten Altın DB\'de mevcut!');
        // İsteğe bağlı: Üzerine yazabilir veya hata dönebiliriz.
        // Admin olduğu için "güncelleme" mantığı güdülebilir ama şimdilik duplicate ekleyelim
        // (Firestore ID farklı olur, ama hash aynı olur - sistem ilk bulduğunu getirir)
      }

      // 5. Veritabanına Yazma (Atomic Operation)
      await _goldenRef.add({
        'imageHash': imageHash,
        'embedding': embedding,
        'questionText': questionText.trim(),
        'correctAnswer': correctAnswer.trim(),
        'solution': solution.trim(), // Adminin yapıştırdığı mükemmel çözüm
        'subject': normalizedSubject,
        'topic': topic.trim(),
        'source': source, // "admin_manual_upload"
        'verifiedAt': Timestamp.now(), // Şu an doğrulandı
        'verificationMethod': 'manual_admin',
        'usageCount': 0,
        'confidenceScore': 1.0, // Admin girdiği için %100 güven
      });

      debugPrint('✅ BAŞARILI: Soru Altın DB\'ye "Mühendis Titizliğiyle" eklendi. 🏗️');

    } catch (e) {
      debugPrint('❌ MANÜEL KAYIT HATASI: $e');
      rethrow; // UI tarafında hatayı gösterelim
    }
  }
}
