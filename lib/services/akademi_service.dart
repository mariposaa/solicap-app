/// Akademi - Anket Servisi
/// Anket oluşturma, AI parse, yanıt toplama, SPSS export

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/survey_model.dart';
import 'auth_service.dart';
import 'user_dna_service.dart';
import 'points_service.dart';

class AkademiService {
  static final AkademiService _instance = AkademiService._internal();
  factory AkademiService() => _instance;
  AkademiService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final UserDNAService _dnaService = UserDNAService();
  final PointsService _pointsService = PointsService();

  static const String _surveysCollection = 'akademi_surveys';
  static const String _responsesCollection = 'akademi_responses';

  /// Fiyat hesapla: 1-20: 500₺ | 21-50: 1000₺ | 50+: 1500₺
  static int calculatePrice(int questionCount) {
    if (questionCount <= 20) return 500;
    if (questionCount <= 50) return 1000;
    return 1500;
  }

  /// Demografik sorular (eklenecekse)
  static List<SurveyQuestion> getDemographicQuestions() {
    return [
      SurveyQuestion(
        order: -3,
        text: 'Yaş aralığınız?',
        type: SurveyQuestionType.singleChoice,
        required: true,
        options: [
          SurveyOption(label: '18-24', code: 1),
          SurveyOption(label: '25-34', code: 2),
          SurveyOption(label: '35-44', code: 3),
          SurveyOption(label: '45+', code: 4),
        ],
      ),
      SurveyQuestion(
        order: -2,
        text: 'Eğitim durumunuz?',
        type: SurveyQuestionType.singleChoice,
        required: true,
        options: [
          SurveyOption(label: 'Lise', code: 1),
          SurveyOption(label: 'Ön lisans', code: 2),
          SurveyOption(label: 'Lisans', code: 3),
          SurveyOption(label: 'Yüksek lisans', code: 4),
          SurveyOption(label: 'Doktora', code: 5),
        ],
      ),
      SurveyQuestion(
        order: -1,
        text: 'Cinsiyetiniz?',
        type: SurveyQuestionType.singleChoice,
        required: true,
        options: [
          SurveyOption(label: 'Kadın', code: 1),
          SurveyOption(label: 'Erkek', code: 2),
          SurveyOption(label: 'Belirtmek istemiyorum', code: 3),
        ],
      ),
    ];
  }

