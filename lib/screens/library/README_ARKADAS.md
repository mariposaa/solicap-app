# Kütüphane – Arkadaşın Olacak

## Yapılanlar
- **Kriter formu:** LGS, YKS TYT, Sayısal/Sözel/Eşit Ağırlık, KPSS, ALES, DGS (max 2).
- **Havuz ve eşleşme:** `library_buddy_pool`, `library_buddy_matches`; ortak kriterle otomatik eşleşme.
- **Son X saatte aktif:** Eşleşen arkadaş listesinde karşı tarafın `lastSeen` bilgisi gösteriliyor.
- **Mesaj ekranı:** Sadece şablon mesajlar; `library_buddy_matches/{matchId}/messages` alt koleksiyonu.
- **Şablonlar:** `library_message_templates` (Firestore boşsa uygulama varsayılan listeyi kullanır).
- **10 dk sonra silme:** Chat açılışında 10 dakikadan eski mesajlar siliniyor.

## Opsiyonel: Eşleşme push bildirimi
Yeni eşleşme olduğunda kullanıcıya push bildirimi göndermek için:

1. **Firebase Cloud Functions** kur (projede henüz yok).
2. `library_buddy_matches` koleksiyonunda **onCreate** tetikleyicisi ekle.
3. Oluşan dokümandan `user1Id` / `user2Id` al; bildirimi **yeni eklenmeyen** kullanıcıya gönder (eşleşmeyi oluşturan zaten uygulamada).
4. FCM token’ı `users/{userId}` veya `user_dna/{userId}` içinde saklanıyorsa, Admin SDK ile ilgili kullanıcıya bildirim gönder.

Örnek (Node.js):
```js
exports.onLibraryBuddyMatchCreated = functions.firestore
  .document('library_buddy_matches/{matchId}')
  .onCreate(async (snap, ctx) => {
    const d = snap.data();
    const recipientId = d.user1Id; // veya hangi kullanıcı “diğer” ise
    const senderName = d.user2Name;
    // recipientId için FCM token al, mesaj gönder: "X seninle eşleşti!"
  });
```
