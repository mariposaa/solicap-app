/// SOLICAP - Prompt Router Service
/// Kullanıcı seviyesine göre AI persona yönetimi

import '../services/user_dna_service.dart';

class PromptRouter {
  static final PromptRouter _instance = PromptRouter._internal();
  factory PromptRouter() => _instance;
  PromptRouter._internal();

  final UserDNAService _dnaService = UserDNAService();

  /// Kullanıcının seviyesine göre system prompt döndür
  Future<String> getSystemPrompt() async {
    final dna = await _dnaService.getDNA();
    final grade = dna?.gradeLevel ?? '9. Sınıf';
    final exam = dna?.targetExam ?? '';
    final style = dna?.learningStyle ?? '';
    
    return _buildPersonaPrompt(grade, exam, style);
  }

  String _buildPersonaPrompt(String grade, String exam, String style) {
    // Seviye belirleme
    final level = _determineLevel(grade);
    
    // Persona şablonu (kullanıcı tarafından güncellenecek)
    String persona = '''
[SYSTEM ROLE]
Sen Türk eğitim sistemine hakim, deneyimli bir öğretmensin.
MEB müfredatına uygun şekilde çözüm yapmalısın.
''';

    // Seviyeye göre özelleştirme
    switch (level) {
      case 'ilkokul':
        persona += '''
[SEVİYE: İLKOKUL]
- Basit ve anlaşılır kelimeler kullan
- Günlük hayattan örnekler ver (elma, top, oyuncak)
- Kısa cümleler kur
- Teşvik edici ve eğlenceli ol
- Emoji kullanabilirsin 🎉
''';
        break;
        
      case 'ortaokul':
        persona += '''
[SEVİYE: ORTAOKUL]
- Orta düzey akademik dil kullan
- LGS odaklı anlatım yap
- Adım adım açıkla
- Neden-sonuç ilişkilerini göster
- Formülleri açıkla
''';
        break;
        
      case 'lise':
        persona += '''
[SEVİYE: LİSE]
- Akademik dil kullanabilirsin
- TYT/AYT odaklı anlatım yap
- Derinlemesine açıklama yap
- Alternatif çözüm yolları göster
- Sınav taktikleri ver
''';
        break;
        
      case 'universite':
        persona += '''
[SEVİYE: ÜNİVERSİTE/LİSANSÜSTÜ]
- Akademik terminoloji kullan
- Detaylı teorik açıklamalar yap
- Kaynaklara referans verebilirsin
- Profesyonel ve derinlemesine ol
''';
        break;
    }

    // Hedef sınav ekleme
    if (exam.isNotEmpty && exam != 'Yok') {
      persona += '''

[HEDEF SINAV: $exam]
Çözümlerin ve anlatımların $exam sınavına yönelik olmalı.
''';
    }

    // Öğrenme stili ekleme
    if (style.isNotEmpty) {
      persona += '''

[ÖĞRENME STİLİ: $style]
''';
      if (style.contains('Görsel')) {
        persona += 'Şemalar, grafikler ve görsel açıklamalar kullan.\n';
      } else if (style.contains('İşitsel')) {
        persona += 'Adım adım sesli anlatır gibi açıkla.\n';
      } else if (style.contains('Yaparak')) {
        persona += 'Bol örnek ve uygulama ver.\n';
      }
    }

    return persona;
  }

  String _determineLevel(String grade) {
    if (grade.contains('4') || grade.contains('5')) {
      return 'ilkokul';
    } else if (grade.contains('6') || grade.contains('7') || grade.contains('8')) {
      return 'ortaokul';
    } else if (grade.contains('9') || grade.contains('10') || 
               grade.contains('11') || grade.contains('12') || grade.contains('Mezun')) {
      return 'lise';
    } else {
      return 'universite';
    }
  }

  /// Soru çözme için tam prompt oluştur
  Future<String> buildQuestionSolvePrompt(String basePrompt) async {
    final systemPrompt = await getSystemPrompt();
    return '''
$systemPrompt

$basePrompt
''';
  }
}
