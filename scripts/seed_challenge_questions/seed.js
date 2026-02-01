/**
 * Solicap - Challenge sorularını Firestore'a yükler
 * Kullanım: node seed.js [dosya.json]
 * Örnek: node seed.js  → Genel Kültür (varsayılan)
 *        node seed.js questions_matematik_ilkokul_50.json  → Matematik
 * Gereksinim: serviceAccountKey.json (Firebase Console > Proje Ayarları > Hizmet Hesapları > Yeni özel anahtar)
 */

import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Service account key dosyası (Firebase Console'dan indir, bu klasöre serviceAccountKey.json olarak koy)
const keyPath = join(__dirname, 'serviceAccountKey.json');
let key;
try {
  key = JSON.parse(readFileSync(keyPath, 'utf8'));
} catch (e) {
  console.error('Hata: serviceAccountKey.json bulunamadı veya geçersiz.');
  console.error('Firebase Console > Proje Ayarları > Hizmet Hesapları > Yeni özel anahtar indir.');
  process.exit(1);
}

initializeApp({ credential: cert(key) });
const db = getFirestore();

// İsteğe bağlı: node seed.js questions_matematik_ilkokul_50.json
const fileName = process.argv[2] || 'questions_genel_kultur_ilkokul_50.json';
const questionsPath = join(__dirname, fileName);
const questions = JSON.parse(readFileSync(questionsPath, 'utf8'));
console.log(`Yükleniyor: ${fileName}`);

async function seed() {
  const col = db.collection('challenge_questions');
  let added = 0;
  for (const q of questions) {
    const doc = {
      category: q.category,
      difficulty: q.difficulty,
      questionText: q.questionText,
      options: q.options,
      correctIndex: q.correctIndex,
      timeLimitSec: q.timeLimitSec ?? 15,
      explanation: q.explanation ?? null,
      imageUrl: q.imageUrl ?? null,
      isActive: q.isActive !== false,
      createdAt: new Date(),
    };
    await col.add(doc);
    added++;
    if (added % 10 === 0) console.log(`${added} soru eklendi...`);
  }
  console.log(`Tamamlandı: ${added} soru challenge_questions koleksiyonuna eklendi.`);
}

seed().catch((e) => {
  console.error('Seed hatası:', e);
  process.exit(1);
});
