import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/smart_note_model.dart';
import '../theme/app_theme.dart';
import '../services/gemini_service.dart';
import '../services/smart_note_service.dart';

class SmartNoteDetailScreen extends StatefulWidget {
  final SmartNote note;

  const SmartNoteDetailScreen({super.key, required this.note});

  @override
  State<SmartNoteDetailScreen> createState() => _SmartNoteDetailScreenState();
}

class _SmartNoteDetailScreenState extends State<SmartNoteDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GeminiService _geminiService = GeminiService(); // Basitleştirici için

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1); // Varsayılan: Analiz sekmesi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Akıllı Not Detayı'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Orijinal'),
            Tab(text: 'Analiz'),
            Tab(text: 'Hap Bilgi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOriginalTab(),
          _buildAnalysisTab(context),
          _buildDistillTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'note_detail_fab',
        onPressed: () => _showSimplifierDialog(context),
        backgroundColor: AppTheme.accentColor,
        icon: const Icon(Icons.child_care),
        label: const Text('Basitleştir'),
      ),
    );
  }

  Widget _buildOriginalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ham OCR Metni:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: Text(widget.note.ocrText, style: const TextStyle(height: 1.5)),
          ),
          // Gelecekte buraya orijinal resim de eklenebilir
        ],
      ),
    );
  }

  Widget _buildAnalysisTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📡 Sınav Radarı Uyarıları
          if (widget.note.highlights.isNotEmpty)
            _buildRadarSection(),

          const SizedBox(height: 16),

          // 📝 Zengin Metin Görünümü
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: MarkdownBody(
              data: widget.note.organizedText,
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                p: const TextStyle(fontSize: 16, height: 1.6, color: AppTheme.textPrimary),
                strong: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
                blockquote: const TextStyle(color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                blockquoteDecoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(left: BorderSide(color: AppTheme.accentColor, width: 4)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80), // FAB için boşluk
        ],
      ),
    );
  }

  Widget _buildRadarSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // Sarı zemin
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.radar, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('SINAV RADARI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 8),
          ...widget.note.highlights.map((h) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚠️ ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    '${h.type == 'exam_radar' ? 'Sınavda Çıkabilir: ' : ''}${h.reason.isNotEmpty ? h.reason : "Önemli Bölüm"}', // Basitleştirildi çünkü metni tam bulamıyoruz
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDistillTab() {
    final summary = widget.note.summary;
    if (summary.formulas.isEmpty && summary.definitions.isEmpty) {
      return const Center(child: Text('Bu not için hap bilgi çıkarılamadı.', style: TextStyle(color: AppTheme.textMuted)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.roughSummary.isNotEmpty) ...[
            const Text('💡 Genel Özet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: AppTheme.primaryColor.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(summary.roughSummary, style: const TextStyle(fontStyle: FontStyle.italic)),
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (summary.formulas.isNotEmpty) ...[
            const Text('📐 Formüller', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...summary.formulas.map((f) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.functions, color: AppTheme.secondaryColor),
                title: Text(f, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Courier')),
              ),
            )),
            const SizedBox(height: 24),
          ],

          if (summary.definitions.isNotEmpty) ...[
            const Text('📖 Tanımlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...summary.definitions.entries.map((e) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(e.value),
              ),
            )),
          ],
        ],
      ),
    );
  }

  // 🍭 Konu Basitleştirici (Simplifier) Dialog
  Future<void> _showSimplifierDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Simplifier Prompt'unu hazırla
      String promptTemplate = await _geminiService.getPrompt('simplifier_prompt') ?? '';
      if (promptTemplate.isEmpty) promptTemplate = "Simplify this: {{text}}";
      
      final filledPrompt = promptTemplate
          .replaceAll('{{text}}', widget.note.organizedText) // Tüm notu basitleştir
          .replaceAll('{{userLevel}}', 'University Student');

      final jsonResult = await _geminiService.generateContentJson(filledPrompt);
      
      Navigator.pop(context); // Loading kapa

      if (jsonResult != null) {
        final simplifiedText = jsonResult['simplified_text'] ?? 'Basitleştirme başarısız.';
        final analogy = jsonResult['analogy_used'] ?? '';
        final takeaway = jsonResult['key_takeaway'] ?? '';

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.child_care, color: AppTheme.accentColor, size: 28),
                    SizedBox(width: 12),
                    Text('5 Yaşında Çocuğa Anlat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(simplifiedText, style: const TextStyle(fontSize: 16, height: 1.6)),
                        const SizedBox(height: 24),
                        if (analogy.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🎮 Analoji (Benzetme)', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor)),
                                const SizedBox(height: 8),
                                Text(analogy),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (takeaway.isNotEmpty) ...[
                          const Text('💡 Tek Cümlede Özet:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(takeaway, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Loading kapa
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }
}
