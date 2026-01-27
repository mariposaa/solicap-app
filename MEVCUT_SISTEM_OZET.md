# 📊 SOLICAP - Mevcut Sistem Özeti

## 🔄 Çalışma Sırası

### Görsel Soru:
```
1. Altın DB Kontrolü (Hash + Embedding) → Ücretsiz
   ├─ %80+ benzerlik → ✅ Direkt Altın DB (Maliyet: 0 TL)
   └─ Bulunamadı → 2. adıma geç

2. OCR (Sadece gerektiğinde) → ~0.0008 TL
   └─ Text çıkarıldı

3. Few-Shot Kontrolü
   ├─ %70-80 benzerlik → Few-shot örnek ekle
   └─ %70 altı → Normal AI çağrısı

4. AI Model Seçimi
   ├─ Karmaşık (türev/integral) → Pro Vision (4096 token)
   ├─ Basit → Flash Vision (2048 token)
   └─ Model: gemini-2.5-flash (hepsi aynı)

5. AI Çağrısı → ~0.005 TL
```

### Metin Soru:
```
1. Altın DB Kontrolü (Embedding) → Ücretsiz
   └─ %80+ benzerlik → ✅ Direkt Altın DB (0 TL)

2. AI Çağrısı → ~0.005 TL
   └─ Model: gemini-2.5-flash (2048 token)
```

---

## 💰 Maliyet Hesaplaması

### Senaryo 1: Altın DB'de %80+ Benzerlik
- **Maliyet: 0 TL** ✅
- OCR atlanıyor
- AI çağrısı yok

### Senaryo 2: Altın DB'de %70-80 Benzerlik
- OCR: ~0.0008 TL
- AI çağrısı (Few-shot ile): ~0.005 TL
- **Toplam: ~0.0058 TL**

### Senaryo 3: Altın DB'de Bulunamadı
- OCR: ~0.0008 TL
- AI çağrısı: ~0.005 TL
- **Toplam: ~0.0058 TL**

---

## 🎯 Model Seçimi Mantığı

**Tüm modeller:** `gemini-2.5-flash` (aynı model)

**Farklar:**
- **Pro Vision:** 4096 token limit (karmaşık sorular)
- **Flash Vision:** 2048 token limit (basit sorular)
- **Flash Model:** 2048 token limit (metin sorular)

**Karmaşıklık Tespiti:**
- Türev, integral, limit, grafik → Pro Vision
- Diğerleri → Flash Vision

---

## 📈 Altın DB Kayıt Mantığı

**Koşullar:**
- Güven skoru ≥ 0.85 (%85)
- Validated = true
- Desteklenen ders (Türkçe dahil tüm dersler)

**Sonuç:**
- ✅ Altın DB'ye kaydedilir
- ❌ Pending DB'ye kaydedilir (düşük güven)

**Auto-promote:**
- Pending'de 5+ sorgu → Otomatik Altın DB'ye taşınır
