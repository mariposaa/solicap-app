// SOLICAP - STEM İçerik Veritabanı (12. Sınıf)
// 12. Sınıf Matematik + Fizik + Kimya

import '../models/stem_models.dart';

// ═══════════════════════════════════════════════════════════════
// 12. SINIF MATEMATİK ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif12MatUnits = [
  StemUnit(id: 's12_mat_u1', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 1, title: 'Üstel ve Logaritmik Fonksiyonlar', titleTr: 'Üstel ve Logaritmik Fonksiyonlar', icon: '📈'),
  StemUnit(id: 's12_mat_u2', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 2, title: 'Diziler', titleTr: 'Diziler', icon: '🔢'),
  StemUnit(id: 's12_mat_u3', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 3, title: 'Trigonometri (İleri)', titleTr: 'Trigonometri (İleri)', icon: '📐'),
  StemUnit(id: 's12_mat_u4', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 4, title: 'Dönüşümler', titleTr: 'Dönüşümler', icon: '🔄'),
  StemUnit(id: 's12_mat_u5', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 5, title: 'Türev', titleTr: 'Türev', icon: '📉'),
  StemUnit(id: 's12_mat_u6', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 6, title: 'İntegral', titleTr: 'İntegral', icon: '∫'),
  StemUnit(id: 's12_mat_u7', gradeLevel: GradeLevel.sinif12, subject: StemSubject.matematik, order: 7, title: 'Çemberin Analitik İncelenmesi', titleTr: 'Çemberin Analitik İncelenmesi', icon: '⭕'),
];

// ═══════════════════════════════════════════════════════════════
// 12. SINIF FİZİK ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif12FizUnits = [
  StemUnit(id: 's12_fiz_u1', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 1, title: 'Çembersel Hareket', titleTr: 'Çembersel Hareket', icon: '🔄'),
  StemUnit(id: 's12_fiz_u2', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 2, title: 'Dönerek Öteleme ve Açısal Momentum', titleTr: 'Dönerek Öteleme ve Açısal Momentum', icon: '🎡'),
  StemUnit(id: 's12_fiz_u3', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 3, title: 'Kütle Çekim ve Kepler Yasaları', titleTr: 'Kütle Çekim ve Kepler Yasaları', icon: '🌍'),
  StemUnit(id: 's12_fiz_u4', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 4, title: 'Basit Harmonik Hareket', titleTr: 'Basit Harmonik Hareket', icon: '〰️'),
  StemUnit(id: 's12_fiz_u5', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 5, title: 'Dalga Mekaniği', titleTr: 'Dalga Mekaniği', icon: '🌊'),
  StemUnit(id: 's12_fiz_u6', gradeLevel: GradeLevel.sinif12, subject: StemSubject.fizik, order: 6, title: 'Modern Fizik', titleTr: 'Modern Fizik', icon: '⚛️'),
];

// ═══════════════════════════════════════════════════════════════
// 12. SINIF KİMYA ÜNİTELERİ
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> sinif12KimUnits = [
  StemUnit(id: 's12_kim_u1', gradeLevel: GradeLevel.sinif12, subject: StemSubject.kimya, order: 1, title: 'Kimya ve Elektrik (Elektrokimya)', titleTr: 'Kimya ve Elektrik (Elektrokimya)', icon: '🔋'),
  StemUnit(id: 's12_kim_u2', gradeLevel: GradeLevel.sinif12, subject: StemSubject.kimya, order: 2, title: 'Karbon Kimyasına Giriş', titleTr: 'Karbon Kimyasına Giriş', icon: '⬡'),
  StemUnit(id: 's12_kim_u3', gradeLevel: GradeLevel.sinif12, subject: StemSubject.kimya, order: 3, title: 'Hidrokarbonlar', titleTr: 'Hidrokarbonlar', icon: '🛢️'),
  StemUnit(id: 's12_kim_u4', gradeLevel: GradeLevel.sinif12, subject: StemSubject.kimya, order: 4, title: 'Fonksiyonel Gruplar', titleTr: 'Fonksiyonel Gruplar', icon: '🧪'),
  StemUnit(id: 's12_kim_u5', gradeLevel: GradeLevel.sinif12, subject: StemSubject.kimya, order: 5, title: 'Enerji Kaynakları ve Bilimsel Gelişmeler', titleTr: 'Enerji Kaynakları ve Bilimsel Gelişmeler', icon: '⚡'),
];

// ═══════════════════════════════════════════════════════════════
// TÜM 12. SINIF İÇERİK HARİTASI
// ═══════════════════════════════════════════════════════════════

final Map<String, StemUnitContent> allStemContent12 = {
  's12_mat_u1': _s12MatU1Content,
  's12_mat_u2': _s12MatU2Content,
  's12_mat_u3': _s12MatU3Content,
  's12_mat_u4': _s12MatU4Content,
  's12_mat_u5': _s12MatU5Content,
  's12_mat_u6': _s12MatU6Content,
  's12_mat_u7': _s12MatU7Content,
  's12_fiz_u1': _s12FizU1Content,
  's12_fiz_u2': _s12FizU2Content,
  's12_fiz_u3': _s12FizU3Content,
  's12_fiz_u4': _s12FizU4Content,
  's12_fiz_u5': _s12FizU5Content,
  's12_fiz_u6': _s12FizU6Content,
  's12_kim_u1': _s12KimU1Content,
  's12_kim_u2': _s12KimU2Content,
  's12_kim_u3': _s12KimU3Content,
  's12_kim_u4': _s12KimU4Content,
  's12_kim_u5': _s12KimU5Content,
};

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 1: ÜSTEL VE LOGARİTMİK FONKSİYONLAR
// ═══════════════════════════════════════════════════════════════

