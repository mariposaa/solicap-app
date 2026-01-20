import 'package:cloud_firestore/cloud_firestore.dart';

/// 🧠 KAMPÜS MODÜLÜ - Akıllı Ders Notu Modeli
class SmartNote {
  final String id;
  final String userId;
  final String originalImageUrl;
  final String ocrText;         // Raw OCR çıktısı
  final String organizedText;   // Gemini tarafından düzenlenmiş metin
  
  // 🧠 Analiz Katmanları
  final List<SmartHighlight> highlights; // AI ve Kullanıcı işaretlemeleri
  final List<SmartFill> filledGaps;      // Tamamlanan boşluklar
  final NoteSummary summary;             // Hap Bilgiler
  
  final DateTime createdAt;
  final bool isProcessed;       // AI analizi tamamlandı mı?

  SmartNote({
    required this.id,
    required this.userId,
    required this.originalImageUrl,
    required this.ocrText,
    required this.organizedText,
    required this.highlights,
    required this.filledGaps,
    required this.summary,
    required this.createdAt,
    required this.isProcessed,
  });

  /// Firestore'dan veri okuma
  factory SmartNote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return SmartNote(
      id: doc.id,
      userId: data['userId'] ?? '',
      originalImageUrl: data['originalImageUrl'] ?? '',
      ocrText: data['ocrText'] ?? '',
      organizedText: data['organizedText'] ?? '',
      highlights: (data['highlights'] as List<dynamic>?)
          ?.map((e) => SmartHighlight.fromMap(e))
          .toList() ?? [],
      filledGaps: (data['filledGaps'] as List<dynamic>?)
          ?.map((e) => SmartFill.fromMap(e))
          .toList() ?? [],
      summary: NoteSummary.fromMap(data['summary'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      isProcessed: data['isProcessed'] ?? false,
    );
  }

  /// Firestore'a veri yazma
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'originalImageUrl': originalImageUrl,
      'ocrText': ocrText,
      'organizedText': organizedText,
      'highlights': highlights.map((e) => e.toMap()).toList(),
      'filledGaps': filledGaps.map((e) => e.toMap()).toList(),
      'summary': summary.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isProcessed': isProcessed,
    };
  }
}

/// 🚥 İşaretleme (Highlight) Modeli
class SmartHighlight {
  final int startIndex;
  final int endIndex;
  final String type; // 'exam_radar' (AI), 'user_selected' (Manuel)
  final String reason; // "Sınavda çıkabilir", "Hoca uyarısı" vb.
  final String color;  // Hex kodu (Genelde sarı: #FFF59D)

  SmartHighlight({
    required this.startIndex,
    required this.endIndex,
    required this.type,
    this.reason = '',
    this.color = '#FFF59D',
  });

  factory SmartHighlight.fromMap(Map<String, dynamic> map) {
    return SmartHighlight(
      startIndex: map['startIndex'] ?? 0,
      endIndex: map['endIndex'] ?? 0,
      type: map['type'] ?? 'exam_radar',
      reason: map['reason'] ?? '',
      color: map['color'] ?? '#FFF59D',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startIndex': startIndex,
      'endIndex': endIndex,
      'type': type,
      'reason': reason,
      'color': color,
    };
  }
}

/// 🧱 Boşluk Doldurma (Context Filler) Modeli
class SmartFill {
  final int index; // Metin içindeki konumu (yaklaşık)
  final String originalFragment; // "Termodinam... yasası"
  final String filledText;       // "Termodinamiğin 1. Yasası"
  final String reasoning;        // "Bağlamdan çıkarıldı"

  SmartFill({
    required this.index,
    required this.originalFragment,
    required this.filledText,
    required this.reasoning,
  });

  factory SmartFill.fromMap(Map<String, dynamic> map) {
    return SmartFill(
      index: map['index'] ?? 0,
      originalFragment: map['originalFragment'] ?? '',
      filledText: map['filledText'] ?? '',
      reasoning: map['reasoning'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'originalFragment': originalFragment,
      'filledText': filledText,
      'reasoning': reasoning,
    };
  }
}

/// 🧪 Hap Bilgi (Distiller) Modeli
class NoteSummary {
  final List<String> formulas; // ["F=ma", "E=mc^2"]
  final Map<String, String> definitions; // {"Mitokondri": "Hücrenin..."}
  final String roughSummary;   // "Bu hafta vektörler işlendi..."

  NoteSummary({
    this.formulas = const [],
    this.definitions = const {},
    this.roughSummary = '',
  });

  factory NoteSummary.fromMap(Map<String, dynamic> map) {
    return NoteSummary(
      formulas: List<String>.from(map['formulas'] ?? []),
      definitions: Map<String, String>.from(map['definitions'] ?? {}),
      roughSummary: map['roughSummary'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formulas': formulas,
      'definitions': definitions,
      'roughSummary': roughSummary,
    };
  }
}
