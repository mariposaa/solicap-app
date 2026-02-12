/// SOLICAP - YDS Servis
/// Faz yönetimi, test, AI konu anlatımı, Firebase kayıt, DNA entegrasyonu

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/yds_models.dart';
import '../data/yds_questions_data.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';
import 'note_service.dart';

class YdsService {
  static final YdsService _instance = YdsService._internal();
  factory YdsService() => _instance;
  YdsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  final NoteService _noteService = NoteService();

  GenerativeModel? _aiModel;
  bool _isInitialized = false;

  // ═══════════════════════════════════════════════════════════════
  // BAŞLATMA
  // ═══════════════════════════════════════════════════════════════

  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('⚠️ YDS Service: GEMINI_API_KEY bulunamadı');
      return;
    }

    _aiModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        maxOutputTokens: 4096,
      ),
    );

    // Soru bankasını yükle
    _loadQuestionBank();

    _isInitialized = true;
    debugPrint('✅ YDS Service initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // İLERLEME YÖNETİMİ (Firebase)
  // ═══════════════════════════════════════════════════════════════

  /// Firestore koleksiyonu
  CollectionReference get _progressCollection =>
      _firestore.collection('yds_progress');
  
  CollectionReference get _testResultsCollection =>
      _firestore.collection('yds_test_results');

  /// Kullanıcı ilerlemesini getir
  Future<YdsProgress> getProgress() async {
    final userId = _authService.currentUserId;
    if (userId == null) return YdsProgress(userId: '');

    try {
      final doc = await _progressCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return YdsProgress.fromFirestore(data);
      }
      // İlk kez - yeni ilerleme oluştur
      final progress = YdsProgress(userId: userId);
      await saveProgress(progress);
      return progress;
    } catch (e) {
      debugPrint('❌ YDS Progress getirme hatası: $e');
      return YdsProgress(userId: userId);
    }
  }

  /// İlerlemeyi kaydet
  Future<void> saveProgress(YdsProgress progress) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      await _progressCollection.doc(userId).set(
        progress.toFirestore(),
        SetOptions(merge: true),
      );
      debugPrint('✅ YDS Progress kaydedildi: Faz ${progress.currentFaz} - ${progress.currentStage}');
    } catch (e) {
      debugPrint('❌ YDS Progress kaydetme hatası: $e');
    }
  }

  /// İlerlemeyi sıfırla (tekrar çöz)
  Future<void> resetProgress() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    try {
      final fresh = YdsProgress(userId: userId);
      await _progressCollection.doc(userId).set(fresh.toFirestore());
      debugPrint('🔄 YDS Progress sıfırlandı');
    } catch (e) {
      debugPrint('❌ YDS Progress sıfırlama hatası: $e');
    }
  }

  /// İlerleme stream'i (realtime)
  Stream<YdsProgress> getProgressStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value(YdsProgress(userId: ''));

    return _progressCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return YdsProgress.fromFirestore(data);
      }
      return YdsProgress(userId: userId);
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // SORU YÖNETİMİ
  // ═══════════════════════════════════════════════════════════════

  /// Belirli faz ve zorluk için soruları getir
  List<YdsQuestion> getQuestions({
    required int fazNumber,
    required String difficulty,
  }) {
    // Faz ve zorluğa göre filtrele
    return _questionBank
        .where((q) => q.fazNumber == fazNumber && q.difficulty == difficulty)
        .toList();
  }

  /// Soru bankası
  static final List<YdsQuestion> _questionBank = [];

  /// Soru bankasını dart verisinden yükle
  void _loadQuestionBank() {
    if (_questionBank.isNotEmpty) return;
    _questionBank.addAll(getAllYdsQuestions());
    debugPrint('📚 YDS Soru bankası yüklendi: ${_questionBank.length} soru');
  }

  // ═══════════════════════════════════════════════════════════════
  // TEST TAMAMLAMA
  // ═══════════════════════════════════════════════════════════════

  /// Testi tamamla ve sonucu kaydet
  Future<YdsTestResult> completeTest({
    required int fazNumber,
    required String testType, // 'baslangic' | 'bitirme'
    required List<YdsAnswer> answers,
  }) async {
    final userId = _authService.currentUserId ?? '';

    // Sonuç oluştur
    final result = YdsTestResult.fromAnswers(
      userId: userId,
      fazNumber: fazNumber,
      testType: testType,
      answers: answers,
    );

    // Firebase'e kaydet
    try {
      await _testResultsCollection.doc(result.id).set(result.toFirestore());
      debugPrint('✅ Test sonucu kaydedildi: Faz $fazNumber $testType - ${result.totalCorrect}/${answers.length}');
    } catch (e) {
      debugPrint('❌ Test sonucu kaydetme hatası: $e');
    }

    // İlerlemeyi güncelle
    final progress = await getProgress();
    final fazProgress = progress.fazProgresses[fazNumber] ?? const YdsFazProgress();

    YdsFazProgress updatedFazProgress;
    if (testType == 'baslangic') {
      updatedFazProgress = fazProgress.copyWith(baslangicTestResult: result);
    } else {
      updatedFazProgress = fazProgress.copyWith(bitirmeTestResult: result);
    }

    final updatedProgress = progress
        .updateFazProgress(fazNumber, updatedFazProgress)
        .advanceStage();
    await saveProgress(updatedProgress);

    // DNA'ya kaydet
    await _updateDNA(result);

    return result;
  }

  // ═══════════════════════════════════════════════════════════════
  // AI KONU KARTI ÜRETİMİ (Gemini 2.5 Flash)
  // ═══════════════════════════════════════════════════════════════

  /// Yanlış yapılan konular için AI anlatım kartları üret
  /// [wrongAnswerDetails]: {konu: [hata tipi 1, hata tipi 2, ...]}
  Future<List<YdsTopicCard>> generateTopicCards(
    List<String> wrongTopics, {
    Map<String, List<String>> errorDetails = const {},
  }) async {
    if (!_isInitialized || _aiModel == null) {
      await initialize();
    }

    final cards = <YdsTopicCard>[];

    for (final topic in wrongTopics) {
      try {
        final errors = errorDetails[topic] ?? [];
        final errorContext = errors.isNotEmpty
            ? 'Öğrencinin bu konuda yaptığı spesifik hatalar: ${errors.join(", ")}'
            : '';

        final prompt = '''
ROLE: Deneyimli bir YDS sınav stratejisti ve İngilizce dilbilgisi uzmanısın.

TASK: "$topic" konusunda öğrencinin yanlış yaptığı noktalara odaklanarak sınav stratejisi kartı hazırla.
$errorContext

TONE: Profesyonel, direkt, stratejik. Konuyu baştan anlatma. Sadece püf noktaları, taktikler ve kritik ayrımları ver. Yetişkin bir sınav adayına hitap et.

KURALLAR:
- Konuyu baştan öğretmeye çalışma, zaten biliyor varsay.
- Sadece sınavda işe yarayacak püf noktaları ve taktikleri ver.
- Türkçe açıkla, tüm örnekler İngilizce tam cümle olsun.
- Her bölümü MUTLAKA yaz, hiçbirini atlama.
- Gereksiz giriş cümlesi yazma, direkt içeriğe gir.

OUTPUT FORMAT (bu 4 bölümü MUTLAKA ve bu sırayla yaz):

🛑 Neden Yanlış Yaptın?
[Bu konuda yapılan tipik hatanın sebebini 2 cümleyle açıkla. Spesifik ol.]

💡 Püf Noktası
[Kuralın özünü 2-3 cümleyle ver. Formül mantığında: "X gördüğünde → Y uygula" şeklinde. Hatırlaması kolay, sınavda anında uygulanabilir olsun.]

🚀 YDS Sınav Taktiği
[Sınavda bu soru tipini görünce tam olarak ne yapılacağını adım adım anlat. Hangi ipucuna bakılacak, hangi şıklar elenir, doğru cevabın özelliği ne. 3-4 cümle.]

⚡ Yanlış vs Doğru
❌ [Tam yanlış İngilizce cümle]
✅ [Tam doğru İngilizce cümle]
→ [Farkın sebebi 1 cümle]

❌ [Tam yanlış İngilizce cümle]
✅ [Tam doğru İngilizce cümle]
→ [Farkın sebebi 1 cümle]

❌ [Tam yanlış İngilizce cümle]
✅ [Tam doğru İngilizce cümle]
→ [Farkın sebebi 1 cümle]
''';

        final response = await _aiModel!.generateContent([Content.text(prompt)]);
        final text = response.text ?? 'İçerik üretilemedi.';

        cards.add(YdsTopicCard(topic: topic, explanation: text));
        debugPrint('✅ Konu kartı üretildi: $topic');
      } catch (e) {
        debugPrint('❌ Konu kartı üretme hatası ($topic): $e');
        cards.add(YdsTopicCard(
          topic: topic,
          explanation: '$topic konusu için içerik üretilemedi. Lütfen tekrar deneyin.',
        ));
      }
    }

    return cards;
  }

  // ═══════════════════════════════════════════════════════════════
  // KART TAMAMLAMA VE NOTLARA KAYIT
  // ═══════════════════════════════════════════════════════════════

  /// Tüm kartlar tamamlandığında Notlarıma kaydet
  Future<void> saveCardsToNotes({
    required int fazNumber,
    required String testType,
    required List<YdsTopicCard> cards,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) return;

    final faz = YdsFaz.getFaz(fazNumber);
    final title = '📝 YDS Faz $fazNumber ${testType == 'baslangic' ? 'Başlangıç' : 'Bitirme'} - ${faz.title}';

    final buffer = StringBuffer();
    buffer.writeln('🎯 YDS Faz $fazNumber: ${faz.title}');
    buffer.writeln('📅 ${DateTime.now().toString().substring(0, 16)}');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    for (final card in cards) {
      buffer.writeln('📌 ${card.topic}');
      buffer.writeln('─────────────────');
      buffer.writeln(card.explanation);
      buffer.writeln('');
    }

    await _noteService.saveNote(
      userId: userId,
      title: title,
      content: buffer.toString(),
    );

    debugPrint('✅ Konu kartları notlara kaydedildi: $title');
  }

  /// Analiz kartları tamamlandığında ilerlemeyi güncelle
  Future<void> completeAnalysisCards({
    required int fazNumber,
    required String testType,
  }) async {
    final progress = await getProgress();
    final fazProgress = progress.fazProgresses[fazNumber] ?? const YdsFazProgress();

    YdsFazProgress updatedFazProgress;
    if (testType == 'baslangic') {
      updatedFazProgress = fazProgress.copyWith(baslangicCardsCompleted: true);
    } else {
      updatedFazProgress = fazProgress.copyWith(
        bitirmeCardsCompleted: true,
        isCompleted: true, // Bitirme analizi bitti = faz tamamlandı
      );
    }

    final updatedProgress = progress
        .updateFazProgress(fazNumber, updatedFazProgress)
        .advanceStage();
    await saveProgress(updatedProgress);
  }

  // ═══════════════════════════════════════════════════════════════
  // DNA ENTEGRASYONU
  // ═══════════════════════════════════════════════════════════════

  /// Test sonucunu DNA'ya yansıt
  Future<void> _updateDNA(YdsTestResult result) async {
    try {
      final dna = await _dnaService.getDNA();
      if (dna == null) return;

      // Zayıf konuları DNA'ya ekle
      final newStruggles = <String>[...dna.struggles];
      for (final topic in result.wrongTopics) {
        final ydsTag = 'YDS-$topic';
        if (!newStruggles.contains(ydsTag)) {
          newStruggles.add(ydsTag);
        }
      }

      // Keşfedilen konuları güncelle
      final newDiscovered = <String>[...dna.discoveredTopics];
      for (final topic in YdsFaz.getFaz(result.fazNumber).topics) {
        final ydsTag = 'YDS-$topic';
        if (!newDiscovered.contains(ydsTag)) {
          newDiscovered.add(ydsTag);
        }
      }

      final updatedDna = dna.copyWith(
        struggles: newStruggles,
        discoveredTopics: newDiscovered,
        totalQuestionsSolved: dna.totalQuestionsSolved + result.answers.length,
        totalCorrect: dna.totalCorrect + result.totalCorrect,
        totalWrong: dna.totalWrong + result.totalWrong,
      );

      await _dnaService.saveDNA(updatedDna);
      debugPrint('✅ DNA güncellendi: +${result.answers.length} soru, ${result.wrongTopics.length} zayıf konu');
    } catch (e) {
      debugPrint('❌ DNA güncelleme hatası: $e');
    }
  }
}
