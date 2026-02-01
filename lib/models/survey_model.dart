/// Akademi - Anket Modeli

import 'package:cloud_firestore/cloud_firestore.dart';

/// Soru tipi
enum SurveyQuestionType {
  singleChoice,
  multipleChoice,
  likert5,
  likert7,
  openText,
  matrix,
}

/// Soru seçeneği (tek/çoklu seçim)
class SurveyOption {
  final String label;
  final int code; // SPSS için

  SurveyOption({required this.label, required this.code});

  Map<String, dynamic> toMap() => {'label': label, 'code': code};

  factory SurveyOption.fromMap(Map<String, dynamic> m) =>
      SurveyOption(label: m['label'] ?? '', code: (m['code'] ?? 0) as int);
}

/// Likert ölçek
class SurveyLikertScale {
  final String minLabel;
  final String maxLabel;
  final int steps; // 5 veya 7

  SurveyLikertScale({required this.minLabel, required this.maxLabel, required this.steps});

  Map<String, dynamic> toMap() =>
      {'minLabel': minLabel, 'maxLabel': maxLabel, 'steps': steps};

  factory SurveyLikertScale.fromMap(Map<String, dynamic> m) =>
      SurveyLikertScale(
        minLabel: m['minLabel'] ?? '1',
        maxLabel: m['maxLabel'] ?? '5',
        steps: (m['steps'] ?? 5) as int,
      );
}

/// Matris satırı (satır etiketi + seçenekler)
class SurveyMatrixRow {
  final String label;
  final List<SurveyOption> options;

  SurveyMatrixRow({required this.label, required this.options});

  Map<String, dynamic> toMap() => {
        'label': label,
        'options': options.map((o) => o.toMap()).toList(),
      };