final _s12MatU1Content = StemUnitContent(
  unitId: 's12_mat_u1',
  topic: const TopicContent(
    summary: 'Üstel Fonksiyon: a>0, a≠1 olmak üzere f(x)=aˣ biçimindeki fonksiyonlardır. a>1 ise artan, 0<a<1 ise azalandır. Logaritma Fonksiyonu: Üstel fonksiyonun tersidir. y=aˣ ⟺ x=log_a(y). Tanım kümesi: a>0, a≠1 ve iç kısım y>0 olmalıdır.',
    rule: 'log_a(1)=0, log_a(a)=1\nlog_a(x·y)=log_a(x)+log_a(y)\nlog_a(x/y)=log_a(x)-log_a(y)\nlog_a(xⁿ)=n·log_a(x)\nTaban Değiştirme: log_a(b)=log_c(b)/log_c(a)\naˡᵒᵍₐᵇ=b',
    formulas: [
      'f(x)=aˣ → a>1 artan, 0<a<1 azalan',
      'log_a(b)=log_c(b)/log_c(a)',
      'aᶠ⁽ˣ⁾=aᵍ⁽ˣ⁾ ⟹ f(x)=g(x)',
      'log_a(f(x))=b ⟹ f(x)=aᵇ',
    ],
    keyPoints: [
      'Üstel fonksiyon birebir ve örtendir',
      'Logaritma tanım kümesi: taban>0, taban≠1, iç kısım>0',
      'Üstel denklemlerde tabanları eşitle',
      'Logaritmik denklemlerde tanım kümesi kontrolü yap',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '3^(2x-1)=27 denklemini çözünüz.',
      steps: ['27=3³ olarak yazılır', '3^(2x-1)=3³ ⟹ 2x-1=3', '2x=4 ⟹ x=2'],
      answer: 'x=2',
    ),
    SolvedExample(
      question: 'log₂(x-3)=4 olduğuna göre x kaçtır?',
      steps: ['Logaritma tanımı: x-3=2⁴', 'x-3=16 ⟹ x=19', 'Tanım kümesi: 19-3>0 ✓'],
      answer: 'x=19',
    ),
    SolvedExample(
      question: 'log2≈0,301 olduğuna göre log200 kaçtır?',
      steps: ['log200=log(2·100)=log2+log100', 'log100=log10²=2', 'log200=0,301+2=2,301'],
      answer: '2,301',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'f(x)=2^(x+3) ise f(1) kaçtır?', options: ['8', '16', '32', '64'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'log₃(81) sonucu kaçtır?', options: ['3', '4', '5', '9'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'log₅(x)=2 ise x kaçtır?', options: ['10', '25', '32', '50'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'ln(e⁵) ifadesinin değeri nedir?', options: ['1', 'e', '5', '5e'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'log₂(16)+log₃(27) toplamı kaçtır?', options: ['5', '6', '7', '8'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '3ˣ=1/9 ise x kaçtır?', options: ['-3', '-2', '2', '3'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'log(1000) değeri kaçtır?', options: ['2', '3', '4', '10'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'log₂(x+1)=3 denkleminde x kaçtır?', options: ['3', '5', '7', '9'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'f(x)=log_x(5-x) fonksiyonunun tanımlı olması için x hangi aralıktadır?', options: ['(0,5)', '(1,5)', '(0,1)∪(1,5)', '(0,1)'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'log₃(5)·log₅(9) işleminin sonucu kaçtır?', options: ['1', '2', '3', '5'], correctIndex: 1, difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'f(x)=2^(x+3), f(1)=?', options: ['8', '16', '32', '64'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'log₃(81)=?', options: ['3', '4', '5', '9'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '3ˣ=1/9, x=?', options: ['-3', '-2', '2', '3'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'ln(e⁵)=?', options: ['1', 'e', '5', '5e'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'log(1000)=?', options: ['2', '3', '4', '10'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Bir bakteri kültürü her saat 3 katına çıkıyor. Başlangıçta 10 bakteri varsa kaçıncı saatte 270\'e ulaşır?', options: ['2', '3', '4', '5'], correctIndex: 1, explanation: '10·3ᵗ=270 ⟹ 3ᵗ=27 ⟹ t=3', difficulty: 2),
    StemQuestion(question: 'x^(log₃x)=9x denkleminin kökler çarpımı kaçtır?', options: ['1', '3', '9', '27'], correctIndex: 1, explanation: 'Her iki tarafın log₃ alınır. Kökler 9 ve 1/3, çarpım=3', difficulty: 3),
    StemQuestion(question: 'log₂(sinx)+log₂(cosx)=-1 in [0,π/2] çözüm kümesi?', options: ['π/6', 'π/4', 'π/3', 'π/2'], correctIndex: 1, explanation: 'log₂(sinx·cosx)=-1 ⟹ (1/2)sin2x=1/2 ⟹ x=π/4', difficulty: 3),
    StemQuestion(question: 'log₃(2x-1)<2 eşitsizliğinin çözüm aralığı?', options: ['(0,5)', '(1/2,5)', '(1,5)', '(1/2,9)'], correctIndex: 1, explanation: '0<2x-1<9 ⟹ 1/2<x<5', difficulty: 2),
    StemQuestion(question: 'f(x)=ln(x²-4x+4) fonksiyonunun en geniş tanım kümesi?', options: ['ℝ', 'ℝ-{2}', '(2,∞)', '(-∞,2)'], correctIndex: 1, explanation: '(x-2)²>0 olmalı, x≠2', difficulty: 2),
    StemQuestion(question: '√((log₂x)²-4log₂x+4)=0 denkleminin kökü kaçtır?', options: ['2', '4', '8', '16'], correctIndex: 1, explanation: '(log₂x-2)²=0 ⟹ log₂x=2 ⟹ x=4', difficulty: 2),
    StemQuestion(question: 'Yarılanma ömrü 10 yıl olan 100g maddeden 50 yıl sonra kaç gram kalır?', options: ['1.5625', '3.125', '6.25', '12.5'], correctIndex: 1, explanation: '100·(1/2)⁵=100/32=3.125', difficulty: 2),
    StemQuestion(question: 'log₂3=a ise log₁₂(18) ifadesinin a türünden eşiti?', options: ['(2a+1)/(a+2)', '(a+2)/(2a+1)', '2a/(a+1)', 'a/(a+2)'], correctIndex: 0, explanation: 'Taban değiştirme: log₂18/log₂12=(1+2a)/(2+a)', difficulty: 3),
    StemQuestion(question: 'e²ˣ-5eˣ+6=0 denkleminin kökleri toplamı?', options: ['ln2', 'ln3', 'ln5', 'ln6'], correctIndex: 3, explanation: 'u=eˣ: u=2,u=3 ⟹ x₁+x₂=ln2+ln3=ln6', difficulty: 3),
    StemQuestion(question: 'Şiddeti 8 olan deprem, şiddeti 6 olan depremden kaç kat daha fazla enerji açığa çıkarır? (R=log(I/I₀))', options: ['10', '100', '1000', '10000'], correctIndex: 1, explanation: '10⁸/10⁶=10²=100', difficulty: 2),
    StemQuestion(question: 'log_a(b)+log_b(a)=2 ise a ile b arasındaki bağıntı?', options: ['a=b', 'a=1/b', 'a·b=1', 'a+b=2'], correctIndex: 0, explanation: 't+1/t=2 ⟹ t=1 ⟹ log_a(b)=1 ⟹ a=b', difficulty: 2),
    StemQuestion(question: '2ˣ=5ʸ ise (x+y)/y ifadesinin eşiti?', options: ['1+log₂5', '1+log₅2', 'log₂5', 'log₅10'], correctIndex: 0, explanation: 'x=y·log₂5, (x+y)/y=log₂5+1', difficulty: 3),
    StemQuestion(question: 'Grafiği (2,0) ve (3,1) noktalarından geçen f(x)=log_a(x+b) için a·b kaçtır?', options: ['-4', '-2', '0', '2'], correctIndex: 1, explanation: 'f(2)=0: log_a(2+b)=0 ⟹ b=-1. f(3)=1: log_a(2)=1 ⟹ a=2. a·b=-2', difficulty: 3),
    StemQuestion(question: 'log₃(x)·log_x(x²)=log₃(x+6) ise x kaçtır?', options: ['1', '2', '3', '9'], correctIndex: 2, explanation: '2·log₃x=log₃(x+6) ⟹ x²=x+6 ⟹ x=3', difficulty: 3),
    StemQuestion(question: 'pH=-log[H⁺] ile hesaplanır. [H⁺]=10⁻⁴ olan çözeltinin pH değeri?', options: ['2', '3', '4', '5'], correctIndex: 2, explanation: '-log(10⁻⁴)=4', difficulty: 1),
  ],
  formulaCards: const [
    'f(x)=aˣ: a>1 artan, 0<a<1 azalan',
    'log_a(1)=0, log_a(a)=1',
    'log_a(x·y)=log_a(x)+log_a(y)',
    'Taban Değiştirme: log_a(b)=log_c(b)/log_c(a)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 2: DİZİLER
// ═══════════════════════════════════════════════════════════════

final _s12MatU2Content = StemUnitContent(
  unitId: 's12_mat_u2',
  topic: const TopicContent(
    summary: 'Dizi: Tanım kümesi sayma sayıları olan fonksiyondur. Aritmetik Dizi: Ardışık terimler arası fark sabit (d). Genel terim: aₙ=a₁+(n-1)d. Geometrik Dizi: Ardışık terimler arası oran sabit (r). Genel terim: aₙ=a₁·rⁿ⁻¹.',
    rule: 'Aritmetik: Sₙ=n/2·[a₁+aₙ] veya Sₙ=n/2·[2a₁+(n-1)d]\nGeometrik: Sₙ=a₁·(1-rⁿ)/(1-r)\nOrtanca terim: aₙ=(aₙ₋ₖ+aₙ₊ₖ)/2 (Aritmetik)\naₙ²=aₙ₋ₖ·aₙ₊ₖ (Geometrik)',
    formulas: [
      'aₙ=a₁+(n-1)d (Aritmetik genel terim)',
      'Sₙ=n/2·[a₁+aₙ] (Aritmetik toplam)',
      'aₙ=a₁·rⁿ⁻¹ (Geometrik genel terim)',
      'Sₙ=a₁·(1-rⁿ)/(1-r) (Geometrik toplam)',
    ],
    keyPoints: [
      'Aritmetik dizide orta terim = iki komşunun ortalaması',
      'Geometrik dizide orta terimin karesi = iki komşunun çarpımı',
      'Fibonacci: Her terim önceki ikisinin toplamı',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Genel terimi aₙ=3n-2 olan dizinin 5. terimi kaçtır?',
      steps: ['n=5 yazılır', 'a₅=3(5)-2=15-2=13'],
      answer: '13',
    ),
    SolvedExample(
      question: 'Aritmetik dizide a₃=7 ve a₇=19 ise ortak fark (d) kaçtır?',
      steps: ['a₇=a₃+4d', '19=7+4d', '12=4d ⟹ d=3'],
      answer: 'd=3',
    ),
    SolvedExample(
      question: 'a₁=2, r=3 olan geometrik dizinin ilk 4 terim toplamı?',
      steps: ['S₄=2·(1-3⁴)/(1-3)', '=2·(1-81)/(-2)', '=2·(-80)/(-2)=80'],
      answer: '80',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'aₙ=(2n+1)/(n+1) dizisinin 3. terimi?', options: ['5/4', '7/4', '9/4', '3/2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sabit dizi aₙ=(k-2)n+5 ise k kaçtır?', options: ['0', '1', '2', '3'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'a₁=5, d=4 ise a₁₀ kaçtır?', options: ['37', '39', '41', '45'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'a₁=3, r=2 olan geometrik dizide a₅ kaçtır?', options: ['24', '36', '48', '96'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '4, x, 36 geometrik dizi oluşturuyorsa x (pozitif) kaçtır?', options: ['8', '12', '16', '20'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '2, y, 10 aritmetik dizi ise y kaçtır?', options: ['4', '5', '6', '8'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Fibonacci dizisinin 6. terimi? (1,1,2,3...)', options: ['5', '8', '13', '21'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Σ(k=1→3)(2k+1) toplamı kaçtır?', options: ['12', '15', '18', '21'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'aₙ=(-1)ⁿ·n dizisinin 4. terimi?', options: ['-4', '-2', '2', '4'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Geometrik dizide a₂=6, a₃=12 ise r kaçtır?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'a₁=5, d=4, a₁₀=?', options: ['37', '39', '41', '45'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '4,x,36 geometrik, x=?', options: ['8', '12', '16', '20'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'a₂=6,a₃=12, r=?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fibonacci 6. terim?', options: ['5', '8', '13', '21'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '2,y,10 aritmetik, y=?', options: ['4', '5', '6', '8'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Tiyatroda ilk sıra 20 koltuk, her sıra 2 fazla. 10. sırada kaç koltuk?', options: ['34', '36', '38', '40'], correctIndex: 2, explanation: '20+9·2=38', difficulty: 2),
    StemQuestion(question: 'Bakteri her saat ikiye bölünüyor. Başlangıçta 1 ise 10. saat sonunda kaç olur?', options: ['512', '1024', '2048', '4096'], correctIndex: 1, explanation: '2¹⁰=1024', difficulty: 1),
    StemQuestion(question: 'Aritmetik dizide a₅+a₁₅=40 ise a₁₀ kaçtır?', options: ['10', '15', '20', '25'], correctIndex: 2, explanation: '2a₁₀=40 ⟹ a₁₀=20', difficulty: 2),
    StemQuestion(question: 'Hem aritmetik hem geometrik olan dizi nasıl bir dizidir?', options: ['Artan', 'Azalan', 'Sabit', 'Harmonik'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'x-2, x+1, x+5 geometrik dizinin ardışık üç terimi ise x kaçtır?', options: ['7', '9', '11', '13'], correctIndex: 2, explanation: '(x+1)²=(x-2)(x+5) ⟹ x=11', difficulty: 2),
    StemQuestion(question: '16m yükseklikten bırakılan top her seferinde 1/2 kadar zıplıyor. Toplam dikey yol?', options: ['32', '40', '48', '64'], correctIndex: 2, explanation: '16+2·(8+4+2+...)=16+32=48', difficulty: 3),
    StemQuestion(question: 'Sₙ=n²+3n olan aritmetik dizinin genel terimi?', options: ['2n+1', '2n+2', '2n+3', 'n+2'], correctIndex: 1, explanation: 'aₙ=Sₙ-Sₙ₋₁=2n+2', difficulty: 2),
    StemQuestion(question: '1/2, 1/4, 1/8... sonsuz toplamının değeri?', options: ['1/2', '3/4', '1', '2'], correctIndex: 2, explanation: 'a₁/(1-r)=(1/2)/(1/2)=1', difficulty: 2),
    StemQuestion(question: 'Aritmetik dizide a₇-a₃=12 ise ortak fark kaçtır?', options: ['2', '3', '4', '6'], correctIndex: 1, explanation: '4d=12 ⟹ d=3', difficulty: 1),
    StemQuestion(question: 'Bileşik faiz ile artan para hangi dizi modeline uyar?', options: ['Aritmetik', 'Geometrik', 'Harmonik', 'Fibonacci'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Geometrik dizi a₁·a₅=100 ise a₃ kaçtır?', options: ['5', '10', '20', '25'], correctIndex: 1, explanation: 'a₃²=a₁·a₅=100 ⟹ a₃=10', difficulty: 2),
    StemQuestion(question: '5 ile 160 arasına geometrik dizi oluşturacak 4 terim yerleştirilirse ortak çarpan?', options: ['2', '3', '4', '5'], correctIndex: 0, explanation: '5·r⁵=160 ⟹ r⁵=32 ⟹ r=2', difficulty: 2),
    StemQuestion(question: 'aₙ=log₂(1+1/n) dizisinin ilk 15 terim toplamı?', options: ['2', '3', '4', '5'], correctIndex: 2, explanation: 'Teleskopik: log₂(16/1)=log₂16=4', difficulty: 3),
    StemQuestion(question: 'Üçgen sayı dizisinin 5. terimi? (n(n+1)/2)', options: ['10', '15', '21', '28'], correctIndex: 1, explanation: '5·6/2=15', difficulty: 1),
    StemQuestion(question: '3. koltuk no 15, 8. koltuk no 35 ise 1. koltuk no?', options: ['5', '7', '9', '11'], correctIndex: 1, explanation: '5d=20 ⟹ d=4, a₁=15-8=7', difficulty: 2),
  ],
  formulaCards: const [
    'Aritmetik: aₙ=a₁+(n-1)d',
    'Aritmetik Toplam: Sₙ=n/2·[a₁+aₙ]',
    'Geometrik: aₙ=a₁·rⁿ⁻¹',
    'Sonsuz Geometrik: S∞=a₁/(1-r), |r|<1',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 3: TRİGONOMETRİ (İLERİ)
// ═══════════════════════════════════════════════════════════════

final _s12MatU3Content = StemUnitContent(
  unitId: 's12_mat_u3',
  topic: const TopicContent(
    summary: 'Toplam-Fark: sin(a±b)=sin(a)cos(b)±cos(a)sin(b). cos(a±b)=cos(a)cos(b)∓sin(a)sin(b). İki Kat Açı: sin2x=2sinx·cosx, cos2x=cos²x-sin²x=2cos²x-1=1-2sin²x.',
    rule: 'sin(a±b)=sinacosb±cosasinb\ncos(a±b)=cosacosb∓sinasinb\ntan(a±b)=(tana±tanb)/(1∓tanatanb)\nsin2x=2sinxcosx\ncos2x=cos²x-sin²x',
    formulas: [
      'sin(a±b)=sinacosb±cosasinb',
      'cos(a±b)=cosacosb∓sinasinb',
      'sin2x=2sinxcosx',
      'cos2x=2cos²x-1=1-2sin²x',
    ],
    keyPoints: [
      'sinx=sinα ⟹ x=α+2kπ veya x=(π-α)+2kπ',
      'cosx=cosα ⟹ x=±α+2kπ',
      'Yarım açı formüllerini iki kat açıdan türet',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'sin15° değerini bulunuz.',
      steps: ['sin(45°-30°)=sin45·cos30-cos45·sin30', '=(√2/2)·(√3/2)-(√2/2)·(1/2)', '=(√6-√2)/4'],
      answer: '(√6-√2)/4',
    ),
    SolvedExample(
      question: 'sin2x/cosx ifadesini sadeleştiriniz.',
      steps: ['sin2x=2sinx·cosx', '2sinx·cosx/cosx=2sinx'],
      answer: '2sinx',
    ),
    SolvedExample(
      question: 'tanx=1 denkleminin [0,2π) çözümleri?',
      steps: ['tan 1. ve 3. bölgede pozitif', 'x=π/4 ve x=5π/4'],
      answer: 'x=π/4, x=5π/4',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'sin75° açılımında hangi iki açı kullanılır?', options: ['30+45', '60+15', '90-15', 'Hepsi'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: '2sin15°cos15° neye eşittir?', options: ['sin30°=1/2', 'cos30°', 'sin15°', '1'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'cos²15°-sin²15° neye eşittir?', options: ['1/2', '√3/2', '√2/2', '1'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'tan(45°+30°) formülü nedir?', options: ['(1+tan30)/(1-tan30)', 'tan45+tan30', 'tan75', 'A ve C'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'sin2x=1/2 ise en küçük pozitif x açısı kaç derecedir?', options: ['15', '30', '45', '60'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'cos2x-1 ifadesinin sinx cinsinden eşiti?', options: ['-2sin²x', '2sin²x', '-2cos²x', '2cos²x'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'sin(x+y) açılımındaki işaret nedir?', options: ['+', '-', '±', '∓'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'tan2x formülünde paydada ne vardır?', options: ['1+tan²x', '1-tan²x', '2tanx', 'cos2x'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'sinx=0 ise x hangi değerleri alır?', options: ['kπ', 'kπ/2', '2kπ', 'π/2+kπ'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'cos(60°-x) açılımı?', options: ['cos60cosx+sin60sinx', 'cos60cosx-sin60sinx', 'sin60cosx+cos60sinx', 'sin60cosx-cos60sinx'], correctIndex: 0, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '2sin15cos15=?', options: ['1/2', '√3/2', '√2/2', '1'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'cos²15-sin²15=?', options: ['1/2', '√3/2', '√2/2', '1'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'sin2x=1/2, x_min=?', options: ['15°', '30°', '45°', '60°'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'sinx=0, x=?', options: ['kπ', 'kπ/2', '2kπ', 'π/2+kπ'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'cos2x-1=?', options: ['-2sin²x', '2sin²x', '-2cos²x', '2cos²x'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'ABC üçgeninde tanA=2, tanB=3 ise tanC kaçtır?', options: ['-1', '0', '1', '5'], correctIndex: 2, explanation: 'tan(A+B)=5/(-5)=-1. tanC=-tan(A+B)=1', difficulty: 3),
    StemQuestion(question: 'sin3x/sinx - cos3x/cosx ifadesinin en sade hali?', options: ['1', '2', '3', '4'], correctIndex: 1, explanation: 'sin(3x-x)/(sinxcosx)=sin2x/(sinxcosx)=2', difficulty: 3),
    StemQuestion(question: '0<x<π/2 ve tanx=3/4 ise sin2x kaçtır?', options: ['12/25', '24/25', '7/25', '3/5'], correctIndex: 1, explanation: 'sinx=3/5, cosx=4/5, sin2x=2·(3/5)·(4/5)=24/25', difficulty: 2),
    StemQuestion(question: '4cos²x-3=0 denkleminin [0,π] çözümleri?', options: ['π/6, 5π/6', 'π/3, 2π/3', 'π/4, 3π/4', 'π/6, π/3'], correctIndex: 0, explanation: 'cosx=±√3/2 ⟹ x=π/6, 5π/6', difficulty: 2),
    StemQuestion(question: 'arctan(1/2)+arctan(1/3) toplamı kaç derecedir?', options: ['30', '45', '60', '90'], correctIndex: 1, explanation: 'tan(α+β)=(5/6)/(5/6)=1 ⟹ 45°', difficulty: 2),
    StemQuestion(question: 'cos80°·cos40°·cos20° çarpımının sonucu?', options: ['1/4', '1/8', '1/16', '√3/8'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'x²-(sinα)x+cos2α=0 denkleminin kökler toplamı?', options: ['sinα', 'cosα', 'sin2α', '1'], correctIndex: 0, explanation: 'Vieta: kökler toplamı=sinα', difficulty: 2),
    StemQuestion(question: 'sinx+√3cosx=2 denkleminin çözüm kümesi?', options: ['π/6', 'π/4', 'π/3', 'π/2'], correctIndex: 0, explanation: '2sin(x+60°)=2 ⟹ sin(x+60°)=1 ⟹ x=π/6', difficulty: 3),
    StemQuestion(question: 'sin105° değeri kaçtır?', options: ['(√6-√2)/4', '(√6+√2)/4', '(√3+1)/4', '(√3-1)/4'], correctIndex: 1, explanation: 'sin(60+45)=(√6+√2)/4', difficulty: 2),
    StemQuestion(question: '(1-cos2x)/sin2x ifadesinin eşiti?', options: ['sinx', 'cosx', 'tanx', 'cotx'], correctIndex: 2, explanation: '2sin²x/(2sinxcosx)=tanx', difficulty: 2),
    StemQuestion(question: 'sin(2·arcsin(3/5)) değeri kaçtır?', options: ['12/25', '24/25', '7/25', '4/5'], correctIndex: 1, explanation: 'sinα=3/5,cosα=4/5, sin2α=24/25', difficulty: 2),
    StemQuestion(question: '5sinx+12cosx ifadesinin alabileceği en büyük değer?', options: ['12', '13', '17', '60'], correctIndex: 1, explanation: '√(25+144)=√169=13', difficulty: 2),
    StemQuestion(question: 'cos2x+3sinx-2=0 denkleminde sinx değerleri?', options: ['1/2 ve 1', '1/3 ve 1', '1/2 ve -1', '-1/2 ve 1'], correctIndex: 0, explanation: '2sin²x-3sinx+1=0 ⟹ sinx=1/2, sinx=1', difficulty: 2),
    StemQuestion(question: 'Bir kulenin gölgesi güneş açısı θ ile değişir. tan formülü hangi konuda kullanılır?', options: ['Uzunluk hesabı', 'Açı farkı problemi', 'Alan hesabı', 'Hız hesabı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'tan2x=2tanx/(1-tan²x) formülü hangi durumda tanımsızdır?', options: ['tanx=0', 'tanx=±1', 'tanx=2', 'tanx=1/2'], correctIndex: 1, explanation: '1-tan²x=0 ⟹ tanx=±1', difficulty: 2),
  ],
  formulaCards: const [
    'sin(a±b)=sinacosb±cosasinb',
    'cos(a±b)=cosacosb∓sinasinb',
    'sin2x=2sinxcosx',
    'cos2x=cos²x-sin²x=2cos²x-1=1-2sin²x',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 4: DÖNÜŞÜMLER
// ═══════════════════════════════════════════════════════════════

final _s12MatU4Content = StemUnitContent(
  unitId: 's12_mat_u4',
  topic: const TopicContent(
    summary: 'Öteleme: (x,y) noktası (x+a,y+b) olur. Simetri: x eksenine (x,-y), y eksenine (-x,y), orijine (-x,-y), y=x doğrusuna (y,x). Dönme: P\'=(xcosα-ysinα, xsinα+ycosα).',
    rule: 'x eksenine göre: (x,-y)\ny eksenine göre: (-x,y)\nOrijine göre: (-x,-y)\ny=x doğrusuna göre: (y,x)\nx=a doğrusuna göre: (2a-x,y)',
    formulas: [
      'Öteleme: (x+a, y+b)',
      'Dönme: (xcosα-ysinα, xsinα+ycosα)',
      'y=x simetrisi: (y,x)',
    ],
    keyPoints: [
      'Dönme dönüşümü uzunluğu ve alanı korur',
      'Öteleme ve dönme bileşkesinde sıra önemlidir',
      'f(x-3) grafiği 3 birim sağa kayar',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'A(2,-3) noktası 3 birim sola, 4 birim yukarı ötelenirse?',
      steps: ['Sola: 2-3=-1', 'Yukarı: -3+4=1'],
      answer: 'A\'(-1,1)',
    ),
    SolvedExample(
      question: 'B(3,4) noktasının y=x doğrusuna göre simetriği?',
      steps: ['x ve y yer değiştirir'],
      answer: 'B\'(4,3)',
    ),
    SolvedExample(
      question: 'C(2,0) noktası orijin etrafında 90° döndürülürse?',
      steps: ['x\'=2cos90-0sin90=0', 'y\'=2sin90+0cos90=2'],
      answer: 'C\'(0,2)',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '(5,2) noktasının x eksenine göre simetriği?', options: ['(5,-2)', '(-5,2)', '(-5,-2)', '(2,5)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(-3,1) noktası 2 birim sağa ötelenirse?', options: ['(-1,1)', '(-5,1)', '(-3,3)', '(-1,3)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(4,-4) noktasının orijine göre simetriği?', options: ['(-4,4)', '(4,4)', '(-4,-4)', '(4,-4)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(1,√3) noktası 180° döndürülürse?', options: ['(-1,-√3)', '(1,-√3)', '(-1,√3)', '(√3,1)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'y=f(x)+2 grafiği nasıl ötelenir?', options: ['2 sağa', '2 yukarı', '2 sola', '2 aşağı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(2,5) noktasının y=-x doğrusuna göre simetriği?', options: ['(-5,-2)', '(5,2)', '(-2,-5)', '(2,-5)'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'A(a,b) 3 birim aşağı ötelenince (2,1) oluyor. b kaçtır?', options: ['2', '3', '4', '-2'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Dönme dönüşümü uzunluğu değiştirir mi?', options: ['Evet', 'Hayır', 'Bazen', 'Açıya bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(-2,-5) noktasının y eksenine göre simetriği?', options: ['(2,-5)', '(-2,5)', '(2,5)', '(5,-2)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'f(x-3) fonksiyonu grafiği ne yöne kayar?', options: ['3 sola', '3 sağa', '3 yukarı', '3 aşağı'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '(5,2) x simetrisi?', options: ['(5,-2)', '(-5,2)', '(-5,-2)', '(2,5)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(4,-4) orijin simetrisi?', options: ['(-4,4)', '(4,4)', '(-4,-4)', '(4,-4)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'f(x-3) hangi yöne?', options: ['3 sola', '3 sağa', '3 yukarı', '3 aşağı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dönme uzunluk değiştirir mi?', options: ['Evet', 'Hayır', 'Bazen', 'Bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'y=f(x)+2 yönü?', options: ['2 sağa', '2 yukarı', '2 sola', '2 aşağı'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'A(-1,3) noktasının K(1,2) noktasına göre simetriği?', options: ['(3,1)', '(1,3)', '(-3,1)', '(3,-1)'], correctIndex: 0, explanation: 'Orta nokta: (x-1)/2=1 ⟹ x=3, (y+3)/2=2 ⟹ y=1', difficulty: 2),
    StemQuestion(question: 'Doğru parçasını 90° döndürmek eğimini nasıl değiştirir?', options: ['Aynı kalır', 'Dik olur (m₁·m₂=-1)', 'İki katına çıkar', 'Sıfır olur'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'f(x)=x² parabolü 2 sağa, 1 aşağı ötelenirse denklemi?', options: ['y=(x-2)²-1', 'y=(x+2)²-1', 'y=(x-2)²+1', 'y=(x+2)²+1'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'A(1,1) orijin etrafında 60° döndürülüyor. Yeni koordinatlar?', options: ['((1-√3)/2,(√3+1)/2)', '((1+√3)/2,(√3-1)/2)', '(0,√2)', '(1/2,√3/2)'], correctIndex: 0, explanation: 'x\'=cos60-sin60=(1-√3)/2, y\'=sin60+cos60=(√3+1)/2', difficulty: 3),
    StemQuestion(question: '3x-4y+5=0 doğrusunun orijine göre simetriği?', options: ['3x-4y-5=0', '-3x+4y+5=0', '3x+4y-5=0', '-3x-4y+5=0'], correctIndex: 0, explanation: 'x→-x, y→-y: -3x+4y+5=0 ⟹ 3x-4y-5=0', difficulty: 2),
    StemQuestion(question: 'Şekil x eksenine yansıtılıp 2 yukarı öteleniyor. Bileşke dönüşüm?', options: ['(x,y+2)', '(x,-y+2)', '(-x,y+2)', '(x,-y-2)'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'A(√3,1) pozitif yönde kaç derece döndürülürse (0,2) elde edilir?', options: ['30°', '45°', '60°', '90°'], correctIndex: 2, explanation: 'Polar: (2,30°)→(2,90°), fark=60°', difficulty: 2),
    StemQuestion(question: 'f(x) grafiği orijine göre simetrikse f(x) nasıl bir fonksiyondur?', options: ['Çift', 'Tek', 'Sabit', 'Periyodik'], correctIndex: 1, explanation: 'f(-x)=-f(x)', difficulty: 1),
    StemQuestion(question: 'Kare 45° döndürüldüğünde alanı değişir mi?', options: ['Evet artar', 'Evet azalır', 'Hayır', 'Açıya bağlı'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'x=2 doğrusuna göre simetriği kendisi olan şekillerin özelliği?', options: ['x=2 simetri ekseni', 'Orijin simetrili', 'y eksenine simetrili', 'Dairesel'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'A(2,3) önce 1 sağa ötelenip sonra y=x simetriği alınıyor. Sonuç?', options: ['(3,3)', '(3,2)', '(2,3)', '(4,3)'], correctIndex: 0, explanation: 'Ötele: (3,3), y=x simetrisi: (3,3)', difficulty: 2),
    StemQuestion(question: 'y=x³ eğrisinin (-2,-8) noktasına göre simetriği?', options: ['y+16=(x+4)³', 'y-16=(x+4)³', 'y=(x+4)³-16', 'y=(x-4)³+16'], correctIndex: 0, explanation: 'Nokta simetrisi: y+16=(x+4)³', difficulty: 3),
    StemQuestion(question: 'P(x,y) saat yönünde 90° döndürülürse koordinatları?', options: ['(-y,x)', '(y,-x)', '(-x,-y)', '(x,-y)'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Öteleme ve dönme dönüşümlerinin bileşkesinde sıra önemli midir?', options: ['Evet', 'Hayır', 'Sadece 90° için', 'Sadece 180° için'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Dönme matrisi hangi matematiksel yapıyı kullanır?', options: ['Determinant', 'Trigonometrik fonksiyonlar', 'Logaritma', 'Türev'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'Öteleme: (x+a, y+b)',
    'x eksenine: (x,-y), y eksenine: (-x,y)',
    'Orijine: (-x,-y), y=x: (y,x)',
    'Dönme: (xcosα-ysinα, xsinα+ycosα)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 5: TÜREV
// ═══════════════════════════════════════════════════════════════

final _s12MatU5Content = StemUnitContent(
  unitId: 's12_mat_u5',
  topic: const TopicContent(
    summary: 'Türev: Fonksiyonun anlık değişim oranıdır. f\'(x)=lim[h→0](f(x+h)-f(x))/h. Geometrik olarak teğetin eğimidir. (xⁿ)\'=n·xⁿ⁻¹. Çarpım, bölüm ve zincir kuralları uygulanır.',
    rule: '(xⁿ)\'=n·xⁿ⁻¹, (c)\'=0\nÇarpım: (f·g)\'=f\'g+g\'f\nBölüm: (f/g)\'=(f\'g-g\'f)/g²\nZincir: [f(g(x))]\'=f\'(g(x))·g\'(x)',
    formulas: [
      '(xⁿ)\'=n·xⁿ⁻¹',
      '(sinx)\'=cosx, (cosx)\'=-sinx',
      '(eˣ)\'=eˣ, (lnx)\'=1/x',
      'f\'(x)>0 artan, f\'(x)<0 azalan',
    ],
    keyPoints: [
      'f\'(x)=0 ve işaret değişimi ⟹ yerel max/min',
      'Türevlenebilirlik için süreklilik şarttır',
      'Maks/Min problemlerinde türevi sıfıra eşitle',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'f(x)=x³-2x²+5 ise f\'(2) kaçtır?',
      steps: ['f\'(x)=3x²-4x', 'f\'(2)=3(4)-4(2)=12-8=4'],
      answer: '4',
    ),
    SolvedExample(
      question: 'y=(2x+1)³ fonksiyonunun türevi? (Zincir Kuralı)',
      steps: ['y\'=3(2x+1)²·(2x+1)\'', 'y\'=3(2x+1)²·2=6(2x+1)²'],
      answer: '6(2x+1)²',
    ),
    SolvedExample(
      question: 'f(x)=x²-4x fonksiyonunun yerel minimum değeri?',
      steps: ['f\'(x)=2x-4=0 ⟹ x=2', 'f(2)=4-8=-4'],
      answer: '-4',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'f(x)=5x türevi nedir?', options: ['0', '5', '5x', 'x'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'f(x)=π² türevi nedir?', options: ['2π', 'π', '0', '1'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'f(x)=x⁻² türevi nedir?', options: ['-2x⁻³', '2x⁻³', '-x⁻³', 'x⁻¹'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'f(x)=sinx türevi nedir?', options: ['-cosx', 'cosx', 'sinx', '-sinx'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'f(x)=lnx türevi nedir?', options: ['x', '1/x', 'lnx', 'eˣ'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'f(x)=eˣ türevi nedir?', options: ['xeˣ⁻¹', 'eˣ', 'eˣ⁻¹', '1'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çarpım türevi kuralı nedir?', options: ['f\'·g\'', 'f\'g+g\'f', '(f·g)\'', 'f/g'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Türevin sıfır olduğu noktalara ne denir?', options: ['Eğim noktası', 'Kritik nokta', 'Kök', 'Sınır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'f(x)=x² eğrisine x=1\'den çizilen teğetin eğimi?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Türevlenebilirlik için önce ne olmalı?', options: ['Artmalı', 'Sürekli', 'Azalmalı', 'Simetrik'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '(5x)\'=?', options: ['0', '5', '5x', 'x'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(sinx)\'=?', options: ['-cosx', 'cosx', 'sinx', '-sinx'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(eˣ)\'=?', options: ['xeˣ⁻¹', 'eˣ', 'eˣ⁻¹', '1'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(lnx)\'=?', options: ['x', '1/x', 'lnx', 'eˣ'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(π²)\'=?', options: ['2π', 'π', '0', '1'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'f(x)=x³-3x²+k, yerel minimum değeri 1 ise k kaçtır?', options: ['3', '4', '5', '6'], correctIndex: 2, explanation: 'f\'=3x²-6x=0, x=2. f(2)=8-12+k=k-4=1 ⟹ k=5', difficulty: 2),
    StemQuestion(question: 'f(x)=|x²-4| fonksiyonunun türevsiz olduğu noktalar?', options: ['{0}', '{-2,2}', '{4}', '{-4,4}'], correctIndex: 1, explanation: 'Mutlak değerin içi sıfır: x=±2', difficulty: 2),
    StemQuestion(question: 'L\'Hopital: lim(x→1)(x³-1)/(x-1) değeri?', options: ['1', '2', '3', '∞'], correctIndex: 2, explanation: '3x²/1=3 (x=1\'de)', difficulty: 2),
    StemQuestion(question: 'x²+y²=25 çemberine (3,4) noktasından teğetin eğimi?', options: ['-3/4', '-4/3', '3/4', '4/3'], correctIndex: 0, explanation: '2x+2yy\'=0 ⟹ y\'=-x/y=-3/4', difficulty: 2),
    StemQuestion(question: 'r=4cm kürenin hacim değişim hızı (dr/dt=0.1cm/s)?', options: ['3.2π', '6.4π', '12.8π', '25.6π'], correctIndex: 1, explanation: 'dV/dt=4πr²·dr/dt=4π(16)(0.1)=6.4π', difficulty: 3),
    StemQuestion(question: 'Çevresi 20cm olan dikdörtgenin en büyük alanı?', options: ['20', '25', '30', '36'], correctIndex: 1, explanation: 'Kare: 5×5=25', difficulty: 2),
    StemQuestion(question: 'f(x)=ln(cosx) ise f\'(π/4) kaçtır?', options: ['1', '-1', '√2', '-√2'], correctIndex: 1, explanation: 'f\'=-sinx/cosx=-tanx. f\'(π/4)=-1', difficulty: 2),
    StemQuestion(question: 'y=x^(lnx) fonksiyonunun türevinde hangi yöntem kullanılır?', options: ['Zincir kuralı', 'Bölüm kuralı', 'Logaritmik türev', 'L\'Hopital'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'f(x) artan bir fonksiyon ise f(x²) her zaman artan mıdır?', options: ['Evet', 'Hayır, x işaretine bağlı', 'Sadece x>0 için', 'B ve C'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: '3. dereceden polinomun en çok kaç ekstremum noktası olur?', options: ['1', '2', '3', '4'], correctIndex: 1, explanation: 'Türevi 2. derece, en çok 2 kök', difficulty: 1),
    StemQuestion(question: 'x(t)=t²-3t konumunda t=3 anındaki hız?', options: ['1', '2', '3', '6'], correctIndex: 2, explanation: 'v(t)=2t-3, v(3)=3', difficulty: 1),
    StemQuestion(question: 'f(2x+1)=x²+3x ise f\'(5) kaçtır?', options: ['2.5', '3', '3.5', '4'], correctIndex: 2, explanation: '2·f\'(2x+1)=2x+3, x=2: 2f\'(5)=7 ⟹ f\'(5)=3.5', difficulty: 3),
    StemQuestion(question: 'Parçalı fonksiyonda kritik noktada türev kontrolü ne ile yapılır?', options: ['Limit', 'Sağ/Sol türev', 'İntegral', 'Grafik'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Türev grafiğinde x eksenini kesen noktalar fonksiyonun neresine karşılık gelir?', options: ['Köklerine', 'Ekstremum noktalarına', 'Büküm noktalarına', 'Asimptotlarına'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'İvme-uzanım grafiğinin eğimi neyi verir?', options: ['Hızı', 'Kuvveti', 'ω² (açısal hız karesi)', 'Kütleyi'], correctIndex: 2, difficulty: 2),
  ],
  formulaCards: const [
    '(xⁿ)\'=n·xⁿ⁻¹',
    'Çarpım: (f·g)\'=f\'g+g\'f',
    'Zincir: [f(g(x))]\'=f\'(g(x))·g\'(x)',
    'f\'(x)=0 ⟹ Kritik nokta (Maks/Min adayı)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 6: İNTEGRAL
// ═══════════════════════════════════════════════════════════════

final _s12MatU6Content = StemUnitContent(
  unitId: 's12_mat_u6',
  topic: const TopicContent(
    summary: 'Belirsiz İntegral: Türevin tersi. ∫f(x)dx=F(x)+c. Kuvvet Kuralı: ∫xⁿdx=xⁿ⁺¹/(n+1)+c. Belirli İntegral: ∫[a→b]f(x)dx=F(b)-F(a). Alan hesabı ve Riemann toplamı.',
    rule: '∫xⁿdx=xⁿ⁺¹/(n+1)+c (n≠-1)\n∫1/x dx=ln|x|+c\n∫eˣdx=eˣ+c\n∫sinxdx=-cosx+c\n∫cosxdx=sinx+c',
    formulas: [
      '∫[a→b]f(x)dx=F(b)-F(a)',
      'Alan=∫[a→b]|f(x)|dx',
      'İki eğri arası=∫(üst-alt)dx',
    ],
    keyPoints: [
      'Değişken değiştirme: u=g(x), du=g\'(x)dx',
      'Sınırlar yer değişirse işaret değişir',
      '∫[a→a]f(x)dx=0',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '∫(3x²-4x+5)dx integralini hesaplayınız.',
      steps: ['Terim terim: 3·x³/3 - 4·x²/2 + 5x + c', '= x³ - 2x² + 5x + c'],
      answer: 'x³-2x²+5x+c',
    ),
    SolvedExample(
      question: '∫[1→3] 2x dx belirli integralinin değeri?',
      steps: ['İntegral: x²', 'Sınırlar: 3²-1²=9-1=8'],
      answer: '8',
    ),
    SolvedExample(
      question: 'f(x)=x² ile x ekseni arasında x=0, x=3 alanı?',
      steps: ['Alan=∫[0→3]x²dx=[x³/3]₀³', '=27/3-0=9 br²'],
      answer: '9 br²',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: '∫5dx nedir?', options: ['5', '5x+c', 'x+c', '0'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫x⁴dx nedir?', options: ['4x³+c', 'x⁵/5+c', 'x⁴/4+c', '5x⁵+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Türevi 2x olan fonksiyon ailesi?', options: ['x²', 'x²+c', '2x²+c', 'x+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫[0→1]xdx kaçtır?', options: ['0', '1/2', '1', '2'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫eˣdx nedir?', options: ['xeˣ+c', 'eˣ+c', 'eˣ/x+c', 'eˣ⁻¹+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫(1/x)dx nedir? (x>0)', options: ['lnx+c', '-1/x²+c', 'x+c', '1+c'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'İntegralde c neyi ifade eder?', options: ['Sabit sayı', 'İntegral sabiti', 'Katsayı', 'Derece'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫sinxdx nedir?', options: ['cosx+c', '-cosx+c', 'sinx+c', '-sinx+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫[2→2]f(x)dx sonucu kaçtır?', options: ['f(2)', '2f(2)', '0', '1'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hız fonksiyonunun integrali neyi verir?', options: ['İvmeyi', 'Konumu', 'Kuvveti', 'Enerjiyi'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '∫5dx=?', options: ['5', '5x+c', 'x+c', '0'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫eˣdx=?', options: ['xeˣ+c', 'eˣ+c', 'eˣ/x+c', 'eˣ⁻¹+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫sinxdx=?', options: ['cosx+c', '-cosx+c', 'sinx+c', '-sinx+c'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫[2→2]f(x)dx=?', options: ['f(2)', '2f(2)', '0', '1'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '∫x⁴dx=?', options: ['4x³+c', 'x⁵/5+c', 'x⁴/4+c', '5x⁵+c'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Riemann toplamı ile belirli integral arasındaki ilişki?', options: ['Toplam=integral', 'n→∞ limit=integral', 'Hiç ilişki yok', 'Toplam>integral'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫(2x+1)⁵dx integrali (u=2x+1)?', options: ['(2x+1)⁶/6+c', '(2x+1)⁶/12+c', '5(2x+1)⁴+c', '(2x+1)⁶/10+c'], correctIndex: 1, explanation: 'du=2dx, (1/2)·u⁶/6=(2x+1)⁶/12', difficulty: 2),
    StemQuestion(question: 'y=x² ve y=√x arasındaki kapalı alan?', options: ['1/6', '1/3', '1/2', '1'], correctIndex: 1, explanation: '∫₀¹(√x-x²)dx=2/3-1/3=1/3', difficulty: 2),
    StemQuestion(question: '∫[-2→2]x³dx değeri kaçtır?', options: ['-8', '0', '8', '16'], correctIndex: 1, explanation: 'Tek fonksiyon, simetrik aralık ⟹ 0', difficulty: 1),
    StemQuestion(question: 'Hız-zaman grafiğinde eğri altındaki alan neyi verir?', options: ['İvmeyi', 'Kuvveti', 'Alınan yolu', 'Enerjiyi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'f\'(x)=3x² ve f(1)=2 ise f(0) kaçtır?', options: ['0', '1', '2', '3'], correctIndex: 1, explanation: 'f(x)=x³+c, f(1)=1+c=2 ⟹ c=1, f(0)=1', difficulty: 2),
    StemQuestion(question: 'd/dx[∫f(x)dx] işleminin sonucu?', options: ['0', 'c', 'f(x)', 'F(x)'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '∫[0→π/2]cosxdx değeri kaçtır?', options: ['0', '1', '-1', 'π/2'], correctIndex: 1, explanation: 'sin(π/2)-sin(0)=1-0=1', difficulty: 1),
    StemQuestion(question: '∫2x/(1+x²)dx integrali?', options: ['ln(1+x²)+c', '1/(1+x²)+c', 'arctan(x)+c', 'x²+c'], correctIndex: 0, explanation: 'u=1+x², du=2xdx', difficulty: 2),
    StemQuestion(question: '∫[-1→3]|x-1|dx değeri kaçtır?', options: ['2', '3', '4', '5'], correctIndex: 2, explanation: '∫₋₁¹(1-x)dx+∫₁³(x-1)dx=2+2=4', difficulty: 2),
    StemQuestion(question: 'y=1/x eğrisi, x=1, x=e ve x ekseni arasındaki alan?', options: ['1/e', '1', 'e', 'e-1'], correctIndex: 1, explanation: 'lne-ln1=1-0=1', difficulty: 2),
    StemQuestion(question: 'Depodaki su değişim hızı veriliyor. 5 saat sonraki miktar nasıl bulunur?', options: ['Türev alınır', 'Başlangıç+∫hız·dt', 'Hız×zaman', 'Grafik çizilir'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Parçalı fonksiyonun belirli integralinde ne yapılır?', options: ['Tek integral yazılır', 'Sınırlara göre ikiye bölünür', 'Mutlak değer alınır', 'Türev alınır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '∫[a→b]f(x)dx=5 ise ∫[a→b](2f(x)+1)dx kaçtır?', options: ['11', '10+(b-a)', '11+(b-a)', '10+2(b-a)'], correctIndex: 1, explanation: '2·5+(b-a)=10+(b-a)', difficulty: 2),
    StemQuestion(question: 'Mutlak değerli integralде kritik noktada ne yapılır?', options: ['Yok sayılır', 'İntegral ikiye bölünür', 'Sıfır kabul edilir', 'İşaret değişmez'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    '∫xⁿdx=xⁿ⁺¹/(n+1)+c (n≠-1)',
    '∫[a→b]f(x)dx=F(b)-F(a)',
    'Alan=∫[a→b]|f(x)|dx',
    'Değişken değiştirme: u=g(x), du=g\'(x)dx',
  ],
);

// ═══════════════════════════════════════════════════════════════
// MATEMATİK ÜNİTE 7: ÇEMBERİN ANALİTİK İNCELENMESİ
// ═══════════════════════════════════════════════════════════════

final _s12MatU7Content = StemUnitContent(
  unitId: 's12_mat_u7',
  topic: const TopicContent(
    summary: 'Standart Denklem: (x-a)²+(y-b)²=r². Merkez orijinde ise x²+y²=r². Genel Denklem: x²+y²+Dx+Ey+F=0. Merkez: (-D/2,-E/2). Yarıçap: r=(1/2)√(D²+E²-4F).',
    rule: 'Merkezin doğruya uzaklığı (d) ile r karşılaştırılır:\nd>r: Doğru kesmez\nd=r: Teğet\nd<r: İki noktada keser',
    formulas: [
      '(x-a)²+(y-b)²=r²',
      'Merkez: (-D/2,-E/2)',
      'r=(1/2)√(D²+E²-4F)',
    ],
    keyPoints: [
      'Çember belirtmesi için D²+E²-4F>0 olmalı',
      'Teğet doğrusu yarıçapa diktir (90°)',
      'Noktanın çembere kuvveti: d²-r²',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Merkezi (2,-3) ve yarıçapı 4 olan çemberin denklemi?',
      steps: ['(x-2)²+(y-(-3))²=4²', '(x-2)²+(y+3)²=16'],
      answer: '(x-2)²+(y+3)²=16',
    ),
    SolvedExample(
      question: 'x²+y²-6x+8y=0 çemberinin merkezi ve yarıçapı?',
      steps: ['D=-6, E=8, F=0', 'Merkez: (3,-4)', 'r=(1/2)√(36+64)=5'],
      answer: 'M(3,-4), r=5',
    ),
    SolvedExample(
      question: 'Merkezi (0,0), 3x-4y+10=0 doğrusuna teğet çemberin yarıçapı?',
      steps: ['d=|3(0)-4(0)+10|/√(9+16)', 'd=10/5=2'],
      answer: 'r=2',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Merkezi orijin, yarıçapı 3 olan denklem?', options: ['x²+y²=3', 'x²+y²=9', 'x²+y²=6', '(x-3)²+y²=9'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '(x-1)²+(y-2)²=25 çemberinin merkezi?', options: ['(1,2)', '(-1,-2)', '(2,1)', '(5,5)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Aynı çemberin yarıçapı?', options: ['3', '4', '5', '25'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Çemberin en uzun kirişine ne denir?', options: ['Yarıçap', 'Kiriş', 'Çap', 'Teğet'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'x²+y²=1 çemberinin adı?', options: ['Birim çember', 'Standart çember', 'Normal çember', 'Temel çember'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(3,4) noktası x²+y²=25 çemberinin neresindedir?', options: ['İçinde', 'Dışında', 'Üzerinde', 'Merkezinde'], correctIndex: 2, explanation: '9+16=25', difficulty: 1),
    StemQuestion(question: 'Çember denklemi için x² ve y² katsayıları ne olmalı?', options: ['Farklı', 'Eşit', 'Biri sıfır', 'Negatif'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Genel denklemde F, çemberin y eksenini kestiğiyle ilişkili midir?', options: ['Evet', 'Hayır', 'Bazen', 'Sadece F=0 için'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Teğet doğrusu yarıçapa kaç derece açı yapar?', options: ['45°', '60°', '90°', '180°'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Noktanın çembere kuvveti d²-r² ile hesaplanır mı?', options: ['Evet', 'Hayır', 'Sadece dışında', 'Sadece içinde'], correctIndex: 0, difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'x²+y²=9, r=?', options: ['3', '9', '√3', '6'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '(x-1)²+(y-2)²=25, merkez?', options: ['(1,2)', '(-1,-2)', '(2,1)', '(5,5)'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Teğet-yarıçap açısı?', options: ['45°', '60°', '90°', '180°'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'En uzun kiriş?', options: ['Yarıçap', 'Kiriş', 'Çap', 'Teğet'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '3²+4²=25, nokta?', options: ['İçinde', 'Dışında', 'Üzerinde', 'Merkezde'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'A(1,2) ve B(5,2) noktalarından geçen, merkezi x ekseni üzerinde olan çemberin denklemi?', options: ['(x-3)²+y²=8', '(x-3)²+y²=4', 'x²+(y-2)²=8', '(x-2)²+y²=5'], correctIndex: 0, explanation: 'Merkez x ekseninde: (a,0). Uzaklıklar eşit ⟹ a=3, r²=4+4=8', difficulty: 2),
    StemQuestion(question: 'x²+y²-4x+2y+k=0 bir nokta belirtiyorsa k kaçtır?', options: ['3', '4', '5', '6'], correctIndex: 2, explanation: 'r=0: 16+4-4k=0 ⟹ k=5', difficulty: 2),
    StemQuestion(question: 'Çemberin her iki eksene teğet olması için merkez koordinatları ne olmalı?', options: ['|a|=|b|=r', 'a=b', 'a+b=r', 'a·b=r²'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'y=x+m doğrusunun x²+y²=8 çemberine teğet olması için m kaçtır?', options: ['±2', '±4', '±2√2', '±4√2'], correctIndex: 1, explanation: '|m|/√2=2√2 ⟹ |m|=4', difficulty: 2),
    StemQuestion(question: 'İki çemberin birbirine göre durumu nasıl belirlenir?', options: ['Yarıçaplar karşılaştırılır', '|M₁M₂| ile r₁+r₂ kıyaslanır', 'Denklemleri çıkarılır', 'Merkezler karşılaştırılır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Merkezi (3,4) olan çember y eksenine teğetse denklemi?', options: ['(x-3)²+(y-4)²=9', '(x-3)²+(y-4)²=16', '(x-3)²+(y-4)²=25', '(x-3)²+(y-4)²=4'], correctIndex: 0, explanation: 'y eksenine uzaklık=|3|=3=r', difficulty: 2),
    StemQuestion(question: 'x²+y²=16 içindeki P(2,1) noktasından geçen en kısa kirişin uzunluğu?', options: ['2√7', '2√11', '4√3', '6'], correctIndex: 1, explanation: 'd=√5, kiriş=2√(16-5)=2√11', difficulty: 3),
    StemQuestion(question: 'x=2+3cosθ, y=1+3sinθ parametrik çemberin yarıçapı?', options: ['1', '2', '3', '5'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Çember dışındaki noktadan teğet uzunluğu nasıl bulunur?', options: ['d-r', '√(d²-r²)', 'd+r', 'd²-r²'], correctIndex: 1, explanation: 'Pisagor: merkez-nokta-teğet üçgeni', difficulty: 2),
    StemQuestion(question: 'x²+y²≤9 ve y>x bölgesinin alanı?', options: ['9π/4', '9π/2', '3π', '9π'], correctIndex: 1, explanation: 'y=x doğrusu çemberi tam ortadan böler ⟹ 9π/2', difficulty: 2),
    StemQuestion(question: 'A(-4,0) ve B(4,0) noktalarına uzaklıkları kareleri toplamı sabit olan noktaların geometrik yeri?', options: ['Doğru', 'Çember', 'Elips', 'Hiperbol'], correctIndex: 1, explanation: '2(x²+y²)+32=sabit ⟹ çember', difficulty: 2),
    StemQuestion(question: 'Her iki eksene teğet, yarıçapı 2, 4. bölgede merkezi olan çemberin denklemi?', options: ['(x-2)²+(y+2)²=4', '(x+2)²+(y-2)²=4', '(x-2)²+(y-2)²=4', '(x+2)²+(y+2)²=4'], correctIndex: 0, explanation: '4. bölge: merkez (2,-2)', difficulty: 2),
    StemQuestion(question: 'İki çemberin dik kesişmesi için şart nedir?', options: ['r₁=r₂', 'r₁²+r₂²=|M₁M₂|²', 'r₁+r₂=|M₁M₂|', 'r₁·r₂=|M₁M₂|'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'x²+y²=20 çemberinin x-y+10=0 doğrusuna en yakın noktasının uzaklığı?', options: ['5√2-2√5', '5√2+2√5', '3√2', '2√5'], correctIndex: 0, explanation: 'd-r=5√2-2√5', difficulty: 3),
    StemQuestion(question: 'Bir radarın tarama alanı çember denklemiyle modellenirse merkezden r uzaklıktaki noktalar ne belirtir?', options: ['Radar sınırı', 'Görüş alanı', 'Menzil çemberi', 'Hepsi'], correctIndex: 3, difficulty: 1),
  ],
  formulaCards: const [
    '(x-a)²+(y-b)²=r²',
    'Merkez: (-D/2,-E/2), r=(1/2)√(D²+E²-4F)',
    'd>r kesmez, d=r teğet, d<r iki noktada keser',
    'Teğet uzunluğu: √(d²-r²)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 1: ÇEMBERSEL HAREKET
// ═══════════════════════════════════════════════════════════════

final _s12FizU1Content = StemUnitContent(
  unitId: 's12_fiz_u1',
  topic: const TopicContent(
    summary: 'Periyot (T): Bir tam tur süresi. Frekans (f): T·f=1. Çizgisel Hız: v=2πr/T. Açısal Hız: ω=2π/T, v=ω·r. Merkezcil İvme: aₘ=ω²r=v²/r. Merkezcil Kuvvet: Fₘ=mω²r.',
    rule: 'Yatay Viraj: v_max=√(k·g·r) (kütleye bağlı değil!)\nEğimli Viraj: v=√(g·r·tanθ)\nDüşey çember üst: T+mg=Fₘ\nDüşey çember alt: T-mg=Fₘ',
    formulas: [
      'v=ωr, ω=2π/T',
      'aₘ=v²/r=ω²r',
      'Fₘ=mv²/r=mω²r',
      'v_max=√(kgr)',
    ],
    keyPoints: [
      'Merkezkaç kuvveti diye bir kuvvet çizilmez',
      'Aynı mil: ω aynı. Kayışlı: v aynı',
      'Yatay virajda güvenli hız kütleye bağlı değildir',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2m ipin ucundaki 3kg cisim f=0,5 tur/s ile dönüyor. İp gerilmesi? (π=3)',
      steps: ['ω=2πf=2·3·0,5=3 rad/s', 'T=Fₘ=mω²r=3·9·2=54 N'],
      answer: '54 N',
    ),
    SolvedExample(
      question: '1m yarıçapta 5m/s ile düşeyde dönen 2kg cisim, en üstte ip gerilmesi? (g=10)',
      steps: ['En üst: T+mg=mv²/r', 'T+20=2·25/1=50', 'T=30 N'],
      answer: '30 N',
    ),
    SolvedExample(
      question: 'k=0,4 olan 100m yarıçaplı yatay viraja araç en fazla kaç m/s girebilir?',
      steps: ['v=√(kgr)=√(0,4·10·100)', '=√400=20 m/s'],
      answer: '20 m/s',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Periyodu 4s olan cismin frekansı?', options: ['0,25 Hz', '0,5 Hz', '2 Hz', '4 Hz'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'ω=10 rad/s, 2s\'de taranan açı?', options: ['5 rad', '10 rad', '20 rad', '40 rad'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'v=12m/s, r=3m ise merkezcil ivme?', options: ['4', '16', '36', '48'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Düzgün çembersel harekette hız ve ivme vektörü arası açı?', options: ['0°', '45°', '90°', '180°'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'r ve v iki katına çıkarsa Fₘ nasıl değişir?', options: ['Yarıya iner', '2 katına çıkar', '4 katına çıkar', 'Değişmez'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Konik sarkaçta ipin düşeyle yaptığı açı nelere bağlıdır?', options: ['Sadece kütle', 'Hız ve yarıçap', 'Sadece ip boyu', 'Sadece g'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Çizgisel hızın birimi?', options: ['rad/s', 'm/s', 'Hz', 'm/s²'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Saniye ibresinin açısal hızı? (π=3)', options: ['0,05 rad/s', '0,1 rad/s', '0,5 rad/s', '1 rad/s'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Yatay düzlemde dönen cisim dengede midir?', options: ['Evet', 'Hayır, net kuvvet var', 'Bazen', 'Hıza bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Merkezcil kuvvet iş yapar mı?', options: ['Evet', 'Hayır, kuvvet yola dik', 'Bazen', 'Hıza bağlı'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'T=4s, f=?', options: ['0,25 Hz', '0,5 Hz', '2 Hz', '4 Hz'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'v=12,r=3, aₘ=?', options: ['4', '16', '36', '48'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'v birimi?', options: ['rad/s', 'm/s', 'Hz', 'm/s²'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fₘ iş yapar mı?', options: ['Evet', 'Hayır', 'Bazen', 'Bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hız-ivme açısı?', options: ['0°', '45°', '90°', '180°'], correctIndex: 2, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Virajlı yollarda yolun içe eğimli yapılmasının mühendislik amacı?', options: ['Daha hızlı geçmek', 'Sürtünmeye olan ihtiyacı azaltmak', 'Yolun ömrünü uzatmak', 'Suyun akmasını sağlamak'], correctIndex: 1, explanation: 'Tepki kuvvetinin yatay bileşeni merkezcil kuvvet olarak kullanılır', difficulty: 2),
    StemQuestion(question: 'Düşeyde dönen kovada en üstte suyun dökülmemesi için minimum hız?', options: ['v=√(gr)', 'v=√(2gr)', 'v=gr', 'v=2gr'], correctIndex: 0, explanation: 'Merkezcil kuvvet=ağırlık, tepki=0: mg=mv²/r', difficulty: 2),
    StemQuestion(question: 'Dönen tabla hızlanırsa tablaya bağlı ağırlık nereye hareket eder?', options: ['Aşağı iner', 'Yukarı çekilir', 'Sabit kalır', 'Yana kayar'], correctIndex: 1, explanation: 'Merkezcil kuvvet ihtiyacı artar, ip gerilmesi artar', difficulty: 2),
    StemQuestion(question: 'Ekvatordaki kişinin kutuptakine göre çizgisel hızı nasıldır?', options: ['Aynı', 'Daha büyük', 'Daha küçük', 'Sıfır'], correctIndex: 1, explanation: 'ω aynı ama Ekvatorda r büyük, v=ωr daha büyük', difficulty: 1),
    StemQuestion(question: 'Çamaşır makinesinde tambur dönerken sudan çıkan su nasıl yol izler?', options: ['Merkezkaç doğrultusunda', 'Yörüngeye teğet doğrusal', 'Spiral', 'Rastgele'], correctIndex: 1, explanation: 'Eylemsizlik: delikten çıkınca o andaki hız yönünde gider', difficulty: 2),
    StemQuestion(question: 'Sabit ω ile dönen pikap üzerinde böcek merkeze yürürse sürtünme kuvveti?', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 1, explanation: 'Fsür=mω²r, r azalır ⟹ Fsür azalır', difficulty: 2),
    StemQuestion(question: 'İple bağlı taş düşeyde dönerken ip en alt noktada koparsa taş nasıl hareket eder?', options: ['Düşey atış', 'Yatay atış', 'Serbest düşme', 'Eğik atış'], correctIndex: 1, explanation: 'Alt noktada hız yatay, kopunca yatay atış', difficulty: 2),
    StemQuestion(question: 'Konik sarkaçta ip uzatılırsa periyot nasıl etkilenir?', options: ['Azalır', 'Artar', 'Değişmez', 'Önce artar sonra azalır'], correctIndex: 1, explanation: 'T=2π√(Lcosθ/g), L artar ⟹ T artar', difficulty: 2),
    StemQuestion(question: 'Silindir içinde düşmemek için sürtünme katsayısı nelere bağlıdır?', options: ['Kütle ve hız', 'Sadece kütle', 'g, ω ve r (kütleye bağlı değil)', 'Sadece ω'], correctIndex: 2, explanation: 'k=g/(ω²r)', difficulty: 2),
    StemQuestion(question: 'Ay\'ın Dünya etrafında dönüşünde merkezcil kuvveti sağlayan nedir?', options: ['İp gerilmesi', 'Sürtünme', 'Kütle çekim', 'Manyetik kuvvet'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Dönerek öteleme yapan tekerleğin yere temas noktasındaki anlık hız?', options: ['v', '2v', 'v√2', '0'], correctIndex: 3, explanation: 'v_öteleme-v_dönme=0', difficulty: 2),
    StemQuestion(question: 'Hızı sabit çembersel harekette teğetsel ivme var mıdır?', options: ['Evet', 'Hayır, sadece merkezcil', 'Bazen', 'Hıza bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Düşey silindirde yarıçap küçülürse düşmemek için gerekli minimum hız?', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 1, explanation: 'v_min=√(gr/k), r azalır ⟹ v_min azalır', difficulty: 2),
    StemQuestion(question: 'Eğimli virajda savrulmadan dönüş hızı kütleye bağlı mıdır?', options: ['Evet', 'Hayır', 'Ağır araçlar için evet', 'Hafif araçlar için evet'], correctIndex: 1, explanation: 'Kütleler formülde sadeleşir', difficulty: 1),
    StemQuestion(question: 'Düzgün olmayan çembersel harekette toplam ivme merkeze mi yöneliktir?', options: ['Evet, daima', 'Hayır, bileşke vektördür', 'Sadece uçlarda', 'Sadece dengede'], correctIndex: 1, explanation: 'Merkezcil+teğetsel ivmenin bileşkesi', difficulty: 2),
  ],
  formulaCards: const [
    'v=ωr, ω=2π/T, T·f=1',
    'aₘ=v²/r=ω²r',
    'Fₘ=mv²/r=mω²r',
    'Yatay viraj: v_max=√(kgr)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 2: DÖNEREK ÖTELEME VE AÇISAL MOMENTUM
// ═══════════════════════════════════════════════════════════════

final _s12FizU2Content = StemUnitContent(
  unitId: 's12_fiz_u2',
  topic: const TopicContent(
    summary: 'Dönerek Öteleme: Üst nokta hızı 2v, yan nokta v√2, temas noktası 0. Eylemsizlik Momenti: I=k·m·r². Açısal Momentum: L=I·ω veya L=m·v·r. Korunum: Dış tork=0 ise L=sabit.',
    rule: 'L=I·ω (Korunur: I₁ω₁=I₂ω₂)\nE_dönme=½Iω²\nE_toplam=½mv²+½Iω²\nSağ el kuralı: Parmaklar dönme yönü, başparmak L yönü',
    formulas: [
      'I=k·m·r² (k: şekle bağlı)',
      'L=I·ω veya L=m·v·r',
      'E_dönme=½Iω²',
      'I₁ω₁=I₂ω₂ (Korunum)',
    ],
    keyPoints: [
      'Kütle eksenden uzaklaşırsa I artar',
      'L korunurken KE artabilir (kas enerjisi)',
      'Disk: I=½mr², Çember: I=mr²',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2kg, r=0,5m disk, ω=4rad/s. Açısal momentum? (I_disk=½mr²)',
      steps: ['I=½·2·(0,5)²=0,25 kg·m²', 'L=I·ω=0,25·4=1 kg·m²/s'],
      answer: '1 kg·m²/s',
    ),
    SolvedExample(
      question: 'Çocuk kollarını kapatınca I yarıya iniyor. Yeni ω kaç ω olur?',
      steps: ['Dış tork yok: L₁=L₂', 'I·ω=(I/2)·ω_yeni', 'ω_yeni=2ω'],
      answer: '2ω',
    ),
    SolvedExample(
      question: 'Tekerlek merkezinin hızı v. Üst/yan nokta hız oranı?',
      steps: ['v_üst=2v', 'v_yan=√(v²+v²)=v√2', 'Oran=2v/(v√2)=√2'],
      answer: '√2',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Açısal momentumun birimi?', options: ['kg·m/s', 'kg·m²/s', 'N·m', 'J·s'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eylemsizlik momenti skaler mi vektörel mi?', options: ['Vektörel', 'Skaler', 'Tensör', 'Boyutsuz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Şekli değişmeden kütlesi artarsa I nasıl değişir?', options: ['Azalır', 'Artar', 'Değişmez', 'Yarıya iner'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dönerek öteleme yapan cismin kaç çeşit kinetik enerjisi vardır?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sağ el kuralında başparmak neyin yönünü gösterir?', options: ['Hız', 'Kuvvet', 'Açısal momentum', 'İvme'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Kaymadan dönen tekerleğin yere temas noktası hızı neden 0?', options: ['Sürtünme yok', 'v_öt ve v_dön zıt ve eşit', 'Kütle sıfır', 'Enerji korunumu'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sabit ω ile dönen diske macun yapışırsa L değişir mi? (Sürtünmesiz mil)', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 2, explanation: 'Dış tork yok, L korunur', difficulty: 2),
    StemQuestion(question: 'L=m·v·r formülü hangi durumda kullanılır?', options: ['Dönen disk', 'Çizgisel yörünge momentumu', 'Dönme enerjisi', 'Eylemsizlik'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Açısal ivme (α) birimi?', options: ['rad/s', 'rad/s²', 'm/s²', 'Hz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eylemsizlik momenti dönme eksenine uzaklığa bağlı mıdır?', options: ['Hayır', 'Evet, karesiyle orantılı', 'Evet, doğru orantılı', 'Evet, ters orantılı'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'L birimi?', options: ['kg·m/s', 'kg·m²/s', 'N·m', 'J·s'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'I skaler mi?', options: ['Vektörel', 'Skaler', 'Tensör', 'Boyutsuz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'α birimi?', options: ['rad/s', 'rad/s²', 'm/s²', 'Hz'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kaç çeşit KE?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Temas noktası hız?', options: ['v', '2v', 'v√2', '0'], correctIndex: 3, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Buz patencisi kollarını açtığında yavaşlar. Hangi büyüklük değişmez?', options: ['Açısal hız', 'Kinetik enerji', 'Açısal momentum', 'Eylemsizlik momenti'], correctIndex: 2, explanation: 'Dış tork=0 ⟹ L korunur', difficulty: 1),
    StemQuestion(question: 'Boş ve dolu kutu aynı eğik düzlemden bırakılıyor. Hangisi yere daha hızlı ulaşır?', options: ['Boş kutu', 'Dolu kutu', 'Aynı anda', 'Eğime bağlı'], correctIndex: 1, explanation: 'Dolu kutunun I\'sı küçük (kütle merkeze yakın) ⟹ daha hızlı', difficulty: 2),
    StemQuestion(question: 'Helikopterin kuyruk pervanesi hangi ilkenin sonucudur?', options: ['Newton 3. yasa', 'Açısal momentum korunumu', 'Enerji korunumu', 'Bernoulli'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dünya yarıçapını yarıya indirseydi (kütle sabit) bir gün kaç saat olurdu?', options: ['3', '6', '12', '48'], correctIndex: 1, explanation: 'I→I/4, ω→4ω, gün=24/4=6 saat', difficulty: 3),
    StemQuestion(question: 'Bisiklette tekerleklerin jiroskopik etkisi ne sağlar?', options: ['Hızlanma', 'Denge kolaylığı', 'Fren gücü', 'Dönüş kolaylığı'], correctIndex: 1, explanation: 'Büyük L yönü değiştirmek zor ⟹ devrilmeye direnç', difficulty: 2),
    StemQuestion(question: 'Dönerek ilerleyen tekerleğin K ve L noktalarının hızları eşit olabilir mi?', options: ['Evet, her zaman', 'Hayır', 'Sadece merkezde', 'Sadece temas noktasında'], correctIndex: 1, explanation: 'Konum farklı ⟹ bileşke hız farklı', difficulty: 2),
    StemQuestion(question: 'Dalgıç havada takla atmak için neden vücudunu toplar?', options: ['Hava direncini azaltmak', 'I\'yı azaltıp ω artırmak', 'Ağırlık merkezi düşürmek', 'Daha yükseğe çıkmak'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'L olan çarkın frekansı 2 katına çıkarsa L nasıl değişir?', options: ['Yarıya iner', 'Değişmez', '2 katına çıkar', '4 katına çıkar'], correctIndex: 2, explanation: 'L=Iω, ω=2πf, f 2 katı ⟹ L 2 katı', difficulty: 1),
    StemQuestion(question: 'Platformda dönen adam elindeki ağır topları bırakırsa?', options: ['Durur', 'Hızlanır', 'Yavaşlar', 'Değişmez'], correctIndex: 1, explanation: 'Sistem I\'sı azalır, L korunur ⟹ ω artar', difficulty: 2),
    StemQuestion(question: 'Tork (τ) ile açısal momentum ilişkisi?', options: ['τ=L·ω', 'τ=ΔL/Δt', 'τ=I/ω', 'τ=L²'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Su dolu şişe mi buz dolu şişe mi eğik düzlemde daha hızlı yuvarlanır?', options: ['Su dolu', 'Buz dolu', 'Aynı', 'Eğime bağlı'], correctIndex: 0, explanation: 'Su dönmeye katılmaz, sadece şişe döner', difficulty: 2),
    StemQuestion(question: 'Yapay uydularda tepki tekerlekleri (reaction wheels) nasıl çalışır?', options: ['Yakıt yakar', 'İçerideki çark döner, uydu ters döner', 'Manyetik alan', 'Güneş rüzgarı'], correctIndex: 1, explanation: 'L korunumu: çark bir yöne, uydu ters yöne', difficulty: 2),
    StemQuestion(question: 'Silindir kaymadan yuvarlanırken E_dönme/E_toplam oranı? (I=½mr²)', options: ['1/2', '1/3', '2/3', '1/4'], correctIndex: 1, explanation: 'E_dön=¼mv², E_top=¾mv², oran=1/3', difficulty: 2),
    StemQuestion(question: 'Elips yörüngede gezegen Güneş\'e en yakınken I nasıl?', options: ['Maksimum', 'Minimum', 'Değişmez', 'Sıfır'], correctIndex: 1, explanation: 'I=mr², r minimum ⟹ I minimum', difficulty: 1),
    StemQuestion(question: 'Sabit tork uygulanan cismin açısal momentumu nasıl değişir?', options: ['Üstel artar', 'Doğrusal artar', 'Sabit kalır', 'Azalır'], correctIndex: 1, explanation: 'τ=ΔL/Δt sabit ⟹ L doğrusal artar', difficulty: 1),
  ],
  formulaCards: const [
    'L=Iω (Açısal Momentum Korunumu)',
    'I₁ω₁=I₂ω₂ (Dış tork yoksa)',
    'E_dönme=½Iω², E_top=½mv²+½Iω²',
    'Disk I=½mr², Çember I=mr²',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 3: KÜTLE ÇEKİM VE KEPLER YASALARI
// ═══════════════════════════════════════════════════════════════

final _s12FizU3Content = StemUnitContent(
  unitId: 's12_fiz_u3',
  topic: const TopicContent(
    summary: 'Kepler: 1) Yörüngeler elips. 2) Eşit zamanda eşit alan (L korunumu). 3) R³/T²=sabit. Newton Çekim: F=GMm/d². Çekim ivmesi: g=GM/R². Kurtulma hızı: v=√(2GM/R).',
    rule: 'F=GMm/d² (Etki-tepki)\ng=GM/R² (yüzeyde)\nR³/T²=sabit (Kepler 3)\nv_kurtulma=√(2GM/R)',
    formulas: [
      'F=GMm/d²',
      'g=GM/R²',
      'R³/T²=sabit',
      'v=√(2GM/R)',
    ],
    keyPoints: [
      'Gezegenin içinde: g∝r (merkeze gidince g=0)',
      'Kurtulma hızı kütleye bağlı değil',
      'Alanlar yasası ⟹ Açısal momentum korunumu',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kütlesi Dünya\'nın 8 katı, yarıçapı 2 katı olan gezegenin g\'si kaç g?',
      steps: ['g∝M/R²', 'g\'=8M/(2R)²=8/4=2g'],
      answer: '2g',
    ),
    SolvedExample(
      question: 'Uydu yörünge yarıçapı 4R yapılırsa periyodu kaç katına çıkar?',
      steps: ['R³/T²=sabit', '1/T₁²=64/T₂²', 'T₂=8T₁'],
      answer: '8 katına',
    ),
    SolvedExample(
      question: 'Dünya Güneş\'e yaklaştığında hangi büyüklükler artar?',
      steps: ['v artar, KE artar, F_çekim artar', 'L ve toplam enerji sabit'],
      answer: 'Hız, KE, çekim kuvveti artar',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Gezegenler neden elips yörüngede dolanır?', options: ['Manyetik kuvvet', 'Kütle çekim kuvveti', 'Elektrik kuvveti', 'Sürtünme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çekim ivmesi birimi?', options: ['N', 'm/s²', 'kg', 'J'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dünya\'dan uzaklaştıkça ağırlık nasıl değişir?', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kepler\'in 2. yasası hangi niceliğin korunduğunu kanıtlar?', options: ['Enerji', 'Açısal momentum', 'Kütle', 'Hız'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Gezegen merkezinde çekim ivmesi kaçtır?', options: ['g', '2g', '0', '∞'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Kurtulma hızı cismin kütlesine bağlı mıdır?', options: ['Evet', 'Hayır', 'Bazen', 'Kütleye göre değişir'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'G sabiti her yerde aynı mıdır?', options: ['Hayır', 'Evet', 'Gezegene bağlı', 'Sıcaklığa bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yüzeyden yukarı çıkıldıkça g nasıl değişir?', options: ['Doğrusal azalır', '1/r² ile azalır', 'Sabit kalır', 'Artar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yörüngedeki uydunun toplam enerjisi negatif midir?', options: ['Evet', 'Hayır', 'Sıfır', 'Pozitif'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Ay\'a merkezden yönelen kuvvet tork oluşturur mu?', options: ['Evet', 'Hayır, kuvvet merkeze yönelik', 'Bazen', 'Hıza bağlı'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'g birimi?', options: ['N', 'm/s²', 'kg', 'J'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Gezegen merkezinde g?', options: ['g', '2g', '0', '∞'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'G sabit mi?', options: ['Hayır', 'Evet', 'Değişir', 'Bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yörünge toplam E?', options: ['Pozitif', 'Negatif', 'Sıfır', 'Bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kepler 2: neyin korunumu?', options: ['Enerji', 'L', 'Kütle', 'Hız'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Dünya çevresinde dolanan uydunun yörünge yarıçapı artırılırsa hangisi artar?', options: ['Çizgisel hız', 'Kinetik enerji', 'Potansiyel enerji', 'Çekim ivmesi'], correctIndex: 2, explanation: 'Uzaklaştıkça PE artar (daha az negatif)', difficulty: 2),
    StemQuestion(question: 'Güneş\'e en yakın konumdaki gezegen için hangisi yanlıştır?', options: ['v maksimum', 'I minimum', 'L maksimum', 'F_çekim maksimum'], correctIndex: 2, explanation: 'L yörünge boyunca sabittir', difficulty: 2),
    StemQuestion(question: 'Özkütlesi sabit, yarıçapı 2 katına çıkan gezegenin g\'si?', options: ['Değişmez', '2 katı', '4 katı', 'Yarısı'], correctIndex: 1, explanation: 'g=K·ρ·R, R 2 katı ⟹ g 2 katı', difficulty: 2),
    StemQuestion(question: 'Dünya merkezinden itibaren g-uzaklık grafiği?', options: ['Doğrusal artar, karesel azalır', 'Her zaman karesel azalır', 'Merkezden yüzeye sabit, dışarıda azalır', 'Hep doğrusal'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Kepler\'in Alanlar Yasası: t sürede A alanı tarayan gezegen 3t sürede kaç A tarar?', options: ['A', '√3A', '3A', '9A'], correctIndex: 2, explanation: 'Alan zamanla doğru orantılı', difficulty: 1),
    StemQuestion(question: 'Uydu yörünge hızını belirleyen temel faktör?', options: ['Uydu kütlesi', 'Yörünge yarıçapı', 'Uydu hacmi', 'Atılış açısı'], correctIndex: 1, explanation: 'v=√(GM/r)', difficulty: 1),
    StemQuestion(question: 'Ay\'ın Dünya\'ya ve Dünya\'nın Ay\'a uyguladığı çekim kuvvetleri?', options: ['F₁>F₂', 'F₂>F₁', 'F₁=F₂', 'Kütlelere bakılmalı'], correctIndex: 2, explanation: 'Etki-tepki: eşit büyüklükte', difficulty: 1),
    StemQuestion(question: 'Astronotun kütlesi Dünya\'da 80kg. g/4 olan gezegende kütlesi?', options: ['20 kg', '40 kg', '80 kg', '320 kg'], correctIndex: 2, explanation: 'Kütle her yerde aynıdır', difficulty: 1),
    StemQuestion(question: 'Yörüngedeki uyduların motorları neden sürekli çalışmaz?', options: ['Yakıt bitmesin diye', 'Çekim kuvveti merkezcil kuvvet sağlar', 'Hava direnci yoktur', 'B ve C'], correctIndex: 3, explanation: 'Çekim yörüngede tutar, sürtünme yok', difficulty: 1),
    StemQuestion(question: 'Çekim alanından kurtulmak için gereken enerjiye ne denir?', options: ['Potansiyel', 'Bağlanma enerjisi', 'Kinetik', 'Isı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dünya\'nın dönüş hızı artsaydı kutuplardaki g nasıl değişirdi?', options: ['Artardı', 'Azalırdı', 'Değişmezdi', 'Sıfır olurdu'], correctIndex: 2, explanation: 'Kutuplar dönme ekseni üzerinde, merkezkaç etkisi yok', difficulty: 2),
    StemQuestion(question: '"Gezegen yörüngeleri elipstir" diyen bilim insanı?', options: ['Newton', 'Kepler', 'Galileo', 'Copernicus'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yüzeyden R kadar yüksekte ağırlığı P olan cismin yüzeydeki ağırlığı?', options: ['P/4', 'P/2', '2P', '4P'], correctIndex: 3, explanation: 'Mesafe 2R, g 1/4, yüzeyde 4P', difficulty: 2),
    StemQuestion(question: 'Yer durağan (Türksat gibi) uydular neden hep aynı noktada görünür?', options: ['Çok hızlı', 'Periyotları Dünya dönme periyoduna eşit', 'Çok uzak', 'Hareket etmez'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Gel-git (Med-cezir) olayının temel sebebi?', options: ['Güneş\'in ısısı', 'Ay ve Güneş\'in kütle çekimi', 'Dünya\'nın manyetik alanı', 'Rüzgarlar'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'F=GMm/d² (Etki-tepki)',
    'g=GM/R² (yüzeyde)',
    'R³/T²=sabit (Kepler 3)',
    'v_kurtulma=√(2GM/R)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 4: BASİT HARMONİK HAREKET
// ═══════════════════════════════════════════════════════════════

final _s12FizU4Content = StemUnitContent(
  unitId: 's12_fiz_u4',
  topic: const TopicContent(
    summary: 'BHH: Denge noktasına göre periyodik salınım. Geri çağırıcı kuvvet: F=-mω²x. Dengede hız max, ivme 0. Uçlarda hız 0, ivme max. Yay sarkacı: T=2π√(m/k). Basit sarkaç: T=2π√(L/g).',
    rule: 'Yay: T=2π√(m/k) (g\'ye bağlı değil)\nSarkaç: T=2π√(L/g) (m\'ye bağlı değil)\nDenge→r/2: T/12 süre\nr/2→uç: T/6 süre',
    formulas: [
      'T=2π√(m/k) (Yay sarkacı)',
      'T=2π√(L/g) (Basit sarkaç)',
      'v_max=ω·A, a_max=ω²·A',
      'Seri: 1/k_eş=1/k₁+1/k₂, Paralel: k_eş=k₁+k₂',
    ],
    keyPoints: [
      'Asansör yukarı ivmelenirse g_eff=g+a, T azalır',
      'Yay kesilirse k artar (k·L=sabit)',
      'Toplam enerji sürtünmesiz ortamda sabit',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'k=200 N/m, m=2kg. Periyot kaç s? (π=3)',
      steps: ['T=2π√(m/k)=6·√(2/200)', '=6·√(1/100)=6·0,1=0,6 s'],
      answer: '0,6 s',
    ),
    SolvedExample(
      question: 'Sarkaç boyu 4 katına çıkarılırsa periyot?',
      steps: ['T∝√L', 'T_yeni=2·(2π√(L/g))=2T'],
      answer: '2T',
    ),
    SolvedExample(
      question: 'a_max=36 m/s², A=4m ise ω kaçtır?',
      steps: ['a_max=ω²·A', '36=ω²·4 ⟹ ω²=9 ⟹ ω=3 rad/s'],
      answer: '3 rad/s',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Yay sarkacının periyodu Ay\'da değişir mi?', options: ['Evet', 'Hayır', 'Artar', 'Azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Basit sarkacın periyodu Ay\'da değişir mi?', options: ['Hayır', 'Evet, artar', 'Evet, azalır', 'Sıfır olur'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Uç noktalarda hız neden sıfırdır?', options: ['Enerji biter', 'Yön değiştirir', 'Kuvvet sıfır', 'Sürtünme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Geri çağırıcı kuvvetin yönü her zaman nereye?', options: ['Dışarı', 'Denge noktasına', 'Yukarı', 'Aşağı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yaylar seri bağlanınca k_eş artar mı azalır mı?', options: ['Artar', 'Azalır', 'Değişmez', 'İkiye katlanır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'BHH yapan cismin ivmesi sabit midir?', options: ['Evet', 'Hayır, uzanıma göre değişir', 'Bazen', 'Hıza bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hızın maximum olduğu noktada uzanım kaçtır?', options: ['A', 'A/2', '0', '-A'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'ω=2 rad/s olan cismin periyodu? (π=3)', options: ['2 s', '3 s', '4 s', '6 s'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Genlik çok büyük olursa BHH bozulur mu?', options: ['Hayır', 'Evet, 10°den küçük olmalı', 'Bazen', 'Yaya bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Bir tam salınım süresi?', options: ['Frekans', 'Periyot', 'Genlik', 'Açısal hız'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Yay sarkacı Ay\'da?', options: ['Değişir', 'Değişmez', 'Artar', 'Azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'v_max noktasında x=?', options: ['A', 'A/2', '0', '-A'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Seri bağ k_eş?', options: ['Artar', 'Azalır', 'Aynı', '2 katı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Geri çağırıcı kuvvet yönü?', options: ['Dışarı', 'Dengeye', 'Yukarı', 'Aşağı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tam salınım süresi?', options: ['Frekans', 'Periyot', 'Genlik', 'ω'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Özdeş yaylar paralel: T₁, seri: T₂. T₁/T₂ oranı?', options: ['1/4', '1/2', '2', '4'], correctIndex: 1, explanation: 'k_par=2k, k_ser=k/2, T∝1/√k', difficulty: 2),
    StemQuestion(question: 'Asansör yukarı ivmelenirse basit sarkaç periyodu?', options: ['Artar', 'Azalır', 'Değişmez', 'Sıfır olur'], correctIndex: 1, explanation: 'g_eff=g+a artar ⟹ T azalır', difficulty: 2),
    StemQuestion(question: 'x=5sin(2t) ise v_max kaç m/s?', options: ['2', '5', '10', '25'], correctIndex: 2, explanation: 'v_max=ω·A=2·5=10', difficulty: 2),
    StemQuestion(question: 'Denge noktasından uzaklaşırken ivme ve hız vektörleri ilişkisi?', options: ['Aynı yönlü', 'Zıt yönlü', 'Uzaklaşırken zıt, yaklaşırken aynı', '90°'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Yayın boyu ortadan ikiye bölünürse k nasıl değişir?', options: ['Yarıya iner', 'Değişmez', '2 katına çıkar', '4 katına çıkar'], correctIndex: 2, explanation: 'k·L=sabit', difficulty: 2),
    StemQuestion(question: 'BHH\'de F-x grafiği nasıldır?', options: ['Doğrusal (eğim negatif)', 'Parabolik', 'Sabit', 'Sinüs'], correctIndex: 0, explanation: 'F=-kx doğrusaldır', difficulty: 1),
    StemQuestion(question: 'T=12s, dengeden geçtikten 1s sonra cisim nerede?', options: ['A/2', 'A', 'Dengede', 'A/4'], correctIndex: 0, explanation: 'T/12=1s ⟹ denge→A/2', difficulty: 2),
    StemQuestion(question: 'Cismin kütlesi artırılırsa hangisi azalır?', options: ['Periyot', 'Maksimum hız', 'Maksimum kuvvet', 'Geri çağırıcı kuvvet'], correctIndex: 1, explanation: 'v_max=ωA, ω=√(k/m), m artar ⟹ ω,v_max azalır', difficulty: 2),
    StemQuestion(question: 'Basit sarkaçta kütle 2 katına çıkarılırsa periyot?', options: ['√2 katı', '2 katı', 'Değişmez', 'Yarısı'], correctIndex: 2, explanation: 'T=2π√(L/g), kütleye bağlı değil', difficulty: 1),
    StemQuestion(question: 'Hangisi BHH değildir?', options: ['Saatin sarkacı', 'Çelik cetvelin titremesei', 'Sabit hızla giden tekerlek', 'Yaydaki kütle'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'BHH\'de toplam enerji nasıl değişir?', options: ['Uçlarda max', 'Dengede max', 'Sabit', 'Sürekli azalır'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Sarkaçlı saat kışın neden ileri gider?', options: ['g artar', 'İp kısalır, T azalır', 'Mekanizma donar', 'Hava direnci azalır'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'İvme-uzanım grafiğinin eğimi neyi verir?', options: ['Hız', 'Kuvvet', 'ω²', 'Kütle'], correctIndex: 2, explanation: 'a=ω²x, eğim=ω²', difficulty: 2),
    StemQuestion(question: 'İvmenin büyüklüğü nerede maksimumdur?', options: ['Dengede', 'Genlik noktalarında', 'Yolun ortasında', 'Her yerde aynı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Esneklik PE max olduğunda hangisi doğrudur?', options: ['Hız max', 'KE max', 'İvme max', 'Kuvvet sıfır'], correctIndex: 2, explanation: 'PE max=uçlar, ivme de uçlarda max', difficulty: 2),
  ],
  formulaCards: const [
    'T=2π√(m/k) (Yay), T=2π√(L/g) (Sarkaç)',
    'v_max=ωA, a_max=ω²A',
    'Denge: v max, a=0. Uç: v=0, a max',
    'Seri: 1/k_eş=Σ(1/kᵢ), Paralel: k_eş=Σkᵢ',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 5: DALGA MEKANİĞİ
// ═══════════════════════════════════════════════════════════════

final _s12FizU5Content = StemUnitContent(
  unitId: 's12_fiz_u5',
  topic: const TopicContent(
    summary: 'Kırınım: Dalga dar aralıktan geçerken bükülür (λ≥w). Young Deneyi: Δx=Lλ/(dn). Doppler: Yaklaşırken frekans artar. EM Dalgalar: Enine, boşlukta c hızıyla yayılır.',
    rule: 'Kırınım: λ≥w olmalı\nΔx=Lλ/(dn) (Saçak aralığı)\nDoppler: Yaklaşma→f artar, uzaklaşma→f azalır\nEM Spektrum: Radyo>Mikro>Kızılötesi>Görünür>Morötesi>X>Gama (enerji artar)',
    formulas: [
      'Δx=Lλ/(dn)',
      'c=λ·f (EM dalgalar)',
      'E=h·f (Foton enerjisi)',
    ],
    keyPoints: [
      'Kırınım: λ artır veya w azalt',
      'EM dalgalar enine ve polarize edilebilir',
      'Tek yarıkta merkezi saçak 2 kat geniş',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Kırınım gözlenmiyorsa ne yapılabilir?',
      steps: ['λ<w demek, kırınım için λ≥w olmalı', 'Su ekle (λ artar) veya yarık daralt (w azalt)'],
      answer: 'Su ekle veya yarık daralt',
    ),
    SolvedExample(
      question: 'Kırmızı ışık yerine mavi kullanılırsa saçak aralığı?',
      steps: ['λ_kırmızı>λ_mavi', 'Δx=Lλ/(dn), λ küçülür ⟹ Δx küçülür'],
      answer: 'Saçak aralığı küçülür',
    ),
    SolvedExample(
      question: 'Yaklaşan ambulansın sesi nasıl duyulur?',
      steps: ['Dalgalar sıkışır, λ küçülür, f artar', 'Ses daha ince (tiz) duyulur'],
      answer: 'Daha tiz (ince) duyulur',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'EM dalgalar boşlukta yayılabilir mi?', options: ['Hayır', 'Evet', 'Bazen', 'Sadece ışık'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işığın kırınımı dalga mı tanecik doğasını kanıtlar?', options: ['Tanecik', 'Dalga', 'Her ikisi', 'Hiçbiri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Ses dalgalarında Doppler görülür mü?', options: ['Hayır', 'Evet', 'Sadece yüksek seste', 'Sadece alçak seste'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Δx nelere bağlıdır?', options: ['Sadece λ', 'L, λ, d, n', 'Sadece d', 'Sadece L'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'En yüksek enerjili EM dalga?', options: ['Radyo', 'X-ışını', 'Gama', 'Morötesi'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Kırınımda dalga boyu değişir mi?', options: ['Evet', 'Hayır', 'Artar', 'Azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tek yarıkta merkezi saçak diğerlerinin kaç katı?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işık hızı ortama bağlı mıdır?', options: ['Hayır', 'Evet', 'Sadece boşlukta', 'Sadece suda'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'EM dalgalar polarize edilebilir mi?', options: ['Hayır', 'Evet', 'Sadece görünür', 'Sadece radyo'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Frekans artarsa dalga boyu?', options: ['Artar', 'Azalır', 'Değişmez', 'İkiye katlanır'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'En enerjili EM dalga?', options: ['Radyo', 'X', 'Gama', 'UV'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'EM boşlukta yayılır mı?', options: ['Hayır', 'Evet', 'Bazen', 'Sadece ışık'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kırınımda λ değişir mi?', options: ['Evet', 'Hayır', 'Artar', 'Azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'f artarsa λ?', options: ['Artar', 'Azalır', 'Aynı', '2 katı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Merkezi saçak kaç kat?', options: ['1', '2', '3', '4'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Su dalgalarında kırınımı artırmak için tek başına ne yapılabilir?', options: ['Frekansı artır', 'Yarığı genişlet', 'Leğene su ekle', 'Genliği artır'], correctIndex: 2, explanation: 'Su ekle ⟹ hız ve λ artar', difficulty: 2),
    StemQuestion(question: 'Çift yarık deneyinde ortam su ile doldurulursa Δx?', options: ['Artar', 'Azalır', 'Değişmez', 'Saçaklar kaybolur'], correctIndex: 1, explanation: 'n artar ⟹ Δx=Lλ/(dn) azalır', difficulty: 2),
    StemQuestion(question: 'Yıldızın tayfında "kırmızıya kayma" ne anlama gelir?', options: ['Yaklaşıyor', 'Uzaklaşıyor', 'Isınıyor', 'Sönüyor'], correctIndex: 1, explanation: 'Uzaklaşma ⟹ λ büyür (kırmızıya kayar)', difficulty: 1),
    StemQuestion(question: 'EM dalgalar için hangisi yanlıştır?', options: ['Boyuna dalgalardır', 'Enerji taşırlar', 'Yansıma ve kırılma yapar', 'Yüksüz'], correctIndex: 0, explanation: 'EM dalgalar enine dalgalardır', difficulty: 1),
    StemQuestion(question: 'Radyo→Gama doğrultusunda hangi nicelik azalır?', options: ['Enerji', 'Frekans', 'Dalga boyu', 'Momentum'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Tek yarıkta cam levha konulursa merkezi saçak ne yöne kayar?', options: ['Kaymaz', 'Camın konulduğu yöne', 'Camın tersi yöne', 'Dışarı çıkar'], correctIndex: 1, explanation: 'Işık camda gecikir', difficulty: 2),
    StemQuestion(question: '"EM dalga teorisi" hangi bilim insanınındır?', options: ['Newton', 'Maxwell', 'Huygens', 'Young'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi EM dalga değildir?', options: ['X-Işını', 'Mikrodalga', 'Ultrason', 'Radyo'], correctIndex: 2, explanation: 'Ultrason mekanik dalgadır', difficulty: 1),
    StemQuestion(question: 'Young deneyinde ekran uzaklaştırılırsa saçak sayısı?', options: ['Artar', 'Azalır', 'Değişmez', 'Netleşir'], correctIndex: 1, explanation: 'Δx büyür ⟹ ekrana sığan sayı azalır', difficulty: 2),
    StemQuestion(question: 'Yaklaşan kaynağın sesi daha tiz, uzaklaşanın daha pes duyulması?', options: ['Kırınım', 'Polarizasyon', 'Doppler', 'Fotoelektrik'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'X-ışınları ile ilgili hangisi doğrudur?', options: ['Canlıya zararsız', 'Elektrik alanda sapar', 'Metal yüzeylerden elektron söker', 'Ses hızıyla yayılır'], correctIndex: 2, explanation: 'Yüksek enerjili ⟹ fotoelektrik olay', difficulty: 2),
    StemQuestion(question: 'Karanlık saçakların oluşma sebebi?', options: ['Soğurulma', 'Yıkıcı girişim', 'Yansıma', 'Kırılma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'EM dalgalarda E, B ve c arasındaki açı?', options: ['Üçü birbirine dik', 'E ve B paralel', 'Sadece E ve c dik', 'Değişken'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Yol farkı 3,5λ olan noktada ne oluşur?', options: ['3. aydınlık', '4. karanlık', '3. karanlık', '4. aydınlık'], correctIndex: 1, explanation: '(n-1/2)λ=3,5λ ⟹ n=4, 4. karanlık', difficulty: 2),
    StemQuestion(question: 'Kızılötesi dalgalar en çok hangi amaçla kullanılır?', options: ['Haberleşme', 'Termal görüntüleme', 'Kanser tedavisi', 'Yemek pişirme'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'Kırınım: λ≥w olmalı',
    'Δx=Lλ/(dn) (Saçak aralığı)',
    'EM Spektrum: Radyo→Gama (E ve f artar)',
    'E, B, c birbirine dik (enine dalga)',
  ],
);

// ═══════════════════════════════════════════════════════════════
// FİZİK ÜNİTE 6: MODERN FİZİK
// ═══════════════════════════════════════════════════════════════

final _s12FizU6Content = StemUnitContent(
  unitId: 's12_fiz_u6',
  topic: const TopicContent(
    summary: 'Bohr: Elektronlar kararlı yörüngelerde, L=nh/(2π). Fotoelektrik: E_foton=E_bağ+E_k. Şiddet elektron sayısını, frekans enerjiyi artırır. Görelilik: Zaman genişler, boy kısalır. De Broglie: λ=h/p.',
    rule: 'E_foton=hf=E_bağlanma+E_kinetik\nZaman genişlemesi: Δt\'=γΔt\nBoy kısalması: L\'=L/γ\nDe Broglie: λ=h/p=h/(mv)',
    formulas: [
      'E=hf (Foton enerjisi)',
      'λ=h/p (De Broglie)',
      'L=nh/(2π) (Bohr)',
      'E=mc² (Kütle-enerji)',
    ],
    keyPoints: [
      'Işığın şiddeti: elektron sayısı. Frekansı: elektron enerjisi',
      'Lyman: UV, Balmer: Görünür, Paschen: Kızılötesi',
      'Compton: Işığın momentumu var (tanecik)',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Bağlanma enerjisi 2eV olan metale 5eV foton. Maks kinetik enerji?',
      steps: ['E_f=E_b+E_k', '5=2+E_k ⟹ E_k=3 eV'],
      answer: '3 eV',
    ),
    SolvedExample(
      question: 'Bohr modeline göre 2. yörüngedeki elektronun açısal momentumu?',
      steps: ['L=nh/(2π), n=2', 'L=2h/(2π)=h/π'],
      answer: 'h/π',
    ),
    SolvedExample(
      question: '0,8c ile giden uzay aracındaki astronot 10 saatlik süreyi nasıl algılar?',
      steps: ['γ=1/√(1-0,64)=1/0,6≈5/3', 'Astronot süresi: 10/γ≈6 saat'],
      answer: '~6 saat',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Elektronun yeri kesin bilinebilir mi? (Heisenberg)', options: ['Evet', 'Hayır', 'Bazen', 'Ölçüme bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işık hem dalga hem tanecik özelliğini aynı anda gösterir mi?', options: ['Evet', 'Hayır, deneye göre biri baskın', 'Bazen', 'Sadece boşlukta'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eşik enerjisi nelere bağlıdır?', options: ['Işık şiddetine', 'Sadece metalin cinsine', 'Frekansa', 'Sıcaklığa'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fotonların durgun kütlesi var mıdır?', options: ['Evet', 'Hayır', 'Bazen', 'Frekansa bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Işık hızı gözlemcinin hızına göre değişir mi?', options: ['Evet', 'Hayır, sabittir', 'Bazen', 'Ortama bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Siyah cisim ışıması nedir?', options: ['Soğuk cismin ışıması', 'Her dalga boyunda ışıma', 'Sadece kızılötesi', 'Sadece görünür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Lyman serisi gözle görülür mü?', options: ['Evet', 'Hayır, morötesidir', 'Bazen', 'Kızılötesi'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fotoelektrikte sökülen elektronlara ne denir?', options: ['İyon', 'Fotoelektron', 'Proton', 'Nötron'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Elektronun dalga boyu hız arttıkça?', options: ['Artar', 'Azalır', 'Değişmez', 'İkiye katlanır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Lazer ışığı uyarılmış emisyonla mı oluşur?', options: ['Hayır', 'Evet', 'Bazen', 'Sadece kırmızı'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Foton durgun kütlesi?', options: ['Var', 'Yok (sıfır)', 'Bazen', 'f\'e bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'c gözlemciye bağlı mı?', options: ['Evet', 'Hayır', 'Bazen', 'Ortama bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Lyman serisi?', options: ['Görünür', 'UV', 'Kızılötesi', 'X-ışını'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hız artarsa λ_De Broglie?', options: ['Artar', 'Azalır', 'Aynı', '2 katı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eşik E nelere bağlı?', options: ['Şiddete', 'Metale', 'f\'e', 'T\'ye'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisi sadece ışığın tanecik modeli ile açıklanır?', options: ['Girişim', 'Kırınım', 'Fotoelektrik olay', 'Yansıma'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Işık hızına yakın hareket eden çubuğun boyu durgun gözlemciye göre?', options: ['Uzun', 'Kısa', 'Aynı', 'Önce uzun sonra kısa'], correctIndex: 1, explanation: 'Lorentz kısalması', difficulty: 1),
    StemQuestion(question: 'Compton saçılmasında gelen fotonun hangi niceliği saçılandan büyük?', options: ['Dalga boyu', 'Enerjisi', 'Hızı', 'Periyodu'], correctIndex: 1, explanation: 'Enerji bir kısmını elektrona verir', difficulty: 2),
    StemQuestion(question: 'Bohr modeline göre üst yörüngeden alta inerken hangisi artar?', options: ['Toplam enerji', 'Bağlanma enerjisi', 'Açısal momentum', 'Yörünge yarıçapı'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Fotoelektrikte sökülen elektron sayısını artırmak için?', options: ['Frekansı artır', 'Şiddeti artır', 'Yüksek eşik enerjili metal kullan', 'Levha mesafesi artır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Antimadde ile ilgili hangisi yanlıştır?', options: ['Kütleleri aynı', 'Yük işaretleri zıt', 'Enerjiye dönüşürler', 'Her parçacığın karşıtı kendisidir'], correctIndex: 3, explanation: 'Sadece foton gibi bazılarının karşıtı kendisidir', difficulty: 2),
    StemQuestion(question: 'Hiçbir cisim ışık hızına ulaşamaz çünkü?', options: ['Yakıt yetersiz', 'Sonsuz enerji gerekir', 'Işık engeller', 'Zaman durur'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kesme potansiyeli (V_kesme) nelere bağlıdır?', options: ['Işık şiddeti', 'Frekans ve metalin cinsi', 'Katot-anot uzaklığı', 'Katot yüzey alanı'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Heisenberg\'e göre aynı anda kesin ölçülemeyen büyüklükler?', options: ['Kütle ve hız', 'Konum ve momentum', 'Enerji ve yük', 'Zaman ve sıcaklık'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisinde atom numarası değişmez?', options: ['Alfa ışıması', 'Beta ışıması', 'Gama ışıması', 'Pozitron salınımı'], correctIndex: 2, explanation: 'Gama sadece enerji atılması', difficulty: 1),
    StemQuestion(question: 'Standart Model\'e göre hangisi temel parçacıktır?', options: ['Proton', 'Nötron', 'Elektron', 'Alfa'], correctIndex: 2, explanation: 'Elektron lepton, temel parçacık', difficulty: 1),
    StemQuestion(question: 'Eşik frekansı f₀ olan metale 2f₀ ile E enerji, 3f₀ ile kaç E?', options: ['1.5E', '2E', '3E', '4E'], correctIndex: 1, explanation: '2hf₀=hf₀+E ⟹ E=hf₀. 3hf₀=hf₀+2E', difficulty: 2),
    StemQuestion(question: 'Michelson-Morley deneyinin amacı?', options: ['Işık hızı ölçmek', 'Eter varlığını kanıtlamak', 'Fotoelektrik gözlemlemek', 'Atom yapısı incelemek'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Güneş\'teki enerji hangi nükleer tepkimeyle üretilir?', options: ['Fisyon', 'Füzyon', 'Yanma', 'Alfa bozunumu'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Modern fiziğe göre ışık nedir?', options: ['Sadece dalga', 'Sadece tanecik', 'Dalga ve tanecik karakterli bütün', 'Elektriksel akım'], correctIndex: 2, difficulty: 1),
  ],
  formulaCards: const [
    'E=hf (Foton), λ=h/p (De Broglie)',
    'E_foton=E_bağ+E_k (Fotoelektrik)',
    'Lyman: UV, Balmer: Görünür, Paschen: IR',
    'Işık hızı sabittir, kütle ışık hızına ulaşamaz',
  ],
);

// ═══════════════════════════════════════════════════════════════
// KİMYA ÜNİTE 1: ELEKTROKİMYA
// ═══════════════════════════════════════════════════════════════

final _s12KimU1Content = StemUnitContent(
  unitId: 's12_kim_u1',
  topic: const TopicContent(
    summary: 'Redoks: Elektron alışverişi. Yükseltgenme=elektron verme, İndirgenme=elektron alma. Galvanik Hücre: Anot(yükseltgenme, aşınır), Katot(indirgenme, birikir). E_pil=E_yüks+E_ind. Faraday: m=QM/(96500z).',
    rule: 'E_pil>0 ⟹ istemli tepkime\nNernst: E=E°-(0,0592/n)·logQ\n1 Faraday=96500 C=1 mol e⁻\nTuz köprüsü: Anyonlar anoda, katyonlar katoda (AKAK)',
    formulas: [
      'E_pil=E_yüks+E_ind',
      'm=Q·M_A/(96500·z)',
      'Q=I·t',
      'E=E°-(0,0592/n)·logQ',
    ],
    keyPoints: [
      'Yükseltgen: Karşıdakini yükseltger, kendisi indirgenir',
      'Derişim pilinde düşük derişim=anot',
      'Kurban elektrot: Daha aktif metal korozyona uğrar',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Zn/Zn²⁺//Cu²⁺/Cu pilinde E°(Zn/Zn²⁺)=0,76V, E°(Cu/Cu²⁺)=-0,34V. E_pil?',
      steps: ['Zn anottur (yükseltgenme): +0,76V', 'Cu katottur (indirgenme): +0,34V', 'E_pil=0,76+0,34=1,10V'],
      answer: '1,10 V',
    ),
    SolvedExample(
      question: 'MgCl₂ eritiği 9,65A ile 1000s elektroliz. Katotta kaç gram Mg? (Mg:24)',
      steps: ['Q=9,65·1000=9650C', 'n_e=9650/96500=0,1 mol', 'Mg²⁺+2e⁻→Mg: 0,1/2=0,05 mol → 1,2g'],
      answer: '1,2 g',
    ),
    SolvedExample(
      question: 'Derişim pilinde anot ve katot nasıl belirlenir?',
      steps: ['Elektrotlar aynıysa derişimi az olan taraf anottur'],
      answer: 'Düşük derişim=Anot',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Aktiflik sıralamasında hidrojenin üstündekilere ne denir?', options: ['Soy metaller', 'Aktif metaller', 'Yarı metaller', 'Ametaller'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Standart hidrojen elektrodunun (SHE) potansiyeli?', options: ['-0,76V', '0,00V', '+0,34V', '+1,10V'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tuz köprüsü kaldırılırsa pil çalışır mı?', options: ['Evet', 'Hayır', 'Yavaş çalışır', 'Ters çalışır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Pil tepkimeleri genelde ne türdür?', options: ['Endotermik', 'Ekzotermik', 'Nötr', 'Değişken'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Anot elektrodun kütlesi zamanla ne olur?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce artar sonra azalır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Elektroliz kabında katyonlar hangi elektroda gider?', options: ['Anot', 'Katot', 'İkisine de', 'Hiçbirine'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Su elektrolizinde anotta hangi gaz çıkar?', options: ['H₂', 'O₂', 'Cl₂', 'N₂'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Demiri korumak için çinko kaplamasına ne denir?', options: ['Elektroliz', 'Galvanizleme', 'Hidroliz', 'Korozyon'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'E_pil sıcaklık artışıyla genelde nasıl değişir?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce artar'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Peroksitlerde oksijenin yükseltgenme basamağı?', options: ['-2', '-1', '0', '+1'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'SHE potansiyeli?', options: ['-0,76V', '0,00V', '+0,34V', '+1,10V'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Anot kütlesi?', options: ['Artar', 'Azalır', 'Aynı', 'Önce artar'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Katyonlar nereye?', options: ['Anot', 'Katot', 'İkisine', 'Hiçbirine'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Galvanizleme?', options: ['Bakır kaplama', 'Çinko kaplama', 'Altın kaplama', 'Gümüş kaplama'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Peroksitte O basamağı?', options: ['-2', '-1', '0', '+1'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisinde redoks gerçekleşmez?', options: ['Demirin paslanması', 'Gümüşün kararması', 'Asit-baz nötralleşme', 'Pilin çalışması'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Standart galvanik hücrede sıcaklık artırılırsa E_pil?', options: ['Artar', 'Azalır', 'Değişmez', 'Önce artar'], correctIndex: 1, explanation: 'Ekzotermik tepkime, sıcaklık dengeyi geri kaydırır', difficulty: 2),
    StemQuestion(question: 'Seri elektrolizde 0,4mol Ag toplandığında kaç mol Cu toplanır?', options: ['0,1', '0,2', '0,4', '0,8'], correctIndex: 1, explanation: '0,4·1=n_Cu·2 ⟹ n=0,2', difficulty: 2),
    StemQuestion(question: 'Kurban elektrot seçimi için temel şart?', options: ['Daha pasif', 'Daha aktif', 'Soy metal', 'Büyük atom numarası'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'SHE\'de platin (Pt) kullanılmasının sebebi?', options: ['Çok aktif', 'Ucuz', 'İnert ve iletken', 'H₂ sıvılaştırır'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'E_pil artırmak için ne yapılmalı?', options: ['Anot derişimini artır', 'Katot derişimini artır', 'Sıcaklığı artır', 'Anot yüzeyini genişlet'], correctIndex: 1, explanation: 'Nernst: katot der. artar ⟹ Q azalır ⟹ E artar', difficulty: 2),
    StemQuestion(question: 'Alüminyumun kendi üzerinde koruyucu tabaka oluşturmasına ne denir?', options: ['Elektroliz', 'Pasifleşme', 'Hidroliz', 'Amalgam'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tuz köprüsünde NaNO₃ varsa NO₃⁻ nereye hareket eder?', options: ['Anoda', 'Katoda', 'Dışarı', 'Hareket etmez'], correctIndex: 0, explanation: 'Anyonlar anoda gider', difficulty: 1),
    StemQuestion(question: 'Cu-Zn pilinde Zn 13g azaldığında Cu kaç gram artar? (Zn:65,Cu:64)', options: ['6,4', '12,8', '25,6', '13,0'], correctIndex: 1, explanation: '0,2mol Zn ⟹ 0,2mol Cu=12,8g', difficulty: 2),
    StemQuestion(question: 'AlCl₃ elektrolizinde 5,4g Al toplandığında kaç Faraday yük geçer? (Al:27)', options: ['0,2', '0,3', '0,6', '0,9'], correctIndex: 2, explanation: '0,2mol Al × 3e⁻=0,6F', difficulty: 2),
    StemQuestion(question: 'Elektron alan madde için hangisi doğrudur?', options: ['Yükseltgenmiştir', 'Yükseltgendir', 'İndirgendir', 'Anottur'], correctIndex: 1, explanation: 'Elektron alan=indirgenir=yükseltgen ajandır', difficulty: 2),
    StemQuestion(question: 'Li-iyon pillerle ilgili hangisi yanlıştır?', options: ['Şarj edilebilir', 'Hafif', 'Hafıza etkisi yok', 'Elektrolit sulu çözelti'], correctIndex: 3, explanation: 'Li su ile tepkime verir, organik elektrolit kullanılır', difficulty: 2),
    StemQuestion(question: 'Standart indirgenme potansiyeli en küçük metal?', options: ['Au', 'Cu', 'H', 'Li'], correctIndex: 3, explanation: 'Li en aktif, indirgenme isteği en az', difficulty: 1),
    StemQuestion(question: 'Sulu elektrolizde katotta önce hangi katyon indirgenir?', options: ['İndirgenme potansiyeli en büyük', 'Yükseltgenme pot. en büyük', 'Derişimi en az olan', 'Atom no. en küçük'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Elektrot yüzey alanı artırılırsa ne değişir?', options: ['Pil gerilimi artar', 'Ömür ve akım artar', 'Gerilim azalır', 'Pil ters çalışır'], correctIndex: 1, explanation: 'Gerilim değişmez, kapasite artar', difficulty: 2),
  ],
  formulaCards: const [
    'E_pil=E_yüks+E_ind (>0 istemli)',
    'm=Q·M/(96500·z) (Faraday)',
    'Tuz köprüsü: Anyonlar→Anot, Katyonlar→Katot',
    'Nernst: E=E°-(0,0592/n)·logQ',
  ],
);

// ═══════════════════════════════════════════════════════════════
// KİMYA ÜNİTE 2: KARBON KİMYASINA GİRİŞ
// ═══════════════════════════════════════════════════════════════

final _s12KimU2Content = StemUnitContent(
  unitId: 's12_kim_u2',
  topic: const TopicContent(
    summary: 'Organik: C temel element, kovalent bağ, düşük erime noktası. Anorganik: İyonik bağ, yüksek erime. Karbon 4 bağ yapar. Elmas(sp³), Grafit(sp²), Fulleren, Grafen. Lewis, Hibritleşme ve VSEPR.',
    rule: 'sp³: 4σ, 109.5°, Dörtyüzlü (CH₄)\nsp²: 3σ+1π, 120°, Düzlem Üçgen (BH₃)\nsp: 2σ+2π, 180°, Doğrusal (CO₂)\nVSEPR: AXₙEₘ ile geometri belirlenir',
    formulas: [
      'sp³: Düzgün dörtyüzlü (109,5°)',
      'sp²: Düzlem üçgen (120°)',
      'sp: Doğrusal (180°)',
      'AX₃E: Üçgen piramit (~107°)',
    ],
    keyPoints: [
      'CO, CO₂, CN⁻, CO₃²⁻ organik değildir (istisna)',
      'Grafen: 2D, çelikten 200 kat güçlü, süper iletken',
      'AX₂E₂ (H₂O): Kırık doğru, ~104,5°',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'C₂H₂ (Asetilen) hangi hibritleşme, kaç σ,π bağı?',
      steps: ['H-C≡C-H: Üçlü bağ ⟹ sp hibritleşme', '3 σ bağı + 2 π bağı'],
      answer: 'sp, 3σ+2π',
    ),
    SolvedExample(
      question: 'NH₃ molekülünün VSEPR gösterimi ve geometrisi?',
      steps: ['N: 5 değerlik e⁻, 3 bağ+1 ortaklanmamış çift', 'AX₃E: Üçgen piramit'],
      answer: 'AX₃E, Üçgen Piramit',
    ),
    SolvedExample(
      question: 'Grafen hakkında doğru bilgi?',
      steps: ['Karbonun yapay, 2D, tek atom kalınlığında allotropu', 'Altıgen bal peteği yapısı, çok iyi iletken'],
      answer: '2D, süper iletken, bal peteği',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Karbon kaçıncı gruptadır?', options: ['2A', '3A', '4A', '5A'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Tekli bağlar hangi bağ türüdür?', options: ['π', 'σ', 'İyonik', 'Metalik'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'H₂O molekül geometrisi?', options: ['Doğrusal', 'Düzlem üçgen', 'Kırık doğru', 'Dörtyüzlü'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Grafitteki karbonlar hangi hibritleşmeyi yapar?', options: ['sp', 'sp²', 'sp³', 'sp³d'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'CO₂ molekülü polar mı apolar mıdır?', options: ['Polar', 'Apolar', 'Nötr', 'Değişken'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'VSEPR\'deki E harfi neyi temsil eder?', options: ['Elektron', 'Enerji', 'Ortaklanmamış çift', 'Element'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangi karbon allotropu elektriği iletir?', options: ['Elmas', 'Grafit', 'Sadece fulleren', 'Hiçbiri'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'CH₄ bağ açısı?', options: ['90°', '104,5°', '109,5°', '120°'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'π bağları hibrit orbitallerle mi oluşur?', options: ['Evet', 'Hayır, dik p orbitalleriyle', 'Bazen', 's orbitalleriyle'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Organik bileşiklerin ana kaynağı?', options: ['Deniz suyu', 'Fosil yakıtlar', 'Hava', 'Toprak'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'C kaçıncı grup?', options: ['2A', '3A', '4A', '5A'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'H₂O geometrisi?', options: ['Doğrusal', 'Üçgen', 'Kırık doğru', 'Dörtyüzlü'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'CH₄ bağ açısı?', options: ['90°', '104,5°', '109,5°', '120°'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Grafit hibritleşme?', options: ['sp', 'sp²', 'sp³', 'sp³d'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'CO₂ polaritesi?', options: ['Polar', 'Apolar', 'Nötr', 'Değişken'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisi anorganik bir bileşiktir?', options: ['CH₄', 'C₂H₅OH', 'CaCO₃', 'HCOOH'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Karbon allotropları ile ilgili hangisi yanlıştır?', options: ['Elmas doğaldır', 'Fulleren yapaydır', 'Elmas ısıyı iletmez', 'Grafen süper iletken'], correctIndex: 2, explanation: 'Elmas elektriği iletmez ama ısıyı çok iyi iletir', difficulty: 2),
    StemQuestion(question: 'BH₃ molekülü için hangisi doğrudur?', options: ['AX₃E, piramit', '107° bağ açısı', 'Düzlem üçgen', 'Polar'], correctIndex: 2, explanation: 'AX₃, 120°, düzlem üçgen', difficulty: 2),
    StemQuestion(question: '2σ+2π bağı varsa merkez atom hangi hibritleşmeyi yapar?', options: ['sp', 'sp²', 'sp³', 'sp³d'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'H₂O\'da bağ açısının CH₄\'ten küçük olma sebebi?', options: ['H kütlesi', 'O elektronegatifliği', 'Ortaklanmamış çiftlerin itmesi', 'Sıvı olması'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Grafen tabakalarının silindir haline gelmesiyle ne oluşur?', options: ['Elmas', 'Karbon Nanotüp', 'Fulleren', 'Kömür'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hibritleşme ile ilgili hangisi yanlıştır?', options: ['Farklı enerjili orbitaller eş enerjili olur', 'Hibrit sayısı=katılan orbital sayısı', 'Sadece organiklerde görülür', 'Bağ sağlamlığını artırır'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'C₂H₄ (Eten) için hangi yargılar doğrudur? I.1σ+1π II.sp² III.Düzlemsel', options: ['Yalnız I', 'I ve II', 'II ve III', 'I, II ve III'], correctIndex: 3, difficulty: 2),
    StemQuestion(question: 'AX₃E tipi molekülde bağ açısı?', options: ['90°', '107°', '120°', '180°'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nanoteknolojide en önemli karbon allotropu?', options: ['Elmas', 'Grafit', 'Fulleren', 'Linyit'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'σ ve π bağları ile ilgili hangisi doğrudur?', options: ['π daha kuvvetli', 'İki atom arası sadece 1 σ olabilir', 'Önce π oluşur', 'σ yan yana örtüşme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: ':N≡N: için hangisi yanlıştır?', options: ['3 bağlayıcı çift', '2 ortaklanmamış çift', '2π+1σ', 'Kırık doğru geometri'], correctIndex: 3, explanation: 'İki atomlu ⟹ daima doğrusal', difficulty: 2),
    StemQuestion(question: 'BeH₂ VSEPR ve geometrisi?', options: ['AX₂, Doğrusal', 'AX₃, Üçgen', 'AX₂E₂, Kırık', 'AX₄, Dörtyüzlü'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Organik yanma ürünleri genellikle?', options: ['O₂ ve H₂', 'CO₂ ve H₂O', 'C ve N₂', 'CH₄ ve H₂O'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi sp³ hibritleşmesi yapmış karbon içerir?', options: ['CO₂', 'C₂H₂', 'CH₄', 'H₂C=O'], correctIndex: 2, difficulty: 1),
  ],
  formulaCards: const [
    'sp³: 4σ, 109,5° (CH₄)',
    'sp²: 3σ+1π, 120° (C₂H₄)',
    'sp: 2σ+2π, 180° (C₂H₂)',
    'VSEPR: AXₙEₘ ile geometri belirlenir',
  ],
);

// ═══════════════════════════════════════════════════════════════
// KİMYA ÜNİTE 3: HİDROKARBONLAR
// ═══════════════════════════════════════════════════════════════

final _s12KimU3Content = StemUnitContent(
  unitId: 's12_kim_u3',
  topic: const TopicContent(
    summary: 'Alkanlar(CₙH₂ₙ₊₂): Doymuş, sp³, sadece yer değiştirme ve yanma. Alkenler(CₙH₂ₙ): İkili bağ, katılma, cis-trans izomeri. Alkinler(CₙH₂ₙ₋₂): Üçlü bağ, uç alkin ayracı. Aromatikler: Benzen(C₆H₆), kararlı halka.',
    rule: 'Alkan: CₙH₂ₙ₊₂ (Parafin, doymuş)\nAlken: CₙH₂ₙ (Olefin, doymamış)\nAlkin: CₙH₂ₙ₋₂ (Asetilen)\nMarkovnikov: H, H\'si çok olan C\'ye gider',
    formulas: [
      'CₙH₂ₙ₊₂ (Alkan)',
      'CₙH₂ₙ (Alken/Sikloalkan)',
      'CₙH₂ₙ₋₂ (Alkin)',
    ],
    keyPoints: [
      'Alkanlar: Yer değiştirme (UV), yanma',
      'Alkenler: Katılma, polimerleşme, cis-trans',
      'Uç alkin: Ag⁺/Cu⁺ ile çökelek, iç alkin vermez',
      'Asetilen trimerleşme ⟹ Benzen',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '5 karbonlu düz zincirli alkanın adı ve izomer sayısı?',
      steps: ['Pentan (C₅H₁₂)', 'n-pentan, izopentan, neopentan ⟹ 3 izomer'],
      answer: 'Pentan, 3 izomer',
    ),
    SolvedExample(
      question: '2-Büten molekülünün Cis ve Trans izomerleri?',
      steps: ['İkili bağda CH₃ grupları aynı tarafta: Cis', 'Zıt tarafta: Trans'],
      answer: 'Cis: aynı taraf, Trans: zıt taraf',
    ),
    SolvedExample(
      question: 'Etine (Asetilen) 1 mol H₂O katılırsa ne oluşur?',
      steps: ['Alkinlere su katılması Keto-Enol tautomerisi', 'Asetilene su ⟹ Asetaldehit'],
      answer: 'Asetaldehit',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Alkanların en küçük üyesi?', options: ['Etan', 'Metan', 'Propan', 'Bütan'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Alkenlerin genel adı?', options: ['Parafin', 'Olefin', 'Asetilen', 'Aren'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Benzene CH₃ bağlanırsa adı?', options: ['Fenol', 'Toluen', 'Anilin', 'Naftalin'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Doymamış hidrokarbonlar Br₂ suyunun rengini giderir mi?', options: ['Hayır', 'Evet', 'Bazen', 'Sadece alkinler'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Alkanlarda dallanma arttıkça kaynama noktası?', options: ['Artar', 'Düşer', 'Değişmez', 'İkiye katlanır'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'CₙH₂ₙ genel formüllü halkalı yapı?', options: ['Alken', 'Sikloalkan', 'Alkin', 'Aromatik'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Asetilen eldesinde hangi taş kullanılır?', options: ['Kireçtaşı', 'Karpit', 'Alçıtaşı', 'Mermer'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Alkenlerde ikili bağ konumu nasıl belirtilir?', options: ['En büyük numara', 'En küçük numara', 'Ortadaki', 'Rastgele'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Benzen molekülünde tüm bağlar özdeş midir?', options: ['Hayır', 'Evet, rezonans', 'Bazen', 'Sadece σ bağları'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hidrokarbon sadece C ve H içerir mi?', options: ['Hayır', 'Evet', 'Bazen O da', 'N de içerir'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'En küçük alkan?', options: ['Etan', 'Metan', 'Propan', 'Bütan'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Alken genel adı?', options: ['Parafin', 'Olefin', 'Asetilen', 'Aren'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Benzen+CH₃?', options: ['Fenol', 'Toluen', 'Anilin', 'Naftalin'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Dallanma artarsa kaynama?', options: ['Artar', 'Düşer', 'Aynı', '2 katı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Karpit nedir?', options: ['CaCO₃', 'CaC₂', 'CaSO₄', 'CaO'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: '2,2-dimetil bütan ile ilgili hangisi yanlıştır?', options: ['6 karbonlu', 'n-hekzan izomeri', 'Katılma tepkimesi verir', 'Doymuş'], correctIndex: 2, explanation: 'Alkanlar katılma vermez', difficulty: 2),
    StemQuestion(question: 'Hangisinin Cis-Trans izomeri vardır?', options: ['1-Penten', '2-Metil-2-büten', '2-Penten', 'Etilen'], correctIndex: 2, explanation: 'İkili bağdaki her karbonda farklı gruplar gerekli', difficulty: 2),
    StemQuestion(question: 'Uç alkini iç alkinden ayıran çözelti?', options: ['Bromlu su', 'Amonyaklı AgNO₃', 'KMnO₄', 'H₂SO₄'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Benzenden bir H çıkarılmasıyla oluşan grup?', options: ['Benzil', 'Fenil', 'Alkil', 'Vinil'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Propene HCl katıldığında ana ürün? (Markovnikov)', options: ['1-klorpropan', '2-klorpropan', '1,2-diklorpropan', 'Kloretan'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Alkanların halojenle yer değiştirmesi için şart?', options: ['Karanlık', 'Pt katalizör', 'UV ışığı veya yüksek sıcaklık', 'Sulu ortam'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '1 mol asetilenin tamamen doyurulması için kaç mol H₂ gerekir?', options: ['1', '2', '3', '4'], correctIndex: 1, explanation: '2 π bağı → 2 mol H₂', difficulty: 1),
    StemQuestion(question: 'Hangisi dezenfektan olarak kullanılır?', options: ['Fenol', 'Anilin', 'Toluen', 'Naftalin'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '0,1 molü yandığında 0,4 mol CO₂ oluşturan alkan?', options: ['Propan', 'Bütan', 'Pentan', 'Hekzan'], correctIndex: 1, explanation: '4 karbon=bütan', difficulty: 1),
    StemQuestion(question: 'CaC₂ + Su ile hangi gaz çıkar?', options: ['Metan', 'Etilen', 'Asetilen', 'Hidrojen'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Siklohekzan ve 1-Hekzen için ortak olan?', options: ['Kapalı formül C₆H₁₂', 'Hibritleşme', 'Br₂ suyunu giderme', 'Geometrik izomeri'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Würtz Sentezi\'nde hangi metal kullanılır?', options: ['Mg', 'Na', 'Al', 'Cu'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Asetilenin trimerleşmesi sonucu ne oluşur?', options: ['Polietilen', 'Benzen', 'Naftalin', 'Bütadien'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '0,1 mol madde 0,2 mol Br₂ harcıyorsa bu madde ne olabilir?', options: ['Alkan', 'Alken', 'Alkin', 'Alkol'], correctIndex: 2, explanation: '1 mol alkin=2 mol Br₂', difficulty: 2),
    StemQuestion(question: 'Hangisi doymuş hidrokarbondur?', options: ['Siklobütan', 'Benzen', 'Vinil klorür', 'Asetilen'], correctIndex: 0, difficulty: 1),
  ],
  formulaCards: const [
    'Alkan: CₙH₂ₙ₊₂ (doymuş, yer değiştirme)',
    'Alken: CₙH₂ₙ (katılma, cis-trans)',
    'Alkin: CₙH₂ₙ₋₂ (uç alkin ayracı: Ag⁺)',
    'Markovnikov: H, H\'si çok olan C\'ye gider',
  ],
);

// ═══════════════════════════════════════════════════════════════
// KİMYA ÜNİTE 4: FONKSİYONEL GRUPLAR
// ═══════════════════════════════════════════════════════════════

final _s12KimU4Content = StemUnitContent(
  unitId: 's12_kim_u4',
  topic: const TopicContent(
    summary: 'Alkoller(R-OH): Primer→Aldehit→Asit. Eterler(R-O-R): Alkol izomeri, uçucu. Aldehitler(R-CHO): Tollens/Fehling ile ayırt. Ketonlar(R-CO-R): Yükseltgenmez. Karboksilik asitler(R-COOH): Zayıf asit. Esterler(R-COOR): Meyve kokusu.',
    rule: 'Primer alkol → Aldehit → Asit (yükseltgenme)\nSekonder alkol → Keton\nTersiyer alkol: Yükseltgenmez!\nEsterleşme: Asit+Alkol ⇌ Ester+Su',
    formulas: [
      'Kaynama: Asit>Alkol>Aldehit>Eter',
      '140°C H₂SO₄: Eter, 170°C: Alken',
      'Tollens: Aldehit → Gümüş aynası',
    ],
    keyPoints: [
      'Formik asit hem aldehit hem asit özelliği gösterir',
      'Ketonlar Tollens/Fehling vermez',
      'Gliserin: 3 OH gruplu poliol',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '2 karbonlu alkol ve eterin adı?',
      steps: ['Alkol: Etanol (Etil alkol)', 'Eter: Dimetil eter', 'İkisi de C₂H₆O, yapı izomeri'],
      answer: 'Etanol ve Dimetil eter',
    ),
    SolvedExample(
      question: '2-propanol yükseltgenirse ne oluşur?',
      steps: ['2-propanol sekonder alkol', 'Sekonder → Keton', 'Ürün: Propanon (Aseton)'],
      answer: 'Propanon (Aseton)',
    ),
    SolvedExample(
      question: 'Etil alkol + Asetik asit = ?',
      steps: ['Asitten: Asetat kökü', 'Alkolden: Etil grubu'],
      answer: 'Etil Asetat',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Glikol (Antifriz) kaç değerlikli alkoldür?', options: ['1 (Mono)', '2 (Diol)', '3 (Triol)', '4'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Eterlerin genel formülü?', options: ['R-OH', 'R-O-R', 'R-CHO', 'R-COOH'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Formaldehit en çok ne için kullanılır?', options: ['Yakıt', 'Ölü doku korunması', 'Gıda', 'İlaç'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Aseton hangi grubun en küçük üyesi?', options: ['Alkol', 'Aldehit', 'Keton', 'Ester'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Karınca asidi (en küçük asit)?', options: ['Asetik asit', 'Formik asit', 'Bütirik asit', 'Propanoik asit'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Esterleşmede su nereden ayrılır?', options: ['Alkolden OH', 'Asitten OH, alkolden H', 'Asitten H', 'Her ikisinden OH'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Hangisi daha uçucu: Alkol mü Eter mi?', options: ['Alkol', 'Eter', 'Aynı', 'Bağlı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Fehling çözeltisi hangi grupla tepkime verir?', options: ['Keton', 'Aldehit', 'Eter', 'Alkol'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sirke asidinin IUPAC adı?', options: ['Metanoik asit', 'Etanoik asit', 'Propanoik asit', 'Büanoik asit'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Tersiyer alkol neden yükseltgenmez?', options: ['Çok kararlı', 'C\'ye bağlı H yok', 'Sıvı değil', 'Asidik'], correctIndex: 1, difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Eter formülü?', options: ['R-OH', 'R-O-R', 'R-CHO', 'R-COOH'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'En küçük keton?', options: ['Metanal', 'Etanal', 'Propanon', 'Bütanon'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Fehling hangi grupla?', options: ['Keton', 'Aldehit', 'Eter', 'Alkol'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Formik asit?', options: ['CH₃COOH', 'HCOOH', 'C₂H₅OH', 'CH₃CHO'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Daha uçucu?', options: ['Alkol', 'Eter', 'Aynı', 'Asit'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisi Tollens ayracı ile gümüş aynası oluşturur?', options: ['Propanol', 'Propanon', 'Propanal', 'Propanoik asit'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Benzer MW\'da kaynama noktası en yüksek olan?', options: ['CH₃OCH₃', 'CH₃CH₂OH', 'CH₃COOH', 'CH₃CHO'], correctIndex: 2, explanation: 'Karboksilik asit dimerleşir', difficulty: 2),
    StemQuestion(question: 'Primer alkol→X→indirgeme→alkol. X nedir?', options: ['Keton', 'Aldehit', 'Ester', 'Eter'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Dimetil eterin alkol izomeri?', options: ['Metanol', 'Etanol', 'Propanol', 'Glikol'], correctIndex: 1, explanation: 'Her ikisi C₂H₆O', difficulty: 1),
    StemQuestion(question: 'Sabunlaşma tepkimesinin yan ürünü?', options: ['Glikoz', 'Gliserin', 'Glikol', 'Etanol'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'C=O grubuna H ve alkil bağlıysa bu bileşik?', options: ['Alkol', 'Keton', 'Aldehit', 'Eter'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '"Kış yeşili yağı" olarak bilinen ester?', options: ['Metil salisilat', 'Etil asetat', 'Metil format', 'Pentil asetat'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Sekonder bütil alkolün yükseltgenme ürünü?', options: ['Bütanal', 'Bütanoik asit', 'Bütanon', 'Dietil eter'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Formik asit (HCOOH) için hangisi doğrudur?', options: ['Hem aldehit hem asit özelliği', 'Yükseltgenemez', 'Fehling ile tepkime vermez', 'Sadece 2 karbonlu'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: 'Hangisi poliol (polialkol)?', options: ['Etanol', 'Fenol', 'Gliserin', 'İzopropanol'], correctIndex: 2, explanation: '3 karbonlu, 3 -OH gruplu', difficulty: 1),
    StemQuestion(question: 'H₂SO₄ katalizörlüğünde 140°C\'de alkol dehidratasyonu sonucu?', options: ['Alken', 'Eter', 'Alkin', 'Aldehit'], correctIndex: 1, explanation: '170°C ⟹ alken', difficulty: 2),
    StemQuestion(question: 'Ketonlar hakkında hangisi yanlıştır?', options: ['En küçük 3 karbonlu', 'Aldehitlerle izomer', 'Yükseltgenerek asit oluşturur', 'İndirgenerek sekonder alkol'], correctIndex: 2, explanation: 'Ketonlar yükseltgenmez', difficulty: 2),
    StemQuestion(question: 'Yağ asitlerinin tuzlarına ne denir?', options: ['Ester', 'Sabun', 'Protein', 'Polimer'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Yandığında eşit mol CO₂ ve H₂O oluşturan bileşik?', options: ['Alkan', 'Doymuş monoasit', 'Doymuş monoalkol', 'Alkin'], correctIndex: 1, explanation: 'CₙH₂ₙO₂: nCO₂=nH₂O', difficulty: 2),
    StemQuestion(question: 'Meyvelere hoş koku veren madde?', options: ['Alkol', 'Aldehit', 'Ester', 'Eter'], correctIndex: 2, difficulty: 1),
  ],
  formulaCards: const [
    'Primer→Aldehit→Asit (yükseltgenme)',
    'Sekonder→Keton, Tersiyer: yükseltgenmez',
    'Esterleşme: Asit+Alkol ⇌ Ester+Su',
    'Tollens: Aldehit → Gümüş aynası',
  ],
);

// ═══════════════════════════════════════════════════════════════
// KİMYA ÜNİTE 5: ENERJİ KAYNAKLARI VE BİLİMSEL GELİŞMELER
// ═══════════════════════════════════════════════════════════════

final _s12KimU5Content = StemUnitContent(
  unitId: 's12_kim_u5',
  topic: const TopicContent(
    summary: 'Fosil Yakıtlar: Kömür(Turba<Linyit<Taş Kömürü<Antrasit), Petrol(Ayrımsal damıtma), Doğalgaz. Alternatif: Güneş, Rüzgar, Jeotermal, Biyokütle, Hidrojen. Nükleer: Fisyon(santral), Füzyon(Güneş). Nanoteknoloji: Grafen, Fulleren.',
    rule: 'Kömür: Turba<Linyit<Taş Kömürü<Antrasit (C% artar)\nPetrol: Ayrımsal damıtma ile ayrılır\nHidrojen: Yanma ürünü sadece su\nNanoteknoloji: 1-100nm boyut aralığı',
    formulas: [
      'Fisyon: Ağır çekirdek parçalanması',
      'Füzyon: Hafif çekirdeklerin birleşmesi',
      'E=mc² (Nükleer enerji)',
    ],
    keyPoints: [
      'Hidrojen: Birim kütle başına en yüksek enerji',
      'Grafen: 2D, çelikten 200 kat güçlü',
      'Türkiye dünya bor rezervinin ~%73\'üne sahip',
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Petrolün rafinerilerde ayrıştırılma yöntemi?',
      steps: ['Petrol karışımdır, bileşenler farklı kaynama noktasına sahip', 'Ayrımsal damıtma ile ayrılır'],
      answer: 'Ayrımsal damıtma',
    ),
    SolvedExample(
      question: 'En kaliteli kömür türü hangisidir?',
      steps: ['Oluşum süreci en uzun: Antrasit', 'Karbon oranı %90-95, ısıl değer en yüksek'],
      answer: 'Antrasit',
    ),
    SolvedExample(
      question: 'Hidrojen yakıt pillerinin avantajı?',
      steps: ['Yanma ürünü sadece su (H₂O)', 'Karbon salınımı sıfır, yüksek enerji yoğunluğu'],
      answer: 'Sıfır karbon, yüksek enerji',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(question: 'Yenilenemeyen enerji kaynaklarına ne denir?', options: ['Alternatif', 'Fosil yakıtlar', 'Biyokütle', 'Nükleer'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'LPG\'nin ana bileşenleri?', options: ['Metan-Etan', 'Propan-Bütan', 'Pentan-Hekzan', 'Etilen-Propilen'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Güneş panellerinde kullanılan yarı iletken?', options: ['Karbon', 'Silisyum', 'Germanyum', 'Bor'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Bitkisel/hayvansal atıklardan elde edilen enerji?', options: ['Jeotermal', 'Biyokütle', 'Nükleer', 'Dalga'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nanometre kaç metredir?', options: ['10⁻⁶', '10⁻⁹', '10⁻¹²', '10⁻³'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Petrolün ana kaynağı?', options: ['Ağaçlar', 'Planktonlar', 'Kömür', 'Mineraller'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangi nükleer tepkime daha yüksek enerji açığa çıkarır?', options: ['Fisyon', 'Füzyon', 'Eşit', 'Bozunma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nanoteknolojide devrim yapan karbon allotropu?', options: ['Elmas', 'Kömür', 'Grafen', 'Antrasit'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Asit yağmurlarına en çok neden olan yakıt?', options: ['Doğalgaz', 'Kömür', 'Benzin', 'Hidrojen'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Sürdürülebilir kalkınma için enerji verimliliği önemli mi?', options: ['Hayır', 'Evet', 'Bazen', 'Sadece sanayide'], correctIndex: 1, difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'LPG bileşenleri?', options: ['Metan-Etan', 'Propan-Bütan', 'Pentan-Hekzan', 'Etilen'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Nanometre?', options: ['10⁻⁶m', '10⁻⁹m', '10⁻¹²m', '10⁻³m'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Daha çok enerji?', options: ['Fisyon', 'Füzyon', 'Eşit', 'Yanma'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'En kaliteli kömür?', options: ['Turba', 'Linyit', 'Taş Kömürü', 'Antrasit'], correctIndex: 3, difficulty: 1),
    StemQuestion(question: 'Güneş paneli elementi?', options: ['C', 'Si', 'Ge', 'B'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Hangisi yenilenebilir enerji kaynağı değildir?', options: ['Rüzgar', 'Doğalgaz', 'Jeotermal', 'Dalga'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Kömür kalite artış sırası?', options: ['Turba<Linyit<Taş K.<Antrasit', 'Antrasit<Taş K.<Linyit<Turba', 'Linyit<Turba<Antrasit<Taş K.', 'Taş K.<Linyit<Turba<Antrasit'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Petrolün ayrımsal damıtılmasıyla en son elde edilen ürün?', options: ['Benzin', 'Gaz yağı', 'LPG', 'Asfalt'], correctIndex: 3, explanation: 'En yüksek kaynama noktası: Asfalt', difficulty: 1),
    StemQuestion(question: 'Hidrojen enerjisi ile ilgili hangisi yanlıştır?', options: ['Doğada serbest H₂ bolca bulunur', 'Depolama maliyetli', 'Çevre dostu', 'Isıl değeri yüksek'], correctIndex: 0, explanation: 'H₂ doğada serbest bulunmaz', difficulty: 2),
    StemQuestion(question: 'Nanoteknoloji hangi boyut aralığıyla ilgilenir?', options: ['1-100nm', '100-500nm', '1-10mm', '10⁻³m'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Grafen allotropu hakkında hangisi söylenebilir?', options: ['3D yapı', 'Sert ama iletmez', 'Tek atom kalınlığında 2D', 'Kırılgan'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Nükleer santrallerde enerji hangi yöntemle üretilir?', options: ['Kontrollü fisyon', 'Kontrolsüz füzyon', 'Kimyasal yanma', 'Radyoaktif bozunma'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Küresel ısınmaya en çok neden olan sera gazı?', options: ['O₂', 'N₂', 'CO₂', 'H₂'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Biyodizel hangi kaynaktan elde edilir?', options: ['Petrol atıkları', 'Bitkisel yağlar', 'Kaya gazı', 'Kömür tozu'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Güneş pilleri (fotovoltaik) ışığı doğrudan neye çevirir?', options: ['Isı', 'Kimyasal enerji', 'Elektrik', 'Mekanik'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Nanotüplerin tıptaki en önemli kullanımı?', options: ['Vücut ısısı ölçmek', 'Hedeflenmiş ilaç taşıma', 'Kan akışı durdurmak', 'Kemik değiştirmek'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Bor madeni ile ilgili hangisi doğrudur?', options: ['Sadece yakıt', 'Türkiye dünya rezervinin ~%73\'ü', 'Fosil yakıt', 'Gümüşten iyi iletken'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Çernobil ve Fukuşima hangi enerji türünün risklerini temsil eder?', options: ['Jeotermal', 'Hidroelektrik', 'Nükleer', 'Rüzgar'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi enerji tasarrufu yöntemi değildir?', options: ['Bina yalıtımı', 'LED kullanmak', 'Fosil yakıt artırmak', 'Geri dönüşüm'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Sürdürülebilirlik kavramı neyi ifade eder?', options: ['Hızla tüketim', 'Gelecek nesilleri tehlikeye atmadan ihtiyaç karşılama', 'Sadece sanayileşme', 'Nüfus durdurmak'], correctIndex: 1, difficulty: 1),
  ],
  formulaCards: const [
    'Kömür: Turba<Linyit<Taş Kömürü<Antrasit',
    'Petrol: Ayrımsal damıtma ile ayrılır',
    'Hidrojen: Yanma ürünü sadece su',
    'Nanoteknoloji: 1-100nm boyut aralığı',
  ],
);
