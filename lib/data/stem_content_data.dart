/// SOLICAP - STEM İçerik Veritabanı
/// 5. Sınıf + 8. Sınıf (LGS) + 12. Sınıf + TYT + AYT

import '../models/stem_models.dart';
import 'stem_content_12.dart';
import 'stem_content_tyt.dart';
import 'stem_content_ayt.dart';
import 'kpss_content_turkce.dart';
import 'kpss_content_matematik.dart';

// ═══════════════════════════════════════════════════════════════
// 5. SINIF MATEMATİK ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif5MatUnits = [
  StemUnit(
    id: 's5_mat_u1',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 1,
    title: 'Doğal Sayılar ve İşlemler',
    titleTr: 'Doğal Sayılar ve İşlemler',
    icon: '🔢',
  ),
  StemUnit(
    id: 's5_mat_u2',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 2,
    title: 'Kesirler',
    titleTr: 'Kesirler',
    icon: '🍕',
  ),
  StemUnit(
    id: 's5_mat_u3',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 3,
    title: 'Ondalık Gösterim',
    titleTr: 'Ondalık Gösterim',
    icon: '🔟',
  ),
  StemUnit(
    id: 's5_mat_u4',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 4,
    title: 'Yüzde Hesaplamaları',
    titleTr: 'Yüzde Hesaplamaları',
    icon: '💯',
  ),
  StemUnit(
    id: 's5_mat_u5',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 5,
    title: 'Alan ve Çevre Ölçme',
    titleTr: 'Alan ve Çevre Ölçme',
    icon: '📐',
  ),
  StemUnit(
    id: 's5_mat_u6',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.matematik,
    order: 6,
    title: 'Veri Toplama ve Grafik Okuma',
    titleTr: 'Veri Toplama ve Grafik Okuma',
    icon: '📊',
  ),
];

// ═══════════════════════════════════════════════════════════════
// 5. SINIF FEN BİLİMLERİ ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif5FenUnits = [
  StemUnit(
    id: 's5_fen_u1',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 1,
    title: 'Canlılar Dünyası',
    titleTr: 'Canlılar Dünyası',
    icon: '🔬',
  ),
  StemUnit(
    id: 's5_fen_u2',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 2,
    title: 'Kuvvet ve Hareket',
    titleTr: 'Kuvvet ve Hareket',
    icon: '🏃',
  ),
  StemUnit(
    id: 's5_fen_u3',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 3,
    title: 'Maddenin Değişimi',
    titleTr: 'Maddenin Değişimi',
    icon: '🧊',
  ),
  StemUnit(
    id: 's5_fen_u4',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 4,
    title: 'Işık ve Ses',
    titleTr: 'Işık ve Ses',
    icon: '💡',
  ),
  StemUnit(
    id: 's5_fen_u5',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 5,
    title: 'Elektrik',
    titleTr: 'Elektrik',
    icon: '⚡',
  ),
  StemUnit(
    id: 's5_fen_u6',
    gradeLevel: GradeLevel.sinif5,
    subject: StemSubject.fenBilimleri,
    order: 6,
    title: 'İnsan ve Çevre',
    titleTr: 'İnsan ve Çevre',
    icon: '🌍',
  ),
];

// ═══════════════════════════════════════════════════════════════
// 8. SINIF (LGS) MATEMATİK ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif8MatUnits = [
  StemUnit(id: 's8_mat_u1', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 1, title: 'Çarpanlar, Katlar ve Üslü İfadeler', titleTr: 'Çarpanlar, Katlar ve Üslü İfadeler', icon: '🔢'),
  StemUnit(id: 's8_mat_u2', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 2, title: 'Kareköklü İfadeler ve Veri Analizi', titleTr: 'Kareköklü İfadeler ve Veri Analizi', icon: '📊'),
  StemUnit(id: 's8_mat_u3', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 3, title: 'Olasılık ve Cebirsel İfadeler', titleTr: 'Olasılık ve Cebirsel İfadeler', icon: '🎲'),
  StemUnit(id: 's8_mat_u4', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 4, title: 'Doğrusal Denklemler ve Eşitsizlikler', titleTr: 'Doğrusal Denklemler ve Eşitsizlikler', icon: '📈'),
  StemUnit(id: 's8_mat_u5', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 5, title: 'Üçgenler, Eşlik ve Benzerlik', titleTr: 'Üçgenler, Eşlik ve Benzerlik', icon: '📐'),
  StemUnit(id: 's8_mat_u6', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.matematik, order: 6, title: 'Dönüşüm Geometrisi ve Geometrik Cisimler', titleTr: 'Dönüşüm Geometrisi ve Geometrik Cisimler', icon: '🔷'),
];

// ═══════════════════════════════════════════════════════════════
// 8. SINIF (LGS) FEN BİLİMLERİ ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif8FenUnits = [
  StemUnit(id: 's8_fen_u1', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 1, title: 'Mevsimler ve İklim', titleTr: 'Mevsimler ve İklim', icon: '🌦️'),
  StemUnit(id: 's8_fen_u2', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 2, title: 'DNA ve Genetik Kod', titleTr: 'DNA ve Genetik Kod', icon: '🧬'),
  StemUnit(id: 's8_fen_u3', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 3, title: 'Basınç', titleTr: 'Basınç', icon: '⬇️'),
  StemUnit(id: 's8_fen_u4', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 4, title: 'Madde ve Endüstri', titleTr: 'Madde ve Endüstri', icon: '⚗️'),
  StemUnit(id: 's8_fen_u5', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 5, title: 'Basit Makineler', titleTr: 'Basit Makineler', icon: '⚙️'),
  StemUnit(id: 's8_fen_u6', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 6, title: 'Enerji Dönüşümleri ve Çevre Bilimi', titleTr: 'Enerji Dönüşümleri ve Çevre Bilimi', icon: '🌿'),
  StemUnit(id: 's8_fen_u7', gradeLevel: GradeLevel.sinif8_lgs, subject: StemSubject.fenBilimleri, order: 7, title: 'Elektrik Yükleri ve Elektrik Enerjisi', titleTr: 'Elektrik Yükleri ve Elektrik Enerjisi', icon: '⚡'),
];

// ═══════════════════════════════════════════════════════════════
// YARDIMCI FONKSİYONLAR
// ═══════════════════════════════════════════════════════════════

/// Sınıf ve derse ait üniteleri getir
List<StemUnit> getStemUnitsForGradeSubject(GradeLevel grade, StemSubject subject) {
  if (grade == GradeLevel.sinif5 && subject == StemSubject.matematik) {
    return sinif5MatUnits;
  }
  if (grade == GradeLevel.sinif5 && subject == StemSubject.fenBilimleri) {
    return sinif5FenUnits;
  }
  if (grade == GradeLevel.sinif8_lgs && subject == StemSubject.matematik) {
    return sinif8MatUnits;
  }
  if (grade == GradeLevel.sinif8_lgs && subject == StemSubject.fenBilimleri) {
    return sinif8FenUnits;
  }
  if (grade == GradeLevel.sinif12 && subject == StemSubject.matematik) {
    return sinif12MatUnits;
  }
  if (grade == GradeLevel.sinif12 && subject == StemSubject.fizik) {
    return sinif12FizUnits;
  }
  if (grade == GradeLevel.sinif12 && subject == StemSubject.kimya) {
    return sinif12KimUnits;
  }
  // TYT
  if (grade == GradeLevel.tyt && subject == StemSubject.matematik) {
    return tytMatUnits;
  }
  if (grade == GradeLevel.tyt && subject == StemSubject.fizik) {
    return tytFizUnits;
  }
  if (grade == GradeLevel.tyt && subject == StemSubject.kimya) {
    return tytKimUnits;
  }
  if (grade == GradeLevel.tyt && subject == StemSubject.biyoloji) {
    return tytBioUnits;
  }
  // AYT
  if (grade == GradeLevel.ayt && subject == StemSubject.matematik) {
    return aytMatUnits;
  }
  if (grade == GradeLevel.ayt && subject == StemSubject.fizik) {
    return aytFizUnits;
  }
  if (grade == GradeLevel.ayt && subject == StemSubject.kimya) {
    return aytKimUnits;
  }
  // KPSS
  if (grade == GradeLevel.kpssLise && subject == StemSubject.turkce) {
    return kpssLiseTurUnits;
  }
  if (grade == GradeLevel.kpssOnlisans && subject == StemSubject.turkce) {
    return kpssOnlisansTurUnits;
  }
  if (grade == GradeLevel.kpssLisans && subject == StemSubject.turkce) {
    return kpssLisansTurUnits;
  }
  // KPSS Matematik
  if (grade == GradeLevel.kpssLise && subject == StemSubject.matematik) {
    return kpssLiseMatUnits;
  }
  if (grade == GradeLevel.kpssOnlisans && subject == StemSubject.matematik) {
    return kpssOnlisansMatUnits;
  }
  if (grade == GradeLevel.kpssLisans && subject == StemSubject.matematik) {
    return kpssLisansMatUnits;
  }
  return [];
}

/// Ünite içeriğini getir
StemUnitContent? getStemUnitContent(String unitId) {
  return _allStemContent[unitId];
}

// ═══════════════════════════════════════════════════════════════
// TÜM İÇERİK HARİTASI
// ═══════════════════════════════════════════════════════════════

final Map<String, StemUnitContent> _allStemContent = {
  's5_mat_u1': _s5MatU1Content,
  's5_mat_u2': _s5MatU2Content,
  's5_mat_u3': _s5MatU3Content,
  's5_mat_u4': _s5MatU4Content,
  's5_mat_u5': _s5MatU5Content,
  's5_mat_u6': _s5MatU6Content,
  's5_fen_u1': _s5FenU1Content,
  's5_fen_u2': _s5FenU2Content,
  's5_fen_u3': _s5FenU3Content,
  's5_fen_u4': _s5FenU4Content,
  's5_fen_u5': _s5FenU5Content,
  's5_fen_u6': _s5FenU6Content,
  's8_mat_u1': _s8MatU1Content,
  's8_mat_u2': _s8MatU2Content,
  's8_mat_u3': _s8MatU3Content,
  's8_mat_u4': _s8MatU4Content,
  's8_mat_u5': _s8MatU5Content,
  's8_mat_u6': _s8MatU6Content,
  's8_fen_u1': _s8FenU1Content,
  's8_fen_u2': _s8FenU2Content,
  's8_fen_u3': _s8FenU3Content,
  's8_fen_u4': _s8FenU4Content,
  's8_fen_u5': _s8FenU5Content,
  's8_fen_u6': _s8FenU6Content,
  's8_fen_u7': _s8FenU7Content,
  ...allStemContent12,
  ...allStemContentTyt,
  ...allStemContentAyt,
  ...kpssTurkceContent,
  ...kpssMatematikContent,
};

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 1: DOĞAL SAYILAR VE İŞLEMLER
// ═══════════════════════════════════════════════════════════════

