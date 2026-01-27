/// 📚 SINAVA HAZIRLIK MODÜLÜ - Veri Modelleri
/// Solicap Exam Engine v2026 - Gemini 2.5 Flash Optimized
import 'package:cloud_firestore/cloud_firestore.dart';

/// 📖 Çalışma Rehberi Bölümü (Chapter)
class StudyChapter {
  final String chapterTitle;
  final String contentMarkdown;
  final List<String> criticalWarnings;

  StudyChapter({
    required this.chapterTitle,
    required this.contentMarkdown,
    this.criticalWarnings = const [],
  });

  factory StudyChapter.fromJson(Map<String, dynamic> json) {
    return StudyChapter(
      chapterTitle: json['chapter_title'] ?? '',
      contentMarkdown: json['content_markdown'] ?? '',
      criticalWarnings: (json['critical_warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'chapter_title': chapterTitle,
        'content_markdown': contentMarkdown,
        'critical_warnings': criticalWarnings,
      };
}

/// 📖 Çalışma Rehberi (Study Guide)
class StudyGuide {
  final String title;
  final String estimatedStudyTime;
  final List<StudyChapter> chapters;

  StudyGuide({
    required this.title,
    required this.estimatedStudyTime,
    required this.chapters,
  });

  factory StudyGuide.fromJson(Map<String, dynamic> json) {
    return StudyGuide(
      title: json['title'] ?? '',
      estimatedStudyTime: json['estimated_study_time'] ?? '30 dk',
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => StudyChapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'estimated_study_time': estimatedStudyTime,
        'chapters': chapters.map((c) => c.toJson()).toList(),
      };
}

/// 🃏 Ezber Kartı (Flashcard)
class Flashcard {
  final String front; // Soru / Terim / Tarih
  final String back; // Cevap / Tanım / Olay
  final String tag; // Tanım, Tarih, Formül, Kavram

  Flashcard({
    required this.front,
    required this.back,
    required this.tag,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      front: json['front'] ?? '',
      back: json['back'] ?? '',
      tag: json['tag'] ?? 'Kavram',
    );
  }

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'tag': tag,
      };
}

/// 📚 Sınav Hazırlık Paketi (Ana Model)
class ExamPrep {
  final String id;
  final String courseId;
  final String userId;
  final String courseName;
  final StudyGuide studyGuide;
  final List<Flashcard> flashcards;
  final DateTime createdAt;
  final int noteCount; // Kaç nottan üretildi

  ExamPrep({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.courseName,
    required this.studyGuide,
    required this.flashcards,
    required this.createdAt,
    this.noteCount = 0,
  });

  factory ExamPrep.fromJson(Map<String, dynamic> json, String id) {
    return ExamPrep(
      id: id,
      courseId: json['courseId'] ?? '',
      userId: json['userId'] ?? '',
      courseName: json['courseName'] ?? '',
      studyGuide: StudyGuide.fromJson(
          json['study_guide'] as Map<String, dynamic>? ?? {}),
      flashcards: (json['flashcards'] as List<dynamic>?)
              ?.map((e) => Flashcard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      noteCount: json['noteCount'] ?? 0,
    );
  }

  factory ExamPrep.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExamPrep.fromJson(data, doc.id);
  }

  Map<String, dynamic> toJson() => {
        'courseId': courseId,
        'userId': userId,
        'courseName': courseName,
        'study_guide': studyGuide.toJson(),
        'flashcards': flashcards.map((f) => f.toJson()).toList(),
        'createdAt': Timestamp.fromDate(createdAt),
        'noteCount': noteCount,
      };

  /// Toplam bölüm sayısı
  int get chapterCount => studyGuide.chapters.length;

  /// Toplam flashcard sayısı
  int get flashcardCount => flashcards.length;

  /// Kritik uyarıların toplam sayısı
  int get warningCount => studyGuide.chapters
      .fold(0, (sum, chapter) => sum + chapter.criticalWarnings.length);
}
