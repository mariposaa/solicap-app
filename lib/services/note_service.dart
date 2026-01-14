import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/note_model.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _noteCollection => _firestore.collection('user_notes');

  /// Yeni bir not kaydet
  Future<String?> saveNote({
    required String userId,
    required String title,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final docRef = await _noteCollection.add({
        'userId': userId,
        'title': title,
        'content': content,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Not kaydetme hatası: $e');
      return null;
    }
  }

  /// Kullanıcının tüm notlarını getir
  Stream<List<StudyNote>> getUserNotes(String userId) {
    return _noteCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => StudyNote.fromFirestore(doc)).toList();
    });
  }

  /// Notu sil
  Future<void> deleteNote(String noteId) async {
    try {
      await _noteCollection.doc(noteId).delete();
    } catch (e) {
      debugPrint('❌ Not silme hatası: $e');
    }
  }
}
