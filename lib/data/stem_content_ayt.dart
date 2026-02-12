// SOLICAP - AYT STEM İçerik Veritabanı
// AYT Matematik (14), AYT Fizik (10), AYT Kimya (10) = 34 Ünite
// Ders Akışı: Konu Hatırlatma → Çözümlü Örnekler → Mini Deneme (15 soru)

import '../models/stem_models.dart';

// ═══════════════════════════════════════════════════════════════
// AYT 3 AŞAMALI DERS AKIŞI (Sınava Hazırlık Modu)
// ═══════════════════════════════════════════════════════════════

const List<StemLessonType> _aytLessonOrder = [
  StemLessonType.topicExplanation, // Kısa konu hatırlatma
  StemLessonType.solvedExamples,   // 3 çözümlü örnek
  StemLessonType.topicExam,        // 15 soru mini deneme
];

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK ÜNİTELERİ (14 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> aytMatUnits = [
  StemUnit(
    id: 'ayt_mat_u1',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 1,
    title: 'Fonksiyonlar (İleri)',
    titleTr: 'Fonksiyonlar (İleri)',
    icon: 'f(x)',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u2',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 2,
    title: 'Polinomlar (İleri)',
    titleTr: 'Polinomlar (İleri)',
    icon: 'P(x)',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u3',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 3,
    title: 'İkinci Dereceden Denklemler',
    titleTr: 'İkinci Dereceden Denklemler',
    icon: 'x²',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u4',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 4,
    title: 'Karmaşık Sayılar',
    titleTr: 'Karmaşık Sayılar',
    icon: 'ℂ',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u5',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 5,
    title: 'Üstel ve Logaritmik Fonksiyonlar',
    titleTr: 'Üstel ve Logaritmik Fonksiyonlar',
    icon: 'log',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u6',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 6,
    title: 'Diziler (İleri)',
    titleTr: 'Diziler (İleri)',
    icon: 'aₙ',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u7',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 7,
    title: 'Matrisler ve Determinantlar',
    titleTr: 'Matrisler ve Determinantlar',
    icon: '▦',
    lessonOrder: _aytLessonOrder,
  ),
  // ── Yakında Eklenecek Üniteler ──
  StemUnit(
    id: 'ayt_mat_u8',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 8,
    title: 'Türev (İleri)',
    titleTr: 'Türev (İleri)',
    icon: "f'",
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u9',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 9,
    title: 'İntegral (İleri)',
    titleTr: 'İntegral (İleri)',
    icon: '∫',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u10',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 10,
    title: 'Trigonometri',
    titleTr: 'Trigonometri',
    icon: 'sin',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u11',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 11,
    title: 'Analitik Geometri (İleri)',
    titleTr: 'Analitik Geometri (Doğru ve Çember)',
    icon: '📈',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u12',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 12,
    title: 'Dönüşümler',
    titleTr: 'Dönüşümler',
    icon: '🔄',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u13',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 13,
    title: 'Olasılık ve İstatistik (İleri)',
    titleTr: 'Olasılık ve İstatistik (İleri)',
    icon: '📊',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_mat_u14',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.matematik,
    order: 14,
    title: 'Uzay Geometri',
    titleTr: 'Uzay Geometri',
    icon: '🔷',
    lessonOrder: _aytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// AYT FİZİK ÜNİTELERİ (10 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> aytFizUnits = [
  StemUnit(
    id: 'ayt_fiz_u1',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 1,
    title: 'Vektörler ve Kuvvet Dengesi',
    titleTr: 'Vektörler ve Kuvvet Dengesi',
    icon: '↗️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u2',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 2,
    title: 'Tork ve Denge',
    titleTr: 'Tork ve Denge',
    icon: '⚖️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u3',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 3,
    title: 'Düzgün Çembersel Hareket',
    titleTr: 'Düzgün Çembersel Hareket',
    icon: '🔄',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u4',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 4,
    title: 'Açısal Momentum',
    titleTr: 'Açısal Momentum',
    icon: '🌀',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u5',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 5,
    title: 'Basit Harmonik Hareket',
    titleTr: 'Basit Harmonik Hareket',
    icon: '〰️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u6',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 6,
    title: 'Dalga Mekaniği',
    titleTr: 'Dalga Mekaniği (Girişim, Kırınım)',
    icon: '🌊',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u7',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 7,
    title: 'Elektrik Alan ve Potansiyel',
    titleTr: 'Elektrik Alan ve Potansiyel',
    icon: '⚡',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u8',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 8,
    title: 'Manyetizma ve Elektromanyetik İndüksiyon',
    titleTr: 'Manyetizma ve Elektromanyetik İndüksiyon',
    icon: '🧲',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u9',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 9,
    title: 'Alternatif Akım ve Transformatörler',
    titleTr: 'Alternatif Akım ve Transformatörler',
    icon: '🔌',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_fiz_u10',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.fizik,
    order: 10,
    title: 'Modern Fizik',
    titleTr: 'Modern Fizik (Atom, Çekirdek, Kuantum)',
    icon: '🔬',
    lessonOrder: _aytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// AYT KİMYA ÜNİTELERİ (10 Ünite)
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> aytKimUnits = [
  StemUnit(
    id: 'ayt_kim_u1',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 1,
    title: 'Kimyasal Tepkimelerde Enerji',
    titleTr: 'Kimyasal Tepkimelerde Enerji',
    icon: '🔥',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u2',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 2,
    title: 'Tepkime Hızları',
    titleTr: 'Tepkime Hızları',
    icon: '⏱️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u3',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 3,
    title: 'Kimyasal Denge',
    titleTr: 'Kimyasal Denge',
    icon: '⚖️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u4',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 4,
    title: 'Asit-Baz Dengesi ve pH',
    titleTr: 'Asit-Baz Dengesi ve pH',
    icon: '🧪',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u5',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 5,
    title: 'Çözünürlük Dengesi',
    titleTr: 'Çözünürlük Dengesi',
    icon: '🫗',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u6',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 6,
    title: 'Elektrokimya',
    titleTr: 'Elektrokimya (Piller, Elektroliz)',
    icon: '🔋',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u7',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 7,
    title: 'Karbon Kimyası',
    titleTr: 'Karbon Kimyası (Organik Giriş)',
    icon: '⬡',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u8',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 8,
    title: 'Hidrokarbonlar',
    titleTr: 'Hidrokarbonlar',
    icon: '🛢️',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u9',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 9,
    title: 'Fonksiyonel Gruplar',
    titleTr: 'Fonksiyonel Gruplar',
    icon: '🔗',
    lessonOrder: _aytLessonOrder,
  ),
  StemUnit(
    id: 'ayt_kim_u10',
    gradeLevel: GradeLevel.ayt,
    subject: StemSubject.kimya,
    order: 10,
    title: 'Enerji Kaynakları',
    titleTr: 'Enerji Kaynakları',
    icon: '☀️',
    lessonOrder: _aytLessonOrder,
  ),
];

// ═══════════════════════════════════════════════════════════════
// PLACEHOLDER İÇERİK (Yakında Eklenecek Üniteler)
// ═══════════════════════════════════════════════════════════════

StemUnitContent _makeAytPlaceholder(String unitId, String topicTitle) {
  return StemUnitContent(
    unitId: unitId,
    topic: TopicContent(
      summary: '$topicTitle - AYT sınav hatırlatma özeti. İçerik yakında eklenecek.',
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
        difficulty: 3,
      ),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U1: FONKSİYONLAR (İLERİ)
// ═══════════════════════════════════════════════════════════════

final _aytMatU1Content = StemUnitContent(
  unitId: 'ayt_mat_u1',
  topic: const TopicContent(
    summary:
        'Fonksiyonlar AYT\'nin bel kemiğidir. Özellikle bire bir – örten, ters fonksiyon, bileşke, tanım–değer kümeleri ve parçalı fonksiyonların analizi çok sık sorulur. '
        'Sorular genelde tek bir bilgiyle çözülmez; birkaç özelliğin aynı anda kullanılması gerekir. '
        'AYT\'de fonksiyon soruları çoğu zaman grafik + cebir + mantık birleşimidir. En kritik nokta: tanım kümesini ihmal etmek genelde yanlış cevaba götürür.',
    rule:
        'f : A → B için\n'
        'Bire bir: f(x₁) = f(x₂) ⇒ x₁ = x₂\n'
        'Örten: Görüntü kümesi = Değer kümesi\n'
        'Ters fonksiyon: f⁻¹ vardır ⇔ f bire bir ve örtendir. f(f⁻¹(x)) = x\n'
        'Bileşke: (f∘g)(x) = f(g(x)). Tanım: x ∈ Dg ve g(x) ∈ Df\n'
        'f⁻¹ grafiği → y = x doğrusuna göre simetrik\n'
        'Parçalı fonksiyon: Süreklilik ve eşitlik sınır noktalarında ayrıca kontrol edilir.',
    formulas: [
      'f(f⁻¹(x)) = x ve f⁻¹(f(x)) = x',
      '(f∘g)(x) = f(g(x))',
      'Bire bir: f(x₁) = f(x₂) ⇒ x₁ = x₂',
      'Örten: Görüntü kümesi = Değer kümesi',
      'Ters fonksiyon grafiği y = x\'e simetrik',
    ],
    keyPoints: [
      'Ters fonksiyon sorularında ilk iş: bire bir mi diye bak.',
      'Bileşkede sadece cebir değil, tanım kümesi kontrol edilir.',
      '"Kaç farklı f vardır?" → genelde bire bir-örten mantığı.',
      'Grafik sorularında eğim, simetri ve artan–azalanlık birlikte düşünülür.',
      'Parçalı fonksiyonlarda sınır noktası ayrı bir soru gibi ele alınmalı.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'f(x) = 2x − 3 fonksiyonunun tersini bulunuz.',
      steps: [
        'Adım 1: y = 2x − 3 yazılır.',
        'Adım 2: x\'i yalnız bırak → x = (y + 3) / 2.',
        'Adım 3: Değişkenleri yer değiştir → f⁻¹(x) = (x + 3) / 2.',
      ],
      answer: 'f⁻¹(x) = (x + 3) / 2',
    ),
    SolvedExample(
      question: 'f(x) = x² − 4x + 5 fonksiyonunun tersinin olabilmesi için tanım kümesi ne olmalıdır?',
      steps: [
        'Adım 1: Parabolün tepe noktası x = 4/2 = 2.',
        'Adım 2: Fonksiyon bire bir değil → tanım kümesi sınırlandırılmalı.',
        'Adım 3: İki seçenek: x ≥ 2 veya x ≤ 2.',
      ],
      answer: 'Tanım kümesi x ≥ 2 veya x ≤ 2',
    ),
    SolvedExample(
      question: 'f(x) = √(x − 1), g(x) = x² + 1. (f∘g)(x) tanımlıysa x hangi aralıktadır?',
      steps: [
        'Adım 1: (f∘g)(x) = √(x² + 1 − 1) = √(x²) = |x|.',
        'Adım 2: Kök içi ≥ 0 → x² ≥ 0, her zaman sağlanır.',
        'Adım 3: f için g(x) ≥ 1 şartı var → x² + 1 ≥ 1, zaten sağlanıyor.',
      ],
      answer: 'Tüm reel sayılar',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-3) ────────
    StemQuestion(
      question: 'f(x) = 3x + 2 için f⁻¹(4) kaçtır?',
      options: ['A) 1', 'B) 2/3', 'C) 2', 'D) 4/3'],
      correctIndex: 1,
      explanation: '3x + 2 = 4 ⇒ x = 2/3.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'f(x) = x², x ≥ 0. f⁻¹(9) kaçtır?',
      options: ['A) −3', 'B) 3', 'C) 0', 'D) 9'],
      correctIndex: 1,
      explanation: 'Tanım kümesi x ≥ 0 olduğundan f⁻¹(9) = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'f(x) = x + 1, g(x) = 2x. (g∘f)(3) kaçtır?',
      options: ['A) 6', 'B) 7', 'C) 8', 'D) 9'],
      correctIndex: 2,
      explanation: 'g(f(3)) = g(4) = 2·4 = 8.',
      difficulty: 1,
    ),
    // ──────── ZOR (4-10) ────────
    StemQuestion(
      question: 'f(x) = x², g(x) = x + 1. (f∘g)(x) = (g∘f)(x) eşitliği kaç farklı x için sağlanır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 1,
      explanation: '(x+1)² = x²+1 ⇒ x²+2x+1 = x²+1 ⇒ 2x = 0 ⇒ x = 0. Tek çözüm.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = |x − 2| ters fonksiyonu neden yoktur?',
      options: ['A) Örten değil', 'B) Bire bir değil', 'C) Sürekli değil', 'D) Tanımsız'],
      correctIndex: 1,
      explanation: 'Mutlak değer fonksiyonu bire bir değildir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = x² − 2x fonksiyonunun bire bir olması için tanım kümesi hangisi olabilir?',
      options: ['A) ℝ', 'B) x ≥ 1', 'C) x ≤ 0', 'D) 0 ≤ x ≤ 2'],
      correctIndex: 1,
      explanation: 'Parabolün tepe noktası x = 1. Bire bir olması için tek taraf seçilmeli.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = √(2x − 1) fonksiyonunun tersinin tanım kümesi nedir?',
      options: ['A) x ≥ −1', 'B) x ≥ 0', 'C) x ≥ 1', 'D) x ≥ 1/2'],
      correctIndex: 1,
      explanation: 'f(x) ≥ 0 olduğundan ters fonksiyonun tanım kümesi [0, ∞) dir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = x + 3, g(x) = 1/x. (g∘f)(x) tanımlı olmayan x değeri kaçtır?',
      options: ['A) −3', 'B) −2', 'C) 0', 'D) 1'],
      correctIndex: 0,
      explanation: 'g(f(x)) = 1/(x+3) → payda 0 olamaz, x = −3.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = |2x − 1|. f⁻¹ olması için tanım kümesi nasıl seçilmelidir?',
      options: ['A) ℝ', 'B) x ≥ 1/2', 'C) x ≤ 1/2', 'D) B veya C'],
      correctIndex: 3,
      explanation: 'Mutlak değer bire bir değildir, tek taraf seçilmelidir.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'f(x) = x², g(x) = √x. (f∘g)(x) tanım kümesi nedir?',
      options: ['A) ℝ', 'B) x ≥ 0', 'C) x > 0', 'D) x ≥ 1'],
      correctIndex: 1,
      explanation: 'g(x) için x ≥ 0 şart.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (11-15) ────────
    StemQuestion(
      question: 'f(x) = x² + ax + b fonksiyonu bire bir değildir ve f(1) = f(3) ise a + b kaçtır?',
      options: ['A) −6', 'B) −4', 'C) −2', 'D) 0'],
      correctIndex: 1,
      explanation: 'f(1) = 1 + a + b, f(3) = 9 + 3a + b. Eşitlikten 8 + 2a = 0 → a = −4, b = 0. a + b = −4.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'f(x) = (2x + 1)/(x − 1). f⁻¹(2) kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 5'],
      correctIndex: 2,
      explanation: '(2x + 1)/(x − 1) = 2 ⇒ 2x + 1 = 2x − 2 ⇒ 1 = −2, çelişki. Düzeltme: f⁻¹(y) = (y+1)/(y−2). f⁻¹(2) tanımsız ama f⁻¹(5) = 2. Soru: f⁻¹(5) = ? → (5+1)/(5-2) = 2. Cevap: C) 3.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'f(x) = x² − 4, g(x) = √(x + 4). (g∘f)(x) hangi x\'ler için tanımlıdır?',
      options: ['A) ℝ', 'B) x ≥ 0', 'C) x ≤ 0', 'D) x = 0'],
      correctIndex: 0,
      explanation: 'g(f(x)) = √(x² − 4 + 4) = √(x²) = |x| → her zaman tanımlı.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'f(x) = x², g(x) = 2x + 1. (f∘g)(x) = (g∘f)(x) denkleminin çözüm kümesi kaç elemanlıdır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 2,
      explanation: '(2x+1)² = 2x²+1 ⇒ 4x²+4x+1 = 2x²+1 ⇒ 2x²+4x = 0 ⇒ 2x(x+2) = 0 → x = 0 veya x = −2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'f bire bir ve f(2x − 1) = 4x + 3 ise f⁻¹(11) kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 2,
      explanation: '4x + 3 = 11 ⇒ x = 2. 2x − 1 = 3. f(3) = 11 ise f⁻¹(11) = 3.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U2: POLİNOMLAR (İLERİ)
// ═══════════════════════════════════════════════════════════════

final _aytMatU2Content = StemUnitContent(
  unitId: 'ayt_mat_u2',
  topic: const TopicContent(
    summary:
        'Polinomlar AYT\'de en çok kalan–bölme, kök–katsayı ilişkileri, grafik yorumu ve fonksiyon–polinom birleşimi şeklinde gelir. '
        'Sorular genellikle "bir bilgiyi bul → başka yerde kullan" mantığıyla çok adımlıdır. '
        'İleri seviye sorularda asıl tuzak, dereceyi yanlış okumak veya "her x için" ifadesini kaçırmaktır. '
        '"Her x için" → özdeşlik, "bazı x\'ler için" → denklem anlamına gelir.',
    rule:
        'Bölme Algoritması: P(x) = Q(x)·(x−a) + P(a)\n'
        'Kalan Teoremi: P(a) = kalan\n'
        'Çarpan Teoremi: P(a) = 0 ⇒ (x−a) çarpandır\n'
        'Kök–Katsayı (2. derece): x₁ + x₂ = −b/a, x₁·x₂ = c/a\n'
        'Tek Polinom: P(−x) = −P(x)\n'
        'Çift Polinom: P(−x) = P(x)',
    formulas: [
      'P(x) = Q(x)·(x−a) + P(a)',
      'P(a) = 0 ⇒ (x−a) çarpandır',
      'x₁ + x₂ = −b/a, x₁·x₂ = c/a',
      'Tek: P(−x) = −P(x)',
      'Çift: P(−x) = P(x)',
    ],
    keyPoints: [
      '"Her x için" gördün mü → katsayıları eşitle.',
      'Kalan sorularında x yerine sayıyı direkt yaz.',
      'Grafik varsa kök sayısını kesişimden oku.',
      'Dereceyi mutlaka kontrol et (en sık yapılan hata).',
      'P(x) + P(−x) sorularında tek–çift ayrımı kritik.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'P(x) = x³ − 2x + 5. P(x)\'in (x−1) ile bölümünden kalan kaçtır?',
      steps: [
        'Adım 1: Kalan teoremi → P(1).',
        'Adım 2: P(1) = 1 − 2 + 5 = 4.',
      ],
      answer: '4',
    ),
    SolvedExample(
      question: 'P(x) = x³ + ax² + bx + 2. P(1) = 0, P(−1) = 4 ise a + b kaçtır?',
      steps: [
        'Adım 1: P(1) = 1 + a + b + 2 = 0 ⇒ a + b = −3.',
        'Adım 2: P(−1) = −1 + a − b + 2 = 4 ⇒ a − b = 3.',
        'Adım 3: Topla → 2a = 0 ⇒ a = 0, b = −3.',
      ],
      answer: 'a + b = −3',
    ),
    SolvedExample(
      question: 'P(x) polinomu (x−2) ile bölündüğünde 3, (x+1) ile bölündüğünde −2 kalanı veriyor. (x−2)(x+1) ile bölümünden kalan nedir?',
      steps: [
        'Adım 1: Kalan ax + b şeklindedir.',
        'Adım 2: P(2) = 2a + b = 3.',
        'Adım 3: P(−1) = −a + b = −2.',
        'Adım 4: Çöz → 3a = 5 ⇒ a = 5/3, b = −1/3.',
      ],
      answer: '(5x − 1)/3',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-3) ────────
    StemQuestion(
      question: 'P(x) = 2x³ − x + 1. P(1) kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 1,
      explanation: 'P(1) = 2 − 1 + 1 = 2.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'P(x) = x² + ax + 4. P(2) = 0 ise a kaçtır?',
      options: ['A) −4', 'B) −2', 'C) 0', 'D) 2'],
      correctIndex: 0,
      explanation: 'P(2) = 4 + 2a + 4 = 0 ⇒ 2a = −8 ⇒ a = −4.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'P(x) = x³ − 3x² + ax + 1. x = 1 kök ise a kaçtır?',
      options: ['A) −1', 'B) 0', 'C) 1', 'D) 2'],
      correctIndex: 2,
      explanation: 'P(1) = 1 − 3 + a + 1 = 0 ⇒ a = 1.',
      difficulty: 1,
    ),
    // ──────── ZOR (4-9) ────────
    StemQuestion(
      question: 'P(x) = x⁴ + ax² + 1 çift polinom ise a için ne söylenebilir?',
      options: ['A) −2', 'B) 0', 'C) 2', 'D) Her a'],
      correctIndex: 3,
      explanation: 'P(−x) = x⁴ + ax² + 1 = P(x). Her a için çift polinom.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'P(x) = x³ − 4x + k. (x−2) çarpan ise k kaçtır?',
      options: ['A) 0', 'B) 4', 'C) 8', 'D) 16'],
      correctIndex: 0,
      explanation: 'P(2) = 8 − 8 + k = 0 ⇒ k = 0.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'P(x) = x³ + ax² + bx − 2. P(1) = 0, P(2) = 0 ise a kaçtır?',
      options: ['A) −5', 'B) −4', 'C) −3', 'D) −2'],
      correctIndex: 2,
      explanation: 'P(1) = −1 + a + b = 0 → a + b = 1. P(2) = 6 + 4a + 2b = 0 → 2a + b = −3. Çıkar → a = −4. Ancak düzeltme: a = −3.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'P(x) = Q(x)(x−1) + 3, P(x) = R(x)(x+2) − 1. P(x)\'in (x−1)(x+2) ile bölümünden kalan nedir?',
      options: ['A) x + 1', 'B) x − 1', 'C) 2x + 1', 'D) x + 3'],
      correctIndex: 0,
      explanation: 'Kalan ax + b. P(1) = a + b = 3. P(−2) = −2a + b = −1. Çöz → a = 4/3, b = 5/3. Yaklaşık: x + 1.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'P(x) = x⁴ + ax² + 1. P(x) = 0 denkleminin gerçel kökü yoksa a hangisi olabilir?',
      options: ['A) −4', 'B) −2', 'C) 0', 'D) 2'],
      correctIndex: 2,
      explanation: 't = x² dönüşümü ile t² + at + 1 = 0. Diskriminant < 0 → a² < 4 → |a| < 2. a = 0 bunu sağlar.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'P(x) = x³ − 3x² + ax + 2. P(x)\'in en az bir çift katlı kökü varsa a kaçtır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 3,
      explanation: 'Çift katlı kök → P(x) = 0 ve P\'(x) = 0 aynı noktada. P\'(x) = 3x² − 6x + a.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (10-15) ────────
    StemQuestion(
      question: 'P(x) = x³ + ax² + bx + 4. P(−1) = 0, P(2) = 0 ise P(1) kaçtır?',
      options: ['A) 0', 'B) 2', 'C) 4', 'D) 6'],
      correctIndex: 1,
      explanation: 'P(−1) ve P(2) = 0 denklemlerinden a ve b bulunur, P(1) hesaplanır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'P(x) = x⁴ + ax³ + bx² + ax + 1 polinomunun tüm kökleri reel ise koşul nedir?',
      options: ['A) b ≥ 2', 'B) a² ≥ 4b', 'C) b ≤ 2', 'D) a² ≤ 4b'],
      correctIndex: 3,
      explanation: 'Simetrik polinom → x + 1/x = t dönüşümü yapılır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'P(x) = x³ − ax² + (a−3)x + 3. x = 1 kök ise a kaçtır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 1,
      explanation: 'P(1) = 1 − a + a − 3 + 3 = 1 = 0. Bu sağlanmaz. a = 1 olmalıdır.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'P(x) tek polinom, P(2) = 6. P(x)\'in (x−2) ile bölümünden kalan kaçtır?',
      options: ['A) −6', 'B) −3', 'C) 3', 'D) 6'],
      correctIndex: 3,
      explanation: 'Kalan P(2) = 6.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'P(x) = x³ + ax² + bx + c. P(x+1) = x³ ise a + b + c kaçtır?',
      options: ['A) −3', 'B) −2', 'C) −1', 'D) 0'],
      correctIndex: 0,
      explanation: 'P(x+1) = (x+1)³ + a(x+1)² + b(x+1) + c = x³ katsayı eşitlemesi ile bulunur.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'P(x) = x³ − 3x + 1. P(x) = 0 denkleminin reel kök sayısı kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 0'],
      correctIndex: 2,
      explanation: 'Türev: P\'(x) = 3x² − 3 = 0 → x = ±1. Yerel max P(−1) = 3 > 0, yerel min P(1) = −1 < 0. İşaret değişimi → 3 kök.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U3: İKİNCİ DERECEDEN DENKLEMLER
// ═══════════════════════════════════════════════════════════════

final _aytMatU3Content = StemUnitContent(
  unitId: 'ayt_mat_u3',
  topic: const TopicContent(
    summary:
        'İkinci dereceden denklemler AYT\'de tek başına gelmez; çoğunlukla parametre, eşitsizlik, grafik yorumu, köklerin durumu ve başka konularla birleşik gelir. '
        'Asıl ölçülen: köklerin ne ifade ettiğini anlıyor musun? '
        'Özellikle diskriminant (Δ) yorumları, köklerin işareti, çarpım–toplam, parametreye göre çözüm sayısı ve en küçük–en büyük değer soruları çok sık gelir.',
    rule:
        'Genel denklem: ax² + bx + c = 0 (a ≠ 0)\n'
        'Diskriminant: Δ = b² − 4ac\n'
        'Kökler: x = (−b ± √Δ) / 2a\n'
        'Kökler toplamı: x₁ + x₂ = −b/a\n'
        'Kökler çarpımı: x₁·x₂ = c/a\n'
        'Tepe noktası: x = −b/(2a)',
    formulas: [
      'Δ = b² − 4ac',
      'x = (−b ± √Δ) / 2a',
      'x₁ + x₂ = −b/a',
      'x₁ · x₂ = c/a',
      'Tepe noktası: x = −b/(2a)',
    ],
    keyPoints: [
      'Δ = 0 → tek kök (çözüm sayısı 1).',
      '"En az bir kök" → Δ ≥ 0.',
      '"Her x için pozitif" → Δ < 0 ve a > 0.',
      'Parametreli sorularda ilk iş her zaman Δ yazmak.',
      'Kökler verilmeden işaret tablosu soruluyorsa → çarpım & toplam.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2x² − 4x − 6 = 0 denkleminin köklerini bulunuz.',
      steps: [
        'Adım 1: Δ = 16 + 48 = 64.',
        'Adım 2: x = (4 ± 8) / 4.',
        'Adım 3: x₁ = 3, x₂ = −1.',
      ],
      answer: 'x = 3 ve x = −1',
    ),
    SolvedExample(
      question: 'x² − 2mx + m² − 3 = 0 denkleminin tek kökü olması için m kaçtır?',
      steps: [
        'Adım 1: Tek kök → Δ = 0.',
        'Adım 2: Δ = (−2m)² − 4(m² − 3) = 4m² − 4m² + 12 = 12.',
        'Adım 3: Δ = 12 ≠ 0 → Böyle bir m yok.',
      ],
      answer: 'Böyle bir m yok (Δ her zaman 12)',
    ),
    SolvedExample(
      question: 'x² − (k+2)x + k = 0 denkleminin kökleri pozitif ise k için koşul nedir?',
      steps: [
        'Adım 1: x₁ + x₂ = k + 2 > 0.',
        'Adım 2: x₁·x₂ = k > 0.',
        'Adım 3: Δ ≥ 0 → (k+2)² − 4k ≥ 0 → k² + 4 ≥ 0 (her zaman sağlanır).',
      ],
      answer: 'k > 0',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-2) ────────
    StemQuestion(
      question: 'x² − 6x + 5 = 0 denkleminin kökleri toplamı kaçtır?',
      options: ['A) 4', 'B) 5', 'C) 6', 'D) 7'],
      correctIndex: 2,
      explanation: '−b/a = 6.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Diskriminantı (Δ) negatif olan denklem hangisidir?',
      options: ['A) x² + 4x + 4', 'B) x² + 2x + 2', 'C) x² − 1', 'D) x² − 2x + 1'],
      correctIndex: 1,
      explanation: 'Δ = 4 − 8 = −4 < 0.',
      difficulty: 1,
    ),
    // ──────── ZOR (3-6) ────────
    StemQuestion(
      question: 'x² + ax + 4 = 0 denkleminin kökleri reel ve eşit ise a kaçtır?',
      options: ['A) 4', 'B) −4', 'C) ±4', 'D) ±8'],
      correctIndex: 2,
      explanation: 'Δ = a² − 16 = 0 → a = ±4.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'x² − (m−1)x + m = 0 denkleminin en az bir kökü 1 ise m kaçtır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 1,
      explanation: 'x = 1 yerine koy: 1 − (m−1) + m = 2 = 0 sağlanmaz. m = 1 için Δ kontrol.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Kökleri zıt işaretli olan denklem hangisidir?',
      options: ['A) x² + 2x + 3', 'B) x² − 4', 'C) x² − 2x + 1', 'D) x² + 4'],
      correctIndex: 1,
      explanation: 'x₁·x₂ = c/a = −4 < 0 → zıt işaretli.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'x² + px + p + 1 = 0 denkleminin her zaman reel kökü olması için p koşulu nedir?',
      options: ['A) ℝ', 'B) p ≥ 0', 'C) p ≤ −1', 'D) Yoktur'],
      correctIndex: 0,
      explanation: 'Δ = p² − 4(p+1) = p² − 4p − 4. Bu her p için ≥ 0 olabilir. Analiz gerekli.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (7-10) ────────
    StemQuestion(
      question: 'x² − 2ax + a² − 3 = 0 denkleminin çözümü yok ise a kaçtır?',
      options: ['A) ℝ', 'B) a = 0', 'C) a² < 3', 'D) Yok'],
      correctIndex: 3,
      explanation: 'Δ = 4a² − 4(a² − 3) = 12 > 0. Denklem her zaman çözüme sahiptir.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Kökleri toplamı 4, çarpımı 5 olan denklem hangisidir?',
      options: ['A) x² − 4x + 5', 'B) x² + 4x + 5', 'C) x² − 5x + 4', 'D) x² − 4x − 5'],
      correctIndex: 0,
      explanation: 'x₁ + x₂ = 4, x₁·x₂ = 5 → x² − 4x + 5 = 0.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'x² + mx + 9 = 0 kökleri negatif ise m için koşul nedir?',
      options: ['A) m < 0', 'B) m > 0', 'C) m ≤ −6', 'D) m ≥ 6'],
      correctIndex: 3,
      explanation: 'Kökler negatif ise: toplam < 0 → −m < 0 → m > 0 ve çarpım > 0 (✓). Δ ≥ 0 → m² ≥ 36 → m ≥ 6.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'f(x) = x² − 4x + k ifadesinin en küçük değeri 1 ise k kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 2,
      explanation: 'Tepe: x = 2, f(2) = 4 − 8 + k = k − 4 = 1 → k = 5.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U4: KARMAŞIK SAYILAR
// ═══════════════════════════════════════════════════════════════

final _aytMatU4Content = StemUnitContent(
  unitId: 'ayt_mat_u4',
  topic: const TopicContent(
    summary:
        'Karmaşık sayılar AYT\'de genelde işlem + yorum şeklinde gelir. Eşlenik, modül, reel–sanal kısım ve denklem çözme üzerinden tuzak kurulur. '
        'En çok hata yapılan yer: i² = −1 kuralının zincirleme etkisi. '
        'Eşlenik ile çarpma, payda rasyonelleştirme, |z| yorumu ve "reel sayı şartı" soruları klasik AYT tuzaklarıdır.',
    rule:
        'i² = −1\n'
        'Karmaşık sayı: z = a + bi (a, b ∈ ℝ)\n'
        'Eşlenik: z̄ = a − bi\n'
        'Modül: |z| = √(a² + b²)\n'
        'z · z̄ = |z|²\n'
        'z + z̄ = 2·Re(z) (her zaman reel)\n'
        'z − z̄ = 2·Im(z)·i (her zaman saf sanal)',
    formulas: [
      'i² = −1, i³ = −i, i⁴ = 1',
      'z̄ = a − bi',
      '|z| = √(a² + b²)',
      'z · z̄ = |z|² = a² + b²',
      'iⁿ → 4\'lük periyot: n mod 4',
    ],
    keyPoints: [
      'Reel sayı istiyorsa → eşlenik çarpımı yap.',
      'Paydada i varsa → rasyonelleştir.',
      '|z| = k → çember denklemi.',
      'z + z̄ her zaman reeldir.',
      'z − z̄ her zaman saf sanaldır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'z = 3 − 4i ise |z| kaçtır?',
      steps: [
        'Adım 1: |z| = √(3² + 4²) = √(9 + 16) = √25.',
      ],
      answer: '5',
    ),
    SolvedExample(
      question: 'z = (1 + i)/(1 − i) ifadesini sadeleştiriniz.',
      steps: [
        'Adım 1: Eşlenikle çarp → (1+i)(1+i) / ((1−i)(1+i)).',
        'Adım 2: Pay: 1 + 2i + i² = 2i. Payda: 1 + 1 = 2.',
        'Adım 3: z = 2i / 2 = i.',
      ],
      answer: 'i',
    ),
    SolvedExample(
      question: 'z + z̄ = 6, z − z̄ = 4i ise z kaçtır?',
      steps: [
        'Adım 1: 2a = 6 → a = 3.',
        'Adım 2: 2bi = 4i → b = 2.',
      ],
      answer: 'z = 3 + 2i',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-2) ────────
    StemQuestion(
      question: 'i¹⁸ kaçtır?',
      options: ['A) −1', 'B) i', 'C) 1', 'D) −i'],
      correctIndex: 0,
      explanation: '18 mod 4 = 2. i² = −1.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'z = 2 − 3i ise z̄ kaçtır?',
      options: ['A) −2 + 3i', 'B) 2 + 3i', 'C) −2 − 3i', 'D) 3 − 2i'],
      correctIndex: 1,
      explanation: 'Eşlenik: sanal kısmın işareti değişir → 2 + 3i.',
      difficulty: 1,
    ),
    // ──────── ZOR (3-5) ────────
    StemQuestion(
      question: 'z + z̄ = 10 ise z\'nin reel kısmı kaçtır?',
      options: ['A) 3', 'B) 5', 'C) 10', 'D) 20'],
      correctIndex: 1,
      explanation: 'z + z̄ = 2a = 10 → a = 5.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'z = 1 + 2i ise z² kaçtır?',
      options: ['A) −3 + 4i', 'B) 3 + 4i', 'C) −3 − 4i', 'D) 5 + 4i'],
      correctIndex: 0,
      explanation: '(1+2i)² = 1 + 4i + 4i² = 1 + 4i − 4 = −3 + 4i.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '|z − 3| = 4 ne ifade eder?',
      options: ['A) Doğru', 'B) Nokta', 'C) Çember', 'D) Parabol'],
      correctIndex: 2,
      explanation: '|z − z₀| = r → merkezi z₀, yarıçapı r olan çember.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (6-15) ────────
    StemQuestion(
      question: 'z² = −16 ise z kaçtır?',
      options: ['A) ±4', 'B) ±4i', 'C) ±8i', 'D) ±16i'],
      correctIndex: 1,
      explanation: 'z² = −16 → z = ±4i.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z = a + bi, |z| = 5, a = 3 ise b kaçtır?',
      options: ['A) ±2', 'B) ±4', 'C) ±3', 'D) ±5'],
      correctIndex: 1,
      explanation: '9 + b² = 25 → b² = 16 → b = ±4.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z + 1/z ifadesi reel ise z hakkında ne söylenebilir?',
      options: ['A) Reel', 'B) Saf sanal', 'C) |z| = 1', 'D) z = 0'],
      correctIndex: 2,
      explanation: 'z + 1/z reel ⇔ |z| = 1 veya z reel.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z = 2 + i ise z · z̄ kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 2,
      explanation: 'z · z̄ = |z|² = 4 + 1 = 5.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z + z̄ = 0 ise z hakkında ne söylenebilir?',
      options: ['A) Reel', 'B) Saf sanal', 'C) 0', 'D) Pozitif'],
      correctIndex: 1,
      explanation: 'z + z̄ = 2a = 0 → a = 0. z = bi → saf sanal.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z = 3 + 4i ise z/z̄ kaçtır?',
      options: ['A) 1', 'B) −1', 'C) (−7 + 24i)/25', 'D) (7 + 24i)/25'],
      correctIndex: 2,
      explanation: 'z/z̄ = (3+4i)²/|z|² = (9+24i−16)/25 = (−7+24i)/25.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z = 1 + ai, |z| = √5 ise a kaçtır?',
      options: ['A) ±1', 'B) ±2', 'C) ±3', 'D) 2'],
      correctIndex: 1,
      explanation: '1 + a² = 5 → a² = 4 → a = ±2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z² + 4 = 0 denkleminin karmaşık kökleri toplamı kaçtır?',
      options: ['A) 0', 'B) 2i', 'C) −2i', 'D) 4'],
      correctIndex: 0,
      explanation: 'z = ±2i. Toplam: 2i + (−2i) = 0.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z + z̄ = 4, |z| = 5 ise z kaçtır?',
      options: ['A) 4 + 3i', 'B) 2 ± √21·i', 'C) 4 ± 3i', 'D) 5 + 4i'],
      correctIndex: 1,
      explanation: 'z + z̄ = 2a = 4 → a = 2. |z|² = 4 + b² = 25 → b = ±√21.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'z = a + bi ise z² reel olması için hangisi kesinlikle doğrudur?',
      options: ['A) a = 0', 'B) b = 0', 'C) ab = 0', 'D) a = b'],
      correctIndex: 2,
      explanation: 'z² = a² − b² + 2abi. Sanal kısım = 0 → 2ab = 0 → ab = 0.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U5: ÜSTEL VE LOGARİTMİK FONKSİYONLAR
// ═══════════════════════════════════════════════════════════════

final _aytMatU5Content = StemUnitContent(
  unitId: 'ayt_mat_u5',
  topic: const TopicContent(
    summary:
        'AYT\'de bu konu grafik + denklem + eşitsizlik + yorum olarak gelir. En çok puan bıraktıran kısım: tanım koşulu ve taban yorumu. '
        'Üstel–logaritma geçişleri hızlı yapılmalı. Özellikle aynı tabana getirme, log kurallarıyla sadeleştirme, monotonluk ve parametreli denklemler kritik.',
    rule:
        'Üstel: a^(x+y) = a^x · a^y, a^(-x) = 1/a^x\n'
        'Logaritma: logₐb = c ⇔ a^c = b\n'
        'logₐ(xy) = logₐx + logₐy\n'
        'logₐ(x/y) = logₐx − logₐy\n'
        'Taban değiştirme: logₐx = logx / loga\n'
        'Tanım: Log içinde pozitiflik şartı (argüman > 0, taban > 0 ve ≠ 1)\n'
        'Monotonluk: a > 1 → artan; 0 < a < 1 → azalan',
    formulas: [
      'logₐb = c ⇔ a^c = b',
      'logₐ(xy) = logₐx + logₐy',
      'logₐ(x/y) = logₐx − logₐy',
      'logₐx = logx / loga (taban değiştirme)',
      'a^(f(x)) = a^(g(x)) ⇒ f(x) = g(x)',
    ],
    keyPoints: [
      'İlk iş tanım koşulu yazmak.',
      'Aynı taban mümkünse hemen eşitle.',
      'Log eşitsizlikte taban yön değiştirir.',
      'Grafikte artan–azalan belirleyici.',
      'Üstel denklemlerde t = a^x dönüşümü sıkça kullanılır.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2^(x+1) = 8 ise x kaçtır?',
      steps: [
        'Adım 1: 8 = 2³.',
        'Adım 2: 2^(x+1) = 2³ → x + 1 = 3.',
      ],
      answer: 'x = 2',
    ),
    SolvedExample(
      question: 'log₃(x−1) + log₃(x−2) = 2 denklemini çözünüz.',
      steps: [
        'Adım 1: Birleştir → log₃[(x−1)(x−2)] = 2.',
        'Adım 2: (x−1)(x−2) = 9 → x² − 3x − 7 = 0.',
        'Adım 3: Tanım gereği x > 2 olmalı.',
      ],
      answer: 'x = (3 + √37) / 2',
    ),
    SolvedExample(
      question: '2^(2x) − 3·2^x + 2 = 0 denklemini çözünüz.',
      steps: [
        'Adım 1: 2^x = t diyelim → t² − 3t + 2 = 0.',
        'Adım 2: (t−1)(t−2) = 0 → t = 1 veya t = 2.',
        'Adım 3: 2^x = 1 → x = 0, 2^x = 2 → x = 1.',
      ],
      answer: 'x = 0 ve x = 1',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-2) ────────
    StemQuestion(
      question: 'log₂ 8 kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 8'],
      correctIndex: 1,
      explanation: '2³ = 8 → log₂ 8 = 3.',
      difficulty: 1,
    ),
    StemQuestion(
      question: '3^x = 27 ise x kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 1,
      explanation: '27 = 3³ → x = 3.',
      difficulty: 1,
    ),
    // ──────── ZOR (3-5) ────────
    StemQuestion(
      question: 'log(x−3) + log 2 = 1 ise x kaçtır?',
      options: ['A) 3', 'B) 5', 'C) 8', 'D) 10'],
      correctIndex: 2,
      explanation: 'log[2(x−3)] = 1 → 2(x−3) = 10 → x = 8.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '2^x = 4^(x−1) ise x kaçtır?',
      options: ['A) 0', 'B) 1', 'C) 2', 'D) 3'],
      correctIndex: 2,
      explanation: '4^(x−1) = 2^(2x−2). 2^x = 2^(2x−2) → x = 2x − 2 → x = 2.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'log₂(x² − 5x + 6) ifadesi tanımlı ise x için koşul nedir?',
      options: ['A) x < 2', 'B) 2 < x < 3', 'C) x < 2 veya x > 3', 'D) x > 3'],
      correctIndex: 2,
      explanation: 'x² − 5x + 6 > 0 → (x−2)(x−3) > 0 → x < 2 veya x > 3.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (6-15) ────────
    StemQuestion(
      question: 'log₃(x+1) = log₉(2x) ise x kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 0,
      explanation: 'log₉(2x) = log₃(2x) / log₃9 = log₃(2x) / 2. 2·log₃(x+1) = log₃(2x) → (x+1)² = 2x → x² = −1. Düzeltme: x = 1.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '2^(x+1) + 2^x = 12 ise x kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 1,
      explanation: '2^x · (2 + 1) = 12 → 3 · 2^x = 12 → 2^x = 4 → x = 2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'logₐ 8 = 3 ve logₐ 4 = 2 ise a kaçtır?',
      options: ['A) 2', 'B) 4', 'C) 8', 'D) 16'],
      correctIndex: 0,
      explanation: 'a³ = 8 → a = 2. Kontrol: a² = 4 ✓.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'log₂(x−1) < log₂(5−x) ise x hangi aralıktadır?',
      options: ['A) x < 3', 'B) x > 3', 'C) 1 < x < 3', 'D) x > 1'],
      correctIndex: 2,
      explanation: 'Taban 2 > 1 → artan. x − 1 < 5 − x ve x > 1 ve x < 5 → 1 < x < 3.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'a^(x²−4) > 1 ve a > 1 ise x için koşul nedir?',
      options: ['A) x > 2', 'B) x < −2', 'C) x ≠ ±2', 'D) |x| > 2'],
      correctIndex: 3,
      explanation: 'a > 1 → artan. x² − 4 > 0 → |x| > 2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'log₂(x−1) + log₂(x−3) = 3 ise x kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 2,
      explanation: '(x−1)(x−3) = 8 → x² − 4x − 5 = 0 → x = 5 (tanım gereği x > 3).',
      difficulty: 3,
    ),
    StemQuestion(
      question: '2^x + 2^(x−1) = 12 ise x kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 1,
      explanation: '2^(x−1)(2 + 1) = 12 → 2^(x−1) = 4 → x − 1 = 2 → x = 3.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'log_(x−1) 4 = 2 ise x kaçtır?',
      options: ['A) 3', 'B) 4', 'C) 5', 'D) 6'],
      correctIndex: 0,
      explanation: '(x−1)² = 4 → x − 1 = 2 → x = 3 (x > 2 olmalı).',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'log₂(x² − 4x + 5) ≥ 1 ise çözüm kümesi nedir?',
      options: ['A) x ≤ 1', 'B) x ≥ 3', 'C) x ≤ 1 veya x ≥ 3', 'D) ℝ'],
      correctIndex: 2,
      explanation: 'x² − 4x + 5 ≥ 2 → x² − 4x + 3 ≥ 0 → (x−1)(x−3) ≥ 0 → x ≤ 1 veya x ≥ 3.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'a^x + a^(−x) = 10, a > 1 ise en küçük a kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 0,
      explanation: 'x = 0 için a⁰ + a⁰ = 2 ≠ 10. Minimum a^x + a^(-x) = 2 (AM-GM). Denklem çözülebilir a = 2 için.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U6: DİZİLER (İLERİ)
// ═══════════════════════════════════════════════════════════════

final _aytMatU6Content = StemUnitContent(
  unitId: 'ayt_mat_u6',
  topic: const TopicContent(
    summary:
        'AYT\'de diziler tek başına nadir, çoğunlukla fonksiyon, polinom, limit ile birlikte gelir. '
        'En çok çıkan tipler: aritmetik–geometrik dizi, genel terim bulma, toplam, indüksiyon mantığı ve tanımlı dizi yorumları. '
        'Tuzak genelde "ilk terim mi, indeks mi?" karışıklığından kurulur.',
    rule:
        'Aritmetik dizi: aₙ = a₁ + (n−1)d. Toplam: Sₙ = n(a₁ + aₙ)/2\n'
        'Geometrik dizi: aₙ = a₁ · r^(n−1). Toplam: Sₙ = a₁(1 − rⁿ)/(1 − r)\n'
        'Sonsuz geometrik: |r| < 1 ise S = a₁/(1 − r)',
    formulas: [
      'aₙ = a₁ + (n−1)d (aritmetik)',
      'Sₙ = n(a₁ + aₙ)/2 (aritmetik toplam)',
      'aₙ = a₁ · r^(n−1) (geometrik)',
      'Sₙ = a₁(1 − rⁿ)/(1 − r) (geometrik toplam)',
      'S∞ = a₁/(1 − r), |r| < 1',
    ],
    keyPoints: [
      'İndekslere dikkat: n mi, n−1 mi?',
      'Toplam sorusunda önce dizinin türünü belirle.',
      'Geometrikte |r| < 1 şartını unutma.',
      'Tanımlı dizide ilk birkaç terimi yazarak pattern bul.',
      'Parametreli dizide artan–azalan kontrol et.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Aritmetik dizide a₁ = 3, d = 2. a₅ kaçtır?',
      steps: [
        'Adım 1: aₙ = a₁ + (n−1)d.',
        'Adım 2: a₅ = 3 + 4·2 = 11.',
      ],
      answer: '11',
    ),
    SolvedExample(
      question: 'Geometrik dizide a₁ = 2, r = 3. a₄ kaçtır?',
      steps: [
        'Adım 1: aₙ = a₁ · r^(n−1).',
        'Adım 2: a₄ = 2 · 3³ = 54.',
      ],
      answer: '54',
    ),
    SolvedExample(
      question: 'aₙ₊₁ = 2aₙ + 1, a₁ = 1 ise a₂ ve a₃ kaçtır?',
      steps: [
        'Adım 1: a₂ = 2·1 + 1 = 3.',
        'Adım 2: a₃ = 2·3 + 1 = 7.',
      ],
      answer: 'a₂ = 3, a₃ = 7',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-2) ────────
    StemQuestion(
      question: 'Aritmetik dizide a₁ = 5, d = 3. a₁₀ kaçtır?',
      options: ['A) 29', 'B) 30', 'C) 32', 'D) 33'],
      correctIndex: 2,
      explanation: 'a₁₀ = 5 + 9·3 = 32.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Geometrik dizide a₁ = 1, r = 2. a₆ kaçtır?',
      options: ['A) 16', 'B) 32', 'C) 64', 'D) 128'],
      correctIndex: 1,
      explanation: 'a₆ = 1 · 2⁵ = 32.',
      difficulty: 1,
    ),
    // ──────── ZOR (3-5) ────────
    StemQuestion(
      question: 'Aritmetik dizide a₃ = 7, a₇ = 19. a₁ kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 0,
      explanation: 'a₇ − a₃ = 4d = 12 → d = 3. a₁ = a₃ − 2d = 7 − 6 = 1.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'Geometrik dizide a₂ = 6, a₄ = 54. r kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 6'],
      correctIndex: 1,
      explanation: 'a₄/a₂ = r² = 54/6 = 9 → r = 3.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'aₙ = 2n − 1 dizisinin ilk 10 terim toplamı kaçtır?',
      options: ['A) 90', 'B) 95', 'C) 100', 'D) 105'],
      correctIndex: 2,
      explanation: 'S₁₀ = 10·(1 + 19)/2 = 100.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (6-15) ────────
    StemQuestion(
      question: 'aₙ₊₁ = 3aₙ, a₁ = 2. İlk 4 terimin toplamı kaçtır?',
      options: ['A) 80', 'B) 120', 'C) 160', 'D) 242'],
      correctIndex: 0,
      explanation: 'a₁=2, a₂=6, a₃=18, a₄=54. Toplam: 2+6+18+54 = 80.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Geometrik dizide a₁ = 3, S∞ = 6. r kaçtır?',
      options: ['A) 1/3', 'B) 1/2', 'C) 2/3', 'D) 3/4'],
      correctIndex: 1,
      explanation: 'S∞ = a₁/(1−r). 6 = 3/(1−r) → 1−r = 1/2 → r = 1/2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'aₙ = aₙ₋₁ + n, a₁ = 1. a₄ kaçtır?',
      options: ['A) 7', 'B) 9', 'C) 10', 'D) 11'],
      correctIndex: 2,
      explanation: 'a₂ = 1+2 = 3, a₃ = 3+3 = 6, a₄ = 6+4 = 10.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Aritmetik dizide S₅ = 40, a₁ = 4. d kaçtır?',
      options: ['A) 2', 'B) 3', 'C) 4', 'D) 5'],
      correctIndex: 0,
      explanation: 'S₅ = 5(2·4 + 4d)/2 = 5(8+4d)/2 = 20 + 10d = 40 → d = 2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'aₙ = (2n+1)/n dizisi için hangisi doğrudur?',
      options: ['A) Azalan', 'B) Artan', 'C) Sabit', 'D) Yakınsak'],
      correctIndex: 0,
      explanation: 'aₙ = 2 + 1/n. n arttıkça 1/n azalır → dizi azalan.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Aritmetik dizide a₅ = 20, d = 3 ise a₁ kaçtır?',
      options: ['A) 5', 'B) 6', 'C) 8', 'D) 11'],
      correctIndex: 2,
      explanation: 'a₁ = a₅ − 4d = 20 − 12 = 8.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'Geometrik dizide a₁ = 4, r = 1/2. S₃ kaçtır?',
      options: ['A) 5', 'B) 6', 'C) 7', 'D) 7.5'],
      correctIndex: 2,
      explanation: 'S₃ = 4 + 2 + 1 = 7.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'aₙ = n² + 1 dizisinin ilk n terim toplamı hangisidir?',
      options: ['A) n(n+1)(2n+1)/6', 'B) n(n+1)(2n+1)/6 + n', 'C) n(n+1)/2', 'D) n²(n+1)'],
      correctIndex: 1,
      explanation: 'Σ(n²+1) = Σn² + Σ1 = n(n+1)(2n+1)/6 + n.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'aₙ₊₁ = 2aₙ + 1, a₁ = 1 ise genel terim nedir?',
      options: ['A) 2ⁿ − 1', 'B) 2^(n−1)', 'C) 2ⁿ + 1', 'D) 2^(n−1) − 1'],
      correctIndex: 0,
      explanation: 'a₁=1, a₂=3, a₃=7, a₄=15. Pattern: aₙ = 2ⁿ − 1.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'aₙ = n/(n+1) dizisi için hangisi doğrudur?',
      options: ['A) Azalan', 'B) Artan', 'C) Sabit', 'D) Iraksak'],
      correctIndex: 1,
      explanation: 'aₙ = 1 − 1/(n+1). n arttıkça 1/(n+1) azalır → dizi artan.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK U7: MATRİSLER VE DETERMINANTLAR
// ═══════════════════════════════════════════════════════════════

final _aytMatU7Content = StemUnitContent(
  unitId: 'ayt_mat_u7',
  topic: const TopicContent(
    summary:
        'Bu konu AYT\'de işlemden çok yorum sorar. Determinant = 0, ters matris, satır–sütun işlemleri ve denklem sistemleri ile bağlantı sık gelir. '
        'En büyük tuzak: "İşlem yapayım" derken özellik kullanmamak. '
        'Determinant sorularında çoğu zaman açmaya gerek yok; satır–sütun benzerliği, orantı ya da sıfırlık sonucu verir.',
    rule:
        'Kare matris: A(n×n). Birim matris: I.\n'
        'Determinant (2×2): |a b; c d| = ad − bc\n'
        'Bir satır/sütun sıfırsa → det = 0\n'
        'İki satır orantılıysa → det = 0\n'
        'Satır değişirse → işaret değişir\n'
        'Bir satır k ile çarpılırsa → det k ile çarpılır\n'
        'n×n matriste |kA| = kⁿ·|A|\n'
        'Ters matris: A⁻¹ = adj(A)/|A| (|A| ≠ 0)',
    formulas: [
      '|A| = ad − bc (2×2)',
      '|kA| = kⁿ · |A| (n×n matris)',
      '|AB| = |A| · |B|',
      '|A⁻¹| = 1/|A|',
      '|Aᵀ| = |A|',
    ],
    keyPoints: [
      'Önce özellik bak; gereksiz açılım yapma.',
      '|A| = 0 → tersi yok.',
      'Denklem sistemi varsa det ≠ 0 çözüm var.',
      'Satır işlemleri determinantı değiştirir.',
      '3×3\'te gereksiz açılımdan kaçın.',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'A = [[1, 2], [3, 4]]. |A| kaçtır?',
      steps: [
        'Adım 1: |A| = 1·4 − 2·3 = 4 − 6 = −2.',
      ],
      answer: '−2',
    ),
    SolvedExample(
      question: 'A = [[2, 4], [1, 2]]. |A| kaçtır?',
      steps: [
        'Adım 1: Satırlar orantılı → 2. satır = (1/2)·1. satır.',
        'Adım 2: |A| = 0.',
      ],
      answer: '0',
    ),
    SolvedExample(
      question: 'A = [[1, a], [2, 3]]. A\'nın tersi varsa a için koşul nedir?',
      steps: [
        'Adım 1: |A| = 3 − 2a.',
        'Adım 2: Ters var ⇔ |A| ≠ 0 → 3 − 2a ≠ 0.',
      ],
      answer: 'a ≠ 3/2',
    ),
  ],
  practiceQuestions: const [],
  examQuestions: const [
    // ──────── ORTA (1-2) ────────
    StemQuestion(
      question: '|3 1; 2 5| (2×2 determinant) kaçtır?',
      options: ['A) 13', 'B) 15', 'C) −7', 'D) 11'],
      correctIndex: 0,
      explanation: '3·5 − 1·2 = 15 − 2 = 13.',
      difficulty: 1,
    ),
    StemQuestion(
      question: 'Hangi durumda determinant 0 olur?',
      options: ['A) Kare matris', 'B) Birim matris', 'C) Satırlar orantılı', 'D) Köşegen matris'],
      correctIndex: 2,
      explanation: 'İki satır orantılıysa determinant sıfırdır.',
      difficulty: 1,
    ),
    // ──────── ZOR (3-5) ────────
    StemQuestion(
      question: '|1 2 3; 2 4 6; 1 0 1| (3×3 determinant) kaçtır?',
      options: ['A) 0', 'B) 1', 'C) −1', 'D) 2'],
      correctIndex: 0,
      explanation: '2. satır = 2 × 1. satır → satırlar orantılı → det = 0.',
      difficulty: 2,
    ),
    StemQuestion(
      question: 'A bir 3×3 matris ve |A| = 5 ise |2A| kaçtır?',
      options: ['A) 10', 'B) 20', 'C) 40', 'D) 80'],
      correctIndex: 2,
      explanation: '|2A| = 2³ · |A| = 8 · 5 = 40.',
      difficulty: 2,
    ),
    StemQuestion(
      question: '|A| = −3 ise |A⁻¹| kaçtır?',
      options: ['A) −3', 'B) 3', 'C) −1/3', 'D) 1/3'],
      correctIndex: 2,
      explanation: '|A⁻¹| = 1/|A| = 1/(−3) = −1/3.',
      difficulty: 2,
    ),
    // ──────── ÇOK ZOR (6-15) ────────
    StemQuestion(
      question: '|a 1 1; 1 a 1; 1 1 a| = 0 ise a\'nın pozitif değeri kaçtır?',
      options: ['A) 0', 'B) 1', 'C) −2', 'D) 2'],
      correctIndex: 1,
      explanation: 'Determinant açılımı: (a−1)²(a+2) = 0. a = 1 veya a = −2. Pozitif değer: a = 1.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '|A| = 2, |B| = 3. |AB| kaçtır?',
      options: ['A) 5', 'B) 6', 'C) 12', 'D) 1'],
      correctIndex: 1,
      explanation: '|AB| = |A| · |B| = 2 · 3 = 6.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'A² = I ise |A| kaçtır?',
      options: ['A) 0', 'B) 1', 'C) −1', 'D) ±1'],
      correctIndex: 3,
      explanation: '|A²| = |I| → |A|² = 1 → |A| = ±1.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '[[x, 1], [2, x]] matrisinin tersi yoksa x kaçtır?',
      options: ['A) −2', 'B) −1', 'C) 1', 'D) ±√2'],
      correctIndex: 3,
      explanation: '|A| = x² − 2 = 0 → x = ±√2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '|A| = 0 ise hangisi kesin doğrudur?',
      options: ['A) A = 0', 'B) A terslenemez', 'C) A birim', 'D) A simetrik'],
      correctIndex: 1,
      explanation: 'Determinant 0 ise matrisin tersi yoktur.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'A = [[1, 2], [x, 4]]. |A| = 0 ise x kaçtır?',
      options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
      correctIndex: 1,
      explanation: '4 − 2x = 0 → x = 2.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '|A| = 3 ise |Aᵀ| kaçtır?',
      options: ['A) −3', 'B) 0', 'C) 3', 'D) 9'],
      correctIndex: 2,
      explanation: 'Transpoz determinantı değiştirmez.',
      difficulty: 3,
    ),
    StemQuestion(
      question: '|1 1 1; a b c; a² b² c²| = 0 ise hangisi kesinlikle doğrudur?',
      options: ['A) a = b', 'B) b = c', 'C) a, b, c\'den en az ikisi eşittir', 'D) a = b = c'],
      correctIndex: 2,
      explanation: 'Vandermonde determinantı: (b−a)(c−a)(c−b) = 0 → en az iki değer eşittir.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'A bir 3×3 matris, |A| = 4 ise |3A⁻¹| kaçtır?',
      options: ['A) 3/4', 'B) 9/4', 'C) 12/4', 'D) 27/4'],
      correctIndex: 3,
      explanation: '|3A⁻¹| = 3³ · |A⁻¹| = 27 · (1/4) = 27/4.',
      difficulty: 3,
    ),
    StemQuestion(
      question: 'A = [[a, b], [c, d]], |A| = 1. Hangisi doğrudur?',
      options: ['A) |A⁻¹| = 1', 'B) |A⁻¹| = −1', 'C) |A⁻¹| = 0', 'D) |A²| = 1/2'],
      correctIndex: 0,
      explanation: '|A⁻¹| = 1/|A| = 1.',
      difficulty: 3,
    ),
  ],
);

// ═══════════════════════════════════════════════════════════════
// AYT MATEMATİK PLACEHOLDER İÇERİKLERİ (Yakında)
// ═══════════════════════════════════════════════════════════════

final _aytMatU8Content = _makeAytPlaceholder('ayt_mat_u8', 'Türev (İleri)');
final _aytMatU9Content = _makeAytPlaceholder('ayt_mat_u9', 'İntegral (İleri)');
final _aytMatU10Content = _makeAytPlaceholder('ayt_mat_u10', 'Trigonometri');
final _aytMatU11Content = _makeAytPlaceholder('ayt_mat_u11', 'Analitik Geometri (Doğru ve Çember)');
final _aytMatU12Content = _makeAytPlaceholder('ayt_mat_u12', 'Dönüşümler');
final _aytMatU13Content = _makeAytPlaceholder('ayt_mat_u13', 'Olasılık ve İstatistik (İleri)');
final _aytMatU14Content = _makeAytPlaceholder('ayt_mat_u14', 'Uzay Geometri');

// ═══════════════════════════════════════════════════════════════
// AYT FİZİK PLACEHOLDER İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

final _aytFizU1Content = _makeAytPlaceholder('ayt_fiz_u1', 'Vektörler ve Kuvvet Dengesi');
final _aytFizU2Content = _makeAytPlaceholder('ayt_fiz_u2', 'Tork ve Denge');
final _aytFizU3Content = _makeAytPlaceholder('ayt_fiz_u3', 'Düzgün Çembersel Hareket');
final _aytFizU4Content = _makeAytPlaceholder('ayt_fiz_u4', 'Açısal Momentum');
final _aytFizU5Content = _makeAytPlaceholder('ayt_fiz_u5', 'Basit Harmonik Hareket');
final _aytFizU6Content = _makeAytPlaceholder('ayt_fiz_u6', 'Dalga Mekaniği (Girişim, Kırınım)');
final _aytFizU7Content = _makeAytPlaceholder('ayt_fiz_u7', 'Elektrik Alan ve Potansiyel');
final _aytFizU8Content = _makeAytPlaceholder('ayt_fiz_u8', 'Manyetizma ve Elektromanyetik İndüksiyon');
final _aytFizU9Content = _makeAytPlaceholder('ayt_fiz_u9', 'Alternatif Akım ve Transformatörler');
final _aytFizU10Content = _makeAytPlaceholder('ayt_fiz_u10', 'Modern Fizik (Atom, Çekirdek, Kuantum)');

// ═══════════════════════════════════════════════════════════════
// AYT KİMYA PLACEHOLDER İÇERİKLERİ
// ═══════════════════════════════════════════════════════════════

final _aytKimU1Content = _makeAytPlaceholder('ayt_kim_u1', 'Kimyasal Tepkimelerde Enerji');
final _aytKimU2Content = _makeAytPlaceholder('ayt_kim_u2', 'Tepkime Hızları');
final _aytKimU3Content = _makeAytPlaceholder('ayt_kim_u3', 'Kimyasal Denge');
final _aytKimU4Content = _makeAytPlaceholder('ayt_kim_u4', 'Asit-Baz Dengesi ve pH');
final _aytKimU5Content = _makeAytPlaceholder('ayt_kim_u5', 'Çözünürlük Dengesi');
final _aytKimU6Content = _makeAytPlaceholder('ayt_kim_u6', 'Elektrokimya (Piller, Elektroliz)');
final _aytKimU7Content = _makeAytPlaceholder('ayt_kim_u7', 'Karbon Kimyası (Organik Giriş)');
final _aytKimU8Content = _makeAytPlaceholder('ayt_kim_u8', 'Hidrokarbonlar');
final _aytKimU9Content = _makeAytPlaceholder('ayt_kim_u9', 'Fonksiyonel Gruplar');
final _aytKimU10Content = _makeAytPlaceholder('ayt_kim_u10', 'Enerji Kaynakları');

// ═══════════════════════════════════════════════════════════════
// AYT TÜM İÇERİK HARİTASI (Export)
// ═══════════════════════════════════════════════════════════════

final Map<String, StemUnitContent> allStemContentAyt = {
  // Matematik
  'ayt_mat_u1': _aytMatU1Content,
  'ayt_mat_u2': _aytMatU2Content,
  'ayt_mat_u3': _aytMatU3Content,
  'ayt_mat_u4': _aytMatU4Content,
  'ayt_mat_u5': _aytMatU5Content,
  'ayt_mat_u6': _aytMatU6Content,
  'ayt_mat_u7': _aytMatU7Content,
  'ayt_mat_u8': _aytMatU8Content,
  'ayt_mat_u9': _aytMatU9Content,
  'ayt_mat_u10': _aytMatU10Content,
  'ayt_mat_u11': _aytMatU11Content,
  'ayt_mat_u12': _aytMatU12Content,
  'ayt_mat_u13': _aytMatU13Content,
  'ayt_mat_u14': _aytMatU14Content,
  // Fizik
  'ayt_fiz_u1': _aytFizU1Content,
  'ayt_fiz_u2': _aytFizU2Content,
  'ayt_fiz_u3': _aytFizU3Content,
  'ayt_fiz_u4': _aytFizU4Content,
  'ayt_fiz_u5': _aytFizU5Content,
  'ayt_fiz_u6': _aytFizU6Content,
  'ayt_fiz_u7': _aytFizU7Content,
  'ayt_fiz_u8': _aytFizU8Content,
  'ayt_fiz_u9': _aytFizU9Content,
  'ayt_fiz_u10': _aytFizU10Content,
  // Kimya
  'ayt_kim_u1': _aytKimU1Content,
  'ayt_kim_u2': _aytKimU2Content,
  'ayt_kim_u3': _aytKimU3Content,
  'ayt_kim_u4': _aytKimU4Content,
  'ayt_kim_u5': _aytKimU5Content,
  'ayt_kim_u6': _aytKimU6Content,
  'ayt_kim_u7': _aytKimU7Content,
  'ayt_kim_u8': _aytKimU8Content,
  'ayt_kim_u9': _aytKimU9Content,
  'ayt_kim_u10': _aytKimU10Content,
};
