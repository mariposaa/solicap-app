# 📊 SOLICAP - Soru Çözüm Mantığı ve Maliyet Analizi

## 🎯 Mevcut Soru Çözüm Akışı

### 1. **Görsel Soru (Image-based)**
```
1. OCR (Her zaman yapılıyor) → Gemini 2.5 Flash
   └─ Maliyet: ~0.0003 TL (1000 token input + 200 token output)
   
2. Altın DB Kontrolü (Paralel)
   ├─ Hash kontrolü (SHA256) → Ücretsiz
   ├─ Embedding araması → Ücretsiz
   └─ Sonuç:
       ├─ %80+ benzerlik → ✅ Direkt Altın DB (Maliyet: 0 TL)
       ├─ %70-80 benzerlik → Few-shot ile AI çağrısı
       └─ %70 altı → Normal AI çağrısı

3. AI Model Seçimi
   ├─ needsProModel = useDeepAnalysis || _isComplexTopic(text)
   │   └─ Görsel soru + text yok → true (varsayılan karmaşık!)
   │
   ├─ Firebase AI aktifse → Gemini 2.5 Flash (her zaman)
   └─ Fallback:
       ├─ Karmaşık görsel → _proVisionModel (Gemini 2.5 Flash)
       ├─ Basit görsel → _visionModel (Gemini 2.5 Flash)
       └─ Metin soru → _model (Gemini 2.5 Flash)
```

### 2. **Metin Soru (Text-based)**
```
1. Altın DB Kontrolü
   ├─ Embedding araması → Ücretsiz
   └─ Sonuç: (aynı mantık)

2. AI Model Seçimi
   ├─ _isComplexTopic(text) kontrolü
   │   └─ Türev, integral, grafik, limit vb. → true
   └─ Model: Gemini 2.5 Flash (her zaman)
```

---

## ⚠️ TESPİT EDİLEN SORUNLAR

### 🔴 Kritik Sorun 1: OCR Her Zaman Yapılıyor
**Durum:** Görsel sorularda OCR, Altın DB kontrolünden ÖNCE yapılıyor.

**Maliyet:**
- Her görsel soru için: ~0.0003 TL (OCR)
- Altın DB'de %80+ benzerlik olsa bile OCR maliyeti oluşuyor

**Çözüm:** OCR'ı Altın DB kontrolünden SONRA yap (Altın DB'de bulunamazsa)

---

### 🔴 Kritik Sorun 2: Görsel Soru = Varsayılan Karmaşık
**Kod:**
```dart
bool _isComplexTopic(String? text) {
  if (text == null || text.isEmpty) return true; // ❌ Görsel soru, varsayılan karmaşık
  // ...
}
```

**Sorun:** Görsel soru + text yok → `needsProModel = true` → Pro Vision seçiliyor
**Gerçek:** Pro Vision ve Flash Vision aynı model (gemini-2.5-flash) → Fark yok!

**Maliyet Etkisi:** Yok (aynı model), ama mantık hatası var.

---

### 🟡 Orta Sorun 3: Pro Vision = Flash Vision
**Durum:** Her iki model de `gemini-2.5-flash` kullanıyor.

**Kod:**
```dart
_visionModel = GenerativeModel(model: 'gemini-2.5-flash', ...);
_proVisionModel = GenerativeModel(model: 'gemini-2.5-flash', ...);
```

**Sonuç:** "Karmaşık soru" tespiti yapılsa bile aynı model kullanılıyor.

---

## 💰 GÜNCEL MALİYET TABLOSU (2024)

### Gemini 2.5 Flash
- **Input:** $0.30 / 1M token (~0.0000003 TL/token)
- **Output:** $2.50 / 1M token (~0.0000025 TL/token)
- **Görsel:** Multimodal token (1 görsel ≈ 256 token)

### Gemini 1.5 Pro (Kullanılmıyor şu anda)
- **Input (≤128K):** $3.50 / 1M token
- **Output:** $10.50 / 1M token
- **~12x daha pahalı** Flash'a göre

---

## 📈 MEVCUT MALİYET HESAPLAMASI

### Senaryo 1: Basit Görsel Soru (Altın DB'de yok)
```
1. OCR: 1000 token input + 200 token output
   = (1000 × 0.0000003) + (200 × 0.0000025)
   = 0.0003 + 0.0005 = 0.0008 TL

2. AI Çağrısı (Flash Vision):
   - Prompt: ~2000 token (few-shot dahil)
   - Görsel: ~256 token
   - Output: ~1500 token
   = (2256 × 0.0000003) + (1500 × 0.0000025)
   = 0.00068 + 0.00375 = 0.00443 TL

TOPLAM: ~0.005 TL/soru
```

