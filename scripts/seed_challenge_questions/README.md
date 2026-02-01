# Challenge Sorularını Firestore'a Yükleme

Bu script, JSON dosyalarındaki soruları Firestore `challenge_questions` koleksiyonuna ekler.

**Hazır dosyalar:**
- `questions_genel_kultur_ilkokul_50.json` – Genel Kültür (50 soru)
- `questions_matematik_ilkokul_50.json` – Matematik (50 soru)
- `questions_fen_ilkokul_50.json` – Fen Bilimleri (50 soru)
- `questions_sosyal_bilgiler_ilkokul_50.json` – Sosyal Bilgiler (50 soru)
- `questions_turkce_ilkokul_50.json` – Türkçe (50 soru)
- `questions_ingilizce_ilkokul_50.json` – İngilizce (50 soru)
- `questions_genel_kultur_ortaokul_50.json` – Genel Kültür Ortaokul 6-8 (şu an 14 soru; 50’ye tamamlanacak)

## Adımlar

1. **Node.js kurulu olsun** (v18+ önerilir).

2. **Firebase Service Account anahtarı al:**
   - [Firebase Console](https://console.firebase.google.com) → Projen (solicap) → Dişli → Proje ayarları
   - "Hizmet hesapları" sekmesi → "Yeni özel anahtar oluştur" → İndir
   - İndirdiğin JSON dosyasını bu klasöre kopyala ve adını **`serviceAccountKey.json`** yap.

3. **Bağımlılıkları yükle ve scripti çalıştır:**
   ```bash
   cd scripts/seed_challenge_questions
   npm install
   node seed.js                                    # Genel Kültür (varsayılan)
   node seed.js questions_matematik_ilkokul_50.json   # Matematik
   node seed.js questions_fen_ilkokul_50.json         # Fen Bilimleri
   node seed.js questions_sosyal_bilgiler_ilkokul_50.json   # Sosyal Bilgiler
   node seed.js questions_turkce_ilkokul_50.json            # Türkçe
   node seed.js questions_ingilizce_ilkokul_50.json         # İngilizce
   node seed.js questions_genel_kultur_ortaokul_50.json     # Genel Kültür Ortaokul 6-8
   ```

4. **Firestore kurallarını deploy et** (challenge_questions için kurallar eklendi):
   ```bash
   firebase deploy --only firestore
   ```

## Not

- `serviceAccountKey.json` dosyasını **asla** Git'e ekleme (`.gitignore`'da olmalı).
- Aynı scripti başka JSON dosyalarıyla da çalıştırabilirsin; `seed.js` içinde `questionsPath` değişkenini değiştir.
