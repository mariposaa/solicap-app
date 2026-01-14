/// SOLICAP - PDF Exam Service
/// Deneme sınavı PDF oluşturucu

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'gemini_service.dart';

class PdfExamService {
  final GeminiService _geminiService = GeminiService();

  /// Deneme sınavı PDF'i oluştur
  Future<Uint8List> generateExamPdf({
    required String examTitle,
    required String subject,
    required List<ExamQuestion> questions,
    bool includeAnswerKey = true,
  }) async {
    final pdf = pw.Document();

    // Sayfa boyutu ve margin
    const pageFormat = PdfPageFormat.a4;

    // Kapak sayfası
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => _buildCoverPage(examTitle, subject, questions.length),
      ),
    );

    // Sorular - her sayfaya 2-3 soru
    final questionsPerPage = 3;
    for (var i = 0; i < questions.length; i += questionsPerPage) {
      final pageQuestions = questions.skip(i).take(questionsPerPage).toList();
      
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => _buildQuestionsPage(pageQuestions, i + 1),
        ),
      );
    }

    // Cevap anahtarı
    if (includeAnswerKey) {
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => _buildAnswerKeyPage(questions),
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget _buildCoverPage(String title, String subject, int questionCount) {
    return pw.Center(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'SOLICAP',
            style: pw.TextStyle(
              fontSize: 36,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            width: 100,
            height: 3,
            color: PdfColors.blue800,
          ),
          pw.SizedBox(height: 40),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              subject,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ),
          pw.SizedBox(height: 60),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              _buildInfoBox('Soru Sayısı', '$questionCount'),
              pw.SizedBox(width: 30),
              _buildInfoBox('Süre', '${questionCount * 2} dk'),
            ],
          ),
          pw.SizedBox(height: 80),
          pw.Text(
            'Ad Soyad: _______________________',
            style: const pw.TextStyle(fontSize: 14),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'Tarih: _______________________',
            style: const pw.TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildQuestionsPage(List<ExamQuestion> questions, int startNumber) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SOLICAP Deneme Sınavı',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
              ),
            ),
            pw.Text(
              'Sayfa ${((startNumber - 1) ~/ 3) + 2}',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 20),
        
        // Sorular
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final questionNumber = startNumber + index;
          
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 25),
            child: _buildQuestionItem(questionNumber, question),
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildQuestionItem(int number, ExamQuestion question) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Soru numarası ve metni
        pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: '$number. ',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.TextSpan(
                text: question.text,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        
        // Seçenekler
        ...question.options.asMap().entries.map((entry) {
          final optionIndex = entry.key;
          final option = entry.value;
          final letter = String.fromCharCode(65 + optionIndex); // A, B, C, D
          
          return pw.Padding(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 6),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 20,
                  height: 20,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.grey400),
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      letter,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Text(
                    option,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildAnswerKeyPage(List<ExamQuestion> questions) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'CEVAP ANAHTARI',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 30),
        
        // Cevaplar grid
        pw.Wrap(
          spacing: 15,
          runSpacing: 15,
          children: questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            
            return pw.Container(
              width: 80,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    '${index + 1}',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Container(
                    width: 30,
                    height: 30,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        question.correctAnswer,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        
        pw.SizedBox(height: 40),
        pw.Divider(),
        pw.SizedBox(height: 20),
        
        // Puanlama tablosu
        pw.Text(
          'Değerlendirme:',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Doğru Sayısı: _____ × ${(100 / questions.length).toStringAsFixed(1)} = _____ Puan',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// AI ile sorular üret ve PDF oluştur
  Future<Uint8List?> generateExamWithAI({
    required String subject,
    required String topic,
    required int questionCount,
    required String difficulty, // easy, medium, hard
  }) async {
    try {
      // AI'dan sorular al
      final similarQuestions = await _geminiService.generateSimilarQuestions(
        subject: subject,
        topic: topic,
        originalQuestion: 'Genel $topic sorusu',
        count: questionCount,
      );

      if (similarQuestions.isEmpty) {
        debugPrint('❌ AI soru üretemedi');
        return null;
      }

      // SimilarQuestion'ları ExamQuestion'a dönüştür
      final examQuestions = similarQuestions.map((q) => ExamQuestion(
        text: q.question,
        options: q.options,
        correctAnswer: q.correctAnswer,
        explanation: q.explanation,
      )).toList();

      return generateExamPdf(
        examTitle: '$topic Deneme Sınavı',
        subject: subject,
        questions: examQuestions,
      );
    } catch (e) {
      debugPrint('❌ PDF oluşturma hatası: $e');
      return null;
    }
  }
}

/// Sınav sorusu modeli
class ExamQuestion {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;

  ExamQuestion({
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  });
}