### Senaryo 2: Karmaşık Görsel Soru (Türev/İntegral, Altın DB'de yok)
```
1. OCR: 0.0008 TL (aynı)

2. AI Çağrısı (Pro Vision - ama aynı model):
   - Prompt: ~2500 token (daha uzun prompt)
   - Görsel: ~256 token
   - Output: ~2000 token
   = (2756 × 0.0000003) + (2000 × 0.0000025)
   = 0.00083 + 0.005 = 0.00583 TL

TOPLAM: ~0.0066 TL/soru
```

### Senaryo 3: Altın DB'de %80+ Benzerlik
```
1. OCR: 0.0008 TL ❌ (Gereksiz!)
2. Altın DB: 0 TL ✅

TOPLAM: 0.0008 TL (OCR gereksiz)
```

### Senaryo 4: Altın DB'de %70-80 Benzerlik (Few-shot)
```
1. OCR: 0.0008 TL
2. AI Çağrısı (Few-shot örnek ile):
   - Few-shot: ~500 token ekstra
   - Prompt: ~2500 token
   - Görsel: ~256 token
   - Output: ~1500 token
   = (3256 × 0.0000003) + (1500 × 0.0000025)
   = 0.00098 + 0.00375 = 0.00473 TL

TOPLAM: ~0.0055 TL/soru
```

---

## 🎯 ÖNERİLER

### 1. **OCR'ı Altın DB Kontrolünden Sonra Yap**
```dart
// ÖNCE: Altın DB kontrolü (hash + embedding)
memoryCheck = await _memoryService.checkMemory(...);

// EĞER Altın DB'de bulunamadıysa:
if (!memoryCheck.foundInGolden) {
  // O zaman OCR yap
  questionTextForSearch = await _doOCR(imageBytes);
}
```

**Tasarruf:** %80+ benzerlik durumunda 0.0008 TL/soru

---

### 2. **İki Aşamalı Cascade: Flash → Pro**
```dart
// ÖNCE Flash dene (ucuz)
final flashSolution = await _tryFlashModel(...);

// Eğer güven skoru düşükse Pro'ya geç
if (confidenceScore < 0.80) {
  final proSolution = await _tryProModel(...);
}
```

**Avantaj:** Basit sorularda Pro maliyeti oluşmaz.

---

### 3. **Görsel Soru Karmaşıklık Tespiti**
```dart
bool _isComplexTopic(String? text, Uint8List? imageBytes) {
  // Önce text'ten kontrol et
  if (text != null && text.isNotEmpty) {
    return _checkComplexKeywords(text);
  }
  
  // Görsel soru → Basit OCR ile ön kontrol
  if (imageBytes != null) {
    final quickText = await _quickOCR(imageBytes); // Sadece keyword arama
    return _checkComplexKeywords(quickText);
  }
  
  return false; // Varsayılan: Basit
}
```

---

### 4. **Gerçek Pro Model Kullanımı (İsteğe Bağlı)**
Karmaşık sorularda gerçekten Gemini 1.5 Pro kullanmak isterseniz:

**Maliyet Artışı:**
- Flash: ~0.005 TL/soru
- Pro: ~0.06 TL/soru (12x daha pahalı)

**Öneri:** Sadece çok karmaşık sorularda (türev/integral grafik analizi) Pro kullan.

---

## 📊 MALİYET KARŞILAŞTIRMASI

| Senaryo | Mevcut | Optimize Edilmiş | Tasarruf |
|---------|--------|------------------|----------|
| Basit soru (Altın DB'de yok) | 0.005 TL | 0.0042 TL | 16% |
| Karmaşık soru (Altın DB'de yok) | 0.0066 TL | 0.0055 TL | 17% |
| %80+ benzerlik | 0.0008 TL | 0 TL | 100% |
| %70-80 benzerlik | 0.0055 TL | 0.0047 TL | 15% |

---

## ✅ UYGULANACAK DEĞİŞİKLİKLER

1. ✅ OCR'ı Altın DB kontrolünden sonra yap
2. ✅ Görsel soru karmaşıklık tespitini iyileştir
3. ⚠️ İki aşamalı cascade (Flash → Pro) - İsteğe bağlı
4. ⚠️ Gerçek Pro model kullanımı - İsteğe bağlı

---

## 🎯 SONUÇ

**Mevcut Durum:**
- Ortalama maliyet: ~0.005 TL/soru
- Altın DB'de %80+ benzerlik: 0.0008 TL (OCR gereksiz)

**Optimize Edilmiş:**
- Ortalama maliyet: ~0.004 TL/soru
- Altın DB'de %80+ benzerlik: 0 TL ✅

**Tasarruf Potansiyeli:** %20-100 (Altın DB büyüdükçe artar)
