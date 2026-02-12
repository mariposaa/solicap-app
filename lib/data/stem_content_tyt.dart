// SOLICAP - TYT STEM İçerik Veritabanı
// TYT Matematik (15), TYT Fizik (7), TYT Kimya (7), TYT Biyoloji (6) = 35 Ünite
// Ders Akışı: Konu Hatırlatma → Çözümlü Örnekler → Mini Deneme (15 soru)

import '../models/stem_models.dart';

// ═══════════════════════════════════════════════════════════════
// TYT 3 AŞAMALI DERS AKIŞI (Sınava Hazırlık Modu)
// ═══════════════════════════════════════════════════════════════

const List<StemLessonType> _tytLessonOrder = [
  StemLessonType.topicExplanation, // Kısa konu hatırlatma
  StemLessonType.solvedExamples,   // 3 çözümlü örnek
  StemLessonType.topicExam,        // 15 soru mini deneme
];

// ═══════════════════════════════════════════════════════════════
// TYT MATEMATİK ÜNİTELERİ (15 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> tytMatUnits = [
  StemUnit(
    id: 'tyt_mat_u1',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 1,
    title: 'Temel Kavramlar',
    titleTr: 'Temel Kavramlar (Sayılar, Bölünebilme, OBEB-OKEK)',
    icon: '🔢',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u2',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 2,
    title: 'Birinci Dereceden Denklemler',
    titleTr: 'Birinci Dereceden Denklemler ve Eşitsizlikler',
    icon: '📏',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u3',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 3,
    title: 'Mutlak Değer',
    titleTr: 'Mutlak Değer',
    icon: '|x|',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u4',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 4,
    title: 'Üslü ve Köklü Sayılar',
    titleTr: 'Üslü ve Köklü Sayılar',
    icon: '√',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u5',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 5,
    title: 'Oran, Orantı ve Yüzde',
    titleTr: 'Oran, Orantı ve Yüzde',
    icon: '%',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u6',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 6,
    title: 'Problemler',
    titleTr: 'Problemler (Yaş, İşçi, Karışım, Hareket)',
    icon: '🧩',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u7',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 7,
    title: 'Kümeler',
    titleTr: 'Kümeler',
    icon: '∩',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u8',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 8,
    title: 'Fonksiyonlar',
    titleTr: 'Fonksiyonlar (Temel)',
    icon: 'f(x)',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u9',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 9,
    title: 'Polinomlar',
    titleTr: 'Polinomlar (Temel)',
    icon: 'P(x)',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u10',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 10,
    title: 'Permütasyon, Kombinasyon, Olasılık',
    titleTr: 'Permütasyon, Kombinasyon ve Olasılık',
    icon: '🎲',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u11',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 11,
    title: 'Veri ve İstatistik',
    titleTr: 'Veri ve İstatistik',
    icon: '📊',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u12',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 12,
    title: 'Üçgenler ve Geometrik Cisimler',
    titleTr: 'Üçgenler ve Geometrik Cisimler',
    icon: '📐',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u13',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 13,
    title: 'Dörtgenler ve Çokgenler',
    titleTr: 'Dörtgenler, Çokgenler',
    icon: '⬠',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u14',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 14,
    title: 'Çember ve Daire',
    titleTr: 'Çember ve Daire',
    icon: '⭕',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_mat_u15',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.matematik,
    order: 15,
    title: 'Analitik Geometri',
    titleTr: 'Analitik Geometri (Temel - Doğru Denklemleri)',
    icon: '📈',
    lessonOrder: _tytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// TYT FİZİK ÜNİTELERİ (7 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> tytFizUnits = [
  StemUnit(
    id: 'tyt_fiz_u1',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 1,
    title: 'Fizik Bilimine Giriş',
    titleTr: 'Fizik Bilimine Giriş (Birimler, Vektörler)',
    icon: '📏',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u2',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 2,
    title: 'Kuvvet ve Hareket',
    titleTr: 'Kuvvet ve Hareket',
    icon: '🏃',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u3',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 3,
    title: 'Enerji',
    titleTr: 'Enerji (İş, Güç, Enerji)',
    icon: '⚡',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u4',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 4,
    title: 'Isı ve Sıcaklık',
    titleTr: 'Isı ve Sıcaklık',
    icon: '🌡️',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u5',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 5,
    title: 'Basınç',
    titleTr: 'Basınç (Katı, Sıvı, Gaz)',
    icon: '⬇️',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u6',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 6,
    title: 'Elektrik',
    titleTr: 'Elektrik (Temel Devreler)',
    icon: '🔌',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_fiz_u7',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.fizik,
    order: 7,
    title: 'Dalgalar',
    titleTr: 'Dalgalar (Ses ve Işık Temelleri)',
    icon: '🌊',
    lessonOrder: _tytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// TYT KİMYA ÜNİTELERİ (7 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> tytKimUnits = [
  StemUnit(
    id: 'tyt_kim_u1',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 1,
    title: 'Kimya Bilimi ve Atom Yapısı',
    titleTr: 'Kimya Bilimi ve Atom Yapısı',
    icon: '⚛️',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u2',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 2,
    title: 'Periyodik Sistem',
    titleTr: 'Periyodik Sistem',
    icon: '📋',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u3',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 3,
    title: 'Kimyasal Bağlar',
    titleTr: 'Kimyasal Türler Arası Etkileşimler (Bağlar)',
    icon: '🔗',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u4',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 4,
    title: 'Maddenin Halleri',
    titleTr: 'Maddenin Halleri',
    icon: '🧊',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u5',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 5,
    title: 'Kimyasal Tepkimeler',
    titleTr: 'Kimyasal Tepkimeler (Denkleştirme, Mol)',
    icon: '⚗️',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u6',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 6,
    title: 'Asitler, Bazlar ve Tuzlar',
    titleTr: 'Asitler, Bazlar ve Tuzlar',
    icon: '🧪',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_kim_u7',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.kimya,
    order: 7,
    title: 'Karışımlar ve Çözeltiler',
    titleTr: 'Karışımlar ve Çözeltiler',
    icon: '🫗',
    lessonOrder: _tytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// TYT BİYOLOJİ ÜNİTELERİ (6 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> tytBioUnits = [
  StemUnit(
    id: 'tyt_bio_u1',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 1,
    title: 'Canlıların Ortak Özellikleri ve Hücre',
    titleTr: 'Canlıların Ortak Özellikleri ve Hücre',
    icon: '🔬',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_bio_u2',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 2,
    title: 'Canlı Çeşitliliği',
    titleTr: 'Canlı Çeşitliliği (Sınıflandırma)',
    icon: '🌿',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_bio_u3',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 3,
    title: 'Ekosistem Ekolojisi',
    titleTr: 'Ekosistem Ekolojisi',
    icon: '🌍',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_bio_u4',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 4,
    title: 'Kalıtım',
    titleTr: 'Kalıtım (Temel Genetik)',
    icon: '🧬',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_bio_u5',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 5,
    title: 'Bitki ve Hayvan Biyolojisi',
    titleTr: 'Bitki ve Hayvan Biyolojisi',
    icon: '🌱',
    lessonOrder: _tytLessonOrder,
  ),
  StemUnit(
    id: 'tyt_bio_u6',
    gradeLevel: GradeLevel.tyt,
    subject: StemSubject.biyoloji,
    order: 6,
    title: 'İnsan Fizyolojisi',
    titleTr: 'İnsan Fizyolojisi (Temel Sistemler)',
    icon: '❤️',
    lessonOrder: _tytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// TYT İÇERİK HARİTASI
// ═══════════════════════════════════════════════════════════════

// Placeholder içerik üreteci - Kullanıcı gerçek içeriği sağladığında güncellenecek
StemUnitContent _makeTytPlaceholder(String unitId, String topicTitle) {
  return StemUnitContent(
    unitId: unitId,
    topic: TopicContent(
      summary: '$topicTitle - TYT sınav hatırlatma özeti. İçerik yakında eklenecek.',
      rule: '$topicTitle ile ilgili temel kurallar ve formüller burada yer alacak.',
      formulas: ['İçerik hazırlanıyor...'],
      keyPoints: ['İçerik hazırlanıyor...'],
    ),
    solvedExamples: const [
      SolvedExample(
        question: 'Çözümlü örnek yakında eklenecek.',
        steps: ['Adım 1: İçerik hazırlanıyor...'],
        answer: 'İçerik hazırlanıyor...',
      ),
    ],
    practiceQuestions: const [],
    examQuestions: const [
      StemQuestion(
        question: 'Mini deneme sorusu yakında eklenecek.',
        options: ['A) -', 'B) -', 'C) -', 'D) -'],
        correctIndex: 0,
        explanation: 'İçerik hazırlanıyor...',
        difficulty: 2,
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
// TYT MATEMATİK İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

final _tytMatU1Content = StemUnitContent(
  unitId: 'tyt_mat_u1',
  topic: const TopicContent(
    summary:
        'Bu konu matematiğin alfabesidir. Sayı kümelerini (Doğal Sayılar N, Tam Sayılar Z, Rasyonel Sayılar Q, Reel Sayılar R) çok iyi ayırt etmelisin. '
        'Özellikle "Sıfır" (0) sayısının doğal sayı olduğu ama pozitif tam sayı olmadığı unutulmamalıdır. '
        'Asal sayılar (2, 3, 5, 7...) sadece 1 ve kendisine bölünebilen, 1\'den büyük sayılardır. En küçük ve tek çift asal sayı 2\'dir.',
    rule:
        'Tek + Tek = Çift, Tek + Çift = Tek, Çift + Çift = Çift. '
        'Tek × Tek = Tek, diğer tüm çarpımlar Çifttir.\n'
        'Ardışık Sayılar Toplamı: 1\'den n\'ye kadar = n(n+1)/2.\n'
        'EBOB ve EKOK: İki sayının çarpımı = EBOB(a,b) × EKOK(a,b).\n'
        'EBOB → Büyük parçaları küçük eşit parçalara bölme (torba, parsel).\n'
        'EKOK → Küçük parçaları birleştirme, zaman soruları (nöbet, zil, buluşma).',
    formulas: [
      'Ardışık n sayının toplamı: n(n+1)/2',
      'İki sayının çarpımı = EBOB(a,b) × EKOK(a,b)',
      '2 ile bölünme: Son basamak çift (0,2,4,6,8)',
      '3 ile bölünme: Rakamlar toplamı 3\'ün katı',
      '4 ile bölünme: Son iki basamak 00 veya 4\'ün katı',
      '5 ile bölünme: Son basamak 0 veya 5',
      '9 ile bölünme: Rakamlar toplamı 9\'un katı',
      '10 ile bölünme: Son basamak 0',
    ],
    keyPoints: [
      'Soru kökünde "tam sayı" diyorsa negatifleri unutma! "Rakam" diyorsa 0-9 arası.',
      'Bölünebilme sorularında önce 5 veya 10 (son basamak) kuralına bak, sonra 3 veya 9\'a geç.',
      '"Birlikte ne zaman tekrar karşılaşırlar?" soruları her zaman EKOK sorusudur.',
      '0 doğal sayıdır ama pozitif tam sayı değildir. 1 ne asal ne bileşiktir.',
      'En küçük ve tek çift asal sayı 2\'dir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'a ve b birbirinden farklı rakamlardır. 3a + 4b ifadesinin alabileceği en büyük değer kaçtır?',
      steps: [
        'Adım 1: İfadenin en büyük olması için katsayısı büyük olan harfe en büyük rakamı vermeliyiz.',
        'Adım 2: b\'nin katsayısı 4 olduğu için b = 9 seçilir.',
        'Adım 3: "Farklı rakamlar" dediği için a\'ya 9 veremeyiz. En büyük kalan rakam 8\'dir, a = 8.',
        'Adım 4: 3×8 + 4×9 = 24 + 36 = 60.',
      ],
      answer: '60',
    ),
    SolvedExample(
      question:
          'Dört basamaklı 2a5b sayısı 10 ile tam bölünebilmekte ve 3 ile bölümünden kalan 1 olmaktadır. Buna göre a kaç farklı değer alır?',
      steps: [
        'Adım 1: 10 ile tam bölünüyorsa son basamak (b) kesinlikle 0\'dır. Sayı: 2a50 oldu.',
        'Adım 2: 3 ile bölümünden kalan 1 ise, rakamlar toplamı 3\'ün katından 1 fazla olmalıdır.',
        'Adım 3: 2 + a + 5 + 0 = 7 + a. Bu toplamın (3k + 1) olması gerekir.',
        'Adım 4: 7 + a ≡ 1 (mod 3) → a ≡ 0 (mod 3). a = 0, 3, 6, 9 olabilir.',
      ],
      answer: '4 farklı değer (a = 0, 3, 6, 9)',
    ),
    SolvedExample(
      question:
          '60 kg pirinç ve 72 kg mercimek birbirine karıştırılmadan hiç artmayacak şekilde eşit büyüklükteki torbalara doldurulacaktır. En az kaç torba gerekir?',
      steps: [
        'Adım 1: Büyük miktarları küçük torbalara "bölüyoruz" → EBOB kullanacağız.',
        'Adım 2: EBOB(60, 72) = 12. Demek ki bir torba en çok 12 kg alabilir.',
        'Adım 3: Torba sayısı = (60 / 12) + (72 / 12) = 5 + 6 = 11.',
      ],
      answer: '11 torba',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: 'İki basamaklı en küçük asal sayı ile iki basamaklı en büyük asal sayının toplamı kaçtır?',
      options: ['A) 108', 'B) 110', 'C) 112', 'D) 109'],
      correctIndex: 0,
      explanation: 'En küçük iki basamaklı asal: 11. En büyük iki basamaklı asal: 97. 11 + 97 = 108.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'x, y, z birer tam sayıdır. x·y = 13 ve y·z = 17 ise x + y + z toplamı kaçtır?',
      options: ['A) 31', 'B) 29', 'C) 1', 'D) 30'],
      correctIndex: 0,
      explanation: '13 ve 17 asaldır, ortak çarpan y = 1 olmak zorundadır. x = 13, z = 17. Toplam: 13 + 1 + 17 = 31.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi kesinlikle çift sayıdır?',
      options: ['A) 3^15 + 2', 'B) 5! + 7', 'C) 4^10 + 5^10', 'D) 2023! + 2024!'],
      correctIndex: 3,
      explanation: 'Faktöriyellerde 2! ve sonrası hep çifttir. Çift + Çift = Çift.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '3 basamaklı 4A2 sayısı 3 ile tam bölünebiliyorsa, A yerine yazılabilecek rakamların toplamı kaçtır?',
      options: ['A) 9', 'B) 12', 'C) 15', 'D) 18'],
      correctIndex: 3,
      explanation: '4 + A + 2 = 6 + A. Bu toplamın 3\'ün katı olması için A = 0, 3, 6, 9 olabilir. Toplam: 0 + 3 + 6 + 9 = 18.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '120 sayısının asal çarpanlarına ayrılmış hali aşağıdakilerden hangisidir?',
      options: ['A) 2³ × 3 × 5', 'B) 2² × 3² × 5', 'C) 2³ × 3²', 'D) 2 × 3 × 5²'],
      correctIndex: 0,
      explanation: '120/2=60, 60/2=30, 30/2=15, 15/3=5, 5/5=1. Yani 2³ × 3 × 5.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question: 'x ve y pozitif tam sayılardır. 3x + 5y = 66 olduğuna göre, x\'in alabileceği kaç farklı değer vardır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 1,
      explanation: 'y = 3 → x = 17, y = 6 → x = 12, y = 9 → x = 7, y = 12 → x = 2. Toplam 4 değer.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'A = 1·2 + 2·3 + 3·4 + ... + 20·21 toplamındaki her bir terimin birinci çarpanı 1 artırılırsa, A sayısı kaç artar?',
      options: ['A) 210', 'B) 230', 'C) 420', 'D) 462'],
      correctIndex: 1,
      explanation: 'Birinci çarpana 1 eklemek, o terime ikinci çarpan kadar eklemek demektir. Artış = 2 + 3 + 4 + ... + 21 = (21×22/2) − 1 = 230.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Boyutları 18 cm, 24 cm ve 30 cm olan dikdörtgenler prizması şeklindeki kutular yan yana ve üst üste dizilerek en küçük hacimli bir küp yapılacaktır. Bu iş için kaç kutu gerekir?',
      options: ['A) 1200', 'B) 1800', 'C) 3600', 'D) 7200'],
      correctIndex: 2,
      explanation: 'EKOK(18,24,30) = 360 cm. Küp kenarı 360 cm. Kutu sayısı = (360/18)×(360/24)×(360/30) = 20×15×12 = 3600.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Rakamları farklı beş basamaklı 3x41y sayısı 4 ve 9 ile tam bölünebildiğine göre x kaç farklı değer alır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 0,
      explanation: '4 ile bölünme: "1y" → y = 2 veya y = 6. y = 2: toplam 10+x, 9\'un katı → x = 8. y = 6: toplam 14+x → x = 4 ama sayıda zaten 4 var (rakamlar farklı kuralı bozulur). Sadece x = 8.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Bir duraktan hareket eden üç dolmuş sırasıyla 15, 20 ve 25 dakikada bir sefer yapmaktadır. Üçü birlikte ilk kez 08:00\'de hareket ettiğine göre, ikinci kez saat kaçta birlikte hareket ederler?',
      options: ['A) 11:00', 'B) 12:00', 'C) 13:00', 'D) 13:30'],
      correctIndex: 2,
      explanation: 'EKOK(15,20,25) = 300 dakika = 5 saat. 08:00 + 5 saat = 13:00.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question: 'a, b, c asal sayılardır. a = 13^(b−c) olduğuna göre a + b + c toplamı kaçtır?',
      options: ['A) 16', 'B) 18', 'C) 20', 'D) 24'],
      correctIndex: 1,
      explanation: 'a\'nın asal olması için 13^(b−c) = 13 → b − c = 1. Aralarındaki fark 1 olan asallar: 3 ve 2. b = 3, c = 2, a = 13. Toplam: 18.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '1\'den 50\'ye kadar olan sayıların çarpımı N = 50! sayısının sondan kaç basamağı sıfırdır?',
      options: ['A) 10', 'B) 12', 'C) 14', 'D) 15'],
      correctIndex: 1,
      explanation: 'Sondaki sıfır sayısı = 5\'in kuvvetlerine bölümlerin toplamı: 50/5 = 10, 10/5 = 2. Toplam: 12.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bir merdivenin basamaklarını üçer üçer çıkıp ikişer ikişer inen bir kişinin inerken attığı adım sayısı, çıkarken attığı adım sayısından 6 fazladır. Merdiven kaç basamaklıdır?',
      options: ['A) 24', 'B) 30', 'C) 36', 'D) 42'],
      correctIndex: 2,
      explanation: 'Basamak sayısı x olsun. x/2 − x/3 = 6 → x/6 = 6 → x = 36.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'x ve y pozitif tam sayılardır. EBOB(x,y) = 6 ve x·y = 720 olduğuna göre, x + y toplamının alabileceği en küçük değer kaçtır?',
      options: ['A) 48', 'B) 54', 'C) 66', 'D) 72'],
      correctIndex: 1,
      explanation: 'x = 6a, y = 6b (a,b aralarında asal). 36ab = 720 → ab = 20. En yakın çift: a = 4, b = 5. x = 24, y = 30. Toplam: 54.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bir A doğal sayısı 12 ile bölündüğünde 7, 15 ile bölündüğünde 10 kalanını vermektedir. A\'nın 180 ile bölümünden kalan kaçtır?',
      options: ['A) 170', 'B) 175', 'C) 177', 'D) 179'],
      correctIndex: 1,
      explanation: 'A + 5 hem 12 hem 15\'in katıdır. EKOK(12,15) = 60. A = 60k − 5. 180 ile bölümde kalan: A mod 180 = 175 (k = 3 için A = 175).',
      difficulty: 3,
    ),
  ],
);
final _tytMatU2Content = StemUnitContent(
  unitId: 'tyt_mat_u2',
  topic: const TopicContent(
    summary:
        'Bu konu, bilinmeyenleri (x, y gibi) bulma sanatıdır. "Eşittir" (=) varsa denklem, "küçüktür/büyüktür" (<, >, ≤, ≥) varsa eşitsizliktir. '
        'Denklemlerde amaç x\'i yalnız bırakmaktır. Eşitsizliklerde ise çözüm genellikle bir sayı değil, bir "aralık"tır.',
    rule:
        'Denklem Çözme: ax + b = 0 ise x = −b/a. Bilinenler bir tarafa, bilinmeyenler diğer tarafa atılır, yer değiştiren terim işaret değiştirir.\n'
        'Eşitsizlik Kuralları:\n'
        '• Her iki tarafa aynı sayı eklenip çıkarılabilir, yön değişmez.\n'
        '• Pozitif sayıyla çarp/böl → yön değişmez.\n'
        '• NEGATİF sayıyla çarp/böl → eşitsizlik YÖN DEĞİŞTİRİR (< ise > olur).\n'
        'Özel Durumlar: 0x = 0 ise Ç.K. = R (sonsuz çözüm). 0x = 5 ise Ç.K. = ∅ (çözüm yok).',
    formulas: [
      'ax + b = 0 → x = −b/a',
      'Negatif sayıyla çarpınca eşitsizlik yönü değişir',
      '0x = 0 → Ç.K. = R (tüm reel sayılar)',
      '0x = k (k≠0) → Ç.K. = ∅ (boş küme)',
    ],
    keyPoints: [
      '"x bir tam sayı" diyorsa değer vererek çöz. "x bir reel sayı" diyorsa aralık yöntemiyle çöz.',
      'x² < x olan sayılar 0 ile 1 arasındadır (0 < x < 1).',
      'Eşitsizliklerde taraf tarafa toplama yapılır ama çıkarma ve çarpma yapılmaz!',
      'Negatif sayıyla çarpınca/bölünce eşitsizlik yönü değişir - en sık yapılan hata!',
      'Aralık sorularında uç noktaların "dahil mi değil mi" olduğuna dikkat et (< vs ≤).',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2(3x − 1) − 3(x + 2) = 10 ise x kaçtır?',
      steps: [
        'Adım 1: Parantezleri dağıt → 6x − 2 − 3x − 6 = 10',
        'Adım 2: Benzer terimleri topla → 3x − 8 = 10',
        'Adım 3: −8\'i karşıya at → 3x = 18',
        'Adım 4: x = 18/3 = 6',
      ],
      answer: 'x = 6',
    ),
    SolvedExample(
      question: '−3 < 2x − 5 ≤ 7 eşitsizliğini sağlayan x tam sayılarının toplamı kaçtır?',
      steps: [
        'Adım 1: Her tarafa +5 ekle → 2 < 2x ≤ 12',
        'Adım 2: Her tarafı 2\'ye böl (pozitif, yön değişmez) → 1 < x ≤ 6',
        'Adım 3: Tam sayılar: 2, 3, 4, 5, 6 (6 dahil çünkü ≤, 1 dahil değil çünkü <)',
      ],
      answer: '2 + 3 + 4 + 5 + 6 = 20',
    ),
    SolvedExample(
      question:
          'Bir su deposunun yarısı doludur. Depoya 20 litre daha su eklenince deponun 2/3\'ü doluyor. Deponun tamamı kaç litre su alır?',
      steps: [
        'Adım 1: Deponun tamamına x diyelim. Başlangıçta x/2 dolu.',
        'Adım 2: Denklemi kur: x/2 + 20 = 2x/3',
        'Adım 3: x\'leri bir tarafa topla: 20 = 2x/3 − x/2',
        'Adım 4: Payda eşitle (6\'da): 20 = (4x − 3x)/6 = x/6',
      ],
      answer: 'x = 120 Litre',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: '4x − 12 = 0 denkleminin çözüm kümesi nedir?',
      options: ['A) {2}', 'B) {3}', 'C) {4}', 'D) {−3}'],
      correctIndex: 1,
      explanation: '4x = 12 → x = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Aşağıdakilerden hangisi birinci dereceden bir denklemdir?',
      options: ['A) x² + 3x = 5', 'B) 2x + 5 = 11', 'C) x + y + z = 10', 'D) 1/x + 2 = 3'],
      correctIndex: 1,
      explanation: 'x\'in kuvveti 1 olmalıdır. A\'da kare var, C\'de 3 bilinmeyen, D\'de x paydada (x⁻¹).',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          '"Bir sayının 3 katının 5 fazlası, aynı sayının 2 katının 10 eksiğine eşittir" cümlesinin matematiksel karşılığı nedir?',
      options: [
        'A) 3(x+5) = 2(x−10)',
        'B) 3x + 5 = 2x − 10',
        'C) 3x + 5 = 2(x−10)',
        'D) 3x − 5 = 2x + 10',
      ],
      correctIndex: 1,
      explanation: '3 katının 5 fazlası: 3x + 5. 2 katının 10 eksiği: 2x − 10.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'x bir doğal sayı olmak üzere, 3x − 1 < 11 eşitsizliğini sağlayan kaç farklı x değeri vardır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 1,
      explanation: '3x < 12 → x < 4. Doğal sayılar: x = {0, 1, 2, 3}. Toplam 4 tane (0\'ı unutma!).',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'a < b < 0 olduğuna göre aşağıdakilerden hangisi kesinlikle pozitiftir?',
      options: ['A) a + b', 'B) a·b', 'C) a/b', 'D) a − b'],
      correctIndex: 1,
      explanation: 'İkisi de negatif. Negatif × Negatif = Pozitif.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          '(a−2)x + 3 = 2x + b denkleminin çözüm kümesi tüm reel sayılar ise (a + b) kaçtır?',
      options: ['A) 4', 'B) 5', 'C) 6', 'D) 7'],
      correctIndex: 3,
      explanation:
          'Tüm reel sayılar için: x\'li katsayılar eşit olmalı → a−2 = 2 → a = 4. Sabitler de eşit → 3 = b. Toplam: 4 + 3 = 7.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'x ve y birer tam sayıdır. −3 < x < 5 ve −2 < y < 4 olduğuna göre, 2x − 3y ifadesinin alabileceği en büyük tam sayı değeri kaçtır?',
      options: ['A) 8', 'B) 11', 'C) 14', 'D) 17'],
      correctIndex: 1,
      explanation:
          'En büyük için: x en büyük (4), y en küçük (−1). 2×4 − 3×(−1) = 8 + 3 = 11.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'x² < x olmak üzere, 5x + 2 ifadesinin alabileceği tam sayı değerleri toplamı kaçtır?',
      options: ['A) 12', 'B) 15', 'C) 18', 'D) 20'],
      correctIndex: 2,
      explanation:
          'x² < x → 0 < x < 1. 5 ile çarp: 0 < 5x < 5. 2 ekle: 2 < 5x+2 < 7. Tam sayılar: 3, 4, 5, 6. Toplam: 18.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '1/x + 1/y = 1/4 ve 1/x − 1/y = 1/12 ise x kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 6', 'D) 8'],
      correctIndex: 2,
      explanation: 'Taraf tarafa topla: 2/x = 1/4 + 1/12 = 4/12 = 1/3. x = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Bir otelde 2 yataklı ve 3 yataklı toplam 20 oda vardır. Toplam yatak kapasitesi 48 olduğuna göre 3 yataklı oda sayısı kaçtır?',
      options: ['A) 6', 'B) 8', 'C) 10', 'D) 12'],
      correctIndex: 1,
      explanation:
          '3 yataklı = x, 2 yataklı = 20−x. 3x + 2(20−x) = 48 → x + 40 = 48 → x = 8.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'a < b olmak üzere a·b < 0, b·c > 0, a·c < 0 ise a, b, c\'nin işaretleri sırasıyla hangisidir?',
      options: ['A) +, −, −', 'B) −, +, +', 'C) −, −, +', 'D) +, −, +'],
      correctIndex: 1,
      explanation:
          'a·b < 0 → a ve b zıt işaretli. a < b ise a negatif, b pozitif olmalı. b·c > 0 → c de pozitif. İşaretler: −, +, +.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'x gerçel sayısı için −2 < x < 3 olduğuna göre, x² + 1 ifadesinin alabileceği en geniş değer aralığı nedir?',
      options: ['A) (1, 10)', 'B) [1, 10)', 'C) (5, 10)', 'D) (1, 5)'],
      correctIndex: 1,
      explanation:
          'Aralıkta 0 var, x = 0 için x² = 0 (minimum). |3| > |−2| olduğu için x² < 9. Dolayısıyla 1 ≤ x² + 1 < 10 → [1, 10).',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'A ve B şehirleri arası 400 km\'dir. A\'dan hızı (2v+10) km/h, B\'den hızı (3v−20) km/h olan iki araç birbirine doğru hareket edip 2 saat sonra karşılaşıyorlar. v kaçtır?',
      options: ['A) 40', 'B) 42', 'C) 45', 'D) 50'],
      correctIndex: 1,
      explanation:
          'Zıt yönde hızlar toplanır: (2v+10)+(3v−20) = 5v−10. Yol = Hız×Zaman: 400 = (5v−10)×2 → 200 = 5v−10 → v = 42.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '2x + a = 3(x − 2) denklemini sağlayan x değeri pozitif ise a\'nın alabileceği en küçük tam sayı değeri kaçtır?',
      options: ['A) −7', 'B) −6', 'C) −5', 'D) 5'],
      correctIndex: 2,
      explanation: '2x + a = 3x − 6 → x = a + 6. x > 0 → a > −6. En küçük tam sayı: −5.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'a ve b birer reel sayıdır. −4 < a < 2 ve 3 < b < 5 olduğuna göre a·b çarpımının değer aralığı aşağıdakilerden hangisidir?',
      options: ['A) (−20, 10)', 'B) (−12, 10)', 'C) (−20, 6)', 'D) (−12, 6)'],
      correctIndex: 0,
      explanation:
          'Uç noktaları çarp: (−4)×5 = −20, (−4)×3 = −12, 2×3 = 6, 2×5 = 10. En küçük −20, en büyük 10 → (−20, 10).',
      difficulty: 3,
    ),
  ],
);
final _tytMatU3Content = StemUnitContent(
  unitId: 'tyt_mat_u3',
  topic: const TopicContent(
    summary:
        'Mutlak değer, bir sayının sayı doğrusu üzerinde 0\'a olan uzaklığıdır. Uzaklık negatif olamaz, bu yüzden mutlak değerin sonucu ya 0\'dır ya da pozitiftir. '
        '|x| ifadesi, x pozitifse aynen çıkar (x), x negatifse önüne eksi alarak çıkar (−x) ki sonuç pozitif olsun.',
    rule:
        'Tanım: |x| ≥ 0 (her zaman)\n'
        'İşaret: |−x| = |x| ve |x − y| = |y − x|\n'
        'Kök Dışına Çıkarma: √(x²) = |x|\n'
        'Denklem: |x| = a (a > 0) ise x = a veya x = −a\n'
        'Eşitsizlik: |x| < a ise −a < x < a, |x| > a ise x > a veya x < −a\n'
        '|x| < (negatif sayı) → Çözüm kümesi boş küme (uzaklık negatiften küçük olamaz)',
    formulas: [
      '|x| = a → x = a veya x = −a (a > 0)',
      '|x| < a → −a < x < a',
      '|x| > a → x > a veya x < −a',
      '√(x²) = |x|',
      '|a| + |b| = 0 ise a = 0 ve b = 0',
    ],
    keyPoints: [
      'İlk iş: Mutlak değerin içinin işaretini belirle! Pozitifse aynen, negatifse işaret değiştirerek çıkar.',
      'Kritik nokta: Mutlak değerin içini 0 yapan sayı. En küçük değer sorularında kritik noktaları dene.',
      '|a| + |b| = 0 ise, hem a = 0 hem b = 0 olmak zorunda.',
      '|x| > x demek x negatiftir. |x| = x demek x ≥ 0 dır.',
      'İki nokta arasındaki uzaklık: |a − b| formülüyle hesaplanır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '|2x − 5| = 7 denklemini sağlayan x değerleri çarpımı kaçtır?',
      steps: [
        'Adım 1: Mutlak değer 7\'ye eşitse, içerisi ya 7 ya da −7\'dir.',
        'Adım 2: 2x − 5 = 7 → 2x = 12 → x = 6',
        'Adım 3: 2x − 5 = −7 → 2x = −2 → x = −1',
        'Adım 4: Çarpım: 6 × (−1) = −6',
      ],
      answer: '−6',
    ),
    SolvedExample(
      question:
          'x < 0 < y olmak üzere, √(x²) + |y − x| + |y| ifadesinin eşiti nedir?',
      steps: [
        'Adım 1: √(x²) = |x|. İfade: |x| + |y − x| + |y| oldu.',
        'Adım 2: x negatif → |x| = −x',
        'Adım 3: y > 0, x < 0 → (y − x) > 0 → |y − x| = y − x',
        'Adım 4: y > 0 → |y| = y',
        'Adım 5: Topla: (−x) + (y − x) + y = 2y − 2x',
      ],
      answer: '2y − 2x',
    ),
    SolvedExample(
      question:
          'Sayı doğrusu üzerinde 3 noktasına olan uzaklığı, 7 noktasına olan uzaklığının 2 katına eşit olan sayıların toplamı kaçtır?',
      steps: [
        'Adım 1: x\'in 3\'e uzaklığı |x − 3|, 7\'ye uzaklığı |x − 7|.',
        'Adım 2: Denklem: |x − 3| = 2|x − 7|',
        'Adım 3: Durum 1: x − 3 = 2(x − 7) → x = 11',
        'Adım 4: Durum 2: x − 3 = −2(x − 7) → 3x = 17 → x = 17/3',
        'Adım 5: Toplam: 11 + 17/3 = 50/3',
      ],
      answer: '50/3',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: '|−7| + |3| − |−2| işleminin sonucu kaçtır?',
      options: ['A) 8', 'B) 10', 'C) 12', 'D) 6'],
      correctIndex: 0,
      explanation: '7 + 3 − 2 = 8.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '|x − 2| = 0 ve |y + 5| = 0 olduğuna göre x + y kaçtır?',
      options: ['A) −3', 'B) 3', 'C) 7', 'D) −7'],
      correctIndex: 0,
      explanation: 'Mutlak değer 0 ise içleri 0 olmalı. x = 2, y = −5. Toplam: −3.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '|x| ≤ 3 eşitsizliğini sağlayan kaç tane x tam sayısı vardır?',
      options: ['A) 5', 'B) 6', 'C) 7', 'D) 8'],
      correctIndex: 2,
      explanation: '−3 ≤ x ≤ 3. Tam sayılar: −3, −2, −1, 0, 1, 2, 3 → 7 tane.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'x < 0 olduğuna göre |3x| − |−x| ifadesinin eşiti nedir?',
      options: ['A) 2x', 'B) −2x', 'C) 4x', 'D) −4x'],
      correctIndex: 1,
      explanation: 'x < 0: |3x| = −3x (3x negatif). |−x| = −x (−x pozitif, aynen çıkar). (−3x) − (−x) = −2x.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Sayı doğrusunda −4 noktasına olan uzaklığı 5 birim olan sayıların çarpımı kaçtır?',
      options: ['A) −9', 'B) −5', 'C) 1', 'D) 9'],
      correctIndex: 0,
      explanation: '|x + 4| = 5. x = 1 veya x = −9. Çarpım: 1 × (−9) = −9.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          '|x − 2| + |2x − 4| = 12 denklemini sağlayan x değerlerinin toplamı kaçtır?',
      options: ['A) 2', 'B) 4', 'C) 6', 'D) 8'],
      correctIndex: 1,
      explanation:
          '|2x − 4| = 2|x − 2|. Denklem: 3|x − 2| = 12 → |x − 2| = 4 → x = 6 veya x = −2. Toplam: 4.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '|x − 3| = 3 − x eşitliğini sağlayan en büyük negatif tam sayı kaçtır?',
      options: ['A) −1', 'B) −2', 'C) −3', 'D) Yoktur'],
      correctIndex: 0,
      explanation:
          '|a| = −a ise a ≤ 0 demektir. x − 3 ≤ 0 → x ≤ 3. En büyük negatif tam sayı: −1.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'A = |x − 4| + |x + 6| ifadesinin alabileceği en küçük değer kaçtır?',
      options: ['A) 0', 'B) 2', 'C) 10', 'D) 12'],
      correctIndex: 2,
      explanation:
          'İki nokta (4 ve −6) arası uzaklıkların toplamı. Min değer = iki nokta arası mesafe = |4 − (−6)| = 10. x ∈ [−6, 4] aralığında hep 10.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '||x − 1| + 2| = 5 denkleminin kaç farklı kökü vardır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 1,
      explanation:
          '|x−1| + 2 ≥ 2 > 0 olduğu için dış mutlak değer gereksiz. |x−1| = 3 → x = 4 veya x = −2. Toplam 2 kök.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Hava sıcaklığının 20°C olduğu bir odada termometre 3°C hata payı ile ölçüm yapmaktadır. Ölçülen sıcaklığı (x) gösteren eşitsizlik hangisidir?',
      options: ['A) |x − 20| ≤ 3', 'B) |x − 3| ≤ 20', 'C) |x + 20| ≤ 3', 'D) |x| ≤ 23'],
      correctIndex: 0,
      explanation: 'Gerçek değerden farkı en çok 3 olabilir → |x − 20| ≤ 3.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          '|x| > x ve x² < 16 eşitsizliklerini aynı anda sağlayan x tam sayılarının toplamı kaçtır?',
      options: ['A) −6', 'B) −9', 'C) −10', 'D) 0'],
      correctIndex: 0,
      explanation:
          '|x| > x → x negatif. x² < 16 → −4 < x < 4. Birlikte: −4 < x < 0. Tam sayılar: −3, −2, −1. Toplam: −6.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '|x − 2|·|x + 2| = 5 denklemini sağlayan x değerlerinin çarpımı kaçtır?',
      options: ['A) −9', 'B) −5', 'C) 5', 'D) 9'],
      correctIndex: 0,
      explanation:
          '|x−2|·|x+2| = |x²−4| = 5. x²−4 = 5 → x² = 9 → x = ±3. x²−4 = −5 → x² = −1 (yok). Çarpım: 3×(−3) = −9.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'x ve y sıfırdan farklı gerçel sayılardır. |x|/x + |y|/y toplamı kaç farklı değer alabilir?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 2,
      explanation:
          '|x|/x ya 1 (x>0) ya −1 (x<0). Olası toplamlar: 1+1=2, 1+(−1)=0, (−1)+(−1)=−2. Toplam 3 farklı değer.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir fabrikanın ürettiği vidaların çapı (x) standart değerden en fazla 0,05 mm sapma gösterebilir. Standart çap 4 mm olduğuna göre, hatalı üretim olan vidaların koşulu hangisidir?',
      options: ['A) |x − 4| > 0,05', 'B) |x − 4| < 0,05', 'C) |x − 0,05| > 4', 'D) |x| > 4,05'],
      correctIndex: 0,
      explanation:
          'Kabul edilebilir: |x − 4| ≤ 0,05. Hatalı = kabul dışı → |x − 4| > 0,05.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '|2x − 1| = 1 − 2x eşitliğini sağlayan en büyük x tam sayısı m, |y − 2| < 3 eşitsizliğini sağlayan en büyük y tam sayısı n ise n − m kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 3,
      explanation:
          '|2x−1| = −(2x−1) → 2x−1 ≤ 0 → x ≤ 1/2. En büyük tam sayı m = 0. |y−2| < 3 → −1 < y < 5. En büyük tam sayı n = 4. Fark: 4 − 0 = 4.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU4Content = StemUnitContent(
  unitId: 'tyt_mat_u4',
  topic: const TopicContent(
    summary:
        'Üslü sayılar, bir sayının kendisiyle tekrarlı çarpımıdır. Köklü sayılar ise üslü sayıların tersidir. '
        '"Negatif üs" (ters çevirme) ve "rasyonel üs" (köklü ifadeye çevirme) kavramları hayati önem taşır.',
    rule:
        'Üslü Kurallar:\n'
        '• Çarpma (tabanlar aynı): a^x · a^y = a^(x+y)\n'
        '• Bölme (tabanlar aynı): a^x / a^y = a^(x−y)\n'
        '• Üssün Üssü: (a^x)^y = a^(x·y)\n'
        '• Negatif Üs: a^(−x) = 1/a^x\n'
        '• Sıfırıncı Kuvvet: a^0 = 1 (a ≠ 0)\n\n'
        'Köklü Kurallar:\n'
        '• Toplama/Çıkarma: Kök içleri aynı olmalı\n'
        '• Çarpma/Bölme: Kök dereceleri aynıysa tek kök altında işlem yapılır\n'
        '• ⁿ√(aᵐ) = a^(m/n)\n'
        '• Eşlenik: Paydada kök varsa eşleniğiyle genişletilir',
    formulas: [
      'a^x · a^y = a^(x+y)',
      'a^x / a^y = a^(x−y)',
      '(a^x)^y = a^(x·y)',
      'a^(−x) = 1/a^x',
      'ⁿ√(aᵐ) = a^(m/n)',
      '(a−b)(a+b) = a²−b² (eşlenik)',
    ],
    keyPoints: [
      '(−2)⁴ = +16 ama −2⁴ = −16. Paranteze dikkat!',
      'Sıralama sorularında tabanları eşitleyemiyorsan üsleri EBOB\'a göre eşitle.',
      'Çift dereceli kökün içi negatif olamaz (karekök gibi).',
      '5 ve 7 gibi aralarında asal tabanlar eşitse her iki üs de 0 olmalıdır.',
      'Paydada kök bırakma! Eşleniğiyle genişlet.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '(2⁵ + 2⁵ + 2⁵ + 2⁵) / 4³ işleminin sonucu kaçtır?',
      steps: [
        'Adım 1: Payda 4 tane 2⁵ var → 4 · 2⁵',
        'Adım 2: 4 = 2² olduğundan 2² · 2⁵ = 2⁷',
        'Adım 3: Payda: 4³ = (2²)³ = 2⁶',
        'Adım 4: 2⁷ / 2⁶ = 2¹ = 2',
      ],
      answer: '2',
    ),
    SolvedExample(
      question: '√75 − √12 + √48 işleminin sonucu kaçtır?',
      steps: [
        'Adım 1: √75 = √(25·3) = 5√3',
        'Adım 2: √12 = √(4·3) = 2√3',
        'Adım 3: √48 = √(16·3) = 4√3',
        'Adım 4: Katsayılarla işlem: 5 − 2 + 4 = 7',
      ],
      answer: '7√3',
    ),
    SolvedExample(
      question: '3^(x+2) − 3^x = 72 ise x kaçtır?',
      steps: [
        'Adım 1: 3^(x+2) = 3^x · 3² = 9 · 3^x',
        'Adım 2: 9 · 3^x − 3^x = 72',
        'Adım 3: 3^x(9 − 1) = 72 → 3^x · 8 = 72',
        'Adım 4: 3^x = 9 = 3² → x = 2',
      ],
      answer: '2',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: '(−3)² − (−2)³ + (−1)²⁰ işleminin sonucu kaçtır?',
      options: ['A) 16', 'B) 17', 'C) 18', 'D) 19'],
      correctIndex: 2,
      explanation: '9 − (−8) + 1 = 9 + 8 + 1 = 18.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '5^x = 1/25 olduğuna göre x kaçtır?',
      options: ['A) −2', 'B) 2', 'C) 1/2', 'D) −1/2'],
      correctIndex: 0,
      explanation: '1/25 = 5^(−2), dolayısıyla x = −2.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '√36 + √100 − √1 işlemi kaçtır?',
      options: ['A) 13', 'B) 14', 'C) 15', 'D) 16'],
      correctIndex: 2,
      explanation: '6 + 10 − 1 = 15.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '2^x · 2³ = 32 olduğuna göre x kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 1,
      explanation: '2^(x+3) = 2⁵ → x + 3 = 5 → x = 2.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Aşağıdakilerden hangisi bir rasyonel sayıdır (kökten tam çıkar)?',
      options: ['A) √8', 'B) √12', 'C) √27', 'D) √36'],
      correctIndex: 3,
      explanation: '√36 = 6. Diğerleri köklü kalır.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          '3^x = a ve 5^x = b olduğuna göre 45^x ifadesinin a ve b cinsinden eşiti nedir?',
      options: ['A) a²·b', 'B) a·b²', 'C) a²·b²', 'D) a/b'],
      correctIndex: 0,
      explanation:
          '45 = 3² · 5. 45^x = (3²)^x · 5^x = (3^x)² · 5^x = a²·b.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '√20 sayısı hangi iki ardışık tam sayı arasındadır?',
      options: ['A) 3 ile 4', 'B) 4 ile 5', 'C) 5 ile 6', 'D) 2 ile 3'],
      correctIndex: 1,
      explanation: '√16 = 4, √25 = 5. 16 < 20 < 25 olduğundan 4 < √20 < 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '(0,2)³ · 5³ işleminin sonucu kaçtır?',
      options: ['A) 0,1', 'B) 1', 'C) 10', 'D) 25'],
      correctIndex: 1,
      explanation: 'Üsler aynı → tabanlar çarpılır: (0,2 × 5)³ = 1³ = 1.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'a = 2⁶⁰, b = 3⁴⁰, c = 5²⁰ olduğuna göre büyükten küçüğe sıralama hangisidir?',
      options: [
        'A) a < b < c',
        'B) c < b < a',
        'C) c < a < b',
        'D) b < c < a',
      ],
      correctIndex: 2,
      explanation:
          'EBOB(60,40,20)=20. a=(2³)²⁰=8²⁰, b=(3²)²⁰=9²⁰, c=5²⁰. Tabanlar: 5 < 8 < 9 → c < a < b.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '√(x − 3) + √(6 − 2x) toplamı bir reel sayı belirttiğine göre x kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 1,
      explanation:
          'x − 3 ≥ 0 → x ≥ 3. 6 − 2x ≥ 0 → x ≤ 3. Her ikisi birden ⇒ x = 3.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'x ve y tam sayılardır. 5^(3x−6) = 7^(2y+8) olduğuna göre x·y çarpımı kaçtır?',
      options: ['A) −8', 'B) −4', 'C) 0', 'D) 8'],
      correctIndex: 0,
      explanation:
          '5 ve 7 aralarında asal. Eşitlik ancak her iki üs 0 ise sağlanır (1=1). 3x−6=0 → x=2. 2y+8=0 → y=−4. Çarpım: −8.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'x = √5 + 2 olduğuna göre (x − 2)² ifadesinin değeri kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 9'],
      correctIndex: 2,
      explanation: 'x − 2 = √5. (√5)² = 5.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir bakteri kültürü her saat sonunda sayısını 2 katına çıkarmaktadır. Başlangıçta 4⁵ tane bakteri varsa, 3 saat sonra bakteri sayısı kaçtır?',
      options: ['A) 2¹¹', 'B) 2¹²', 'C) 2¹³', 'D) 2¹⁵'],
      correctIndex: 2,
      explanation:
          'Başlangıç: 4⁵ = (2²)⁵ = 2¹⁰. 3 saatte 2³ katına çıkar. 2¹⁰ · 2³ = 2¹³.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '1 / (3 − 2√2) ifadesinin eşlenik kullanılarak sadeleştirilmiş hali nedir?',
      options: ['A) 3 + 2√2', 'B) 3 − 2√2', 'C) 1', 'D) 3'],
      correctIndex: 0,
      explanation:
          'Eşlenik (3 + 2√2) ile genişlet. Payda: 9 − 8 = 1. Sonuç: 3 + 2√2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '√(7 + √48) ifadesinin değeri kaçtır?',
      options: ['A) √3 + 1', 'B) √3 + 2', 'C) 2 + √2', 'D) 2 − √3'],
      correctIndex: 1,
      explanation:
          '√48 = 4√3. İfade: √(7 + 4√3). Çarpımı 12, toplamı 7 olan sayılar: 3 ve 4. Sonuç: √4 + √3 = 2 + √3.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU5Content = StemUnitContent(
  unitId: 'tyt_mat_u5',
  topic: const TopicContent(
    summary:
        'Oran, iki çokluğun birbirine bölünerek karşılaştırılmasıdır (a/b). Orantı ise iki veya daha fazla oranın eşitliğidir (a/b = c/d = k). '
        '"k" orantı sabitidir ve konunun kalbidir. Yüzde problemleri paydası 100 olan özel bir orantı çeşididir.',
    rule:
        'İçler-Dışlar Çarpımı: a/b = c/d ise a·d = b·c\n'
        'Doğru Orantı: Biri artarken diğeri de artıyorsa → y/x = k\n'
        'Ters Orantı: Biri artarken diğeri azalıyorsa → y·x = k\n'
        'Aritmetik Ortalama: Toplam / Sayı Adedi\n'
        'Geometrik Ortalama: √(a·b)\n'
        'Yüzde: Bir sayının %x\'i = Sayı × (x/100)',
    formulas: [
      'a/b = c/d → a·d = b·c',
      'Doğru orantı: y = k·x',
      'Ters orantı: y·x = k',
      'Harmonik Ortalama = 2·V₁·V₂ / (V₁ + V₂)',
      '%Artış sonrası değer = Başlangıç × (1 + oran)',
      '%Azalış sonrası değer = Başlangıç × (1 − oran)',
    ],
    keyPoints: [
      'k metodu: a/3 = b/4 = c/5 görürsen a = 3k, b = 4k, c = 5k yaz.',
      'Ters orantı pratiği: 2a = 3b = 4c ise EKOK(2,3,4) = 12 al → a = 6k, b = 4k, c = 3k.',
      'Yüzde problemlerinde başlangıç değerini "100x" olarak al. %20\'si hemen 20x olur.',
      'Ortalama hız = aritmetik ortalama değil! Harmonik ortalama kullan.',
      'Art arda yüzde işlemleri toplanmaz, çarpılır. (%20 artış sonra %20 azalış ≠ değişmez)',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'a/b = c/d = 3 ve 2a + 3c = 24 ise 2b + 3d kaçtır?',
      steps: [
        'Adım 1: Pay ve paydayı aynı katsayıyla çarpıp toplarsak oran değişmez.',
        'Adım 2: (2a + 3c) / (2b + 3d) = 3 olmalıdır.',
        'Adım 3: 24 / (2b + 3d) = 3',
        'Adım 4: 2b + 3d = 24 / 3 = 8',
      ],
      answer: '8',
    ),
    SolvedExample(
      question:
          'Eşit kapasiteli 4 işçi bir duvarı 15 günde örüyor. Aynı duvarı 6 işçi kaç günde örer?',
      steps: [
        'Adım 1: İşçi artar → gün azalır. Ters orantı.',
        'Adım 2: 4 × 15 = 6 × x',
        'Adım 3: 60 = 6x → x = 10',
      ],
      answer: '10 gün',
    ),
    SolvedExample(
      question:
          'Maliyeti 500 TL olan ürün %30 kârla satılıyor. Satış fiyatı üzerinden %10 indirim yapılırsa yeni fiyat kaçtır?',
      steps: [
        'Adım 1: %30 kâr → 500 × 0,30 = 150 TL kâr',
        'Adım 2: Satış fiyatı = 500 + 150 = 650 TL',
        'Adım 3: %10 indirim → 650 × 0,10 = 65 TL',
        'Adım 4: Yeni fiyat = 650 − 65 = 585 TL',
      ],
      answer: '585 TL',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: '300 sayısının %40\'ı kaçtır?',
      options: ['A) 120', 'B) 140', 'C) 150', 'D) 160'],
      correctIndex: 0,
      explanation: '300 × 40/100 = 120.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'x/y = 2/5 olduğuna göre (x + y)/x oranı kaçtır?',
      options: ['A) 5/2', 'B) 7/2', 'C) 7/5', 'D) 3/2'],
      correctIndex: 1,
      explanation: 'x = 2k, y = 5k. (2k + 5k) / 2k = 7/2.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Kızların erkeklere oranı 3/4 olan sınıfın mevcudu 35 ise kaç erkek vardır?',
      options: ['A) 15', 'B) 18', 'C) 20', 'D) 25'],
      correctIndex: 2,
      explanation: 'Kız = 3k, Erkek = 4k. 7k = 35 → k = 5. Erkek = 20.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Hangi sayının %20\'sinin 3 fazlası, aynı sayının %25\'ine eşittir?',
      options: ['A) 30', 'B) 40', 'C) 50', 'D) 60'],
      correctIndex: 3,
      explanation:
          'Sayı = 100x. 20x + 3 = 25x → 5x = 3 → x = 0,6. Sayı = 60.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'a, b ile doğru, c ile ters orantılıdır. a = 4, b = 2, c = 6 iken a = 6, b = 3 ise c kaçtır?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 12'],
      correctIndex: 1,
      explanation:
          'a·c/b = k. İlk: (4×6)/2 = 12. İkinci: (6×c)/3 = 12 → c = 6.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question: '%20 zararla 160 TL\'ye satılan malın maliyeti kaç TL\'dir?',
      options: ['A) 180', 'B) 192', 'C) 200', 'D) 220'],
      correctIndex: 2,
      explanation: '%20 zarar → %80\'e satılmış. 0,80 × Maliyet = 160. Maliyet = 200.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Cevizler 3, 4 ve 6 yaşlarındaki çocuklara yaşları ile ters orantılı dağıtılıyor. En çok alan 40 ceviz aldığına göre toplam kaçtır?',
      options: ['A) 70', 'B) 80', 'C) 90', 'D) 100'],
      correctIndex: 2,
      explanation:
          'Ters orantı payları: 4p, 3p, 2p. En çok: 4p = 40 → p = 10. Toplam: 9p = 90.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Dikdörtgenin kısa kenarı %20 artırılıp uzun kenarı %20 azaltılırsa alan nasıl değişir?',
      options: [
        'A) Değişmez',
        'B) %2 azalır',
        'C) %4 azalır',
        'D) %4 artar',
      ],
      correctIndex: 2,
      explanation:
          'Yeni alan = 1,20 × 0,80 = 0,96 katı. %4 azalır.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '%20 tuzlu 40 L su ile %40 tuzlu 60 L su karıştırılırsa tuz oranı yüzde kaç olur?',
      options: ['A) 28', 'B) 30', 'C) 32', 'D) 35'],
      correctIndex: 2,
      explanation:
          '(40×20 + 60×40) / 100 = (800 + 2400) / 100 = 32.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'x, y, z sırasıyla 2, 3, 5 ile orantılıdır. 2x + y − z = 40 ise y kaçtır?',
      options: ['A) 30', 'B) 45', 'C) 60', 'D) 75'],
      correctIndex: 2,
      explanation:
          'x = 2k, y = 3k, z = 5k. 4k + 3k − 5k = 2k = 40 → k = 20. y = 60.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'Bir lastik çekildiğinde boyu %120 uzamaktadır. Çekilmiş halde 66 cm olan lastiğin ilk boyu kaç cm\'dir?',
      options: ['A) 30', 'B) 33', 'C) 36', 'D) 40'],
      correctIndex: 0,
      explanation:
          'İlk boy L. %120 uzarsa yeni boy = 2,20L. 2,20L = 66 → L = 30.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '"3 al 2 öde" kampanyasından 3 ürün alan müşteri gerçekte yüzde kaç indirim kazanmıştır?',
      options: ['A) 33,3', 'B) 25', 'C) 50', 'D) 20'],
      correctIndex: 0,
      explanation:
          '3 ürün yerine 2 ödeniyor. İndirim = 1/3 ≈ %33,3.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'a = k·b² dir. b, %20 azaltılırsa a\'nın aynı kalması için k yüzde kaç artırılmalıdır?',
      options: ['A) %25', 'B) %36', 'C) %56,25', 'D) %44'],
      correctIndex: 2,
      explanation:
          'b → 0,8b olunca (0,8b)² = 0,64b². a sabit kalacaksa k_yeni = k/0,64 = 1,5625k. %56,25 artış.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir araç A\'dan B\'ye 80 km/h hızla gidip 120 km/h hızla dönüyor. Ortalama hız kaç km/h\'tir?',
      options: ['A) 90', 'B) 96', 'C) 100', 'D) 110'],
      correctIndex: 1,
      explanation:
          'Harmonik ortalama: 2×80×120 / (80+120) = 19200/200 = 96. Aritmetik ortalama (100) hatalı olur!',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Yaş sabun kuruyunca ağırlığının %20\'sini kaybediyor. Kilosu 40 TL\'den alınan sabun, kurutulduktan sonra %25 kâr için kilosu kaç TL\'den satılmalıdır?',
      options: ['A) 50', 'B) 60', 'C) 62,5', 'D) 65'],
      correctIndex: 2,
      explanation:
          '100 kg alınırsa maliyet 4000 TL. Kuruyunca 80 kg kalır. %25 kâr → hedef 5000 TL. 5000/80 = 62,5 TL/kg.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU6Content = StemUnitContent(
  unitId: 'tyt_mat_u6',
  topic: const TopicContent(
    summary:
        'Problemlerin çözümünde en önemli kural değişkenleri doğru atamaktır. '
        'Yaş, işçi, karışım ve hareket problemleri TYT\'de en sık çıkan soru tipleridir.',
    rule:
        'Yaş: Kişiler arasındaki yaş farkı asla değişmez.\n'
        'İşçi: İşin tamamı = 1. Ali a günde bitiriyorsa günde 1/a yapar.\n'
        'Karışım: (Saf Madde / Toplam) × 100\n'
        'Hareket: Yol = Hız × Zaman\n'
        '• Zıt yön (karşılaşma): Hızlar toplanır\n'
        '• Aynı yön (yetişme): Hızlar çıkarılır\n'
        'Ortalama Hız = Toplam Yol / Toplam Zaman',
    formulas: [
      'Yol = Hız × Zaman',
      'Birlikte çalışma: 1/t = 1/a + 1/b',
      'Karşılaşma: t = Yol / (v₁ + v₂)',
      'Yetişme: t = Yol / (v₁ − v₂)',
      'Harmonik Ortalama = 2·v₁·v₂ / (v₁ + v₂)',
      'Tren/tünel: Alınan yol = Tünel + Tren boyu',
    ],
    keyPoints: [
      'İşçi problemlerinde EKOK yöntemi: Sürelerin EKOK\'unu iş parçası olarak al.',
      'Yaş farkı sabittir. "A, B\'nin yaşına geldiğinde" → geçen süre = yaş farkı.',
      'Tünel/tren soruları: Trenin geçmesi gereken yol = tünel + tren boyu.',
      'Karışım problemlerinde kap yöntemi: (Miktar×Yüzde) + (Miktar×Yüzde) = Toplam×Yeni Yüzde.',
      'Saf suyun oranı %0, saf tuzun oranı %100.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'Baba 40, oğlu 10 yaşındadır. Kaç yıl sonra babanın yaşı oğlunun yaşının 3 katı olur?',
      steps: [
        'Adım 1: x yıl sonra baba (40+x), oğul (10+x) yaşında.',
        'Adım 2: 40 + x = 3(10 + x)',
        'Adım 3: 40 + x = 30 + 3x → 10 = 2x → x = 5',
      ],
      answer: '5 yıl sonra',
    ),
    SolvedExample(
      question:
          'Ahmet bir işi 12 günde, Mehmet 24 günde bitiriyor. Birlikte kaç günde bitirirler?',
      steps: [
        'Adım 1: 1/t = 1/12 + 1/24',
        'Adım 2: 1/t = 2/24 + 1/24 = 3/24 = 1/8',
        'Adım 3: t = 8',
      ],
      answer: '8 gün',
    ),
    SolvedExample(
      question:
          'A ve B arası 600 km. A\'dan 70 km/h, B\'den 80 km/h hızla iki araç karşılıklı hareket ediyor. Kaç saat sonra karşılaşırlar?',
      steps: [
        'Adım 1: Zıt yönde hızlar toplanır: 70 + 80 = 150 km/h',
        'Adım 2: t = 600 / 150 = 4 saat',
      ],
      answer: '4 saat',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          'Bir baba ile oğlunun yaşları toplamı 60\'tır. 5 yıl sonra yaşları toplamı kaç olur?',
      options: ['A) 65', 'B) 70', 'C) 75', 'D) 80'],
      correctIndex: 1,
      explanation:
          'İki kişi var, her biri 5 yaş alır. 60 + 2×5 = 70.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Saatteki hızı 90 km olan bir araç, 450 km\'lik yolu kaç saatte gider?',
      options: ['A) 4', 'B) 5', 'C) 6', 'D) 7'],
      correctIndex: 1,
      explanation: 't = 450 / 90 = 5 saat.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Tuz oranı %20 olan 40 litre tuzlu suyun içinde kaç litre saf su vardır?',
      options: ['A) 8', 'B) 16', 'C) 30', 'D) 32'],
      correctIndex: 3,
      explanation: 'Tuz = 40 × 0,20 = 8 L. Su = 40 − 8 = 32 L.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Ali bir işi 10 günde, Veli 15 günde yapıyor. İkisi birlikte 2 gün çalışırsa işin kaçta kaçı biter?',
      options: ['A) 1/3', 'B) 1/2', 'C) 2/3', 'D) 3/4'],
      correctIndex: 0,
      explanation:
          '(1/10 + 1/15) × 2 = (3/30 + 2/30) × 2 = 5/30 × 2 = 1/3.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Üç kardeşin yaşları toplamı 24\'tür. 4 yıl sonra yaşları toplamı kaç olur?',
      options: ['A) 28', 'B) 32', 'C) 36', 'D) 40'],
      correctIndex: 2,
      explanation: '3 × 4 = 12 artış. 24 + 12 = 36.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'Bir araç A\'dan B\'ye 60 km/h hızla gidip, 90 km/h hızla geri dönüyor. Toplam 10 saat sürdüğüne göre A-B arası kaç km\'dir?',
      options: ['A) 300', 'B) 360', 'C) 420', 'D) 450'],
      correctIndex: 1,
      explanation:
          'x/60 + x/90 = 10. (3x + 2x)/180 = 10 → 5x = 1800 → x = 360.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '%30 şekerli 60 g karışıma 15 g saf şeker ve 25 g saf su eklenirse yeni şeker oranı yüzde kaç olur?',
      options: ['A) 30', 'B) 33', 'C) 35', 'D) 40'],
      correctIndex: 1,
      explanation:
          'İlk şeker: 18 g. Toplam şeker: 18 + 15 = 33 g. Toplam: 100 g. %33.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Burak bir işi 12 günde bitiriyor. Hızını 2 katına çıkarırsa aynı işi kaç günde bitirir?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 24'],
      correctIndex: 1,
      explanation: 'Hız ve süre ters orantılı. Hız 2 katına çıkarsa süre yarıya düşer: 12/2 = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Bir baba 48, kızı 12 yaşındadır. Kaç yıl sonra babanın yaşı kızının yaşının 3 katı olur?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 10'],
      correctIndex: 1,
      explanation:
          '48 + x = 3(12 + x) → 48 + x = 36 + 3x → 12 = 2x → x = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Durgun sudaki hızı 20 km/h olan tekne, akıntı hızı 5 km/h olan nehirde akıntı yönünde 2 saatte aldığı yolu akıntıya karşı kaç saatte alır?',
      options: ['A) 2,5', 'B) 3', 'C) 10/3', 'D) 4'],
      correctIndex: 2,
      explanation:
          'Akıntı yönü: (20+5)×2 = 50 km. Akıntıya karşı: 50/(20−5) = 50/15 = 10/3 saat.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          '6 işçi bir işe başlıyor. Her günün sonunda 1 işçi ayrılıyor ve iş 4 günde bitiyor. Bir işçi tek başına bu işi kaç günde bitirir?',
      options: ['A) 15', 'B) 18', 'C) 20', 'D) 24'],
      correctIndex: 1,
      explanation:
          '1 işçi günde x iş yapar. Toplam: 6x + 5x + 4x + 3x = 18x. Bir işçi 18x işi 18 günde bitirir.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '%40 alkollü karışımın 1/4\'ü dökülüp yerine aynı miktar saf su konursa alkol oranı yüzde kaç olur?',
      options: ['A) 20', 'B) 25', 'C) 30', 'D) 35'],
      correctIndex: 2,
      explanation:
          '100 L başlangıç, 40 L alkol. 25 L döküldü (10 L alkol gitti). Kalan alkol: 30 L. 25 L su eklendi → 100 L, 30 L alkol = %30.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Çevresi 400 m olan dairesel pistte zıt yöne koşan iki kişinin hızları 15 m/dk ve 25 m/dk\'dır. İlk karşılaşmadan kaç dakika sonra ikinci kez karşılaşırlar?',
      options: ['A) 8', 'B) 10', 'C) 12', 'D) 15'],
      correctIndex: 1,
      explanation:
          'Zıt yönde hızlar toplanır: 40 m/dk. Her karşılaşma arası 400/40 = 10 dk.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir baba ile kızının yaş farkı 24\'tür. 8 yıl sonra babanın yaşı kızının yaşının 2 katından 4 fazla olacağına göre kızın şimdiki yaşı kaçtır?',
      options: ['A) 10', 'B) 12', 'C) 16', 'D) 20'],
      correctIndex: 1,
      explanation:
          'Kız = x, Baba = x + 24. 8 yıl sonra: x + 32 = 2(x + 8) + 4 → x + 32 = 2x + 20 → x = 12.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir öğrenci harçlığının 1/4\'ünü, sonra kalanın 1/3\'ünü, en son kalanın yarısını harcıyor. Geriye 20 TL kalıyorsa başlangıç harçlığı kaç TL\'dir?',
      options: ['A) 60', 'B) 80', 'C) 100', 'D) 120'],
      correctIndex: 1,
      explanation:
          'Geriye doğru: 20 TL yarısıysa → 40. 40 kalan 2/3 ise → 60. 60 kalan 3/4 ise → 80. Sağlama: 80→60→40→20 ✓.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU7Content = StemUnitContent(
  unitId: 'tyt_mat_u7',
  topic: const TopicContent(
    summary:
        'Küme, iyi tanımlanmış nesneler topluluğudur. Elemanlar {a, b, c} şeklinde yazılır ve her eleman bir kez yazılır. '
        'TYT\'de en çok Venn Şeması yöntemi işe yarar.',
    rule:
        'Alt Küme Sayısı: n elemanlı kümenin 2ⁿ alt kümesi vardır (öz alt küme: 2ⁿ − 1)\n'
        'Birleşim (∪): A veya B → s(A∪B) = s(A) + s(B) − s(A∩B)\n'
        'Kesişim (∩): A ve B (ortak olanlar)\n'
        'Fark (−): A − B = A\'da olup B\'de olmayanlar\n'
        'Tümleyen (A\'): Evrensel kümenin içinde, A\'nın dışında kalanlar\n'
        'Boş Küme (∅): Hiç elemanı olmayan küme. Her kümenin alt kümesidir.',
    formulas: [
      's(A∪B) = s(A) + s(B) − s(A∩B)',
      'Alt küme sayısı = 2ⁿ',
      'Öz alt küme sayısı = 2ⁿ − 1',
      'A∩(B∪C) = (A∩B) ∪ (A∩C) (dağılma)',
      's(A×B) = s(A) · s(B) (kartezyen çarpım)',
    ],
    keyPoints: [
      '"Ve" → Kesişim (∩), "Veya" → Birleşim (∪).',
      'Alt küme: "a bulunsun, b bulunmasın" → b\'yi at, a\'yı cebe koy, kalanlarla 2ⁿ yap.',
      'Venn şemasında önce kesişimi yaz, sonra "sadece" bölgeleri bul.',
      '{∅} boş küme değildir; içinde ∅ sembolü olan 1 elemanlı kümedir.',
      'Kartezyen çarpımda s(A×B) = s(A)·s(B). Toplamın min olması için çarpanlar yakın seçilir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'A = {a, b, c, d, e} kümesinin alt kümelerinin kaç tanesinde "a" bulunur ama "c" bulunmaz?',
      steps: [
        'Adım 1: c\'yi kümeden sil → {a, b, d, e}',
        'Adım 2: a\'yı cebe at (garanti). Serbest elemanlar: {b, d, e}',
        'Adım 3: 3 elemanla alt küme sayısı = 2³ = 8',
      ],
      answer: '8',
    ),
    SolvedExample(
      question:
          's(A) = 12, s(B) = 10, s(A∪B) = 18 ise s(A∩B) kaçtır?',
      steps: [
        'Adım 1: s(A∪B) = s(A) + s(B) − s(A∩B)',
        'Adım 2: 18 = 12 + 10 − s(A∩B)',
        'Adım 3: s(A∩B) = 22 − 18 = 4',
      ],
      answer: '4',
    ),
    SolvedExample(
      question:
          '30 kişilik sınıfta İngilizce bilen 18, Almanca bilen 15, her ikisini bilen 5 kişidir. İki dili de bilmeyen kaç kişidir?',
      steps: [
        'Adım 1: Kesişim = 5 (her ikisi)',
        'Adım 2: Sadece İngilizce = 18 − 5 = 13',
        'Adım 3: Sadece Almanca = 15 − 5 = 10',
        'Adım 4: Toplam bilen = 13 + 5 + 10 = 28',
        'Adım 5: Bilmeyen = 30 − 28 = 2',
      ],
      answer: '2 kişi',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          '6 elemanlı bir kümenin kendisi hariç kaç tane alt kümesi (öz alt kümesi) vardır?',
      options: ['A) 31', 'B) 63', 'C) 64', 'D) 127'],
      correctIndex: 1,
      explanation: '2⁶ = 64. Kendisi hariç: 64 − 1 = 63.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'A = {a, b, {a}, c} kümesinin eleman sayısı kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 1,
      explanation: 'Elemanlar: a, b, {a}, c → 4 eleman.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Boş küme ile ilgili aşağıdakilerden hangisi yanlıştır?',
      options: [
        'A) Eleman sayısı 0\'dır',
        'B) Her kümenin alt kümesidir',
        'C) { } veya ∅ ile gösterilir',
        'D) {∅} boş kümedir',
      ],
      correctIndex: 3,
      explanation:
          '{∅} boş küme değildir; içinde ∅ olan 1 elemanlı bir kümedir.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'A∩B = {1, 2} ve A∩C = {1, 3, 5} olduğuna göre A∩(B∪C) kümesi hangisidir?',
      options: ['A) {1}', 'B) {1, 2, 3}', 'C) {1, 2, 3, 5}', 'D) {1, 2, 3, 4, 5}'],
      correctIndex: 2,
      explanation:
          'Dağılma: (A∩B) ∪ (A∩C) = {1,2} ∪ {1,3,5} = {1, 2, 3, 5}.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          's(A) = 5 ve s(B) = 7 ise s(A∪B) en az kaç olabilir?',
      options: ['A) 7', 'B) 8', 'C) 10', 'D) 12'],
      correctIndex: 0,
      explanation:
          'A ⊂ B ise birleşim = B → 7. Bu en küçük değerdir.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'A = {x | 10 < x < 50, x = 3k, k tam sayı} kümesinin eleman sayısı kaçtır?',
      options: ['A) 12', 'B) 13', 'C) 14', 'D) 15'],
      correctIndex: 1,
      explanation:
          '10-50 arası 3\'ün katları: 12, 15, …, 48. Sayı = (48−12)/3 + 1 = 13.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Sınıfın %60\'ı futbol, %50\'si basketbol oynuyor. %20\'si her iki sporu da yapıyorsa hiçbirini yapmayanlar yüzde kaçtır?',
      options: ['A) 5', 'B) 10', 'C) 15', 'D) 20'],
      correctIndex: 1,
      explanation:
          'Birleşim = 60 + 50 − 20 = 90. Yapmayanlar = 100 − 90 = %10.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'A ve B ayrık olmayan iki kümedir. s(A) = 8, s(B) = 12 ise s(A∪B) en çok kaçtır?',
      options: ['A) 18', 'B) 19', 'C) 20', 'D) 21'],
      correctIndex: 1,
      explanation:
          'Ayrık değil → kesişim ≥ 1. En çok birleşim = 8 + 12 − 1 = 19.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Alt küme sayısı ile öz alt küme sayısının toplamı 31 olan kümenin eleman sayısı kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 1,
      explanation:
          '2ⁿ + (2ⁿ − 1) = 31 → 2·2ⁿ = 32 → 2ⁿ = 16 → n = 4.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'A = {1,2,3,4,5,6} kümesinin alt kümelerinin kaç tanesinde 1 bulunur, 2 bulunmaz?',
      options: ['A) 8', 'B) 16', 'C) 32', 'D) 64'],
      correctIndex: 1,
      explanation:
          '1\'i cebe at, 2\'yi çöpe at. Kalan {3,4,5,6} → 2⁴ = 16.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'A ⊂ B, s(A) = 4, s(B) = 7 ise A ⊂ K ⊂ B şartını sağlayan kaç farklı K kümesi vardır?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 9'],
      correctIndex: 2,
      explanation:
          'B\'de A dışında 7 − 4 = 3 eleman var. Bu 3 elemanın her alt kümesi A\'ya eklenir → 2³ = 8.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          's(A) = 2·s(B), s(A−B) = 10, s(B−A) = 2 ise s(A∪B) kaçtır?',
      options: ['A) 12', 'B) 14', 'C) 16', 'D) 18'],
      correctIndex: 3,
      explanation:
          'Kesişim = x. s(A) = 10+x, s(B) = 2+x. 10+x = 2(2+x) → x = 6. s(A∪B) = 10+6+2 = 18.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'A = {1,2,3,4,5,7,9} kümesinin 3 elemanlı alt kümelerinden kaç tanesi yalnızca asal sayılardan oluşur?',
      options: ['A) 1', 'B) 2', 'C) 4', 'D) 5'],
      correctIndex: 2,
      explanation:
          'Kümedeki asallar: {2,3,5,7} → 4 asal. C(4,3) = 4.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '40 kişilik grupta matematik bilen 28, fen bilen 22, her ikisini bilen 15 kişidir. Ne matematik ne fen bilen kaç kişidir?',
      options: ['A) 3', 'B) 5', 'C) 7', 'D) 10'],
      correctIndex: 1,
      explanation:
          's(M∪F) = 28 + 22 − 15 = 35. Bilmeyen = 40 − 35 = 5.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          's(A)·s(B) = 24 ve A∩B = ∅ olduğuna göre s(A∪B) en az kaç olabilir?',
      options: ['A) 10', 'B) 11', 'C) 14', 'D) 25'],
      correctIndex: 0,
      explanation:
          'Kesişim boş → s(A∪B) = s(A)+s(B). Çarpımı 24, toplamı min olan çift: 4×6 → 10.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU8Content = StemUnitContent(
  unitId: 'tyt_mat_u8',
  topic: const TopicContent(
    summary:
        'Fonksiyon, A kümesindeki (Tanım) her elemanı B kümesindeki (Değer) yalnız bir elemana eşleyen bağıntıdır. '
        'Kıyma makinesi gibi düşün: Et (x) girer, kıyma (y) çıkar.',
    rule:
        'Sabit Fonksiyon: f(x) = c (girdi ne olursa olsun çıktı aynı)\n'
        'Birim Fonksiyon: f(x) = x\n'
        'Doğrusal Fonksiyon: f(x) = ax + b\n'
        'Ters Fonksiyon: f(x) = y ise f⁻¹(y) = x\n'
        '• f(x) = ax + b → f⁻¹(x) = (x − b) / a\n'
        'Bileşke: (f∘g)(x) = f(g(x)) → önce g, sonra f',
    formulas: [
      'f(x) = ax + b → f⁻¹(x) = (x−b)/a',
      '(f∘g)(x) = f(g(x))',
      'f(x) = (ax+b)/(cx+d) → f⁻¹(x) = (−dx+b)/(cx−a)',
      'Tek fonksiyon: f(−x) = −f(x)',
      'Çift fonksiyon: f(−x) = f(x)',
    ],
    keyPoints: [
      'Parantez içi: f(2x+1) verilip f(5) sorulursa, 2x+1 = 5 eşitle, x bul, sağ tarafa yaz.',
      'Tanım kümesinin her elemanı kullanılmalı ve her biri tek çıktıya gitmeli.',
      'Paydalı fonksiyonlarda paydayı sıfır yapan değerler tanım kümesinden çıkarılır.',
      'Ters fonksiyon: dışarıdaki içeri, içerideki dışarı geçer.',
      'Grafik okumada x ekseni tanım kümesi, y ekseni görüntü kümesidir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'f(x) = 3x − 2 olduğuna göre f(4) + f(0) kaçtır?',
      steps: [
        'Adım 1: f(4) = 3(4) − 2 = 10',
        'Adım 2: f(0) = 3(0) − 2 = −2',
        'Adım 3: 10 + (−2) = 8',
      ],
      answer: '8',
    ),
    SolvedExample(
      question: 'f(2x + 3) = 4x − 5 olduğuna göre f(7) kaçtır?',
      steps: [
        'Adım 1: İçeriği eşitle: 2x + 3 = 7 → x = 2',
        'Adım 2: Sağ tarafa yaz: f(7) = 4(2) − 5 = 3',
      ],
      answer: '3',
    ),
    SolvedExample(
      question: 'f(x) = 2x + 10 ise f⁻¹(16) kaçtır?',
      steps: [
        'Adım 1: Sonucu 16 yapan x\'i arıyoruz: 2x + 10 = 16',
        'Adım 2: 2x = 6 → x = 3',
        'Adım 3: f(3) = 16 ise f⁻¹(16) = 3',
      ],
      answer: '3',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: 'f(x) = x² + 1 olduğuna göre f(−3) kaçtır?',
      options: ['A) −8', 'B) 7', 'C) 9', 'D) 10'],
      correctIndex: 3,
      explanation: '(−3)² + 1 = 9 + 1 = 10.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'f(x) birim fonksiyondur. f(3x − 2) = 10 ise x kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 2,
      explanation: 'Birim fonksiyon: f(x) = x. 3x − 2 = 10 → x = 4.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'f(x) sabit fonksiyondur. f(1) = 5 ise f(100) kaçtır?',
      options: ['A) 1', 'B) 5', 'C) 100', 'D) 500'],
      correctIndex: 1,
      explanation: 'Sabit fonksiyonda çıktı değişmez, her zaman 5.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'f(x) = 2x + a ve f(2) = 7 ise a kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 2,
      explanation: '2(2) + a = 7 → a = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'A = {1,2,3}, B = {4,5} ise hangisi A\'dan B\'ye bir fonksiyondur?',
      options: [
        'A) {(1,4), (2,5)}',
        'B) {(1,4), (1,5), (2,4), (3,5)}',
        'C) {(1,4), (2,4), (3,5)}',
        'D) {(1,4), (2,5), (3,4), (3,5)}',
      ],
      correctIndex: 2,
      explanation:
          'C: Her eleman (1,2,3) tek bir çıktıya gidiyor ve boşta kalan yok.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'f(x) = 3x − 1, g(x) = x + 4 ise (f∘g)(2) kaçtır?',
      options: ['A) 12', 'B) 14', 'C) 17', 'D) 19'],
      correctIndex: 2,
      explanation: 'g(2) = 6. f(6) = 3(6) − 1 = 17.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'f doğrusal fonksiyondur. f(1) = 4, f(3) = 10 ise f(2) kaçtır?',
      options: ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      correctIndex: 1,
      explanation:
          'Eğim = (10−4)/(3−1) = 3. f(2) = 4 + 3 = 7. Veya ortalamayla: (4+10)/2 = 7.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'f(x) = (2x+1)/(x−3) fonksiyonunun en geniş tanım kümesi nedir?',
      options: ['A) ℝ', 'B) ℝ − {3}', 'C) ℝ − {−1/2}', 'D) ℝ − {0}'],
      correctIndex: 1,
      explanation: 'Payda 0 olamaz: x − 3 = 0 → x = 3 çıkarılır.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'f(x + 2) = 3x − 5 olduğuna göre f(x) hangisidir?',
      options: ['A) 3x − 11', 'B) 3x + 1', 'C) 3x − 6', 'D) 3x − 8'],
      correctIndex: 0,
      explanation:
          'x yerine (x−2) yaz: f(x) = 3(x−2) − 5 = 3x − 11.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'f(x) = x², g(x) = 2x − 1 ise (g∘f)(3) kaçtır?',
      options: ['A) 10', 'B) 15', 'C) 17', 'D) 25'],
      correctIndex: 2,
      explanation: 'f(3) = 9. g(9) = 2(9) − 1 = 17.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'f(x) = 2x + 5 fonksiyonunun tersi f⁻¹(x) nedir?',
      options: [
        'A) (x + 5)/2',
        'B) (x − 5)/2',
        'C) 2x − 5',
        'D) 5x − 2',
      ],
      correctIndex: 1,
      explanation: 'y = 2x + 5 → x = (y−5)/2 → f⁻¹(x) = (x−5)/2.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'f tek fonksiyon, g çift fonksiyon. f(−3) = 4, g(−5) = 2 ise 2·f(3) + g(5) kaçtır?',
      options: ['A) −6', 'B) −2', 'C) 6', 'D) 10'],
      correctIndex: 0,
      explanation:
          'Tek: f(3) = −f(−3) = −4. Çift: g(5) = g(−5) = 2. 2(−4) + 2 = −6.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'f(x) = (3x+4)/(2x−5) ise f⁻¹(x) nedir?',
      options: [
        'A) (5x+4)/(2x−3)',
        'B) (2x+5)/(3x−4)',
        'C) (−3x+4)/(2x+5)',
        'D) (5x−4)/(2x+3)',
      ],
      correctIndex: 0,
      explanation:
          'y(2x−5) = 3x+4 → x(2y−3) = 5y+4 → x = (5y+4)/(2y−3). f⁻¹(x) = (5x+4)/(2x−3).',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Taksi açılışta 10 TL, her km için 5 TL alıyor. f(x) = 5x + 10 ise 20 km giden yolcu kaç TL öder?',
      options: ['A) 100', 'B) 110', 'C) 115', 'D) 120'],
      correctIndex: 1,
      explanation: 'f(20) = 5(20) + 10 = 110 TL.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'f(2^x + 1) = 4^x + 3 olduğuna göre f(3) kaçtır?',
      options: ['A) 7', 'B) 9', 'C) 12', 'D) 19'],
      correctIndex: 0,
      explanation:
          '2^x + 1 = 3 → 2^x = 2 → x = 1. f(3) = 4¹ + 3 = 7.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU9Content = StemUnitContent(
  unitId: 'tyt_mat_u9',
  topic: const TopicContent(
    summary:
        'Polinom olması için x\'in kuvvetleri doğal sayı (0,1,2…) olmalıdır; negatif veya kesirli üs olamaz. '
        'Derece, baş katsayı, sabit terim ve katsayılar toplamı kavramları temeldir.',
    rule:
        'Derece: x\'in en büyük kuvveti\n'
        'Baş Katsayı: En büyük dereceli terimin katsayısı\n'
        'Sabit Terim: P(0) → x yerine 0 yaz\n'
        'Katsayılar Toplamı: P(1) → x yerine 1 yaz\n'
        'Bölme: Bölünen = Bölen × Bölüm + Kalan\n'
        'Kalan Bulma: P(x)\'i (ax+b) ile bölümünden kalan → ax+b=0 çöz, P\'ye yaz',
    formulas: [
      'P(x) = Q(x)·B(x) + K(x)',
      'P(x) ÷ (x−a) → Kalan = P(a)',
      'Çarpımda derece: m + n',
      'Bölümde derece: m − n',
      'P(x^k) derecesi: m · k',
    ],
    keyPoints: [
      'x yerine 0 → sabit terim, x yerine 1 → katsayılar toplamı.',
      '"P(x+2)\'nin katsayılar toplamı" denirse P(1+2) = P(3) hesaplanır. Parantez içine dikkat!',
      '"(x−3) P(x)\'in çarpanıdır" demek P(3) = 0 demektir.',
      'Polinom eşitliği: Aynı dereceli terimlerin katsayıları birbirine eşittir.',
      'Tek dereceli terimler toplamı: [P(1)−P(−1)]/2, Çift dereceli: [P(1)+P(−1)]/2.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'P(x) = 2x³ − 4x^(n−2) + 7 polinom ise n en az kaç olmalıdır?',
      steps: [
        'Adım 1: Polinom kuralı: x\'in kuvveti doğal sayı olmalı.',
        'Adım 2: n − 2 ≥ 0 → n ≥ 2',
      ],
      answer: 'En az 2',
    ),
    SolvedExample(
      question:
          'P(x) = (x² − 3x + 1)³ polinomunun sabit terimi ve katsayılar toplamı kaçtır?',
      steps: [
        'Adım 1: Sabit terim → P(0) = (0 − 0 + 1)³ = 1',
        'Adım 2: Katsayılar toplamı → P(1) = (1 − 3 + 1)³ = (−1)³ = −1',
      ],
      answer: 'Sabit terim 1, katsayılar toplamı −1',
    ),
    SolvedExample(
      question:
          'P(x−1) = x² + 3x − 5 olduğuna göre P(x)\'in (x−2) ile bölümünden kalan kaçtır?',
      steps: [
        'Adım 1: Kalan = P(2). P\'nin içinin 2 olması lazım.',
        'Adım 2: x − 1 = 2 → x = 3 yazmalıyız.',
        'Adım 3: 3² + 3(3) − 5 = 9 + 9 − 5 = 13',
      ],
      answer: '13',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: 'Aşağıdakilerden hangisi bir polinomdur?',
      options: [
        'A) P(x) = x² − 1/x',
        'B) P(x) = √x + 3',
        'C) P(x) = x³ − 2x + 5',
        'D) P(x) = x⁻² + 1',
      ],
      correctIndex: 2,
      explanation:
          '1/x = x⁻¹, √x = x^(1/2), x⁻² → üsler doğal sayı değil. Sadece C\'de tüm üsler doğal sayı.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'P(x) = 3x⁴ − 2x² + 5 polinomunun derecesi kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 2,
      explanation: 'En büyük kuvvet 4.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'P(x) = (a−2)x² + (b−3)x + 5 sabit polinom olduğuna göre a + b kaçtır?',
      options: ['A) 4', 'B) 5', 'C) 6', 'D) 7'],
      correctIndex: 1,
      explanation:
          'Sabit polinomda x\'li terimler yok edilir. a−2 = 0 → a = 2. b−3 = 0 → b = 3. a + b = 5.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'P(x) = 2x² − 3x + 1 ise P(2) kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 5'],
      correctIndex: 2,
      explanation: '2(4) − 3(2) + 1 = 8 − 6 + 1 = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'P(x) polinomunun katsayılar toplamı için x yerine hangi sayı yazılır?',
      options: ['A) −1', 'B) 0', 'C) 1', 'D) 2'],
      correctIndex: 2,
      explanation: 'Tanım gereği x = 1 yazılır → P(1).',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'P(x) = 3x^(n−4) + 2x^(10−n) polinom ise n kaç farklı değer alır?',
      options: ['A) 5', 'B) 6', 'C) 7', 'D) 8'],
      correctIndex: 2,
      explanation:
          'n − 4 ≥ 0 → n ≥ 4. 10 − n ≥ 0 → n ≤ 10. n ∈ {4,5,6,7,8,9,10} → 7 değer.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'P(x) = 2x³ − x + 4 polinomunun (x−1) ile bölümünden kalan kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 2,
      explanation: 'x − 1 = 0 → x = 1. P(1) = 2 − 1 + 4 = 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'P(x+1) = x² − x + 3 ise P(0) (sabit terim) kaçtır?',
      options: ['A) 1', 'B) 3', 'C) 5', 'D) 7'],
      correctIndex: 2,
      explanation:
          'P(0) için x + 1 = 0 → x = −1. (−1)² − (−1) + 3 = 1 + 1 + 3 = 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'der[P(x)] = 3, der[Q(x)] = 2 ise der[P(x)·Q(x)] kaçtır?',
      options: ['A) 5', 'B) 6', 'C) 8', 'D) 9'],
      correctIndex: 0,
      explanation: 'Çarpımda dereceler toplanır: 3 + 2 = 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'P(x) = Q(x)·(x²+1) + 3x ve Q(1) = 2 ise P(1) kaçtır?',
      options: ['A) 5', 'B) 6', 'C) 7', 'D) 8'],
      correctIndex: 2,
      explanation:
          'P(1) = Q(1)·(1+1) + 3 = 2·2 + 3 = 7.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'P(x) ikinci dereceden polinomdur. P(0) = 4, P(1) = 6, P(−1) = 4 ise P(2) kaçtır?',
      options: ['A) 6', 'B) 8', 'C) 10', 'D) 12'],
      correctIndex: 2,
      explanation:
          'P(x) = ax²+bx+c. P(0) = c = 4. P(1) = a+b+4 = 6 → a+b = 2. P(−1) = a−b+4 = 4 → a−b = 0 → a = b = 1. P(2) = 4+2+4 = 10.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'P(x) = (x³ − 2x + 1)² polinomunun tek dereceli terimlerinin katsayıları toplamı kaçtır?',
      options: ['A) −4', 'B) −2', 'C) 0', 'D) 2'],
      correctIndex: 1,
      explanation:
          'Tek dereceli toplamı = [P(1)−P(−1)]/2. P(1) = (1−2+1)² = 0. P(−1) = (−1+2+1)² = 4. (0−4)/2 = −2.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'P(x), (x−2) ile bölümünde bölüm Q(x), kalan 5\'tir. Q(x), (x−3) ile bölümünden kalan 2\'dir. P(x)\'in (x²−5x+6) ile bölümünden kalan nedir?',
      options: ['A) 2x − 1', 'B) 2x + 1', 'C) 3x − 1', 'D) x + 3'],
      correctIndex: 1,
      explanation:
          'P(x) = (x−2)Q(x)+5. Q(x) = (x−3)B(x)+2. Yerine koy: P(x) = (x−2)(x−3)B(x)+2(x−2)+5. Kalan: 2x−4+5 = 2x+1.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'P(x) baş katsayısı 2 olan üçüncü dereceden polinomdur. P(1) = P(2) = P(3) = 0 ise P(4) kaçtır?',
      options: ['A) 6', 'B) 12', 'C) 18', 'D) 24'],
      correctIndex: 1,
      explanation:
          'Kökleri 1,2,3 → P(x) = 2(x−1)(x−2)(x−3). P(4) = 2·3·2·1 = 12.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'der[P(x)] = 4, der[Q(x)] = m olmak üzere der[P(x²)/Q(3x)] = 5 ise m kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 2,
      explanation:
          'P(x²) derecesi: 4×2 = 8. Q(3x) derecesi = m (3x yazınca derece değişmez). 8 − m = 5 → m = 3.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU10Content = StemUnitContent(
  unitId: 'tyt_mat_u10',
  topic: const TopicContent(
    summary:
        'Sayma ilkesi: İşlemler bağlıysa (ve) çarpılır, alternatifse (veya) toplanır. '
        'Sıra önemliyse permütasyon, yalnızca seçim varsa kombinasyon kullanılır.',
    rule:
        'Faktöriyel: n! = n·(n−1)·…·1 (0! = 1)\n'
        'Permütasyon (sıra önemli): P(n,r) = n!/(n−r)!\n'
        'Kombinasyon (sıra önemsiz): C(n,r) = n!/[r!·(n−r)!]\n'
        'Tekrarlı Permütasyon: n!/(k₁!·k₂!·…)\n'
        'Olasılık: P(A) = İstenen/Toplam, 0 ≤ P ≤ 1\n'
        'Tümleyen: P(A) + P(A\') = 1',
    formulas: [
      'P(n,r) = n!/(n−r)!',
      'C(n,r) = n!/[r!·(n−r)!]',
      'Dairesel permütasyon: (n−1)!',
      'Tekrarlı: n!/(k₁!·k₂!·…)',
      'P(A) = s(A)/s(S)',
      'P(A\') = 1 − P(A)',
    ],
    keyPoints: [
      '"Dizilebilir/sıralanabilir" → Permütasyon. "Grup/takım oluşturulabilir" → Kombinasyon.',
      'Yan yana olma: Paketleyip tek birim say, sonra paketin iç sıralamasını (2!) çarp.',
      '"En az bir" soruları: Toplam − Hiçbiri formatı en pratik.',
      'Bağımsız olaylarda olasılıklar çarpılır: P(A∩B) = P(A)·P(B).',
      '(x+y)ⁿ açılımında katsayılar toplamı → x=1, y=1 yaz.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          '3 farklı matematik ve 4 farklı fizik kitabı, matematikler bir arada olmak şartıyla kaç farklı şekilde dizilir?',
      steps: [
        'Adım 1: Matematikleri paketleyip 1 nesne say → 1+4 = 5 nesne',
        'Adım 2: 5 nesne 5! şekilde sıralanır',
        'Adım 3: Paketin içi kendi aralarında 3! sıralanır',
        'Adım 4: 5! × 3! = 120 × 6 = 720',
      ],
      answer: '720',
    ),
    SolvedExample(
      question:
          '5 doktor ve 6 hemşire arasından 3 kişilik ekipte en az 1 doktor bulunması şartıyla kaç farklı seçim yapılabilir?',
      steps: [
        'Adım 1: Toplam (şartsız): C(11,3) = 165',
        'Adım 2: İstenmeyen (hiç doktor yok): C(6,3) = 20',
        'Adım 3: 165 − 20 = 145',
      ],
      answer: '145',
    ),
    SolvedExample(
      question:
          'Hileli zarda çift gelme olasılığı tekin 2 katıdır. 3\'ten büyük gelme olasılığı kaçtır?',
      steps: [
        'Adım 1: Tek → k, Çift → 2k. Tekler 3 tane (3k), çiftler 3 tane (6k).',
        'Adım 2: 3k + 6k = 9k = 1 → k = 1/9',
        'Adım 3: P(>3) = P(4)+P(5)+P(6) = 2k+k+2k = 5k',
        'Adım 4: 5 × (1/9) = 5/9',
      ],
      answer: '5/9',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          '5 kişi yan yana duran 3 sandalyeye kaç farklı şekilde oturabilir?',
      options: ['A) 15', 'B) 20', 'C) 60', 'D) 120'],
      correctIndex: 2,
      explanation: 'P(5,3) = 5 × 4 × 3 = 60.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'C(n, 2) = 21 olduğuna göre n kaçtır?',
      options: ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      correctIndex: 1,
      explanation: 'n(n−1)/2 = 21 → n(n−1) = 42. 7×6 = 42 → n = 7.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Madeni para 3 kez atılıyor. En az iki kez tura gelme olasılığı kaçtır?',
      options: ['A) 1/2', 'B) 3/8', 'C) 1/4', 'D) 1/8'],
      correctIndex: 0,
      explanation:
          'TTT(1) + tam 2 tura: TTY,TYT,YTT(3) = 4 durum. Toplam 2³ = 8. P = 4/8 = 1/2.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          '"TATAR" kelimesinin harfleriyle kaç farklı 5 harfli kelime yazılabilir?',
      options: ['A) 10', 'B) 20', 'C) 30', 'D) 60'],
      correctIndex: 2,
      explanation:
          'T×2, A×2, R×1. 5!/(2!·2!) = 120/4 = 30.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          '4 farklı gömlek ve 3 farklı pantolon olan biri kaç farklı kıyafet kombinasyonu yapabilir?',
      options: ['A) 7', 'B) 12', 'C) 64', 'D) 81'],
      correctIndex: 1,
      explanation: 'Çarpma kuralı: 4 × 3 = 12.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'A = {1,2,3,4,5} kümesinin 3 elemanlı alt kümelerinin kaç tanesinde 2 bulunur ama 4 bulunmaz?',
      options: ['A) 3', 'B) 4', 'C) 6', 'D) 10'],
      correctIndex: 0,
      explanation:
          '2 cebe, 4 çöpe. Kalan {1,3,5}\'ten 2 eleman seç: C(3,2) = 3.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Anne, baba ve 3 çocuk fotoğraf çektirecek. Anne ve baba uçlarda olmak şartıyla kaç farklı sıralama vardır?',
      options: ['A) 6', 'B) 12', 'C) 24', 'D) 120'],
      correctIndex: 1,
      explanation:
          'Anne-baba uçlarda: 2! = 2 durum. Ortadaki 3 çocuk: 3! = 6. Toplam: 2 × 6 = 12.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'İki zar atılıyor. Üst yüze gelen sayıların toplamının 8 olma olasılığı kaçtır?',
      options: ['A) 1/6', 'B) 5/36', 'C) 1/9', 'D) 7/36'],
      correctIndex: 1,
      explanation:
          'Toplamı 8: (2,6),(3,5),(4,4),(5,3),(6,2) → 5 durum. P = 5/36.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '5 kız ve 4 erkekten 3 kişi seçilecek. 2 kız 1 erkek seçilme olasılığı kaçtır?',
      options: ['A) 5/14', 'B) 10/21', 'C) 20/63', 'D) 25/42'],
      correctIndex: 1,
      explanation:
          'İstenen: C(5,2)·C(4,1) = 10·4 = 40. Toplam: C(9,3) = 84. P = 40/84 = 10/21.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '(2x − y)⁴ açılımında katsayılar toplamı kaçtır?',
      options: ['A) 1', 'B) 16', 'C) 81', 'D) 0'],
      correctIndex: 0,
      explanation:
          'x = 1, y = 1 yaz: (2−1)⁴ = 1⁴ = 1.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          '4 mektup 5 posta kutusuna, her kutuya en çok 1 mektup atılmak şartıyla kaç farklı şekilde atılabilir?',
      options: ['A) 20', 'B) 60', 'C) 120', 'D) 625'],
      correctIndex: 2,
      explanation:
          'P(5,4) = 5 × 4 × 3 × 2 = 120.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '3 mavi, 4 kırmızı bilye olan torbadan geri atmadan çekilen 2 bilyenin aynı renkte olma olasılığı kaçtır?',
      options: ['A) 1/7', 'B) 2/7', 'C) 3/7', 'D) 4/7'],
      correctIndex: 2,
      explanation:
          'P(MM) = (3/7)·(2/6) = 6/42. P(KK) = (4/7)·(3/6) = 12/42. Toplam: 18/42 = 3/7.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'A→B: 3 yol, B→C: 4 yol. Gidişte kullanılan güzergah dönüşte kullanılmamak şartıyla A→C→A kaç farklı şekilde yapılabilir?',
      options: ['A) 72', 'B) 132', 'C) 143', 'D) 144'],
      correctIndex: 1,
      explanation:
          'Gidiş: 3×4 = 12 yol. Dönüş: 12−1 = 11 (aynı güzergah hariç). Toplam: 12 × 11 = 132.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '6 kişi yuvarlak masaya, Ahmet ve Mehmet yan yana oturmamak şartıyla kaç farklı şekilde oturabilir?',
      options: ['A) 24', 'B) 48', 'C) 72', 'D) 96'],
      correctIndex: 2,
      explanation:
          'Toplam dairesel: (6−1)! = 120. Yan yana: (5−1)!×2! = 48. Yan yana olmayan: 120−48 = 72.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Hedefi vurma olasılığı 2/3 olan okçunun, 3. atışında hedefi ilk kez vurma olasılığı kaçtır?',
      options: ['A) 2/27', 'B) 4/27', 'C) 2/9', 'D) 8/27'],
      correctIndex: 0,
      explanation:
          'İlk 2 ıska, 3.\'de vur: (1/3)·(1/3)·(2/3) = 2/27.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU11Content = StemUnitContent(
  unitId: 'tyt_mat_u11',
  topic: const TopicContent(
    summary:
        'İstatistik, verileri toplama, özetleme ve yorumlama bilimidir. '
        'Merkezi eğilim ölçüleri (ortalama, medyan, mod) ve yayılım ölçüleri (açıklık, standart sapma) temeldir.',
    rule:
        'Aritmetik Ortalama = Toplam / Veri Sayısı\n'
        'Medyan (Ortanca): Sıralı verinin tam ortasındaki değer. Çift sayıda ise ortadaki ikinin ortalaması.\n'
        'Mod (Tepe Değer): En çok tekrar eden sayı.\n'
        'Açıklık = En Büyük − En Küçük\n'
        'Standart Sapma: Verilerin ortalamadan ne kadar saptığını gösterir.',
    formulas: [
      'Ortalama = Σxᵢ / n',
      'Açıklık = xₘₐₓ − xₘᵢₙ',
      'Daire grafikte: Oran = Açı/360',
      'Tüm verilere sabit c eklenir → Ort c artar, sapma değişmez',
      'Tüm veriler k ile çarpılır → Ort k katına, sapma |k| katına çıkar',
    ],
    keyPoints: [
      'Medyan sorulursa önce verileri sırala! Karışık listede medyan bulunmaz.',
      'Başarı karşılaştırması → Ortalamaya bak. Tutarlılık → Standart sapmaya bak (küçük olan daha tutarlı).',
      'Standart sapma 0 ise tüm veriler birbirine eşittir.',
      'Ortalamaya eşit bir değer eklenirse ortalama değişmez.',
      'Daire grafiğinde %25 = 90°, %50 = 180°.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'Veri: 3, 5, 2, 5, 8, 2, 5. Mod ve medyanı bulunuz.',
      steps: [
        'Adım 1: Sırala: 2, 2, 3, 5, 5, 5, 8',
        'Adım 2: Mod = 5 (3 kez tekrar, en çok)',
        'Adım 3: 7 veri → ortadaki 4. terim = 5',
      ],
      answer: 'Mod = 5, Medyan = 5',
    ),
    SolvedExample(
      question:
          '5 kişilik grubun yaş ortalaması 20\'dir. 32 yaşında biri katılırsa yeni ortalama kaçtır?',
      steps: [
        'Adım 1: Eski toplam = 20 × 5 = 100',
        'Adım 2: Yeni toplam = 100 + 32 = 132',
        'Adım 3: Yeni ortalama = 132 / 6 = 22',
      ],
      answer: '22',
    ),
    SolvedExample(
      question:
          'A sınıfı: ort=70, sapma=2. B sınıfı: ort=70, sapma=15. Hangi sınıf daha tutarlıdır?',
      steps: [
        'Adım 1: Başarı → ortalamaya bak: ikisi de 70, eşit.',
        'Adım 2: Tutarlılık → sapmaya bak: A\'nın sapması (2) çok düşük.',
        'Adım 3: A sınıfında herkes 70\'e yakın not almış. B\'de dağılım çok geniş.',
      ],
      answer: 'Başarılar eşit, A sınıfı daha tutarlı.',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          '10, 12, 15, 10, 18 veri grubunun tepe değeri (modu) kaçtır?',
      options: ['A) 10', 'B) 12', 'C) 15', 'D) 18'],
      correctIndex: 0,
      explanation: '10 iki kez tekrar etmiş, diğerleri birer kez.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Ortalaması 15 olan 4 sayıya hangi sayı eklenirse ortalama değişmez?',
      options: ['A) 10', 'B) 15', 'C) 20', 'D) 30'],
      correctIndex: 1,
      explanation: 'Ortalamaya eşit sayı eklenince ortalama değişmez.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '2, 8, 5, 12, 20 veri grubunun açıklığı kaçtır?',
      options: ['A) 12', 'B) 15', 'C) 18', 'D) 20'],
      correctIndex: 2,
      explanation: '20 − 2 = 18.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Aşağıdakilerden hangisi merkezi yayılım (dağılım) ölçüsüdür?',
      options: [
        'A) Aritmetik Ortalama',
        'B) Medyan',
        'C) Mod',
        'D) Standart Sapma',
      ],
      correctIndex: 3,
      explanation: 'A, B, C eğilim ölçüsü. Standart sapma yayılım ölçüsü.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Daire grafiğinde %25\'lik dilim kaç derecelik merkez açıya karşılık gelir?',
      options: ['A) 45', 'B) 60', 'C) 90', 'D) 120'],
      correctIndex: 2,
      explanation: '360° × 0,25 = 90°.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          '1, 2, 3, 3, 4, 5, x veri grubunun modu 3 ve aritmetik ortalaması 4 ise x kaçtır?',
      options: ['A) 3', 'B) 6', 'C) 9', 'D) 10'],
      correctIndex: 3,
      explanation:
          'Toplam = 18+x. Ortalama 4 ise (18+x)/7 = 4 → x = 10. Mod kontrolü: 3 hâlâ en sık (2 kez).',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '160, 162, 165, 170, 173 veri grubunun medyanı kaçtır?',
      options: ['A) 162', 'B) 165', 'C) 166', 'D) 170'],
      correctIndex: 1,
      explanation: 'Sıralı 5 veri → ortadaki (3.) = 165.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Kız sayısı erkeklerin 2 katıdır. Kızların ortalaması 70, erkeklerin 85 ise sınıf ortalaması kaçtır?',
      options: ['A) 75', 'B) 77,5', 'C) 80', 'D) 82,5'],
      correctIndex: 0,
      explanation:
          'Erkek = k, Kız = 2k. Toplam puan: 85k + 140k = 225k. Ortalama: 225k/3k = 75.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Standart sapma 0 ise aşağıdakilerden hangisi kesinlikle doğrudur?',
      options: [
        'A) Tüm değerler 0\'dır',
        'B) Tüm değerler birbirine eşittir',
        'C) Ortalama 0\'dır',
        'D) Medyan hesaplanamaz',
      ],
      correctIndex: 1,
      explanation: 'Sapma 0 → hiç sapma yok → herkes aynı değerde.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Daire grafiğinde A ürünü 120°, B ürünü 90° ile gösteriliyor. A\'dan 40 ton üretildiyse B kaç tondur?',
      options: ['A) 20', 'B) 30', 'C) 45', 'D) 60'],
      correctIndex: 1,
      explanation: '120° → 40 ton. 90° → 40 × 90/120 = 30 ton.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'Ardışık 5 çift sayının standart sapması ile ardışık 5 tek sayının standart sapması arasındaki ilişki nedir?',
      options: [
        'A) Çiftlerinki daha büyük',
        'B) Teklerinki daha büyük',
        'C) Eşittir',
        'D) Hesaplanamaz',
      ],
      correctIndex: 2,
      explanation:
          'İkisi de ikişer ikişer artar, yayılımları aynı → sapmalar eşit.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '10, 10, 10, 20, 20, 20, 50 grubunun medyanı ile ortalaması arasındaki fark kaçtır?',
      options: ['A) 0', 'B) 5', 'C) 10', 'D) 20'],
      correctIndex: 0,
      explanation:
          'Medyan = 20 (4. terim). Toplam = 140, Ort = 20. Fark = 0.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Vida boylarının standart sapması geçen ay 0,5 mm, bu ay 0,1 mm ise bu ne anlama gelir?',
      options: [
        'A) Kalite düşmüştür',
        'B) Vidalar daha uzun üretilmiştir',
        'C) Üretim daha standart hale gelmiştir',
        'D) Boy ortalaması artmıştır',
      ],
      correctIndex: 2,
      explanation:
          'Sapma küçüldü → veriler ortalamaya yaklaştı → daha standart üretim.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '7 kişilik grubun yaş ortalaması 12\'dir. Yaşları 10 ve 14 olan iki kişi ayrılırsa ortalama ve sapma nasıl değişir?',
      options: [
        'A) Ort değişmez, sapma artar',
        'B) Ort değişmez, sapma azalır',
        'C) Ort artar, sapma değişmez',
        'D) Ort azalır, sapma azalır',
      ],
      correctIndex: 1,
      explanation:
          'Ayrılanların ort = (10+14)/2 = 12 (grup ort ile aynı) → ort değişmez. Ortalamadan uzak değerler gittiği için sapma azalır.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Histogramda sınıf aralığı 5 kg, ilk aralık 40-44 ise üçüncü aralık hangisidir?',
      options: ['A) 50-54', 'B) 50-55', 'C) 45-49', 'D) 55-59'],
      correctIndex: 0,
      explanation: '1.: 40-44, 2.: 45-49, 3.: 50-54.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU12Content = StemUnitContent(
  unitId: 'tyt_mat_u12',
  topic: const TopicContent(
    summary:
        'Geometrinin %60\'ı üçgenlerdir. Üçgeni halleden dörtgeni de çözer. '
        'Dik üçgen (Pisagor, Öklid), benzerlik ve özel üçgenler TYT\'nin vazgeçilmezleridir.',
    rule:
        'İç açılar toplamı: 180°, dış açılar toplamı: 360°\n'
        'Pisagor: a² + b² = c² (hipotenüs karesi)\n'
        'Öklid: h² = p·k (dikten dik inerse)\n'
        'Muhteşem üçlü: Hipotenüse ait kenarortay = hipotenüs/2\n'
        'Benzerlik: Paralel doğru → oran eşitliği\n'
        'Prizma: Hacim = Taban Alanı × Yükseklik',
    formulas: [
      'Alan = Taban × Yükseklik / 2',
      'Pisagor: a² + b² = c²',
      'Öklid: h² = p·k',
      'Prizma Hacmi = Taban Alanı × h',
      'Yanal Alan = Taban Çevresi × h',
      'Cisim köşegeni = √(a²+b²+c²)',
    ],
    keyPoints: [
      'Özel üçgenler: 3-4-5, 5-12-13, 8-15-17, 7-24-25 ve katları.',
      '30-60-90: 30° karşısı x, 60° karşısı x√3, 90° karşısı 2x.',
      '45-45-90: Dik kenarlar x, hipotenüs x√2.',
      'İkizkenar üçgen → tepeden dik indir, tabanı ikiye böler.',
      'Ağırlık merkezi kenarortayı köşeden 2:1 oranında böler.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'ABC ikizkenar üçgende |AB| = |AC| ve tepe açısı 40° ise taban açısı kaçtır?',
      steps: [
        'Adım 1: İkizkenar → taban açıları eşit: m(B) = m(C)',
        'Adım 2: 180 − 40 = 140° (taban açıları toplamı)',
        'Adım 3: 140 / 2 = 70°',
      ],
      answer: '70°',
    ),
    SolvedExample(
      question:
          'Dik üçgende dikten hipotenüse inen yükseklik, hipotenüsü 4 cm ve 9 cm\'lik parçalara ayırıyor. Yükseklik kaç cm?',
      steps: [
        'Adım 1: Öklid: h² = p·k',
        'Adım 2: h² = 4 × 9 = 36',
        'Adım 3: h = 6',
      ],
      answer: '6 cm',
    ),
    SolvedExample(
      question:
          'Taban ayrıtları 3 cm ve 4 cm, yüksekliği 10 cm olan prizmanın yarısı su doludur. Suyun hacmi kaçtır?',
      steps: [
        'Adım 1: Taban alanı = 3 × 4 = 12 cm²',
        'Adım 2: Hacim = 12 × 10 = 120 cm³',
        'Adım 3: Yarısı: 120 / 2 = 60 cm³',
      ],
      answer: '60 cm³',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          'Bir üçgenin iç açıları 3, 4 ve 5 ile orantılıdır. En büyük iç açı kaç derecedir?',
      options: ['A) 60', 'B) 75', 'C) 80', 'D) 90'],
      correctIndex: 1,
      explanation:
          '3k + 4k + 5k = 180 → 12k = 180 → k = 15. En büyük: 5×15 = 75°.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Dik kenarları 6 cm ve 8 cm olan dik üçgenin hipotenüsü kaç cm\'dir?',
      options: ['A) 9', 'B) 10', 'C) 12', 'D) 14'],
      correctIndex: 1,
      explanation: '6-8-10 özel üçgeni. √(36+64) = √100 = 10.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Bir kenarı 6 cm olan eşkenar üçgenin çevresi kaç cm\'dir?',
      options: ['A) 12', 'B) 18', 'C) 24', 'D) 36'],
      correctIndex: 1,
      explanation: 'Tüm kenarlar eşit: 3 × 6 = 18.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Taban çevresi 20 cm, yüksekliği 8 cm olan kare prizmanın yanal alanı kaç cm²\'dir?',
      options: ['A) 80', 'B) 160', 'C) 200', 'D) 240'],
      correctIndex: 1,
      explanation: 'Yanal Alan = Çevre × Yükseklik = 20 × 8 = 160.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'ABC üçgeninde ağırlık merkezi G\'dir. Köşeden G\'ye uzaklık 8 cm ise G\'den kenara uzaklık kaç cm\'dir?',
      options: ['A) 2', 'B) 4', 'C) 6', 'D) 8'],
      correctIndex: 1,
      explanation:
          'Ağırlık merkezi kenarortayı 2:1 böler. 2k = 8 → k = 4.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'ABC üçgeninde DE ∥ BC, |AD| = 2, |DB| = 3, |DE| = 4 ise |BC| kaç cm\'dir?',
      options: ['A) 6', 'B) 8', 'C) 10', 'D) 12'],
      correctIndex: 2,
      explanation:
          'Temel benzerlik: AD/AB = DE/BC → 2/5 = 4/BC → BC = 10.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '30-60-90 üçgeninde hipotenüs 12 cm ise 60° nin karşısındaki kenar kaç cm\'dir?',
      options: ['A) 6', 'B) 6√3', 'C) 8', 'D) 12√3'],
      correctIndex: 1,
      explanation:
          '90° karşısı 12 → 30° karşısı 6. 60° karşısı = 6√3.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Dik üçgenin hipotenüsüne ait kenarortay 5 cm ise hipotenüs kaç cm\'dir?',
      options: ['A) 5', 'B) 7,5', 'C) 10', 'D) 15'],
      correctIndex: 2,
      explanation:
          'Muhteşem üçlü: Hipotenüse ait kenarortay = hipotenüs/2. 5 = h/2 → h = 10.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Alanı 24 cm² olan üçgenin tabanı 8 cm ise bu tabana ait yükseklik kaç cm\'dir?',
      options: ['A) 3', 'B) 4', 'C) 6', 'D) 8'],
      correctIndex: 2,
      explanation: '24 = 8·h/2 → h = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Bir ayrıtı 4 cm olan küpün tüm yüzey alanı kaç cm²\'dir?',
      options: ['A) 64', 'B) 96', 'C) 128', 'D) 144'],
      correctIndex: 1,
      explanation: 'Bir yüz = 16 cm². 6 yüz → 6 × 16 = 96.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'ABC üçgeninde |AB| = 6, |AC| = 8, |BC| = 7 dir. A açıortayı BC\'yi kaçe kaç böler?',
      options: ['A) 3\'e 4', 'B) 2\'ye 5', 'C) 3,5\'a 3,5', 'D) 1\'e 6'],
      correctIndex: 0,
      explanation:
          'Açıortay teoremi: BD/DC = AB/AC = 6/8 = 3/4. BC = 7 → 3 ve 4 cm.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Dik üçgende dikten hipotenüse inen yükseklik, hipotenüsü 2 cm ve 8 cm\'ye ayırıyor. Üçgenin alanı kaç cm²\'dir?',
      options: ['A) 10', 'B) 20', 'C) 40', 'D) 80'],
      correctIndex: 1,
      explanation:
          'Öklid: h² = 2×8 = 16 → h = 4. Alan = (2+8)×4/2 = 20.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'ABC üçgeni biçimindeki kağıt, B köşesinden tutulup A köşesi üzerine katlanıyor. Katlama çizgisi aşağıdakilerden hangisidir?',
      options: [
        'A) Yükseklik',
        'B) Açıortay',
        'C) Kenarortay',
        'D) Kenar Orta Dikme',
      ],
      correctIndex: 3,
      explanation:
          'A, B\'nin üzerine geliyorsa AB kenarının tam ortasından dik katlanmış → kenar orta dikmesi.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Ayrıtları 3, 4 ve 12 cm olan dikdörtgenler prizmasının cisim köşegeni kaç cm\'dir?',
      options: ['A) 13', 'B) 14', 'C) 15', 'D) 16'],
      correctIndex: 0,
      explanation:
          '√(9 + 16 + 144) = √169 = 13.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Yarıçapı 3 cm, yüksekliği 10 cm olan silindirdeki su, taban ayrıtı 3 cm ve yüksekliği 5 cm olan kare prizma bardaklara doldurulacaktır. Kaç bardak dolar? (π = 3)',
      options: ['A) 4', 'B) 6', 'C) 9', 'D) 12'],
      correctIndex: 1,
      explanation:
          'Silindir: π·r²·h = 3·9·10 = 270. Bardak: 3²×5 = 45. 270/45 = 6 bardak.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU13Content = StemUnitContent(
  unitId: 'tyt_mat_u13',
  topic: const TopicContent(
    summary:
        'Çokgenler kenar sayısına (n) göre isimlendirilir. Dörtgenler özel kuralları olan bir ailedir: '
        'Yamuk, Paralelkenar, Eşkenar Dörtgen, Dikdörtgen, Kare, Deltoid.',
    rule:
        'Çokgenler:\n'
        '• İç açılar toplamı: (n−2)·180°\n'
        '• Dış açılar toplamı: her zaman 360°\n'
        '• Düzgün çokgende bir dış açı = 360/n\n\n'
        'Dörtgenler:\n'
        '• Yamuk: Alan = (Alt+Üst)/2 · h\n'
        '• Paralelkenar: Alan = Taban · h, köşegenler birbirini ortalar\n'
        '• Eşkenar Dörtgen: Alan = e·f/2, köşegenler dik kesişir\n'
        '• Dikdörtgen: Köşegenler eşit, açılar 90°\n'
        '• Kare: Hem dikdörtgen hem eşkenar dörtgen',
    formulas: [
      'İç açılar toplamı = (n−2)·180°',
      'Düzgün çokgen bir iç açı = 180 − 360/n',
      'Yamuk alanı = (a+c)/2 · h',
      'Paralelkenar alanı = a · h',
      'Eşkenar dörtgen alanı = e·f/2',
      'Düzgün altıgen alanı = 6·(a²√3/4)',
    ],
    keyPoints: [
      'Düzgün altıgen = 6 eşkenar üçgen. Bir iç açısı 120°.',
      'Yamukta yan kenara paralel çekerek paralelkenar + üçgen oluştur.',
      'Kare ve eşkenar dörtgende köşegenler DİK kesişir. Dikdörtgen ve paralelkenarda kesişmez.',
      'Deltoidde köşegenler dik kesişir (sadece biri diğerini ortalar).',
      'Yamukta köşegen kesim noktasından tabanlara paralel: 2ac/(a+c).',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'Düzgün beşgenin bir iç açısı ile düzgün altıgenin bir dış açısının toplamı kaçtır?',
      steps: [
        'Adım 1: Beşgen dış açısı: 360/5 = 72°. İç açısı: 180 − 72 = 108°',
        'Adım 2: Altıgen dış açısı: 360/6 = 60°',
        'Adım 3: Toplam: 108 + 60 = 168°',
      ],
      answer: '168°',
    ),
    SolvedExample(
      question:
          'Alt tabanı 10, üst tabanı 6, yüksekliği 5 cm olan yamuğun alanı kaçtır?',
      steps: [
        'Adım 1: Orta taban = (10+6)/2 = 8 cm',
        'Adım 2: Alan = 8 × 5 = 40 cm²',
      ],
      answer: '40 cm²',
    ),
    SolvedExample(
      question:
          'ABCD paralelkenarında A ve D açıortayları BC üzerinde E noktasında kesişiyor. |AB| = 6 ise |AD| kaçtır?',
      steps: [
        'Adım 1: Paralelkenarda A + D = 180° → açıortaylar dik kesişir (AED = 90°)',
        'Adım 2: Z kuralı: AE bisektör → △ABE ikizkenar → |BE| = |AB| = 6',
        'Adım 3: DE bisektör → △DCE ikizkenar → |EC| = |DC| = 6',
        'Adım 4: |BC| = 6 + 6 = 12 = |AD| (karşılıklı kenarlar eşit)',
      ],
      answer: '12 cm',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          'İç açılar toplamı 1080° olan çokgenin kenar sayısı kaçtır?',
      options: ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      correctIndex: 2,
      explanation: '(n−2)·180 = 1080 → n−2 = 6 → n = 8.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Bir karenin köşegeni 4√2 cm ise alanı kaç cm²\'dir?',
      options: ['A) 8', 'B) 16', 'C) 32', 'D) 64'],
      correctIndex: 1,
      explanation: 'Köşegen = a√2 → a = 4. Alan = 4² = 16.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Dikdörtgenin kısa kenarı 5 cm, köşegeni 13 cm ise alanı kaç cm²\'dir?',
      options: ['A) 60', 'B) 65', 'C) 120', 'D) 130'],
      correctIndex: 0,
      explanation: '5-12-13 üçgeninden uzun kenar = 12. Alan = 5 × 12 = 60.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Düzgün altıgenin bir kenarı 4 cm ise çevresi kaç cm\'dir?',
      options: ['A) 16', 'B) 20', 'C) 24', 'D) 30'],
      correctIndex: 2,
      explanation: '6 × 4 = 24.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Eşkenar dörtgenin köşegen uzunlukları 6 cm ve 8 cm ise alanı kaç cm²\'dir?',
      options: ['A) 12', 'B) 24', 'C) 48', 'D) 96'],
      correctIndex: 1,
      explanation: 'Alan = e·f/2 = 6×8/2 = 24.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'Bir dış açısı 45° olan düzgün çokgen kaç kenarlıdır?',
      options: ['A) 6', 'B) 8', 'C) 9', 'D) 10'],
      correctIndex: 1,
      explanation: '360/n = 45 → n = 8.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'ABCD yamuğunda orta taban 12 cm, yükseklik 6 cm ise alan kaç cm²\'dir?',
      options: ['A) 36', 'B) 48', 'C) 72', 'D) 144'],
      correctIndex: 2,
      explanation: 'Alan = Orta Taban × h = 12 × 6 = 72.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Alanı 48 cm² olan paralelkenarın tabanı 8 cm ise yüksekliği kaç cm\'dir?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 12'],
      correctIndex: 1,
      explanation: '48 = 8·h → h = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Karenin çevresi ile eşkenar üçgenin çevresi eşittir. Kare kenarı 6 cm ise üçgen kenarı kaç cm\'dir?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 12'],
      correctIndex: 2,
      explanation: 'Kare çevresi = 24 = 3a → a = 8.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Deltoid için aşağıdakilerden hangisi daima doğrudur?',
      options: [
        'A) Köşegenleri eşittir',
        'B) Köşegenleri birbirini ortalar',
        'C) Köşegenleri dik kesişir',
        'D) Tüm kenarları eşittir',
      ],
      correctIndex: 2,
      explanation:
          'Deltoid iki ikizkenar üçgenin birleşimidir. Köşegenleri dik kesişir.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'Düzgün altıgenin alanı 96√3 cm² ise bir kenarı kaç cm\'dir?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 12'],
      correctIndex: 2,
      explanation:
          '6·(a²√3/4) = 96√3 → 3a²/2 = 96 → a² = 64 → a = 8.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'ABCD dikdörtgeninde E, CD üzerindedir. △ADE ve △BCE alanları toplamı 20 cm² ise △ABE alanı kaç cm²\'dir?',
      options: ['A) 10', 'B) 20', 'C) 30', 'D) 40'],
      correctIndex: 1,
      explanation:
          'Dikdörtgendeki üçgen kuralı: E, karşı kenarda ise iki yan üçgen toplamı = orta üçgen alanı = 20.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Kenarı a olan kare köşegeninden kesilip paralelkenar olarak birleştirilirse çevre nasıl değişir?',
      options: ['A) Değişmez', 'B) Artar', 'C) Azalır', 'D) Yarıya düşer'],
      correctIndex: 1,
      explanation:
          'Kare çevresi 4a. Paralelkenar çevresi 2a + 2a√2 = 2a(1+√2) ≈ 4,83a. Çevre artar.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Dikdörtgenler prizmasının üç yüzey alanı 12, 15 ve 20 cm² ise hacmi kaç cm³\'tür?',
      options: ['A) 47', 'B) 60', 'C) 80', 'D) 3600'],
      correctIndex: 1,
      explanation:
          'ab=12, bc=15, ac=20. (abc)² = 3600 → abc = 60.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Yamukta alt taban a, üst taban c ise köşegen kesim noktasından tabanlara paralel doğru uzunluğu nedir?',
      options: ['A) (a+c)/2', 'B) √(a·c)', 'C) 2ac/(a+c)', 'D) a−c'],
      correctIndex: 2,
      explanation:
          'Yamukta köşegen kesişim noktasından geçen paralel = 2ac/(a+c).',
      difficulty: 3,
    ),
  ],
);
final _tytMatU14Content = StemUnitContent(
  unitId: 'tyt_mat_u14',
  topic: const TopicContent(
    summary:
        'Çember içi boş halkadır (çevre), daire içi dolu disktir (alan). '
        'Merkez açı, çevre açı, teğet ve kiriş TYT\'nin temel çember konularıdır.',
    rule:
        'Merkez Açı: Köşesi merkezde, gördüğü yaya eşit.\n'
        'Çevre Açı: Köşesi çember üzerinde, gördüğü yayın yarısı.\n'
        'Çapı gören çevre açı: Daima 90°.\n'
        'Teğet: Çembere tek noktada değer, yarıçapla dik.\n'
        'Kiriş: Merkezden kirişe dikme, kirişi ikiye böler.',
    formulas: [
      'Çevre = 2πr',
      'Alan = πr²',
      'Yay uzunluğu = (α/360)·2πr',
      'Dilim alanı = (α/360)·πr²',
      'Çevre açı = Yay/2 = Merkez açı/2',
    ],
    keyPoints: [
      'Teğet varsa → merkezden teğete dik çiz (90°).',
      'Çapı gören çevre açı = 90° (Muhteşem üçlü).',
      'Bir dış noktadan çizilen iki teğet uzunlukları eşittir (Külah kuralı).',
      'Merkezden kirişe inen dikme kirişi ortalar → dik üçgen oluşur.',
      'Yarıçap oranı k ise alan oranı k².',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'O merkezli çemberde merkez açı 80°. Bu yayı gören çevre açı kaçtır?',
      steps: [
        'Adım 1: Merkez açı = yay = 80°',
        'Adım 2: Çevre açı = yay/2 = 80/2 = 40°',
      ],
      answer: '40°',
    ),
    SolvedExample(
      question:
          'r=5 büyük daire, r=3 küçük daire (aynı merkezli). Kalan alan kaç π cm²?',
      steps: [
        'Adım 1: Büyük: 25π, Küçük: 9π',
        'Adım 2: Fark: 25π − 9π = 16π',
      ],
      answer: '16π cm²',
    ),
    SolvedExample(
      question:
          'r = 12 cm, 60° merkez açının yay uzunluğu kaçtır? (π = 3)',
      steps: [
        'Adım 1: (60/360)·2·3·12',
        'Adım 2: (1/6)·72 = 12 cm',
      ],
      answer: '12 cm',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question: 'Yarıçapı 4 cm olan dairenin alanı kaç π cm²\'dir?',
      options: ['A) 8', 'B) 12', 'C) 16', 'D) 20'],
      correctIndex: 2,
      explanation: 'π·4² = 16π.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Çapı 10 cm olan çemberin çevresi kaç π cm\'dir?',
      options: ['A) 5', 'B) 10', 'C) 20', 'D) 25'],
      correctIndex: 1,
      explanation: 'r = 5. Çevre = 2π·5 = 10π.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Bir çemberde 100°\'lik yayı gören çevre açı kaç derecedir?',
      options: ['A) 25', 'B) 50', 'C) 100', 'D) 200'],
      correctIndex: 1,
      explanation: 'Çevre açı = yay/2 = 50°.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          '90° merkez açılı daire diliminin alanı, tüm dairenin kaçta kaçıdır?',
      options: ['A) 1/2', 'B) 1/3', 'C) 1/4', 'D) 1/6'],
      correctIndex: 2,
      explanation: '90/360 = 1/4.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'Çember üzerindeki en uzun kirişe ne ad verilir?',
      options: ['A) Yarıçap', 'B) Teğet', 'C) Kesen', 'D) Çap'],
      correctIndex: 3,
      explanation: 'En uzun kiriş çaptır.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'r = 4 cm olan çeyrek dairenin çevresi kaç cm\'dir? (π = 3)',
      options: ['A) 6', 'B) 10', 'C) 12', 'D) 14'],
      correctIndex: 3,
      explanation:
          'Yay: (1/4)·2·3·4 = 6. Düz kenarlar: 4+4 = 8. Toplam: 14.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Uzunluğu 10 cm olan yelkovan 30 dakikada kaç cm² alan tarar? (π = 3)',
      options: ['A) 75', 'B) 100', 'C) 150', 'D) 300'],
      correctIndex: 2,
      explanation: '30 dk = yarım daire. (1/2)·3·100 = 150.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'AB çap, C çember üzerinde. |AC| = 6, |BC| = 8 ise yarıçap kaç cm\'dir?',
      options: ['A) 5', 'B) 6', 'C) 8', 'D) 10'],
      correctIndex: 0,
      explanation:
          'Çapı gören çevre açı 90°. ABC dik üçgen: 6-8-10. Çap = 10, r = 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Çevresi 12π cm olan dairenin alanı kaç π cm²\'dir?',
      options: ['A) 12', 'B) 24', 'C) 36', 'D) 144'],
      correctIndex: 2,
      explanation: '2πr = 12π → r = 6. Alan = π·36 = 36π.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Çemberde kiriş merkeze yaklaştıkça uzunluğu nasıl değişir?',
      options: ['A) Azalır', 'B) Artar', 'C) Değişmez', 'D) Yarıya iner'],
      correctIndex: 1,
      explanation: 'Merkeze en yakın kiriş çaptır ve en uzundur.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          'r = 2 cm olan 3 eş çember birbirine dıştan teğettir. Merkezleri birleştiren üçgenin çevresi kaç cm\'dir?',
      options: ['A) 6', 'B) 8', 'C) 12', 'D) 24'],
      correctIndex: 2,
      explanation:
          'Her kenar = 2+2 = 4. Eşkenar üçgen çevresi = 3×4 = 12.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Kiriş uzunluğu 8 cm, kirişin merkeze uzaklığı 3 cm ise yarıçap kaç cm\'dir?',
      options: ['A) 4', 'B) 5', 'C) 6', 'D) 7'],
      correctIndex: 1,
      explanation:
          'Dikme kirişi ikiye böler: 4 cm. Dik üçgen: 3-4-5. r = 5.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Kare bahçenin köşesine 4 m iple bağlanan kuzunun otlayabileceği alan en çok kaç m²\'dir? (π = 3)',
      options: ['A) 12', 'B) 16', 'C) 24', 'D) 48'],
      correctIndex: 0,
      explanation:
          'Köşede çeyrek daire: (1/4)·3·16 = 12.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Yarıçapları oranı 2 olan iki dairenin alanları oranı kaçtır?',
      options: ['A) 2', 'B) 4', 'C) 8', 'D) 16'],
      correctIndex: 1,
      explanation: 'Yarıçap oranı k ise alan oranı k² = 4.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Bir tekerlek 5 tam turda 150 m yol gidiyorsa çevresi kaç m\'dir?',
      options: ['A) 15', 'B) 25', 'C) 30', 'D) 50'],
      correctIndex: 2,
      explanation: '150 = 5 × Çevre → Çevre = 30.',
      difficulty: 3,
    ),
  ],
);
final _tytMatU15Content = StemUnitContent(
  unitId: 'tyt_mat_u15',
  topic: const TopicContent(
    summary:
        'Analitik geometri, şekilleri koordinat sisteminde incelemektir. '
        'Her noktanın (x, y) adresi vardır. Doğru denklemi, uzaklık, orta nokta ve eğim temeldir.',
    rule:
        'İki nokta arası uzaklık: √[(x₂−x₁)²+(y₂−y₁)²]\n'
        'Orta nokta: ((x₁+x₂)/2, (y₁+y₂)/2)\n'
        'Eğim: m = (y₂−y₁)/(x₂−x₁)\n'
        'Doğru denklemi: y − y₁ = m(x − x₁)\n'
        'Paralel: m₁ = m₂, Dik: m₁·m₂ = −1\n'
        'Eksen kesişimi: x bul → y=0, y bul → x=0',
    formulas: [
      '|AB| = √[(x₂−x₁)²+(y₂−y₁)²]',
      'Orta Nokta = ((x₁+x₂)/2, (y₁+y₂)/2)',
      'm = (y₂−y₁)/(x₂−x₁)',
      'y − y₁ = m(x − x₁)',
      'Paralel: m₁ = m₂',
      'Dik: m₁·m₂ = −1',
    ],
    keyPoints: [
      'Bölgeler: I(+,+), II(−,+), III(−,−), IV(+,−).',
      'Orijinden geçen doğru: y = mx (sabit yok).',
      '"Dik kesişiyor" → m₁·m₂ = −1 formülünü hemen uygula.',
      'Çakışık doğrularda tüm katsayı oranları eşittir.',
      'Üçgen ağırlık merkezi = köşe koordinatlarının ortalaması.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'A(1, 2) ve B(4, 6) noktaları arasındaki uzaklık kaçtır?',
      steps: [
        'Adım 1: Δx = 4−1 = 3, Δy = 6−2 = 4',
        'Adım 2: √(9+16) = √25 = 5',
      ],
      answer: '5 birim',
    ),
    SolvedExample(
      question:
          'A(2, 3) noktasından geçen, eğimi 4 olan doğrunun denklemi nedir?',
      steps: [
        'Adım 1: y − 3 = 4(x − 2)',
        'Adım 2: y = 4x − 8 + 3 = 4x − 5',
      ],
      answer: 'y = 4x − 5',
    ),
    SolvedExample(
      question:
          'y = 2x + 5 doğrusuna dik olan ve orijinden geçen doğrunun denklemi nedir?',
      steps: [
        'Adım 1: m₁ = 2. Dik → m₁·m₂ = −1 → m₂ = −1/2',
        'Adım 2: Orijinden geçiyor → y = mx → y = −x/2',
      ],
      answer: 'y = −x/2',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── KOLAY (1-5) ────────
    StemQuestion(
      question:
          'A(3, −2) noktası koordinat sisteminin hangi bölgesindedir?',
      options: ['A) 1. Bölge', 'B) 2. Bölge', 'C) 3. Bölge', 'D) 4. Bölge'],
      correctIndex: 3,
      explanation: 'x > 0, y < 0 → 4. bölge.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'A(−2, 4) ve B(6, 4) noktaları arası uzaklık kaç birimdir?',
      options: ['A) 4', 'B) 6', 'C) 8', 'D) 10'],
      correctIndex: 2,
      explanation: 'y\'ler eşit → |6−(−2)| = 8.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          'A(2, 5) ve B(4, 1) noktalarının orta noktası nedir?',
      options: ['A) (3, 3)', 'B) (3, 2)', 'C) (6, 6)', 'D) (2, 4)'],
      correctIndex: 0,
      explanation: '((2+4)/2, (5+1)/2) = (3, 3).',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'y = 3x − 1 doğrusunun eğimi kaçtır?',
      options: ['A) −1', 'B) 1', 'C) 3', 'D) 1/3'],
      correctIndex: 2,
      explanation: 'y = mx + n formatında m = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question:
          '2x − 3y + 6 = 0 doğrusunun y eksenini kestiği noktanın ordinatı kaçtır?',
      options: ['A) 2', 'B) 3', 'C) −2', 'D) −3'],
      correctIndex: 0,
      explanation: 'x = 0: −3y + 6 = 0 → y = 2.',
      difficulty: 1,
    ),
    // ──────── ORTA (6-10) ────────
    StemQuestion(
      question:
          'A(1, 2) ve B(3, 8) noktalarından geçen doğrunun eğimi kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 6'],
      correctIndex: 1,
      explanation: '(8−2)/(3−1) = 6/2 = 3.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'x = 2 ve y = −3 doğrularının kesişim noktası hangisidir?',
      options: ['A) (2, 0)', 'B) (0, −3)', 'C) (2, −3)', 'D) (−3, 2)'],
      correctIndex: 2,
      explanation: 'x her yerde 2, y her yerde −3 → (2, −3).',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'y = mx + 4 doğrusu A(1, 7) noktasından geçiyorsa m kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 2,
      explanation: '7 = m + 4 → m = 3.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          '3x + 4y − 12 = 0 doğrusu ile eksenler arasında kalan üçgenin alanı kaçtır?',
      options: ['A) 6', 'B) 12', 'C) 18', 'D) 24'],
      correctIndex: 0,
      explanation:
          'x = 0 → y = 3. y = 0 → x = 4. Alan = 4×3/2 = 6.',
      difficulty: 2,
    ),
    StemQuestion(
      question:
          'Orijine uzaklığı 13, apsisi 5 olan noktanın ordinatı (pozitif) kaçtır?',
      options: ['A) 8', 'B) 10', 'C) 12', 'D) 13'],
      correctIndex: 2,
      explanation: '5-12-13 üçgeni. √(25+y²) = 13 → y = 12.',
      difficulty: 2,
    ),
    // ──────── ZOR (11-15) ────────
    StemQuestion(
      question:
          '2x − y + 5 = 0 doğrusuna paralel olan ve A(1, 2) noktasından geçen doğrunun denklemi nedir?',
      options: ['A) y = 2x', 'B) y = 2x + 1', 'C) y = −2x + 4', 'D) 2x − y = 0'],
      correctIndex: 0,
      explanation:
          'Eğim = 2 (paralel). y − 2 = 2(x − 1) → y = 2x. (A ve D aynı doğru, A formatı doğru.)',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Köşeleri A(0,0), B(6,0), C(0,8) olan üçgenin ağırlık merkezi nedir?',
      options: ['A) (2, 3)', 'B) (2, 8/3)', 'C) (3, 4)', 'D) (3, 8/3)'],
      correctIndex: 1,
      explanation:
          'x: (0+6+0)/3 = 2. y: (0+0+8)/3 = 8/3. → (2, 8/3).',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'A(2, −3) noktasından x eksenine uğrayıp B(8, 5) noktasına giden en kısa yol kaç birimdir?',
      options: ['A) 10', 'B) 12', 'C) 13', 'D) 15'],
      correctIndex: 0,
      explanation:
          'A(4. bölge) ve B(1. bölge) x ekseninin farklı taraflarında → doğrudan bağlanır. √(6²+8²) = √100 = 10.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'x + y = 6 ve x − y = 2 doğrularının kesişim noktasının orijine uzaklığı kaçtır?',
      options: ['A) √10', 'B) 2√5', 'C) 5', 'D) 6'],
      correctIndex: 1,
      explanation:
          'Topla: 2x = 8 → x = 4, y = 2. √(16+4) = √20 = 2√5.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'ax + 2y − 4 = 0 ile 4x + by + 8 = 0 çakışıksa a + b kaçtır?',
      options: ['A) −6', 'B) −2', 'C) 4', 'D) 6'],
      correctIndex: 0,
      explanation:
          'Oran: a/4 = 2/b = −4/8 = −1/2. a = −2, b = −4. Toplam: −6.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// TYT FİZİK İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────
// TYT FİZİK İÇERİKLERİ (7 ünite)
// ─────────────────────────────────────────────

final _tytFizU1Content = StemUnitContent(
  unitId: 'tyt_fiz_u1',
  topic: const TopicContent(
    summary:
        'Fizik, madde ve enerji arasındaki etkileşimi inceleyen, deney ve gözleme dayalı bir bilim dalıdır.',
    rule:
        'Temel Büyüklükler (KISAMAL): Kütle, Işık Şiddeti, Sıcaklık, Akım, Madde Miktarı, Uzunluk, Zaman\n'
        'Vektörel: Hız, Kuvvet, İvme, Yer Değiştirme (yönü var)\n'
        'Skaler: Kütle, Zaman, Enerji, Sıcaklık (yalnız sayı+birim)',
    formulas: [
      'Özkütle: d = m / V (g/cm³)',
    ],
    keyPoints: [
      'Sıcaklık temel büyüklüktür ama ısı (enerji) türetilmiştir.',
      'Ağırlık vektörel, kütle skalerdir; karıştırma!',
      'Fiziğin alt dalları: Mekanik, Optik, Termodinamik, Elektromanyetizma, Nükleer, Atom, Katıhal.',
      'Bilimsel kurumlar: TÜBİTAK, CERN, NASA, ESA, TENMAK.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kütlesi 200 g, hacmi 50 cm³ olan cismin özkütlesi kaç g/cm³?',
      steps: ['d = m/V', 'd = 200/50 = 4'],
      answer: '4 g/cm³',
    ),
    SolvedExample(
      question: 'Hem temel hem skaler büyüklük hangisidir?',
      steps: ['KISAMAL listesindeki tüm büyüklükler temel ve skalerdir.', 'Zaman, Kütle, Sıcaklık vb.'],
      answer: 'Zaman (veya Kütle, Sıcaklık vb.)',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Hangisi fiziğin alt dallarından biri değildir?', options: ['A) Optik', 'B) Mekanik', 'C) Biyoloji', 'D) Termodinamik'], correctIndex: 2, explanation: 'Biyoloji ayrı bir bilim dalıdır.', difficulty: 1),
    StemQuestion(question: 'SI birim sisteminde uzunluğun birimi nedir?', options: ['A) Santimetre', 'B) Metre', 'C) Kilometre', 'D) Milimetre'], correctIndex: 1, explanation: 'SI\'da uzunluk birimi metredir.', difficulty: 1),
    StemQuestion(question: 'Hangisi vektörel bir büyüklüktür?', options: ['A) Kütle', 'B) Zaman', 'C) Kuvvet', 'D) Sıcaklık'], correctIndex: 2, explanation: 'Kuvvetin yönü vardır, vektöreldir.', difficulty: 1),
    StemQuestion(question: 'Hangi eşleştirme yanlıştır?', options: ['A) Akım - Ampermetre', 'B) Sıcaklık - Termometre', 'C) Kütle - Dinamometre', 'D) Uzunluk - Şerit metre'], correctIndex: 2, explanation: 'Kütle eşit kollu terazi ile ölçülür; dinamometre ağırlık ölçer.', difficulty: 2),
    StemQuestion(question: '"Hız" ve "Sürat" için hangisi ortaktır?', options: ['A) İkisi de vektörel', 'B) Birimleri aynı', 'C) İkisi de temel büyüklük', 'D) İkisi de skaler'], correctIndex: 1, explanation: 'İkisinin de birimi m/s; hız vektörel, sürat skalerdir.', difficulty: 2),
    StemQuestion(question: 'Hangisi nükleer fiziğin alanına girer?', options: ['A) Işığın kırılması', 'B) Isı yalıtımı', 'C) Atom çekirdeği tepkimeleri', 'D) Elektrik devreleri'], correctIndex: 2, explanation: 'Nükleer fizik çekirdek yapısını ve radyoaktifliği inceler.', difficulty: 2),
    StemQuestion(question: 'Astronot Ay\'a gittiğinde hangi niceliği değişir?', options: ['A) Kütlesi', 'B) Madde miktarı', 'C) Ağırlığı', 'D) Eylemsizliği'], correctIndex: 2, explanation: 'Yerçekimi değiştiği için ağırlık değişir, kütle değişmez.', difficulty: 3),
    StemQuestion(question: 'CERN\'de yapılan deneyler hangi alt dalın konusudur?', options: ['A) Mekanik', 'B) Yüksek Enerji Fiziği', 'C) Optik', 'D) Termodinamik'], correctIndex: 1, explanation: 'Parçacık hızlandırıcılar yüksek enerji fiziğinin konusudur.', difficulty: 3),
  ],
);

final _tytFizU2Content = StemUnitContent(
  unitId: 'tyt_fiz_u2',
  topic: const TopicContent(
    summary:
        'Bir cismin sabit noktaya göre yer değiştirmesine hareket, hareket durumunu değiştiren etkiye kuvvet denir.',
    rule:
        'Yol skaler (toplam mesafe), yer değiştirme vektörel (en kısa mesafe)\n'
        'Newton 1: Eylemsizlik (durumunu koruma)\n'
        'Newton 2: F = m·a (Temel Prensip)\n'
        'Newton 3: Etki-Tepki (zıt yönlü, eşit büyüklükte, farklı cisimler üzerinde)',
    formulas: [
      'Sürat: v = x / t',
      'Hız: v = Δx / t (vektörel)',
      'İvme: a = Δv / t',
      'Net Kuvvet: F = m · a (N, kg, m/s²)',
    ],
    keyPoints: [
      'Sabit hızlı harekette ivme sıfırdır.',
      'Etki-tepki kuvvetleri farklı cisimler üzerine uygulanır.',
      'Sürtünme her zaman harekete zıt yönlü olmak zorunda değildir (yürürken ileriye doğru).',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '4 kg cisme 20 N net kuvvet uygulanırsa ivme kaç m/s²?',
      steps: ['F = m·a', '20 = 4·a → a = 5'],
      answer: '5 m/s²',
    ),
    SolvedExample(
      question: '200 m yolu 10 s\'de alan aracın sürati kaç m/s?',
      steps: ['v = x/t', 'v = 200/10 = 20'],
      answer: '20 m/s',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Birim zamandaki yer değiştirmeye ne denir?', options: ['A) Sürat', 'B) İvme', 'C) Hız', 'D) Konum'], correctIndex: 2, explanation: 'Yer değiştirme vektörel → birim zamandaki karşılığı hızdır.', difficulty: 1),
    StemQuestion(question: 'Hangisi türetilmiş ve vektörel bir büyüklüktür?', options: ['A) Kütle', 'B) Kuvvet', 'C) Zaman', 'D) Sürat'], correctIndex: 1, explanation: 'Kuvvet hem türetilmiştir hem yönü vardır.', difficulty: 1),
    StemQuestion(question: 'Sürtünmesiz ortamda duran cisme net kuvvet uygulanmazsa ne olur?', options: ['A) Hızlanır', 'B) Yavaşlar', 'C) Durmaya devam eder', 'D) Zıt yöne gider'], correctIndex: 2, explanation: 'Eylemsizlik yasası: duran cisim durmaya devam eder.', difficulty: 1),
    StemQuestion(question: 'Dairesel pistte tam bir tur atan sporcu için hangisi doğrudur?', options: ['A) Yer değiştirmesi sıfır', 'B) Aldığı yol sıfır', 'C) Hızı sabit', 'D) İvmesi sıfır'], correctIndex: 0, explanation: 'Başlangıç noktasına döndüğü için yer değiştirme sıfırdır.', difficulty: 2),
    StemQuestion(question: '2 kg cisme 10 N kuvvet, 4 N sürtünme varsa ivme kaç m/s²?', options: ['A) 5', 'B) 2', 'C) 3', 'D) 7'], correctIndex: 2, explanation: 'F_net = 10−4 = 6 N. a = 6/2 = 3.', difficulty: 2),
    StemQuestion(question: 'Hangisi etki-tepki yasasına örnek olamaz?', options: ['A) Masadaki kitap-masa tepkisi', 'B) Duvara vurulunca el acıması', 'C) Serbest düşen cismin hızlanması', 'D) Kürek çekerken su-tekne etkileşimi'], correctIndex: 2, explanation: 'Serbest düşüş yerçekimi etkisindeki ivmeli harekettir, temas tepki çifti değil.', difficulty: 2),
    StemQuestion(question: 'Hız-zaman grafiğinin altındaki alan neyi verir?', options: ['A) İvme', 'B) Yer Değiştirme', 'C) Sürat', 'D) Toplam Kuvvet'], correctIndex: 1, explanation: 'v-t grafiğinin alanı yer değiştirmeyi verir.', difficulty: 3),
    StemQuestion(question: 'Buz patencisi duran arkadaşını itince ikisi de hareket eder. Hangi yasalarla açıklanır?', options: ['A) Sadece Eylemsizlik', 'B) Sadece Temel Prensip', 'C) Etki-Tepki ve Temel Prensip', 'D) Enerjinin Korunumu'], correctIndex: 2, explanation: 'İtme: etki-tepki. Kütleye göre hız: temel prensip.', difficulty: 3),
  ],
);

final _tytFizU3Content = StemUnitContent(
  unitId: 'tyt_fiz_u3',
  topic: const TopicContent(
    summary:
        'İş, kuvvetin cisme kendi doğrultusunda yol aldırmasıdır. Enerji iş yapabilme yeteneği, güç birim zamanda yapılan iştir.',
    rule:
        'İş şartı: Kuvvet ve yer değiştirme aynı doğrultuda olmalı\n'
        'Mekanik Enerji = Ek + Ep (sürtünmesiz ortamda korunur)\n'
        'Verim = Yararlı iş / Harcanan enerji (hiçbir sistem %100 değil)\n'
        'Yenilenebilir: Güneş, rüzgar, jeotermal, biyokütle, hidrojen',
    formulas: [
      'İş: W = F · x (Joule)',
      'Güç: P = W / t (Watt)',
      'Kinetik Enerji: Ek = ½mv²',
      'Potansiyel Enerji: Ep = mgh',
    ],
    keyPoints: [
      'Çantayı yatayda taşıyan kişi fiziksel iş yapmaz (kuvvet düşey, yol yatay).',
      'Net kuvvetin yaptığı iş = kinetik enerjideki değişim.',
      'Sürtünme kuvvetinin yaptığı iş ısı enerjisine dönüşür.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '20 N kuvvetle 5 m hareket ettirilen kutuya yapılan iş kaç J?',
      steps: ['W = F·x', 'W = 20×5 = 100'],
      answer: '100 J',
    ),
    SolvedExample(
      question: '2 kg cisim 10 m yüksekliğe çıkarılırsa Ep kaç J? (g=10)',
      steps: ['Ep = mgh', 'Ep = 2×10×10 = 200'],
      answer: '200 J',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Güç birimi hangisidir?', options: ['A) Joule', 'B) Newton', 'C) Watt', 'D) Pascal'], correctIndex: 2, explanation: 'Birim zamanda yapılan iş (J/s) = Watt.', difficulty: 1),
    StemQuestion(question: 'Hız 2 katına çıkarsa kinetik enerji kaç kat artar?', options: ['A) 2', 'B) 4', 'C) 6', 'D) 8'], correctIndex: 1, explanation: 'Ek ∝ v². Hız 2 kat → enerji 4 kat.', difficulty: 1),
    StemQuestion(question: 'Hangisi yenilenemez enerji kaynağıdır?', options: ['A) Rüzgar', 'B) Güneş', 'C) Doğalgaz', 'D) Jeotermal'], correctIndex: 2, explanation: 'Fosil yakıtlar yenilenemez.', difficulty: 1),
    StemQuestion(question: '500 J işi 10 s\'de yapan motorun gücü kaç W?', options: ['A) 50', 'B) 500', 'C) 5000', 'D) 5'], correctIndex: 0, explanation: 'P = 500/10 = 50 W.', difficulty: 2),
    StemQuestion(question: 'Hangisinde fiziksel iş yapılır?', options: ['A) Duvarı iten ama hareket ettiremeyen çocuk', 'B) Kitap okuyan öğrenci', 'C) Bebeği kaldıran anne', 'D) Çantayı yatayda taşıyan kişi'], correctIndex: 2, explanation: 'Kuvvet (yukarı) ve yol (yukarı) aynı doğrultuda.', difficulty: 2),
    StemQuestion(question: 'Sürtünmesiz ortamda yukarı fırlatılan ciste ne korunur?', options: ['A) Kinetik enerji', 'B) Potansiyel enerji', 'C) Mekanik enerji', 'D) Hız'], correctIndex: 2, explanation: 'Sürtünmesiz ortamda toplam mekanik enerji korunur.', difficulty: 2),
    StemQuestion(question: 'Verimi %80 olan makine 200 J harcarsa yararlı iş kaç J?', options: ['A) 160', 'B) 180', 'C) 200', 'D) 240'], correctIndex: 0, explanation: '200 × 0,80 = 160 J.', difficulty: 3),
    StemQuestion(question: 'Barajlarda enerji dönüşüm sırası nedir?', options: ['A) Kinetik→Potansiyel→Elektrik', 'B) Potansiyel→Kinetik→Elektrik', 'C) Isı→Hareket→Elektrik', 'D) Elektrik→Potansiyel→Kinetik'], correctIndex: 1, explanation: 'Yükseklik (Ep) → akış (Ek) → jeneratör (elektrik).', difficulty: 3),
  ],
);

final _tytFizU4Content = StemUnitContent(
  unitId: 'tyt_fiz_u4',
  topic: const TopicContent(
    summary:
        'Sıcaklık taneciklerin ortalama kinetik enerjisinin göstergesi, ısı sıcaklık farkından dolayı transfer edilen enerjidir.',
    rule:
        'Isıl denge: Sıcaklıklar eşitlenene kadar ısı alışverişi sürer\n'
        'Hâl değişimi sırasında sıcaklık sabit kalır\n'
        'Isı iletimi: Işıma (vakum), Konveksiyon (sıvı/gaz), İletim (katı)\n'
        'Genleşme: Sıcaklık artar → hacim artar (su 0-4°C hariç)',
    formulas: [
      'Isı: Q = m·c·ΔT (sıcaklık değişimi)',
      'Isı: Q = m·L (hâl değişimi)',
      'Isı Sığası: C = m·c',
    ],
    keyPoints: [
      'Maddenin "ısısı" olmaz; "iç enerjisi" veya "aldığı/verdiği ısı" olur.',
      '0 K (Mutlak Sıfır) = −273°C, ulaşılabilecek en düşük sıcaklık.',
      'Öz ısı (c) ayırt edicidir, ısı sığası (C) değildir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'c = 0,5 cal/g°C, 100 g buzun sıcaklığını 20°C artırmak için kaç cal gerekir?',
      steps: ['Q = m·c·ΔT', 'Q = 100 × 0,5 × 20 = 1000'],
      answer: '1000 cal',
    ),
    SolvedExample(
      question: 'Yalıtılmış kapta 20°C ve 80°C eşit kütleli sular karıştırılırsa denge sıcaklığı?',
      steps: ['Aynı madde, eşit kütle → aritmetik ortalama', '(20+80)/2 = 50'],
      answer: '50°C',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'SI\'da sıcaklık birimi hangisidir?', options: ['A) Celsius', 'B) Fahrenheit', 'C) Kelvin', 'D) Kalori'], correctIndex: 2, explanation: 'SI\'da sıcaklık birimi Kelvin.', difficulty: 1),
    StemQuestion(question: 'Hangi ısı iletim yolu maddeye ihtiyaç duymaz?', options: ['A) İletim', 'B) Işıma', 'C) Konveksiyon', 'D) İletkenlik'], correctIndex: 1, explanation: 'Işıma boşlukta da yayılır (Güneş→Dünya).', difficulty: 1),
    StemQuestion(question: 'Hangisi madde miktarından bağımsız ayırt edici özelliktir?', options: ['A) Isı Sığası', 'B) İç Enerji', 'C) Isı', 'D) Öz Isı'], correctIndex: 3, explanation: 'Öz ısı maddenin türüne bağlı, kütleden bağımsız.', difficulty: 1),
    StemQuestion(question: 'Saf sıvı kaynarken hangi özelliği değişir?', options: ['A) Sıcaklığı', 'B) Öz ısısı', 'C) Potansiyel enerjisi', 'D) Kinetik enerjisi'], correctIndex: 2, explanation: 'Hâl değişiminde sıcaklık sabit, bağlar koptuğu için Ep artar.', difficulty: 2),
    StemQuestion(question: 'Deniz kenarında buzun erime ve suyun kaynama noktası?', options: ['A) −10/100', 'B) 0/100', 'C) 0/110', 'D) 4/100'], correctIndex: 1, explanation: 'Standart şartlarda 0°C erime, 100°C kaynama.', difficulty: 2),
    StemQuestion(question: 'Katıda ısı iletim hızı hangisine bağlı değildir?', options: ['A) Yüzey alanı', 'B) Madde cinsi', 'C) Sıcaklık farkı', 'D) Toplam kütle'], correctIndex: 3, explanation: 'İletim hızı geometrik boyutlara ve ΔT\'ye bağlı, kütleye değil.', difficulty: 2),
    StemQuestion(question: 'Kışın demir bank neden tahtadan soğuk hissedilir?', options: ['A) Sıcaklığı daha düşük', 'B) Öz ısısı daha büyük', 'C) Isı iletkenliği daha yüksek', 'D) Isı sığası küçük'], correctIndex: 2, explanation: 'Aynı ortamda sıcaklıklar eşit; demir ısıyı hızlı iletir → soğuk hissettirir.', difficulty: 3),
    StemQuestion(question: 'Suyun +4°C\'deki özel durumu hangisidir?', options: ['A) Hacmi en büyük', 'B) Özkütlesi en büyük', 'C) Donmaya başlar', 'D) Isı sığası en düşük'], correctIndex: 1, explanation: 'Su +4°C\'de en küçük hacim, en büyük özkütle.', difficulty: 3),
  ],
);

final _tytFizU5Content = StemUnitContent(
  unitId: 'tyt_fiz_u5',
  topic: const TopicContent(
    summary:
        'Basınç, birim yüzeye dik etki eden kuvvettir. Katılar ağırlıkla, sıvılar derinlik-özkütleyle, gazlar tanecik hareketleriyle basınç uygular.',
    rule:
        'Pascal Prensibi: Sıvılar basıncı her yöne aynen iletir\n'
        'Bernoulli: Akışkan hızı artınca basınç azalır\n'
        'Açık hava basıncı: Yükseldikçe azalır (Toricelli)\n'
        'Kapalı gaz: Hacim azalır veya sıcaklık artarsa basınç artar',
    formulas: [
      'Katı basıncı: P = G / S (Pa)',
      'Sıvı basıncı: P = h·d·g',
      'İdeal gaz: P·V = n·R·T',
    ],
    keyPoints: [
      'Basınç skalerdir, basınç kuvveti vektöreldir.',
      'Sıvı basıncı kabın şekline bağlı değil, sadece h ve d\'ye bağlı.',
      'Çivinin ucu sivri → küçük alan → büyük basınç.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Ağırlığı 60 N, tabanı 2 m² olan kutunun basıncı kaç Pa?',
      steps: ['P = G/S', 'P = 60/2 = 30'],
      answer: '30 Pa',
    ),
    SolvedExample(
      question: '10 cm su (d=1) ile 10 cm yağ (d=0,8) hangi kapta taban basıncı büyük?',
      steps: ['P = h·d·g, derinlikler eşit → d büyük olan kazanır', 'd_su > d_yağ'],
      answer: 'Su bulunan kabın basıncı büyük',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Raptiyenin ucunun sivri olmasının nedeni?', options: ['A) Kuvveti artırmak', 'B) Basıncı artırmak', 'C) Ağırlığı azaltmak', 'D) Sürtünmeyi azaltmak'], correctIndex: 1, explanation: 'Küçük alan → büyük basınç → kolay batar.', difficulty: 1),
    StemQuestion(question: 'Sıvı basıncı hangisine bağlı değildir?', options: ['A) Derinlik', 'B) Özkütle', 'C) Yerçekimi', 'D) Kap şekli'], correctIndex: 3, explanation: 'P = h·d·g; kap şekli etkisizdir.', difficulty: 1),
    StemQuestion(question: 'Açık hava basıncını ölçen alet?', options: ['A) Manometre', 'B) Barometre', 'C) Altimetre', 'D) Batimetre'], correctIndex: 1, explanation: 'Açık hava basıncı barometreyle ölçülür.', difficulty: 1),
    StemQuestion(question: 'Dağa çıkan dağcının üzerindeki açık hava basıncı?', options: ['A) Artar', 'B) Azalır', 'C) Değişmez', 'D) Önce artar sonra azalır'], correctIndex: 1, explanation: 'Yükseldikçe hava sütunu azalır → basınç düşer.', difficulty: 2),
    StemQuestion(question: 'Esnek balon yukarı yükselirken hacmi?', options: ['A) Artar', 'B) Azalır', 'C) Değişmez', 'D) Önce azalır sonra artar'], correctIndex: 0, explanation: 'Dış basınç azalınca iç basınç dengelenir → hacim artar.', difficulty: 2),
    StemQuestion(question: 'Suyun içindeki noktaya basınç kuvveti nasıl etki eder?', options: ['A) Sadece aşağı', 'B) Sadece yanlara', 'C) Her yöne dik', 'D) Sadece yukarı'], correctIndex: 2, explanation: 'Sıvılar basıncı tüm yüzeylere dik iletir.', difficulty: 2),
    StemQuestion(question: 'Fırtınada çatıların uçmasının nedeni?', options: ['A) Çatının ağırlığı azalır', 'B) İç basınç > dış basınç', 'C) Rüzgar çatıyı çeker', 'D) Yağmur basıncı artırır'], correctIndex: 1, explanation: 'Bernoulli: Üstte hız artar → dış basınç düşer → iç basınç iter.', difficulty: 3),
    StemQuestion(question: 'Kesik koni ters çevrilirse basınç ve basınç kuvveti?', options: ['A) Basınç artar, kuvvet değişmez', 'B) Basınç azalır, kuvvet artar', 'C) İkisi de artar', 'D) İkisi de değişmez'], correctIndex: 0, explanation: 'Ağırlık (kuvvet) aynı, alan küçülür → basınç artar.', difficulty: 3),
  ],
);

final _tytFizU6Content = StemUnitContent(
  unitId: 'tyt_fiz_u6',
  topic: const TopicContent(
    summary:
        'Elektrik akımı iletkendeki yüklerin hareketidir. Pil potansiyel fark oluşturarak bu hareketi sağlar.',
    rule:
        'Akım yönü: + kutuptan − kutba\n'
        'Seri bağlama: Dirençler toplanır, akımlar eşit\n'
        'Paralel bağlama: R_eş azalır, gerilimler eşit\n'
        'Kısa devre: Akım dirençsiz yolu tercih eder',
    formulas: [
      'Ohm Kanunu: V = I·R',
      'Güç: P = V·I (Watt)',
      'Enerji: E = P·t = V·I·t (Joule)',
    ],
    keyPoints: [
      'Ampermetre: Seri bağlanır (iç direnç ≈ 0).',
      'Voltmetre: Paralel bağlanır (iç direnç ≈ ∞).',
      'Evlerdeki aletler birbirine paralel bağlıdır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'R = 5 Ω, I = 2 A ise V kaç Volt?',
      steps: ['V = I·R', 'V = 2×5 = 10'],
      answer: '10 V',
    ),
    SolvedExample(
      question: '6 Ω ve 3 Ω paralel bağlanırsa R_eş kaç Ω?',
      steps: ['R_eş = (6×3)/(6+3)', '18/9 = 2'],
      answer: '2 Ω',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Akım şiddetini ölçen alet?', options: ['A) Voltmetre', 'B) Ampermetre', 'C) Ohmmetre', 'D) Kalorimetre'], correctIndex: 1, explanation: 'Akım ampermetre ile ölçülür.', difficulty: 1),
    StemQuestion(question: 'Akıma karşı gösterilen zorluğa ne denir?', options: ['A) Akım', 'B) Potansiyel', 'C) Direnç', 'D) Yük'], correctIndex: 2, explanation: 'Maddelerin akıma direnme özelliği = direnç.', difficulty: 1),
    StemQuestion(question: 'Hangisi yalıtkan maddedir?', options: ['A) Bakır tel', 'B) Tuzlu su', 'C) Plastik', 'D) Demir çivi'], correctIndex: 2, explanation: 'Plastik serbest elektron içermez.', difficulty: 1),
    StemQuestion(question: 'Seri bağlı 3 lambadan biri patlarsa ne olur?', options: ['A) Diğerleri parlak yanar', 'B) Aynı kalır', 'C) Hepsi söner', 'D) Daha sönük yanar'], correctIndex: 2, explanation: 'Seri devrede kol koparsa akım kesilir, hepsi söner.', difficulty: 2),
    StemQuestion(question: '220 V, 5 A çeken süpürgenin gücü kaç W?', options: ['A) 44', 'B) 1100', 'C) 2200', 'D) 110'], correctIndex: 1, explanation: 'P = 220×5 = 1100 W.', difficulty: 2),
    StemQuestion(question: 'Paralel devrede kol sayısı artarsa R_eş?', options: ['A) Artar', 'B) Azalır', 'C) Değişmez', 'D) Önce artar sonra azalır'], correctIndex: 1, explanation: 'Paralelde direnç sayısı arttıkça R_eş azalır.', difficulty: 2),
    StemQuestion(question: 'Voltmetre lambaya seri bağlanırsa?', options: ['A) Lamba çok parlak yanar', 'B) Voltmetre bozulur', 'C) Lamba söner', 'D) Akım çok artar'], correctIndex: 2, explanation: 'Voltmetrenin direnci çok büyük → akım geçmez → lamba söner.', difficulty: 3),
    StemQuestion(question: 'İletken boyu 2 katına, kesiti yarıya inerse direnç?', options: ['A) Değişmez', 'B) 2 kat', 'C) 4 kat', 'D) Yarıya düşer'], correctIndex: 2, explanation: 'R ∝ L/S. Boy 2×, kesit ½ → 2×2 = 4 kat artar.', difficulty: 3),
  ],
);

final _tytFizU7Content = StemUnitContent(
  unitId: 'tyt_fiz_u7',
  topic: const TopicContent(
    summary:
        'Dalga, enerjinin titreşimle aktarılmasıdır. Madde taşınmaz, sadece enerji iletilir.',
    rule:
        'Mekanik dalgalar: Ortam gerektirir (ses, su, deprem)\n'
        'Elektromanyetik dalgalar: Boşlukta yayılır (ışık, radyo, X-ışını)\n'
        'Enine: Titreşim yönü yayılmaya dik (ışık, su)\n'
        'Boyuna: Titreşim yönü yayılmaya paralel (ses)',
    formulas: [
      'Hız: v = λ·f',
      'Periyot-Frekans: T·f = 1',
    ],
    keyPoints: [
      'Dalga hızı sadece ortama bağlıdır (ortam değişmezse hız değişmez).',
      'Frekans sadece kaynağa bağlıdır (kaynak değişmezse f değişmez).',
      'Ses: katılarda en hızlı, gazlarda en yavaş; boşlukta yayılmaz.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'f = 2 Hz, v = 10 m/s ise dalga boyu kaç m?',
      steps: ['v = λ·f', '10 = λ×2 → λ = 5'],
      answer: '5 m',
    ),
    SolvedExample(
      question: 'Su dalgası derinden sığa geçerken v ve λ nasıl değişir?',
      steps: ['Sığ ortamda dalga yavaşlar (v azalır)', 'f sabit → λ da azalır (v=λf)'],
      answer: 'Her ikisi de azalır',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Hangisi yayılmak için maddesel ortama ihtiyaç duyar?', options: ['A) Radyo dalgası', 'B) Mikrodalga', 'C) Ses dalgası', 'D) Görünür ışık'], correctIndex: 2, explanation: 'Ses mekanik dalgadır, boşlukta yayılmaz.', difficulty: 1),
    StemQuestion(question: 'Bir tam salınım süresine ne denir?', options: ['A) Frekans', 'B) Periyot', 'C) Genlik', 'D) Uzanım'], correctIndex: 1, explanation: 'Bir tam dalga oluşum süresi = periyot.', difficulty: 1),
    StemQuestion(question: 'Işık kırıldığında kesinlikle ne değişir?', options: ['A) Frekansı', 'B) Periyodu', 'C) Rengi', 'D) Hızı'], correctIndex: 3, explanation: 'Ortam değişince hız değişir; f ve renk sabit kalır.', difficulty: 1),
    StemQuestion(question: 'Sesin ince/kalınlığını belirleyen özellik?', options: ['A) Şiddet', 'B) Frekans', 'C) Genlik', 'D) Hız'], correctIndex: 1, explanation: 'Yüksek frekans → ince (tiz), düşük frekans → kalın (pes).', difficulty: 2),
    StemQuestion(question: 'EM dalganın boşluktaki hızı neye eşittir?', options: ['A) Ses hızı', 'B) Işık hızı', 'C) İletken hızı', 'D) Frekans değeri'], correctIndex: 1, explanation: 'Tüm EM dalgalar boşlukta ışık hızıyla (c) yayılır.', difficulty: 2),
    StemQuestion(question: 'Deprem dalgaları ile ilgili hangisi yanlıştır?', options: ['A) Mekanik dalgalar', 'B) Enerji taşırlar', 'C) Sadece enine dalgalar', 'D) Odak noktası yer altında'], correctIndex: 2, explanation: 'Depremde hem enine (S) hem boyuna (P) dalgalar vardır.', difficulty: 2),
    StemQuestion(question: 'Ses şiddeti artırılırsa hangi nicelik artar?', options: ['A) Dalga boyu', 'B) Frekans', 'C) Genlik', 'D) Hız'], correctIndex: 2, explanation: 'Şiddet/gürlük genlikle ilgilidir.', difficulty: 3),
    StemQuestion(question: 'Camda kırmızı, yeşil ve mavi ışık hızları ilişkisi?', options: ['A) Vk > Vy > Vm', 'B) Vm > Vy > Vk', 'C) Hepsi eşit', 'D) Vy > Vk > Vm'], correctIndex: 0, explanation: 'Kırmızı en az kırılır → en hızlı; mavi en çok kırılır → en yavaş.', difficulty: 3),
  ],
);

// ═══════════════════════════════════════════════════════════════
// TYT KİMYA İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

final _tytKimU1Content = StemUnitContent(
  unitId: 'tyt_kim_u1',
  topic: const TopicContent(
    summary:
        'Kimya, maddenin yapısını ve değişimlerini inceleyen bilim dalıdır. '
        'Atom ise maddenin kimyasal özelliklerini taşıyan en küçük yapı taşıdır.',
    rule:
        'Simya: Teorik temeli yok, altın üretme amacı güder\n'
        'Kimya: Sistematik, bilimsel\n'
        'Güvenlik sembolleri: Ünlem (tahriş), Kurukafa (zehirli), Alev (yanıcı)\n'
        'Atom modelleri: Dalton (bilardo topu), Thomson (üzümlü kek), Rutherford (çekirdekli), Bohr (yörüngeli)\n'
        'Tanecikler: Proton (p⁺) ve Nötron (n⁰) çekirdekte; Elektron (e⁻) katmanlarda',
    formulas: [
      'Kütle Numarası: A = p + n',
      'İyon Yükü: Yük = p − e',
    ],
    keyPoints: [
      'İzotop: Protonları aynı, nötronları farklı (kimyasal özellikler aynı).',
      'İzobar: Kütle numaraları aynı, protonları farklı.',
      'İzoton: Nötron sayıları aynı, protonları farklı.',
      'Nötr atomda proton sayısı = elektron sayısı.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'Kütle numarası 23, nötron sayısı 12 olan Na atomunun proton sayısı kaçtır?',
      steps: [
        'A = p + n',
        '23 = p + 12 → p = 11',
      ],
      answer: '11',
    ),
    SolvedExample(
      question:
          'X²⁺ iyonunun 10 elektronu varsa, atomun proton sayısı kaçtır?',
      steps: [
        'Yük = p − e',
        '+2 = p − 10 → p = 12',
      ],
      answer: '12',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Hangisi bir element sembolüdür?',
      options: ['A) CO', 'B) NaCl', 'C) Cu', 'D) HCl'],
      correctIndex: 2,
      explanation: 'Cu (Bakır) tek/çift harfli element sembolüdür; diğerleri bileşik formülüdür.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Çekirdeğinde proton ve nötron bulunan atom modelini ilk ortaya atan kimdir?',
      options: ['A) Dalton', 'B) Thomson', 'C) Rutherford', 'D) Bohr'],
      correctIndex: 2,
      explanation: 'Çekirdek kavramını ilk kez Rutherford ortaya koymuştur.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Laboratuvarda "Alev" sembolü olan madde için ne söylenir?',
      options: ['A) Zehirlidir', 'B) Yanıcıdır', 'C) Koroziftir', 'D) Patlayıcıdır'],
      correctIndex: 1,
      explanation: 'Alev sembolü maddenin kolay tutuşabilir olduğunu gösterir.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Nötr bir atom elektron verdiğinde ne olur?',
      options: [
        'A) Proton sayısı artar',
        'B) Çekirdek çapı küçülür',
        'C) İyon yükü pozitif olur',
        'D) Nötron sayısı azalır',
      ],
      correctIndex: 2,
      explanation: 'Elektron kaybeden atom pozitif yüklü (katyon) olur.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'İzotop atomlar için hangisi doğrudur?',
      options: [
        'A) Fiziksel özellikleri aynıdır',
        'B) Nötron sayıları aynıdır',
        'C) Kimyasal özellikleri aynıdır',
        'D) Kütle numaraları aynıdır',
      ],
      correctIndex: 2,
      explanation: 'Proton sayıları aynı olduğu için kimyasal özellikleri aynıdır.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi simyacılar tarafından keşfedilmemiştir?',
      options: ['A) Barut', 'B) Cam', 'C) Plastik', 'D) Mürekkep'],
      correctIndex: 2,
      explanation: 'Plastik modern kimya dönemine ait sentetik bir polimerdir.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'İzoton ve izobar arasındaki fark nedir?',
      options: [
        'A) İzotonda nötron, izobarda kütle numarası aynıdır',
        'B) Her ikisinde de proton aynıdır',
        'C) İzotonda elektron, izobarda nötron aynıdır',
        'D) Hiçbir fark yoktur',
      ],
      correctIndex: 0,
      explanation: 'İzoton: nötron sayısı eşit. İzobar: kütle numarası (A) eşit.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bohr modeline göre elektron alt katmandan üst katmana geçerken ne olur?',
      options: [
        'A) Enerji verir',
        'B) Enerji alır',
        'C) Kütlesi artar',
        'D) Kararlı hale gelir',
      ],
      correctIndex: 1,
      explanation: 'Üst yörüngeye geçiş (uyarılma) dışarıdan enerji alarak gerçekleşir.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU2Content = StemUnitContent(
  unitId: 'tyt_kim_u2',
  topic: const TopicContent(
    summary:
        'Elementlerin artan atom numaralarına göre dizildiği tabloya periyodik sistem denir. '
        'Benzer kimyasal özellik gösteren elementler aynı grupta toplanmıştır.',
    rule:
        'Katman dizilimi (ilk 20 element): 2-8-8-2\n'
        'Katman sayısı → Periyot numarası\n'
        'Son katmandaki e⁻ sayısı → Grup numarası (A grupları)\n'
        'Metaller (sol), Ametaller (sağ), Yarı metaller (merdiven hattı), Soygazlar (8A)\n'
        'Çap: Aşağı ↑, Sağa ↓ | İyonlaşma E.: Çapın tersi',
    formulas: [
      'Periyot = Katman sayısı',
      'Grup (A) = Son katman elektron sayısı',
    ],
    keyPoints: [
      'Hidrojen 1A\'dadır ama ametaldir.',
      'Helyum son katmanında 2 e⁻ var ama 8A grubundadır (soygaz).',
      'İyonlaşma enerjisi istisnası: 2A > 3A ve 5A > 6A (küresel simetri / yarı dolu kararlılık).',
      'Aynı gruptaki elementlerin değerlik elektron sayıları aynıdır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question:
          'Atom numarası 13 olan Al\'un grup ve periyodunu bulunuz.',
      steps: [
        'Katman dizilimi: 2 – 8 – 3',
        '3 katman → 3. Periyot, son katmanda 3 e⁻ → 3A Grubu',
      ],
      answer: '3. Periyot, 3A Grubu',
    ),
    SolvedExample(
      question:
          '₇N ve ₁₅P elementlerinden hangisinin atom çapı daha büyüktür?',
      steps: [
        'N: 2-5 (2. periyot), P: 2-8-5 (3. periyot)',
        'Katman sayısı fazla olan → çap büyük',
      ],
      answer: 'Fosfor (P)',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Modern periyodik sistemde elementler neye göre sıralanmıştır?',
      options: ['A) Kütle numarası', 'B) Nötron sayısı', 'C) Atom numarası', 'D) Özkütle'],
      correctIndex: 2,
      explanation: 'Modern tablo atom numarasına (proton sayısı) göredir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '7A grubu elementlerine verilen özel ad nedir?',
      options: ['A) Toprak metalleri', 'B) Halojenler', 'C) Kalkojenler', 'D) Soygazlar'],
      correctIndex: 1,
      explanation: '7A grubu elementleri halojenler olarak bilinir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi bir soygazdır?',
      options: ['A) O', 'B) F', 'C) Ne', 'D) Na'],
      correctIndex: 2,
      explanation: 'Neon (Ne) 8A grubu soygazıdır.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Aynı periyotta soldan sağa gidildikçe hangisi genellikle artar?',
      options: ['A) Atom çapı', 'B) Metalik özellik', 'C) İyonlaşma enerjisi', 'D) Katman sayısı'],
      correctIndex: 2,
      explanation: 'Sağa gidildikçe elektron koparmak zorlaşır, iyonlaşma enerjisi artar.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Alkali metaller (1A) ile ilgili hangisi yanlıştır?',
      options: [
        'A) Isı ve elektriği iyi iletirler',
        'B) Bileşiklerinde +1 değerlik alırlar',
        'C) Doğada serbest halde bulunurlar',
        'D) Erime noktaları düşüktür',
      ],
      correctIndex: 2,
      explanation: 'Çok aktif olduklarından doğada genellikle bileşik halindedirler.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aynı grupta yukarıdan aşağıya inildikçe hangisi değişmez?',
      options: [
        'A) Değerlik elektron sayısı',
        'B) Atom numarası',
        'C) Atom kütlesi',
        'D) Periyot numarası',
      ],
      correctIndex: 0,
      explanation: 'Aynı gruptaki elementlerin son katman elektron sayıları aynıdır.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question:
          'X atomu 1 elektron aldığında dizilimi 3. periyot soygazına benziyor. X\'in grup ve periyodu?',
      options: ['A) 3. Periyot 7A', 'B) 3. Periyot 8A', 'C) 2. Periyot 7A', 'D) 4. Periyot 1A'],
      correctIndex: 0,
      explanation:
          '3. periyot soygazı: 2-8-8 (18 e⁻). 1 e⁻ alarak → orijinali 17 e⁻ (2-8-7). 3. Periyot, 7A.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          '2A\'nın iyonlaşma enerjisinin aynı periyottaki 3A\'dan büyük olması ne ile açıklanır?',
      options: [
        'A) Atom çapının küçüklüğü',
        'B) Küresel simetri özelliği',
        'C) Çekirdek yükü',
        'D) Metalik bağ kuvveti',
      ],
      correctIndex: 1,
      explanation: '2A tam dolu s alt kabuğuna sahip olduğu için küresel simetriktir → e⁻ koparmak daha zordur.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU3Content = StemUnitContent(
  unitId: 'tyt_kim_u3',
  topic: const TopicContent(
    summary:
        'Kimyasal türler arasındaki çekme-itme kuvvetleri sonucu bağlar oluşur. '
        'Güçlü bağlar (kimyasal) ve zayıf etkileşimler (fiziksel) olarak ikiye ayrılır.',
    rule:
        'Güçlü: İyonik (Metal–Ametal), Kovalent (Ametal–Ametal), Metalik (Metal–Metal)\n'
        'Zayıf: Van der Waals (Dipol-dipol, London), Hidrojen Bağı\n'
        'Polar kovalent: Farklı ametaller arası | Apolar kovalent: Aynı ametaller arası\n'
        'Hidrojen bağı: H doğrudan F, O veya N\'ye bağlıysa moleküller arasında oluşur',
    formulas: [
      'Bağ Enerjisi ≥ 40 kJ/mol → Güçlü etkileşim',
    ],
    keyPoints: [
      'Hidrojen bağı en güçlü zayıf etkileşimdir.',
      '"Benzer benzeri çözer": Polar→polar, apolar→apolar çözünürlük.',
      'London kuvvetleri tüm moleküllerde bulunur; apolarlarda tek etkili kuvvettir.',
      'İyonik bileşikler katı halde iletken değil, sıvı/çözeltide iletken.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '₁H ve ₉F atomları arasında oluşan bağ türü nedir?',
      steps: [
        'H (ametal) ve F (ametal) → ametal-ametal',
        'Farklı ametaller → kutuplaşma olur',
      ],
      answer: 'Polar Kovalent Bağ',
    ),
    SolvedExample(
      question: 'MgO bileşiğinin bağ türü nedir? (₁₂Mg, ₈O)',
      steps: [
        'Mg (metal) ve O (ametal) → metal-ametal',
        'Elektron alışverişi gerçekleşir',
      ],
      answer: 'İyonik Bağ',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Hangisi güçlü bir etkileşim değildir?',
      options: ['A) İyonik bağ', 'B) Metalik bağ', 'C) Hidrojen bağı', 'D) Kovalent bağ'],
      correctIndex: 2,
      explanation: 'Hidrojen bağı moleküller arası zayıf bir etkileşimdir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Lewis yapısında eşleşmemiş elektron sayısı neyi ifade eder?',
      options: [
        'A) Periyot numarasını',
        'B) Yapabileceği bağ sayısını',
        'C) Proton sayısını',
        'D) Kütle numarasını',
      ],
      correctIndex: 1,
      explanation: 'Atomlar tekli nokta sayısı kadar bağ yapma eğilimindedir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Metal atomlarını bir arada tutan kuvvete ne ad verilir?',
      options: ['A) London kuvvetleri', 'B) Metalik bağ', 'C) Dipol-dipol', 'D) İyonik bağ'],
      correctIndex: 1,
      explanation: 'Elektron denizi ve pozitif iyonlar arasındaki çekim = metalik bağ.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'NH₃ molekülleri arasında hangi baskın etkileşim görülür?',
      options: ['A) London kuvvetleri', 'B) İyonik bağ', 'C) Hidrojen bağı', 'D) Apolar kovalent bağ'],
      correctIndex: 2,
      explanation: 'N atomuna bağlı H içerdiğinden moleküller arası hidrojen bağı kurulur.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi apolar bir moleküldür?',
      options: ['A) H₂O', 'B) HCl', 'C) CH₄', 'D) NH₃'],
      correctIndex: 2,
      explanation: 'CH₄ simetrik yapıda olduğu için yük dağılımı dengeli → apolar.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'İyonik bağlı bileşikler için hangisi yanlıştır?',
      options: [
        'A) Katı halde elektriği iletirler',
        'B) Oda koşullarında katıdırlar',
        'C) Erime noktaları yüksektir',
        'D) Kristal örgü yapısındadırlar',
      ],
      correctIndex: 0,
      explanation: 'İyonik bileşikler katı halde iletken değil; sıvı veya çözelti halinde iletirler.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'O₂ molekülünde bağ türü ve polarlığı nedir?',
      options: [
        'A) Polar kovalent – Polar',
        'B) Apolar kovalent – Apolar',
        'C) İyonik – Apolar',
        'D) Polar kovalent – Apolar',
      ],
      correctIndex: 1,
      explanation: 'Aynı ametaller arası → apolar kovalent bağ; simetrik → apolar molekül.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Soygazların kaynama noktalarının yukarıya doğru azalmasının nedeni?',
      options: [
        'A) Proton sayısının artması',
        'B) London kuvvetlerinin zayıflaması',
        'C) Metalik bağın kopması',
        'D) İyonlaşma enerjisinin artması',
      ],
      correctIndex: 1,
      explanation: 'Yukarı çıkıldıkça e⁻ sayısı azalır → polarlanabilirlik düşer → London kuvvetleri zayıflar.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU4Content = StemUnitContent(
  unitId: 'tyt_kim_u4',
  topic: const TopicContent(
    summary:
        'Madde doğada katı, sıvı, gaz ve plazma hallerinde bulunur. '
        'Fiziksel hal; sıcaklık, basınç ve tanecikler arası çekim kuvvetlerine bağlıdır.',
    rule:
        'Katılar: Amorf (cam, lastik) ve Kristal (iyonik, moleküler, kovalent, metalik)\n'
        'Sıvılar: Viskozite sıcaklıkla ters orantılı\n'
        'Gazlar: Belirli şekil/hacim yok, kabı doldurur\n'
        'Plazma: Pozitif iyon + serbest elektron (Güneş, şimşek, neon lamba)',
    formulas: [
      'Bağıl Nem = (Havadaki Buhar / Maks. Nem) × 100',
    ],
    keyPoints: [
      'Buharlaşma: Her sıcaklıkta, sadece yüzeyde. Kaynama: Belirli sıcaklıkta, her yerde.',
      'Dış basınç artarsa kaynama noktası artar.',
      'Uçucu olmayan madde çözmek kaynama noktasını yükseltir, donma noktasını düşürür.',
      'Yükseklere çıkıldıkça dış basınç azalır → kaynama noktası düşer.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Aynı sıcaklıktaki bal ve suyun akışkanlıklarını karşılaştırınız.',
      steps: [
        'Balın viskozitesi suyunkinden büyüktür',
        'Akışkanlık viskozitenin tersi → su daha akışkan',
      ],
      answer: 'Su, baldan daha akışkandır',
    ),
    SolvedExample(
      question: 'Sıcaklığı artırılan bir sıvının viskozitesi nasıl değişir?',
      steps: [
        'Sıcaklık artışı tanecikler arası çekimi zayıflatır',
        'Direnç (viskozite) azalır, akışkanlık artar',
      ],
      answer: 'Viskozite azalır',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Belirli geometrik şekli olmayan, ısıtıldığında yumuşayan katılara ne denir?',
      options: ['A) İyonik Katı', 'B) Amorf Katı', 'C) Kovalent Katı', 'D) Metalik Katı'],
      correctIndex: 1,
      explanation: 'Cam, plastik, mum gibi maddeler amorf katılara örnektir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Sıvıların akmaya karşı gösterdiği dirence ne denir?',
      options: ['A) Akışkanlık', 'B) Özkütle', 'C) Viskozite', 'D) Yüzey gerilimi'],
      correctIndex: 2,
      explanation: 'Tanımı gereği bu direnç viskozitedir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi plazma haline örnek değildir?',
      options: ['A) Güneş', 'B) Mum alevi', 'C) Floresan lamba içi', 'D) Buz pateni pisti'],
      correctIndex: 3,
      explanation: 'Buz katı haldedir, plazma değil.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Kaynamakta olan saf bir sıvı için hangisi yanlıştır?',
      options: [
        'A) Sıcaklığı sabittir',
        'B) Buhar basıncı dış basınca eşittir',
        'C) Sadece yüzeyde buharlaşma olur',
        'D) Potansiyel enerjisi artar',
      ],
      correctIndex: 2,
      explanation: 'Kaynama sıvının her yerinde gerçekleşir; yüzeyde olan buharlaşmadır.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Saf suya tuz eklenip çözülürse aynı basınçta kaynama noktası nasıl değişir?',
      options: ['A) Artar', 'B) Azalır', 'C) Değişmez', 'D) Önce azalır sonra artar'],
      correctIndex: 0,
      explanation: 'Uçucu olmayan katı çözmek kaynama noktasını yükseltir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Deniz seviyesinden yükseklere çıkıldığında suyun kaynama noktası nasıl değişir?',
      options: [
        'A) Artar',
        'B) Azalır',
        'C) Değişmez',
        'D) Dış basınca bağlı değildir',
      ],
      correctIndex: 1,
      explanation: 'Yükseklere çıkıldığında dış basınç azalır → kaynama noktası düşer.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Elmas ve grafit hangi katı sınıfına girer ve farkları nedir?',
      options: [
        'A) Moleküler – Erime noktaları',
        'B) Kovalent – Ağ örgüsü yapısı',
        'C) İyonik – İletkenlik',
        'D) Amorf – Sertlik',
      ],
      correctIndex: 1,
      explanation: 'Her ikisi de kovalent katıdır; atomların dizilimi ve bağ yapıları farklıdır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Bağıl nemin %100 olması ne anlama gelir?',
      options: [
        'A) Hava tamamen kurudur',
        'B) Yağış başlama ihtimali çok yüksektir',
        'C) Sıcaklık çok düşüktür',
        'D) Buharlaşma hızı maksimumdur',
      ],
      correctIndex: 1,
      explanation: 'Hava neme doymuştur, daha fazla nemi taşıyamaz → yağış ihtimali çok yüksek.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU5Content = StemUnitContent(
  unitId: 'tyt_kim_u5',
  topic: const TopicContent(
    summary:
        'Mol, çok küçük tanecikleri saymak için kullanılan birimdir (1 mol = 6,02×10²³ tanecik). '
        'Kimyasal tepkimeler maddelerin atom dizilimlerinin değişerek yeni maddeler oluşturmasıdır.',
    rule:
        'Kütlenin Korunumu: Girenlerin kütlesi = Ürünlerin kütlesi\n'
        'Tepkime Türleri: Yanma, Analiz, Sentez, Asit-Baz, Çökelme\n'
        'Denkleştirme: Atom sayısı ve cinsi korunur\n'
        'Katsayılar mol oranını verir, kütle oranını değil!',
    formulas: [
      'n = m / Mₐ (kütleden mol)',
      'n = V / 22,4 (NK\'da gaz hacminden mol)',
      'n = N / Nₐ (tanecikten mol, Nₐ = 6,02×10²³)',
    ],
    keyPoints: [
      'Yanma tepkimesi için O₂ gazı şarttır.',
      'NK (0°C, 1 atm) ifadesi sadece gazlar için geçerlidir.',
      '1 mol ideal gaz NK\'da 22,4 L hacim kaplar.',
      'Katsayılar mol oranını verir; kütle oranı için Mₐ ile çarpılmalıdır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2 mol CH₄ kaç gramdır? (C:12, H:1)',
      steps: [
        'Mₐ = 12 + 4×1 = 16 g/mol',
        'm = n × Mₐ = 2 × 16 = 32',
      ],
      answer: '32 g',
    ),
    SolvedExample(
      question:
          'C₃H₈ + 5O₂ → 3CO₂ + 4H₂O tepkimesinde 0,5 mol C₃H₈ yakılırsa kaç mol H₂O oluşur?',
      steps: [
        'Katsayı oranı: 1 mol C₃H₈ → 4 mol H₂O',
        '0,5 × 4 = 2',
      ],
      answer: '2 mol',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: '1 mol H₂O molekülünde toplam kaç tane atom vardır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 3 × 6,02×10²³'],
      correctIndex: 3,
      explanation: '1 molekülde 3 atom; 1 molde Avogadro katı → 3×6,02×10²³ atom.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'NK altında 1 mol gaz kaç litre hacim kaplar?',
      options: ['A) 11,2', 'B) 22,4', 'C) 24,5', 'D) 44,8'],
      correctIndex: 1,
      explanation: 'Tüm ideal gazların 1 molü NK\'da 22,4 L hacim kaplar.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi bir yanma tepkimesidir?',
      options: [
        'A) NaOH + HCl → …',
        'B) Mg + O₂ → …',
        'C) CaCO₃ → …',
        'D) NaCl → …',
      ],
      correctIndex: 1,
      explanation: 'Girenler kısmında serbest O₂ bulunması yanma tepkimesidir.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'X + 2O₂ → CO₂ + 2H₂O tepkimesindeki X maddesi hangisidir?',
      options: ['A) CH₄', 'B) C₂H₂', 'C) C₂H₄', 'D) CH₃OH'],
      correctIndex: 0,
      explanation: 'Ürünlerde 1C ve 4H var → girenlerde de 1C, 4H olmalı → CH₄.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '0,1 mol C₃H₄ gazı kaç gramdır? (C:12, H:1)',
      options: ['A) 4', 'B) 40', 'C) 0,4', 'D) 44'],
      correctIndex: 0,
      explanation: 'Mₐ = 36+4 = 40. m = 0,1×40 = 4 g.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'İki veya daha fazla maddenin birleşerek tek madde oluşturması hangi tepkimedir?',
      options: ['A) Analiz', 'B) Sentez', 'C) Çökelme', 'D) Nötralleşme'],
      correctIndex: 1,
      explanation: 'Sentez (oluşum): küçük birimlerden büyük yapı oluşur.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: '12 g karbon içeren C₂H₆ molekülü kaç moldür? (C:12, H:1)',
      options: ['A) 0,5', 'B) 1', 'C) 2', 'D) 1,5'],
      correctIndex: 0,
      explanation: '1 mol C₂H₆\'da 24 g C var. 12 g C → 0,5 mol C₂H₆.',
      difficulty: 3,
    ),
    StemQuestion(
      question:
          'Eşit mollerde H₂ ve O₂ gazları 2H₂+O₂→2H₂O tepkimesine girdiğinde hangi gaz artar?',
      options: ['A) H₂', 'B) O₂', 'C) H₂O', 'D) Artış olmaz'],
      correctIndex: 1,
      explanation: 'H₂ daha hızlı tükenir (2:1 oranı). O₂ artar.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU6Content = StemUnitContent(
  unitId: 'tyt_kim_u6',
  topic: const TopicContent(
    summary:
        'Suda çözündüğünde H⁺ iyonu veren maddelere asit, OH⁻ iyonu verenlere baz denir. '
        'Asit ve bazların tepkimesinden tuz ve (genellikle) su oluşur.',
    rule:
        'pH: 0-7 asit (kırmızı turnusol), 7 nötr, 7-14 baz (mavi turnusol)\n'
        'Asit: Ekşi tat, aşındırıcı, metallerle H₂ gazı çıkarır\n'
        'Baz: Acı tat, kayganlık hissi, temizlik malzemelerinde bulunur\n'
        'Nötralleşme: Asit + Baz → Tuz + Su',
    formulas: [
      'HCl + NaOH → NaCl + H₂O',
      'pH < 7 → Asit | pH = 7 → Nötr | pH > 7 → Baz',
    ],
    keyPoints: [
      'NH₃ (Amonyak): Yapısında OH yok ama zayıf bir bazdır (susuz baz).',
      'Soy metaller (Au, Pt) sadece kral suyuyla tepkime verir.',
      'Amfoter metaller (Al, Zn) hem asit hem bazla tepkime verir.',
      'Kireç çözücüler asidik, lavabo açıcılar baziktir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'H₂SO₄ ve KOH tepkimesinden hangi tuz oluşur?',
      steps: [
        'Asidin anyonu: SO₄²⁻, bazın katyonu: K⁺',
        'Çaprazlama → K₂SO₄',
      ],
      answer: 'K₂SO₄ (Potasyum sülfat)',
    ),
    SolvedExample(
      question: 'pH 2 olan çözeltiye mavi turnusol batırılırsa renk ne olur?',
      steps: [
        'pH 2 → çözelti asidik',
        'Asitler mavi turnusolu kırmızıya çevirir',
      ],
      answer: 'Kırmızı',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Hangisi bir asidin özelliğidir?',
      options: [
        'A) Ele kayganlık vermesi',
        'B) Tadının acı olması',
        'C) Mavi turnusolu kırmızıya çevirmesi',
        'D) pH değerinin 7\'den büyük olması',
      ],
      correctIndex: 2,
      explanation: 'Asitler mavi turnusolu kırmızıya çevirir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '"Kezzap" olarak bilinen asit hangisidir?',
      options: ['A) HCl', 'B) HNO₃', 'C) H₂SO₄', 'D) CH₃COOH'],
      correctIndex: 1,
      explanation: 'Nitrik asit (HNO₃) halk arasında kezzap olarak bilinir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi bazik özellik gösterir?',
      options: ['A) Limon suyu', 'B) Sirke', 'C) Sabunlu su', 'D) Elma'],
      correctIndex: 2,
      explanation: 'Temizlik ürünleri (sabun, deterjan) genellikle baziktir.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Yapısında OH bulundurmayan "susuz baz" hangisidir?',
      options: ['A) Ca(OH)₂', 'B) KOH', 'C) NH₃', 'D) Mg(OH)₂'],
      correctIndex: 2,
      explanation: 'Amonyak (NH₃) zayıf ve susuz bir bazdır.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Aktif metallerin asitlerle tepkimesinde hangi gaz açığa çıkar?',
      options: ['A) O₂', 'B) CO₂', 'C) H₂', 'D) N₂'],
      correctIndex: 2,
      explanation: 'Asit-metal tepkimelerinde hidrojen gazı (H₂) oluşur.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kireçlenmiş çaydanlığı temizlemek için hangisi kullanılmalıdır?',
      options: ['A) Çamaşır suyu', 'B) Tuz ruhu', 'C) Sirke', 'D) Sabun'],
      correctIndex: 2,
      explanation: 'Kireç bazik tortudur; hafif asit olan sirke veya limon tuzu ile çözülür.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Fenolftalein pembe oluyorsa çözelti için hangisi kesinlikle yanlıştır?',
      options: [
        'A) pH < 7',
        'B) Baziktir',
        'C) Ele kayganlık verir',
        'D) OH⁻ iyonu içerir',
      ],
      correctIndex: 0,
      explanation: 'Fenolftalein bazik ortamda pembeleşir; pH > 7 olmalıdır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Al metali hem HCl hem NaOH ile tepkime veriyorsa nasıl sınıflandırılır?',
      options: ['A) Soy metal', 'B) Amfoter metal', 'C) Alkali metal', 'D) Toprak metali'],
      correctIndex: 1,
      explanation: 'Hem asit hem bazla tepkime veren metallere amfoter metal denir.',
      difficulty: 3,
    ),
  ],
);
final _tytKimU7Content = StemUnitContent(
  unitId: 'tyt_kim_u7',
  topic: const TopicContent(
    summary:
        'Birden fazla maddenin kimyasal özelliklerini kaybetmeden bir araya gelmesiyle karışım oluşur. '
        'Homojen karışımlara çözelti, heterojen karışımlara süspansiyon/emülsiyon/aerosol denir.',
    rule:
        'Homojen (çözelti): Tuzlu su, hava, alaşımlar (çelik, pirinç)\n'
        'Heterojen: Emülsiyon (yağ-su), Süspansiyon (çamurlu su), Aerosol (sis, duman), Kolloid (süt)\n'
        'Derişik: Çok çözünen | Seyreltik: Az çözünen\n'
        'Ayırma: Süzme (boyut), Ayırma hunisi (yoğunluk), Damıtma (kaynama noktası)',
    formulas: [
      'Kütlece % = (Çözünen / Çözelti) × 100',
      'Çözelti Kütlesi = Çözünen + Çözücü',
    ],
    keyPoints: [
      'Çözünen tanecik sayısı arttıkça kaynama noktası artar, donma noktası düşer.',
      'Emülsiyonlar ayırma hunisi ile ayrılır (yoğunluk farkı).',
      'Katı-sıvı homojen karışımlar buharlaştırma/kristallendirme ile ayrılır.',
      'Ayrımsal damıtma: kaynama noktası farkına dayanan homojen sıvı-sıvı ayırma yöntemi.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '20 g tuz, 80 g suda çözülüyor. Kütlece yüzde derişimi kaçtır?',
      steps: [
        'Çözelti kütlesi = 20 + 80 = 100 g',
        '(20/100) × 100 = %20',
      ],
      answer: '%20',
    ),
    SolvedExample(
      question: 'Zeytinyağı-su karışımını ayırmak için hangi yöntem kullanılır?',
      steps: [
        'İki sıvı karışmaz (heterojen), yoğunlukları farklı',
        'Yoğunluk farkından yararlanan araç seçilir',
      ],
      answer: 'Ayırma Hunisi',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Hangisi homojen bir karışımdır (çözeltidir)?',
      options: ['A) Süt', 'B) Çelik', 'C) Ayran', 'D) Zeytinyağlı su'],
      correctIndex: 1,
      explanation: 'Alaşımlar (çelik, tunç vb.) katı-katı homojen karışımlardır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Çözeltide çözünen miktarını artırmak çözeltiyi nasıl yapar?',
      options: ['A) Daha seyreltik', 'B) Daha derişik', 'C) Daha uçucu', 'D) Daha saf'],
      correctIndex: 1,
      explanation: 'Birim hacimdeki çözünen miktarının artması = derişik.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Tuzlu suyu bileşenlerine ayırmak için en uygun yöntem?',
      options: ['A) Süzme', 'B) Ayırma hunisi', 'C) Buharlaştırma', 'D) Diyaliz'],
      correctIndex: 2,
      explanation: 'Çözünmüş katıyı sıvıdan ayırmak için sıvı buharlaştırılır.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Talaş-kum karışımını ayırmak için hangi özellik farkı kullanılır?',
      options: ['A) Kaynama noktası', 'B) Yoğunluk', 'C) Çözünürlük', 'D) Erime noktası'],
      correctIndex: 1,
      explanation: 'Suya atıldığında talaş yüzer, kum batar (yüzdürme/flotasyon).',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kışın yollara tuz dökülmesinin kimyasal nedeni nedir?',
      options: [
        'A) Suyun kaynama noktasını yükseltmek',
        'B) Suyun donma noktasını düşürmek',
        'C) Buzun özkütlesini artırmak',
        'D) Sürtünmeyi azaltmak',
      ],
      correctIndex: 1,
      explanation: 'Çözünen tuz donma noktasını 0°C\'nin altına indirir → buzlanma önlenir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi bir aerosol örneğidir?',
      options: ['A) Mayonez', 'B) Jöle', 'C) Deodorant', 'D) Sirke'],
      correctIndex: 2,
      explanation: 'Gaz içinde dağılmış sıvı/katı tanecikleri = aerosol.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question:
          'Kütlece %10\'luk 200 g şekerli suya 50 g şeker eklenip çözülürse yeni yüzde kaçtır?',
      options: ['A) 20', 'B) 28', 'C) 35', 'D) 40'],
      correctIndex: 1,
      explanation: 'Başlangıç: 20 g şeker. Son: 70 g şeker / 250 g çözelti → (70/250)×100 = 28.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Ayrımsal damıtma ile sıvıları ayırmak için hangi şart gereklidir?',
      options: [
        'A) Yoğunluklarının aynı olması',
        'B) Renklerinin farklı olması',
        'C) Kaynama noktalarının farklı olması',
        'D) Çözünürlüklerinin sıfır olması',
      ],
      correctIndex: 2,
      explanation: 'Ayrımsal damıtma sıvı-sıvı homojen karışımların kaynama noktası farkına dayanır.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// TYT BİYOLOJİ İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────
// TYT BİYOLOJİ İÇERİKLERİ (6 ünite)
// ─────────────────────────────────────────────

final _tytBioU1Content = StemUnitContent(
  unitId: 'tyt_bio_u1',
  topic: const TopicContent(
    summary:
        'Tüm canlılar hücresel yapı, beslenme, solunum, boşaltım gibi ortak özelliklere sahiptir. '
        'Hücre canlının en küçük yapısal ve işlevsel birimidir; prokaryot ve ökaryot olarak ikiye ayrılır.',
    rule:
        'Ortak özellikler: Hücresel yapı, Metabolizma (Anabolizma-Katabolizma), Homeostazi, Adaptasyon, Üreme\n'
        'Prokaryot: Çekirdek ve zarlı organel yok (Bakteri, Arke)\n'
        'Ökaryot: Çekirdek ve zarlı organeller var (Bitki, Hayvan, Mantar, Protista)\n'
        'Ribozom: Tüm canlılarda ortak | Mitokondri: Enerji | Kloroplast: Fotosentez',
    formulas: [
      'Fotosentez: CO₂ + H₂O + Işık → Besin + O₂',
      'Oksijenli Solunum: Besin + O₂ → CO₂ + H₂O + ATP',
    ],
    keyPoints: [
      'Virüsler hücre yapısına sahip değildir (canlı-cansız arası geçiş formu).',
      'Bitki hücresinde çeper ve kloroplast var; hayvan hücresinde sentrozom var.',
      'Küçük maddeler: Difüzyon/Aktif taşıma. Büyük maddeler: Endositoz/Ekzositoz.',
      'Prokaryotlarda DNA sitoplazmada serbesttir.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Ribozomda protein sentezi artıyorsa hücrede hangi olay gerçekleşir?',
      steps: [
        'Ribozom protein sentezi yeridir',
        'Protein sentezi bir anabolizma (yapım) olayıdır',
      ],
      answer: 'Dehidrasyon sentezi / Anabolizma',
    ),
    SolvedExample(
      question: 'Hücre zarından ATP harcanarak madde taşınıyorsa bu ne tür taşımadır?',
      steps: [
        'Enerji harcanan küçük madde geçişi → Aktif Taşıma',
        'Büyük madde alımı ise → Endositoz',
      ],
      answer: 'Aktif Taşıma veya Endositoz/Ekzositoz',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Tüm canlılarda ortak olarak bulunan organel hangisidir?',
      options: ['A) Mitokondri', 'B) Ribozom', 'C) Kloroplast', 'D) Sentrozom'],
      correctIndex: 1,
      explanation: 'Ribozom protein sentezinden sorumludur ve tüm canlı hücrelerde bulunur.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi canlıların ortak özelliklerinden biri değildir?',
      options: ['A) Solunum', 'B) Boşaltım', 'C) Fotosentez', 'D) Homeostazi'],
      correctIndex: 2,
      explanation: 'Fotosentez sadece üretici canlılara (bitki, bazı bakteriler) özgüdür.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Prokaryot hücrelerde DNA nerede bulunur?',
      options: ['A) Çekirdek içinde', 'B) Mitokondri içinde', 'C) Sitoplazmada serbest', 'D) Ribozom içinde'],
      correctIndex: 2,
      explanation: 'Prokaryotlarda çekirdek olmadığı için DNA sitoplazmadadır.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Hücre çeperi bulunan bir hücre için hangisi kesinlikle doğrudur?',
      options: ['A) Bitki hücresidir', 'B) Hayvan hücresidir', 'C) Ökaryottur', 'D) Endositoz yapamaz'],
      correctIndex: 3,
      explanation: 'Hücre çeperi sert yapı olduğu için hücre büyük katı madde alamaz (fagosentez yapamaz).',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Mitokondri faaliyeti artan bir hücrede hangisinin miktarı azalır?',
      options: ['A) ATP', 'B) Isı', 'C) Glikoz', 'D) Karbondioksit'],
      correctIndex: 2,
      explanation: 'Mitokondri glikozu yakarak enerji üretir → glikoz miktarı azalır.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Difüzyon (pasif taşıma) için hangisi geçerlidir?',
      options: [
        'A) ATP harcanır',
        'B) Yoğunluk farkına göre olur',
        'C) Sadece canlı hücrelerde görülür',
        'D) Sadece büyük moleküller taşınır',
      ],
      correctIndex: 1,
      explanation: 'Difüzyon: çok yoğundan az yoğuna kendiliğinden yayılmadır.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Kontraktil koful hangi canlıda ve ne amaçla bulunur?',
      options: [
        'A) Bitkilerde su depolamak için',
        'B) Tatlı su tek hücrelilerde fazla suyu atmak için',
        'C) Hayvanlarda sindirim yapmak için',
        'D) Bakterilerde hareket etmek için',
      ],
      correctIndex: 1,
      explanation: 'Paramesyum gibi canlılarda hücrenin patlamasını önlemek için fazla suyu pompalar.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'ER\'de sentezlenen proteinin dışarı salgılanma sırası nasıldır?',
      options: [
        'A) ER → Golgi → Hücre Zarı',
        'B) Golgi → ER → Koful',
        'C) Ribozom → Çekirdek → Zar',
        'D) Lizozom → Golgi → ER',
      ],
      correctIndex: 0,
      explanation: 'ER\'de üretilen proteinler Golgi\'de paketlenir ve hücre zarına gönderilir.',
      difficulty: 3,
    ),
  ],
);

final _tytBioU2Content = StemUnitContent(
  unitId: 'tyt_bio_u2',
  topic: const TopicContent(
    summary:
        'Canlıların benzerlik ve akrabalık derecelerine göre gruplandırılmasına sınıflandırma denir. '
        'Günümüzde genetik benzerliğe dayanan filogenetik (doğal) sınıflandırma kullanılır.',
    rule:
        'Birimler: Tür → Cins → Aile → Takım → Sınıf → Şube → Alem\n'
        'Binomial Adlandırma: 1. isim Cins (büyük), 2. isim Tanımlayıcı (küçük)\n'
        'Alemler: Bakteriler, Arkeler, Protistalar, Mantarlar, Bitkiler, Hayvanlar\n'
        'Türden Aleme: Birey sayısı artar, benzerlik azalır',
    formulas: [
      'Tür tanımı: A × B = Verimli (kısır olmayan) Döl',
    ],
    keyPoints: [
      'Analog organlar (görevdaş): yapay sınıflandırma. Homolog organlar (kökendaş): doğal sınıflandırma.',
      'Sadece tanımlayıcı ad aynı olması akrabalık kanıtlamaz; cins adları aynı olmalı.',
      'Arkeler ekstrem koşullarda (aşırı sıcak, tuzlu vb.) yaşayan prokaryotlardır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Pinus nigra ve Pinus brutia canlıları için ne söylenebilir?',
      steps: [
        'İlk isimleri (Pinus) aynı → aynı cinsin farklı türleri',
        'Cinsleri aynı → aile ve üstü birimler de aynı',
      ],
      answer: 'Aynı cinsin farklı türleridir, yakın akrabadırlar',
    ),
    SolvedExample(
      question: 'Türden Aleme gidildikçe genetik benzerlik nasıl değişir?',
      steps: [
        'Tür en özel, Alem en genel birimdir',
        'Grup büyüdükçe ortak özellikler azalır',
      ],
      answer: 'Genetik benzerlik azalır',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Hangi sınıflandırma biriminde canlı benzerliği en fazladır?',
      options: ['A) Sınıf', 'B) Cins', 'C) Şube', 'D) Alem'],
      correctIndex: 1,
      explanation: 'Türden sonra en özel birim cinstir; benzerlik en fazladır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Felis leo bilimsel adında "leo" kelimesi neyi ifade eder?',
      options: ['A) Cins adı', 'B) Tür adı', 'C) Tanımlayıcı ad', 'D) Takım adı'],
      correctIndex: 2,
      explanation: 'İlk isim cins, ikinci isim tanımlayıcı addır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bakterileri arkelerden ayıran en temel fark nedir?',
      options: ['A) Tek hücreli olmaları', 'B) Hücre duvarı yapısı', 'C) DNA içermeleri', 'D) Hareket etmeleri'],
      correctIndex: 1,
      explanation: 'Bakterilerin çeperi peptidoglikan, arkelerin farklıdır.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Filogenetik sınıflandırmada hangisi dikkate alınmaz?',
      options: ['A) DNA benzerliği', 'B) Protein benzerliği', 'C) Analog organlar', 'D) Embriyonik gelişim'],
      correctIndex: 2,
      explanation: 'Analog organlar dış görünüş benzerliğidir, doğal sınıflandırmada kullanılmaz.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Omurgalılar şubesindeki bir canlının kesinlikle sahip olduğu özellik?',
      options: [
        'A) Akciğer solunumu',
        'B) Sırtta sinir şeridi',
        'C) Sabit vücut sıcaklığı',
        'D) Yavrusunu sütle besleme',
      ],
      correctIndex: 1,
      explanation: 'Tüm omurgalılarda sırtta bir sinir şeridi vardır.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Mantarlar alemi ile ilgili hangisi yanlıştır?',
      options: [
        'A) Tamamı heterotroftur',
        'B) Glikojen depo ederler',
        'C) Kloroplast içermezler',
        'D) Hücre çeperleri selülozdur',
      ],
      correctIndex: 3,
      explanation: 'Mantarların çeperi selüloz değil, kitin yapılıdır.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Aynı takımdaki iki canlı için hangisi kesinlikle doğrudur?',
      options: [
        'A) Cinsleri aynıdır',
        'B) Türleri aynıdır',
        'C) Şubeleri aynıdır',
        'D) Protein yapıları özdeştir',
      ],
      correctIndex: 2,
      explanation: 'Takımları aynı → yukarıdaki birimler (Sınıf, Şube, Alem) kesinlikle aynıdır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Memelileri diğer omurgalılardan ayıran özelliklerden hangisi değildir?',
      options: [
        'A) Diyafram kası',
        'B) Alveollü akciğer',
        'C) 4 odacıklı kalp',
        'D) Çekirdeksiz olgun alyuvarlar',
      ],
      correctIndex: 2,
      explanation: 'Kuşların da kalbi 4 odacıklıdır; bu ayırt edici değil.',
      difficulty: 3,
    ),
  ],
);

final _tytBioU3Content = StemUnitContent(
  unitId: 'tyt_bio_u3',
  topic: const TopicContent(
    summary:
        'Ekosistem; belirli bir alandaki canlılar (biyotik) ve cansız (abiyotik) çevrenin etkileşimidir. '
        'Enerji akışı güneşle başlar ve besin zinciri yoluyla tek yönlü aktarılır.',
    rule:
        'Biyotik: Üreticiler (Ototrof), Tüketiciler (Heterotrof), Ayrıştırıcılar (Saprofit)\n'
        'Besin Piramidi: Tabanda üreticiler; yukarı çıkıldıkça enerji azalır (%10 yasası)\n'
        'Madde Döngüleri: Karbon, Su, Azot\n'
        'Kirlilik: Küresel ısınma, Ötrofikasyon, Asit yağmurları',
    formulas: [
      'Üst Basamak Enerjisi = Alt Basamak × 0,10',
    ],
    keyPoints: [
      'Piramitte yukarı çıkıldıkça: biyokütle azalır, biyolojik birikim (zehir) artar.',
      'Ayrıştırıcılar besin piramidinin her basamağında etkilidir.',
      'Azot döngüsünde nitrifikasyon bakterileri çok önemlidir.',
      'Fotosentez atmosferdeki CO₂ miktarını azaltan tek olaydır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Besin zincirinde yukarı gidildikçe zehirli madde birikimi nasıl değişir?',
      steps: [
        'Zehirli maddeler (DDT, ağır metaller) vücuttan atılamaz',
        'Piramit tepesine çıkıldıkça bu maddeler birikir',
      ],
      answer: 'Artar',
    ),
    SolvedExample(
      question: 'Ötrofikasyon görülen gölde ilk olarak ne gerçekleşir?',
      steps: [
        'Suya aşırı azot ve fosfor karışmasıyla algler hızla çoğalır',
        'Yüzey kaplandığı için alt katmanlara ışık geçemez',
      ],
      answer: 'Alg patlaması / Aşırı yosunlanma',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Besin piramidinin en alt basamağında hangi canlı grubu yer alır?',
      options: ['A) Ayrıştırıcılar', 'B) Birincil tüketiciler', 'C) Üreticiler', 'D) Otçullar'],
      correctIndex: 2,
      explanation: 'Enerji girişi üreticiler (bitkiler, algler) üzerinden yapılır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi abiyotik (cansız) bir faktördür?',
      options: ['A) Mantarlar', 'B) Işık', 'C) Bakteriler', 'D) Bitkiler'],
      correctIndex: 1,
      explanation: 'Işık, sıcaklık, su ve pH abiyotik faktörlerdir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Atmosferdeki serbest azotu doğrudan kullanabilen canlı grubu?',
      options: ['A) Yeşil bitkiler', 'B) İnsanlar', 'C) Bazı bakteriler', 'D) Mantarlar'],
      correctIndex: 2,
      explanation: 'Sadece azot bağlayıcı bakteriler (Rhizobium gibi) atmosfer azotunu tutabilir.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Ayrıştırıcılar tamamen yok edilirse ne olur?',
      options: [
        'A) Madde döngüsü durur',
        'B) Üretici sayısı artar',
        'C) Enerji akışı hızlanır',
        'D) Toprak verimi artar',
      ],
      correctIndex: 0,
      explanation: 'Organik atıklar parçalanamaz → inorganik maddeler döngüye dönemez.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Besin zincirinde yukarı çıkıldıkça hangisi yanlıştır?',
      options: [
        'A) Toplam biyokütle azalır',
        'B) Birey sayısı azalır',
        'C) Aktarılan enerji azalır',
        'D) Vücut büyüklüğü her zaman azalır',
      ],
      correctIndex: 3,
      explanation: 'Vücut büyüklüğü genellikle artar ama kesin kural değildir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Baklagil kökündeki Rhizobium bakterileriyle bitki arasındaki ilişki?',
      options: ['A) Parazitlik', 'B) Mutualizm', 'C) Kommensalizm', 'D) Rekabet'],
      correctIndex: 1,
      explanation: 'Her iki taraf da fayda sağlar (karşılıklı yarar = mutualizm).',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Ötrofikasyon sonucu balık ölümlerinin temel sebebi nedir?',
      options: [
        'A) Suyun sıcaklığının artması',
        'B) Çözünmüş oksijen miktarının azalması',
        'C) Alglerin balıkları yemesi',
        'D) Su seviyesinin düşmesi',
      ],
      correctIndex: 1,
      explanation: 'Ölen algleri parçalayan bakteriler sudaki oksijeni tüketir → balıklar boğulur.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Karbon döngüsünde atmosferdeki CO₂ miktarını azaltan tek olay?',
      options: ['A) Solunum', 'B) Yanma', 'C) Fotosentez', 'D) Çürüme'],
      correctIndex: 2,
      explanation: 'Fotosentez atmosferdeki karbonu alıp besine çevirir.',
      difficulty: 3,
    ),
  ],
);

final _tytBioU4Content = StemUnitContent(
  unitId: 'tyt_bio_u4',
  topic: const TopicContent(
    summary:
        'Kalıtım, özelliklerin nesilden nesile aktarılmasını inceler. '
        'Mendel\'in bezelyelerle yaptığı çalışmalar genetik biliminin temelini oluşturmuştur.',
    rule:
        'Genotip: Genetik yapı (AA, Aa). Fenotip: Dış görünüş\n'
        'Dominant (A): Her durumda etkili. Resesif (a): Sadece homozigot (aa) durumda etkili\n'
        'Eş baskınlık: İki genin de fenotipte görülmesi (AB kan grubu)\n'
        'Cinsiyete bağlı: X-Y kromozomları (Renk körlüğü, Hemofili)',
    formulas: [
      'Fenotip Çeşidi: 2ⁿ (n = heterozigot sayısı)',
      'Genotip Çeşidi: 3ⁿ',
      'Gamet Çeşidi: 2ⁿ',
    ],
    keyPoints: [
      'Renk körlüğü/hemofili X\'e bağlı çekinik → erkeklerde daha sık.',
      'Kan gruplarında Rh(+) baskın, Rh(−) çekinik.',
      'Akraba evliliklerinde çekinik hastalıklar ortaya çıkma ihtimali yüksek.',
      'Her doğum bağımsız olaydır; önceki çocuklar sonrakini etkilemez.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Heterozigot (Aa × Aa) ebeveynlerin mavi gözlü (aa) çocuk olasılığı?',
      steps: [
        'Çaprazlama: Aa × Aa = AA, Aa, Aa, aa',
        '4 ihtimalden 1 tanesi aa',
      ],
      answer: '%25',
    ),
    SolvedExample(
      question: 'AB Rh(+) anne ile 0 Rh(−) babanın 0 kan gruplu çocuğu olabilir mi?',
      steps: [
        'Anne AB genotipine sahip → çocuğuna A veya B geni verir',
        '0 kan grubu için her iki ebeveynden 0 geni gelmeli',
      ],
      answer: 'Hayır, olamaz',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Canlının sahip olduğu genlerin tamamına ne denir?',
      options: ['A) Fenotip', 'B) Genotip', 'C) Alel', 'D) Modifikasyon'],
      correctIndex: 1,
      explanation: 'Canlının kalıtsal şifrelerinin bütünü genotiptir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi saf döl (homozigot) çekiniktir?',
      options: ['A) AA', 'B) Aa', 'C) aa', 'D) AB'],
      correctIndex: 2,
      explanation: 'aa durumu hem saf döl hem de çekinik özelliktir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'İnsanlarda cinsiyeti belirleyen kromozom çifti?',
      options: ['A) 21. çift', 'B) 1. çift', 'C) Gonozomlar (X ve Y)', 'D) Otozomlar'],
      correctIndex: 2,
      explanation: 'X ve Y kromozomları cinsiyeti belirleyen gonozomlardır.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'AaBb genotipli canlı kaç çeşit gamet oluşturur? (Bağımsız)',
      options: ['A) 2', 'B) 4', 'C) 6', 'D) 8'],
      correctIndex: 1,
      explanation: 'n=2 heterozigot → 2² = 4 çeşit gamet.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Renk körü babanın tüm kızları taşıyıcıysa annenin genotipi?',
      options: [
        'A) Renk körü',
        'B) Sağlıklı (saf döl)',
        'C) Taşıyıcı',
        'D) Sağlıklı (erkek)',
      ],
      correctIndex: 1,
      explanation: 'Baba XʳY. Kızlar XᴿXʳ (taşıyıcı) → anneden Xᴿ gelmiş → anne saf sağlıklı.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '0 kan grubuna sahip kişi kimlerden kan alabilir?',
      options: ['A) A ve B', 'B) Sadece AB', 'C) Sadece 0', 'D) Herkesten'],
      correctIndex: 2,
      explanation: '0 kan grubu genel vericidir ama sadece 0\'dan kan alabilir.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Bir ailede 4. çocuğun erkek olma ihtimali nedir?',
      options: ['A) 1/2', 'B) 1/4', 'C) 1/8', 'D) 1/16'],
      correctIndex: 0,
      explanation: 'Her doğum bağımsız olay; önceki çocuklar sonrakini etkilemez.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Kan uyuşmazlığı (Eritroblastosis fetalis) hangi durumda görülür?',
      options: [
        'A) Anne (+) / Bebek (−)',
        'B) Anne (−) / Bebek (+)',
        'C) Anne (−) / Bebek (−)',
        'D) Baba (−) / Bebek (+)',
      ],
      correctIndex: 1,
      explanation: 'Anne Rh(−), bebek Rh(+) → annenin antikorları bebeğin alyuvarlarına saldırır.',
      difficulty: 3,
    ),
  ],
);

final _tytBioU5Content = StemUnitContent(
  unitId: 'tyt_bio_u5',
  topic: const TopicContent(
    summary:
        'Bitkiler ototrof ve genellikle hareketsiz; hayvanlar heterotrof ve aktif hareket edebilen organizmalardır. '
        'Bu ünite iki alemin temel yapısal ve işlevsel özelliklerine odaklanır.',
    rule:
        'Bitki Dokuları: Meristem (bölünür), Temel, İletim (Ksilem-Su, Floem-Besin), Örtü\n'
        'Bitkisel Organlar: Kök (su), Gövde (taşıma), Yaprak (fotosentez), Çiçek (üreme)\n'
        'Hayvanlar: Omurgasızlar (Sünger→Eklem bacaklı) ve Omurgalılar (Balık→Memeli)\n'
        'Hayvansal Dokular: Epitel, Bağ, Kas, Sinir',
    formulas: [
      'Terleme Hızı ∝ (Sıcaklık, Rüzgar, Işık) / Nem',
    ],
    keyPoints: [
      'Ksilem: tek yönlü, pasif taşıma. Floem: çift yönlü, aktif taşıma.',
      'Açık dolaşım: omurgasızlar. Kapalı dolaşım: tüm omurgalılar.',
      'Bitkilerde büyüme sınırsız (meristem), hayvanlarda genellikle sınırlı.',
      'Kambiyum (ikincil meristem): enine kalınlaşma ve yaş halkaları.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Bitkide stomalar ne zaman kapanır?',
      steps: [
        'Stomalar su kaybını önlemek için kapanır',
        'Aşırı sıcaklık veya su kıtlığında kapanma tetiklenir',
      ],
      answer: 'Su stresi veya aşırı sıcaklık',
    ),
    SolvedExample(
      question: 'Bir memeli hayvanı kuştan ayıran temel özellik?',
      steps: [
        'Kuşlar yumurtlar, memeliler doğurur ve sütle besler',
        'Ter bezleri ve vücut kılları memelilere özgüdür',
      ],
      answer: 'Yavrusunu sütle beslemesi veya vücut kılları',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'Bitkilerde su ve mineralleri köklerden yapraklara taşıyan yapı?',
      options: ['A) Floem', 'B) Ksilem', 'C) Stoma', 'D) Kambiyum'],
      correctIndex: 1,
      explanation: 'Ksilem (odun borusu) suyun yukarı taşınmasından sorumludur.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangisi omurgasız bir hayvandır?',
      options: ['A) Kurbağa', 'B) Yılan', 'C) Ahtapot', 'D) Serçe'],
      correctIndex: 2,
      explanation: 'Ahtapot yumuşakçalar grubunda yer alan bir omurgasızdır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Bitki hücresinde olup hayvan hücresinde olmayan yapı?',
      options: ['A) Mitokondri', 'B) Hücre zarı', 'C) Hücre çeperi', 'D) Ribozom'],
      correctIndex: 2,
      explanation: 'Hayvan hücrelerinde hücre çeperi bulunmaz.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Böceklerin dış iskeleti hangi maddeden yapılmıştır?',
      options: ['A) Kalsiyum', 'B) Selüloz', 'C) Kitin', 'D) Keratin'],
      correctIndex: 2,
      explanation: 'Böceklerin dış iskeleti dayanıklı karbonhidrat olan kitinden oluşur.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Fotosentezin en yoğun gerçekleştiği yaprak tabakası?',
      options: ['A) Üst epidermis', 'B) Palizat parankiması', 'C) Sünger parankiması', 'D) İletim demetleri'],
      correctIndex: 1,
      explanation: 'Palizat parankiması bol kloroplast içerir ve dik dizilimlidir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kapalı kan dolaşımında hangisi doğrudur?',
      options: [
        'A) Kan damar dışına çıkmaz',
        'B) Kan boşluklara dökülür',
        'C) Taşıma hızı çok yavaş',
        'D) Sadece böceklerde görülür',
      ],
      correctIndex: 0,
      explanation: 'Kapalı dolaşımda kan sürekli kalp ve damarların içindedir.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Gövdenin enine kalınlaşmasını sağlayan doku?',
      options: ['A) Primer meristem', 'B) Kambiyum', 'C) Stoma', 'D) Peridermis'],
      correctIndex: 1,
      explanation: 'Kambiyum (ikincil meristem) yaş halkalarını oluşturur ve enine büyümeyi sağlar.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Kuşlar ve memeliler için ortak olan özellik?',
      options: [
        'A) Tüylere sahip olma',
        'B) Sabit vücut sıcaklığı (sıcakkanlılık)',
        'C) Diyafram kası',
        'D) Çekirdeksiz alyuvarlar',
      ],
      correctIndex: 1,
      explanation: 'Her iki grup da çevre sıcaklığından bağımsız vücut ısılarını korur.',
      difficulty: 3,
    ),
  ],
);

final _tytBioU6Content = StemUnitContent(
  unitId: 'tyt_bio_u6',
  topic: const TopicContent(
    summary:
        'İnsan vücudu homeostaziyi korumak için birlikte çalışan karmaşık sistemlerden oluşur. '
        'TYT kapsamında sindirim, dolaşım, solunum, boşaltım ve denetleyici sistemler incelenir.',
    rule:
        'Sindirim: Besinlerin yapı taşlarına ayrılması (Ağız, Mide, İnce Bağırsak)\n'
        'Dolaşım: Madde taşıması (Kalp, Damarlar, Kan)\n'
        'Solunum: Gaz değişimi (Akciğerler, Alveoller)\n'
        'Boşaltım: Atıkların uzaklaştırılması (Böbrekler, Nefronlar)\n'
        'Denetleyici: Sinir sistemi ve Hormonlar (Endokrin)',
    formulas: [
      'Kullanım sırası: Karbonhidrat > Yağ > Protein',
      'Gram başı verim: Yağ > Protein > Karbonhidrat',
    ],
    keyPoints: [
      'Kimyasal sindirim ince bağırsakta tamamlanır; emilim de burada biter.',
      'Atardamarlar (akciğer atardamarı hariç) temiz kan taşır.',
      'Homeostazi merkezi: Hipotalamus.',
      'Küçük dolaşım: Sağ karıncık → Akciğer → Sol kulakçık.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Proteinlerin kimyasal sindirimi nerede başlar ve nerede biter?',
      steps: [
        'Midede pepsin enzimi ile başlar',
        'İnce bağırsakta amino asitlere kadar parçalanarak biter',
      ],
      answer: 'Mide → İnce Bağırsak',
    ),
    SolvedExample(
      question: 'Kan şekerini düşüren ve yükselten hormonlar?',
      steps: [
        'İnsülin kan şekerini düşürür → hücrelere geçirir',
        'Glukagon kan şekerini yükseltir',
      ],
      answer: 'İnsülin (düşürür) – Glukagon (yükseltir)',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──── KOLAY (1-3) ────
    StemQuestion(
      question: 'O₂ ve CO₂ değişiminin yapıldığı en küçük birim?',
      options: ['A) Bronş', 'B) Alveol', 'C) Yutak', 'D) Trake'],
      correctIndex: 1,
      explanation: 'Akciğerlerdeki alveoller gaz değişim yüzeyidir.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Kanı kalpten vücuda götüren damarlara ne denir?',
      options: ['A) Toplardamar', 'B) Kılcal damar', 'C) Atardamar', 'D) Lenf damarı'],
      correctIndex: 2,
      explanation: 'Kalpten çıkan damarlar atardamardır.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Böbreklerde kanın süzüldüğü temel birim?',
      options: ['A) Üreter', 'B) Mesane', 'C) Nefron', 'D) Korteks'],
      correctIndex: 2,
      explanation: 'Nefronlar böbreğin işlevsel birimleridir.',
      difficulty: 1,
    ),
    // ──── ORTA (4-6) ────
    StemQuestion(
      question: 'Safra nerede üretilir ve görevi nedir?',
      options: [
        'A) Mide – Protein sindirimi',
        'B) Karaciğer – Yağların mekanik sindirimi',
        'C) Pankreas – Şeker dengesi',
        'D) İnce bağırsak – Emilim',
      ],
      correctIndex: 1,
      explanation: 'Safra karaciğerde üretilir ve yağları fiziksel olarak parçalar.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Refleks hareketlerinin kontrol merkezi neresidir?',
      options: ['A) Beyincik', 'B) Omurilik', 'C) Omurilik soğanı', 'D) Hipofiz'],
      correctIndex: 1,
      explanation: 'Ani refleksler omurilik tarafından yönetilir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Hangisi bir iç salgı bezidir?',
      options: ['A) Tükürük bezi', 'B) Ter bezi', 'C) Tiroid bezi', 'D) Gözyaşı bezi'],
      correctIndex: 2,
      explanation: 'Hormon üreterek kana veren bezler (tiroid gibi) endokrin bezlerdir.',
      difficulty: 2,
    ),
    // ──── ZOR (7-8) ────
    StemQuestion(
      question: 'Küçük kan dolaşımının izlediği yol?',
      options: [
        'A) Sol karıncık → Vücut → Sağ kulakçık',
        'B) Sağ karıncık → Akciğer → Sol kulakçık',
        'C) Sağ kulakçık → Karaciğer → Sol karıncık',
        'D) Sol kulakçık → Böbrek → Sağ kulakçık',
      ],
      correctIndex: 1,
      explanation: 'Küçük dolaşım: kanın temizlenmesi için kalp-akciğer arası.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Çizgili kas kasılırken hangisinin miktarı azalmaz?',
      options: ['A) ATP', 'B) Glikoz', 'C) Oksijen', 'D) Laktik asit'],
      correctIndex: 3,
      explanation: 'Kasılma sırasında laktik asit üretilir, miktarı artar (azalmaz).',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// TYT TÜM İÇERİK HARİTASI (Export)
// ═══════════════════════════════════════════════════════════════

final Map<String, StemUnitContent> allStemContentTyt = {
  // Matematik
  'tyt_mat_u1': _tytMatU1Content,
  'tyt_mat_u2': _tytMatU2Content,
  'tyt_mat_u3': _tytMatU3Content,
  'tyt_mat_u4': _tytMatU4Content,
  'tyt_mat_u5': _tytMatU5Content,
  'tyt_mat_u6': _tytMatU6Content,
  'tyt_mat_u7': _tytMatU7Content,
  'tyt_mat_u8': _tytMatU8Content,
  'tyt_mat_u9': _tytMatU9Content,
  'tyt_mat_u10': _tytMatU10Content,
  'tyt_mat_u11': _tytMatU11Content,
  'tyt_mat_u12': _tytMatU12Content,
  'tyt_mat_u13': _tytMatU13Content,
  'tyt_mat_u14': _tytMatU14Content,
  'tyt_mat_u15': _tytMatU15Content,
  // Fizik
  'tyt_fiz_u1': _tytFizU1Content,
  'tyt_fiz_u2': _tytFizU2Content,
  'tyt_fiz_u3': _tytFizU3Content,
  'tyt_fiz_u4': _tytFizU4Content,
  'tyt_fiz_u5': _tytFizU5Content,
  'tyt_fiz_u6': _tytFizU6Content,
  'tyt_fiz_u7': _tytFizU7Content,
  // Kimya
  'tyt_kim_u1': _tytKimU1Content,
  'tyt_kim_u2': _tytKimU2Content,
  'tyt_kim_u3': _tytKimU3Content,
  'tyt_kim_u4': _tytKimU4Content,
  'tyt_kim_u5': _tytKimU5Content,
  'tyt_kim_u6': _tytKimU6Content,
  'tyt_kim_u7': _tytKimU7Content,
  // Biyoloji
  'tyt_bio_u1': _tytBioU1Content,
  'tyt_bio_u2': _tytBioU2Content,
  'tyt_bio_u3': _tytBioU3Content,
  'tyt_bio_u4': _tytBioU4Content,
  'tyt_bio_u5': _tytBioU5Content,
  'tyt_bio_u6': _tytBioU6Content,
};