final _s5MatU1Content = StemUnitContent(
  unitId: 's5_mat_u1',
  topic: const TopicContent(
    summary: 'Bu ünitede 9 basamaklı sayılara kadar okuma/yazma, bölükler ve basamak değerleri öğrenilir. Sayı örüntüleri, doğal sayılarla toplama, çıkarma, çarpma ve bölme işlemleri yapılır. Bir sayının karesi (a²) ve küpü (a³) kavramları ile parantezli işlemlerde işlem önceliği konuları işlenir.',
    rule: 'İşlem Önceliği: 1) Üslü ifadeler 2) Parantez içi 3) Çarpma/Bölme (soldan sağa) 4) Toplama/Çıkarma (soldan sağa)',
    formulas: [
      'a² = a × a (sayının karesi)',
      'a³ = a × a × a (sayının küpü)',
      'Bölünen = Bölen × Bölüm + Kalan',
    ],
    keyPoints: [
      'İşlem önceliği sırasına dikkat et',
      'Üslü ifadelerde önce değeri bul',
      'Parantez her zaman ilk çözülür',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '40 ÷ (5 + 3) × 2 = ?',
      steps: [
        'Önce parantez içi yapılır: 5 + 3 = 8',
        'İşlem 40 ÷ 8 × 2 haline geldi',
        'Bölme ve çarpma soldan sağa: 40 ÷ 8 = 5',
        'Sonra çarpma: 5 × 2 = 10',
      ],
      answer: '10',
    ),
    SolvedExample(
      question: '5² + 2³ işleminin sonucu kaçtır?',
      steps: [
        'Üslü sayıların değerleri bulunur: 5² = 5 × 5 = 25',
        '2³ = 2 × 2 × 2 = 8',
        'Bulunan değerler toplanır: 25 + 8 = 33',
      ],
      answer: '33',
    ),
    SolvedExample(
      question: 'Bir okulda 15 sınıf ve her sınıfta 24 öğrenci vardır. Okul mevcudunun 180\'i erkektir. Kız öğrenci sayısı kaçtır?',
      steps: [
        'Toplam öğrenci sayısı: 15 × 24 = 360',
        'Kız öğrenci sayısı: 360 - 180 = 180',
      ],
      answer: '180',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: '"Yetmiş iki milyon kırk bin beş yüz" sayısının rakamla yazılışı hangisidir?',
      options: ['72 400 500', '72 040 500', '70 204 500', '72 004 050'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '8 × 8 işlemi üslü olarak nasıl gösterilir?',
      options: ['8²', '8³', '2⁸', '8 × 2'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: '(24 - 4) ÷ 5 işleminin sonucu kaçtır?',
      options: ['2', '3', '4', '5'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir bölme işleminde bölen 12, bölüm 10 ve kalan 5 ise bölünen sayı kaçtır?',
      options: ['120', '125', '130', '135'],
      correctIndex: 1,
      explanation: 'Bölen × Bölüm + Kalan = 12 × 10 + 5 = 125',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki örüntüde soru işareti yerine ne gelir?\n4, 11, 18, 25, ?',
      options: ['30', '31', '32', '33'],
      correctIndex: 2,
      explanation: '7\'şer artıyor: 25 + 7 = 32',
      difficulty: 2,
    ),
    StemQuestion(
      question: '3³ ifadesinin değeri kaçtır?',
      options: ['9', '18', '27', '33'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '546.789 sayısında basamak değeri en büyük olan rakam hangisidir?',
      options: ['9', '6', '5', '4'],
      correctIndex: 2,
      explanation: '5 yüz binler basamağında → 500.000',
      difficulty: 2,
    ),
    StemQuestion(
      question: '15 × 100 işleminin sonucu kaçtır?',
      options: ['150', '1500', '15000', '1050'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir çiftlikte günde 45 litre süt sağılıyor. 10 günde toplam kaç litre süt sağılır?',
      options: ['400', '450', '500', '550'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '100 - (20 + 30) işleminin sonucu kaçtır?',
      options: ['10', '30', '50', '80'],
      correctIndex: 2,
      difficulty: 1,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: '8 × 8 işlemi üslü olarak nasıl gösterilir?',
      options: ['8²', '8³', '2⁸', '8 × 2'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: '3³ ifadesinin değeri kaçtır?',
      options: ['9', '18', '27', '33'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '15 × 100 işleminin sonucu kaçtır?',
      options: ['150', '1500', '15000', '1050'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '(24 - 4) ÷ 5 işleminin sonucu kaçtır?',
      options: ['2', '3', '4', '5'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '100 - (20 + 30) işleminin sonucu kaçtır?',
      options: ['10', '30', '50', '80'],
      correctIndex: 2,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: '9 basamaklı en büyük doğal sayı hangisidir?',
      options: ['999.999.999', '100.000.000', '987.654.321', '900.000.000'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: '2058 + 3642 işleminin tahmini sonucu, sayılar en yakın yüzlüğe yuvarlanarak bulunduğunda sonuç kaç olur?',
      options: ['5600', '5700', '5800', '6000'],
      correctIndex: 1,
      explanation: '2100 + 3600 = 5700',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Ahmet\'in parası Mehmet\'in parasının 3 katından 50 TL fazladır. Mehmet\'in 100 TL\'si varsa Ahmet\'in kaç TL\'si vardır?',
      options: ['250', '300', '350', '400'],
      correctIndex: 2,
      explanation: '100 × 3 = 300, 300 + 50 = 350',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'A = 4² ve B = 5² ise A + B kaçtır?',
      options: ['9', '21', '41', '81'],
      correctIndex: 2,
      explanation: '16 + 25 = 41',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir trende 12 vagon, her vagonda 30 koltuk vardır. Tren tamamen dolu ise kaç yolcu vardır?',
      options: ['300', '320', '360', '400'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '80 ÷ (12 - 4) + 5 işleminin sonucu kaçtır?',
      options: ['10', '15', '20', '25'],
      correctIndex: 1,
      explanation: 'Parantez: 8, Bölme: 80÷8=10, Toplama: 10+5=15',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Rakamları birbirinden farklı 4 basamaklı en küçük çift doğal sayı hangisidir?',
      options: ['1000', '1024', '1234', '1032'],
      correctIndex: 1,
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bir bölme işleminde bölen 15 ise, kalan aşağıdakilerden hangisi olamaz?',
      options: ['0', '10', '14', '15'],
      correctIndex: 3,
      explanation: 'Kalan bölenden büyük veya eşit olamaz',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki eşitliklerden hangisi yanlıştır?',
      options: ['10² = 100', '1³ = 1', '6² = 12', '2³ = 8'],
      correctIndex: 2,
      explanation: '6² = 36, 12 değil',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir kırtasiyeci 500 kalemi 20\'şerli paketlere koyup her paketi 15 TL\'den satıyor. Tüm kalemleri satarsa kaç TL kazanır?',
      options: ['300', '375', '400', '450'],
      correctIndex: 1,
      explanation: '500/20 = 25 paket, 25 × 15 = 375',
      difficulty: 2,
    ),
    StemQuestion(
      question: '3, 0, 7, 5 rakamlarını birer kez kullanarak yazılabilecek 4 basamaklı en büyük tek sayı kaçtır?',
      options: ['7530', '7503', '7305', '7053'],
      correctIndex: 1,
      difficulty: 3,
    ),
    StemQuestion(
      question: '(150 - 50) × (3 + 7) işleminin sonucu kaçtır?',
      options: ['100', '500', '1000', '2000'],
      correctIndex: 2,
      explanation: '100 × 10 = 1000',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir örüntü 7\'den başlayıp 4\'er artarak devam etmektedir. Bu örüntünün 6. terimi kaçtır?',
      options: ['23', '27', '31', '35'],
      correctIndex: 1,
      explanation: '7, 11, 15, 19, 23, 27',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Ali\'nin 120 bilyesi var. Can\'ın bilyeleri Ali\'ninkinin yarısından 10 fazladır. İkisinin toplam kaç bilyesi vardır?',
      options: ['70', '190', '200', '210'],
      correctIndex: 1,
      explanation: 'Can = 120/2 + 10 = 70. Toplam = 120 + 70 = 190',
      difficulty: 2,
    ),
    StemQuestion(
      question: '24000 ÷ 600 işleminin sonucu kaçtır?',
      options: ['4', '40', '400', '4000'],
      correctIndex: 1,
      explanation: '240 ÷ 6 = 40',
      difficulty: 2,
    ),
  ],
  formulaCards: const [
    'İşlem Önceliği: Üs → Parantez → Çarpma/Bölme → Toplama/Çıkarma',
    'a² = a × a (karesi)',
    'a³ = a × a × a (küpü)',
    'Bölünen = Bölen × Bölüm + Kalan',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 2: KESİRLER
// ═══════════════════════════════════════════════════════════════

final _s5MatU2Content = StemUnitContent(
  unitId: 's5_mat_u2',
  topic: const TopicContent(
    summary: 'Bu ünitede basit, bileşik ve tam sayılı kesir kavramları öğrenilir. Tam sayılı kesirler bileşik kesre, bileşik kesirler tam sayılı kesre çevrilir. Kesirlerde sadeleştirme ve genişletme yapılarak denk kesirler oluşturulur. Paydaları eşit olan kesirlerde toplama ve çıkarma işlemleri yapılır.',
    rule: 'Paydaları eşit olan kesirlerle toplama veya çıkarma yapılırken; paylar toplanır veya çıkarılır, payda aynen kalır.\na/c + b/c = (a+b)/c',
    formulas: [
      'Tam sayılı → Bileşik: Tam × Payda + Pay / Payda',
      'Bileşik → Tam sayılı: Pay ÷ Payda = Tam, Kalan/Payda',
      'Bir çokluğun kesir kadarı: Sayı ÷ Payda × Pay',
    ],
    keyPoints: [
      'Basit kesir: Pay < Payda',
      'Bileşik kesir: Pay > Payda',
      'Sadeleştirme: Pay ve payda ortak bölene bölünür',
      'Genişletme: Pay ve payda aynı sayıyla çarpılır',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '3 2/5 tam sayılı kesrini bileşik kesre çeviriniz.',
      steps: [
        'Tam kısım (3) ile payda (5) çarpılır: 3 × 5 = 15',
        'Çıkan sonuca pay (2) eklenir: 15 + 2 = 17',
        'Bulunan sayı paya yazılır, payda aynen kalır',
      ],
      answer: '17/5',
    ),
    SolvedExample(
      question: '4/9 + 3/9 işleminin sonucu kaçtır?',
      steps: [
        'Paydalar eşit mi? Evet, ikisi de 9',
        'Paylar toplanır: 4 + 3 = 7',
        'Payda aynen yazılır',
      ],
      answer: '7/9',
    ),
    SolvedExample(
      question: '60 tane cevizin 2/3\'ünü arkadaşıma verdim. Kaç ceviz verdim?',
      steps: [
        'Bütünü paydaya böleriz: 60 ÷ 3 = 20',
        'Çıkan sonucu pay ile çarparız: 20 × 2 = 40',
      ],
      answer: '40 ceviz',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: 'Payı paydasından küçük olan kesirlere ne denir?',
      options: ['Bileşik Kesir', 'Tam Sayılı Kesir', 'Basit Kesir', 'Birim Kesir'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi birim kesirdir?',
      options: ['2/5', '1/9', '5/3', '1 1/2'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '15/4 kesrinin tam sayılı kesir olarak gösterimi hangisidir?',
      options: ['3 3/4', '4 1/4', '3 1/4', '2 7/4'],
      correctIndex: 0,
      explanation: '15 ÷ 4 = 3 tam, kalan 3',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki kesirlerden hangisi en büyüktür?',
      options: ['1/2', '1/5', '1/8', '1/10'],
      correctIndex: 0,
      explanation: 'Birim kesirlerde payda küçüldükçe kesir büyür',
      difficulty: 1,
    ),
    StemQuestion(
      question: '2/5 kesrinin 3 ile genişletilmiş hali hangisidir?',
      options: ['5/8', '6/15', '6/5', '2/15'],
      correctIndex: 1,
      explanation: 'Hem payı hem paydayı 3 ile çarparız',
      difficulty: 2,
    ),
    StemQuestion(
      question: '7/12 - 4/12 işleminin sonucu kaçtır?',
      options: ['3/0', '11/12', '3/12', '3/24'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir ekmeğin 3/8\'ini Ali, 2/8\'ini Veli yedi. Toplam ne kadar ekmek yendi?',
      options: ['5/16', '1/8', '5/8', '6/8'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdaki eşleştirmelerden hangisi yanlıştır?',
      options: ['1/2 = Yarım', '1/4 = Çeyrek', '4/4 = Yarım', '2/2 = Bütün'],
      correctIndex: 2,
      explanation: '4/4 bir bütündür',
      difficulty: 1,
    ),
    StemQuestion(
      question: '80 liranın 1/4\'ü kaç liradır?',
      options: ['10', '20', '30', '40'],
      correctIndex: 1,
      explanation: '80 ÷ 4 = 20',
      difficulty: 1,
    ),
    StemQuestion(
      question: '2 1/3 + 1/3 işleminin sonucu kaçtır?',
      options: ['2 2/6', '3 1/3', '2 2/3', '3'],
      correctIndex: 2,
      difficulty: 2,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: 'Payı paydasından küçük olan kesirlere ne denir?',
      options: ['Bileşik Kesir', 'Tam Sayılı Kesir', 'Basit Kesir', 'Birim Kesir'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '7/12 - 4/12 işleminin sonucu kaçtır?',
      options: ['3/0', '11/12', '3/12', '3/24'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '80 liranın 1/4\'ü kaç liradır?',
      options: ['10', '20', '30', '40'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi birim kesirdir?',
      options: ['2/5', '1/9', '5/3', '1 1/2'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir ekmeğin 3/8\'ini Ali, 2/8\'ini Veli yedi. Toplam ne kadar ekmek yendi?',
      options: ['5/16', '1/8', '5/8', '6/8'],
      correctIndex: 2,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: '24/36 kesrinin en sade hali hangisidir?',
      options: ['12/18', '6/9', '2/3', '4/6'],
      correctIndex: 2,
      explanation: 'Her iki tarafı 12\'ye bölersek',
      difficulty: 2,
    ),
    StemQuestion(
      question: '200 sayfalık bir kitabın 3/5\'ini okudum. Okumadığım kaç sayfa kaldı?',
      options: ['80', '100', '120', '150'],
      correctIndex: 0,
      explanation: 'Okunan: 200÷5×3=120. Kalan: 200-120=80',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki sıralamalardan hangisi doğrudur?',
      options: ['3/7 < 5/7 < 1/7', '1/7 < 3/7 < 5/7', '5/7 < 3/7 < 1/7', '3/7 < 1/7 < 5/7'],
      correctIndex: 1,
      explanation: 'Paydalar eşitse payı büyük olan büyüktür',
      difficulty: 1,
    ),
    StemQuestion(
      question: '14/18 kesrinin sadeleştirilmiş hali hangisidir?',
      options: ['7/9', '5/9', '6/9', '8/9'],
      correctIndex: 0,
      explanation: '2 ile sadeleştirilir',
      difficulty: 2,
    ),
    StemQuestion(
      question: '5 - 2/3 işleminin sonucu kaçtır?',
      options: ['3/3', '4 1/3', '13/3', '3 1/3'],
      correctIndex: 2,
      explanation: '5 = 15/3. 15/3 - 2/3 = 13/3',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangi seçenekteki kesir 1 bütünden büyüktür?',
      options: ['9/10', '7/7', '8/5', '1/2'],
      correctIndex: 2,
      explanation: 'Pay > Payda olduğu için 1\'den büyüktür',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Ali parasının 2/10\'unu harcadı. Geriye parasının kaçta kaçı kaldı?',
      options: ['8/10', '5/10', '2/10', '1/10'],
      correctIndex: 0,
      explanation: '10/10 - 2/10 = 8/10',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'A = 1/3, B = 1/6, C = 1/2. Küçükten büyüğe sıralama hangisidir?',
      options: ['A < B < C', 'C < A < B', 'B < A < C', 'B < C < A'],
      correctIndex: 2,
      explanation: '1/6 < 1/3 < 1/2',
      difficulty: 2,
    ),
    StemQuestion(
      question: '4 2/5 kesri aşağıdakilerden hangisine eşittir?',
      options: ['22/5', '20/5', '18/5', '14/5'],
      correctIndex: 0,
      explanation: '4 × 5 + 2 = 22',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir sınıftaki öğrencilerin 1/4\'ü gözlüklüdür. 32 öğrenci varsa gözlüksüz öğrenci sayısı kaçtır?',
      options: ['8', '16', '20', '24'],
      correctIndex: 3,
      explanation: 'Gözlüklü: 32÷4=8. Gözlüksüz: 32-8=24',
      difficulty: 2,
    ),
    StemQuestion(
      question: '12/16 kesrine denk olan kesir hangisidir?',
      options: ['3/5', '4/5', '3/4', '2/3'],
      correctIndex: 2,
      explanation: '4 ile sadeleştirilirse 3/4',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir sürahinin 3/7\'si su ile doludur. 2/7\'si kadar daha su eklenirse kaçta kaçı dolu olur?',
      options: ['1/7', '5/14', '5/7', '6/7'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '3 × 1/5 işleminin sonucu nedir?',
      options: ['3/15', '1/15', '3/5', '3 1/5'],
      correctIndex: 2,
      explanation: '1/5 + 1/5 + 1/5 = 3/5',
      difficulty: 2,
    ),
    StemQuestion(
      question: '?/8 < 5/8 ifadesinde "?" yerine yazılabilecek en büyük doğal sayı kaçtır?',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Ayşe bir kitabın 1. gün 2/9\'unu, 2. gün 4/9\'unu okudu. Kitabın bitmesi için ne kadar daha okumalı?',
      options: ['6/9', '4/9', '3/9', '2/9'],
      correctIndex: 2,
      explanation: 'Okunan toplam: 6/9. Kalan: 9/9 - 6/9 = 3/9',
      difficulty: 2,
    ),
  ],
  formulaCards: const [
    'Tam sayılı → Bileşik: Tam × Payda + Pay',
    'Paydaları eşit kesirler: Paylar toplanır/çıkarılır',
    'Bir çokluğun kesir kadarı: Sayı ÷ Payda × Pay',
    'Birim kesirlerde payda küçüldükçe kesir büyür',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 3: ONDALIK GÖSTERİM
// ═══════════════════════════════════════════════════════════════

final _s5MatU3Content = StemUnitContent(
  unitId: 's5_mat_u3',
  topic: const TopicContent(
    summary: 'Paydası 10, 100 veya 1000 olan kesirlerin virgül kullanılarak yazılmasına "ondalık gösterim" denir. Ondalık gösterimde virgülün solu tam kısım, sağı ise ondalık kısımdır.',
    rule: 'Paydada 10 → virgülden sonra 1 basamak (3/10 = 0,3)\nPaydada 100 → virgülden sonra 2 basamak (25/100 = 0,25)\nPaydada 1000 → virgülden sonra 3 basamak\nToplama/Çıkarma: Virgüller alt alta gelmelidir.',
    formulas: [
      'Kesir → Ondalık: Pay sayısı, payda\'nın sıfır sayısı kadar virgülden sonraya yazılır',
      '10 ile çarpma: Virgülü 1 basamak sağa kaydır',
    ],
    keyPoints: [
      'Virgüller alt alta gelecek şekilde işlem yap',
      'Ondalık kısımlardaki basamak sayılarını eşitle',
      'Sondaki sıfırların değeri yoktur (0,5 = 0,50)',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2 7/100 kesrinin ondalık gösterimi nasıldır?',
      steps: [
        'Tam kısım: 2. Virgülün soluna 2 yazılır',
        'Payda 100 → virgülden sonra 2 basamak olacak',
        'Pay 7 → iki basamaklı olacak şekilde 07 yazılır',
      ],
      answer: '2,07',
    ),
    SolvedExample(
      question: '0,4 ; 0,35 ve 0,42 sayılarını küçükten büyüğe sıralayınız.',
      steps: [
        'Tam kısımlar eşit (hepsi 0)',
        'Basamak sayıları eşitlenir: 0,40 - 0,35 - 0,42',
        'Kesir kısımları sıralanır: 35 < 40 < 42',
      ],
      answer: '0,35 < 0,4 < 0,42',
    ),
    SolvedExample(
      question: '3,5 + 1,25 işleminin sonucu kaçtır?',
      steps: [
        'Virgüller alt alta gelecek şekilde yazılır',
        '3,50 + 1,25 (boşluk 0 ile tamamlanır)',
        'Normal toplama yapılır',
      ],
      answer: '4,75',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: '"Sıfır tam yüzde beş" ifadesinin ondalık gösterimi hangisidir?',
      options: ['0,5', '0,05', '0,005', '5,00'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '12/10 kesrinin ondalık gösterimi hangisidir?',
      options: ['0,12', '1,2', '12,0', '0,012'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '5,487 sayısındaki "8" rakamının basamak değeri nedir?',
      options: ['8', '0,8', '0,08', '0,008'],
      correctIndex: 2,
      explanation: 'Yüzde birler basamağında',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki sıralamalardan hangisi doğrudur?',
      options: ['2,1 < 2,01', '5,5 = 5,50', '3,4 < 3,39', '0,9 > 1,0'],
      correctIndex: 1,
      explanation: 'Sondaki sıfırların değeri yoktur',
      difficulty: 2,
    ),
    StemQuestion(
      question: '7,2 - 3,4 işleminin sonucu kaçtır?',
      options: ['3,8', '4,2', '4,8', '3,2'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Okunuşu "On iki tam binde dokuz" olan sayı hangisidir?',
      options: ['12,9', '12,09', '12,009', '12,900'],
      correctIndex: 2,
      difficulty: 2,
    ),
    StemQuestion(
      question: '4 + 3/10 + 5/100 şeklinde çözümlenen sayı hangisidir?',
      options: ['4,305', '4,35', '4,53', '43,5'],
      correctIndex: 1,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdaki kesirlerden hangisi 0,6\'ya eşittir?',
      options: ['3/5', '1/6', '6/100', '5/6'],
      correctIndex: 0,
      explanation: '3/5 = 6/10 = 0,6',
      difficulty: 2,
    ),
    StemQuestion(
      question: '2,4 metre kumaşın 1,15 metresi satılırsa geriye ne kadar kalır?',
      options: ['1,35 m', '1,25 m', '1,15 m', '1,05 m'],
      correctIndex: 1,
      explanation: '2,40 - 1,15 = 1,25',
      difficulty: 2,
    ),
    StemQuestion(
      question: '8,7_5 < 8,745 ifadesinde boşluğa hangi rakamlar gelebilir?',
      options: ['0, 1, 2, 3', '4, 5, 6', '5, 6, 7, 8, 9', 'Sadece 4'],
      correctIndex: 0,
      explanation: '4\'ten küçük olmalı',
      difficulty: 3,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: '12/10 kesrinin ondalık gösterimi hangisidir?',
      options: ['0,12', '1,2', '12,0', '0,012'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '7,2 - 3,4 işleminin sonucu kaçtır?',
      options: ['3,8', '4,2', '4,8', '3,2'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: '"Sıfır tam yüzde beş" ifadesinin ondalık gösterimi?',
      options: ['0,5', '0,05', '0,005', '5,00'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '5,5 = 5,50 ifadesi doğru mudur?',
      options: ['Doğru', 'Yanlış', 'Belirlenemez', 'Bazen doğru'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: '2,4 - 1,15 = ?',
      options: ['1,35', '1,25', '1,15', '1,05'],
      correctIndex: 1,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: '3 1/4 kesrinin ondalık gösterimi hangisidir?',
      options: ['3,14', '3,25', '3,4', '3,41'],
      correctIndex: 1,
      explanation: 'Paydayı 25 ile genişlet: 3 tam %25',
      difficulty: 2,
    ),
    StemQuestion(
      question: '15 TL 25 kuruşun ondalık gösterimi nasıldır?',
      options: ['15,25 TL', '1,525 TL', '152,5 TL', '0,1525 TL'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdaki toplama işlemlerinden hangisinin sonucu yanlıştır?',
      options: ['0,2 + 0,3 = 0,5', '1,5 + 2,5 = 4,0', '0,7 + 0,03 = 0,10', '3,2 + 1,8 = 5'],
      correctIndex: 2,
      explanation: '0,7 + 0,03 = 0,73 olmalıydı',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir koşucu 12,58 sn, diğeri 12,6 sn\'de koştu. Birinci ne kadar daha hızlı?',
      options: ['0,2 sn', '0,02 sn', '0,12 sn', '0,20 sn'],
      correctIndex: 1,
      explanation: '12,60 - 12,58 = 0,02',
      difficulty: 2,
    ),
    StemQuestion(
      question: '5, 2, 0, 9 rakamlarıyla 5\'ten büyük en küçük ondalık sayı hangisidir?',
      options: ['5,029', '5,209', '5,092', '9,025'],
      correctIndex: 0,
      difficulty: 3,
    ),
    StemQuestion(
      question: '20 + 0,5 + 0,07 + 0,001 işleminin sonucu kaçtır?',
      options: ['20,571', '25,71', '2,571', '205,71'],
      correctIndex: 0,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi 0,5\'e en yakındır?',
      options: ['0,48', '0,55', '0,42', '0,59'],
      correctIndex: 0,
      explanation: '0,50\'ye uzaklığı 0,02',
      difficulty: 2,
    ),
    StemQuestion(
      question: '7,a3 > 7,53 için "a" yerine en küçük hangi rakam gelir?',
      options: ['4', '5', '6', '7'],
      correctIndex: 2,
      explanation: '6 yazarsak 7,63 > 7,53',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bir bakkal 50 kg pirincin 12,5 kg\'ını sabah, 18,75 kg\'ını öğleden sonra sattı. Geriye kaç kg kaldı?',
      options: ['18,75', '19,25', '20,50', '31,25'],
      correctIndex: 0,
      explanation: 'Satılan: 31,25. Kalan: 50 - 31,25 = 18,75',
      difficulty: 2,
    ),
    StemQuestion(
      question: '3/5 kesri ile 0,4 sayısının toplamı kaçtır?',
      options: ['0,7', '0,9', '1,0', '1,1'],
      correctIndex: 2,
      explanation: '3/5 = 0,6. 0,6 + 0,4 = 1,0',
      difficulty: 2,
    ),
    StemQuestion(
      question: '43,267 sayısını onda birler basamağına göre yuvarlarsak?',
      options: ['43,2', '43,3', '43,26', '43,27'],
      correctIndex: 1,
      explanation: 'Bir sonraki basamak 6 → yukarı yuvarlanır',
      difficulty: 2,
    ),
    StemQuestion(
      question: '4 tam binde 8 sayısının yazılışı hangisidir?',
      options: ['4,8', '4,08', '4,008', '4,800'],
      correctIndex: 2,
      difficulty: 2,
    ),
    StemQuestion(
      question: '2,5 × 10 işleminin sonucu kaçtır?',
      options: ['25', '250', '0,25', '2,50'],
      correctIndex: 0,
      explanation: '10 ile çarpmak virgülü 1 basamak sağa kaydırır',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir kenarı 4,5 cm olan karenin çevresi kaç cm\'dir?',
      options: ['9', '13,5', '16', '18'],
      correctIndex: 3,
      explanation: '4 × 4,5 = 18',
      difficulty: 2,
    ),
    StemQuestion(
      question: '10 - 0,9 işleminin sonucu kaçtır?',
      options: ['9,1', '9,9', '0,1', '1,1'],
      correctIndex: 0,
      difficulty: 1,
    ),
  ],
  formulaCards: const [
    'Payda 10 → 1 basamak, Payda 100 → 2 basamak',
    '10 ile çarpma: Virgül 1 sağa kayar',
    'Toplama/çıkarmada virgüller alt alta gelmeli',
    'Sondaki sıfırların değeri yoktur (0,5 = 0,50)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 4: YÜZDE HESAPLAMALARI
// ═══════════════════════════════════════════════════════════════

final _s5MatU4Content = StemUnitContent(
  unitId: 's5_mat_u4',
  topic: const TopicContent(
    summary: 'Paydası 100 olan kesirler "yüzde" sembolü (%) ile gösterilir. Kesir, ondalık gösterim ve yüzdeler birbirine dönüştürülebilir ve karşılaştırılabilir.',
    rule: 'Bir bütünün belirtilen yüzdesini bulmak için: Sayı ÷ 100 × Yüzde oranı\n%100 = Tamamı, %50 = Yarısı (1/2), %25 = Çeyreği (1/4)',
    formulas: [
      'Kesir → Yüzde: Paydayı 100 yap, payı % ile göster',
      'Bir sayının %x\'i = Sayı ÷ 100 × x',
      'Ondalık → Yüzde: 100 ile çarp (0,4 → %40)',
    ],
    keyPoints: [
      '%100 = Tamamı (1 bütün)',
      '%50 = Yarısı (1/2)',
      '%25 = Çeyreği (1/4)',
      'İndirim hesabı: Ürün fiyatı - (Fiyat × İndirim oranı / 100)',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '3/5 kesrini yüzde sembolü ile gösteriniz.',
      steps: [
        'Paydanın 100 olması gerekir. 5\'i 100 yapmak için 20 ile genişletiriz',
        '(3×20) / (5×20) = 60/100',
        'Sembolle yazılışı: %60',
      ],
      answer: '%60',
    ),
    SolvedExample(
      question: '300 sayısının %20\'si kaçtır?',
      steps: [
        'Sayı 100\'e bölünür: 300 ÷ 100 = 3',
        'Yüzde oranı ile çarpılır: 3 × 20 = 60',
      ],
      answer: '60',
    ),
    SolvedExample(
      question: '0,4 ondalık gösterimini yüzde olarak yazınız.',
      steps: [
        'Ondalık sayıyı kesir olarak yazarız: 4/10',
        'Paydayı 100 yapmak için 10 ile genişletiriz: 40/100',
        'Yüzde sembolüyle: %40',
      ],
      answer: '%40',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: 'Aşağıdakilerden hangisi %35\'e eşittir?',
      options: ['3/5', '35/10', '35/100', '7/50'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir pastanın yarısını yedik. Yediğimiz kısım yüzde kaçtır?',
      options: ['%25', '%50', '%75', '%100'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '12/25 kesrinin yüzde sembolüyle gösterilişi hangisidir?',
      options: ['%12', '%24', '%36', '%48'],
      correctIndex: 3,
      explanation: '4 ile genişlet: 48/100',
      difficulty: 2,
    ),
    StemQuestion(
      question: '200 TL\'nin %10\'u kaç TL\'dir?',
      options: ['10', '20', '40', '100'],
      correctIndex: 1,
      explanation: '200 ÷ 100 = 2, 2 × 10 = 20',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdaki sıralamalardan hangisi doğrudur?',
      options: ['%40 < 0,5', '%60 = 0,06', '%25 > 1/4', '0,8 < %75'],
      correctIndex: 0,
      explanation: '%40 = 0,40 < 0,50',
      difficulty: 2,
    ),
    StemQuestion(
      question: '%7\'nin ondalık gösterimi hangisidir?',
      options: ['0,7', '0,07', '7,0', '0,70'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bir sınıftaki öğrencilerin %60\'ı erkektir. Kız öğrencilerin oranı yüzde kaçtır?',
      options: ['%30', '%40', '%50', '%60'],
      correctIndex: 1,
      explanation: '%100 - %60 = %40',
      difficulty: 1,
    ),
    StemQuestion(
      question: '100 TL\'lik gömleğe %20 indirim yapıldı. Yeni fiyat ne olur?',
      options: ['20 TL', '80 TL', '90 TL', '120 TL'],
      correctIndex: 1,
      explanation: 'İndirim: 20 TL. Yeni fiyat: 100-20=80',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi en büyüktür?',
      options: ['0,45', '2/5', '%48', '9/20'],
      correctIndex: 2,
      explanation: '0,45=%45, 2/5=%40, 9/20=%45. En büyük %48',
      difficulty: 3,
    ),
    StemQuestion(
      question: '50 soruluk sınavda hepsini doğru yapanın başarı yüzdesi kaçtır?',
      options: ['%50', '%80', '%90', '%100'],
      correctIndex: 3,
      difficulty: 1,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: 'Bir pastanın yarısı yüzde kaçtır?',
      options: ['%25', '%50', '%75', '%100'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '200 TL\'nin %10\'u kaç TL?',
      options: ['10', '20', '40', '100'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '%7 = ?',
      options: ['0,7', '0,07', '7,0', '0,70'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '%100 - %60 = ?',
      options: ['%30', '%40', '%50', '%60'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '35/100 yüzde kaçtır?',
      options: ['%3,5', '%35', '%350', '%0,35'],
      correctIndex: 1,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: '3/4 kesrinin yüzde karşılığı nedir?',
      options: ['%25', '%50', '%70', '%75'],
      correctIndex: 3,
      explanation: '25 ile genişlet: 75/100',
      difficulty: 2,
    ),
    StemQuestion(
      question: '40 kişilik sınıfın %30\'u gözlüklüdür. Kaç gözlüklü öğrenci var?',
      options: ['10', '12', '15', '20'],
      correctIndex: 1,
      explanation: '40÷100×30 = 12',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi çeyreği ifade etmez?',
      options: ['%25', '1/4', '0,25', '25/10'],
      correctIndex: 3,
      explanation: '25/10 = 2,5',
      difficulty: 2,
    ),
    StemQuestion(
      question: '150 sayfanın 60\'ını okudum. Kitabın yüzde kaçını okudum?',
      options: ['%20', '%30', '%40', '%50'],
      correctIndex: 2,
      explanation: '60/150 = 2/5 = %40',
      difficulty: 2,
    ),
    StemQuestion(
      question: '500\'ün %1\'i kaçtır?',
      options: ['1', '5', '10', '50'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '%18, %24, 0,20 ve 1/5 sayılarından en küçüğü hangisidir?',
      options: ['%18', '%24', '0,20', '1/5'],
      correctIndex: 0,
      explanation: '%18 < %20 = %20 < %24',
      difficulty: 2,
    ),
    StemQuestion(
      question: '80 TL\'lik pantolona %50 indirim. Yeni fiyat kaç TL?',
      options: ['20', '30', '40', '50'],
      correctIndex: 2,
      explanation: 'Yarısı kadar indirim: 80÷2=40',
      difficulty: 1,
    ),
    StemQuestion(
      question: '0,04 sayısı hangi yüzdeye eşittir?',
      options: ['%40', '%4', '%0,4', '%400'],
      correctIndex: 1,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangi sayının %10\'u 7\'dir?',
      options: ['70', '700', '7000', '0,7'],
      correctIndex: 0,
      explanation: '7 × 10 = 70',
      difficulty: 2,
    ),
    StemQuestion(
      question: '20 ağacın 15\'i elma ağacıdır. Elma ağaçlarının oranı yüzde kaçtır?',
      options: ['%15', '%50', '%65', '%75'],
      correctIndex: 3,
      explanation: '15/20 = 75/100',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'A = %45, B = 0,55, C = 1/2. Sıralama nasıldır?',
      options: ['A < B < C', 'A < C < B', 'C < A < B', 'B < C < A'],
      correctIndex: 1,
      explanation: '%45 < %50 < %55',
      difficulty: 2,
    ),
    StemQuestion(
      question: '300 sayısının %25 eksiği kaçtır?',
      options: ['75', '200', '225', '250'],
      correctIndex: 2,
      explanation: '%25\'i 75 eder. 300-75=225',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Sürahinin %80\'i 400 ml ise tamamı kaç ml?',
      options: ['450', '500', '600', '800'],
      correctIndex: 1,
      explanation: '400÷80×100 = 500',
      difficulty: 3,
    ),
    StemQuestion(
      question: '17/20 kesrinin % sembolü ile yazılışı hangisidir?',
      options: ['%17', '%34', '%80', '%85'],
      correctIndex: 3,
      explanation: '5 ile genişlet: 85/100',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Telefon şarjı %15 kalmışsa tam dolması için yüzde kaç gerekir?',
      options: ['%75', '%80', '%85', '%95'],
      correctIndex: 2,
      explanation: '%100 - %15 = %85',
      difficulty: 1,
    ),
  ],
  formulaCards: const [
    'Bir sayının %x\'i = Sayı ÷ 100 × x',
    '%100 = Tam, %50 = Yarı, %25 = Çeyrek',
    'Kesir → Yüzde: Paydayı 100 yap',
    'İndirimli fiyat = Fiyat - (Fiyat × %İndirim / 100)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 5: ALAN VE ÇEVRE ÖLÇME
// ═══════════════════════════════════════════════════════════════

final _s5MatU5Content = StemUnitContent(
  unitId: 's5_mat_u5',
  topic: const TopicContent(
    summary: 'Bir şeklin kenar uzunluklarının toplamına çevre, şeklin düzlemde kapladığı yere ise alan denir. Çevre uzunluk birimleriyle (cm, m), alan kareli birimlerle (cm², m²) ifade edilir.',
    rule: 'Kare Çevresi: 4 × kenar\nDikdörtgen Çevresi: 2 × (kısa + uzun)\nKare Alanı: kenar × kenar\nDikdörtgen Alanı: kısa × uzun',
    formulas: [
      'Kare Çevresi = 4 × a',
      'Dikdörtgen Çevresi = 2 × (a + b)',
      'Kare Alanı = a × a = a²',
      'Dikdörtgen Alanı = a × b',
    ],
    keyPoints: [
      'Çevre → uzunluk birimi (cm, m)',
      'Alan → kare birimi (cm², m²)',
      'Kare özel bir dikdörtgendir',
      'Alan hesabında çarpma, çevre hesabında toplama yapılır',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kısa kenarı 5 cm, uzun kenarı 12 cm olan dikdörtgenin çevresi kaç cm?',
      steps: [
        'Formül: 2 × (kısa + uzun)',
        'Kenarlar toplanır: 5 + 12 = 17 cm',
        '2 ile çarpılır: 17 × 2 = 34 cm',
      ],
      answer: '34 cm',
    ),
    SolvedExample(
      question: 'Çevresi 20 cm olan karenin alanı kaç cm²?',
      steps: [
        'Kenar uzunluğu: Çevre ÷ 4 = 20 ÷ 4 = 5 cm',
        'Alan: kenar × kenar = 5 × 5 = 25 cm²',
      ],
      answer: '25 cm²',
    ),
    SolvedExample(
      question: 'Alanı 48 cm² olan dikdörtgenin kısa kenarı 6 cm ise uzun kenarı kaç cm?',
      steps: [
        'Alan = Kısa × Uzun → 6 × ? = 48',
        'Uzun kenar = 48 ÷ 6 = 8 cm',
      ],
      answer: '8 cm',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: 'Bir kenarı 8 cm olan karenin çevresi kaç cm\'dir?',
      options: ['16', '24', '32', '64'],
      correctIndex: 2,
      explanation: '4 × 8 = 32',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Uzun kenarı 10 cm, kısa kenarı 4 cm olan dikdörtgenin alanı kaç cm²?',
      options: ['14', '28', '40', '80'],
      correctIndex: 2,
      explanation: '10 × 4 = 40',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Çevresi 18 cm olan eşkenar üçgenin bir kenarı kaç cm\'dir?',
      options: ['3', '6', '9', '12'],
      correctIndex: 1,
      explanation: '18 ÷ 3 = 6',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Alan ölçü birimi aşağıdakilerden hangisidir?',
      options: ['metre (m)', 'santimetre (cm)', 'metrekare (m²)', 'litre (L)'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Kenar uzunlukları 3 cm ve 7 cm olan dikdörtgenin çevresi nedir?',
      options: ['10 cm', '20 cm', '21 cm', '30 cm'],
      correctIndex: 1,
      explanation: '(3+7)×2 = 20',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Alanı 36 cm² olan karenin bir kenarı kaç cm\'dir?',
      options: ['4', '6', '9', '12'],
      correctIndex: 1,
      explanation: '6 × 6 = 36',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisinin çevresi en büyüktür?',
      options: ['Kenarı 5 cm kare (Ç=20)', 'Kenarları 4-7 cm dikdörtgen (Ç=22)', 'Kenarları 6-6-6 üçgen (Ç=18)', 'Kenarları 3-9 cm dikdörtgen (Ç=24)'],
      correctIndex: 3,
      difficulty: 2,
    ),
    StemQuestion(
      question: '1 cm kenarı olan 5 kare yan yana getirilirse çevresi kaç cm?',
      options: ['5', '10', '12', '20'],
      correctIndex: 2,
      explanation: 'Uzun 5, kısa 1. (5+1)×2=12',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Çevresi 40 cm olan karenin alanı kaç cm²?',
      options: ['10', '40', '80', '100'],
      correctIndex: 3,
      explanation: 'Kenar=10. 10×10=100',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kenarları 20 m ve 30 m olan bahçeye 2 sıra tel çekilecek. Kaç m tel gerekir?',
      options: ['50', '100', '150', '200'],
      correctIndex: 3,
      explanation: 'Çevre: (20+30)×2=100. 2 sıra: 100×2=200',
      difficulty: 2,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: 'Bir kenarı 8 cm olan karenin çevresi?',
      options: ['16', '24', '32', '64'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '10 × 4 = ? (Dikdörtgen alanı)',
      options: ['14', '28', '40', '80'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: '18 ÷ 3 = ? (Eşkenar üçgen kenarı)',
      options: ['3', '6', '9', '12'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Alanı 36 cm² olan karenin kenarı?',
      options: ['4', '6', '9', '12'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '(3+7)×2 = ? (Dikdörtgen çevresi)',
      options: ['10', '20', '21', '30'],
      correctIndex: 1,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: 'Kenarları doğal sayı olan ve alanı 12 cm² olan kaç farklı dikdörtgen çizilebilir?',
      options: ['1', '2', '3', '4'],
      correctIndex: 2,
      explanation: '1×12, 2×6, 3×4 = 3 tane',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Dikdörtgenin uzun kenarı kısa kenarın 3 katı. Kısa kenar 5 cm ise alan?',
      options: ['15', '40', '75', '100'],
      correctIndex: 2,
      explanation: 'Uzun: 5×3=15. Alan: 5×15=75',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kenarı 4 m olan kare oda parkeyle kaplanacak. m² fiyatı 50 TL ise toplam maliyet?',
      options: ['200', '400', '800', '1600'],
      correctIndex: 2,
      explanation: 'Alan: 4×4=16 m². 16×50=800',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Çevresi 24 cm olan dikdörtgenin kenarları hangisi olamaz?',
      options: ['1 cm ve 11 cm', '2 cm ve 10 cm', '6 cm ve 6 cm', '5 cm ve 8 cm'],
      correctIndex: 3,
      explanation: '5+8=13, 13×2=26 (24 değil)',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'İki karenin çevre toplamı 40 cm. Birinin çevresi 16 cm ise diğerinin alanı?',
      options: ['16', '25', '36', '49'],
      correctIndex: 2,
      explanation: 'Diğer çevre: 24. Kenar: 6. Alan: 36',
      difficulty: 2,
    ),
    StemQuestion(
      question: '8 m ve 12 m kenarları olan dikdörtgen halının alanı kaç m²?',
      options: ['20', '40', '96', '100'],
      correctIndex: 2,
      explanation: '8 × 12 = 96',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Kenarı 6 cm olan karenin alanı, kısa kenarı 4 cm olan dikdörtgenle eşit. Uzun kenar kaç?',
      options: ['6', '8', '9', '12'],
      correctIndex: 2,
      explanation: 'Kare alanı: 36. 36÷4=9',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisinin çevresini bulmak için tek kenar yeterlidir?',
      options: ['Dikdörtgen', 'Çeşitkenar üçgen', 'Kare', 'İkizkenar üçgen'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Dikdörtgen masanın çevresi 300 cm. Uzun kenar 90 cm ise kısa kenar?',
      options: ['60', '105', '120', '210'],
      correctIndex: 0,
      explanation: '90×2=180. 300-180=120. 120÷2=60',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Alanı 81 m² olan kare bahçeye 1 sıra tel çekilecek. Kaç m tel gerekir?',
      options: ['9', '18', '27', '36'],
      correctIndex: 3,
      explanation: 'Kenar: 9. Çevre: 9×4=36',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kenarı 10 cm kareden kenarı 3 cm kare kesilirse kalan alan kaç cm²?',
      options: ['91', '94', '97', '100'],
      correctIndex: 0,
      explanation: '100 - 9 = 91',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Çevresi 60 cm olan dikdörtgenin kısa kenarı uzun kenarın yarısı. Kısa kenar?',
      options: ['10', '15', '20', '25'],
      correctIndex: 0,
      explanation: 'K=1 kat, U=2 kat. Çevre=6 kat=60. 1 kat=10',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Aşağıdaki ifadelerden hangisi yanlıştır?',
      options: ['Karenin tüm kenarları eşittir', 'Dikdörtgenin karşılıklı kenarları eşittir', 'Alan hesaplarken kenarlar toplanır', 'Çevre bir uzunluk belirtir'],
      correctIndex: 2,
      explanation: 'Alan hesaplarken çarpılır, toplanmaz',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Dikdörtgenin eni 2 cm, boyu 5 cm artırılırsa çevresi kaç cm artar?',
      options: ['7', '10', '14', '20'],
      correctIndex: 2,
      explanation: 'Her kenardan ikişer tane: 2×2+5×2=14',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Alanı 17 cm² olan dikdörtgenin (doğal sayı kenarlar) çevresi kaç cm?',
      options: ['17', '18', '34', '36'],
      correctIndex: 3,
      explanation: '17 asal: kenarlar 1 ve 17. (1+17)×2=36',
      difficulty: 3,
    ),
  ],
  formulaCards: const [
    'Kare Çevresi = 4 × a',
    'Dikdörtgen Çevresi = 2 × (a + b)',
    'Kare Alanı = a²',
    'Dikdörtgen Alanı = a × b',
    'Alan → cm², m² | Çevre → cm, m',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 6: VERİ TOPLAMA VE GRAFİK OKUMA
// ═══════════════════════════════════════════════════════════════

final _s5MatU6Content = StemUnitContent(
  unitId: 's5_mat_u6',
  topic: const TopicContent(
    summary: 'Bir konuda bilgi toplamak için hazırlanan sorulara araştırma sorusu denir. Toplanan veriler çetele tablosu veya sıklık tablosu ile düzenlenir, sonra sütun grafiği ile görselleştirilir.',
    rule: 'Sütun grafiği çizerken:\n- Eksenlerin neyi ifade ettiği yazılmalıdır\n- Sütun genişlikleri eşit olmalıdır\n- Sütunlar arası boşluklar eşit olmalıdır\n- Sayılar eşit aralıklarla artmalıdır',
    formulas: [],
    keyPoints: [
      'Çetele tablosu: Çizgilerle gösterim (4 çizgi + 1 yatay = 5)',
      'Sıklık tablosu: Sayılarla gösterim',
      'Araştırma sorusu: Bir gruba sorulur, farklı cevaplar alınır',
      'Grafik adı en üste veya alta yazılır',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Bir sınıfta 5 kişi elma, 8 kişi armut, 3 kişi muz seviyor. Sıklık tablosu oluşturunuz.',
      steps: [
        'Tablo başlığı: "Sevilen Meyveler"',
        'Elma: 5, Armut: 8, Muz: 3',
        'Her meyve adı satıra, sayısı karşısına yazılır',
      ],
      answer: 'Elma: 5, Armut: 8, Muz: 3',
    ),
    SolvedExample(
      question: 'Ali 10, Ayşe 15, Can 5 kitap okudu. En çok ile en az arasındaki fark?',
      steps: [
        'En çok: Ayşe (15)',
        'En az: Can (5)',
        'Fark: 15 - 5 = 10',
      ],
      answer: '10',
    ),
    SolvedExample(
      question: '"Ayşe\'nin en sevdiği renk" mi yoksa "5-A sınıfının en sevdiği renk" mi araştırma sorusudur?',
      steps: [
        '"Ayşe\'nin rengi" tek kişi → veri grubu oluşturmaz',
        '"5-A sınıfı" bir grup → farklı cevaplar alınabilir',
      ],
      answer: '"5-A sınıfındaki öğrencilerin en sevdiği renk nedir?" araştırma sorusudur',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
      question: 'Verilerin çizgilerle gösterildiği tabloya ne ad verilir?',
      options: ['Sıklık Tablosu', 'Çetele Tablosu', 'Sütun Grafiği', 'Ağaç Şeması'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Grafikte dikey eksende 0,4,8,12... varsa 20\'yi gösteren sütun kaç birim?',
      options: ['4', '5', '6', '8'],
      correctIndex: 1,
      explanation: '20 ÷ 4 = 5 aralık',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi araştırma sorusu olamaz?',
      options: ['Okuldaki öğrencilerin en sevdiği ders', 'Türkiye\'nin başkenti', 'Sınıftaki öğrencilerin tuttukları takımlar', 'İnsanların en çok izlediği program'],
      correctIndex: 1,
      explanation: 'Cevabı net, araştırma gerektirmez',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Çetele tablosunda "||||" sembolü kaç sayısını ifade eder?',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '12 kız, 18 erkek varsa sütun grafiğinde erkek sütunu kızlardan ne kadar uzun?',
      options: ['4', '6', '8', '10'],
      correctIndex: 1,
      explanation: '18 - 12 = 6',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Grafiklerde sütunlar arasındaki boşluklar nasıl olmalıdır?',
      options: ['Rastgele', 'Biri dar biri geniş', 'Eşit', 'Sütunlar yapışık olmalı'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'En büyük 90, en küçük 40 ise açıklık (fark) kaçtır?',
      options: ['40', '50', '130', '140'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Sıklık tablosundaki sayılar çetele tablosunda ne ile gösterilir?',
      options: ['Resimlerle', 'Çizgilerle', 'Noktalarla', 'Harflerle'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '10 kırmızı, 5 beyaz, 15 siyah araba var. En çok hangi renk?',
      options: ['Kırmızı', 'Beyaz', 'Siyah', 'Mavi'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Grafiğin adı nereye yazılır?',
      options: ['Sütunların içine', 'Grafiğin altına veya üstüne', 'Eksenlerin yanına', 'Hiçbir yere'],
      correctIndex: 1,
      difficulty: 1,
    ),
  ],
  speedTestQuestions: const [
    StemQuestion(
      question: 'Çetele tablosunda "||||" kaç sayısıdır?',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '18 - 12 = ? (Sütun farkı)',
      options: ['4', '6', '8', '10'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '90 - 40 = ? (Açıklık)',
      options: ['40', '50', '130', '140'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Grafik adı nereye yazılır?',
      options: ['Sütunların içine', 'Grafiğin altına/üstüne', 'Eksenlerin yanına', 'Hiçbir yere'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Grafik sütunları arası boşluk nasıl olmalı?',
      options: ['Rastgele', 'Farklı', 'Eşit', 'Yapışık'],
      correctIndex: 2,
      difficulty: 1,
    ),
  ],
  examQuestions: const [
    StemQuestion(
      question: '(Grafik: Pzt 20, Sal 30, Çrş 25, Prş 40, Cum 45) En çok soru hangi gün?',
      options: ['Salı', 'Çarşamba', 'Perşembe', 'Cuma'],
      correctIndex: 3,
      explanation: '45 soru ile Cuma',
      difficulty: 1,
    ),
    StemQuestion(
      question: '(Grafik: Pzt 20, Sal 30, Çrş 25, Prş 40, Cum 45) Toplam kaç soru?',
      options: ['100', '120', '140', '160'],
      correctIndex: 3,
      explanation: '20+30+25+40+45=160',
      difficulty: 1,
    ),
    StemQuestion(
      question: '(Grafik) Perşembe sorusu Salı\'dan kaç fazla?',
      options: ['5', '10', '15', '20'],
      correctIndex: 1,
      explanation: '40-30=10',
      difficulty: 1,
    ),
    StemQuestion(
      question: '8 Çikolatalı, 6 Vanilyalı, 4 Çilekli, 2 Limonlu dondurma. En kısa sütun?',
      options: ['Çikolatalı', 'Vanilyalı', 'Çilekli', 'Limonlu'],
      correctIndex: 3,
      explanation: '2 kişi',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi veri toplama yöntemi değildir?',
      options: ['Anket yapmak', 'Gözlem yapmak', 'Görüşme yapmak', 'Tahmin etmek'],
      correctIndex: 3,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Eksenlerden biri "Günler" ise diğeri ne olabilir?',
      options: ['Aylar', 'Yıllar', 'Sıcaklık Değeri', 'Mevsimler'],
      correctIndex: 2,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Çetele tablosunda bir beşlik grup nasıl gösterilir?',
      options: ['|||||', '/////', '4 dikey çizgi + 1 yatay', '5 nokta'],
      correctIndex: 2,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Araştırma sorusu kime sorulmalıdır?',
      options: ['İlgisiz kişilere', 'Örneklem grubuna', 'Sadece çocuklara', 'Sadece yaşlılara'],
      correctIndex: 1,
      difficulty: 1,
    ),
    StemQuestion(
      question: '100 öğrencinin 30\'u basketbol seviyor. Basketbol sevenlerin yüzdesi?',
      options: ['%10', '%20', '%30', '%40'],
      correctIndex: 2,
      explanation: '30/100 = %30',
      difficulty: 1,
    ),
    StemQuestion(
      question: '(Veriler: 40 Futbol, 30 Basketbol, 20 Voleybol, 10 Yüzme) Futbol-Voleybol farkı?',
      options: ['10', '20', '30', '40'],
      correctIndex: 1,
      explanation: '40-20=20',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Sütun boyları birbirine çok yakınsa ne anlama gelir?',
      options: ['Veriler eşit/yakın', 'Veriler hatalı', 'Grafik yanlış', 'Veriler çok farklı'],
      correctIndex: 0,
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Sütun grafiği ile göstermeye uygun olan hangisidir?',
      options: ['Bitki uzaması', 'Farklı illerin sıcaklıkları', 'Ders notları dağılımı', 'Hepsi'],
      correctIndex: 3,
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Başkanlık seçimi: Ali 12, Veli 8, Can 5 oy. Toplam kaç oy?',
      options: ['20', '25', '30', '35'],
      correctIndex: 1,
      explanation: '12+8+5=25',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Sütun grafiği kullanmak hangi durumda yanlış olur?',
      options: ['Marka satışlarını karşılaştırırken', 'Sıcaklık değişimi gösterirken', 'Nüfus cüzdanı bilgilerini gösterirken', 'Öğrenci boylarını gösterirken'],
      correctIndex: 2,
      explanation: 'Nüfus bilgileri sayısal veri grubu oluşturmaz',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Grafik yorumlarken hangisine bakmak gerekmez?',
      options: ['Eksen isimlerine', 'Sütun yüksekliklerine', 'Grafiğin rengine', 'Grafiğin başlığına'],
      correctIndex: 2,
      explanation: 'Renk sadece görsellik katar',
      difficulty: 1,
    ),
  ],
  formulaCards: const [
    'Çetele: 4 dikey + 1 yatay çizgi = 5',
    'Sıklık tablosu: Sayılarla gösterim',
    'Grafik: Eşit genişlik, eşit boşluk, eşit aralık',
    'Araştırma sorusu: Bir gruba sorulur, farklı cevaplar olur',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// 5. SINIF FEN BİLİMLERİ İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 1: CANLILAR DÜNYASI
// ═══════════════════════════════════════════════════════════════

final _s5FenU1Content = StemUnitContent(
  unitId: 's5_fen_u1',
  topic: const TopicContent(
    summary: 'Canlıların en küçük yapı taşına hücre denir. Canlılar hücre yapılarına göre tek hücreli (bakteri, amip, öglena) ve çok hücreli (insan, hayvan, bitki) olarak ikiye ayrılır.',
    rule: 'Bitki Hücresi: Köşelidir, hücre duvarı ve kloroplast bulunur, sentrozom bulunmaz.\nHayvan Hücresi: Yuvarlaktır, hücre duvarı ve kloroplast yoktur, sentrozom bulunur.',
    formulas: [],
    keyPoints: [
      'Hücre duvarı bitkiye sertlik ve dayanıklılık verir',
      'Kloroplast fotosentez yapar (sadece bitkide)',
      'Çekirdek hücrenin yönetim merkezidir',
      'Mitokondri her iki hücrede de enerji üretir',
      'Hücre → Doku → Organ → Sistem → Organizma',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Bir hücre mikroskopta incelendiğinde köşeli yapıya sahip ve hücre duvarı bulunuyor. Bu hücre kime aittir?',
      steps: [
        'Hücre duvarı sadece bitki, mantar ve bakterilerde bulunur',
        'Köşeli yapı bitki hücresine özgüdür',
        'Hayvan hücreleri yuvarlaktır ve duvarları yoktur',
      ],
      answer: 'Bitki hücresidir',
    ),
    SolvedExample(
      question: 'Amip ve İnsan arasındaki temel hücresel fark nedir?',
      steps: [
        'Amip tek bir hücreden oluşur, tüm faaliyetlerini tek hücre yapar',
        'İnsan çok hücrelidir, doku ve organları vardır',
      ],
      answer: 'Hücre sayısı (Tek hücreli vs Çok hücreli)',
    ),
    SolvedExample(
      question: 'Bir hücrede kloroplast organeli tespit edilmiştir. Bu canlı kendi besinini üretebilir mi?',
      steps: [
        'Kloroplast güneş ışığını kullanarak besin ve oksijen üretir (fotosentez)',
        'Bu organel sadece bitkilerde bulunur',
      ],
      answer: 'Evet, üretebilir',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Aşağıdakilerden hangisi tek hücreli bir canlıdır?', options: ['Kedi', 'Papatya', 'Öglena', 'Solucan'], correctIndex: 2, explanation: 'Öglena mikroskobik tek hücreli bir canlıdır', difficulty: 1),
    StemQuestion(question: 'Bitki hücresine sertlik ve dayanıklılık veren yapı hangisidir?', options: ['Çekirdek', 'Hücre Duvarı', 'Sitoplazma', 'Hücre Zarı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hayvan hücresinde bulunmayıp bitki hücresinde bulunan, besin üretiminden sorumlu organel?', options: ['Mitokondri', 'Koful', 'Kloroplast', 'Ribozom'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hayvan hücresinin şekli nasıldır?', options: ['Köşeli', 'Yuvarlak', 'Yıldız', 'Kare'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hücrenin yönetim merkezi neresidir?', options: ['Çekirdek', 'Sitoplazma', 'Zar', 'Duvar'], correctIndex: 0, explanation: 'Çekirdek DNA\'yı barındırır ve hücreyi yönetir', difficulty: 1),
    StemQuestion(question: 'Küçük canlıları incelemek için hangi araç kullanılır?', options: ['Teleskop', 'Dürbün', 'Mikroskop', 'Periskop'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Aşağıdakilerden hangisi çok hücrelidir?', options: ['Paramesyum', 'Bakteri', 'Şapkalı Mantar', 'Amip'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hücre içindeki yaşamsal faaliyetlerin gerçekleştiği akışkan sıvıya ne denir?', options: ['Çekirdek', 'Sitoplazma', 'Zar', 'Duvar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sentrozom organeli hangi hücre tipinde bulunur?', options: ['Sadece Bitki', 'Sadece Hayvan', 'Her ikisi', 'Hiçbiri'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Bitki ve hayvan hücresinin ortak yapısı hangisidir?', options: ['Hücre Duvarı', 'Kloroplast', 'Hücre Zarı', 'Şekil'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Tek hücreli canlı hangisidir?', options: ['Kedi', 'Papatya', 'Öglena', 'Solucan'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hayvan hücresi şekli?', options: ['Köşeli', 'Yuvarlak', 'Yıldız', 'Kare'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hücrenin yönetim merkezi?', options: ['Çekirdek', 'Sitoplazma', 'Zar', 'Duvar'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Fotosentez yapan organel?', options: ['Mitokondri', 'Koful', 'Kloroplast', 'Ribozom'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Bitki-hayvan ortak yapı?', options: ['Hücre Duvarı', 'Kloroplast', 'Hücre Zarı', 'Sentrozom'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hücre zarı ile ilgili hangisi yanlıştır?', options: ['Canlıdır', 'Seçici geçirgendir', 'Sert ve cansızdır', 'Hücreyi korur'], correctIndex: 2, explanation: 'Sert ve cansız olan Hücre Duvarıdır, zar esnektir', difficulty: 2),
    StemQuestion(question: 'Kloroplast görülmeyen hücre kesinlikle bitki değildir diyebilir miyiz?', options: ['Evet, bitkilerin hepsinde vardır', 'Hayır, kök hücrelerinde kloroplast olmayabilir', 'Evet, kloroplast hayvanlarda olur', 'Hayır, kloroplast mantarlarda bulunur'], correctIndex: 1, explanation: 'Bitkinin kök gibi ışık almayan hücrelerinde kloroplast bulunmayabilir', difficulty: 3),
    StemQuestion(question: 'Hücre→Doku→Organ→?→Organizma sıralamasında ? ne gelir?', options: ['Sistem', 'Hücre', 'İnsan', 'Çekirdek'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangi eşleştirme yanlıştır?', options: ['Mitokondri-Enerji Üretimi', 'Ribozom-Protein Sentezi', 'Koful-Atık depolama', 'Çekirdek-Enerji üretimi'], correctIndex: 3, explanation: 'Çekirdek yönetim merkezidir, enerji üretmez', difficulty: 2),
    StemQuestion(question: 'Soğan zarı hücresi hangi şekle benzer?', options: ['Daire', 'Dikdörtgen (Tuğla dizilimi)', 'Üçgen', 'Düzensiz'], correctIndex: 1, explanation: 'Bitki hücresi olduğu için köşeli/tuğla gibidir', difficulty: 2),
    StemQuestion(question: 'Bakteriler ile ilgili hangisi doğrudur?', options: ['Çok hücrelidirler', 'Mikroskopla görülürler', 'Hepsi zararlıdır', 'Kloroplastları vardır'], correctIndex: 1, explanation: 'Tek hücrelidirler ve mikroskopla görülürler', difficulty: 1),
    StemQuestion(question: 'Hücre duvarının temel görevi nedir?', options: ['Madde alışverişini kontrol etmek', 'Hücreye koruma ve dayanıklılık sağlamak', 'Enerji üretmek', 'Yönetimi sağlamak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hücrelerin iş bölümü yapması neyi sağlar?', options: ['Canlının küçük olmasını', 'Enerji tasarrufunu ve hızlı iş yapılmasını', 'Hücre sayısının azalmasını', 'Canlının tek hücreli kalmasını'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Sitoplazmanın yapısı nasıldır?', options: ['Sert ve kuru', 'Yumurta akı kıvamında, yarı akışkan', 'Gaz halinde', 'Tamamen su gibi'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Hangisi bir Sistem örneğidir?', options: ['Mide', 'Kan Hücresi', 'Sindirim Sistemi', 'İnsan'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Terliksi hayvan (Paramesyum) hangi grupta yer alır?', options: ['Bitkiler', 'Tek Hücreliler', 'Hayvanlar', 'Mantarlar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hücre zarının "Seçici Geçirgen" olması ne demektir?', options: ['Her maddeyi içeri alır', 'Hiçbir maddeyi almaz', 'Yararlı maddeleri alır, zararlıları atar', 'Sadece suyu geçirir'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Hem bitki hem hayvan hücresinde aynı görevi yapan organel?', options: ['Mitokondri', 'Hücre duvarı', 'Kloroplast', 'Sentrozom'], correctIndex: 0, explanation: 'Her iki hücrede de mitokondri enerji üretir', difficulty: 2),
    StemQuestion(question: 'Yoğurdun mayalanmasını sağlayan canlı grubu?', options: ['Küf mantarı', 'Bakteriler', 'Şapkalı mantar', 'Algler'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Bir canlının canlılık özelliği gösteren en küçük birimi?', options: ['Organel', 'Atom', 'Hücre', 'Doku'], correctIndex: 2, difficulty: 1),
  ],
  formulaCards: const [
    'Bitki hücresi: Köşeli, hücre duvarı var, kloroplast var',
    'Hayvan hücresi: Yuvarlak, hücre duvarı yok, sentrozom var',
    'Hücre → Doku → Organ → Sistem → Organizma',
    'Kloroplast = Fotosentez, Mitokondri = Enerji',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 2: KUVVET VE HAREKET
// ═══════════════════════════════════════════════════════════════

final _s5FenU2Content = StemUnitContent(
  unitId: 's5_fen_u2',
  topic: const TopicContent(
    summary: 'Kuvvet duran cismi hareket ettirir, hareket edeni durdurur, şeklini veya yönünü değiştirir. Birimi Newton (N), dinamometre ile ölçülür. Sürtünme kuvveti harekete zıt yönde etki eder.',
    rule: 'Sürtünme: Pürüzlü yüzeyde fazla, kaygan yüzeyde az.\nYerçekimi: Dünya\'nın cisimleri merkeze çekmesi.\nHareket Enerjisi: Hız arttıkça artar.',
    formulas: [
      'Kuvvet birimi: Newton (N)',
      'Ölçüm aracı: Dinamometre (yay)',
    ],
    keyPoints: [
      'Sürtünme harekete zıt yöndedir',
      'Pürüzlü yüzey = çok sürtünme',
      'Sürtünme ısı enerjisi açığa çıkarır',
      'Yerçekimi yerin merkezine doğrudur',
      'Dünya\'da ağırlık > Ay\'da ağırlık',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Futbol topu çim sahada ve betonda aynı hızla yuvarlanıyor. Hangisinde daha çabuk durur?',
      steps: [
        'Çim saha betona göre daha pürüzlüdür',
        'Pürüzlü yüzeyde sürtünme kuvveti daha fazladır',
      ],
      answer: 'Çim sahada daha çabuk durur',
    ),
    SolvedExample(
      question: 'Paraşütçünün hızının aşırı artmamasını sağlayan kuvvet nedir?',
      steps: [
        'Yerçekimi onu aşağı çeker',
        'Hava direnci (sürtünme) yukarı yönde etki eder',
      ],
      answer: 'Hava direnci (Sürtünme kuvveti)',
    ),
    SolvedExample(
      question: 'Kışın araba tekerleklerine neden zincir takılır?',
      steps: [
        'Buzlu yollar çok kaygandır (sürtünme azdır)',
        'Zincir yüzeyi pürüzlü hale getirir',
      ],
      answer: 'Sürtünmeyi artırmak ve kaymayı önlemek için',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Kuvveti ölçen aletin adı nedir?', options: ['Termometre', 'Dinamometre', 'Barometre', 'Metre'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sürtünme kuvvetinin yönü nasıldır?', options: ['Hareketle aynı yönde', 'Harekete zıt yönde', 'Yukarı doğru', 'Aşağı doğru'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi sürtünmeyi azaltmaya yönelik bir işlemdir?', options: ['Kapı menteşelerini yağlamak', 'Yola kum dökmek', 'Ayakkabı tabanının tırtıklı olması', 'Paraşüt kullanmak'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Dünya\'nın cisimlere uyguladığı çekim kuvvetine ne denir?', options: ['Manyetizma', 'Yerçekimi Kuvveti', 'Sürtünme', 'İtme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dinamometrenin içindeki temel parça nedir?', options: ['Cıva', 'Yay', 'Su', 'Mıknatıs'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Havadaki cisimlere etki eden sürtünme kuvvetine ne denir?', options: ['Su direnci', 'Hava direnci', 'Yerçekimi', 'Manyetik alan'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi pürüzlü bir yüzeydir?', options: ['Ayna', 'Buz', 'Zımpara kağıdı', 'Yağlı kağıt'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Gemilerin ucunun V şeklinde yapılması neyi sağlar?', options: ['Su direncini artırmayı', 'Su direncini azaltmayı', 'Daha ağır olmasını', 'Balıkları korkutmayı'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Sürtünme kuvveti sonucunda genelde hangi enerji açığa çıkar?', options: ['Isı enerjisi', 'Işık enerjisi', 'Nükleer enerji', 'Elektrik enerjisi'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Bir cismin ağırlığı Dünya\'da mı Ay\'da mı daha fazladır?', options: ['Ay\'da', 'Eşittir', 'Dünya\'da', 'Değişmez'], correctIndex: 2, explanation: 'Dünya\'nın yerçekimi Ay\'dan büyüktür', difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Kuvvet ölçen alet?', options: ['Termometre', 'Dinamometre', 'Barometre', 'Metre'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sürtünme kuvveti yönü?', options: ['Aynı yön', 'Zıt yön', 'Yukarı', 'Aşağı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Pürüzlü yüzey hangisi?', options: ['Ayna', 'Buz', 'Zımpara', 'Yağlı kağıt'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Sürtünme hangi enerjiyi açığa çıkarır?', options: ['Isı', 'Işık', 'Nükleer', 'Elektrik'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Yerçekimi yönü?', options: ['Sağa', 'Sola', 'Yerin merkezine', 'Gökyüzüne'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisinde sürtünme artırılmıştır?', options: ['Valize tekerlek takılması', 'Makine parçaları yağlanması', 'Haltercinin eline toz sürmesi', 'Uçak burnunun sivri olması'], correctIndex: 2, explanation: 'Toz elin kaymasını engeller', difficulty: 2),
    StemQuestion(question: 'Dinamometre ile ilgili hangisi yanlıştır?', options: ['Kuvvet ölçer', 'Yaylardan yararlanılır', 'Her dinamometre her ağırlığı ölçebilir', 'Birimi Newton\'dur'], correctIndex: 2, explanation: 'Her dinamometrenin bir ölçüm sınırı vardır', difficulty: 2),
    StemQuestion(question: 'Yüksekten bırakılan taşın düşmesini sağlayan kuvvet?', options: ['Hava direnci', 'Yerçekimi', 'Sürtünme', 'Manyetik kuvvet'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Cam, Halı, Beton yüzeyde oyuncak araba en uzağa hangisinde gider?', options: ['Cam', 'Halı', 'Beton', 'Hepsinde aynı'], correctIndex: 0, explanation: 'Cam en kaygan yüzeydir', difficulty: 2),
    StemQuestion(question: 'Sürtünme olmasaydı hangisi gerçekleşmezdi?', options: ['Yürüyemezdik', 'Yazı yazamazdık', 'Arabalar fren yapınca duramazdı', 'Hepsi'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Su direnci ile ilgili hangisi doğrudur?', options: ['Suda hareketi zorlaştırır', 'Havadaki dirençten azdır', 'Balık pulları direnci artırır', 'Sadece yüzeyde etkilidir'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: '20 N\'da 2 birim uzayan dinamometreye 40 N asılırsa kaç birim uzar?', options: ['2', '3', '4', '5'], correctIndex: 2, explanation: 'Ağırlık 2 kat → uzama 2 kat: 2×2=4', difficulty: 2),
    StemQuestion(question: 'Uzayda yerçekimi yoksa cismin ağırlığı ne olur?', options: ['Artar', 'Sıfır olur', 'Değişmez', 'Azalır'], correctIndex: 1, explanation: 'Ağırlık yerçekimine bağlıdır', difficulty: 2),
    StemQuestion(question: 'Hava direncinden en az etkilenecek araç?', options: ['Tır', 'Otobüs', 'Yarış arabası', 'Kamyonet'], correctIndex: 2, explanation: 'Alçak ve aerodinamik yapı', difficulty: 2),
    StemQuestion(question: 'Sürtünme kinetik enerjiyi neye dönüştürür?', options: ['Isı enerjisi', 'Potansiyel enerji', 'Işık enerjisi', 'Kimyasal enerji'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Hassas ölçüm için dinamometre yayı nasıl olmalı?', options: ['Kalın telli', 'İnce telli', 'Çok sert', 'Kısa'], correctIndex: 1, explanation: 'İnce yay küçük kuvvetlerde de uzar', difficulty: 3),
    StemQuestion(question: 'Cisimlerin hareketine zıt yönde oluşan etkiye ne denir?', options: ['İtme', 'Çekme', 'Sürtünme', 'Kuvvet'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Paraşütlerin geniş yapılmasının sebebi?', options: ['Güzel görünmesi', 'Hava direncini artırarak güvenli iniş', 'Hava direncini azaltarak hızlı iniş', 'Rüzgardan etkilenmemek'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Yerçekimi kuvvetinin yönü nasıldır?', options: ['Sağa', 'Sola', 'Yerin merkezine', 'Gökyüzüne'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Mıknatısın demiri çekmesi temas gerektiren kuvvet midir?', options: ['Evet', 'Hayır', 'Bazen', 'Bilinemez'], correctIndex: 1, explanation: 'Mıknatıs, yerçekimi ve elektrik kuvvetleri temassızdır', difficulty: 2),
  ],
  formulaCards: const [
    'Kuvvet birimi: Newton (N)',
    'Sürtünme: Harekete zıt yönde, pürüzlü → fazla',
    'Yerçekimi: Yerin merkezine doğru',
    'Sürtünme → Isı enerjisi açığa çıkar',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 3: MADDENİN DEĞİŞİMİ
// ═══════════════════════════════════════════════════════════════

final _s5FenU3Content = StemUnitContent(
  unitId: 's5_fen_u3',
  topic: const TopicContent(
    summary: 'Fiziksel değişimde maddenin sadece dış görünüşü değişir (kağıt yırtılması, buz erimesi). Kimyasal değişimde iç yapısı değişir, yeni madde oluşur (yanma, paslanma, pişme). Hal değişimi maddenin katı-sıvı-gaz arasında geçiş yapmasıdır.',
    rule: 'Isı alarak: Erime, Buharlaşma, Süblimleşme\nIsı vererek: Donma, Yoğuşma, Kırağılaşma\nHal değişimi sırasında saf maddenin sıcaklığı değişmez.',
    formulas: [
      'Katı → Sıvı: Erime (ısı alır)',
      'Sıvı → Gaz: Buharlaşma/Kaynama (ısı alır)',
      'Katı → Gaz: Süblimleşme (ısı alır)',
      'Gaz → Katı: Kırağılaşma (ısı verir)',
    ],
    keyPoints: [
      'Fiziksel: Geri dönüşümlü, kimlik değişmez',
      'Kimyasal: Geri dönüşümsüz, yeni madde oluşur',
      'Kaynama sıcaklığı ayırt edici özelliktir',
      'Isı alan madde genleşir',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '"Sütten yoğurt yapılması" ve "Sütün dökülmesi" olaylarını sınıflandırınız.',
      steps: [
        'Süt dökülünce hala süttür → Fiziksel değişim',
        'Süt mayalanıp yoğurt olunca tadı ve yapısı değişir → Kimyasal değişim',
      ],
      answer: 'Yoğurt yapımı: Kimyasal, Dökülme: Fiziksel',
    ),
    SolvedExample(
      question: 'Kaynama ve Buharlaşma arasındaki temel fark nedir?',
      steps: [
        'Buharlaşma her sıcaklıkta ve sadece yüzeyde olur',
        'Kaynama belirli sıcaklıkta ve sıvının her yerinde olur',
      ],
      answer: 'Kaynama hızlı ve her yerde; buharlaşma yavaş ve yüzeyde',
    ),
    SolvedExample(
      question: 'Naftalinin katıdan doğrudan gaz haline geçmesine ne denir?',
      steps: [
        'Katı → Gaz geçişi (sıvı aşaması atlanır)',
      ],
      answer: 'Süblimleşme',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Hangisi kimyasal değişimdir?', options: ['Ekmeğin dilimlenmesi', 'Demirin paslanması', 'Buzun erimesi', 'Suyun kaynaması'], correctIndex: 1, explanation: 'Paslanma maddenin yapısını bozar', difficulty: 1),
    StemQuestion(question: 'Sıvının ısı vererek katılaşmasına ne denir?', options: ['Erime', 'Donma', 'Buharlaşma', 'Yoğuşma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi fiziksel değişimdir?', options: ['Yumurtanın haşlanması', 'Odunun yanması', 'Camın kırılması', 'Elmanın çürümesi'], correctIndex: 2, explanation: 'Kırılan cam hala camdır', difficulty: 1),
    StemQuestion(question: 'Gazın ısı vererek sıvılaşmasına ne denir?', options: ['Yoğuşma', 'Süblimleşme', 'Kaynama', 'Erime'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Saf sıvı kaynarken sıcaklığı nasıl değişir?', options: ['Artar', 'Azalır', 'Sabit kalır', 'Önce artar sonra azalır'], correctIndex: 2, explanation: 'Hal değişiminde saf madde sıcaklığı sabit', difficulty: 2),
    StemQuestion(question: 'Erime noktası ayırt edici bir özellik midir?', options: ['Evet', 'Hayır', 'Sadece sıvılar için', 'Bilinemez'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Çamaşırların kuruması hangi olaya örnektir?', options: ['Kaynama', 'Buharlaşma', 'Erime', 'Donma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yapraklardaki çiy damlaları hangi olayla oluşur?', options: ['Erime', 'Donma', 'Yoğuşma', 'Süblimleşme'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Mumun erimesi fiziksel mi kimyasal mıdır?', options: ['Kimyasal', 'Fiziksel', 'Her ikisi', 'Hiçbiri'], correctIndex: 1, explanation: 'Eriyen mum tekrar donarsa eski haline döner', difficulty: 2),
    StemQuestion(question: 'Isı alan maddelerin hacminin artmasına ne denir?', options: ['Büzülme', 'Genleşme', 'Erime', 'Kaynama'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Demirin paslanması hangi değişim?', options: ['Fiziksel', 'Kimyasal', 'Hal değişimi', 'Hiçbiri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sıvı→Katı geçişi?', options: ['Erime', 'Donma', 'Buharlaşma', 'Yoğuşma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çamaşır kuruması?', options: ['Kaynama', 'Buharlaşma', 'Erime', 'Donma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Camın kırılması hangi değişim?', options: ['Kimyasal', 'Fiziksel', 'Her ikisi', 'Hiçbiri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Isı alan madde ne yapar?', options: ['Büzülür', 'Genleşir', 'Erir', 'Donar'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisinde yeni bir madde oluşur?', options: ['Tuzun suda çözünmesi', 'Kağıdın buruşturulması', 'Kekin pişmesi', 'Havucun rendelenmesi'], correctIndex: 2, explanation: 'Pişme kimyasal değişimdir', difficulty: 2),
    StemQuestion(question: 'Hangisi buharlaşmayı hızlandırmaz?', options: ['Sıcaklığın artması', 'Yüzeyin genişlemesi', 'Rüzgar', 'Havanın nemli olması'], correctIndex: 3, explanation: 'Nemli havada buharlaşma yavaşlar', difficulty: 2),
    StemQuestion(question: 'Göllerin yüzeyi donar ama altı sıvı kalır. Sebebi?', options: ['Buzun yoğunluğunun sudan küçük olması', 'Buzun ağır olması', 'Suyun tuzlu olması', 'Balıkların hareket etmesi'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Isı alan maddede hangisi gerçekleşmez?', options: ['Sıcaklığı artabilir', 'Hal değiştirebilir', 'Büzülebilir', 'Genleşebilir'], correctIndex: 2, explanation: 'Isı alan madde genleşir, büzülmez', difficulty: 2),
    StemQuestion(question: 'Hangisi Süblimleşmeye örnektir?', options: ['Buzun erimesi', 'Naftalinin dolapta yok olması', 'Suyun donması', 'Yağmur yağması'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'I.Yoğurt yapımı II.Peynir küflenmesi III.Buz erimesi - Hangileri kimyasal?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 1, explanation: 'Mayalanma ve küflenme kimyasal, erime fiziksel', difficulty: 2),
    StemQuestion(question: 'Yükseklere çıkıldıkça kaynama noktası nasıl değişir?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce azalır sonra artar'], correctIndex: 1, explanation: 'Basınç azalır, kaynama noktası düşer', difficulty: 3),
    StemQuestion(question: 'Farklı sıcaklıktaki iki madde temas ederse ne olur?', options: ['Isı alışverişi olur', 'Hiçbir şey olmaz', 'İkisinin de sıcaklığı artar', 'İkisinin de sıcaklığı azalır'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Isı ve Sıcaklık farkı hangisidir?', options: ['Isı enerji, sıcaklık ölçümdür', 'İkisi de enerjidir', 'Sıcaklık kalorimetre ile ölçülür', 'Isı termometre ile ölçülür'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Hangisi ısıyı iyi iletir?', options: ['Tahta', 'Plastik', 'Bakır', 'Yün'], correctIndex: 2, explanation: 'Metaller iyi iletkendir', difficulty: 1),
    StemQuestion(question: 'Kırağılaşma nedir?', options: ['Gazın sıvıya dönüşmesi', 'Gazın doğrudan katıya dönüşmesi', 'Katının sıvıya dönüşmesi', 'Sıvının gaza dönüşmesi'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Dişlerin çürümesi nasıl bir değişimdir?', options: ['Fiziksel', 'Kimyasal', 'Mekanik', 'Hal değişimi'], correctIndex: 1, explanation: 'Yapı bozulur, geri dönüşü yoktur', difficulty: 1),
    StemQuestion(question: 'Elektrik tellerinin yazın sarkması neye örnektir?', options: ['Erime', 'Büzülme', 'Genleşme', 'Buharlaşma'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi maddenin ayırt edici özelliğidir?', options: ['Kütle', 'Hacim', 'Kaynama Noktası', 'Renk'], correctIndex: 2, explanation: 'Saf maddelerin kaynama noktası sabittir', difficulty: 2),
    StemQuestion(question: 'Saçın kesilmesi ve boyanması sırasıyla hangi değişimler?', options: ['Fiziksel-Fiziksel', 'Kimyasal-Kimyasal', 'Fiziksel-Kimyasal', 'Kimyasal-Fiziksel'], correctIndex: 2, difficulty: 2),
  ],
  formulaCards: const [
    'Fiziksel: Dış görünüş değişir, kimlik aynı',
    'Kimyasal: Yeni madde oluşur, geri dönüşümsüz',
    'Isı alarak: Erime, Buharlaşma, Süblimleşme',
    'Isı vererek: Donma, Yoğuşma, Kırağılaşma',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 4: IŞIK VE SES
// ═══════════════════════════════════════════════════════════════

final _s5FenU4Content = StemUnitContent(
  unitId: 's5_fen_u4',
  topic: const TopicContent(
    summary: 'Işık bir enerji türüdür, doğrusal yolla yayılır. Opak cisimlerin arkasında gölge oluşur. Ses titreşim sonucu oluşur, yayılması için maddesel ortam gerekir. Ses boşlukta yayılmaz. Yankı sesin engele çarpıp geri dönmesidir.',
    rule: 'Işık: Doğrusal yayılır, ışık sesten hızlıdır.\nGölge: Işık kaynağı cisme yaklaşırsa gölge büyür.\nSes: Katıda en hızlı, boşlukta yayılmaz.',
    formulas: [],
    keyPoints: [
      'Saydam: Işığı geçirir (cam)',
      'Yarı saydam: Kısmen geçirir (yağlı kağıt)',
      'Opak: Işığı geçirmez, gölge oluşur',
      'Güneş tepedeyken gölge en kısa',
      'Yumuşak/gözenekli maddeler sesi soğurur',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Neden gök gürültüsünü şimşek çaktıktan sonra duyarız?',
      steps: [
        'Işığın hızı sesin hızından çok daha fazladır',
        'Işık bize hemen ulaşır, ses arkadan gelir',
      ],
      answer: 'Işık sesten hızlıdır',
    ),
    SolvedExample(
      question: 'Cisim ışık kaynağına yaklaştırılırsa gölge boyu ne olur?',
      steps: [
        'Cisim kaynağa yaklaşırsa ışık daha geniş açıyla gelir',
        'Engellenen alan artar',
      ],
      answer: 'Gölge büyür',
    ),
    SolvedExample(
      question: 'Uzaydaki patlamaların sesini neden Dünya\'dan duyamayız?',
      steps: [
        'Uzay boşluktur (hava yoktur)',
        'Sesin yayılması için maddesel ortam gerekir',
      ],
      answer: 'Ses boşlukta yayılmaz',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Işık nasıl yayılır?', options: ['Eğrisel', 'Doğrusal', 'Dalgalı', 'Zikzak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi doğal ışık kaynağıdır?', options: ['Ampul', 'Güneş', 'Mum', 'El feneri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işığı geçirmeyen maddelere ne denir?', options: ['Saydam', 'Yarı saydam', 'Opak', 'Parlak'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Ses en hızlı hangi ortamda yayılır?', options: ['Gaz', 'Sıvı', 'Katı', 'Boşluk'], correctIndex: 2, explanation: 'Katıda tanecikler çok yakındır', difficulty: 1),
    StemQuestion(question: 'Güneş tutulmasında Ay ne gibi davranır?', options: ['Işık kaynağı', 'Saydam madde', 'Opak madde', 'Ayna'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Sesin yüzeye çarpıp geri dönmesine ne denir?', options: ['Soğurulma', 'Yankı', 'Yalıtım', 'Kırılma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi yarı saydam maddedir?', options: ['Tahta', 'Cam', 'Yağlı kağıt', 'Demir'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Ses yalıtımı için hangisi kullanılır?', options: ['Demir levha', 'Strafor köpük', 'Cam', 'Mermer'], correctIndex: 1, explanation: 'Boşluklu yapısı sesi soğurur', difficulty: 2),
    StemQuestion(question: 'Sabah/akşam gölgemiz neden uzundur?', options: ['Güneş dik geldiği için', 'Güneş eğik geldiği için', 'Hava soğuk olduğu için', 'Güneş yakın olduğu için'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Ay bir ışık kaynağı mıdır?', options: ['Evet, doğal', 'Evet, yapay', 'Hayır, Güneş ışığını yansıtır', 'Bazen'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Işık nasıl yayılır?', options: ['Eğrisel', 'Doğrusal', 'Dalgalı', 'Zikzak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Doğal ışık kaynağı?', options: ['Ampul', 'Güneş', 'Mum', 'El feneri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Opak ne demek?', options: ['Işık geçirir', 'Kısmen geçirir', 'Geçirmez', 'Parlak'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Ses en hızlı nerede?', options: ['Gaz', 'Sıvı', 'Katı', 'Boşluk'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Sesin geri dönmesi?', options: ['Soğurulma', 'Yankı', 'Yalıtım', 'Kırılma'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Düzgün yüzeyde (ayna) ışık nasıl yansır?', options: ['Dağınık', 'Düzgün yansıma', 'Kırılarak', 'Yansımaz'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Tam gölge oluşması için ne gerekli?', options: ['Işık kaynağı ve Saydam cisim', 'Işık kaynağı ve Opak cisim', 'Sadece Işık', 'Sadece Opak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sesin şiddetini değiştirmek için ne yaparız?', options: ['İnce tel kullanırız', 'Sesin enerjisini artırırız', 'Ortamı değiştiririz', 'Kaynağı uzaklaştırırız'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Hangisinde ses yayılmaz?', options: ['Okyanusun dibi', 'Uzay boşluğu', 'Çelik kasa', 'Orman'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sert pürüzsüz yüzeylerde ses nasıl davranır?', options: ['Soğurulur', 'İyi yansır', 'Yayılmaz', 'Olduğu yerde kalır'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Sinema duvarlarının kumaşla kaplanma sebebi?', options: ['Sesi yansıtmak', 'Yankıyı önlemek', 'İçeriyi ısıtmak', 'Görsellik'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Çubuğun suda kırık görünmesinin sebebi?', options: ['Işığın yansıması', 'Işığın kırılması', 'Işığın soğurulması', 'Kaldırma kuvveti'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Işık kirliliği neye sebep olur?', options: ['Gökyüzü gözlemlerinin zorlaşması', 'Daha iyi görmemize', 'Enerji tasarrufuna', 'Güneşin daha parlak olması'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Öğle vakti gölge boyu nasıldır?', options: ['En uzun', 'En kısa', 'Yoktur', 'Akşamki ile aynı'], correctIndex: 1, explanation: 'Işık dik geldikçe gölge kısalır', difficulty: 1),
    StemQuestion(question: 'Sesin oluşması için temel şart?', options: ['Titreşim', 'Elektrik', 'Isı', 'Işık'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangisi yapay ışık kaynağıdır?', options: ['Ateş böceği', 'Güneş', 'Yıldızlar', 'Trafik lambası'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Karagöz-Hacivat ışığın hangi özelliğinden yararlanır?', options: ['Işığın kırılması', 'Opak maddelerin gölge oluşturması', 'Işığın yansıması', 'Renklere ayrılması'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Yumuşak gözenekli maddeler sesi ne yapar?', options: ['Yansıtır', 'Soğurur', 'Güçlendirir', 'Hızlandırır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işık ışınları nasıl gösterilir?', options: ['Dalgalı çizgiler', 'Daireler', 'Doğrusal çizgiler ve oklar', 'Noktalar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Ses kirliliğinin insan üzerindeki etkisi?', options: ['İşitme kaybı ve stres', 'Mutluluk', 'Daha iyi duyma', 'Hızlı düşünme'], correctIndex: 0, difficulty: 1),
  ],
  formulaCards: const [
    'Işık doğrusal yayılır, sesten hızlıdır',
    'Opak cisim → gölge oluşur',
    'Ses: Katıda en hızlı, boşlukta yayılmaz',
    'Yankı: Sesin engele çarpıp geri dönmesi',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 5: ELEKTRİK
// ═══════════════════════════════════════════════════════════════

final _s5FenU5Content = StemUnitContent(
  unitId: 's5_fen_u5',
  topic: const TopicContent(
    summary: 'Basit elektrik devresi: Pil (güç), Kablo (iletim), Anahtar (kontrol), Ampul (tüketim). İletken elektriği geçirir (metaller, tuzlu su), yalıtkan geçirmez (plastik, cam, saf su).',
    rule: 'Seri Bağlantı: Tek hat, biri patlarsa hepsi söner, ampuller sönük yanar.\nParalel Bağlantı: Farklı kollar, biri patlarsa diğerleri yanar, ampuller parlak yanar.',
    formulas: [
      'Seri: Pil ömrü uzun, parlaklık az',
      'Paralel: Pil ömrü kısa, parlaklık çok',
      'Pil sembolü: Uzun çizgi +, kısa çizgi -',
    ],
    keyPoints: [
      'Anahtar açık = devre kesik = ampul yanmaz',
      'Anahtar kapalı = devre tamam = ampul yanar',
      'Evdeki lambalar paralel bağlıdır',
      'İnsan vücudu iletkendir (su ve mineraller)',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Devrede anahtar "açık" ise ampul yanar mı?',
      steps: [
        'Anahtarın açık olması devrenin kesik olması demektir',
        'Akım geçemez',
      ],
      answer: 'Yanmaz (Yanması için anahtarın kapalı olması gerekir)',
    ),
    SolvedExample(
      question: 'Tornavidanın sapı neden plastiktir?',
      steps: [
        'Plastik yalıtkandır',
        'Elektrik çarpmasını önler',
      ],
      answer: 'Yalıtkan olduğu için güvenliği sağlar',
    ),
    SolvedExample(
      question: '2 ampullü seri devrede biri çıkarılırsa diğeri ne olur?',
      steps: [
        'Seri devrede akımın geçeceği tek yol vardır',
        'Yol kesilirse akım durur',
      ],
      answer: 'Diğer ampul de söner',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Devreye enerji sağlayan eleman?', options: ['Ampul', 'Anahtar', 'Pil', 'Kablo'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi iletken maddedir?', options: ['Plastik', 'Gümüş', 'Cam', 'Kumaş'], correctIndex: 1, explanation: 'Metaller iletkendir', difficulty: 1),
    StemQuestion(question: 'Devreyi açıp kapamaya yarayan eleman?', options: ['Duy', 'Pil Yatağı', 'Anahtar', 'Kablo'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi yalıtkan maddedir?', options: ['Bakır tel', 'Demir çivi', 'Alüminyum folyo', 'Porselen fincan'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Evdeki lambalar nasıl bağlanmıştır?', options: ['Seri', 'Paralel', 'Karışık', 'Bağlantısız'], correctIndex: 1, explanation: 'Biri patlayınca diğerleri sönmesin diye', difficulty: 1),
    StemQuestion(question: 'Seri devrede ampul parlaklığını artırmak için?', options: ['Pil sayısı artırılır', 'Ampul sayısı artırılır', 'Kablo uzatılır', 'Anahtar açılır'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Tuzlu su iletken midir?', options: ['Evet', 'Hayır', 'Bazen', 'Az yalıtkan'], correctIndex: 0, explanation: 'İçindeki iyonlar sayesinde iletir', difficulty: 1),
    StemQuestion(question: '+ kutuptan çıkan akım hangi kutba gider?', options: ['+ kutba', '- kutba', 'Ampule gidip biter', 'Anahtara gidip durur'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Seri bağlı ampul sayısı artarsa parlaklık?', options: ['Artar', 'Değişmez', 'Azalır', 'Patlar'], correctIndex: 2, explanation: 'Enerji paylaşılır', difficulty: 2),
    StemQuestion(question: 'Elektrik çarpmış birine hangisiyle dokunulmaz?', options: ['Kuru tahta sopa', 'Plastik boru', 'Demir çubuk', 'Lastik eldiven'], correctIndex: 2, explanation: 'Demir iletkendir', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Devreye enerji veren?', options: ['Ampul', 'Anahtar', 'Pil', 'Kablo'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'İletken madde?', options: ['Plastik', 'Gümüş', 'Cam', 'Kumaş'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Evdeki lambalar?', options: ['Seri', 'Paralel', 'Karışık', 'Yok'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yalıtkan madde?', options: ['Bakır', 'Demir', 'Alüminyum', 'Porselen'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Tuzlu su iletken mi?', options: ['Evet', 'Hayır', 'Bazen', 'Bilinemez'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Ampul sembolü hangisidir?', options: ['Yuvarlak içinde X', 'İki paralel çizgi', 'Düz çizgi', 'İçi boş yuvarlak'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Paralel bağlının en büyük avantajı?', options: ['Pili az harcaması', 'Ampullerin bağımsız çalışması', 'Kablo tasarrufu', 'Daha az ışık'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Ampul yanmıyorsa sebebi ne olamaz?', options: ['Pil bitmiştir', 'Kablo kopuktur', 'Anahtar kapalıdır', 'Ampul patlaktır'], correctIndex: 2, explanation: 'Anahtar kapalı = devre çalışıyor demek', difficulty: 2),
    StemQuestion(question: 'İletken tellerin dışı neden plastik kaplı?', options: ['Paslanmasın diye', 'Güzel görünsün diye', 'Yalıtım ve can güvenliği için', 'Daha hızlı iletsin diye'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Saf suya ne atarsak iletken olur?', options: ['Şeker', 'Tuz', 'Alkol', 'Zeytinyağı'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'I.Bakır II.Altın III.Plastik IV.Gümüş - Hangileri iletken?', options: ['I ve II', 'I, II ve IV', 'Yalnız III', 'Hepsi'], correctIndex: 1, explanation: 'Plastik hariç hepsi metal', difficulty: 2),
    StemQuestion(question: 'Duy ne işe yarar?', options: ['Pili tutar', 'Ampulün takıldığı yuvadır', 'Kabloyu tutar', 'Akım üretir'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Seri devrede ampul artarsa: I.Parlaklık azalır II.Pil uzun dayanır', options: ['I Doğru, II Yanlış', 'I Yanlış, II Doğru', 'Her ikisi Doğru', 'Her ikisi Yanlış'], correctIndex: 2, explanation: 'Direnç artar, akım azalır', difficulty: 3),
    StemQuestion(question: 'İnsan vücudu elektriği iletir mi?', options: ['Hayır, yalıtkan', 'Evet, iletken', 'Sadece eller', 'Sadece ayaklar'], correctIndex: 1, explanation: 'Su ve mineraller nedeniyle', difficulty: 1),
    StemQuestion(question: 'Pil sembolünde uzun çizgi neyi ifade eder?', options: ['Negatif kutup', 'Pozitif kutup', 'Anahtar', 'Kablo'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Elektrik enerjisini ışığa çeviren?', options: ['Pil', 'Anahtar', 'Ampul', 'Kablo'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Yıldırımda arabanın içinin güvenli olma sebebi?', options: ['Tekerlekler yalıtkan, kaporta elektriği dıştan iletir', 'Camlar var', 'Motor çalışıyor', 'Koltuklar yumuşak'], correctIndex: 0, difficulty: 3),
    StemQuestion(question: 'Devrede direnç oluşturan eleman?', options: ['Kablo kalınlığı', 'Ampul', 'Pil', 'Anahtar'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Paralel bağlı özdeş ampullerin parlaklığı?', options: ['Hepsi farklı', 'Kaynağa yakın parlak', 'Hepsi eşit', 'Kaynağa uzak parlak'], correctIndex: 2, explanation: 'Paralel kollarda voltaj eşit', difficulty: 2),
    StemQuestion(question: '3 pil seri bağlanırsa ne olur?', options: ['Voltaj artar, ampul parlak yanar', 'Voltaj azalır', 'Ampul söner', 'Pil ömrü artar'], correctIndex: 0, explanation: '1.5V+1.5V+1.5V=4.5V', difficulty: 2),
  ],
  formulaCards: const [
    'Devre: Pil + Kablo + Anahtar + Ampul',
    'Seri: Tek hat, biri söner hepsi söner',
    'Paralel: Ayrı kollar, bağımsız çalışır',
    'İletken: Metaller, tuzlu su | Yalıtkan: Plastik, cam',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FEN ÜNİTE 6: İNSAN VE ÇEVRE
// ═══════════════════════════════════════════════════════════════

final _s5FenU6Content = StemUnitContent(
  unitId: 's5_fen_u6',
  topic: const TopicContent(
    summary: 'Nüfus artışı, sanayileşme ve bilinçsizlik çevre sorunlarına yol açar. Deprem, sel, heyelan gibi doğa olayları yıkıcıdır. Biyolojik çeşitlilik bir bölgedeki tür zenginliğidir. Geri dönüşüm doğal kaynakları korur.',
    rule: 'Geri dönüşüm: Kağıt, plastik, cam, metal tekrar işlenir.\nErozyon: Toprağın rüzgar/su ile taşınması → Çözüm: Ağaçlandırma.\nSera etkisi: CO₂ artışı → Küresel ısınma.',
    formulas: [],
    keyPoints: [
      'Deprem: Çök-Kapan-Tutun',
      'Erozyon ≠ Heyelan (yavaş aşınma vs ani kayma)',
      'Yenilenebilir enerji: Güneş, rüzgar, su',
      'Piller atık toplama kutusuna atılmalı',
      'Karbon ayak izi: Doğaya verilen zarar ölçüsü',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kullanılmış kızartma yağlarını lavaboya dökmek neden zararlıdır?',
      steps: [
        '1 litre atık yağ 1 milyon litre temiz suyu kirletir',
        'Su canlılarına zarar verir, boruları tıkar',
      ],
      answer: 'Su kirliliğine neden olur. Atık yağ toplama kutularına atılmalı',
    ),
    SolvedExample(
      question: 'Erozyonu önlemek için en etkili yöntem nedir?',
      steps: [
        'Ağaç kökleri toprağı tutar',
        'Rüzgar ve suyun toprağı taşımasını engeller',
      ],
      answer: 'Ağaçlandırma yapmak',
    ),
    SolvedExample(
      question: 'Nesli tükenmekte olan Caretta Carettalar için ne yapılmalı?',
      steps: [
        'Üreme alanları (plajlar) koruma altına alınmalı',
        'Işık kirliliği önlenmeli',
      ],
      answer: 'Koruma alanları oluşturmak',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Hangisi çevre kirliliğine neden olmaz?', options: ['Fabrika bacaları', 'Egzoz gazları', 'Güneş enerjisi kullanımı', 'Plastik atıklar'], correctIndex: 2, explanation: 'Temiz enerjidir', difficulty: 1),
    StemQuestion(question: 'Atıkların tekrar kullanıma kazandırılmasına ne denir?', options: ['Yakma', 'Gömme', 'Geri Dönüşüm', 'Depolama'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi yıkıcı doğa olayıdır?', options: ['Yağmur', 'Kar', 'Deprem', 'Rüzgar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Toprağın su/rüzgar etkisiyle taşınmasına ne denir?', options: ['Deprem', 'Erozyon', 'Heyelan', 'Çığ'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisinin geri dönüşümü yoktur?', options: ['Cam şişe', 'Gazete', 'Meyve kabuğu', 'Metal kutu'], correctIndex: 2, explanation: 'Organik atıktır, çürür gübre olur', difficulty: 2),
    StemQuestion(question: 'Biyolojik çeşitliliği en çok tehdit eden faktör?', options: ['Doğal afetler', 'İnsan faaliyetleri', 'Mevsimler', 'Hayvan göçü'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nesli tükenmekte olan ve koruma altındaki hayvan?', options: ['Kedi', 'Akdeniz Foku', 'Serçe', 'İnek'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sera etkisi ve küresel ısınmaya neden olan gaz?', options: ['Oksijen', 'Karbondioksit', 'Azot', 'Hidrojen'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Heyelan en çok hangi bölgemizde görülür?', options: ['Eğimli, çok yağışlı (Karadeniz)', 'Düz, kurak (İç Anadolu)', 'Kumsal (Ege)', 'Karlı (Doğu Anadolu)'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Doğal anıt nedir?', options: ['İnsan yapımı heykeller', 'Doğada kendiliğinden oluşmuş yapılar', 'Tarihi binalar', 'Müzeler'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Çevre kirliliği yapmayan?', options: ['Fabrika', 'Egzoz', 'Güneş enerjisi', 'Plastik'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Atıkların tekrar kullanımı?', options: ['Yakma', 'Gömme', 'Geri Dönüşüm', 'Depolama'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Yıkıcı doğa olayı?', options: ['Yağmur', 'Kar', 'Deprem', 'Rüzgar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Toprak taşınması?', options: ['Deprem', 'Erozyon', 'Heyelan', 'Çığ'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sera gazı?', options: ['Oksijen', 'Karbondioksit', 'Azot', 'Hidrojen'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Deprem sırasında en doğru hareket?', options: ['Merdivenlere koşmak', 'Balkona çıkmak', 'Çök-Kapan-Tutun', 'Asansöre binmek'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Biyoçeşitliliği olumlu etkileyen?', options: ['Milli park sayısının artırılması', 'Ormanların tarıma çevrilmesi', 'Aşırı avlanma', 'Sanayileşme'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Geri dönüşümün en önemli faydası?', options: ['Çöplerin güzel kokması', 'Doğal kaynakların korunması ve enerji tasarrufu', 'İşçilere iş çıkması', 'Fabrikaların çalışması'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Asit yağmurlarının temel sebebi?', options: ['Ağaçların çok olması', 'Hava kirliliği (fabrika ve araç gazları)', 'Suyun buharlaşması', 'Toprak kirliliği'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Erozyon ile Heyelan farkı?', options: ['Erozyon yavaş aşınma, Heyelan ani kayma', 'İkisi aynıdır', 'Erozyon kışın, heyelan yazın', 'Erozyon önlenemez'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Nesli tamamen tükenmiş canlı?', options: ['Panda', 'Mamut', 'Kelaynak', 'Yunus'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Su kirliliğini önlemek için alınacak tedbir?', options: ['Atıkları nehirlere vermek', 'Aşırı gübre kullanmak', 'Arıtma tesisleri kurmak', 'Çöpleri denize dökmek'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Ülkemizdeki volkanlar aktif midir?', options: ['Evet, her yıl olur', 'Hayır, sönmüştür', 'Sadece yazın', 'Sadece Ege\'de'], correctIndex: 1, explanation: 'Ağrı, Erciyes gibi dağlar sönmüş volkanlardır', difficulty: 2),
    StemQuestion(question: 'Karbon Ayak İzini küçültmek ne demektir?', options: ['Büyük ayakkabı giymek', 'Doğaya verilen zararı azaltmak', 'Kömür madeninde çalışmak', 'Çok araba kullanmak'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Biyoçeşitlilik neden önemlidir?', options: ['Sadece güzel göründüğü için', 'Tarım, tıp ve ekosistem dengesi için', 'Turistler geldiği için', 'Önemsizdir'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Pillerin çöpe atılması neden tehlikeli?', options: ['Çöp kutusunu deler', 'Ağır metaller toprağa ve suya karışır', 'Patlama riski', 'Geri dönüşümü yoktur'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Orman yangını sonucu hangisi beklenmez?', options: ['Biyoçeşitliliğin azalması', 'Oksijen üretiminin artması', 'Erozyonun artması', 'Canlıların evsiz kalması'], correctIndex: 1, explanation: 'Ağaçlar yanarsa oksijen üretimi azalır', difficulty: 2),
    StemQuestion(question: 'Çığdan korunmak için yamaçlarda ne yapılmalı?', options: ['Bağırmak', 'Ağaçlandırma ve set kurma', 'Ev yapmak', 'Yol yapmak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi yenilenebilir enerji kaynağıdır?', options: ['Kömür', 'Petrol', 'Rüzgar', 'Doğalgaz'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Çevre eğitimi neden önemlidir?', options: ['Sınavları geçmek için', 'Çevre bilinci ve sürdürülebilir yaşam için', 'Okulların açık kalması için', 'Kitap okumak için'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'Geri dönüşüm: Kağıt, cam, plastik, metal',
    'Erozyon → Ağaçlandırma ile önlenir',
    'Sera gazı (CO₂) → Küresel ısınma',
    'Deprem: Çök-Kapan-Tutun',
    'Yenilenebilir: Güneş, rüzgar, su enerjisi',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// 8. SINIF (LGS) MATEMATİK İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 1: ÇARPANLAR, KATLAR VE ÜSLÜ İFADELER
// ═══════════════════════════════════════════════════════════════

final _s8MatU1Content = StemUnitContent(
  unitId: 's8_mat_u1',
  topic: const TopicContent(
    summary: 'EBOB iki veya daha fazla sayıyı aynı anda bölebilen en büyük sayıdır (bütünden parçaya). EKOK iki veya daha fazla sayının katı olan en küçük sayıdır (parçadan bütüne). Üslü ifadelerde aynı tabanlı çarpma/bölme üsleri toplar/çıkarır.',
    rule: 'EBOB: Ortak asal çarpanların en küçük kuvvetlerinin çarpımı\nEKOK: Tüm asal çarpanların en büyük kuvvetlerinin çarpımı\nÜslü: a^x · a^y = a^(x+y), a^x / a^y = a^(x-y), (a^x)^y = a^(x·y)',
    formulas: [
      'EBOB × EKOK = A × B (iki sayı için)',
      'a^0 = 1 (a ≠ 0)',
      'a^(-n) = 1/a^n',
      'Bilimsel gösterim: a × 10^n (1 ≤ |a| < 10)',
    ],
    keyPoints: [
      'Aralarında asal → EBOB = 1',
      'EBOB "bütünden parçaya" (paketleme, parselleme)',
      'EKOK "parçadan bütüne" (zil çalma, nöbet)',
      'Tabanlar aynı → üsler toplanır/çıkarılır',
      'Üsler aynı → tabanlar çarpılır/bölünür',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '48 kg ve 60 kg pirinç eşit poşetlere doldurulacak. En az kaç poşet gerekir?',
      steps: ['EBOB(48,60) bulunur', '48=2⁴·3, 60=2²·3·5', 'EBOB=2²·3=12', 'Poşet: 48/12 + 60/12 = 4+5 = 9'],
      answer: '9 poşet',
    ),
    SolvedExample(
      question: '(2⁸ · 4³) / 8⁴ işleminin sonucu kaçtır?',
      steps: ['4³=(2²)³=2⁶, 8⁴=(2³)⁴=2¹²', 'Pay: 2⁸·2⁶=2¹⁴', 'Bölme: 2¹⁴/2¹²=2²'],
      answer: '4',
    ),
    SolvedExample(
      question: 'Alarmlar 30 dk ve 45 dk arayla çalıyor. 08:00\'de birlikte çaldıktan sonra ikinci kez ne zaman?',
      steps: ['EKOK(30,45) bulunur', '30=2·3·5, 45=3²·5', 'EKOK=2·3²·5=90 dakika', '90 dk = 1 saat 30 dk'],
      answer: '09:30',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '72 sayısının asal çarpanlarından hangisi değildir?', options: ['2', '3', '4', 'Hepsi asaldır'], correctIndex: 2, explanation: '4 asal değildir, 2²dir', difficulty: 1),
    StemQuestion(question: '3⁴ ifadesinin değeri kaçtır?', options: ['12', '64', '81', '243'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'EBOB(20, 30) kaçtır?', options: ['5', '10', '15', '60'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'EKOK(12, 18) kaçtır?', options: ['24', '36', '48', '72'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '5⁻² ifadesinin eşiti nedir?', options: ['-10', '-25', '1/10', '1/25'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Hangisi bilimsel gösterimdir?', options: ['12·10⁵', '0,5·10⁻³', '3,4·10⁸', '10·10²'], correctIndex: 2, explanation: 'Katsayı 1-10 arası olmalı', difficulty: 1),
    StemQuestion(question: '2ˣ = 32 ise x kaçtır?', options: ['4', '5', '6', '8'], correctIndex: 1, explanation: '2⁵=32', difficulty: 1),
    StemQuestion(question: '45 sayısının kaç pozitif tam sayı çarpanı vardır?', options: ['4', '5', '6', '8'], correctIndex: 2, explanation: '1,3,5,9,15,45 → 6 tane', difficulty: 2),
    StemQuestion(question: 'Aralarında asal iki sayının EBOB\'u kaçtır?', options: ['0', '1', 'Çarpımları', 'Toplamları'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(-2)³ ifadesinin sonucu kaçtır?', options: ['8', '6', '-6', '-8'], correctIndex: 3, explanation: 'Tek kuvvet negatif yapar', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '3⁴ = ?', options: ['12', '64', '81', '243'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'EBOB(20,30)?', options: ['5', '10', '15', '60'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '2⁵ = ?', options: ['16', '32', '64', '128'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(-2)³ = ?', options: ['8', '6', '-6', '-8'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'EKOK(12,18)?', options: ['24', '36', '48', '72'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: '120cm ve 150cm kalası en büyük eşit parçalara ayrılıyor. Her kesim 10sn sürerse toplam kaç sn?', options: ['70', '80', '90', '100'], correctIndex: 0, explanation: 'EBOB=30. 4+5=9 parça, 3+4=7 kesim. 7×10=70', difficulty: 3),
    StemQuestion(question: 'Aralarında asal A,B için EKOK=60, A·B=60. A=12,B=5 ise A-B?', options: ['7', '8', '9', '10'], correctIndex: 0, difficulty: 3),
    StemQuestion(question: 'Başlangıçta 16 bakteri, her saat 2 katına çıkıyor. 10. saatte kaç bakteri?', options: ['2¹²', '2¹³', '2¹⁴', '2¹⁶'], correctIndex: 2, explanation: '2⁴·2¹⁰=2¹⁴', difficulty: 2),
    StemQuestion(question: 'Kenarı 4⁴cm kare 16 eş kareye ayrılıyor. Küçük karenin çevresi?', options: ['2⁶', '2⁸', '2¹⁰', '2¹²'], correctIndex: 1, explanation: 'Kenar 2⁸/4=2⁶, çevre 4·2⁶=2⁸', difficulty: 3),
    StemQuestion(question: 'A=2³·3²·5, B=2²·3³·7 ise EKOK/EBOB?', options: ['210', '420', '630', '840'], correctIndex: 0, explanation: 'Ortak olmayanların çarpımı: 2·3·5·7=210', difficulty: 3),
    StemQuestion(question: '149.600.000 km metre cinsinden bilimsel gösterimi?', options: ['1,496·10⁸', '1,496·10¹¹', '1,496·10¹⁰', '14,96·10¹⁰'], correctIndex: 1, explanation: 'km→m için 10³ ile çarp', difficulty: 2),
    StemQuestion(question: 'Merdiven basamakları 3er çıkınca 2, 4er çıkınca 2 artıyor. 50den fazla ise en az kaç basamak?', options: ['52', '58', '62', '74'], correctIndex: 2, explanation: 'EKOK(3,4)=12. 12k+2. k=5→62', difficulty: 3),
    StemQuestion(question: '-3<x<4, -2<y<3 (tam sayı). x^y en büyük değeri?', options: ['9', '16', '27', '81'], correctIndex: 0, explanation: 'y en fazla 2. x=3,y=2→3²=9', difficulty: 3),
    StemQuestion(question: 'Kenarı 27⁴m eşkenar üçgen, 9 tur koşuluyor. Toplam mesafe?', options: ['3¹³', '3¹⁴', '3¹⁵', '3¹⁶'], correctIndex: 2, explanation: 'Çevre=3·3¹²=3¹³. 9tur=3². 3¹³·3²=3¹⁵', difficulty: 3),
    StemQuestion(question: 'Alanı 72cm² dikdörtgenin tam sayı kenarları varsa çevresi hangisi olamaz?', options: ['34', '36', '44', '56'], correctIndex: 3, explanation: 'Olası çevreler: 146,76,54,44,36,34. 56 yok', difficulty: 2),
    StemQuestion(question: '(0,25)⁴·(0,5)⁻⁶ sonucu?', options: ['2⁻⁴', '2⁻²', '4', '16'], correctIndex: 1, explanation: '(2⁻²)⁴·(2⁻¹)⁻⁶=2⁻⁸·2⁶=2⁻²', difficulty: 3),
    StemQuestion(question: 'Yarıçapı 40cm tekerlek 1,2·10⁴cm yolda kaç tam tur? (π=3)', options: ['50', '100', '200', '500'], correctIndex: 0, explanation: 'Çevre=2·3·40=240. 12000/240=50', difficulty: 2),
    StemQuestion(question: '8¹⁰ sayısının yarısı?', options: ['4¹⁰', '8⁵', '2²⁹', '2¹⁹'], correctIndex: 2, explanation: '2³⁰/2=2²⁹', difficulty: 2),
    StemQuestion(question: 'Aralarında asal iki sayının çarpımı 120. Toplamları?', options: ['22', '23', '24', '26'], correctIndex: 1, explanation: '8×15=120, aralarında asal, toplam 23', difficulty: 3),
    StemQuestion(question: '120lt zeytinyağı ve 144lt ayçiçek yağı eşit şişelere. Şişe 2TL ise en az kaç TL?', options: ['18', '20', '22', '24'], correctIndex: 2, explanation: 'EBOB=24. 5+6=11 şişe. 11×2=22', difficulty: 2),
  ],
  formulaCards: const [
    'EBOB: Ortak asal çarpanların küçük kuvvetleri',
    'EKOK: Tüm asal çarpanların büyük kuvvetleri',
    'a^x · a^y = a^(x+y), a^x / a^y = a^(x-y)',
    '(a^x)^y = a^(x·y), a^0 = 1',
    'Bilimsel gösterim: a × 10^n (1 ≤ a < 10)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 2: KAREKÖKLÜ İFADELER VE VERİ ANALİZİ
// ═══════════════════════════════════════════════════════════════

final _s8MatU2Content = StemUnitContent(
  unitId: 's8_mat_u2',
  topic: const TopicContent(
    summary: 'Tam kare sayılar kök dışına çıkabilen sayılardır. √(a²)=|a|. Kök içleri aynı olanların katsayıları toplanır/çıkarılır. a√b gösteriminde a içeri girerken karesi alınır.',
    rule: '√a · √b = √(a·b)\nx√a + y√a = (x+y)√a\na√b = √(a²·b)\nRasyonel: Kökten tamamen çıkar. İrrasyonel: Çıkamaz (√3, π)',
    formulas: [
      '√a · √b = √(a·b)',
      'a√b = √(a²·b)',
      'Açıklık = En büyük - En küçük',
    ],
    keyPoints: [
      'Tam kareler: 1, 4, 9, 16, 25, 36, 49, 64, 81, 100',
      'Toplama/Çıkarma: Kök içleri aynı olmalı',
      'İrrasyonel: √2, √3, √5, π',
      'Daire grafiği: Toplam 360°',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '√75 + √12 - √27 = ?',
      steps: ['√75=5√3, √12=2√3, √27=3√3', '5√3 + 2√3 - 3√3 = 4√3'],
      answer: '4√3',
    ),
    SolvedExample(
      question: '√45 hangi iki tam sayı arasındadır?',
      steps: ['√36=6, √49=7', '36<45<49 → 6 ile 7 arası', '45-36=9, 49-45=4 → 7ye daha yakın'],
      answer: '6 ile 7 arasında, 7ye daha yakın',
    ),
    SolvedExample(
      question: '72 kişilik sınıfta 18 futbol, 36 basketbol, kalanı voleybol. Voleybola ait merkez açı?',
      steps: ['Voleybol: 72-54=18 kişi', '72→360°, 18→x°', 'x=360/4=90°'],
      answer: '90°',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Hangisi tam kare değildir?', options: ['1', '144', '196', '200'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: '√289 = ?', options: ['13', '15', '17', '19'], correctIndex: 2, explanation: '17×17=289', difficulty: 1),
    StemQuestion(question: '√20 neye eşittir?', options: ['2√10', '2√5', '4√5', '5√2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi irrasyoneldir?', options: ['√16', '√1,44', 'π', '0,333...'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '√18 · √2 = ?', options: ['6', '6√2', '9', '36'], correctIndex: 0, explanation: '√36=6', difficulty: 1),
    StemQuestion(question: 'Alanı 81cm² olan karenin kenarı?', options: ['8', '9', '18', '20,25'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '√0,04 = ?', options: ['0,02', '0,2', '0,4', '2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'En büyük ile en küçük değer farkına ne denir?', options: ['Mod', 'Medyan', 'Açıklık', 'Ortalama'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '3√2 içeri nasıl girer?', options: ['√6', '√12', '√18', '√24'], correctIndex: 2, explanation: '3²·2=18', difficulty: 1),
    StemQuestion(question: '√(100+44) = ?', options: ['12', '14', '16', '18'], correctIndex: 0, explanation: '√144=12', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '√289 = ?', options: ['13', '15', '17', '19'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '√20 = ?', options: ['2√10', '2√5', '4√5', '5√2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '√18·√2 = ?', options: ['6', '6√2', '9', '36'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '3√2 = √?', options: ['6', '12', '18', '24'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '√144 = ?', options: ['12', '14', '16', '18'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Alanı 200m² kare bahçeye 2 sıra tel çekilecek. Kaç metre tel? (√2≈1,4)', options: ['84', '112', '120', '160'], correctIndex: 1, explanation: 'Kenar=10√2. Çevre=40√2. 2sıra=80√2≈112', difficulty: 3),
    StemQuestion(question: '√720=a√b, b en küçük ise a+b?', options: ['12', '15', '17', '24'], correctIndex: 2, explanation: '720=144·5. 12√5. a=12,b=5. 17', difficulty: 2),
    StemQuestion(question: 'Kenarı 4√3cm eşkenar üçgenin çevresi = karenin çevresi. Karenin alanı?', options: ['24', '27', '36', '48'], correctIndex: 1, explanation: 'Çevre=12√3. Kare kenarı=3√3. Alan=27', difficulty: 3),
    StemQuestion(question: '√3·(√12+√27) = ?', options: ['9', '12', '15', '18'], correctIndex: 2, explanation: '√3·5√3=5·3=15', difficulty: 2),
    StemQuestion(question: '√55 hangi tam sayılar arasında?', options: ['6-7', '7-8', '8-9', '9-10'], correctIndex: 1, explanation: '√49<√55<√64', difficulty: 1),
    StemQuestion(question: 'Hangisinin sonucu rasyoneldir?', options: ['√2+√3', '√5·√5', '√8/√4', '√10-√2'], correctIndex: 1, explanation: '√5·√5=5', difficulty: 2),
    StemQuestion(question: 'Daire grafiğinde 120° elma, 90° armut, kalan muz. Toplam 72kg ise kaç kg muz?', options: ['18', '24', '30', '36'], correctIndex: 2, explanation: 'Muz=150°. 150/360·72=30', difficulty: 2),
    StemQuestion(question: '√0,81 + √1,21 - √0,09 = ?', options: ['1,5', '1,7', '1,9', '2,1'], correctIndex: 1, explanation: '0,9+1,1-0,3=1,7', difficulty: 2),
    StemQuestion(question: '√192cm tahta √3cm parçalara ayrılıyor. Kaç kesim yapılır?', options: ['6', '7', '8', '9'], correctIndex: 1, explanation: 'Parça=√64=8. Kesim=7', difficulty: 2),
    StemQuestion(question: 'x=√2,y=√3,z=√5 ise √240 = ?', options: ['x²·y·z', 'x⁴·y·z', 'x³·y²·z', 'x⁴·y·z²'], correctIndex: 1, explanation: '240=2⁴·3·5. (√2)⁴·√3·√5', difficulty: 3),
    StemQuestion(question: 'Araç √8km sonra √32km gitti. Yol √200km ise kalan?', options: ['2√2', '3√2', '4√2', '5√2'], correctIndex: 2, explanation: '2√2+4√2=6√2. 10√2-6√2=4√2', difficulty: 2),
    StemQuestion(question: 'A:10, B:20, C:30 adet. Daire grafiğinde C kaç derece?', options: ['60', '120', '150', '180'], correctIndex: 3, explanation: '30/60·360=180', difficulty: 1),
    StemQuestion(question: '√(21+√(13+√(7+√4))) = ?', options: ['3', '4', '5', '6'], correctIndex: 2, explanation: '√4=2,√9=3,√16=4,√25=5', difficulty: 3),
    StemQuestion(question: 'Kenarları √45 ve √80cm dikdörtgenin alanı?', options: ['30', '40', '50', '60'], correctIndex: 3, explanation: '3√5·4√5=12·5=60', difficulty: 2),
    StemQuestion(question: '40-50 arası tam kare sayı. Karekökünün 2 katı?', options: ['10', '12', '14', '16'], correctIndex: 2, explanation: '49=7². 2·7=14', difficulty: 1),
  ],
  formulaCards: const [
    'Tam kareler: 1,4,9,16,25,36,49,64,81,100',
    '√a·√b = √(a·b), a√b = √(a²·b)',
    'Toplama: Kök içleri aynı olmalı',
    'Daire grafiği: 360° = Toplam',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 3: OLASILIK VE CEBİRSEL İFADELER
// ═══════════════════════════════════════════════════════════════

final _s8MatU3Content = StemUnitContent(
  unitId: 's8_mat_u3',
  topic: const TopicContent(
    summary: 'Olasılık = İstenilen Durum / Tüm Durumlar. Değeri 0-1 arasıdır. Cebirsel ifadelerde özdeşlikler: İki kare farkı, tam kare toplam/fark. Çarpanlara ayırma ortak parantez veya özdeşlik ile yapılır.',
    rule: 'P(A) = İstenilen/Toplam, 0 ≤ P(A) ≤ 1\na²-b² = (a-b)(a+b)\n(a+b)² = a²+2ab+b²\n(a-b)² = a²-2ab+b²',
    formulas: [
      'a²-b² = (a-b)(a+b)',
      '(a+b)² = a²+2ab+b²',
      '(a-b)² = a²-2ab+b²',
    ],
    keyPoints: [
      'Kesin olay: P=1, İmkansız olay: P=0',
      'P(olma) + P(olmama) = 1',
      'Çarpanlara ayırma: Önce ortak çarpan, sonra özdeşlik',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '4 mavi, 5 kırmızı, 3 yeşil top. Kırmızı olmama olasılığı?',
      steps: ['Toplam: 12 top', 'Kırmızı olmayan: 4+3=7', 'P=7/12'],
      answer: '7/12',
    ),
    SolvedExample(
      question: 'Kenarı (2x+3)cm karenin alanı?',
      steps: ['Alan=(2x+3)²', '(2x)²+2·(2x)·3+3²', '4x²+12x+9'],
      answer: '4x²+12x+9 cm²',
    ),
    SolvedExample(
      question: '2023²-2022² = ?',
      steps: ['a²-b²=(a-b)(a+b)', '(2023-2022)(2023+2022)', '1·4045=4045'],
      answer: '4045',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Zarda asal sayı gelme olasılığı?', options: ['1/2', '1/3', '1/6', '2/3'], correctIndex: 0, explanation: 'Asallar: 2,3,5→3/6=1/2', difficulty: 1),
    StemQuestion(question: 'Hangisi özdeşliktir?', options: ['2x+5=15', '3(x-2)=3x-6', 'x²=9', '4x=20'], correctIndex: 1, explanation: 'Her x için doğru', difficulty: 1),
    StemQuestion(question: '(x-4)² açılımı?', options: ['x²-16', 'x²+16', 'x²-4x+16', 'x²-8x+16'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'ANKARA harflerinden A çekme olasılığı?', options: ['1/6', '1/3', '1/2', '2/3'], correctIndex: 2, explanation: '3A/6harf=1/2', difficulty: 1),
    StemQuestion(question: '4x²-25 çarpanlarına ayrılmış hali?', options: ['(2x-5)(2x+5)', '(4x-5)(4x+5)', '(2x-5)²', '(2x-25)(2x+1)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Olasılık değeri hangisi olamaz?', options: ['0', '0,5', '1', '1,2'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: '3x(2x-5) = ?', options: ['6x-15', '6x²-15', '6x²-15x', '5x²-8x'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'İki paranın ikisinin de tura gelme olasılığı?', options: ['1/2', '1/3', '1/4', '3/4'], correctIndex: 2, explanation: 'TT,TY,YT,YY→1/4', difficulty: 1),
    StemQuestion(question: 'x²+10x+25 = ?', options: ['(x+5)(x-5)', '(x+5)²', '(x+10)²', 'x(x+10)+25'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '1-10 arası sayıdan 4ten büyük seçme olasılığı?', options: ['4/10', '5/10', '6/10', '7/10'], correctIndex: 2, explanation: '5,6,7,8,9,10→6/10', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Zarda asal gelme olasılığı?', options: ['1/2', '1/3', '1/6', '2/3'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(x-4)² = ?', options: ['x²-16', 'x²+16', 'x²-4x+16', 'x²-8x+16'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: '4x²-25 = ?', options: ['(2x-5)(2x+5)', '(4x-5)(4x+5)', '(2x-5)²', '(2x-25)(2x+1)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '3x(2x-5) = ?', options: ['6x-15', '6x²-15', '6x²-15x', '5x²-8x'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '2 para atılıyor. İkisi de tura?', options: ['1/2', '1/3', '1/4', '3/4'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Kenarı a olan kareden köşesinden kenarı b olan kare kesilirse kalan alan?', options: ['(a-b)²', 'a²-2ab+b²', '(a-b)(a+b)', 'a²-b'], correctIndex: 2, explanation: 'a²-b²=(a-b)(a+b)', difficulty: 2),
    StemQuestion(question: '24 öğrenci (12K,12E). 4 kız gözlüklü. Gözlüksüz kız olasılığı?', options: ['1/6', '1/4', '1/3', '1/2'], correctIndex: 2, explanation: 'Gözlüksüz kız=8. 8/24=1/3', difficulty: 2),
    StemQuestion(question: '(2x-y)² = ?', options: ['4x²-y²', '4x²+y²', '4x²-2xy+y²', '4x²-4xy+y²'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Alanı x²+6x+9 olan karenin çevresi?', options: ['2(x+3)', '4(x+3)', '4x+9', 'x+3'], correctIndex: 1, explanation: 'Alan=(x+3)². Kenar=x+3. Çevre=4(x+3)', difficulty: 2),
    StemQuestion(question: '1den nye kadar toplar. 10dan küçük gelme olasılığı 3/5 ise n?', options: ['15', '18', '20', '25'], correctIndex: 0, explanation: '9/n=3/5→n=15', difficulty: 2),
    StemQuestion(question: 'Büyük kare x, küçük kare y. Taralı alan 48, x+y=12 ise x-y?', options: ['2', '4', '6', '8'], correctIndex: 1, explanation: '(x-y)(x+y)=48. (x-y)·12=48. x-y=4', difficulty: 3),
    StemQuestion(question: 'x=√5+2, y=√5-2 ise x²-y²?', options: ['4√5', '8√5', '10', '20'], correctIndex: 1, explanation: '(x-y)(x+y)=4·2√5=8√5', difficulty: 3),
    StemQuestion(question: 'Zarda tam kare gelme olasılığı?', options: ['1/6', '1/3', '1/2', '2/3'], correctIndex: 1, explanation: '1 ve 4→2/6=1/3', difficulty: 1),
    StemQuestion(question: '2a²-8 çarpanlarına ayrılırsa kenarlar?', options: ['2 ve (a-2)', '2(a-2) ve (a+2)', '(2a-4) ve (a+2)', '2a ve (a-4)'], correctIndex: 1, explanation: '2(a²-4)=2(a-2)(a+2)', difficulty: 2),
    StemQuestion(question: 'Olayın gerçekleşme olasılığı x ise gerçekleşmeme?', options: ['x-1', '1-x', '1/x', 'x/2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(3x+4)(3x-4)-(3x-2)² en sade hali?', options: ['12x-20', '12x-12', '-12x-20', '6x-16'], correctIndex: 0, explanation: '9x²-16-(9x²-12x+4)=12x-20', difficulty: 3),
    StemQuestion(question: '1-20 arası kartlardan 3ün veya 5in katı gelme olasılığı?', options: ['9/20', '1/2', '11/20', '3/5'], correctIndex: 0, explanation: '3ün katları+5in katları-ortak=6+4-1=9', difficulty: 2),
    StemQuestion(question: 'Kenarı a kareden 4 köşeden kenarı b kareler kesilirse alan?', options: ['(a-2b)(a+2b)', '(a-4b)²', 'a²-4b²', '(a-b)(a+b)'], correctIndex: 0, explanation: 'a²-4b²=(a-2b)(a+2b)', difficulty: 2),
    StemQuestion(question: '25x²-Δx+9 tam kare ise Δ (pozitif)?', options: ['15', '30', '45', '60'], correctIndex: 1, explanation: '2·5x·3=30x', difficulty: 2),
    StemQuestion(question: 'x mavi, x+2 kırmızı bilye. Mavi olasılığı 3/7 ise toplam?', options: ['12', '14', '21', '28'], correctIndex: 1, explanation: 'x/(2x+2)=3/7→x=6. Toplam=14', difficulty: 2),
  ],
  formulaCards: const [
    'P(A) = İstenilen / Toplam (0 ≤ P ≤ 1)',
    'a²-b² = (a-b)(a+b)',
    '(a±b)² = a²±2ab+b²',
    'P(olma) + P(olmama) = 1',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 4: DOĞRUSAL DENKLEMLER VE EŞİTSİZLİKLER
// ═══════════════════════════════════════════════════════════════

final _s8MatU4Content = StemUnitContent(
  unitId: 's8_mat_u4',
  topic: const TopicContent(
    summary: 'Birinci dereceden denklemlerde bilinmeyeni yalnız bırakılır. Koordinat sisteminde noktalar (x,y) ile gösterilir. y=mx+n doğrusunda m eğimdir. Eşitsizliklerde negatifle çarpınca yön değişir.',
    rule: 'y=mx+n: m eğim, n y-kesişim\nEğim = Dikey/Yatay = (y₂-y₁)/(x₂-x₁)\nNegatifle çarpınca eşitsizlik yön değiştirir',
    formulas: [
      'Eğim: m = (y₂-y₁)/(x₂-x₁)',
      'Orijinden geçen: y = mx',
      'Yatay doğru eğimi: 0, Dikey: tanımsız',
    ],
    keyPoints: [
      '1.Bölge(+,+), 2.Bölge(-,+), 3.Bölge(-,-), 4.Bölge(+,-)',
      'Sağa yatık → pozitif eğim, sola yatık → negatif',
      'y=mx+n de m=eğim, x katsayısı',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2x-3y=12 doğrusunun eksenleri kestiği noktalar?',
      steps: ['y=0: 2x=12→x=6. Nokta(6,0)', 'x=0: -3y=12→y=-4. Nokta(0,-4)'],
      answer: '(6,0) ve (0,-4)',
    ),
    SolvedExample(
      question: 'A(2,5) ve B(4,9) noktalarından geçen doğrunun eğimi?',
      steps: ['m=(y₂-y₁)/(x₂-x₁)', 'm=(9-5)/(4-2)=4/2=2'],
      answer: 'Eğim 2',
    ),
    SolvedExample(
      question: '3 katının 5 eksiği, 2 katının 4 fazlasından küçük olan en büyük tam sayı?',
      steps: ['3x-5 < 2x+4', 'x < 9'],
      answer: '8',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '3x+2=17 ise x?', options: ['3', '4', '5', '6'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'A(-3,4) hangi bölgede?', options: ['1.', '2.', '3.', '4.'], correctIndex: 1, explanation: 'x negatif, y pozitif → 2.Bölge', difficulty: 1),
    StemQuestion(question: 'y=2x-6 doğrusunun eğimi?', options: ['-6', '2', '-2', '1/2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Orijinden geçen doğru denklemi?', options: ['y=2x+3', 'x=5', 'y=-3x', 'y=4'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '2x-10≥0 çözüm kümesi?', options: ['x≥5', 'x>5', 'x≤5', 'x<5'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Eğimi %40 rampa, dikey 2m ise yatay kaç m?', options: ['4', '5', '8', '10'], correctIndex: 1, explanation: '2/x=2/5→x=5', difficulty: 2),
    StemQuestion(question: 'x=3 doğrusunun eğimi?', options: ['0', '1', '3', 'Tanımsız'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Taksimetre: 10TL açılış + 5TL/km. 10km kaç TL?', options: ['50', '55', '60', '65'], correctIndex: 2, explanation: '10+5·10=60', difficulty: 1),
    StemQuestion(question: '-2x<8 ise?', options: ['x<-4', 'x>-4', 'x<4', 'x>4'], correctIndex: 1, explanation: 'Negatife bölünce yön değişir', difficulty: 2),
    StemQuestion(question: 'y=3x-1 üzerindeki nokta?', options: ['(1,3)', '(2,5)', '(0,1)', '(3,7)'], correctIndex: 1, explanation: 'x=2: y=6-1=5', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '3x+2=17 → x?', options: ['3', '4', '5', '6'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'A(-3,4) bölgesi?', options: ['1.', '2.', '3.', '4.'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'y=2x-6 eğimi?', options: ['-6', '2', '-2', '1/2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'x=3 eğimi?', options: ['0', '1', '3', 'Tanımsız'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: '-2x<8 → ?', options: ['x<-4', 'x>-4', 'x<4', 'x>4'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Fidan 20cm başlangıç, aylık 5cm. y(boy) x(ay) denklemi?', options: ['y=5x', 'y=20x+5', 'y=5x+20', 'y=x+25'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Depoda 60lt su, saatte 4lt boşalıyor. 20lt altına en az kaç saat?', options: ['9', '10', '11', '12'], correctIndex: 2, explanation: '60-4x<20→x>10. En az 11', difficulty: 2),
    StemQuestion(question: 'A(a,-3) noktası 2x-y=7 üzerinde ise a?', options: ['1', '2', '3', '4'], correctIndex: 1, explanation: '2a+3=7→a=2', difficulty: 2),
    StemQuestion(question: 'Orijinden geçen doğru hangisi?', options: ['2x-3y=0', 'x+y=5', 'y=2x+1', 'x=3'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'y=2x+5 doğrusuna dik doğrunun eğimi?', options: ['2', '-2', '1/2', '-1/2'], correctIndex: 3, explanation: 'm₁·m₂=-1→2·m₂=-1→m₂=-1/2', difficulty: 3),
    StemQuestion(question: 'A tarifesi: 50TL+0,1TL/dk. B: 0,2TL/dk. Eşit ücret kaç dk?', options: ['250', '400', '500', '600'], correctIndex: 2, explanation: '50+0,1x=0,2x→x=500', difficulty: 2),
    StemQuestion(question: 'A(0,4),B(6,0),O(0,0) üçgen alanı?', options: ['10', '12', '18', '24'], correctIndex: 1, explanation: '4·6/2=12', difficulty: 2),
    StemQuestion(question: 'ax-3y+12=0 eğimi 2 ise a?', options: ['2', '3', '6', '-6'], correctIndex: 2, explanation: 'y=(a/3)x+4. a/3=2→a=6', difficulty: 2),
    StemQuestion(question: 'y=2x-1500. Kâr için alış fiyatı en az? (tam sayı)', options: ['1499', '1500', '1501', '2000'], correctIndex: 2, explanation: '2x-1500>x→x>1500. En az 1501', difficulty: 2),
    StemQuestion(question: '3x-2y=12 ile eksenler arası üçgen alanı?', options: ['6', '12', '18', '24'], correctIndex: 1, explanation: 'x-kesişim 4, y-kesişim -6. Alan=4·6/2=12', difficulty: 2),
    StemQuestion(question: '"2 katının 3 fazlası, 3 katının 7 eksiğinden küçük" eşitsizliği?', options: ['2x+3<3x-7', '2x+3>3x-7', '2(x+3)<3(x-7)', '2x-3<3x+7'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Merdiven yüksekliği 150cm, yatay 200cm. Eğim yüzde kaç?', options: ['%60', '%75', '%80', '%133'], correctIndex: 1, explanation: '150/200=75%', difficulty: 1),
    StemQuestion(question: '2x-y=4 ve x+y=5 kesişim noktası koordinat toplamı?', options: ['3', '4', '5', '6'], correctIndex: 2, explanation: '3x=9→x=3,y=2. 3+2=5', difficulty: 2),
    StemQuestion(question: 'Her gün 5TL biriktiriliyor. Tablo?', options: ['5,10,15', '5,5,5', '0,5,10', '10,15,20'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '-3≤2x-1<9 kaç tam sayı x sağlar?', options: ['4', '5', '6', '7'], correctIndex: 2, explanation: '-1≤x<5. Değerler: -1,0,1,2,3,4→6', difficulty: 2),
  ],
  formulaCards: const [
    'y=mx+n: m eğim, n sabit',
    'Eğim = (y₂-y₁)/(x₂-x₁)',
    'Negatifle çarp/böl → eşitsizlik yön değişir',
    '1.Bölge(+,+) 2.(-,+) 3.(-,-) 4.(+,-)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 5: ÜÇGENLER, EŞLİK VE BENZERLİK
// ═══════════════════════════════════════════════════════════════

final _s8MatU5Content = StemUnitContent(
  unitId: 's8_mat_u5',
  topic: const TopicContent(
    summary: 'Üçgen eşitsizliği: |b-c|<a<b+c. Pisagor: a²+b²=c² (dik üçgen). Benzerlikte açılar eşit, kenarlar orantılıdır. Eş üçgenlerde k=1.',
    rule: 'Üçgen eşitsizliği: |b-c| < a < b+c\nPisagor: a²+b²=c² (3-4-5, 5-12-13, 8-15-17)\nBenzerlik oranı k → Çevre oranı k, Alan oranı k²',
    formulas: [
      'a²+b²=c² (Pisagor)',
      'Özel üçgenler: 3-4-5, 5-12-13, 8-15-17',
      'F·Kuvvet Kolu = P·Yük Kolu (Kaldıraç)',
    ],
    keyPoints: [
      'Büyük açı karşısında büyük kenar',
      'Eşlik: k=1 (birebir aynı)',
      'Benzerlik: Açılar eşit, kenarlar orantılı',
      'Thales: Paralellik → benzerlik',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kenarları 8cm ve 12cm. Üçüncü kenarın en büyük+en küçük tam sayı toplamı?',
      steps: ['|12-8|<x<12+8', '4<x<20', 'En küçük: 5, En büyük: 19'],
      answer: '5+19=24',
    ),
    SolvedExample(
      question: 'Merdiven: duvardan 5m, yerden 12m yükseklikte. Merdiven boyu?',
      steps: ['Dik üçgen: 5²+12²=x²', '25+144=169', 'x=13 (5-12-13 üçgeni)'],
      answer: '13 metre',
    ),
    SolvedExample(
      question: 'Ali boyu 1,6m gölgesi 2m. Direğin gölgesi 10m ise boyu?',
      steps: ['Benzerlik oranı: 1,6/2 = x/10', '10, 2nin 5 katı', 'x=1,6·5=8'],
      answer: '8 metre',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '3,4,x dik üçgende x hipotenüs ise?', options: ['5', '6', '7', '8'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangisi üçgen kenarı olamaz?', options: ['3,4,5', '5,5,5', '2,3,6', '6,8,10'], correctIndex: 2, explanation: '2+3=5<6', difficulty: 1),
    StemQuestion(question: 'Benzerlik oranı 1/3 ise çevre oranı?', options: ['1/9', '1/6', '1/3', '3'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Dik kenarlar 6 ve 8 ise hipotenüs?', options: ['9', '10', '12', '14'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'En kısa kenara ait yükseklik nasıldır?', options: ['En kısa', 'En uzun', 'Ortanca', 'Kenara eşit'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Hangisi dik üçgen oluşturur?', options: ['4-5-6', '5-12-13', '6-8-12', '8-10-15'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eş üçgenlerin benzerlik oranı?', options: ['0', '1/2', '1', '2'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'A(3,0) ve B(0,4) arası mesafe?', options: ['3', '4', '5', '7'], correctIndex: 2, explanation: '3-4-5 dik üçgeni', difficulty: 1),
    StemQuestion(question: 'En büyük açının karşısında?', options: ['En kısa kenar', 'En uzun kenar', 'Hipotenüs', 'Yükseklik'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Benzerlik oranı 2 ise alan oranı?', options: ['2', '3', '4', '8'], correctIndex: 2, explanation: 'k²=4', difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '3-4-? dik üçgen', options: ['5', '6', '7', '8'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '2,3,6 üçgen olur mu?', options: ['Evet', 'Hayır', 'Bazen', 'Bilinmez'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '6-8-? dik üçgen', options: ['9', '10', '12', '14'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Benzerlik k=2 → alan oranı?', options: ['2', '3', '4', '8'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'A(3,0)-B(0,4) mesafe?', options: ['3', '4', '5', '7'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Kenarları 5 ve 9 olan üçgenin çevresi en fazla?', options: ['24', '25', '27', '28'], correctIndex: 2, explanation: 'x<14. Max x=13. 5+9+13=27', difficulty: 2),
    StemQuestion(question: 'A=70°,B=50°,C=60° ise kenar sıralaması?', options: ['a>b>c', 'b>c>a', 'c>a>b', 'a>c>b'], correctIndex: 3, explanation: '70>60>50→a>c>b', difficulty: 2),
    StemQuestion(question: 'Karınca doğuya 5m, kuzeye 12m yürüyor. Kuş uçuşu mesafe?', options: ['13', '15', '17', '25'], correctIndex: 0, explanation: '5-12-13 üçgeni', difficulty: 1),
    StemQuestion(question: 'Alan oranı 4/25 ise benzerlik oranı?', options: ['2/5', '4/25', '16/625', '2/25'], correctIndex: 0, explanation: 'k=√(4/25)=2/5', difficulty: 2),
    StemQuestion(question: '10,24,x dik üçgen ise x?', options: ['25', '26', '28', '30'], correctIndex: 1, explanation: '10-24-26 (5-12-13 iki katı)', difficulty: 2),
    StemQuestion(question: 'Üçgen çizmek için hangisi yeterli değil?', options: ['Üç kenar (SSS)', 'İki kenar ve arası açı (SAS)', 'İki açı ve bir kenar (ASA)', 'Sadece üç açı (AAA)'], correctIndex: 3, explanation: 'AAA ile boyut bilinemez', difficulty: 2),
    StemQuestion(question: '16m direk bir yerden kırılıyor (6m ve 10m). Tepe dibinden kaç m uzağa düştü?', options: ['6', '8', '8√3', '12'], correctIndex: 1, explanation: '6-8-10 üçgeni', difficulty: 2),
    StemQuestion(question: 'A(-2,1) ve B(4,9) arası mesafe?', options: ['8', '10', '12', '14'], correctIndex: 1, explanation: 'Δx=6,Δy=8. 6-8-10', difficulty: 2),
    StemQuestion(question: 'Benzerlik oranı 2/3, büyük çevre 36 ise küçük çevre?', options: ['18', '24', '30', '54'], correctIndex: 1, explanation: 'x/36=2/3→x=24', difficulty: 1),
    StemQuestion(question: 'İkizkenar üçgen: eşit kenarlar 10, taban 12. Tabana ait yükseklik?', options: ['6', '8', '10', '12'], correctIndex: 1, explanation: '6-8-10 üçgeni', difficulty: 2),
    StemQuestion(question: 'a²=b²+c² ise üçgen?', options: ['İkizkenar', 'Eşkenar', 'Geniş açılı', 'Dik üçgen'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Karenin kenarı 100m. Köşegen vs kenar farkı?', options: ['200-100√2', '100√2', '100', '50'], correctIndex: 0, explanation: 'Kenarlardan 200m, köşegenden 100√2', difficulty: 3),
    StemQuestion(question: 'Çevresi 24 üçgenin en uzun kenarı en fazla?', options: ['10', '11', '12', '13'], correctIndex: 1, explanation: 'a<12. En fazla 11', difficulty: 2),
    StemQuestion(question: 'AB=6, AC=8, A>90° ise BC en küçük tam sayı?', options: ['9', '10', '11', '12'], correctIndex: 2, explanation: '90° olsa BC=10. A>90°→BC>10. Min 11', difficulty: 3),
    StemQuestion(question: 'Lamba 6m, çocuk 1,5m, gölge 2m. Çocuk lambadan kaç m uzak?', options: ['4', '6', '8', '10'], correctIndex: 1, explanation: '1,5/6=2/(2+x)→x=6', difficulty: 2),
  ],
  formulaCards: const [
    'Üçgen eşitsizliği: |b-c| < a < b+c',
    'Pisagor: a²+b²=c² (3-4-5, 5-12-13)',
    'Benzerlik: Çevre oranı k, Alan oranı k²',
    'Büyük açı ↔ Büyük kenar',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS MAT ÜNİTE 6: DÖNÜŞÜM GEOMETRİSİ VE GEOMETRİK CİSİMLER
// ═══════════════════════════════════════════════════════════════

final _s8MatU6Content = StemUnitContent(
  unitId: 's8_mat_u6',
  topic: const TopicContent(
    summary: 'Öteleme: Şekil kaydırılır (x veya y değişir). Yansıma: x eksenine göre y işaret değişir, y eksenine göre x işaret değişir. Prizma hacmi: Taban Alanı × Yükseklik. Koni hacmi: 1/3 × πr²h.',
    rule: 'x eksenine yansıma: (x,y)→(x,-y)\ny eksenine yansıma: (x,y)→(-x,y)\nSilindir: V=πr²h, Yanal=2πrh\nKoni: V=1/3·πr²h, h²+r²=l²',
    formulas: [
      'Prizma V = Taban Alanı × h',
      'Silindir V = πr²h',
      'Koni V = 1/3·πr²h',
      'Koni açınım: r/l = α/360',
    ],
    keyPoints: [
      'Öteleme: Boyut değişmez',
      'Yansıma: Boyut değişmez, yön değişir',
      'Piramit/Koni hacmi = Prizma/Silindirin 1/3ü',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'A(3,-2) x eksenine yansıtılıp 4 birim sola ötelenirse?',
      steps: ['x yansıma: (3,-2)→(3,2)', '4 sola: (3-4,2)=(-1,2)'],
      answer: '(-1, 2)',
    ),
    SolvedExample(
      question: 'r=4cm, h=10cm silindir yarısı su dolu. Su hacmi? (π=3)',
      steps: ['V=π·r²·h=3·16·10=480cm³', 'Yarısı: 480/2=240'],
      answer: '240 cm³',
    ),
    SolvedExample(
      question: 'Koni r=3cm, l=9cm. Açınım merkez açısı?',
      steps: ['r/l=α/360', '3/9=α/360', '1/3=α/360→α=120°'],
      answer: '120°',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'A(2,5) 3 sağa 2 aşağı ötelenirse?', options: ['(5,3)', '(5,7)', '(-1,3)', '(-1,7)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangisi prizma değildir?', options: ['Küp', 'Silindir', 'Kare Prizma', 'Koni'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Silindirin yan yüz açınımı?', options: ['Daire', 'Üçgen', 'Dikdörtgen', 'Yamuk'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'B(-4,3) y eksenine yansıması?', options: ['(4,3)', '(-4,-3)', '(4,-3)', '(3,-4)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Taban alanı 25cm², h=4cm prizmanın hacmi?', options: ['29', '50', '100', '200'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Koni r=5cm, l=13cm ise yükseklik?', options: ['10', '11', '12', '14'], correctIndex: 2, explanation: '5-12-13 üçgeni', difficulty: 2),
    StemQuestion(question: 'Piramidin kaç tabanı var?', options: ['1', '2', '3', '4'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Dönme hareketinde ne değişmez?', options: ['Yeri', 'Yönü', 'Boyutu', 'Koordinatları'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hacmi 90cm³, taban alanı 15cm² silindirin h?', options: ['4', '5', '6', '8'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Tepe noktası olan cisim?', options: ['Küp', 'Silindir', 'Dikdörtgen Prizma', 'Koni'], correctIndex: 3, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'A(2,5) → 3 sağa 2 aşağı?', options: ['(5,3)', '(5,7)', '(-1,3)', '(-1,7)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'B(-4,3) y yansıması?', options: ['(4,3)', '(-4,-3)', '(4,-3)', '(3,-4)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'V=Taban×h, A=25, h=4 → V?', options: ['29', '50', '100', '200'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Piramidin taban sayısı?', options: ['1', '2', '3', '4'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Tepe noktası olan cisim?', options: ['Küp', 'Silindir', 'Prizma', 'Koni'], correctIndex: 3, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'A(a,b) 5 sağa ötelenince y eksenine geliyor. a kaç?', options: ['-5', '0', '5', '10'], correctIndex: 0, explanation: 'a+5=0→a=-5', difficulty: 2),
    StemQuestion(question: 'Koni r=6, h=8. Yanal alan? (π=3)', options: ['144', '180', '216', '240'], correctIndex: 1, explanation: 'l=10. πrl=3·6·10=180', difficulty: 2),
    StemQuestion(question: 'Dikdörtgen kısa kenar etrafında döndürülünce?', options: ['Küre', 'Silindir', 'Koni', 'Prizma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'A(1,1) y eksenine yansıtılınca A\' ?', options: ['(-1,1)', '(1,-1)', '(-1,-1)', '(-4,1)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Taban çevresi 24cm, h=10cm silindir yanal alanı?', options: ['120', '240', '360', '480'], correctIndex: 1, explanation: 'Çevre×h=24·10=240', difficulty: 1),
    StemQuestion(question: 'Silindir: r, h→V₁. Silindir: 2r, h/2→V₂. V₁/V₂?', options: ['1/2', '1', '2', '4'], correctIndex: 0, explanation: 'V₂=π(2r)²(h/2)=2πr²h. V₁/V₂=1/2', difficulty: 3),
    StemQuestion(question: '2.bölgedeki L harfi saat yönünde 90° dönerse hangi bölge?', options: ['1.', '2.', '3.', '4.'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Kare piramit: taban ayrıtı 6, yan yüz h=5. Yüzey alanı?', options: ['36', '60', '96', '100'], correctIndex: 2, explanation: 'Taban 36+4·(6·5/2)=36+60=96', difficulty: 2),
    StemQuestion(question: 'Daire dilimi (açı 216°, r=10) kıvrılınca koninin taban r?', options: ['4', '5', '6', '8'], correctIndex: 2, explanation: 'r/10=216/360=3/5→r=6', difficulty: 3),
    StemQuestion(question: 'Silindirin yan yüzü açılınca kısa kenar 10, uzun 30. Taban r en fazla? (π=3)', options: ['5/3', '5', '10/3', '10'], correctIndex: 1, explanation: '2πr=30→r=5', difficulty: 2),
    StemQuestion(question: 'A(2,-3) 3 yukarı ötelenip x yansıtılırsa?', options: ['(2,0)', '(2,6)', '(-2,0)', '(2,-6)'], correctIndex: 0, explanation: 'Öteleme(2,0). y=0 yansımada değişmez', difficulty: 2),
    StemQuestion(question: 'Silindir h=8π, r=3. Karınca 1 tur atarak tırmanıyor. En kısa yol?', options: ['10', '10π', '12', '12π'], correctIndex: 1, explanation: 'Açınım: 6π-8π-10π üçgeni', difficulty: 3),
    StemQuestion(question: 'Kare piramit hacmi 108cm³, h=9 ise taban kenarı?', options: ['4', '6', '8', '12'], correctIndex: 1, explanation: '108=A·9/3→A=36. Kenar=6', difficulty: 2),
    StemQuestion(question: 'Orijine göre simetrik nokta çifti?', options: ['(2,3)-(2,-3)', '(2,3)-(-2,3)', '(2,3)-(-2,-3)', '(2,3)-(3,2)'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Koni r yarıya, h 4 katına. Hacim nasıl değişir?', options: ['Değişmez', '2 katı', 'Yarısı', '4 katı'], correctIndex: 0, explanation: 'π(r/2)²·4h=πr²h', difficulty: 3),
  ],
  formulaCards: const [
    'x yansıma: (x,y)→(x,-y), y yansıma: (x,y)→(-x,y)',
    'Silindir V=πr²h, Yanal=2πrh',
    'Koni V=1/3·πr²h, Açınım: r/l=α/360',
    'Piramit/Koni hacmi = Prizma/Silindirin 1/3ü',
  ],
);

// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// 8. SINIF (LGS) FEN BİLİMLERİ İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 1: MEVSİMLER VE İKLİM
// ═══════════════════════════════════════════════════════════════

final _s8FenU1Content = StemUnitContent(
  unitId: 's8_fen_u1',
  topic: const TopicContent(
    summary: 'Mevsimlerin sebebi: Eksen eğikliği (23°27\') ve yıllık hareket. 21 Haziran KYK yaz, 21 Aralık KYK kış. Ekinokslarda gece=gündüz. İklim uzun süreli, hava olayı kısa süreli. Rüzgar yüksek basınçtan alçak basınca eser.',
    rule: '21 Haziran: KYK Yaz, Yengeç Dönencesine dik\n21 Aralık: GYK Yaz, Oğlak Dönencesine dik\n21 Mart / 23 Eylül: Ekinoks, Ekvator\'a dik\nRüzgar: Yüksek Basınç → Alçak Basınç',
    formulas: [
      'Eksen eğikliği: 23°27\'',
      'Ekinoks: Gece = Gündüz = 12 saat',
    ],
    keyPoints: [
      'Mevsim sebebi: Eksen eğikliği + yıllık hareket',
      'İklim: Uzun süre, geniş alan (Klimatoloji)',
      'Hava: Kısa süre, dar alan (Meteoroloji)',
      'Yüksek basınç: Açık hava, Alçak basınç: Yağışlı',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Gölge boyunun en kısa olduğu tarih ve yarım küre?',
      steps: ['Güneş dik gelince gölge kısa olur', 'KYK: 21 Haziran, GYK: 21 Aralık'],
      answer: 'KYK→21 Haziran, GYK→21 Aralık',
    ),
    SolvedExample(
      question: '21 Aralık\'ta K(KYK) ve L(GYK) hangisinde birim yüzeye enerji fazla?',
      steps: ['21 Aralık GYK yazı', 'Güneş ışınları L\'ye daha dik gelir'],
      answer: 'L şehri (GYK)',
    ),
    SolvedExample(
      question: 'A bölgesi 10°C, B bölgesi 25°C. Rüzgar yönü?',
      steps: ['Soğuk hava = Yüksek basınç (A)', 'Sıcak hava = Alçak basınç (B)', 'Yüksek→Alçak'],
      answer: 'A\'dan B\'ye',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Dünya\'nın eksen eğikliği kaç derece?', options: ['21°30\'', '23°27\'', '27°23\'', '33°27\''], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'KYK\'de en uzun gündüz hangi tarihte?', options: ['21 Mart', '23 Eylül', '21 Aralık', '21 Haziran'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Hava olaylarını inceleyen bilim dalı?', options: ['Klimatoloji', 'Meteoroloji', 'Biyoloji', 'Jeoloji'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Ekinokslarda Güneş nereye dik düşer?', options: ['Yengeç', 'Oğlak', 'Ekvator', 'Kutuplar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi iklim ifadesidir?', options: ['Yarın yağmur bekleniyor', 'Karadeniz her mevsim yağışlı', 'Öğleden sonra fırtına çıkacak', 'Haftasonu güneşli'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Rüzgarın oluşum sebebi?', options: ['Dünya\'nın dönmesi', 'Basınç farkı', 'Yağmur', 'Mevsimler'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '21 Haziran\'da Güneş hangi dönenceye dik?', options: ['Ekvator', 'Oğlak', 'Yengeç', 'Greenwich'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'GYK\'de Sonbahar hangi tarihte başlar?', options: ['21 Mart', '21 Haziran', '23 Eylül', '21 Aralık'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Alçak basınç alanında hava hareketi?', options: ['Merkezden çevreye', 'Yükselici', 'Alçalıcı', 'Soğuk ve kuru'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Küresel ısınmanın en büyük sebebi?', options: ['Sera gazları', 'Güneş patlamaları', 'Volkanlar', 'Rüzgar enerjisi'], correctIndex: 0, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Eksen eğikliği?', options: ['21°30\'', '23°27\'', '27°23\'', '33°27\''], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'KYK en uzun gündüz?', options: ['21 Mart', '23 Eylül', '21 Aralık', '21 Haziran'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Ekinoksta Güneş nereye dik?', options: ['Yengeç', 'Oğlak', 'Ekvator', 'Kutuplar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Rüzgar sebebi?', options: ['Dönme', 'Basınç farkı', 'Yağmur', 'Mevsim'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Küresel ısınma sebebi?', options: ['Sera gazları', 'Güneş', 'Volkan', 'Rüzgar'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Gölge yılda 2 kez sıfır oluyor. Çubuk nerede?', options: ['Yengeç Dönencesi', 'Oğlak Dönencesi', 'Dönenceler arası', 'Kutuplarda'], correctIndex: 2, explanation: 'Dönenceler arasına yılda 2 kez dik düşer', difficulty: 3),
    StemQuestion(question: '21 Aralık\'ta K(KYK) ve L(GYK) için hangisi doğru?', options: ['K\'de en uzun gündüz', 'L\'ye ışın daha eğik', 'K\'nin gölgesi L\'den uzun', 'L\'de kış başlar'], correctIndex: 2, explanation: 'KYK kış=eğik ışın=uzun gölge', difficulty: 2),
    StemQuestion(question: 'KYK Sonbahar ise GYK hangi mevsim?', options: ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '"Eksen eğikliği olmasaydı" hangisi yanlış?', options: ['Mevsimler oluşmazdı', 'Sıcaklık farkları olmazdı', 'Gece-gündüz eşit olurdu', 'Güneşe uzaklık değişmezdi'], correctIndex: 3, explanation: 'Uzaklık yörünge elipsliğiyle ilgili', difficulty: 3),
    StemQuestion(question: 'Rüzgar tulumu doğuya dalgalanıyor. Basınç alanları?', options: ['Batı:Alçak, Doğu:Yüksek', 'Batı:Yüksek, Doğu:Alçak', 'Her ikisi Alçak', 'Her ikisi Yüksek'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Meteorologun çalışma alanına giren?', options: ['40 yıllık sıcaklık ortalaması', 'Yıllık yağış', 'Önümüzdeki 3 gün rüzgar tahmini', 'Kışların sert geçmesi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Yükselici hava hareketi alanı için doğru olan?', options: ['Yüksek basınç', 'Hava açık', 'Sıcaklık düşük', 'Yağış ihtimali fazla'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: '21 Mart\'ta Türkiye\'de gece-gündüz süresi?', options: ['Gündüz>Gece', 'Gece>Gündüz', 'Gece=Gündüz', 'Ölçülemez'], correctIndex: 2, explanation: 'Ekinoks', difficulty: 1),
    StemQuestion(question: 'KYK Temmuz\'da yaz olmasının sebebi? (Güneşe en uzak 4 Temmuz)', options: ['Kendi dönüşü', 'Işın geliş açısı', 'Güneşe uzaklık', 'Okyanuslar'], correctIndex: 1, explanation: 'Eksen eğikliği sebebiyle açı belirleyici', difficulty: 3),
    StemQuestion(question: 'Birim yüzeye düşen enerji artıyorsa; I.Yaza yaklaşır II.Gündüz uzar III.Işık açısı büyür', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'İklim değişikliği sonucu gösterilemez?', options: ['Buzulların erimesi', 'Çölleşme', 'Biyolojik çeşitlilik artması', 'Fırtınaların sıklaşması'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '21 Haziran\'da gündüz 15, 21 Aralık\'ta 9 saat. Şehir nerede?', options: ['Ekvator', 'KYK', 'GYK', 'Kutuplar'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Ekvator\'da gölge hangi tarihte oluşmaz?', options: ['21 Haziran', '23 Eylül', '21 Aralık', '3 Ocak'], correctIndex: 1, explanation: 'Ekinoksta Ekvator\'a dik', difficulty: 2),
    StemQuestion(question: 'Yüksek basınç alanında hava durumu?', options: ['Bulutlu ve yağmurlu', 'Açık ve güneşli', 'Fırtınalı', 'Çok nemli'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '21 Haziran\'da GYK\'de güneye gidildikçe gece süresi?', options: ['Kısalır', 'Uzar', 'Değişmez', 'Önce uzar sonra kısalır'], correctIndex: 1, explanation: 'GYK kış, kutuplara gidildikçe gece uzar', difficulty: 2),
  ],
  formulaCards: const [
    'Eksen eğikliği: 23°27\' → Mevsimlerin sebebi',
    '21 Haz: KYK Yaz, 21 Ara: KYK Kış',
    'Ekinoks: 21 Mart & 23 Eylül → Gece=Gündüz',
    'Rüzgar: Yüksek Basınç → Alçak Basınç',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 2: DNA VE GENETİK KOD
// ═══════════════════════════════════════════════════════════════

final _s8FenU2Content = StemUnitContent(
  unitId: 's8_fen_u2',
  topic: const TopicContent(
    summary: 'DNA yapı birimi nükleotid. Eşleşme: A=T, G=C. Sıralama: Kromozom>DNA>Gen>Nükleotid. Baskın gen: büyük harf (A), çekinik: küçük (a). Cinsiyeti baba belirler (XY). Mutasyon kalıcı DNA değişimi, modifikasyon çevre etkisi.',
    rule: 'A=T, G=C (Chargaff kuralı)\nGenotip: AA(saf baskın), Aa(melez), aa(saf çekinik)\nCinsiyet: Dişi XX, Erkek XY\nMutasyon: DNA yapı değişimi (kalıcı)\nModifikasyon: Gen işleyiş değişimi (kalıtsal değil)',
    formulas: [
      'A sayısı = T sayısı, G sayısı = C sayısı',
      'Toplam nükleotid = 2×(A+G)',
    ],
    keyPoints: [
      'Çekinik fenotip → genotip mutlaka aa',
      'Cinsiyeti baba belirler (X veya Y spermi)',
      'Mutasyon: Radyasyon, kimyasal → kalıcı',
      'Modifikasyon: Çevre etkisi → kalıtsal değil',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'DNA zinciri A-T-G-C-A. Eşlenme sonucu yeni iplikler?',
      steps: ['Karşı iplik: T-A-C-G-T', 'Eşlenmede her iplik kendi tamamlayıcısını oluşturur', 'Sonuç iki özdeş DNA'],
      answer: 'T-A-C-G-T ve A-T-G-C-A',
    ),
    SolvedExample(
      question: 'Ss × ss çaprazlama. Yeşil tohumlu olma ihtimali?',
      steps: ['Ss × ss: Ss, Ss, ss, ss', '2 Ss (Sarı) + 2 ss (Yeşil)', 'Yeşil ihtimali: 2/4'],
      answer: '%50',
    ),
    SolvedExample(
      question: 'Arı larvası arı sütüyle beslenirse kraliçe, çiçek tozuyla işçi olur. Mutasyon mu modifikasyon mu?',
      steps: ['Çevresel faktör (beslenme) etkisi', 'DNA yapısı değişmiyor, gen işleyişi değişiyor', 'Kalıtsal değil'],
      answer: 'Modifikasyon',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'DNA\'nın temel yapı birimi?', options: ['Gen', 'Nükleotid', 'Kromozom', 'Organik Baz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Adenin karşısına ne gelir?', options: ['Guanin', 'Sitozin', 'Timin', 'Fosfat'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Basitten karmaşığa sıralama?', options: ['Krom>DNA>Gen>Nük', 'Nük>Gen>DNA>Krom', 'Krom>Gen>DNA>Nük', 'Nük>DNA>Gen>Krom'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çekinik özellik görünmesi için genotip?', options: ['AA', 'Aa', 'aa', 'Aa'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Cinsiyeti belirleyen kromozom kimden?', options: ['Anne', 'Baba', 'Her ikisi', 'Çevre'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi mutasyon örneği?', options: ['Bronzlaşma', 'Kas geliştirme', 'Van kedisi göz rengi', 'Çuha çiçeği renk değişimi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'DNA eşlenmesinde sitoplazmadaki serbest nükleotid?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce artar sonra azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yaşama ve üreme şansı artıran kalıtsal özellikler?', options: ['Varyasyon', 'Modifikasyon', 'Adaptasyon', 'Seleksiyon'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'MM × mm çaprazlama genotipi?', options: ['%100 Mm', '%50 Saf %50 Melez', '%100 MM', '%25 mm'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Biyoteknolojinin olumsuz etkisi?', options: ['Verimli ürünler', 'Dirençli tohumlar', 'Doğal denge bozulması', 'Yapay organ'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'DNA yapı birimi?', options: ['Gen', 'Nükleotid', 'Kromozom', 'Baz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'A karşısına?', options: ['G', 'C', 'T', 'P'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Çekinik fenotip için genotip?', options: ['AA', 'Aa', 'aa', 'aA'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Cinsiyeti kim belirler?', options: ['Anne', 'Baba', 'İkisi', 'Çevre'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Van kedisi göz rengi?', options: ['Modifikasyon', 'Mutasyon', 'Adaptasyon', 'Seleksiyon'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'DNA\'da 2000 nükleotid, 400 Adenin var. Guanin sayısı?', options: ['400', '600', '800', '1200'], correctIndex: 1, explanation: 'A=T=400→800. G=C=(2000-800)/2=600', difficulty: 2),
    StemQuestion(question: 'Düz×Düz→Buruşuk çıkıyorsa ebeveyn genotipi?', options: ['DD×DD', 'DD×Dd', 'Dd×Dd', 'Dd×dd'], correctIndex: 2, explanation: 'Çekinik çıkması için ikisi de Dd olmalı', difficulty: 2),
    StemQuestion(question: 'DNA\'da karşılıklı iki zincirde aynı bölgede kopma olursa?', options: ['Onarılır', 'Mutasyon olur', 'Onarılamaz', 'Modifikasyon olur'], correctIndex: 2, explanation: 'Tek zincir kopması onarılır, çift onarılamaz', difficulty: 3),
    StemQuestion(question: 'Kutup ayısı beyaz kürk, geniş ayak, kalın yağ tabakası?', options: ['Modifikasyon', 'Mutasyon', 'Varyasyon', 'Adaptasyon'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Akraba evliliği ile ilgili doğru olan?', options: ['Çocuklar kesin hasta', 'Çekinik genlerin birleşme ihtimali artar', 'Baskın hastalıklar', 'Çeşitliliği artırır'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Himalaya tavşanı buz konunca siyah kıl çıkıyor. Bu durum?', options: ['Mutasyon', 'Modifikasyon', 'Adaptasyon', 'Evrim'], correctIndex: 1, explanation: 'Çevre etkisi, kalıtsal değil', difficulty: 2),
    StemQuestion(question: 'Bakterilerle insülin üretiminde hangi özellik kullanılır?', options: ['Hızlı çoğalma ve gen aktarımı', 'İnsanda yaşayabilme', 'Fotosentez', 'Hastalık yapıcılık'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Kk × kk çaprazlama. İlk çocuk mavi gözlü. İkincinin kahverengi olma ihtimali?', options: ['%0', '%25', '%50', '%100'], correctIndex: 2, explanation: 'Her çaprazlama bağımsız. Kk×kk→Kk,kk→%50', difficulty: 2),
    StemQuestion(question: 'Hızlı koşan ceylanların hayatta kalması?', options: ['Doğal seçilim', 'Kas geliştirme', 'Radyasyon', 'Biyoteknoloji'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'DNA parmak izi hangi özelliğe dayanır?', options: ['Nükleotid çeşidi aynı', 'Fosfat sayısı farklı', 'Nükleotid dizilimi farklı', 'DNA eşlenmesi'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Kromozom sayısı ile gelişmişlik arasında ilişki. Hangisi söylenemez?', options: ['Vücut büyüklüğünü belirler', 'Farklı türlerde aynı olabilir', 'Gelişmişlik göstergesi değil', 'Türe özgüdür'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'GDO ile ilgili tartışmalı konu?', options: ['Verim artışı', 'Raf ömrü uzatma', 'Uzun vadeli sağlık etkisi bilinmiyor', 'Soğuğa dayanıklı bitki'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'DNA eşlenmesinde 50G, 30A kullanılmış. Toplam zayıf hidrojen bağ?', options: ['80', '160', '210', '240'], correctIndex: 2, explanation: 'A=T ikili(30×2=60), G=C üçlü(50×3=150). 60+150=210', difficulty: 3),
    StemQuestion(question: 'Hangisinden saf döl elde etme ihtimali yok?', options: ['AA×aa', 'Aa×Aa', 'Aa×aa', 'AA×AA'], correctIndex: 0, explanation: 'AA×aa→tamamı Aa (melez)', difficulty: 2),
    StemQuestion(question: 'Uzun×Uzun→Hep Uzun. Uzun×Kısa→Yarısı Kısa. 2. çaprazlamadaki Uzunun genotipi?', options: ['AA', 'Aa', 'aa', 'Belirlenemez'], correctIndex: 1, explanation: 'Kısa çıkması için Aa olmalı', difficulty: 2),
  ],
  formulaCards: const [
    'A=T, G=C (Chargaff kuralı)',
    'Kromozom > DNA > Gen > Nükleotid',
    'Dişi: XX, Erkek: XY (Baba belirler)',
    'Mutasyon: Kalıcı DNA değişimi',
    'Modifikasyon: Çevre etkisi, kalıtsal değil',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 3: BASINÇ
// ═══════════════════════════════════════════════════════════════

final _s8FenU3Content = StemUnitContent(
  unitId: 's8_fen_u3',
  topic: const TopicContent(
    summary: 'Katı basıncı: P=G/S (ağırlık/yüzey alanı). Sıvı basıncı: P=h·d·g (derinlik, yoğunluk). Kap şekline bağlı değil. Pascal: Sıvıya uygulanan basınç aynen iletilir. Atmosfer basıncı yükselince azalır.',
    rule: 'Katı: P=G/S (Pa)\nSıvı: P=h·d·g\nPascal: Kapalı kaptaki basınç aynen iletilir\nAtmosfer: Yükseklik artar→basınç azalır',
    formulas: [
      'P = F/A (Katı basıncı)',
      'P = h·d·g (Sıvı basıncı)',
      'Torricelli: 76 cm Hg (deniz seviyesi)',
    ],
    keyPoints: [
      'Alan küçülürse basınç artar (bıçak, çivi)',
      'Sıvı basıncı kap şekline bağlı değil',
      'Pascal prensibi: Hidrolik sistemler',
      'Yükseklere çıkınca basınç azalır',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2 küp üst üste vs 4 küp yan yana. Zemin basınçları?',
      steps: ['Şekil 1: P₁=2G/1S=2P', 'Şekil 2: P₂=4G/4S=1P'],
      answer: 'P₁ > P₂ (2 katı)',
    ),
    SolvedExample(
      question: 'Küçük piston 10cm², büyük 100cm². 50N uygulanırsa büyük kaç N kaldırır?',
      steps: ['P₁=P₂: 50/10=x/100', '5=x/100→x=500'],
      answer: '500 N',
    ),
    SolvedExample(
      question: 'Farklı kaplarda aynı yükseklikte aynı sıvı. Taban basınçları?',
      steps: ['P=h·d·g', 'h aynı, d aynı, g aynı', 'Kap şekli etkilemez'],
      answer: 'Eşit',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Katı basıncının birimi?', options: ['Newton', 'Pascal', 'Joule', 'Kilogram'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Basıncı azaltma uygulaması?', options: ['Bıçak bileme', 'Krampon çivisi', 'Kamyon tekerlek artırma', 'Toplu iğne ucu'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Sıvı basıncı hangisine bağlı değil?', options: ['Derinlik', 'Yoğunluk', 'Yerçekimi', 'Kap şekli'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Açık hava basıncını ölçen alet?', options: ['Barometre', 'Manometre', 'Termometre', 'Dinamometre'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Torricelli deneyinde su kullanılsa yükseklik?', options: ['Azalır', 'Değişmez', 'Artar (≈10,5m)', 'Sıfır olur'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Sıvıların basıncı aynen iletme ilkesi?', options: ['Arşimet', 'Pascal', 'Bernoulli', 'Torricelli'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dağa tırmanırken açık hava basıncı?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce artar sonra azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Magdeburg yarım kürelerini sıkıştıran?', options: ['İçerideki vakum', 'Dışarıdaki atmosfer basıncı', 'Yapışkanlık', 'Genleşme'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Dalgıç derinlere indikçe basınç?', options: ['Artar', 'Azalır', 'Değişmez', 'Kiloya bağlı'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '30cm² yüzeye 60N kuvvet. Basınç?', options: ['0,5', '2', '1800', '90'], correctIndex: 1, explanation: '60/30=2', difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Basınç birimi?', options: ['Newton', 'Pascal', 'Joule', 'kg'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sıvı basıncı kap şekline bağlı mı?', options: ['Evet', 'Hayır', 'Bazen', 'Bilinmez'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dağda basınç?', options: ['Artar', 'Azalır', 'Değişmez', 'Artar sonra azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '60N / 30cm²?', options: ['0,5', '2', '1800', '90'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Basıncı azaltma?', options: ['Bıçak bileme', 'Krampon', 'Tekerlek artırma', 'İğne sivri'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Tuğla geniş yüzünden dar yüzüne konuyor. Kuvvet ve basınç?', options: ['Kuvvet değişmez, basınç artar', 'Kuvvet artar, basınç artar', 'Kuvvet değişmez, basınç azalır', 'Kuvvet azalır, basınç artar'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Şişede K(üst), L(orta), M(alt) delikleri. Fışkırma sıralaması?', options: ['K>L>M', 'K=L=M', 'M>L>K', 'L>M>K'], correctIndex: 2, explanation: 'Derinlik fazla→basınç fazla→uzağa fışkırır', difficulty: 1),
    StemQuestion(question: '"Bıçak basıncı artırır" ilkesiyle çelişen?', options: ['Krampon', 'Zincir takma', 'Ördek perdeli ayak', 'Çivi sivri uç'], correctIndex: 2, explanation: 'Ördek: Alan artırır→basınç azaltır', difficulty: 2),
    StemQuestion(question: 'Torricelli deneyinde 76cm cıva değişir mi?', options: ['Kalın boru', 'Eğik tutma', 'Yüksek rakım', 'Cıva artırma'], correctIndex: 2, explanation: 'Sadece yükseklik (rakım) etkiler', difficulty: 2),
    StemQuestion(question: 'Yukarı daralan kapta basınç-zaman grafiği?', options: ['Doğrusal artar', 'Artarak artar', 'Azalarak artar', 'Sabit kalır'], correctIndex: 1, explanation: 'Daralan kapta su seviyesi daha hızlı yükselir', difficulty: 3),
    StemQuestion(question: 'Hidrolik fren prensibi?', options: ['Katı kuvvet iletimi', 'Sıvı basınç iletimi', 'Gaz sıkıştırma', 'Yoğunluk farkı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Helyum balonun yükseldikçe hacmi?', options: ['Azalır', 'Değişmez', 'Artar', 'Önce azalır sonra artar'], correctIndex: 2, explanation: 'Dış basınç azalır→balon şişer', difficulty: 2),
    StemQuestion(question: 'Çiviye çekiçle vurulduğunda; I.Kuvvetler eşit II.Uçta basınç fazla III.Uç geniş olsa girmesi zor. Doğru?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Yoğunluk 2d, h yükseklik→P basınç. Yarısı boşaltılıp d yoğunluklu sıvı konursa basınç?', options: ['P/2', '3P/4', 'P', '3P/2'], correctIndex: 1, explanation: 'Alt h/2 2d→P/2. Üst h/2 d→P/4. Toplam 3P/4', difficulty: 3),
    StemQuestion(question: 'Baraj duvarları alt kısımda neden kalın?', options: ['Tasarruf', 'Estetik', 'Derinlerde artan basınç', 'Akış hızı'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Esnek balonun iç ve dış basıncı?', options: ['Dış>İç', 'Dış<İç', 'Dış=İç', 'Hacme bağlı'], correctIndex: 2, explanation: 'Esnek cisimlerde eşitlenir', difficulty: 2),
    StemQuestion(question: 'Özdeş tuğla: I.Tek II.2 yan yana III.2 üst üste. P₁,P₂,P₃?', options: ['P₃>P₁=P₂', 'P₁=P₂=P₃', 'P₃>P₂>P₁', 'P₁>P₂>P₃'], correctIndex: 0, explanation: 'I: G/S=P. II: 2G/2S=P. III: 2G/S=2P', difficulty: 2),
    StemQuestion(question: 'Buzda kırılma tehlikesine karşı ne yapmalı?', options: ['Tek ayakta seke', 'Yüzüstü uzanıp sürün', 'Koşarak geç', 'Zıpla'], correctIndex: 1, explanation: 'Alan artırır→basınç azalır', difficulty: 1),
    StemQuestion(question: 'U borusunda d₁ yüksekliği 10cm, d₂ yüksekliği 20cm. Yoğunluk ilişkisi?', options: ['d₁=d₂', 'd₁=2d₂', 'd₂=2d₁', 'd₁=4d₂'], correctIndex: 1, explanation: '10·d₁=20·d₂→d₁=2d₂', difficulty: 2),
    StemQuestion(question: 'I.Meyve suyu kutusu büzülmesi II.Vantuz III.Çay tabağı yapışması. Hangisi atmosfer basıncı?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 3, difficulty: 2),
  ],
  formulaCards: const [
    'Katı P=G/S: Alan↓ Basınç↑',
    'Sıvı P=h·d·g: Kap şekline bağlı değil',
    'Pascal: Sıvıya uygulanan basınç aynen iletilir',
    'Torricelli: 76cm Hg (deniz seviyesi)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 4: MADDE VE ENDÜSTRİ
// ═══════════════════════════════════════════════════════════════

final _s8FenU4Content = StemUnitContent(
  unitId: 's8_fen_u4',
  topic: const TopicContent(
    summary: 'Periyodik tablo: Yatay=periyot, dikey=grup. Metaller sol, ametaller sağ, yarı metaller merdivende. Fiziksel değişim: Kimlik değişmez. Kimyasal değişim: Yeni madde oluşur. Asit pH<7, Baz pH>7. Nötralleşme: Asit+Baz→Tuz+Su.',
    rule: 'Periyot: Katman sayısı = Periyot no\nGrup: Son katman e⁻ sayısı = Grup no (A)\nAsit: H⁺ verir, pH<7, turnusolu kırmızı\nBaz: OH⁻ verir, pH>7, turnusolu mavi\nKütlenin korunumu: Girenlerin kütlesi = Ürünlerin kütlesi',
    formulas: [
      'Q = m·c·Δt (Isı formülü)',
      'Nötralleşme: Asit + Baz → Tuz + Su',
    ],
    keyPoints: [
      'Metaller: Parlak, iletken, işlenebilir',
      'Ametaller: Mat, yalıtkan, kırılgan',
      'Kütle korunur, atom sayısı korunur',
      'Özısısı büyük olan geç ısınır, geç soğur',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Elektron dağılımı 2-8-3 olan elementin yeri ve sınıfı?',
      steps: ['3 katman→3. Periyot', 'Son katman 3 e⁻→3A Grubu', '3A grubu metal (Alüminyum)'],
      answer: '3. Periyot, 3A Grubu, Metal',
    ),
    SolvedExample(
      question: 'A: 40g→10g, B: 20g→0g. C ürünü kaç gram?',
      steps: ['Harcanan A: 30g, B: 20g', 'Kütlenin korunumu: 30+20=50'],
      answer: '50 gram',
    ),
    SolvedExample(
      question: 'Eşit kütleli X(c=0,5) ve Y(c=2,0) eşit ısıtılıyor. X 40°C artarsa Y?',
      steps: ['Q=m·c·Δt eşit', 'Özısı ile Δt ters orantılı', '0,5·40=2,0·Δt→Δt=10'],
      answer: '10°C',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '1A grubunda olup ametal olan?', options: ['Lityum', 'Hidrojen', 'Sodyum', 'Helyum'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi kimyasal değişim?', options: ['Buzun erimesi', 'Kağıdın yırtılması', 'Demirin paslanması', 'Tuzun çözünmesi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'pH 3 olan madde?', options: ['Kuvvetli baz', 'Nötr', 'Asit', 'Kayganlık verir'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'OH⁻ iyonu veren sınıf?', options: ['Asit', 'Baz', 'Tuz', 'Metal'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi fiziksel değişim?', options: ['Yoğurdun ekşimesi', 'Mumun erimesi', 'Mumun yanması', 'Sütün bozulması'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tepkimede değişebilen?', options: ['Toplam kütle', 'Atom sayısı', 'Atom cinsi', 'Molekül sayısı'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Özısısı büyük maddeler?', options: ['Çabuk ısınır çabuk soğur', 'Geç ısınır geç soğur', 'Çabuk ısınır geç soğur', 'Isı alışverişi yapmaz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Mavi turnusolu kırmızıya çeviren?', options: ['Sabunlu su', 'Limonlu su', 'Çamaşır suyu', 'Tuzlu su'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Periyodik tabloda dikey sütunlar?', options: ['Periyot', 'Grup', 'Ametal', 'Soygaz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Saf katı erirken sıcaklık?', options: ['Artar', 'Azalır', 'Sabit kalır', 'Önce artar sonra azalır'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '1A grubundaki ametal?', options: ['Li', 'H', 'Na', 'He'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Demir paslanması?', options: ['Fiziksel', 'Kimyasal', 'Hal değişimi', 'Çözünme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'pH<7 ne demek?', options: ['Baz', 'Nötr', 'Asit', 'Tuz'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Dikey sütun adı?', options: ['Periyot', 'Grup', 'Ametal', 'Soygaz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Saf madde erirken sıcaklık?', options: ['Artar', 'Azalır', 'Sabit', 'Artar-azalır'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Periyodik tabloda soldan sağa genellikle artan?', options: ['Atom numarası', 'Metalik özellik', 'Atom çapı', 'Elektron verme eğilimi'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'X: Parlak, tel olur. Y: Kırılgan, ısı iletmez. Z: Kararlı, bileşik yapmaz. Sınıfları?', options: ['X:Metal, Y:Ametal, Z:Soygaz', 'X:Ametal, Y:Metal, Z:Yarı Metal', 'X:Yarı Metal, Y:Soygaz, Z:Metal', 'X:Metal, Y:Yarı Metal, Z:Ametal'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Asit yağmurlarına sebep olan gazlar?', options: ['O₂, H₂, N₂', 'CO₂, SO₂, NO₂', 'He, Ne, Ar', 'H₂O, CO, O₃'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'K ve L azalıyor, M artıyor. Tepkime denklemi?', options: ['M→K+L', 'K+L→M', 'K+M→L', 'K→L+M'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'K 5dk\'da 10°C, L 5dk\'da 20°C ısınıyor (eşit kütle). I.L özısısı küçük II.K geç soğur. Doğru?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 1, explanation: 'Çok ısınan=düşük özısı. Yüksek özısılı geç soğur', difficulty: 2),
    StemQuestion(question: 'Saf katının ısınma grafiğinde sabit sıcaklık bölgeleri ne?', options: ['Kinetik enerji artışı', 'Hal değişimi', 'Isı almama', 'Genleşme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Asitleri saklamak için en uygun kap?', options: ['Metal', 'Cam', 'Mermer', 'Demir'], correctIndex: 1, explanation: 'Cam asitlerden etkilenmez (HF hariç)', difficulty: 2),
    StemQuestion(question: 'Kimyasal tepkimede kesinlikle korunan? I.Toplam kütle II.Atom sayısı III.Molekül sayısı', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Asitlere su eklenirse pH?', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 0, explanation: 'Seyreltme pH\'yı 7ye yaklaştırır (artırır)', difficulty: 2),
    StemQuestion(question: 'Metal parayı parlatırken kimyasal aşınma riski olan?', options: ['Saf su', 'Tuzlu su', 'Sirke', 'Sabunlu su'], correctIndex: 2, explanation: 'Sirke asittir, metallerle tepkime verir', difficulty: 2),
    StemQuestion(question: 'Türk kimya endüstrisi: I.Hammadde dışa bağımlı II.İthalat>İhracat III.Mineral yakıtlar ihraç. Doğru?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Göllerin yüzeyden donmasının sebebi?', options: ['Buzun yoğunluğu sudan küçük', 'Suyun özısısı yüksek', 'Buharlaşma ısısı yüksek', 'Su iletken'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'H₂SO₄ + KOH → ?', options: ['Nötralleşme: Tuz+Su', 'Gaz çıkışı, patlama', 'Tepkime olmaz', 'Donma'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangisinde sadece tanecik arası boşluk değişir?', options: ['Odun yanması', 'Demir paslanması', 'Su buharlaşması', 'Ekmek küflenmesi'], correctIndex: 2, explanation: 'Buharlaşma fiziksel değişim', difficulty: 1),
    StemQuestion(question: 'Eşit sıcaklıkta Demir(c=0,4) ve Su(c=4,18) soğuk ortama bırakılıyor. Hangisi daha çok ısı verir?', options: ['Demir çabuk soğur', 'Su deposunda daha çok ısı var', 'Eşit ısı verirler', 'Demir iletkendir'], correctIndex: 1, explanation: 'Özısısı büyük olan daha çok ısı depolar', difficulty: 3),
  ],
  formulaCards: const [
    'Periyot = Katman sayısı, Grup(A) = Son katman e⁻',
    'Asit pH<7, Baz pH>7, Nötr pH=7',
    'Kütlenin korunumu: Girenlerin kütlesi = Ürünlerin kütlesi',
    'Q=m·c·Δt → Özısı büyük = Geç ısınır',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 5: ENERJİ DÖNÜŞÜMLERİ VE ÇEVRE BİLİMİ
// ═══════════════════════════════════════════════════════════════

final _s8FenU5Content = StemUnitContent(
  unitId: 's8_fen_u5',
  topic: const TopicContent(
    summary: 'Besin zinciri: Üretici→Otçul→Etçil. Enerji %10 aktarılır. Biyolojik birikim son tüketicide en fazla. Fotosentez: CO₂+Su→Besin+O₂. Solunum: Besin+O₂→CO₂+Su+ATP. Fermantasyon: Etil alkol veya Laktik asit.',
    rule: 'Fotosentez: CO₂+H₂O→Besin(Glikoz)+O₂ (Kloroplast)\nSolunum: Besin+O₂→CO₂+H₂O+ATP (Mitokondri)\nEtil Alkol Fermantasyonu: Besin→Alkol+CO₂+ATP\nLaktik Asit Fermantasyonu: Besin→Laktik Asit+ATP (CO₂ çıkmaz!)',
    formulas: [
      'Enerji piramidi: %10 aktarılır',
      'Fotosentez: 6CO₂+6H₂O→C₆H₁₂O₆+6O₂',
    ],
    keyPoints: [
      'Biyolojik birikim: Yukarıya çıkınca artar',
      'Yeşil ışıkta fotosentez en yavaş',
      'Laktik asit fermantasyonunda CO₂ çıkmaz',
      'Ozon tabakası: UV süzer, CFC inceltir',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Ot→Çekirge→Kurbağa→Yılan→Kartal. En çok zehir kimde?',
      steps: ['Biyolojik birikim: Yukarı çıkınca artar', 'Son tüketici: Kartal'],
      answer: 'Kartal',
    ),
    SolvedExample(
      question: 'Mor, Yeşil, Kırmızı ışıkta hangisinde fotosentez en yavaş?',
      steps: ['Bitkiler yeşil ışığı yansıtır', 'Soğurmayan ışıkla fotosentez yapamaz'],
      answer: 'Yeşil Işık',
    ),
    SolvedExample(
      question: 'Kapalı fanusta yanan mum yanında kireç suyu bulanıyor. Sebep?',
      steps: ['Kireç suyu CO₂ ile bulanır', 'Yanma tepkimesi CO₂ üretir'],
      answer: 'Yanma sonucu oluşan CO₂',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Besin zincirinin ilk basamağı?', options: ['Etçiller', 'Üreticiler', 'Mantarlar', 'Otçullar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fotosentez hangi organelde?', options: ['Mitokondri', 'Koful', 'Kloroplast', 'Ribozom'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Fotosentez ürünü?', options: ['CO₂', 'Su', 'Işık', 'Oksijen'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Kaslarda yorgunluk veren madde?', options: ['Etil Alkol', 'Laktik Asit', 'Sirke Asidi', 'Karbonik Asit'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Serbest azotu toprağa bağlayan doğa olayı?', options: ['Yağmur', 'Rüzgar', 'Yıldırım ve Şimşek', 'Kar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Enerji piramidinde yukarı çıkınca enerji?', options: ['Artar', 'Azalır (%10)', 'Değişmez', 'Önce artar sonra azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Oksijenli solunum denklemi?', options: ['Besin+O₂→CO₂+H₂O+ATP', 'CO₂+H₂O→Besin+O₂', 'Besin→Alkol+CO₂+ATP', 'Besin→Laktik Asit+ATP'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Sera etkisine sebep olan gaz?', options: ['O₂', 'N₂', 'CO₂', 'H₂'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi ayrıştırıcı (çürükçül)?', options: ['Papatya', 'Şapkalı Mantar', 'Çekirge', 'Kartal'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hamur mayalanmasında çıkan gaz?', options: ['O₂', 'H₂', 'CO₂', 'N₂'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Besin zinciri ilk basamak?', options: ['Etçil', 'Üretici', 'Mantar', 'Otçul'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fotosentez nerede?', options: ['Mitokondri', 'Koful', 'Kloroplast', 'Ribozom'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Fotosentez ürünü?', options: ['CO₂', 'Su', 'Işık', 'O₂'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Enerji piramidi: yukarı çıkınca?', options: ['Artar', 'Azalır', 'Değişmez', 'Artar-azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sera etkisi gazı?', options: ['O₂', 'N₂', 'CO₂', 'H₂'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Engelmann deneyi: Bakteriler en çok hangi ışıkta toplandı?', options: ['Sarı ve turuncu', 'Mor ve kırmızı', 'Yeşil ve mavi', 'Tüm renkler eşit'], correctIndex: 1, explanation: 'Fotosentez mor ve kırmızıda en hızlı', difficulty: 2),
    StemQuestion(question: 'Yaprak yarısı folyo ile kapatıldı. İyot damlası sadece açık kısımda mor. Kanıtlanan?', options: ['Su', 'CO₂', 'Işık', 'Klorofil'], correctIndex: 2, explanation: 'Işık olmadan fotosentez (nişasta üretimi) yok', difficulty: 2),
    StemQuestion(question: 'Cam fanusta bitki ve fare ışıkta uzun süre yaşıyor. Sebep?', options: ['Bitki CO₂ alır, fare O₂ alır', 'Fare bitkiyi yer', 'Cam ısıyı tutar', 'Bitki sadece gece solunum yapar'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Baklagil köklerindeki bakterilerin görevi?', options: ['Oksijen bağlama', 'Azotu bitkiye kullanılır hale getirme', 'Ölü organizmaları parçalama', 'Su emme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Biyokütlesi en fazla olan canlı?', options: ['Kartal', 'Yılan', 'Kurbağa', 'Ot (Üretici)'], correctIndex: 3, explanation: 'Üreticiler piramidin tabanı', difficulty: 1),
    StemQuestion(question: 'Serada fotosentez artırma ama yanlış olan?', options: ['CO₂ zenginleştirici', 'Yapay ışık (mor led)', 'Sıcaklık 50°C üstü', 'Düzenli sulama'], correctIndex: 2, explanation: 'Yüksek sıcaklık enzimleri bozar', difficulty: 2),
    StemQuestion(question: 'Fermantasyon: I.İnsan kasında olur II.Az enerji III.Her zaman CO₂ çıkar. Doğru?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 1, explanation: 'Laktik asitte CO₂ çıkmaz', difficulty: 2),
    StemQuestion(question: 'Asit yağmurlarının pH ve etkisi?', options: ['pH>7, bitkiyi besler', 'pH<5.6, eserlere zarar', 'pH=7, içme suyu', 'Sadece denizi etkiler'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çekirge azalırsa ot ve kurbağa?', options: ['Ot azalır, Kurbağa artar', 'Ot artar, Kurbağa azalır', 'Her ikisi artar', 'Her ikisi azalır'], correctIndex: 1, explanation: 'Otları yiyen az→Ot artar. Kurbağanın yiyeceği az→azalır', difficulty: 2),
    StemQuestion(question: 'Pipetle üflenen kireç suyu daha çabuk bulanıyor. Sebep?', options: ['Solukta bol CO₂ var', 'Nefes sıcak', 'Oksijen kireç suyunu bozar', 'Üfleyince su hareket eder'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Geri dönüşümün en önemli faydası?', options: ['Çöp alanları genişletme', 'Doğal kaynakları koruma ve enerji tasarrufu', 'Ürünleri pahalandırma', 'Plastik kullanımı artırma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sıcaklık artınca fotosentez hızı neden düşer?', options: ['Su buharlaşır', 'Işık yetersiz', 'Enzim yapısı bozulur', 'CO₂ biter'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Ozon tabakası incelmesinin sağlık etkisi?', options: ['Solunum yolu', 'Cilt kanseri ve katarakt', 'Kemik erimesi', 'Sindirim bozukluğu'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fotosentezde zamanla azalan madde çifti?', options: ['Glikoz ve O₂', 'CO₂ ve Su', 'Su ve O₂', 'Glikoz ve CO₂'], correctIndex: 1, explanation: 'CO₂ ve Su fotosentezde harcanır', difficulty: 1),
    StemQuestion(question: 'Sanayileşme→yaprak sararma ve mermer aşınması. Sebep?', options: ['Sera etkisi', 'Ozon incelmesi', 'Asit yağmurları', 'Biyolojik birikim'], correctIndex: 2, difficulty: 1),
  ],
  formulaCards: const [
    'Fotosentez: CO₂+H₂O→Glikoz+O₂ (Kloroplast)',
    'Solunum: Glikoz+O₂→CO₂+H₂O+ATP (Mitokondri)',
    'Enerji piramidi: Her basamakta %90 kayıp',
    'Laktik asit fermantasyonunda CO₂ çıkmaz!',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 6: (PLACEHOLDER - Basit Makineler unit title is used in unit list but content is about energy/environment mapped to U5, this is the actual U6 for Enerji)
// Note: This unit was labeled as "Basit Makineler" in unit definitions but the provided content
// covers "Enerji Dönüşümleri ve Çevre Bilimi" which was already added as U5 content.
// The unit definitions in sinif8FenUnits already have correct titles.
// Since the user provided content for 7 units with unit 5 being about Besin Zinciri/Fotosentez/Solunum,
// and unit 6 being separate, we need to check the mapping.
// Actually looking at the unit definitions:
// U5 = Basit Makineler, U6 = Enerji Dönüşümleri, U7 = Elektrik
// But the user's provided content labeled as "5. ÜNİTE: Basit Makineler" actually covers
// Besin Zinciri, Fotosentez, Solunum - which doesn't match "Basit Makineler" title.
// The content will be mapped as provided by the user regardless of title mismatch.
// ═══════════════════════════════════════════════════════════════

// The user did not provide separate content for "Enerji Dönüşümleri ve Çevre Bilimi" (U6).
// Since the "Basit Makineler" unit (U5 content) actually contains Besin Zinciri/Fotosentez content,
// we'll create a placeholder for U6 that references the environmental science topics.

final _s8FenU6Content = StemUnitContent(
  unitId: 's8_fen_u6',
  topic: const TopicContent(
    summary: 'Enerji dönüşümleri ve çevre bilimi: Enerji bir formdan diğerine dönüşür, toplam enerji korunur. Fosil yakıtlar çevre kirliliğine yol açar. Yenilenebilir enerji kaynakları (güneş, rüzgar, jeotermal) sürdürülebilir kalkınma için önemlidir.',
    rule: 'Enerji korunumu: Enerji yoktan var olmaz, vardan yok olmaz, sadece dönüşür.\nVerim = Yararlı Enerji / Toplam Enerji × 100\nFosil yakıtlar: Kömür, petrol, doğalgaz (yenilenemez)\nYenilenebilir: Güneş, rüzgar, su, jeotermal, biyokütle',
    formulas: [
      'Verim = (Yararlı Enerji / Toplam Enerji) × 100',
      'Enerji birimi: Joule (J), kWh',
    ],
    keyPoints: [
      'Enerji korunumu yasası: Toplam enerji sabittir',
      'Fosil yakıtlar sera gazı üretir',
      'Nükleer enerji: Çok güçlü ama atık sorunu var',
      'Sürdürülebilir kalkınma: Gelecek nesillerin ihtiyacını düşünmek',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Bir ampulde 100J elektrik enerjisi 20J ışık, 80J ısı enerjisine dönüşüyor. Verimi?',
      steps: ['Yararlı enerji: 20J (ışık)', 'Verim = 20/100 × 100 = %20'],
      answer: '%20',
    ),
    SolvedExample(
      question: 'Hangisi yenilenebilir enerji kaynağıdır: Kömür, Rüzgar, Petrol, Doğalgaz?',
      steps: ['Kömür, petrol, doğalgaz fosil yakıt', 'Rüzgar tükenmez ve yenilenebilir'],
      answer: 'Rüzgar',
    ),
    SolvedExample(
      question: 'Hidroelektrik santralde enerji dönüşüm sırası?',
      steps: ['Suyun potansiyel enerjisi', '→ kinetik enerji (su düşmesi)', '→ mekanik enerji (türbin dönmesi)', '→ elektrik enerjisi (jeneratör)'],
      answer: 'Potansiyel → Kinetik → Mekanik → Elektrik',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Hangisi yenilenebilir enerji kaynağı?', options: ['Kömür', 'Petrol', 'Güneş', 'Doğalgaz'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Enerji korunumu yasasına göre?', options: ['Enerji yok olabilir', 'Enerji yaratılabilir', 'Enerji sadece dönüşür', 'Enerji azalır'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Fosil yakıtların çevre etkisi?', options: ['Hava kirliliği ve sera etkisi', 'Ozon tabakasını kalınlaştırma', 'Biyoçeşitliliği artırma', 'Zararsızdır'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Nükleer enerjinin dezavantajı?', options: ['Az enerji üretmesi', 'Sera gazı çıkarması', 'Radyoaktif atık sorunu', 'Pahalı olmaması'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'LED ampulün dann ampule göre avantajı?', options: ['Daha çok ısı üretir', 'Daha az enerji harcar (yüksek verim)', 'Daha ucuzdur', 'Daha kısa ömürlüdür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Rüzgar enerjisi hangi enerji dönüşümünü kullanır?', options: ['Isı→Elektrik', 'Kinetik→Elektrik', 'Potansiyel→Işık', 'Kimyasal→Isı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sürdürülebilir kalkınma ne demektir?', options: ['Sadece bugünü düşünmek', 'Gelecek nesillerin ihtiyacını da gözetmek', 'Enerji kullanmamak', 'Fabrika kurmamak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Jeotermal enerji kaynağı?', options: ['Güneş', 'Rüzgar', 'Yer altı ısısı', 'Kömür'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Verim formülü?', options: ['Toplam/Yararlı×100', 'Yararlı/Toplam×100', 'Toplam×Yararlı', 'Yararlı-Toplam'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Biyokütle enerjisi neyi kullanır?', options: ['Rüzgarı', 'Güneşi', 'Organik atıkları', 'Suyu'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Yenilenebilir enerji?', options: ['Kömür', 'Petrol', 'Güneş', 'Doğalgaz'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Enerji korunumu?', options: ['Yok olur', 'Yaratılır', 'Sadece dönüşür', 'Azalır'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Nükleer dezavantaj?', options: ['Az enerji', 'Sera gazı', 'Radyoaktif atık', 'Ucuz değil'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Verim formülü?', options: ['T/Y×100', 'Y/T×100', 'T×Y', 'Y-T'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Jeotermal kaynak?', options: ['Güneş', 'Rüzgar', 'Yer altı ısısı', 'Kömür'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Bir elektrikli ısıtıcıda 1000J elektrik 800J ısıya, 200J ışığa dönüşüyor. Isıtıcının verimi?', options: ['%20', '%80', '%100', '%120'], correctIndex: 1, explanation: 'Yararlı=800J ısı. 800/1000×100=%80', difficulty: 2),
    StemQuestion(question: 'I.Kömür II.Rüzgar III.Güneş IV.Petrol. Hangiler yenilenemez?', options: ['I ve II', 'I ve IV', 'II ve III', 'III ve IV'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hidroelektrik santralde türbini döndüren?', options: ['Buhar', 'Rüzgar', 'Akan suyun kinetik enerjisi', 'Güneş ışığı'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'A ampulün verimi %10, B ampulün %40. Aynı ışığı vermek için hangisi daha çok enerji harcar?', options: ['A', 'B', 'Eşit', 'Bilinemez'], correctIndex: 0, explanation: 'Düşük verim=daha çok harcama', difficulty: 2),
    StemQuestion(question: 'Karbon ayak izini azaltmak için ne yapılmalı?', options: ['Daha çok araba kullanmak', 'Fosil yakıt tüketimini artırmak', 'Toplu taşıma ve yenilenebilir enerji', 'Ağaçları kesmek'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Güneş panelinde enerji dönüşümü?', options: ['Işık→Elektrik', 'Isı→Kinetik', 'Kimyasal→Işık', 'Elektrik→Isı'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Termik santrallerde kullanılan yakıt?', options: ['Uranyum', 'Su', 'Kömür/Doğalgaz', 'Rüzgar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Enerji tasarrufu sağlayan uygulama?', options: ['Lambaları açık bırakmak', 'A++ sınıfı beyaz eşya kullanmak', 'Klimayı sürekli çalıştırmak', 'Sıcak su israfı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nükleer santral kazasının en tehlikeli etkisi?', options: ['Gürültü', 'Hava kirliliği', 'Radyoaktif sızıntı ve uzun süreli kirlilik', 'Su kirliliği'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Biyogaz hangi kaynaktan elde edilir?', options: ['Kömürden', 'Petrolden', 'Hayvan gübresi ve organik atıktan', 'Güneşten'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Rüzgar türbinlerinin denize kurulmasının avantajı?', options: ['Daha ucuz olması', 'Denizde rüzgarın daha kararlı esmesi', 'Balıklara yardımcı olması', 'Görüntü kirliliği yaratması'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Ev tipi güneş kolektörleri hangi dönüşümü yapar?', options: ['Işık→Elektrik', 'Işık→Isı', 'Isı→Elektrik', 'Kimyasal→Isı'], correctIndex: 1, explanation: 'Kolektör ısıtma, panel elektrik üretir', difficulty: 2),
    StemQuestion(question: 'Enerji verimliliği arttıkça ne olur?', options: ['Daha çok enerji harcanır', 'Aynı iş daha az enerjiyle yapılır', 'Enerji kayıpları artar', 'Maliyet artar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Türkiye\'nin en çok yararlandığı yenilenebilir kaynak?', options: ['Güneş', 'Rüzgar', 'Hidroelektrik (su)', 'Jeotermal'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Sera gazı etkisini azaltmak için en etkili yöntem?', options: ['Orman alanlarını azaltmak', 'Fosil yakıt kullanımını azaltıp yenilenebilir enerjiye geçmek', 'Daha çok fabrika açmak', 'Plastik üretimini artırmak'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'Enerji korunumu: Toplam enerji sabittir, sadece dönüşür',
    'Verim = Yararlı Enerji / Toplam Enerji × 100',
    'Yenilenebilir: Güneş, Rüzgar, Su, Jeotermal, Biyokütle',
    'Yenilenemez: Kömür, Petrol, Doğalgaz, Nükleer',
  ],
);

// ═══════════════════════════════════════════════════════════════
// LGS FEN ÜNİTE 7: ELEKTRİK YÜKLERİ VE ELEKTRİK ENERJİSİ
// ═══════════════════════════════════════════════════════════════

final _s8FenU7Content = StemUnitContent(
  unitId: 's8_fen_u7',
  topic: const TopicContent(
    summary: 'Nötr cisim: (+) ve (-) yük eşit. Aynı yükler iter, zıt yükler çeker. Sürtünme ile: İki yalıtkan. Dokunma ile: Yükleri paylaşır (son yükler aynı işaret). Etki ile: Yaklaştırma (kutuplanma). Enerji dönüşümleri: Isı, ışık, hareket.',
    rule: 'Aynı yükler iter, zıt yükler çeker\nNötr cisimler yüklü cisimlerle çekilir\nDokunma: Toplam yük yarıçapa göre paylaşılır\nEnerji = Güç × Zaman (kWh)\nTopraklama: Cismi nötrler',
    formulas: [
      'Dokunma: Toplam yük / Toplam yarıçap',
      'Enerji = Güç(kW) × Zaman(saat)',
      'Maliyet = kWh × Birim fiyat',
    ],
    keyPoints: [
      'Cam+İpek: Cam(+), İpek(-)',
      'Ebonit+Yün: Ebonit(-), Yün(+)',
      'Elektroskop: Yük tespit aleti',
      'Paratoner: Yıldırımdan koruma',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'K(r, +10q) ve L(2r, -4q) dokundurulursa son yükler?',
      steps: ['Toplam yük: +10q+(-4q)=+6q', 'Toplam yarıçap: r+2r=3r', 'Her r başına: +6q/3r=+2q/r', 'K(r): +2q, L(2r): +4q'],
      answer: 'K: +2q, L: +4q',
    ),
    SolvedExample(
      question: '(-) yüklü elektroskopa yaklaştırılan K cismi yaprakları daha açıyorsa K\'nin yükü?',
      steps: ['Daha açılma = yapraklarda daha çok (-) yük', 'Topuzdaki (-)leri yapraklara iten: (-) yüklü cisim'],
      answer: 'Negatif (-) yüklü',
    ),
    SolvedExample(
      question: '2000W ısıtıcı günde 2 saat, 1kWh=2TL. 30 günlük maliyet?',
      steps: ['2000W=2kW', 'Günlük: 2kW×2h=4kWh', 'Aylık: 4×30=120kWh', 'Maliyet: 120×2=240TL'],
      answer: '240 TL',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Nötr cisim için doğru olan?', options: ['Hiç yükü yok', 'Sadece nötronları var', '(+) ve (-) yük eşit', 'Sadece elektronları var'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Cam çubuk ipek kumaşa sürtülünce cam?', options: ['Pozitif (+)', 'Negatif (-)', 'Nötr', 'Kutuplanmış'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Aynı cins yüklü cisimler?', options: ['Çeker', 'İter', 'Etki etmez', 'Döndürür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Elektroskop yaprakları kapalıysa?', options: ['Pozitif', 'Negatif', 'Nötr', 'Bozuk'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Elektriği hareket enerjisine çeviren?', options: ['Ütü', 'Ampul', 'Vantilatör', 'Tost makinesi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Binaları yıldırımdan koruyan?', options: ['Sigorta', 'Paratoner', 'Jeneratör', 'Transformatör'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fazla akımda atan güvenlik aracı?', options: ['Anahtar', 'Üretec', 'Sigorta', 'Direnç'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '(+) cisme (-) cisim dokunursa son durum?', options: ['Biri +, biri -', 'İkisi nötr', 'İkisi +', 'Toplam yüke bağlı'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'Topraklamanın amacı?', options: ['Elektriklendirmek', 'Nötrlemek', 'Elektrik üretmek', 'Yükü artırmak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Elektrik enerjisi birimi?', options: ['Watt', 'Newton', 'Joule/kWh', 'Amper'], correctIndex: 2, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Nötr cisim?', options: ['Yüksüz', 'Nötron', '(+)=(-)', 'Elektron'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Cam+İpek → Cam?', options: ['(+)', '(-)', 'Nötr', 'Kutuplu'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Aynı yükler?', options: ['Çeker', 'İter', 'Etki yok', 'Döndürür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Paratoner ne yapar?', options: ['Sigorta atar', 'Yıldırımdan korur', 'Elektrik üretir', 'Dönüştürür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Topraklama amacı?', options: ['Elektriklendirme', 'Nötrlemek', 'Üretmek', 'Artırmak'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Nötr elektroskopa (+) cisim yaklaştırılıyor (dokunmuyor). Topuz ve yaprak yükleri?', options: ['Topuz(+), Yaprak(-)', 'Topuz(-), Yaprak(+)', 'Topuz(-), Yaprak(-)', 'Topuz(+), Yaprak(+)'], correctIndex: 1, explanation: 'Etki ile: (+) topuzdaki (-)leri çeker, (+)ler yapraklara gider', difficulty: 2),
    StemQuestion(question: '(-) elektroskopa K cismi yaklaştırınca yapraklar biraz kapanıyor. K cismi; I.(+) II.Nötr III.(-) olabilir mi?', options: ['Yalnız I', 'I ve II', 'I ve III', 'Yalnız III'], correctIndex: 0, explanation: 'Kapanma=yük azalma. (+) cisim (-)leri çeker→yaprakta (-) azalır', difficulty: 3),
    StemQuestion(question: 'K(+) yüklü olduğu biliniyor. K, L\'yi itiyor. L, nötr M\'yi çekiyor. K ve L yükleri?', options: ['K(+), L(-)', 'K(-), L(-)', 'K(+), L(+)', 'K(-), L(+)'], correctIndex: 2, explanation: 'K L\'yi itiyor→aynı yük. K(+) ise L(+). L nötr M\'yi çeker (yüklü cisim nötrü çeker)', difficulty: 2),
    StemQuestion(question: 'Özdeş K(+10q) ve L(-2q) dokunuyor, sonra L nötr M\'ye. M\'nin son yükü?', options: ['+2q', '+4q', '+3q', '+q'], correctIndex: 0, explanation: 'K+L toplam=+8q. Özdeş→her biri +4q. L(+4q)+M(0)→her biri +2q', difficulty: 3),
    StemQuestion(question: 'Telin uzatılıp inceltilmesi: I.Direnç artar II.Akım azalır. Doğru?', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 1, explanation: 'Uzun+ince tel→direnç artar→akım azalır', difficulty: 2),
    StemQuestion(question: '(-) ebonit çubuk nötr kağıtları neden çeker?', options: ['Kağıtlar (+)', 'Etki ile kutuplayıp çeker', 'Mıknatıs özelliği', 'Yerçekimi azalır'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: '(+) cisim topraklanıyor. Elektron hareketi?', options: ['Cisimden toprağa (+)', 'Topraktan cisme (+)', 'Cisimden toprağa (-)', 'Topraktan cisme (-)'], correctIndex: 3, explanation: '(+) cisim elektron eksiği var. Toprak elektron verir', difficulty: 2),
    StemQuestion(question: 'Elektrik→ısı dönüşümünün istenmeyen olduğu cihaz?', options: ['Ütü', 'Tost makinesi', 'Elektrikli soba', 'Vantilatör'], correctIndex: 3, explanation: 'Vantilatörde motor ısınması verim kaybıdır', difficulty: 2),
    StemQuestion(question: 'A++ buzdolabının avantajı?', options: ['Daha iyi soğutma', 'Daha sessiz', 'Aynı işi daha az enerjiyle', 'Daha ucuz'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Yüklü elektroskopa zıt yüklü cisim dokundurulunca yapraklar ne yapamaz?', options: ['Biraz kapanır', 'Tamamen kapanır', 'Önce kapanıp sonra açılır', 'Daha çok açılır'], correctIndex: 3, explanation: 'Zıt yük nötrler veya azaltır, daha çok açılamaz', difficulty: 2),
    StemQuestion(question: 'Sigorta neden atar?', options: ['Ampul patlaması', 'Paralel ampul→aşırı akım', 'Pil azaltma', 'Kablo kopması'], correctIndex: 1, explanation: 'Paralel bağlantı akımı artırır', difficulty: 2),
    StemQuestion(question: '(-) K cismi nötr L çubuğunun X ucuna yaklaştırılıyor. Y ucu topraklı. Toprak kesilip K uzaklaştırılırsa L?', options: ['Nötr', '(-) yüklü', '(+) yüklü', 'X(-), Y(+)'], correctIndex: 2, explanation: 'K(-) X\'i (+), Y\'yi (-) kutuplar. Toprak (-)leri çeker. Toprak kesilip K gidince L\'de (+) kalır', difficulty: 3),
    StemQuestion(question: 'Ev aletleri aynı anda çalışınca sayaç neden hızlanır?', options: ['Voltaj artar', 'Direnç artar', 'Toplam akım ve güç artar', 'Kablolar ısınır'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'K en parlak, L ve M eşit ve sönük. Bağlantı?', options: ['Hepsi seri', 'Hepsi paralel', 'K ana kol, L-M paralel', 'K-L seri, M paralel'], correctIndex: 2, explanation: 'Ana kol tüm akımı alır (en parlak)', difficulty: 2),
    StemQuestion(question: 'Elektroskop yaprakları "önce kapanıp sonra açılması" ne zaman olur?', options: ['Aynı yüklü dokunma', 'Nötr dokunma', 'Zıt ve fazla yüklü dokunma', 'Zıt ve az yüklü dokunma'], correctIndex: 2, explanation: 'Önce nötrler (kapanır), fazla yük ters işaretle açar', difficulty: 3),
  ],
  formulaCards: const [
    'Aynı yükler iter, zıt yükler çeker',
    'Dokunma: Toplam yük / Toplam yarıçap ile paylaşım',
    'Enerji = Güç(kW) × Zaman(saat) → kWh',
    'Topraklama: Cismi nötrler (yüksüz yapar)',
  ],
);
