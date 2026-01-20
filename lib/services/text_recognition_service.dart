import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// 📷 Canlı Tarayıcı Servisi (OCR)
/// Görseldeki metni internet olmadan (On-Device) okur.
class TextRecognitionService {
  static final TextRecognitionService _instance = TextRecognitionService._internal();
  factory TextRecognitionService() => _instance;
  TextRecognitionService._internal();

  // ML Kit Text Recognizer
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  /// Görselden metin oku
  Future<String?> processImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.isEmpty) {
        debugPrint('⚠️ OCR: Metin bulunamadı.');
        return null;
      }

      debugPrint('✅ OCR Başarılı: ${recognizedText.text.length} karakter okundu.');
      return recognizedText.text;
    } catch (e) {
      debugPrint('❌ OCR Hatası: $e');
      return null;
    }
  }

  /// Servisi kapat
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}
