/// SOLICAP - Kütüphane mesaj şablonları modeli
/// library_message_templates - sadece okuma, admin ekler

import 'package:cloud_firestore/cloud_firestore.dart';

/// type: 'simple' -> tek metin (Evet, Hayır, Devam, Bırakma)
/// type: 'number_choice' -> "Bugün hedefim X saat" gibi, numberOptions ile
class LibraryMessageTemplate {
  final String id;
  final String label;
  final String type; // 'simple' | 'number_choice'
  final List<int>? numberOptions; // [1,2,3,4,5] gibi, number_choice için
  final int? order;

  LibraryMessageTemplate({
    required this.id,
    required this.label,
    required this.type,
    this.numberOptions,
    this.order,
  });

  factory LibraryMessageTemplate.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    List<int>? opts;
    final raw = d['numberOptions'];
    if (raw is List) {
      opts = raw.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).where((e) => e > 0).toList();
    }
    return LibraryMessageTemplate(
      id: doc.id,
      label: d['label'] ?? '',
      type: d['type'] ?? 'simple',
      numberOptions: opts,
      order: (d['order'] as num?)?.toInt(),
    );
  }

  /// Gönderilecek metin; number_choice için placeholder X yerine value yazılır
  String buildText([int? value]) {
    if (type == 'number_choice' && value != null && label.contains('X')) {
      return label.replaceAll('X', value.toString());
    }
    return label;
  }
}

/// Firestore boşsa kullanılacak varsayılan şablonlar
List<LibraryMessageTemplate> get defaultLibraryMessageTemplates => [
      LibraryMessageTemplate(id: 'evet', label: 'Evet', type: 'simple', order: 1),
      LibraryMessageTemplate(id: 'hayir', label: 'Hayır', type: 'simple', order: 2),
      LibraryMessageTemplate(id: 'devam', label: 'Devam', type: 'simple', order: 3),
      LibraryMessageTemplate(id: 'birakma', label: 'Bırakma', type: 'simple', order: 4),
      LibraryMessageTemplate(id: 'hedef_saat', label: 'Bugün hedefim X saat çalışmak', type: 'number_choice', numberOptions: [1, 2, 3, 4, 5], order: 5),
    ];