  /// Görselden anket parse et (Gemini Vision)
  Future<List<SurveyQuestion>> parseSurveyFromImage(Uint8List imageBytes) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) throw Exception('GEMINI_API_KEY bulunamadı');

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 8192,
        responseMimeType: 'application/json',
      ),
    );

    const prompt = '''
Bu anket görselini analiz et. Her soru için JSON formatında çıktı ver.
Soru tipleri: single_choice, multiple_choice, likert_5, likert_7, open_text, matrix
Tablolu sorular için matrix kullan. Her seçeneğe SPSS için 1,2,3... kod ver.

Örnek çıktı:
{
  "questions": [
    {
      "order": 1,
      "text": "Soru metni",
      "type": "single_choice",
      "required": true,
      "options": [{"label": "Seçenek A", "code": 1}, {"label": "Seçenek B", "code": 2}]
    },
    {
      "order": 2,
      "text": "Değerlendirme",
      "type": "likert_5",
      "required": true,
      "likertScale": {"minLabel": "Hiç katılmıyorum", "maxLabel": "Tamamen katılıyorum", "steps": 5}
    },
    {
      "order": 3,
      "text": "Matris sorusu",
      "type": "matrix",
      "required": true,
      "matrixRows": [{"label": "Satır 1", "options": [{"label": "Evet", "code": 1}, {"label": "Hayır", "code": 2}]}]
    }
  ]
}
Sadece JSON döndür, başka metin ekleme.
''';

    final response = await model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ]),
    ]);

    final text = response.text;
    if (text == null || text.isEmpty) throw Exception('AI yanıt vermedi');

    return _parseQuestionsFromJson(text);
  }

  List<SurveyQuestion> _parseQuestionsFromJson(String jsonText) {
    String clean = jsonText.trim();
    if (clean.startsWith('```')) {
      clean = clean.replaceFirst(RegExp(r'^```\w*\n?'), '').replaceFirst(RegExp(r'\n?```$'), '');
    }
    final map = jsonDecode(clean) as Map<String, dynamic>;
    final list = (map['questions'] as List<dynamic>?) ?? [];
    final questions = <SurveyQuestion>[];
    for (var i = 0; i < list.length; i++) {
      final q = list[i] as Map<String, dynamic>;
      q['order'] = i + 1;
      questions.add(SurveyQuestion.fromMap(q));
    }
    return questions;
  }

  /// Anket oluştur (ödemesiz - pending)
  Future<String> createSurvey({
    required String title,
    required List<SurveyQuestion> questions,
    required bool includeDemographics,
  }) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Giriş yapılmamış');

    final dna = await _dnaService.getDNA();
    final ownerName = dna?.userName ?? 'Araştırmacı';

    var allQuestions = List<SurveyQuestion>.from(questions);
    if (includeDemographics) {
      final demos = getDemographicQuestions();
      allQuestions = [
        ...demos.asMap().entries.map((e) => SurveyQuestion(
          order: e.key + 1,
          text: e.value.text,
          type: e.value.type,
          required: e.value.required,
          options: e.value.options,
        )),
        ...allQuestions.asMap().entries.map((e) {
          final q = e.value;
          return SurveyQuestion(
            order: demos.length + e.key + 1,
            text: q.text,
            type: q.type,
            required: q.required,
            options: q.options,
            likertScale: q.likertScale,
            matrixRows: q.matrixRows,
          );
        }),
      ];
    } else {
      for (var i = 0; i < allQuestions.length; i++) {
        final q = allQuestions[i];
        allQuestions[i] = SurveyQuestion(
          order: i + 1,
          text: q.text,
          type: q.type,
          required: q.required,
          options: q.options,
          likertScale: q.likertScale,
          matrixRows: q.matrixRows,
        );
      }
    }

    final price = calculatePrice(allQuestions.length);
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(days: 3));

    final survey = Survey(
      id: '',
      ownerId: userId,
      ownerName: ownerName,
      title: title,
      questions: allQuestions,
      includeDemographics: includeDemographics,
      priceLira: price,
      createdAt: now,
      expiresAt: expiresAt,
      isPaid: false,
      status: SurveyStatus.pendingPayment,
    );

    final ref = await _firestore.collection(_surveysCollection).add(survey.toFirestore());
    return ref.id;
  }

  /// Ödemeyi tamamla (IAP sonrası çağrılacak)
  Future<void> completePayment(String surveyId) async {
    final doc = await _firestore.collection(_surveysCollection).doc(surveyId).get();
    if (!doc.exists) throw Exception('Anket bulunamadı');
    final s = Survey.fromFirestore(doc);
    await _firestore.collection(_surveysCollection).doc(surveyId).update({
      'isPaid': true,
      'status': SurveyStatus.active.name,
    });
    debugPrint('✅ Akademi anket ödemesi tamamlandı: $surveyId');
  }

  /// Doldurulabilir anketeri getir (stream)
  Stream<List<Survey>> getActiveSurveysStream() {
    return _firestore
        .collection(_surveysCollection)
        .where('isPaid', isEqualTo: true)
        .where('status', isEqualTo: SurveyStatus.active.name)
        .orderBy('expiresAt', descending: false)
        .snapshots()
        .map((s) => s.docs.map((d) => Survey.fromFirestore(d)).toList());
  }

  /// Kullanıcının oluşturduğu anketeri getir
  Stream<List<Survey>> getMySurveysStream() {
    final userId = _authService.currentUserId;
    if (userId == null) return Stream.value([]);
    return _firestore
        .collection(_surveysCollection)
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Survey.fromFirestore(d)).toList());
  }

  /// Admin: Tüm anketeri getir (takip için)
  Stream<List<Survey>> getAdminSurveysStream() {
    return _firestore
        .collection(_surveysCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Survey.fromFirestore(d)).toList());
  }

  /// Kullanıcı bu anketi doldurmuş mu?
  Future<bool> hasUserResponded(String surveyId) async {
    final userId = _authService.currentUserId;
    if (userId == null) return false;
    final q = await _firestore
        .collection(_responsesCollection)
        .where('surveyId', isEqualTo: surveyId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  /// Anketi doldur + 50 puan ver
  Future<void> submitResponse(String surveyId, Map<String, dynamic> answers) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Giriş yapılmamış');

    final already = await hasUserResponded(surveyId);
    if (already) throw Exception('Bu anketi zaten doldurdunuz');

    await _firestore.collection(_responsesCollection).add({
      'surveyId': surveyId,
      'userId': userId,
      'answers': answers,
      'submittedAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection(_surveysCollection).doc(surveyId).update({
      'responseCount': FieldValue.increment(1),
    });

    await _pointsService.addPoints(50, 'akademi_survey_fill');
    debugPrint('✅ Anket yanıtı kaydedildi +50 puan');
  }

  /// Anket yanıtlarını getir (sadece anket sahibi)
  Future<List<SurveyResponse>> getResponsesForSurvey(String surveyId) async {
    final userId = _authService.currentUserId;
    if (userId == null) throw Exception('Giriş yapılmamış');

    final surveyDoc = await _firestore.collection(_surveysCollection).doc(surveyId).get();
    if (!surveyDoc.exists) throw Exception('Anket bulunamadı');
    final survey = Survey.fromFirestore(surveyDoc);
    if (survey.ownerId != userId) throw Exception('Bu anket size ait değil');

    final snapshot = await _firestore
        .collection(_responsesCollection)
        .where('surveyId', isEqualTo: surveyId)
        .get();

    return snapshot.docs.map((d) => SurveyResponse.fromFirestore(d)).toList();
  }

  /// CSV olarak dışa aktar (SPSS uyumlu)
  Future<String> exportSurveyToCsv(String surveyId) async {
    final surveyDoc = await _firestore.collection(_surveysCollection).doc(surveyId).get();
    if (!surveyDoc.exists) throw Exception('Anket bulunamadı');
    final survey = Survey.fromFirestore(surveyDoc);

    final responses = await getResponsesForSurvey(surveyId);

    final questions = survey.questions..sort((a, b) => a.order.compareTo(b.order));
    final headers = questions.asMap().entries.map((e) => 'Q${e.key + 1}').toList();
    final headerLine = headers.join(';');

    final sb = StringBuffer();
    sb.writeln(headerLine);

    for (final r in responses) {
      final row = <String>[];
      for (var i = 0; i < questions.length; i++) {
        final q = questions[i];
        final key = q.order.toString();
        var val = r.answers[key];
        String cell = '';
        if (val != null) {
          if (val is List) {
            cell = val.join(',');
          } else if (val is Map) {
            cell = (val as Map).values.map((e) => e.toString()).join(',');
          } else {
            cell = val.toString();
          }
        }
        row.add(cell.replaceAll(';', ',').replaceAll('\n', ' '));
      }
      sb.writeln(row.join(';'));
    }

    return sb.toString();
  }

  /// Süre uzat (1 gün)
  Future<void> extendSurvey(String surveyId) async {
    final doc = await _firestore.collection(_surveysCollection).doc(surveyId).get();
    if (!doc.exists) throw Exception('Anket bulunamadı');
    final s = Survey.fromFirestore(doc);
    final newExpires = s.expiresAt.add(const Duration(days: 1));
    await _firestore.collection(_surveysCollection).doc(surveyId).update({
      'expiresAt': Timestamp.fromDate(newExpires),
      'status': SurveyStatus.extended.name,
    });
  }
}
