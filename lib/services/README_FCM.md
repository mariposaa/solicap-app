# Firebase Cloud Messaging (FCM) – Push Bildirimler

## Uygulama tarafı (yapıldı)
- **firebase_messaging** eklendi; **FcmService** ile izin, token alma ve dinleyiciler ayarlanıyor.
- Giriş yapan kullanıcının FCM token’ı **Firestore**’a yazılıyor: `user_fcm_tokens/{userId}` → `token`, `updatedAt`.
- **main.dart:** Uygulama açılışında `FcmService().initialize()` çağrılıyor.
- **Splash:** Kullanıcı giriş yaptıysa `FcmService().saveTokenForCurrentUser()` ile token kaydediliyor.
- **Android:** `AndroidManifest.xml` içinde FCM varsayılan bildirim kanalı tanımlandı.

## Güncelleme / duyuru göndermek

### 1) Firebase Console üzerinden (tek seferlik / test)
1. [Firebase Console](https://console.firebase.google.com) → Projen (solicap) → **Engage** → **Messaging** (veya **Cloud Messaging**).
2. **Create your first campaign** veya **New campaign** → **Firebase Notification messages**.
3. **Notification title** ve **Notification text** doldur.
4. **Send test message** ile kendi cihazına test etmek için:
   - Uygulamayı telefonda aç, giriş yap, bir süre bekle (token yazılsın).
   - Firestore’da `user_fcm_tokens` koleksiyonundan kendi `userId` dokümanındaki `token` değerini kopyala.
   - Messaging’de **Send test message** → **FCM registration token** alanına bu token’ı yapıştır → Test.
5. **Target:** “Send to topic” veya “Send to single device” (token ile). Tüm kullanıcılara göndermek için önce bir **topic**’e subscribe etmek gerekir (şu an uygulama tarafında topic yok; istersen eklenebilir).

### 2) Belirli kullanıcıya göndermek (token ile)
- Firestore’da `user_fcm_tokens/{userId}` dokümanındaki `token` değerini al.
- Firebase Console Messaging’de “Single device” seçip bu token’ı kullan VEYA Cloud Functions ile `admin.messaging().send({ token: token, notification: { title, body } })` çağır.

### 3) Tüm kullanıcılara / konuya göndermek (Cloud Functions)
- İleride: Tüm token’ları Firestore’dan okuyup tek tek veya toplu göndermek için Cloud Functions yazılabilir.
- Veya uygulama tarafında her kullanıcıyı bir topic’e (örn. `all_users`) subscribe edip Console’dan “Send to topic: all_users” ile duyuru yapılabilir.

## iOS – Yapman gerekenler (adım adım)

### 1. Xcode’da projeyi aç
- `ios/Runner.xcworkspace` dosyasını Xcode ile aç (`.xcodeproj` değil, `.xcworkspace`).

### 2. Push Notifications capability
- Sol taraftan **Runner** projesini seç → **Signing & Capabilities** sekmesi.
- **+ Capability** tıkla → **Push Notifications** ara ve ekle.

### 3. Background Modes
- Aynı **Signing & Capabilities** ekranında **+ Capability** → **Background Modes** ekle (zaten varsa sadece işaretle).
- **Background Modes** listesinde **Remote notifications** kutusunu işaretle.

### 4. APNs key’i Firebase’e yükle
- **Apple Developer** (developer.apple.com) → **Certificates, Identifiers & Profiles** → **Keys**.
- Yeni key oluştur (veya mevcut bir key kullan), **Apple Push Notifications service (APNs)** işaretli olsun.
- Key’i indir (`.p8` dosyası), **Key ID** ve **Team ID** / **Bundle ID** bilgilerini not al.
- **Firebase Console** → Projen (solicap) → Dişli **Project settings** → **Cloud Messaging** sekmesi.
- **Apple app configuration** bölümünde **APNs Authentication Key** ile `.p8` dosyasını yükle; **Key ID** ve **Team ID** gir.

(Alternatif: APNs certificate ile de yapılabilir; key yöntemi daha pratik.)

### 5. Test
- Uygulamayı gerçek bir iPhone’da çalıştır (simülatör push almaz).
- Giriş yap, bir süre bekle; Firestore’da `user_fcm_tokens` içinde token oluşmalı.
- Firebase Console → Messaging → **Send test message** ile bu token’a bildirim gönder.

## Özet
- Token’lar `user_fcm_tokens/{userId}` içinde; giriş sonrası otomatik yazılıyor.
- Güncelleme / bilgilendirme için Firebase Console → Messaging ile bildirim oluşturup tek cihaz (token) veya topic ile gönderebilirsin.
