import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb için
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/smart_memory_service.dart';
import '../../services/text_recognition_service.dart'; // OCR Servisi
import '../../services/gemini_service.dart'; // 🧠 AI Vision için
import '../../theme/app_theme.dart';

/// 🛠️ Admin Manüel Soru Yükleme Ekranı
/// Golden DB'ye "Sıfır AI Maliyeti" ile soru ekler.
class AdminGoldenDbScreen extends StatefulWidget {
  const AdminGoldenDbScreen({super.key});

  @override
  State<AdminGoldenDbScreen> createState() => _AdminGoldenDbScreenState();
}

class _AdminGoldenDbScreenState extends State<AdminGoldenDbScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _subjectController = TextEditingController();
  final _topicController = TextEditingController();
  final _questionTextController = TextEditingController();
  final _solutionController = TextEditingController();
  final _correctAnswerController = TextEditingController();
  
  // State
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String? _statusMessage;

  @override
  void dispose() {
    _subjectController.dispose();
    _topicController.dispose();
    _questionTextController.dispose();
    _solutionController.dispose();
    _correctAnswerController.dispose();
    super.dispose();
  }

  /// 📸 Galeriden/Kameradan Resim Seç ve OCR ile Oku
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        
        setState(() {
          _selectedImageBytes = bytes;
          _statusMessage = "📸 Görsel alındı.";
        });

        // 🧠 Canlı Tarayıcı (OCR) SADECE MOBİL'de çalışır
        // Web ve Windows'ta ML Kit desteği yoktur.
        if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
          setState(() {
             _statusMessage = "📸 Görsel alındı. OCR okunuyor...";
          });

          final file = File(pickedFile.path);
          final extractedText = await TextRecognitionService().processImage(file);

          if (extractedText != null && extractedText.isNotEmpty) {
             setState(() {
               _questionTextController.text = extractedText; 
               _statusMessage = "⚡ Metin otomatik okundu!";
             });
             
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚡ Süper! Metin görselden okundu.'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 2),
              ),
             );
          }
        } else {
           // PC/Web için sessizce geç
           setState(() {
             _statusMessage = "📸 Görsel hazır.";
           });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilemedi: $e')),
      );
    }
  }

  /// 💾 Altın DB'ye Kaydet
  Future<void> _saveToGoldenDB() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Lütfen bir soru görseli seçin!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "İşleniyor... Görsel DNA'sı çıkarılıyor...";
    });

    try {
      await SmartMemoryService().saveManualGoldenQuestion(
        imageBytes: _selectedImageBytes!,
        questionText: _questionTextController.text,
        solution: _solutionController.text,
        correctAnswer: _correctAnswerController.text,
        subject: _subjectController.text,
        topic: _topicController.text,
        source: 'admin_manual_v1',
      );

      // Başarılı!
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = "✅ BAŞARILI! Soru Altın Veritabanına Eklendi.";
          _clearForm();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Kayıt Başarılı! Artık bu soru BEDAVA çözülecek.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _statusMessage = "❌ HATA: $e";
        });
      }
    }

  }

  /// 🧠 AI Vision ile Metin Çıkar (Gemini)
  /// Karmaşık matematiksel ifadeler için
  Future<void> _extractTextWithAI() async {
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Önce bir görsel seçmelisiniz!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "🧠 Yapay Zeka (Gemini) görseli okuyor...";
    });

    try {
      final text = await GeminiService().extractTextFromImage(_selectedImageBytes!);
      
      setState(() {
        _questionTextController.text = text;
        _isLoading = false;
        _statusMessage = "✨ AI Okuması Tamamlandı! (Matematiksel Format)";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Mükemmel! Kesirler ve formüller okundu.'),
          backgroundColor: Colors.purple,
        ),
      );

    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "❌ AI Okuma Hatası: $e";
      });
    }
  }

  void _clearForm() {
    _selectedImageBytes = null;
    _questionTextController.clear();
    _solutionController.clear();
    _correctAnswerController.clear();
    // Konu ve Branch kalsın, belki ardışık giriş yapılır
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Altın DB Yükleyici'),
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Bilgilendirme Kartı
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(color: Colors.amber[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Buradan yüklenen sorular "Anında Çözüm" havuzuna eklenir ve yapay zeka maliyeti oluşturmaz.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Görsel Seçimi
              _buildImagePicker(),
              
              // ✨ AI Vision Butonu (Sadece görsel seçiliyse göster)
              if (_selectedImageBytes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _extractTextWithAI,
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Görseli Yapay Zeka ile Oku (Net)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[50],
                        foregroundColor: Colors.purple[700],
                        elevation: 0,
                        side: BorderSide(color: Colors.purple[100]!),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // 3. Form Alanları
              Row(
                children: [
                   Expanded(
                    child: _buildTextField(
                      controller: _subjectController,
                      label: 'Ders (Örn: Matematik)',
                      icon: Icons.school,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _topicController,
                      label: 'Konu (Örn: Türev)',
                      icon: Icons.category,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
               _buildTextField(
                controller: _questionTextController,
                label: 'Soru Metni (Kopyala-Yapıştır)',
                icon: Icons.text_fields,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                controller: _solutionController,
                label: 'ÇÖZÜM (Detaylı Anlatım)',
                icon: Icons.description,
                maxLines: 8,
              ),
               const SizedBox(height: 12),

              _buildTextField(
                controller: _correctAnswerController,
                label: 'Doğru Cevap (Örn: C veya 5)',
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 24),

              // 4. Durum Mesajı
              if (_statusMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _statusMessage!.startsWith('❌') ? Colors.red[50] : Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusMessage!,
                    style: TextStyle(
                      color: _statusMessage!.startsWith('❌') ? Colors.red : Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // 5. Kaydet Butonu
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveToGoldenDB,
                  icon: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'GÖMÜLÜYOR...' : 'ALTIN DB\'YE GÖM 💾'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[800],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          image: _selectedImageBytes != null
              ? DecorationImage(
                  image: MemoryImage(_selectedImageBytes!),
                  fit: BoxFit.contain,
                )
              : null,
        ),
        child: _selectedImageBytes == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Soru Fotoğrafı Seç', style: TextStyle(color: Colors.grey)),
                ],
              )
            : Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber), 
                    onPressed: () => _showImageSourceDialog(),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeriden Seç'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Fotoğraf Çek'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Bu alan zorunludur' : null,
    );
  }
}
