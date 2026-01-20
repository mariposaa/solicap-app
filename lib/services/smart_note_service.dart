import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/smart_note_model.dart';
import 'gemini_service.dart';

class SmartNoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GeminiService _geminiService = GeminiService(); // AI Analiz için
  
  CollectionReference get _smartNoteCollection => _firestore.collection('smart_notes');

  /// 📸 Görseli İşle Pipeline'ı (OCR -> AI -> SmartNote)
  /// Bu fonksiyon Phase 1'de sadece OCR yapar ve taslağı oluşturur.
  /// Phase 2-3'te AI analizi eklenecektir.
  Future<SmartNote?> processNote({
    required File imageFile,
    required String userId,
  }) async {
    try {
      debugPrint('🚀 Smart Note Pipeline Başlatılıyor...');

      // 1. ADIM: On-Device OCR (Maliyet: 0 TL)
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      final rawOcrText = recognizedText.text;

      debugPrint('✅ OCR Tamamlandı. Karakter sayısı: ${rawOcrText.length}');

      textRecognizer.close();

      if (rawOcrText.isEmpty) {
        debugPrint('⚠️ OCR boş metin döndürdü.');
        return null;
      }

      // 2. ADIM: Gemini 2.5 Flash ile Analiz (Real Brain Integration)
      debugPrint('🧠 AI Analizi Başlatılıyor (Prompt: smart_note_analyzer)...');
      
      final gemini = GeminiService(); // Gemini servisini kullan
      final promptKey = 'smart_note_analyzer';
      // Promptu registry'den alıp değişkenleri dolduralım
      // Not: PromptRegistryService GeminiService içinde kullanılıyor, 
      // burada direkt GeminiService metodunu çağıracağız.
      
      // Ancak GeminiService'de 'smart_note_analyzer' çağıracak özel bir metod yok.
      // Generic 'generateContentJson' metodunu kullanacağız.
      
      final promptRegistry = gemini.promptRegistry; // Getter lazım veya direkt erişim
      // Şimdilik string replace ile manuel yapalım veya GeminiService'e metod ekleyelim.
      // En temizi: GeminiService'e 'analyzeSmartNote' eklemek. 
      // Ama user 'structure' bozulmasın dedi. O zaman generic metodu kullanalım.

      // Prompt'u hazırla
      String promptTemplate = await gemini.getPrompt('smart_note_analyzer') ?? '';
      if (promptTemplate.isEmpty) {
        // Fallback
        promptTemplate = "Analyze this note: {{ocrText}}"; 
      }
      
      final filledPrompt = promptTemplate
          .replaceAll('{{ocrText}}', rawOcrText)
          .replaceAll('{{userLevel}}', 'University Student'); // TODO: UserDNA'den al
          
      // Gemini 2.5 Flash'a gönder (Token tasarrufu için sadece text)
      // GeminiService içindeki model yapısını kullanmak için yeni bir metod yazmak yerine
      // existing private modelleri açmak riskli.
      // En güvenli yol: GeminiService içine 'analyzeDocument' metodu eklemekti 
      // ama service dosyasına dokunmadan buradan halledebilir miyiz?
      // SmartNoteService içinde kendi Gemini instance'ımızı oluşturalım (Sadece bu işlem için)
      
      // HIZLI ÇÖZÜM: GeminiService public `generateContentJson` metodunu kullan.
      // Ancak bu metod 'text' alıyor, çok uzun metin olabilir.
      
      final jsonResult = await gemini.generateContentJson(filledPrompt);
      
      String organizedText = rawOcrText; // Fallback
      List<SmartHighlight> highlights = [];
      List<SmartFill> filledGaps = [];
      NoteSummary summary = NoteSummary();
      
      if (jsonResult != null) {
        debugPrint('✅ AI Analizi Başarılı! JSON ayrıştırılıyor...');
        
        organizedText = jsonResult['organized_content'] ?? rawOcrText;
        
        // Highlights
        if (jsonResult['smart_highlights'] != null) {
          highlights = (jsonResult['smart_highlights'] as List).map((h) => SmartHighlight(
            startIndex: 0, // Metin içi arama ile bulunacak (zor) veya UI'da badge olarak gösterilecek
            endIndex: 0,
            type: h['type'] ?? 'exam_radar',
            reason: h['reason'] ?? '',
            color: h['color'] ?? '#FFF59D',
          )).toList();
        }
        
        // Gaps
        if (jsonResult['filled_gaps'] != null) {
          filledGaps = (jsonResult['filled_gaps'] as List).map((g) => SmartFill(
            index: 0,
            originalFragment: g['original_fragment'] ?? '',
            filledText: g['filled_text'] ?? '',
            reasoning: '',
          )).toList();
        }
        
        // Summary
        if (jsonResult['summary'] != null) {
          final s = jsonResult['summary'];
          summary = NoteSummary(
            formulas: List<String>.from(s['formulas'] ?? []),
            definitions: Map<String, String>.from(s['definitions'] ?? {}),
            roughSummary: s['rough_summary'] ?? '',
          );
        }
      } else {
        debugPrint('⚠️ AI JSON yanıt veremedi veya hata oluştu.');
      }

      return SmartNote(
        id: '', // Firestore oluşturacak
        userId: userId,
        originalImageUrl: '', // Storage URL'i gerekir (UI tarafında yüklenecek)
        ocrText: rawOcrText,
        organizedText: organizedText,
        highlights: highlights,
        filledGaps: filledGaps,
        summary: summary,
        createdAt: DateTime.now(),
        isProcessed: jsonResult != null,
      );

    } catch (e) {
      debugPrint('❌ Smart Note İşleme Hatası: $e');
      return null;
    }
  }

  /// 💾 SmartNote Kaydet
  Future<String?> saveSmartNote(SmartNote note) async {
    try {
      final docRef = await _smartNoteCollection.add(note.toFirestore());
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Smart Note Kayıt Hatası: $e');
      return null;
    }
  }

  /// 📥 Kullanıcının Notlarını Getir
  Stream<List<SmartNote>> getUserSmartNotes(String userId) {
    return _smartNoteCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => SmartNote.fromFirestore(doc)).toList();
    });
  }
}