  factory SurveyMatrixRow.fromMap(Map<String, dynamic> m) =>
      SurveyMatrixRow(
        label: m['label'] ?? '',
        options: (m['options'] as List<dynamic>?)
                ?.map((o) => SurveyOption.fromMap(o as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

/// Tek soru
class SurveyQuestion {
  final int order;
  final String text;
  final SurveyQuestionType type;
  final bool required;
  final List<SurveyOption>? options;
  final SurveyLikertScale? likertScale;
  final List<SurveyMatrixRow>? matrixRows;

  SurveyQuestion({
    required this.order,
    required this.text,
    required this.type,
    this.required = true,
    this.options,
    this.likertScale,
    this.matrixRows,
  });

  String get typeString {
    switch (type) {
      case SurveyQuestionType.singleChoice:
        return 'single_choice';
      case SurveyQuestionType.multipleChoice:
        return 'multiple_choice';
      case SurveyQuestionType.likert5:
        return 'likert_5';
      case SurveyQuestionType.likert7:
        return 'likert_7';
      case SurveyQuestionType.openText:
        return 'open_text';
      case SurveyQuestionType.matrix:
        return 'matrix';
      default:
        return 'single_choice';
    }
  }

  static SurveyQuestionType typeFromString(String s) {
    switch (s) {
      case 'single_choice':
        return SurveyQuestionType.singleChoice;
      case 'multiple_choice':
        return SurveyQuestionType.multipleChoice;
      case 'likert_5':
        return SurveyQuestionType.likert5;
      case 'likert_7':
        return SurveyQuestionType.likert7;
      case 'open_text':
        return SurveyQuestionType.openText;
      case 'matrix':
        return SurveyQuestionType.matrix;
      default:
        return SurveyQuestionType.singleChoice;
    }
  }

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'order': order,
      'text': text,
      'type': typeString,
      'required': required,
    };
    if (options != null) m['options'] = options!.map((o) => o.toMap()).toList();
    if (likertScale != null) m['likertScale'] = likertScale!.toMap();
    if (matrixRows != null) m['matrixRows'] = matrixRows!.map((r) => r.toMap()).toList();
    return m;
  }

  factory SurveyQuestion.fromMap(Map<String, dynamic> m) {
    final type = typeFromString(m['type'] ?? 'single_choice');
    return SurveyQuestion(
      order: (m['order'] ?? 0) as int,
      text: m['text'] ?? '',
      type: type,
      required: m['required'] ?? true,
      options: (m['options'] as List<dynamic>?)
          ?.map((o) => SurveyOption.fromMap(o as Map<String, dynamic>))
          .toList(),
      likertScale: m['likertScale'] != null
          ? SurveyLikertScale.fromMap(m['likertScale'] as Map<String, dynamic>)
          : null,
      matrixRows: (m['matrixRows'] as List<dynamic>?)
          ?.map((r) => SurveyMatrixRow.fromMap(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Anket
class Survey {
  final String id;
  final String ownerId;
  final String ownerName;
  final String title;
  final List<SurveyQuestion> questions;
  final bool includeDemographics; // Demografik sorular eklendi mi
  final int priceLira; // 500, 1000, 1500
  final DateTime createdAt;
  final DateTime expiresAt; // 3 gün sonra
  final int responseCount;
  final bool isPaid; // Ödeme yapıldı mı
  final SurveyStatus status; // pending_payment, active, completed, extended

  Survey({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.questions,
    this.includeDemographics = false,
    required this.priceLira,
    required this.createdAt,
    required this.expiresAt,
    this.responseCount = 0,
    this.isPaid = false,
    this.status = SurveyStatus.pendingPayment,
  });

  bool get isActive => status == SurveyStatus.active && DateTime.now().isBefore(expiresAt);
  bool get needsUrgentFill =>
      isActive && responseCount < 50 && expiresAt.difference(DateTime.now()).inHours < 24;
  Duration get remaining => expiresAt.difference(DateTime.now());

  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'includeDemographics': includeDemographics,
      'priceLira': priceLira,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'responseCount': responseCount,
      'isPaid': isPaid,
      'status': status.name,
    };
  }

  factory Survey.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final qList = (d['questions'] as List<dynamic>?) ?? [];
    return Survey(
      id: doc.id,
      ownerId: d['ownerId'] ?? '',
      ownerName: d['ownerName'] ?? '',
      title: d['title'] ?? '',
      questions: qList.map((q) => SurveyQuestion.fromMap(q as Map<String, dynamic>)).toList(),
      includeDemographics: d['includeDemographics'] ?? false,
      priceLira: d['priceLira'] ?? 1000,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (d['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now().add(const Duration(days: 3)),
      responseCount: d['responseCount'] ?? 0,
      isPaid: d['isPaid'] ?? false,
      status: SurveyStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => SurveyStatus.pendingPayment,
      ),
    );
  }
}

enum SurveyStatus {
  pendingPayment,
  active,
  completed,
  extended,
}

/// Anket yanıtı (tek kullanıcının tüm cevapları)
class SurveyResponse {
  final String id;
  final String surveyId;
  final String userId;
  final Map<String, dynamic> answers; // questionOrder -> value (int, List<int>, String)
  final DateTime submittedAt;

  SurveyResponse({
    required this.id,
    required this.surveyId,
    required this.userId,
    required this.answers,
    required this.submittedAt,
  });

  Map<String, dynamic> toFirestore() => {
        'surveyId': surveyId,
        'userId': userId,
        'answers': answers,
        'submittedAt': Timestamp.fromDate(submittedAt),
      };

  factory SurveyResponse.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final a = d['answers'] as Map<String, dynamic>? ?? {};
    final parsed = <String, dynamic>{};
    for (final e in a.entries) {
      final v = e.value;
      if (v is List) {
        parsed[e.key] = v.cast<dynamic>();
      } else {
        parsed[e.key] = v;
      }
    }
    return SurveyResponse(
      id: doc.id,
      surveyId: d['surveyId'] ?? '',
      userId: d['userId'] ?? '',
      answers: parsed,
      submittedAt: (d['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
