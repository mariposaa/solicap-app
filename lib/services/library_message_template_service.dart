/// SOLICAP - Kütüphane mesaj şablonları servisi
/// library_message_templates - okuma; boşsa varsayılan listeyi döndürür

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/library_message_template_model.dart';

class LibraryMessageTemplateService {
  static final LibraryMessageTemplateService _instance = LibraryMessageTemplateService._internal();
  factory LibraryMessageTemplateService() => _instance;
  LibraryMessageTemplateService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'library_message_templates';

  /// Şablonlar stream; Firestore boşsa varsayılan listeyi döndürür
  Stream<List<LibraryMessageTemplate>> getTemplatesStream() {
    return _firestore.collection(_collection).snapshots().map((snap) {
      if (snap.docs.isEmpty) return defaultLibraryMessageTemplates;
      final list = snap.docs.map((d) => LibraryMessageTemplate.fromFirestore(d)).toList();
      list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      return list.isEmpty ? defaultLibraryMessageTemplates : list;
    }).handleError((e) {
      debugPrint('❌ LibraryMessageTemplateService getTemplatesStream: $e');
      return Stream.value(defaultLibraryMessageTemplates);
    });
  }

  /// Tek seferlik şablon listesi (Firestore boşsa varsayılan)
  Future<List<LibraryMessageTemplate>> getTemplates() async {
    try {
      final snap = await _firestore.collection(_collection).get();
      if (snap.docs.isEmpty) return defaultLibraryMessageTemplates;
      final list = snap.docs.map((d) => LibraryMessageTemplate.fromFirestore(d)).toList();
      list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
      return list;
    } catch (e) {
      debugPrint('❌ LibraryMessageTemplateService getTemplates: $e');
      return defaultLibraryMessageTemplates;
    }
  }
}
