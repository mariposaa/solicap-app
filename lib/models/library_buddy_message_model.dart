/// SOLICAP - Kütüphane Arkadaşın Olacak mesaj modeli
/// library_buddy_matches/{matchId}/messages/{messageId}

import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryBuddyMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  LibraryBuddyMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory LibraryBuddyMessage.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return LibraryBuddyMessage(
      id: doc.id,
      senderId: d['senderId'] ?? '',
      text: d['text'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'senderId': senderId,
        'text': text,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
