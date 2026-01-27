# 🎯 SOLICAP - Optimizasyon Yapılacaklar Listesi

## ✅ Öncelik 1: Altın DB Optimizasyonu
- [ ] OCR'ı Altın DB kontrolünden SONRA yap (hash kontrolü önce)
- [ ] %80+ benzerlik → Direkt Altın DB (0 TL maliyet)
- [ ] %70-80 benzerlik → Few-shot ile AI çağrısı

## ✅ Öncelik 2: Tiered Routing Sistemi
- [ ] **Tier 3 (Ekonomik):** Türkçe, Edebiyat, Tarih, Coğrafya, Felsefe, Din, Biyoloji → Gemini 1.5 Flash
- [ ] **Tier 2 (Orta):** Matematik (Temel), Geometri (Basit), Fizik, Kimya → Gemini 2.5 Flash
- [ ] **Tier 1 (Ağır):** Matematik (İleri - Türev/İntegral), Fizik (Karmaşık) → Gemini 1.5 Pro

## ✅ Öncelik 3: Complexity Score Algoritması
- [ ] OCR metninden keyword taraması (Türev/İntegral +50, Fonksiyon +20, vb.)
- [ ] LaTeX sembol yoğunluğu kontrolü
- [ ] Score > 40 → Pro, Score ≤ 40 → Flash
- [ ] Görsel soru varsayılanını kaldır (text yoksa false döndür)

## ✅ Öncelik 4: Fallback Mekanizması
- [ ] Flash başarısız olursa (confidence < 0.80) otomatik Pro'ya geç
- [ ] Kullanıcıya hissettirmeden çifte çağrı (sadece başarısız durumlarda)

## ✅ Öncelik 5: Model Güncellemeleri
- [ ] Gemini 1.5 Flash modeli ekle (Tier 3 için)
- [ ] Gemini 1.5 Pro modeli ekle (Tier 1 için)
- [ ] Mevcut 2.5 Flash'ı Tier 2'de kullan

## 📊 Beklenen Sonuç
- **Maliyet:** %30-50 azalma (Altın DB + Tiered Routing)
- **Başarı:** Zor sorularda %95+ (Pro garantisi)
- **Hız:** Basit sorularda daha hızlı (1.5 Flash)
