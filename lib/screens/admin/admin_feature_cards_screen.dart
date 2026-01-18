import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/feature_cards_service.dart';

class AdminFeatureCardsScreen extends StatefulWidget {
  const AdminFeatureCardsScreen({super.key});

  @override
  State<AdminFeatureCardsScreen> createState() => _AdminFeatureCardsScreenState();
}

class _AdminFeatureCardsScreenState extends State<AdminFeatureCardsScreen> {
  List<FeatureCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _isLoading = true);
    final cards = await FeatureCardsService.getAllCards();
    setState(() {
      _cards = cards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('📢 Bilgilendirme Kartları'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCards,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditDialog(null),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 'load_defaults') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Varsayılan Kartları Ekle'),
                    content: const Text('14 adet varsayılan kart eklenecek. Mevcut kartlar silinmeyecek.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                      ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ekle')),
                    ],
                  ),
                );
                if (confirm == true) {
                  for (final card in FeatureCardsService.defaultCards) {
                    await FeatureCardsService.saveCard(card);
                  }
                  _loadCards();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ 14 varsayılan kart eklendi!')),
                    );
                  }
                }
              } else if (value == 'reset_defaults') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppTheme.surfaceColor,
                    title: const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Kartları Sıfırla'),
                      ],
                    ),
                    content: const Text(
                      'Tüm mevcut kartlar silinecek ve 14 yeni varsayılan kart yüklenecek.\n\nBu işlem geri alınamaz!',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('İptal')),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text('Sıfırla'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await FeatureCardsService.resetToDefaults();
                    _loadCards();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ 14 varsayılan kart yüklendi!')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('❌ Hata: $e')),
                      );
                    }
                  }
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'load_defaults',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text('Varsayılanları Ekle'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset_defaults',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Varsayılanları Sıfırla'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCardList(),
    );
  }

  Widget _buildCardList() {
    if (_cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 64, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            const Text('Henüz kart yok', style: TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await FeatureCardsService.initializeDefaults();
                _loadCards();
              },
              icon: const Icon(Icons.download),
              label: const Text('Varsayılanları Yükle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _cards.length,
      onReorder: _onReorder,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return _buildCardTile(card, index);
      },
    );
  }

  Widget _buildCardTile(FeatureCard card, int index) {
    return Card(
      key: ValueKey(card.id),
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: card.isActive ? card.color.withOpacity(0.3) : AppTheme.dividerColor,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: card.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(card.icon, color: card.color),
        ),
        title: Text(
          card.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: card.isActive ? AppTheme.textPrimary : AppTheme.textMuted,
          ),
        ),
        subtitle: Text(
          card.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Aktif/Pasif Switch
            Switch(
              value: card.isActive,
              activeColor: AppTheme.successColor,
              onChanged: (value) => _toggleActive(card, value),
            ),
            // Düzenle
            IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
              onPressed: () => _showEditDialog(card),
            ),
            // Sil
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.errorColor),
              onPressed: () => _confirmDelete(card),
            ),
            // Sıralama tutamacı
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    
    setState(() {
      final card = _cards.removeAt(oldIndex);
      _cards.insert(newIndex, card);
    });
    
    // Sıralamayı güncelle
    for (int i = 0; i < _cards.length; i++) {
      final updatedCard = _cards[i].copyWith(order: i);
      await FeatureCardsService.saveCard(updatedCard);
    }
  }

  Future<void> _toggleActive(FeatureCard card, bool isActive) async {
    final updatedCard = card.copyWith(isActive: isActive);
    await FeatureCardsService.saveCard(updatedCard);
    _loadCards();
  }

  Future<void> _confirmDelete(FeatureCard card) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Kartı Sil'),
        content: Text('"${card.title}" kartını silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (result == true) {
      await FeatureCardsService.deleteCard(card.id);
      _loadCards();
    }
  }

  Future<void> _showEditDialog(FeatureCard? card) async {
    final isNew = card == null;
    final titleController = TextEditingController(text: card?.title ?? '');
    final subtitleController = TextEditingController(text: card?.subtitle ?? '');
    String selectedIcon = card?.iconName ?? 'info_rounded';
    int selectedColor = card?.colorValue ?? 0xFF3B82F6;

    final result = await showDialog<FeatureCard>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          title: Text(isNew ? 'Yeni Kart Ekle' : 'Kartı Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Başlık',
                    hintText: '📸 AI Soru Çözücü',
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Açıklama
                TextField(
                  controller: subtitleController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Açıklama',
                    hintText: 'Kart açıklaması...',
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                
                // İkon Seçimi
                const Text('İkon Seç:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: FeatureCard.availableIcons.map((iconName) {
                    final iconData = FeatureCard.iconMap[iconName]!;
                    final isSelected = selectedIcon == iconName;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIcon = iconName),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(selectedColor).withOpacity(0.2) : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Color(selectedColor) : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(iconData, color: isSelected ? Color(selectedColor) : AppTheme.textMuted),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Renk Seçimi
                const Text('Renk Seç:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    0xFF3B82F6, // Blue
                    0xFF8B5CF6, // Purple
                    0xFFF59E0B, // Amber
                    0xFF10B981, // Emerald
                    0xFFEF4444, // Red
                    0xFF06B6D4, // Cyan
                    0xFFEC4899, // Pink
                    0xFF6366F1, // Indigo
                  ].map((colorValue) {
                    final isSelected = selectedColor == colorValue;
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = colorValue),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(colorValue),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: Color(colorValue).withOpacity(0.5), blurRadius: 8)]
                              : null,
                        ),
                        child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || subtitleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Başlık ve açıklama zorunludur')),
                  );
                  return;
                }
                
                final newCard = FeatureCard(
                  id: card?.id ?? 'new_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleController.text,
                  subtitle: subtitleController.text,
                  iconName: selectedIcon,
                  colorValue: selectedColor,
                  order: card?.order ?? _cards.length,
                  isActive: card?.isActive ?? true,
                );
                Navigator.pop(context, newCard);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
              child: Text(isNew ? 'Ekle' : 'Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await FeatureCardsService.saveCard(result);
      _loadCards();
    }
  }
}
