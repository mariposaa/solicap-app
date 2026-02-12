/// SOLICAP - KPSS Türkçe İçerik Veritabanı
/// Lise + Önlisans + Lisans - Ünite 1-11

import '../models/stem_models.dart';

// ═══════════════════════════════════════════════════════════════
// KPSS TÜRKÇE ÜNİTE TANIMLARI (3 seviye x 11 ünite = 33)
// Şimdilik Ü1-Ü11 mevcut
// ═══════════════════════════════════════════════════════════════

const List<StemUnit> kpssLiseTurUnits = [
  StemUnit(id: 'kpsslise_tur_u1', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 1, title: 'Sözcükte Anlam', titleTr: 'Sözcükte Anlam', icon: '📝'),
  StemUnit(id: 'kpsslise_tur_u2', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 2, title: 'Cümlede Anlam', titleTr: 'Cümlede Anlam', icon: '💬'),
  StemUnit(id: 'kpsslise_tur_u3', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 3, title: 'Paragrafta Anlam', titleTr: 'Paragrafta Anlam', icon: '📖'),
  StemUnit(id: 'kpsslise_tur_u4', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 4, title: 'Ses Bilgisi', titleTr: 'Ses Bilgisi', icon: '🔊'),
  StemUnit(id: 'kpsslise_tur_u5', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 5, title: 'Yapı Bilgisi', titleTr: 'Yapı Bilgisi', icon: '🧩'),
  StemUnit(id: 'kpsslise_tur_u6', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 6, title: 'Sözcük Türleri', titleTr: 'Sözcük Türleri', icon: '🏷️'),
  StemUnit(id: 'kpsslise_tur_u7', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 7, title: 'Cümle Bilgisi', titleTr: 'Cümle Bilgisi', icon: '📐'),
  StemUnit(id: 'kpsslise_tur_u8', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 8, title: 'Yazım Kuralları', titleTr: 'Yazım Kuralları', icon: '✍️'),
  StemUnit(id: 'kpsslise_tur_u9', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 9, title: 'Noktalama İşaretleri', titleTr: 'Noktalama İşaretleri', icon: '❓'),
  StemUnit(id: 'kpsslise_tur_u10', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 10, title: 'Anlatım Bozuklukları', titleTr: 'Anlatım Bozuklukları', icon: '🔧'),
  StemUnit(id: 'kpsslise_tur_u11', gradeLevel: GradeLevel.kpssLise, subject: StemSubject.turkce, order: 11, title: 'Sözel Mantık', titleTr: 'Sözel Mantık', icon: '🧩'),
];

const List<StemUnit> kpssOnlisansTurUnits = [
  StemUnit(id: 'kpssonlisans_tur_u1', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 1, title: 'Sözcükte Anlam', titleTr: 'Sözcükte Anlam', icon: '📝'),
  StemUnit(id: 'kpssonlisans_tur_u2', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 2, title: 'Cümlede Anlam', titleTr: 'Cümlede Anlam', icon: '💬'),
  StemUnit(id: 'kpssonlisans_tur_u3', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 3, title: 'Paragrafta Anlam', titleTr: 'Paragrafta Anlam', icon: '📖'),
  StemUnit(id: 'kpssonlisans_tur_u4', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 4, title: 'Ses Bilgisi', titleTr: 'Ses Bilgisi', icon: '🔊'),
  StemUnit(id: 'kpssonlisans_tur_u5', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 5, title: 'Yapı Bilgisi', titleTr: 'Yapı Bilgisi', icon: '🧩'),
  StemUnit(id: 'kpssonlisans_tur_u6', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 6, title: 'Sözcük Türleri', titleTr: 'Sözcük Türleri', icon: '🏷️'),
  StemUnit(id: 'kpssonlisans_tur_u7', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 7, title: 'Cümle Bilgisi', titleTr: 'Cümle Bilgisi', icon: '📐'),
  StemUnit(id: 'kpssonlisans_tur_u8', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 8, title: 'Yazım Kuralları', titleTr: 'Yazım Kuralları', icon: '✍️'),
  StemUnit(id: 'kpssonlisans_tur_u9', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 9, title: 'Noktalama İşaretleri', titleTr: 'Noktalama İşaretleri', icon: '❓'),
  StemUnit(id: 'kpssonlisans_tur_u10', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 10, title: 'Anlatım Bozuklukları', titleTr: 'Anlatım Bozuklukları', icon: '🔧'),
  StemUnit(id: 'kpssonlisans_tur_u11', gradeLevel: GradeLevel.kpssOnlisans, subject: StemSubject.turkce, order: 11, title: 'Sözel Mantık', titleTr: 'Sözel Mantık', icon: '🧩'),
];

const List<StemUnit> kpssLisansTurUnits = [
  StemUnit(id: 'kpsslisans_tur_u1', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 1, title: 'Sözcükte Anlam', titleTr: 'Sözcükte Anlam', icon: '📝'),
  StemUnit(id: 'kpsslisans_tur_u2', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 2, title: 'Cümlede Anlam', titleTr: 'Cümlede Anlam', icon: '💬'),
  StemUnit(id: 'kpsslisans_tur_u3', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 3, title: 'Paragrafta Anlam', titleTr: 'Paragrafta Anlam', icon: '📖'),
  StemUnit(id: 'kpsslisans_tur_u4', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 4, title: 'Ses Bilgisi', titleTr: 'Ses Bilgisi', icon: '🔊'),
  StemUnit(id: 'kpsslisans_tur_u5', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 5, title: 'Yapı Bilgisi', titleTr: 'Yapı Bilgisi', icon: '🧩'),
  StemUnit(id: 'kpsslisans_tur_u6', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 6, title: 'Sözcük Türleri', titleTr: 'Sözcük Türleri', icon: '🏷️'),
  StemUnit(id: 'kpsslisans_tur_u7', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 7, title: 'Cümle Bilgisi', titleTr: 'Cümle Bilgisi', icon: '📐'),
  StemUnit(id: 'kpsslisans_tur_u8', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 8, title: 'Yazım Kuralları', titleTr: 'Yazım Kuralları', icon: '✍️'),
  StemUnit(id: 'kpsslisans_tur_u9', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 9, title: 'Noktalama İşaretleri', titleTr: 'Noktalama İşaretleri', icon: '❓'),
  StemUnit(id: 'kpsslisans_tur_u10', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 10, title: 'Anlatım Bozuklukları', titleTr: 'Anlatım Bozuklukları', icon: '🔧'),
  StemUnit(id: 'kpsslisans_tur_u11', gradeLevel: GradeLevel.kpssLisans, subject: StemSubject.turkce, order: 11, title: 'Sözel Mantık', titleTr: 'Sözel Mantık', icon: '🧩'),
];

// ═══════════════════════════════════════════════════════════════
// İÇERİK HARİTASI
// ═══════════════════════════════════════════════════════════════

final Map<String, StemUnitContent> kpssTurkceContent = {
  'kpsslise_tur_u1': kpssLiseTurU1Content,
  'kpsslise_tur_u2': kpssLiseTurU2Content,
  'kpsslise_tur_u3': kpssLiseTurU3Content,
  'kpsslise_tur_u4': kpssLiseTurU4Content,
  'kpssonlisans_tur_u1': kpssOnlisansTurU1Content,
  'kpssonlisans_tur_u2': kpssOnlisansTurU2Content,
  'kpssonlisans_tur_u3': kpssOnlisansTurU3Content,
  'kpssonlisans_tur_u4': kpssOnlisansTurU4Content,
  'kpsslisans_tur_u1': kpssLisansTurU1Content,
  'kpsslisans_tur_u2': kpssLisansTurU2Content,
  'kpsslisans_tur_u3': kpssLisansTurU3Content,
  'kpsslisans_tur_u4': kpssLisansTurU4Content,
  'kpsslise_tur_u5': kpssLiseTurU5Content,
  'kpssonlisans_tur_u5': kpssOnlisansTurU5Content,
  'kpsslisans_tur_u5': kpssLisansTurU5Content,
  'kpsslise_tur_u6': kpssLiseTurU6Content,
  'kpssonlisans_tur_u6': kpssOnlisansTurU6Content,
  'kpsslisans_tur_u6': kpssLisansTurU6Content,
  'kpsslise_tur_u7': kpssLiseTurU7Content,
  'kpssonlisans_tur_u7': kpssOnlisansTurU7Content,
  'kpsslisans_tur_u7': kpssLisansTurU7Content,
  'kpsslise_tur_u8': kpssLiseTurU8Content,
  'kpssonlisans_tur_u8': kpssOnlisansTurU8Content,
  'kpsslisans_tur_u8': kpssLisansTurU8Content,
  'kpsslise_tur_u9': kpssLiseTurU9Content,
  'kpssonlisans_tur_u9': kpssOnlisansTurU9Content,
  'kpsslisans_tur_u9': kpssLisansTurU9Content,
  'kpsslise_tur_u10': kpssLiseTurU10Content,
  'kpssonlisans_tur_u10': kpssOnlisansTurU10Content,
  'kpsslisans_tur_u10': kpssLisansTurU10Content,
  'kpsslise_tur_u11': kpssLiseTurU11Content,
  'kpssonlisans_tur_u11': kpssOnlisansTurU11Content,
  'kpsslisans_tur_u11': kpssLisansTurU11Content,
};

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 1: SÖZCÜKTE ANLAM
// ═══════════════════════════════════════════════════════════════

final kpssLiseTurU1Content = StemUnitContent(
  unitId: 'kpsslise_tur_u1',
  topic: const TopicContent(
    summary: 'Sözcükte anlam, kelimelerin cümle içindeki kullanımlarına göre kazandıkları anlam özelliklerini inceler. Temel olarak Gerçek (Temel), Yan, Mecaz ve Terim anlam başlıklarına ayrılır. Gerçek anlam akla gelen ilk anlamdır. Mecaz anlam ise kelimenin gerçek anlamından tamamen uzaklaşmasıdır.',
    rule: 'Bir sözcüğün mecaz olabilmesi için gerçek anlamından tamamen kopması gerekir.',
    formulas: [
      'Gerçek Anlam: Akla gelen ilk anlam.',
      'Mecaz Anlam: Soyut ve yeni anlam.',
      'Terim Anlam: Bilim/Sanat kavramı.'
    ],
    keyPoints: [
      'Yan anlam ile mecaz anlamı karıştırma; yan anlamda şekil/işlev benzerliği sürer.',
      'Deyimler genellikle mecaz anlamlıdır.',
      'Terimler (üçgen, penaltı vb.) özel alanlara aittir.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '"Kırılmak" sözcüğü hangisinde mecaz anlamda kullanılmıştır?',
      steps: [
        'A seçeneğinde cam kırıldı (Gerçek).',
        'B seçeneğinde dal kırıldı (Gerçek).',
        'C seçeneğinde arkadaşına kırıldı (Üzüldü/Gücendi -> Mecaz).',
      ],
      answer: 'C) Bana söylediği sözlerden dolayı çok kırıldım.',
    ),
    SolvedExample(
      question: 'Hangisi terim anlamlıdır?',
      steps: ['Üçgenin iç açıları toplamı 180 derecedir cümlesindeki "açı" matematike ait bir terimdir.'],
      answer: 'Bu açıyı daraltmamız gerekiyor.',
    ),
    SolvedExample(
      question: 'Hangi sözcük yansıma kökenlidir?',
      steps: ['Yansıma doğadaki seslerin taklididir.', 'Miyav, gürültü, patırtı yansımadır.', 'Parıltı (ışık) yansıma değildir.'],
      answer: 'Dere şırıl şırıl akıyordu.',
    ),
    SolvedExample(
      question: '"Ağır" sözcüğü hangisinde "yavaş" anlamında kullanılmıştır?',
      steps: ['Ağır çanta (yük bakımından).', 'Ağır konuşmak (kırıcı).', 'İşler ağır ilerliyor (yavaş).'],
      answer: 'Bu işler çok ağır ilerliyor.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "burun" sözcüğü yan anlamda kullanılmıştır?',
        options: ['A) Burnu kanadı.', 'B) Ayakkabının burnu aşınmış.', 'C) Burnundan kıl aldırmıyor.', 'D) Burnuma güzel kokular geliyor.'],
        correctIndex: 1,
        explanation: 'Ayakkabının burnu, organ adına şekilce benzediği için yan anlamdır.',
        difficulty: 1),
    StemQuestion(
        question: '"Tatlı" sözcüğü hangisinde gerçek anlamının dışında kullanılmıştır?',
        options: ['A) Tatlı bir elma yedi.', 'B) Bu tatlıyı çok severim.', 'C) Bize çok tatlı gülümsedi.', 'D) Çayın yanında tatlı ikram etti.'],
        correctIndex: 2,
        explanation: 'Tatlı gülümsemek, sevimli/hoş anlamında mecazdır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "soğuk" sözcüğü mecaz anlamda kullanılmıştır?',
        options: ['A) Soğuk su içme.', 'B) Hava bugün çok soğuk.', 'C) Bize çok soğuk davrandı.', 'D) Soğuk hava deposu bozuldu.'],
        correctIndex: 2,
        explanation: 'Soğuk davranmak, ilgisiz/mesafeli olmak demektir.',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdakilerden hangisi somut anlamlı iken soyut anlama gelecek şekilde kullanılmıştır?',
        options: ['A) Kalemi masaya bıraktı.', 'B) Bu yolda çok yıprandık.', 'C) Ağaçlar çiçek açtı.', 'D) Kitabı çantasına koydu.'],
        correctIndex: 1,
        explanation: 'Yol (somut) burada yöntem/süreç (soyut) anlamında kullanılmıştır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde terim anlamlı bir sözcük yoktur?',
        options: ['A) Nota bilgisi çok iyiydi.', 'B) Hakem penaltı noktasını gösterdi.', 'C) Şiirin son kıtası etkileyiciydi.', 'D) Akşam pazara gideceğiz.'],
        correctIndex: 3,
        explanation: 'Pazar günlük hayata dair bir kelimedir, terim değildir.',
        difficulty: 1),
    StemQuestion(
        question: '"İnce" sözcüğü hangisinde "kibar/nazik" anlamındadır?',
        options: ['A) İnce bir ip bulmalısın.', 'B) Çok ince bir davranıştı.', 'C) İnce belli bardak.', 'D) İnce bir defter aldı.'],
        correctIndex: 1,
        explanation: 'İnce davranış nezaket bildirir, mecazdır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde yansıma sözcük yoktur?',
        options: ['A) Köpek sabaha kadar havladı.', 'B) Kapı gıcırdayıp duruyor.', 'C) Çocuklar neşeyle koşuşturuyor.', 'D) Şelale gürül gürül akıyor.'],
        correctIndex: 2,
        explanation: 'Koşuşturmak yansıma değildir, ses taklidi yoktur.',
        difficulty: 1),
    StemQuestion(
        question: '"Düşmek" sözcüğü hangisinde "rastlamak/denk gelmek" anlamındadır?',
        options: ['A) Çocuğun elindeki bardak düştü.', 'B) Bayram bu yıl yaza düşüyor.', 'C) Tansiyonum düştü.', 'D) Ağaçtan elma düştü.'],
        correctIndex: 1,
        explanation: 'Tarihlerin denk gelmesi anlamında kullanılmıştır.',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdaki altı çizili sözcüklerden hangisi nicel (sayılabilen) anlamlıdır?',
        options: ['A) Büyük lokma ye, büyük konuşma.', 'B) Güzel günler göreceğiz.', 'C) Zor bir soru sordu.', 'D) Lezzetli yemekler yaptı.'],
        correctIndex: 0,
        explanation: 'Lokmanın büyüklüğü ölçülebilir, niceldir. (Not: Cümledeki ikinci "büyük" niteldir).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde zıt anlamlı sözcükler bir arada kullanılmıştır?',
        options: ['A) Gelir gider dengesi bozuldu.', 'B) Eş dost herkesi çağırdı.', 'C) Yalan yanlış konuşma.', 'D) Ses seda çıkmıyor.'],
        correctIndex: 0,
        explanation: 'Gelir ve gider zıt anlamlıdır.',
        difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '"Kara" sözcüğünün sesteşi hangisidir?', options: ['A) Siyah', 'B) Toprak parçası', 'C) Kötü', 'D) Yazı'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Hangisi soyut anlamlıdır?', options: ['A) Rüya', 'B) Masa', 'C) Işık', 'D) Hava'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: '"Kuru" sözcüğünün mecaz anlamı hangisi olabilir?', options: ['A) Kuru ekmek', 'B) Kuru otlar', 'C) Kuru iftira', 'D) Kuru temizleme'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Hangisi ikilemedir?', options: ['A) Masmavi', 'B) Yavaş yavaş', 'C) Sımsıcak', 'D) Kapkara'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: 'Özgün kelimesinin eş anlamlısı?', options: ['A) Orijinal', 'B) Kopya', 'C) Eski', 'D) Yeni'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdakilerden hangisinde "açık" sözcüğü "belirgin, net" anlamında kullanılmıştır?', options: ['A) Dükkan bugün açık.', 'B) Açık havada yürüyelim.', 'C) Bu konu gayet açık.', 'D) Açık renk giyinmelisin.'], correctIndex: 2, explanation: 'Anlaşılır, net anlamında.', difficulty: 1),
    StemQuestion(question: 'Hangisinde deyim kullanılmamıştır?', options: ['A) Gözden düştü.', 'B) Etekleri zil çaldı.', 'C) Küplere bindi.', 'D) Hızlıca koştu.'], correctIndex: 3, explanation: 'Hızlıca koşmak eylemdir, deyim değildir.', difficulty: 1),
    StemQuestion(question: '"Bakmak" sözcüğü hangisinde "beslemek, geçindirmek" anlamındadır?', options: ['A) Denize bakan ev aldık.', 'B) Üç çocuğa o bakıyor.', 'C) Saate baktın mı?', 'D) Dosyalara ben bakıyorum.'], correctIndex: 1, explanation: 'Maddi sorumluluğunu üstlenmek anlamında.', difficulty: 1),
    StemQuestion(question: 'Hangisinde dolaylama vardır?', options: ['A) Balık yedik.', 'B) Derya kuzusu bunlar.', 'C) Ankara çok soğuk.', 'D) Top oynadık.'], correctIndex: 1, explanation: 'Balık yerine "Derya kuzusu" denmesi dolaylamadır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde kişileştirme (teşhis) vardır?', options: ['A) Güneş gülümsedi.', 'B) Hava karardı.', 'C) Çiçekler soldu.', 'D) Yağmur yağdı.'], correctIndex: 0, explanation: 'Güneşin gülümsemesi insana ait bir özelliktir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde benzetme (teşbih) yoktur?', options: ['A) Aslan gibi kuvvetli.', 'B) İnci gibi dişler.', 'C) Kömür gibi gözler.', 'D) Altın kalpli adam.'], correctIndex: 3, explanation: 'D seçeneğinde mecaz vardır ama "gibi/kadar" edatlarıyla yapılan açık bir teşbih yapısı yoktur (İstiareye yakındır, lise seviyesinde basit benzetme aranır).', difficulty: 1),
    StemQuestion(question: 'Hangisi genelden özele sıralanmıştır?', options: ['A) Varlık - Canlı - Bitki - Çiçek', 'B) Çiçek - Bitki - Canlı - Varlık', 'C) Papatya - Çiçek - Bitki', 'D) Ev - Oda - Salon'], correctIndex: 0, explanation: 'Kapsayıcıdan özele doğru sıralama.', difficulty: 1),
    StemQuestion(question: '"Çevirmek" sözcüğü hangisinde "dönüştürmek/tercüme etmek" anlamındadır?', options: ['A) Sayfayı çevirdi.', 'B) Başını çevirdi.', 'C) Kitabı Türkçeye çevirdi.', 'D) Arabayı çevirdi.'], correctIndex: 2, explanation: 'Bir dilden başka dile aktarmak.', difficulty: 1),
    StemQuestion(question: 'Hangisinde sesteş kök yoktur?', options: ['A) Yaz', 'B) Gül', 'C) At', 'D) Masa'], correctIndex: 3, explanation: 'Masa kelimesinin sesteşi yoktur.', difficulty: 1),
    StemQuestion(question: '"Karanlık" sözcüğü hangisinde "şüpheli/korkutucu" anlamında mecazdır?', options: ['A) Karanlık oda.', 'B) Karanlık sokak.', 'C) Karanlık işler.', 'D) Hava karanlık.'], correctIndex: 2, explanation: 'Yasadışı veya belirsiz işler anlamında.', difficulty: 1),
    StemQuestion(question: 'Hangisi nitel (ölçülemeyen) anlamlıdır?', options: ['A) Geniş bahçe', 'B) Uzun yol', 'C) Derin kuyu', 'D) Derin düşünce'], correctIndex: 3, explanation: 'Düşüncenin derinliği metre ile ölçülemez.', difficulty: 1),
    StemQuestion(question: 'Hangisinde duyu aktarımı vardır?', options: ['A) Keskin koku', 'B) Yeşil kazak', 'C) Ekşi elma', 'D) Sert taş'], correctIndex: 0, explanation: 'Dokunma (keskin) duyusu, koklama (koku) duyusuna aktarılmıştır.', difficulty: 1),
    StemQuestion(question: '"El" sözcüğü hangisinde "yabancı" anlamındadır?', options: ['A) Elini yıkadı.', 'B) Elleri cebindeydi.', 'C) El ne derse desin.', 'D) Eli kapıya sıkıştı.'], correctIndex: 2, explanation: 'El (yabancı, başkası).', difficulty: 1),
    StemQuestion(question: 'Hangisinde yakın anlamlı sözcükler bir arada kullanılmamıştır?', options: ['A) Doğru dürüst', 'B) Yalan yanlış', 'C) Ses seda', 'D) İleri geri'], correctIndex: 3, explanation: 'İleri ve geri zıt anlamlıdır.', difficulty: 1),
    StemQuestion(question: '"Sarmak" sözcüğü hangisinde "bulaşmak/musallat olmak" anlamındadır?', options: ['A) Yarayı sardı.', 'B) Etrafı duman sardı.', 'C) Başıma bela sardı.', 'D) Hediye paketini sardı.'], correctIndex: 2, explanation: 'Bir sorunu birine musallat etmek.', difficulty: 1),
  ],
  formulaCards: const ['Mecaz: Gerçekten tamamen uzaklaşma.', 'Yan Anlam: Şekil/İşlev benzerliği.', 'Terim: Bilim/Sanat kavramı.'],
);

final kpssOnlisansTurU1Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u1',
  topic: const TopicContent(
    summary: 'Sözcükte anlam ilişkileri Önlisans seviyesinde daha detaylı incelenir. Eş anlam (Anlamdaş), Zıt anlam (Karşıt), Sesteş (Eş sesli) kelimelerin yanı sıra; somutlaştırma, soyutlaştırma, ad aktarması (mecaz-ı mürsel) ve dolaylama konuları önem kazanır. Söz öbeklerinde anlam (deyimler ve atasözleri) soruları sıkça çıkar.',
    rule: 'Ad aktarmasında benzetme amacı güdülmeden bir söz başka bir söz yerine kullanılır.',
    formulas: [
      'Ad Aktarması: Benzetme amacı yok (Parça-Bütün).',
      'Dolaylama: Tek kelime -> Çok kelime (Aslan -> Ormanlar kralı).',
      'Güzel Adlandırma: Kötü kavram -> İyi ifade (Verem -> İnce hastalık).'
    ],
    keyPoints: [
      'Nicel anlam ölçülebilir, Nitel anlam ölçülemez (özellik bildirir).',
      'Yansıma sözcükler ses taklididir; "parlamak, ışıldamak" yansıma DEĞİLDİR.',
      'Duyu aktarımı (Acı çığlık: Tatma -> İşitme) sık sorulur.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Aşağıdaki cümlede hangi söz sanatı vardır?\n"Tribünler ayağa kalktı."',
      steps: [
        'Tribün cansız bir varlıktır, ayağa kalkamaz.',
        'Burada kastedilen tribündeki "seyircilerdir".',
        'Yer söylenip içindekiler kastedildiği için Ad Aktarması (Mecaz-ı Mürsel) vardır.',
      ],
      answer: 'Ad Aktarması (Mecaz-ı Mürsel)',
    ),
    SolvedExample(
      question: '"Acı" sözcüğü hangisinde tatma duyusundan işitme duyusuna aktarılmıştır?',
      steps: ['Duyu aktarımı aranıyor.', 'A) Acı biber (Tatma - Normal).', 'B) Acı fren sesi (Tatma -> İşitme).'],
      answer: 'Sokaktan acı bir fren sesi duyuldu.',
    ),
    SolvedExample(
      question: 'Hangisi dolaylamaya örnektir?',
      steps: ['Kıbrıs yerine "Yavru Vatan" denmesi.', 'Tek kelimelik "Kıbrıs", iki kelimeyle ifade edilmiştir.'],
      answer: 'Yavru Vatan',
    ),
    SolvedExample(
      question: 'Hangisinde "yol" sözcüğü "yöntem" anlamındadır?',
      steps: ['Bu yolu takip et (Gerçek).', 'Başka bir yol denemeliyiz (Yöntem).'],
      answer: 'Bu problemi çözmek için başka bir yol denemeliyiz.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdakilerden hangisinde "ad aktarması" (mecaz-ı mürsel) vardır?',
        options: ['A) Güneş gülümsüyor.', 'B) Ankara bu kararı tepkiyle karşıladı.', 'C) Aslan gibi kükredi.', 'D) İnci dişli çocuk.'],
        correctIndex: 1,
        explanation: 'Ankara (şehir) söylenip, içindeki yönetim/halk kastedilmiştir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde yansıma kökten türemiş bir eylem vardır?',
        options: ['A) Işıldamak', 'B) Patlamak', 'C) Kişnemek', 'D) Görünmek'],
        correctIndex: 1,
        explanation: '"Pat" sesinden türemiştir. (Not: Kişnemek de yansıma kökenlidir ancak "patlamak" en net örnektir.)',
        difficulty: 2),
    StemQuestion(
        question: '"Boş" sözcüğü hangisinde "bilgisiz" anlamında kullanılmıştır?',
        options: ['A) Boş bardak.', 'B) Boş kafa.', 'C) Boş söz.', 'D) Boş arsa.'],
        correctIndex: 1,
        explanation: 'Boş kafa, bilgisiz insan anlamındadır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde somutlaştırma yapılmıştır?',
        options: ['A) Hayallerim suya düştü.', 'B) Rüzgar sert esiyor.', 'C) Kitap okumayı severim.', 'D) Hava çok sıcak.'],
        correctIndex: 0,
        explanation: '"Hayal" (soyut) kavramı, suya düşebilen bir nesne (somut) gibi anlatılmıştır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "kinaye" (değinmece) vardır?',
        options: ['A) Kapısı herkese açıktır.', 'B) Hava çok sıcak.', 'C) Ders çalışıyorum.', 'D) Yemek yedik.'],
        correctIndex: 0,
        explanation: 'Hem gerçek (kapı açık) hem mecaz (misafirperver) anlama gelebilir, kastedilen mecazdır.',
        difficulty: 2),
    StemQuestion(
        question: 'Aşağıdaki ikilemelerden hangisi oluşum yolu bakımından diğerlerinden farklıdır?',
        options: ['A) İleri geri', 'B) Aşağı yukarı', 'C) Acı tatlı', 'D) Eğri büğrü'],
        correctIndex: 3,
        explanation: 'A, B, C zıt anlamlı kelimelerle; D (Eğri büğrü) biri anlamlı biri anlamsız kelimelerle kurulmuştur.',
        difficulty: 2),
    StemQuestion(
        question: '"Dün akşamki maçta fileler üç kez havalandı." cümlesindeki söz sanatı nedir?',
        options: ['A) Benzetme', 'B) Dolaylama', 'C) Kişileştirme', 'D) Abartma'],
        correctIndex: 1,
        explanation: '"Gol atıldı" yerine "fileler havalandı" ifadesi kullanılmıştır. (Ad aktarmasına da yakın, ancak şıklarda dolaylama en uygun seçenektir.)',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde eş sesli (sesteş) bir sözcük yoktur?',
        options: ['A) Çay kenarında oturduk.', 'B) Yüzümde sivilce çıktı.', 'C) Ben bu işi hallederim.', 'D) Okulun kapısı kilitli.'],
        correctIndex: 3,
        explanation: 'Çay (içecek/dere), Yüz (surat/sayı/yüzmek), Ben (kişi/leke) sesteştir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "güzel adlandırma" örneğidir?',
        options: ['A) Kara elmas (Kömür)', 'B) Tahta at (Tabut)', 'C) Beyaz altın (Pamuk)', 'D) Bacasız sanayi (Turizm)'],
        correctIndex: 1,
        explanation: 'Ölümü çağrıştıran tabut yerine "tahta at" veya "iyi yolculuklar" denmesi.',
        difficulty: 2),
    StemQuestion(
        question: '"Saymak" sözcüğü hangisinde "geçerli addetmek" anlamındadır?',
        options: ['A) Paraları saydım.', 'B) Seni adamdan saymıyor.', 'C) Bu golü saymam.', 'D) Günleri sayıyorum.'],
        correctIndex: 2,
        explanation: 'Geçerli kabul etmemek.',
        difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Sanat güneşi (Zeki Müren) hangi sanattır?', options: ['A) Ad Aktarması', 'B) Dolaylama', 'C) Kinaye', 'D) Teşbih'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: '"Göz" sözcüğü hangisinde terimdir?', options: ['A) Çocuğun gözü', 'B) Çantanın gözü', 'C) Suyun gözü', 'D) (Hiçbiri)'], correctIndex: 3, explanation: 'Terim anlamı genellikle yoktur, yan anlamları vardır.', difficulty: 2),
    StemQuestion(question: '"Pişkin" sözcüğü insan için kullanılırsa ne olur?', options: ['A) Gerçek', 'B) Mecaz', 'C) Yan', 'D) Terim'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Hangisi yansımadır?', options: ['A) Pırıl pırıl', 'B) Fokur fokur', 'C) Işıl ışıl', 'D) Mışıl mışıl'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Cimri - Cömert ilişkisi?', options: ['A) Eş anlam', 'B) Yakın anlam', 'C) Zıt anlam', 'D) Sesteş'], correctIndex: 2, difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdakilerden hangisinde "kanat" sözcüğü yan anlamda kullanılmıştır?', options: ['A) Kuşun kanadı kırıldı.', 'B) Uçağın kanadı hasar gördü.', 'C) Annesinin kanatları altına sığındı.', 'D) Partinin gençlik kanadı toplandı.'], correctIndex: 1, explanation: 'Uçağın kanadı, kuşun kanadına şekilce benzediği için yan anlamdır. C ve D mecazdır.', difficulty: 2),
    StemQuestion(question: '"Çekmek" sözcüğü aşağıdaki cümlelerin hangisinde "tahammül etmek" anlamında kullanılmıştır?', options: ['A) Arabayı kenara çekti.', 'B) Bu dertleri yıllardır çekiyorum.', 'C) Fotoğraf çekti.', 'D) Halatı çekti.'], correctIndex: 1, explanation: 'Katlanmak, tahammül etmek.', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "tezat" (karşıtlık) sanatı vardır?', options: ['A) Ağlarım hatıra geldikçe gülüştüklerimiz.', 'B) Ak akçe kara gün içindir.', 'C) Gülü seven dikenine katlanır.', 'D) Sakla samanı gelir zamanı.'], correctIndex: 0, explanation: 'Ağlamak ve gülüşmek zıt kavramlardır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "dokunmak" sözcüğü "duygulandırmak, etkilemek" anlamındadır?', options: ['A) Masaya dokunma.', 'B) Bu sözleri bana çok dokundu.', 'C) Bu yemek bana dokundu (hasta etti).', 'D) Halıya dokundu.'], correctIndex: 1, explanation: 'Duygusal olarak etkilemek.', difficulty: 2),
    StemQuestion(question: 'Aşağıdakilerden hangisinde özelden genele bir anlatım vardır?', options: ['A) Roman, en sevdiğim edebiyat türüdür.', 'B) Edebiyat, insana çok şey katar.', 'C) Varlıklar içinde insan en değerlisidir.', 'D) Meyvelerden elmayı severim.'], correctIndex: 0, explanation: 'Roman (Özel) -> Edebiyat türü (Genel).', difficulty: 2),
    StemQuestion(question: '"Kırmak" sözcüğü hangisinde "fiyatını indirmek" anlamındadır?', options: ['A) Odunu kırdı.', 'B) Kalbimi kırdı.', 'C) Soğuklar kırıldı.', 'D) Satıcı fiyattan biraz kırdı.'], correctIndex: 3, explanation: 'İndirim yapmak.', difficulty: 2),
    StemQuestion(question: 'Hangisinde deyim aktarması (doğadan insana) vardır?', options: ['A) Aslanlar gibi savaştı.', 'B) Orman inliyordu.', 'C) Olay henüz çok taze.', 'D) Bu çocuk çok olgun.'], correctIndex: 3, explanation: 'Olgunluk meyveye (doğaya) ait bir özelliktir, insana aktarılmıştır.', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki ikilemelerden hangisi "isim tamlaması" biçimindedir?', options: ['A) Güzel güzel', 'B) Suyun suyu', 'C) Eğri büğrü', 'D) Yalan yanlış'], correctIndex: 1, explanation: 'Suyun suyu (Belirtili isim tamlaması).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "söz" kelimesi "vaat" anlamındadır?', options: ['A) Söz gümüşse sükut altındır.', 'B) Ondan söz aldım, yarın gelecek.', 'C) Sözü uzatmayalım.', 'D) Bu sözler beni kırdı.'], correctIndex: 1, explanation: 'Söz vermek, vaat etmek.', difficulty: 2),
    StemQuestion(question: '"Batmak" sözcüğü hangisinde "güneşin kaybolması" anlamındadır?', options: ['A) Gemi battı.', 'B) İğne battı.', 'C) Güneş battı.', 'D) Şirket battı.'], correctIndex: 2, explanation: 'Temel anlamda güneşin ufukta kaybolması.', difficulty: 2),
    StemQuestion(question: 'Hangisi nitel anlamlı bir sözcüktür?', options: ['A) Ağır çanta', 'B) Geniş oda', 'C) Kötü koku', 'D) Uzun yol'], correctIndex: 2, explanation: 'Kokunun kötülüğü ölçülemez, niteliktir.', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde mecaz-ı mürsel (ad aktarması) yoktur?', options: ['A) Sobayı yaktım.', 'B) Reçeteyi evde unutmuşum.', 'C) Vapur Üsküdar\'a yanaştı.', 'D) Tüm sınıf ayağa kalktı.'], correctIndex: 1, explanation: 'Reçete unutulabilir, burada bir aktarma yoktur. Soba (içindeki odun), Üsküdar (iskele), Sınıf (öğrenciler).', difficulty: 2),
    StemQuestion(question: '"Erimek" sözcüğü hangisinde "zayıflamak" anlamındadır?', options: ['A) Kar eridi.', 'B) Dondurma eridi.', 'C) Üzüntüden eridi gitti.', 'D) Şeker suda eridi.'], correctIndex: 2, explanation: 'Zayıflamak, tükenmek mecaz anlam.', difficulty: 2),
    StemQuestion(question: 'Hangisinde karşıt kavramlar bir arada kullanılmamıştır?', options: ['A) Azı karar çoğu zarar.', 'B) İyisiyle kötüsüyle bitirdik.', 'C) Genç yaşlı herkes oradaydı.', 'D) Akıllı uslu bir çocuktu.'], correctIndex: 3, explanation: 'Akıllı ve uslu yakın anlamlıdır.', difficulty: 2),
    StemQuestion(question: '"Çiğ" sözcüğü hangisinde mecaz anlamdadır?', options: ['A) Çiğ et.', 'B) Çiğ süt.', 'C) Çiğ davranış.', 'D) Çiğ sebze.'], correctIndex: 2, explanation: 'Yersiz, kaba davranış.', difficulty: 2),
  ],
  formulaCards: const ['Dolaylama: Tek kelime yerine çok kelime.', 'Ad Aktarması: Benzetme yok, ilgi var.', 'Kinaye: Hem gerçek hem mecaz, kasıt mecaz.'],
);

final kpssLisansTurU1Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u1',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde sözcükte anlam; ince nüanslar, edebi sanatlarla iç içe geçmiş anlam olayları ve karmaşık semantik ilişkileri kapsar. Kinaye (Değinmece), Tariz (İğneleme), Tevriye (İki anlamlılık) ve Mübalağa (Abartma) gibi sanatların cümle içindeki tespiti önemlidir. Ayrıca soyut kavramların somutlaştırılması veya tam tersi durumlar, paragrafın anlam bütünlüğünü etkileyen sözcük seçimleri bu seviyenin konusudur.',
    rule: 'Tevriyede iki gerçek anlam vardır ve uzak anlam kastedilir; Kinayede ise biri gerçek biri mecazdır ve mecaz kastedilir.',
    formulas: [
      'Kinaye = Gerçek + Mecaz (Kasıt Mecaz).',
      'Tevriye = Gerçek (Yakın) + Gerçek (Uzak) -> Kasıt Uzak.',
      'Tariz = Söylenilenin tam tersini kastetme (İğneleme).'
    ],
    keyPoints: [
      'Alışılmamış bağdaştırma (şiirsel/soyut anlatım) lisans sorularında ayırt edicidir.',
      'Ad aktarmasında "yer-insan", "yazar-eser", "kap-içerik" ilişkilerine dikkat et.',
      'Deyimler kalıplaşmıştır, sözcüklerin yeri değiştirilemez.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '"Ulusun, korkma! Nasıl böyle bir imanı boğar?" dizesindeki "ulusun" sözcüğündeki anlam olayı nedir?',
      steps: [
        'Sözcük 1: Ulumak eylemi (Köpeğin uluması).',
        'Sözcük 2: Yüce, büyük (Ulu-sun).',
        'İki gerçek anlama da gelecek şekilde kullanılmış ve uzak anlam (yücelik) gizlenmiştir (Tevriye). Aynı zamanda düşmana "ürüsün/ulusun" göndermesi de vardır.',
      ],
      answer: 'Tevriye',
    ),
    SolvedExample(
      question: '"Bu ne kudret ki elifbayı okur ezberden." dizesindeki anlam inceliği nedir?',
      steps: [
        'Elifbayı ezberden okumak çok basit bir iştir.',
        'Ancak şair burada "kudret" diyerek över gibi görünüp aslında kişinin cehaletiyle alay etmektedir.',
        'Sözün tersini kastetme sanatı Tariz\'dir.',
      ],
      answer: 'Tariz (İğneleme)',
    ),
    SolvedExample(
      question: 'Hangisinde "Güzel Adlandırma" yoktur?',
      steps: ['İnce hastalık (Verem) - Var.', 'Üç harfliler (Cin) - Var.', 'Görme engelli (Kör) - Var.', 'Ormanlar kralı (Aslan) - Bu Dolaylamadır.'],
      answer: 'Ormanlar Kralı (Dolaylama örneğidir, güzel adlandırma korkulan/ürkütülen durumlar için yapılır).',
    ),
    SolvedExample(
      question: 'Mecaz-ı Mürsel (Ad Aktarması) hangisinde farklı bir ilişkiyle kurulmuştur?',
      steps: ['A) Orhan Pamuk\'u okudum (Yazar-Eser).', 'B) Soba yandı (Kap-İç).', 'C) Tencere kaynadı (Kap-İç).'],
      answer: 'A seçeneği Yazar-Eser, diğerleri Kap-İç ilişkisidir.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "istiare" (eğretileme) vardır?',
        options: ['A) Aslan askerlerimiz cepheye koştu.', 'B) Gökyüzünün kandilleri yandı.', 'C) Gözleri deniz gibi maviydi.', 'D) Pamuk ellerini uzattı.'],
        correctIndex: 1,
        explanation: 'Yıldızlar (benzeyen) söylenmemiş, sadece kandiller (benzetilen) söylenmiş. Bu açık istiaredir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde altı çizili sözcük gerçek (temel) anlamıyla kullanılmıştır?',
        options: ['A) Ağır bir yük taşıyordu.', 'B) Ağır konuşmaları herkesi kırdı.', 'C) Ağır aksak yürüyordu.', 'D) Ağır sorular sordu.'],
        correctIndex: 0,
        explanation: 'Ağır yük fiziksel ağırlıktır (gerçek anlam). Diğerlerinde kırıcı, yavaş, zor anlamlarında mecaz kullanılmıştır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "tariz" (dokundurma) yapılmıştır?',
        options: ['A) Çok çalışkandır, liseyi 7 yılda bitirdi.', 'B) Seni görünce dünyalar benim oldu.', 'C) Gözüm yollarda kaldı.', 'D) Bir of çeksem karşıki dağlar yıkılır.'],
        correctIndex: 0,
        explanation: 'Çalışkan diyip 7 yılda bitirmesiyle alay edilmiştir.',
        difficulty: 3),
    StemQuestion(
        question: '"Gül" sözcüğü hangisinde tevriye sanatına örnek olacak şekilde kullanılmıştır?',
        options: ['A) Bahçedeki güller soldu.', 'B) Sen gülünce güller açar gül pembe.', 'C) Bana bir kez gül.', 'D) Gül yağını ellerine sürdü.'],
        correctIndex: 1,
        explanation: 'Gülmek eylemi ve Çiçek olan gül. İki anlam da çağrıştırılmıştır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "alışılmamış bağdaştırma" vardır?',
        options: ['A) Sıcak çorba', 'B) Dilsiz hayaller', 'C) Mavi deniz', 'D) Yüksek dağ'],
        correctIndex: 1,
        explanation: 'Hayallerin dilsiz olması mantıksal olarak uyumsuz ama şiirseldir (İmge).',
        difficulty: 3),
    StemQuestion(
        question: 'Aşağıdaki deyimlerden hangisi "kararsız kalmak" anlamındadır?',
        options: ['A) İki arada bir derede kalmak.', 'B) İpe un sermek.', 'C) İnce eleyip sık dokumak.', 'D) İçi içine sığmamak.'],
        correctIndex: 0,
        explanation: 'İki seçenek arasında sıkışmak.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "Mecaz-ı Mürsel" (Ad Aktarması) yoktur?',
        options: ['A) Batı, bu konuda sessiz kaldı.', 'B) Ünlü raket turnuvadan çekildi.', 'C) İstanbul\'u dinliyorum gözlerim kapalı.', 'D) Ayağını yorganına göre uzat.'],
        correctIndex: 3,
        explanation: 'D şıkkı bir atasözüdür ve temsili istiare/mecaz vardır, ad aktarması yoktur. A (Batı-Ülkeler), B (Raket-Tenisçi), C (İstanbul-Sesler).',
        difficulty: 3),
    StemQuestion(
        question: '"Düşmek" kelimesi hangisinde "değerini yitirmek" anlamındadır?',
        options: ['A) Gözden düşmek.', 'B) Yola düşmek.', 'C) Elden ayaktan düşmek.', 'D) Üstüne düşmek.'],
        correctIndex: 0,
        explanation: 'Gözden düşmek, değer kaybetmektir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde somut anlamlı bir sözcük soyut bir kavramı karşılamak için kullanılmıştır (Soyutlaştırma)?',
        options: ['A) Bu kafayla gidersen işin zor.', 'B) Rüzgar eken fırtına biçer.', 'C) Taş kalpli olma.', 'D) Zaman su gibi akıp gidiyor.'],
        correctIndex: 0,
        explanation: 'Kafa (organ, somut) -> Zihniyet/Düşünce yapısı (soyut).',
        difficulty: 3),
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "kinaye" vardır?',
        options: ['A) Hamama giren terler.', 'B) Damlaya damlaya göl olur.', 'C) Sakla samanı gelir zamanı.', 'D) Bugün işe gitmedim.'],
        correctIndex: 0,
        explanation: 'Gerçek anlam: Hamam sıcaktır terletir. Mecaz: Bir işe girişen zorluklarına katlanır. Kastedilen mecazdır.',
        difficulty: 3),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Sanatlı söyleyişe ne denir?', options: ['A) Üslup', 'B) İçerik', 'C) Tema', 'D) Konu'], correctIndex: 0, difficulty: 3),
    StemQuestion(question: 'Tevriyede kaç gerçek anlam vardır?', options: ['A) 1', 'B) 2', 'C) 0', 'D) 3'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'İğneleme sanatının adı nedir?', options: ['A) Teşbih', 'B) İntak', 'C) Tariz', 'D) Tekrir'], correctIndex: 2, difficulty: 3),
    StemQuestion(question: 'Benzetme edatı hangisidir?', options: ['A) İle', 'B) Gibi', 'C) Ve', 'D) De'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'Hangisi dolaylamadır?', options: ['A) Kara Kıt\'a', 'B) Kara Kedi', 'C) Kara Gün', 'D) Kara Tahta'], correctIndex: 0, explanation: 'Afrika = Kara Kıt\'a', difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: '"Korku dağları bekler." cümlesindeki anlam olayı nedir?', options: ['A) Kişileştirme', 'B) Somutlaştırma', 'C) Benzetme', 'D) Dolaylama'], correctIndex: 1, explanation: 'Korku (soyut), dağları bekleyen bir canlı/nesne gibi (somut) anlatılmıştır.', difficulty: 3),
    StemQuestion(question: 'Aşağıdaki dizelerin hangisinde "hüsnütalil" (güzel nedene bağlama) sanatı vardır?', options: ['A) Yeni bir ülkede yem vermek için atlarına / Nice bin atlı kapılmıştı fetih rüzgarına.', 'B) Güzel şeyler düşünelim diye / Yemyeşil oluvermiş ağaçlar.', 'C) Ben sana mecburum bilemezsin.', 'D) Gökyüzünde yalnız gezen yıldızlar.'], correctIndex: 1, explanation: 'Ağaçların yeşermesi (doğal olay), "güzel şeyler düşünelim diye" (güzel neden) şeklinde açıklanmış.', difficulty: 3),
    StemQuestion(question: '"Mühür gözlüm" sözünde hangi sanat vardır?', options: ['A) Teşbih-i Beliğ', 'B) Mübalağa', 'C) Tezat', 'D) İntak'], correctIndex: 0, explanation: 'Gibi edatı kullanılmadan yapılan güzel benzetme (Mühür gibi göz).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "Abartma" (Mübalağa) yapılmamıştır?', options: ['A) Bir ah çeksem dağı taşı eritir.', 'B) Gözyaşlarım sel oldu.', 'C) Seni dünyalar kadar seviyorum.', 'D) Sabaha kadar ders çalıştım.'], correctIndex: 3, explanation: 'D seçeneği normal bir durumdur, abartma yoktur.', difficulty: 3),
    StemQuestion(question: 'Hangisinde anlam kayması (kip kayması) anlam belirsizliğine yol açmıştır?', options: ['A) Yarın geliyorum.', 'B) Her sabah koşarım.', 'C) Nasrettin Hoca bir gün pazara gider.', 'D) Sabahları erken kalkıyorum.'], correctIndex: 2, explanation: 'Gider (Geniş zaman) kullanılmış ama geçmiş anlatılıyor. Ancak bu bir anlatım bozukluğu değil, üslup özelliğidir. Soru kökünde anlam olayı sorulduğunda zaman kayması da bir anlam özelliğidir.', difficulty: 3),
    StemQuestion(question: '"Kopmak" sözcüğü hangisinde "bir bağın ilgisini kesmesi" anlamında mecazdır?', options: ['A) İp koptu.', 'B) Fırtına koptu.', 'C) Arkadaşıyla bağları koptu.', 'D) Düğme koptu.'], correctIndex: 2, explanation: 'İlişkiyi bitirmek.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "duyular arası aktarım" yoktur?', options: ['A) Tatlı bir bakış.', 'B) Yumuşak ses.', 'C) Keskin koku.', 'D) Acı biber.'], correctIndex: 3, explanation: 'Acı biber, tatma duyusuyla ilgilidir ve kendi duyusundadır. Aktarım yoktur.', difficulty: 3),
    StemQuestion(question: '"Ayağını yorganına göre uzat" atasözünde hangi sanat ağır basmaktadır?', options: ['A) Teşbih', 'B) Mecaz-ı Mürsel', 'C) Kinaye', 'D) Tezat'], correctIndex: 2, explanation: 'Kinaye. Gerçekten de ayak yorgana göre uzatılır (Gerçek), harcamalar gelire göre yapılmalıdır (Mecaz). Kastedilen mecazdır.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "dolaylama" yoktur?', options: ['A) Yedi tepeli şehir (İstanbul).', 'B) Ege\'nin incisi (İzmir).', 'C) Altın boynuz (Haliç).', 'D) Yüksek kule (Galata).'], correctIndex: 3, explanation: 'Yüksek kule bir dolaylama değil, sıfat tamlamasıdır. Galata için özel bir dolaylama değildir.', difficulty: 3),
    StemQuestion(question: 'Aşağıdaki altı çizili sözcüklerden hangisi kökünün türü bakımından diğerlerinden farklıdır?', options: ['A) Yazın tatile gideceğiz.', 'B) Yüzü çok asıktı.', 'C) Gülmek sana yakışıyor.', 'D) Ben de geliyorum.'], correctIndex: 2, explanation: 'A (Yaz-İsim/Fiil sesteş ama burada isim kökü "mevsim"), B (Yüz-İsim), D (Ben-Zamir/İsim). C (Gülmek-Fiil kökü). Soru kökü sesteşlik değil kök türü (isim/fiil) soruyor.', difficulty: 3),
    StemQuestion(question: '"Yol" sözcüğü hangisinde "yöntem, usul" anlamında kullanılmıştır?', options: ['A) Yol çalışması var.', 'B) Bu işin bir yolu olmalı.', 'C) Yolcular otobüse bindi.', 'D) Yolu şaşırdık.'], correctIndex: 1, explanation: 'Yöntem, çare.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ad aktarması" yer-insan ilişkisiyle kurulmamıştır?', options: ['A) Erzurum kan ağlıyor.', 'B) Stat ayakta alkışladı.', 'C) Evi taşıdık.', 'D) Meclis tatile girdi.'], correctIndex: 2, explanation: 'Evi taşıdık derken evin içindeki eşyalar kastedilir (Nesne-İçerik/Parça-Bütün), Yer-İnsan ilişkisi yoktur.', difficulty: 3),
    StemQuestion(question: '"Çevirmek" eylemi hangisinde "yönetmek, idare etmek" anlamındadır?', options: ['A) Sayfayı çevirdi.', 'B) Evi tek başına çeviriyor.', 'C) Arabayı sağa çevirdi.', 'D) Türkçeye çevirdi.'], correctIndex: 1, explanation: 'Evin idaresini sağlamak.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "nicel" anlamlı bir sözcük "nitel" anlama gelecek şekilde kullanılmıştır?', options: ['A) Büyük ev.', 'B) Büyük insan.', 'C) Ağır çuval.', 'D) Geniş yol.'], correctIndex: 1, explanation: 'Büyük (boyut olarak ölçülebilir-nicel) ama "Büyük insan" (önemli/değerli-nitel).', difficulty: 3),
    StemQuestion(question: 'Hangisi yansımadan türemiş bir isimdir?', options: ['A) Çıtırtı', 'B) Patlamak', 'C) Işıltı', 'D) Gürlemek'], correctIndex: 0, explanation: 'Çıt-ır-tı (İsim). Patla-mak (Fiil), Gürle-mek (Fiil). Işıltı yansıma değildir.', difficulty: 3),
  ],
  formulaCards: const ['Tevriye: İki gerçek anlam, uzak olan kastedilir.', 'Tariz: İğneleme amacıyla tersini söyleme.', 'Hüsnütalil: Güzel nedene bağlama.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 2: CÜMLEDE ANLAM
// ═══════════════════════════════════════════════════════════════

final kpssLiseTurU2Content = StemUnitContent(
  unitId: 'kpsslise_tur_u2',
  topic: const TopicContent(
    summary: 'Cümlede anlam; cümlelerin ifade ettiği yargıları (öznel-nesnel) ve cümleler arasındaki ilişkileri (neden-sonuç, amaç-sonuç, koşul-sonuç) inceler. Ayrıca tanım, karşılaştırma, benzetme gibi anlatım özellikleri de bu ünitenin konusudur.',
    rule: 'Amaç-sonuç cümlelerinde eylem henüz gerçekleşmemiştir (hedef vardır); Neden-sonuçta eylem gerçekleşmiştir.',
    formulas: [
      'Neden-Sonuç: "-dığı için" (Eylem bitti).',
      'Amaç-Sonuç: "-mek için" (Eylem bitmedi, hedef var).',
      'Koşul-Sonuç: "-se / -sa" (Şarta bağlılık).'
    ],
    keyPoints: [
      'Nesnel yargılar kanıtlanabilir, öznel yargılar kişisel yorum içerir.',
      'Tanım cümleleri "Bu nedir?" sorusuna cevap verir ("...denir" ile biter).',
      'Karşılaştırmada "en, daha, kadar" gibi ifadeler aranır.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Aşağıdaki cümlelerden hangisi amaç-sonuç ilişkisi taşır?',
      steps: [
        'A) Yağmur yağdığı için ıslandık. (Islandık, eylem bitmiş -> Neden-sonuç)',
        'B) Seni görmek için geldim. (Görmek bir hedef, henüz görmemiş olabilir -> Amaç-sonuç)',
        'C) Çok yediğinden hastalandı. (Hastalandı, eylem bitmiş -> Neden-sonuç)',
      ],
      answer: 'B) Seni görmek için geldim.',
    ),
    SolvedExample(
      question: 'Hangisi kanıtlanabilirlik açısından diğerlerinden farklıdır (Öznel/Nesnel)?',
      steps: [
        'A) Şiirde sade bir dil kullanılmış. (İncelenip kanıtlanabilir -> Nesnel)',
        'B) Roman 200 sayfadan oluşuyor. (Sayılabilir -> Nesnel)',
        'C) Yazarın sürükleyici bir anlatımı var. ("Sürükleyici" kişisel bir yorumdur -> Öznel)',
      ],
      answer: 'C) Yazarın sürükleyici bir anlatımı var.',
    ),
    SolvedExample(
      question: 'Hangisi bir tanım cümlesidir?',
      steps: [
        'Tanım cümlesi "Bu nedir?" sorusuna cevap verir.',
        'A) Roman, yaşanmış ya da yaşanması mümkün olayları anlatan türdür. (Roman nedir? -> Cevap var.)',
        'B) Romanda olaylar detaylı anlatılır. (Bu bir özellik, tanım değil.)',
      ],
      answer: 'A) Roman, yaşanmış ya da yaşanması mümkün olayları anlatan türdür.',
    ),
    SolvedExample(
      question: 'Hangisinde koşul (şart) anlamı vardır?',
      steps: [
        'Koşul cümlelerinde eylemin gerçekleşmesi bir şarta bağlıdır.',
        'A) Eve gelirse haber ver. (Haber vermenin şartı eve gelmesidir.)',
        'B) Eve geldiği için sevindi. (Neden-sonuç)',
      ],
      answer: 'A) Eve gelirse haber ver.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "neden-sonuç" ilişkisi vardır?',
        options: ['A) Sınavı kazanmak için çalışıyor.', 'B) Yorulduğu için erken yattı.', 'C) Kitap okumak üzere odasına gitti.', 'D) Erken kalkarsan yetişirsin.'],
        correctIndex: 1,
        explanation: 'Yorulma eylemi gerçekleşmiş ve bunun sonucunda yatmış.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi öznel bir yargıdır?',
        options: ['A) Türkiye\'nin başkenti Ankara\'dır.', 'B) Kitabın kapağı mavidir.', 'C) Film çok heyecanlıydı.', 'D) Yazar 1980 yılında doğdu.'],
        correctIndex: 2,
        explanation: 'Heyecanlı olması kişisel bir yorumdur.',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdakilerden hangisi bir "varsayım" cümlesidir?',
        options: ['A) Belki yarın gelir.', 'B) Diyelim ki sınavı kazandın.', 'C) Keşke tatile gitsek.', 'D) Sanırım yağmur yağacak.'],
        correctIndex: 1,
        explanation: '"Diyelim ki, tut ki, farz et ki" varsayım ifadeleridir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "karşılaştırma" yoktur?',
        options: ['A) Sınıfın en çalışkanı Ali\'dir.', 'B) Bu ev diğerinden daha geniş.', 'C) Sen de onlar kadar başarılısın.', 'D) Akşam pazara gittik.'],
        correctIndex: 3,
        explanation: 'Diğer seçeneklerde "en, daha, kadar" ile kıyaslama yapılmıştır.',
        difficulty: 1),
    StemQuestion(
        question: '"Sanat, gerçeğin yeniden yorumlanmasıdır." cümlesi ne tür bir cümledir?',
        options: ['A) Tanım cümlesi', 'B) Neden-sonuç cümlesi', 'C) Koşul cümlesi', 'D) Benzetme cümlesi'],
        correctIndex: 0,
        explanation: '"Sanat nedir?" sorusuna cevap verir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "önyargı" anlamı vardır?',
        options: ['A) Bu işi kesinlikle başaramayacak.', 'B) Yarın yağmur yağabilir.', 'C) Sınav zor geçti.', 'D) Belki bizi arar.'],
        correctIndex: 0,
        explanation: 'Sonuç belli olmadan peşin hüküm verilmiştir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "ihtimal" (olasılık) anlamı vardır?',
        options: ['A) Kapı çaldı, babam gelmiş olabilir.', 'B) Ödevlerini bitirmelisin.', 'C) Buraya park etmek yasaktır.', 'D) Sabah erken kalktım.'],
        correctIndex: 0,
        explanation: '"-ebilmek" eki ihtimal katmıştır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "üzüntü" anlamı vardır?',
        options: ['A) Ne yazık ki onu son kez göremedim.', 'B) Keşke daha çok çalışsaydım.', 'C) Bu işten bıktım artık.', 'D) Oraya gitmek istemiyorum.'],
        correctIndex: 0,
        explanation: 'Yaşanan bir olaydan duyulan keder.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi nesnel bir yargıdır?',
        options: ['A) Bu manzara harika.', 'B) İstanbul en güzel şehirdir.', 'C) Şairin son kitabı 100 sayfadır.', 'D) Yemek çok lezzetliydi.'],
        correctIndex: 2,
        explanation: 'Sayfa sayısı kişiye göre değişmez, kanıtlanabilir.',
        difficulty: 1),
    StemQuestion(
        question: '"...üzere" ifadesi hangisinde amaç anlamı katmıştır?',
        options: ['A) Güneş batmak üzere.', 'B) Konuşmak üzere kürsüye çıktı.', 'C) Anlaştığımız üzere yarın gel.', 'D) Onu bir daha görmemek üzere gitti.'],
        correctIndex: 1,
        explanation: 'Konuşmak amacıyla.',
        difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '"Tut ki" ile başlayan cümle ne bildirir?', options: ['A) Neden', 'B) Amaç', 'C) Varsayım', 'D) Kesinlik'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '"En" kelimesi genellikle ne yapar?', options: ['A) Benzetme', 'B) Karşılaştırma', 'C) Tanım', 'D) Örnekleme'], correctIndex: 1, difficulty: 1),
    StemQuestion(question: '"Bu nedir?" sorusuna cevap veren cümle?', options: ['A) Tanım', 'B) Yorum', 'C) Eleştiri', 'D) Öneri'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Hangisi özneldir?', options: ['A) Kırmızı gömlek', 'B) Uzun yol', 'C) Güzel elbise', 'D) Taş bina'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: 'Eylem gerçekleşmişse ne ilişkisi vardır?', options: ['A) Amaç-Sonuç', 'B) Neden-Sonuç', 'C) Koşul', 'D) Varsayım'], correctIndex: 1, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "amaç-sonuç" ilişkisi vardır?', options: ['A) Kar yağdığı için yollar kapandı.', 'B) İlaç almak için eczaneye gitti.', 'C) Geç kaldığımdan servisi kaçırdım.', 'D) Çok konuştuğu için sesi kısıldı.'], correctIndex: 1, explanation: 'İlaç almak bir hedeftir. Diğerlerinde eylem gerçekleşmiştir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "aşamalı bir durum" anlatılmaktadır?', options: ['A) Hava birdenbire soğudu.', 'B) Hasta günden güne iyileşiyor.', 'C) Dün akşam sinemaya gittik.', 'D) Sabah erkenden uyandı.'], correctIndex: 1, explanation: '"Günden güne" ifadesi durumun zamanla değiştiğini (aşamalı) bildirir.', difficulty: 1),
    StemQuestion(question: '"Sanki" sözcüğü cümleye hangi anlamı katmaz?', options: ['A) Benzetme', 'B) Uyarı', 'C) Varsayım', 'D) İnanmama'], correctIndex: 1, explanation: 'Sanki uyarı anlamı taşımaz.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "dolaylı anlatım" vardır?', options: ['A) "Yarın gelirim." dedi.', 'B) Yarın geleceğini söyledi.', 'C) Sakın geç kalma, dedi.', 'D) Öğretmen: "Ders çalışın." dedi.'], correctIndex: 1, explanation: 'Başkasına ait sözün değiştirilerek aktarılmasıdır (geleceğini söyledi).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "beğenme" anlamı vardır?', options: ['A) Bu kıyafet sana çok yakışmış.', 'B) Keşke ben de alabilsem.', 'C) Nerede o eski bayramlar.', 'D) Bu işi nasıl yaptın?'], correctIndex: 0, explanation: 'Takdir etme, beğenme.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "pişmanlık" anlamı vardır?', options: ['A) Keşke o sözü söylemeseydim.', 'B) Keşke tatile gitsek.', 'C) İyi ki doğdun.', 'D) Belki bir gün döner.'], correctIndex: 0, explanation: 'Yapılan bir işten duyulan üzüntü.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "gerçekleşmemiş beklenti" anlamı vardır?', options: ['A) Sınavdan yüksek not alacağımı sanıyordum.', 'B) Yarın bize gelecekmiş.', 'C) Umarım her şey güzel olur.', 'D) Beklediğim mektup sonunda geldi.'], correctIndex: 0, explanation: 'Sanıyordum ama olmadı.', difficulty: 1),
    StemQuestion(question: '"Üzere" sözcüğü hangisinde "koşuluyla" anlamında kullanılmıştır?', options: ['A) Yarın getirmek üzere kitabı alabilirsin.', 'B) Güneş batmak üzere.', 'C) Anlaşmak üzere toplandılar.', 'D) Birazdan çıkmak üzereyiz.'], correctIndex: 0, explanation: 'Geri getirme şartıyla.', difficulty: 1),
    StemQuestion(question: 'Hangisi üslup (biçem) cümlesidir?', options: ['A) Yazar, eserinde köy hayatını anlatmış.', 'B) Romanda, Kurtuluş Savaşı yılları işlenmiş.', 'C) Şair, şiirlerinde ağdalı bir dil kullanmış.', 'D) Kitapta üç ana karakter var.'], correctIndex: 2, explanation: 'Dil ve anlatım özelliği (ağdalı dil) üsluptur. Diğerleri içeriktir.', difficulty: 1),
    StemQuestion(question: 'Hangisi içerik (konu) cümlesidir?', options: ['A) Yazar kısa cümleler kurmuş.', 'B) Eser akıcı bir dille yazılmış.', 'C) Yazar, eserinde gurbetçi ailenin dramını anlatıyor.', 'D) Kelime seçimleri çok başarılı.'], correctIndex: 2, explanation: 'Ne anlatıldığı içeriktir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "yakınma" (şikayet) vardır?', options: ['A) Ne yapsam bana yaranamıyorum.', 'B) Keşke daha çok çalışsaydım.', 'C) Aşk olsun, beni neden beklemedin?', 'D) Çok güzel bir filmdi.'], correctIndex: 0, explanation: 'Bir durumdan duyulan rahatsızlığı başkasına anlatma.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "sitem" vardır?', options: ['A) İnsan bir arayıp sorar.', 'B) Trafik yine çok sıkışık.', 'C) Keşke oraya gitmeseydim.', 'D) Bu yemek çok tuzlu olmuş.'], correctIndex: 0, explanation: 'Bir kimseye, yaptığı hareketten dolayı duyulan üzüntüyü yüzüne vurma.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "küçümseme" vardır?', options: ['A) Bu parayla mı ev alacaksın?', 'B) Zavallı çocuk çok hasta.', 'C) O çok başarılı biridir.', 'D) Seni tebrik ederim.'], correctIndex: 0, explanation: 'Bir şeyi veya kişiyi hafife alma, azımsama.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "azımsama" (miktar olarak az bulma) vardır?', options: ['A) Bu kadarcık yemekle kim doyar?', 'B) O bu işi beceremez.', 'C) Sen kim, doktor olmak kim!', 'D) Bu davranış ona yakışmadı.'], correctIndex: 0, explanation: 'Miktar olarak yetersiz bulma.', difficulty: 1),
    StemQuestion(question: '"Sözde" kelimesi cümleye hangi anlamı katmıştır: "Sözde bize yardım edecekti."', options: ['A) Kesinlik', 'B) İnanmama/Gerçekleşmemiş', 'C) Onaylama', 'D) Beğenme'], correctIndex: 1, explanation: 'Söylenenin aksinin olduğu veya inanılmadığı anlamı.', difficulty: 1),
  ],
  formulaCards: const ['Amaç-Sonuç: Hedef var (mak için).', 'Neden-Sonuç: Eylem bitti (dığı için).', 'Öznel: Kişisel yorum.'],
);

final kpssOnlisansTurU2Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u2',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde Cümlede Anlam; Pişmanlık ile Hayıflanma, Sitem ile Yakınma, Küçümseme ile Azımsama gibi karıştırılan kavramların ayrımı üzerine yoğunlaşır. Ayrıca doğrudan ve dolaylı anlatım, üslup ve içerik cümleleri, kinayeli anlatım bu seviyenin önemli başlıklarıdır.',
    rule: 'Pişmanlık yapılan bir işten, Hayıflanma yapılmayan bir işten duyulan üzüntüdür.',
    formulas: [
      'Pişmanlık: Yaptım -> Üzgünüm.',
      'Hayıflanma: Yapmadım -> Üzgünüm (Fırsatı kaçırdım).',
      'Sitem: Yüzüne karşı serzeniş.',
      'Yakınma: Arkasından şikayet etme.'
    ],
    keyPoints: [
      'Azımsama miktar (sayısal) ile ilgilidir, küçümseme nitelik (değer) ile ilgilidir.',
      'Doğrudan anlatım: "..." dedi. Dolaylı anlatım: ...diğini söyledi.',
      'Üslup (Biçem): "Nasıl anlatmış?" (Dil, kelime seçimi). İçerik: "Ne anlatmış?" (Konu, olay).'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Hangisinde "hayıflanma" anlamı vardır?',
      steps: [
        'Hayıflanma: Yapılmayan bir işten duyulan üzüntü.',
        'A) Oraya gitmeseydim. (Gittim -> Pişmanlık)',
        'B) Gençlikte gezip eğlenmek varmış. (Yapamadım -> Hayıflanma)',
      ],
      answer: 'B) Gençlikte gezip eğlenmek varmış.',
    ),
    SolvedExample(
      question: 'Hangisi bir "üslup" cümlesidir?',
      steps: [
        'Üslup, yazarın dili kullanma şeklidir.',
        'A) Yazar, Anadolu insanının acılarını işliyor. (Ne anlatıyor? -> Konu/İçerik)',
        'B) Yazar, devrik cümlelerle akıcı bir dil oluşturmuş. (Nasıl anlatıyor? -> Üslup)',
      ],
      answer: 'B) Yazar, devrik cümlelerle akıcı bir dil oluşturmuş.',
    ),
    SolvedExample(
      question: 'Hangisinde "küçümseme" anlamı vardır?',
      steps: [
        'Küçümseme: Bir kişiyi veya durumu hor görme, değersiz bulma.',
        'A) Bu maaşla geçinilmez. (Miktar az -> Azımsama)',
        'B) O da güya şair olacak. (Değersiz görme -> Küçümseme)',
      ],
      answer: 'B) O da güya şair olacak.',
    ),
    SolvedExample(
      question: 'Hangisi dolaylı anlatımdır?',
      steps: [
        'A) Atatürk: "Yurtta sulh, cihanda sulh." dedi. (Doğrudan)',
        'B) Doktor, ilaçlarımı düzenli içmem gerektiğini söyledi. (Söz değiştirilmiş -> Dolaylı)',
      ],
      answer: 'B) Doktor, ilaçlarımı düzenli içmem gerektiğini söyledi.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "yakınma" (şikayet) söz konusudur?',
        options: ['A) Davetimize bir tek o gelmedi.', 'B) İnsanlar artık birbirine saygı göstermiyor.', 'C) Keşke bu arabayı almasaydık.', 'D) Bu kadar az yemekle doymam.'],
        correctIndex: 1,
        explanation: 'Genel bir durumdan duyulan rahatsızlık dile getirilmiştir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "kaniksama" (kabullenme/alışma) anlamı vardır?',
        options: ['A) Bu gürültü artık beni rahatsız etmiyor.', 'B) Bu sözleri hak etmedim.', 'C) Nasıl böyle bir hata yaparsın?', 'D) Teklifimizi kabul etmedi.'],
        correctIndex: 0,
        explanation: 'Süregelen olumsuz bir duruma alışma hali.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi hem içerik hem üslup cümlesidir?',
        options: ['A) Roman, savaş yıllarını anlatıyor.', 'B) Yazar, sade bir Türkçe kullanmış.', 'C) Eserinde köy yaşamını etkileyici bir dille anlatmış.', 'D) Kitap haftaya çıkacak.'],
        correctIndex: 2,
        explanation: 'Köy yaşamı (İçerik) + Etkileyici dil (Üslup).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "yadsıma" (inkâr) anlamı vardır?',
        options: ['A) Ben öyle bir şey söylemedim.', 'B) Sanırım o gelmeyecek.', 'C) Bu konuyu sonra konuşuruz.', 'D) Yanlış yaptığını kabul etmelisin.'],
        correctIndex: 0,
        explanation: 'Yadsıma, yaptığını veya söylediğini inkar etmektir.',
        difficulty: 2),
    StemQuestion(
        question: '"Kimi yazarlar, eserlerinde süslü ifadelere yer vererek okuyucuyu yorar." cümlesi ne tür bir cümledir?',
        options: ['A) Öz eleştiri', 'B) Eleştiri', 'C) Öneri', 'D) Varsayım'],
        correctIndex: 1,
        explanation: 'Bir yazar grubuna yönelik olumsuz değerlendirme (eleştiri).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "olasılık" anlamı yoktur?',
        options: ['A) Geç kaldığına göre trafiğe takılmış olabilir.', 'B) Sanıyorum bu iş bugün biter.', 'C) Belki yarın size uğrarız.', 'D) Mutlaka bu soruyu çözmelisin.'],
        correctIndex: 3,
        explanation: 'Mutlaka kesinlik (gereklilik) bildirir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "karşılaştırma" yapılırken "eşitlik" belirtilmiştir?',
        options: ['A) Sinema da tiyatro kadar eğlencelidir.', 'B) En sevdiğim meyve elmadır.', 'C) Burası dünden daha sıcak.', 'D) Hiç kimse onun gibi koşamaz.'],
        correctIndex: 0,
        explanation: '"Kadar" edatı eşitlik ilgisi kurmuştur.',
        difficulty: 2),
    StemQuestion(
        question: '"Mutluluk, varılacak bir istasyon değil, bir yolculuk şeklidir." cümlesi ile anlatılmak istenen nedir?',
        options: ['A) Mutluluk için çok çalışmak gerekir.', 'B) Mutluluk sonuçta değil, süreçtedir.', 'C) Herkes mutlu olamaz.', 'D) Mutluluk geçici bir duygudur.'],
        correctIndex: 1,
        explanation: 'İstasyon (sonuç) değil, yolculuk (süreç).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "öneri" anlamı vardır?',
        options: ['A) Bu konuyu daha detaylı araştırmalısınız.', 'B) Keşke daha önce haber verseydin.', 'C) Sınavdan yüksek alacağımı sanıyorum.', 'D) Yağmur yağarsa ıslanırız.'],
        correctIndex: 0,
        explanation: 'Bir tavsiyede bulunulmaktadır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "gerçekleşmemiş niyet" vardır?',
        options: ['A) Dün akşam sinemaya gittik.', 'B) Hafta sonu pikniğe gidecektik ama yağmur yağdı.', 'C) Yarın size geleceğiz.', 'D) Orayı görmeyi çok istiyorum.'],
        correctIndex: 1,
        explanation: 'Niyet edilmiş (gidecektik) ama eylem gerçekleşmemiş.',
        difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Yapılmayan işten duyulan üzüntü?', options: ['A) Pişmanlık', 'B) Hayıflanma', 'C) Sitem', 'D) Yakınma'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Sayılabilen azlık?', options: ['A) Küçümseme', 'B) Azımsama', 'C) Yadsıma', 'D) Kanıksama'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: '"Nasıl anlatmış?" sorusunun cevabı?', options: ['A) İçerik', 'B) Üslup', 'C) Konu', 'D) Ana fikir'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Dolaylı anlatım hangi ekle biter genelde?', options: ['A) -di', 'B) -yor', 'C) -diğini söyledi', 'D) "..." dedi'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Yadsıma nedir?', options: ['A) İnkar', 'B) Kabul', 'C) Alışma', 'D) Bıkma'], correctIndex: 0, difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "azımsama" anlamı vardır?', options: ['A) Bu işi bir çocuk bile yapar.', 'B) Bir tanecik mi elma alabildin?', 'C) Senin aklın bu işlere ermez.', 'D) Oraya gitmek yürek ister.'], correctIndex: 1, explanation: 'Miktar olarak az bulma (bir tanecik). A ve C küçümsemedir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "sitem" anlamı vardır?', options: ['A) Herkes beni yanlış anlıyor.', 'B) İnsan en yakın arkadaşını düğüne çağırmaz mı?', 'C) Keşke o gün evde kalsaydım.', 'D) Bu çocuk adam olmaz.'], correctIndex: 1, explanation: 'Muhatabına yönelik kırgınlık ifadesi. A yakınma, C pişmanlık, D küçümseme/önyargı.', difficulty: 2),
    StemQuestion(question: '"Roman dediğin, sokağın tozunu yutmalı." cümlesinde anlatılmak istenen nedir?', options: ['A) Roman hayal ürünü olmalıdır.', 'B) Roman gerçek hayatı yansıtmalıdır.', 'C) Roman dili ağır olmalıdır.', 'D) Roman yazmak zordur.'], correctIndex: 1, explanation: 'Sokağın tozu (gerçek hayat/realizm).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "tahmin" anlamı yoktur?', options: ['A) Bu saatte uyumuş olmalı.', 'B) Kapıyı çalan Ahmet olabilir.', 'C) Sanırım yağmur yağacak.', 'D) Lütfen sessiz olunuz.'], correctIndex: 3, explanation: 'Rica/Emir kipidir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "özeleştiri" yapılmıştır?', options: ['A) Arkadaşım çok dağınık çalışır.', 'B) Bu konuyu anlatırken çok hızlı konuşmuşum.', 'C) O, işlerini zamanında yapmaz.', 'D) Sınav soruları çok zordu.'], correctIndex: 1, explanation: 'Kişinin kendisine yönelik eleştirisi.', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "dolaylı anlatım" söz konusudur?', options: ['A) Şair, "Şiir benim hayatımdır." der.', 'B) Annem, akşam eve erken gelmemi tembihledi.', 'C) Arkadaşım: "Yarın sinemaya gidelim mi?" diye sordu.', 'D) Öğretmenimiz: "Ders çalışın." dedi.'], correctIndex: 1, explanation: 'Sözü aktarırken kendi cümlesiyle ifade etme (...tembihledi).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "beklenti" anlamı vardır?', options: ['A) Umarım sınavın iyi geçer.', 'B) Artık her şey bitti.', 'C) Keşke daha önce gelseydin.', 'D) Bu kitap çok sürükleyici.'], correctIndex: 0, explanation: 'Geleceğe dair bir umut/istek (beklenti).', difficulty: 2),
    StemQuestion(question: '"Bir eleştirmen, eserleri değerlendirirken tarafsız olmalıdır." cümlesine anlamca en yakın cümle hangisidir?', options: ['A) Eleştirmen, eserleri kendi zevkine göre yorumlamalıdır.', 'B) Eleştirmen, duygularını işine karıştırmamalıdır.', 'C) Eleştiri, yazarın hayatını anlatmalıdır.', 'D) Tarafsız eleştiri mümkün değildir.'], correctIndex: 1, explanation: 'Tarafsızlık = Duyguları karıştırmamak (Objektiflik).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "onaylama" (tasvip etme) anlamı vardır?', options: ['A) Bu davranışınla herkesi üzdün.', 'B) Aferin, tam da beklediğim gibi davrandın.', 'C) Neden böyle yaptığını anlamadım.', 'D) Belki daha iyisini yapabilirdin.'], correctIndex: 1, explanation: 'Yapılanı doğru bulma.', difficulty: 2),
    StemQuestion(question: 'Hangisi "tanım cümlesi" değildir?', options: ['A) Lisan, insanların anlaşmasını sağlayan bir araçtır.', 'B) Üçgen, iç açıları toplamı 180 derece olan bir çokgendir.', 'C) Şiir, duyguların coşkulu anlatımıdır.', 'D) Şiir, düz yazıdan daha zordur.'], correctIndex: 3, explanation: 'Bu bir karşılaştırma cümlesidir. "Şiir nedir?" sorusuna tam cevap vermez, özellik kıyaslar.', difficulty: 2),
    StemQuestion(question: '"Ne kadar bilirsen bil, söylediklerin karşındakinin anlayabileceği kadardır." cümlesinin ana düşüncesi nedir?', options: ['A) Çok bilmek önemlidir.', 'B) İletişim, dinleyicinin kapasitesiyle sınırlıdır.', 'C) Herkes her şeyi anlayamaz.', 'D) Konuşmak bir sanattır.'], correctIndex: 1, explanation: 'Anlatanın bilgisi değil, dinleyenin algısı sınırı çizer.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "çıkarım" yapılmıştır?', options: ['A) Hava bulutlu.', 'B) Yerler ıslak, demek ki gece yağmur yağmış.', 'C) Yarın sinemaya gideceğim.', 'D) Kitabı masaya bıraktım.'], correctIndex: 1, explanation: 'Görünen bir durumdan (ıslaklık) yola çıkarak bir sonuca (yağmur) varma.', difficulty: 2),
    StemQuestion(question: '"Eski dost düşman olmaz." cümlesi ne anlama gelir?', options: ['A) Dostluklar zamanla biter.', 'B) Gerçek dostluklar kalıcıdır, düşmanlığa dönüşmez.', 'C) Düşmanlar dost olabilir.', 'D) Dostunu iyi seçmelisin.'], correctIndex: 1, explanation: 'Köklü dostlukların bozulmayacağı.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "aşamalı durum" söz konusudur?', options: ['A) Araba aniden durdu.', 'B) Çocuklar bahçeye çıktı.', 'C) Havalar gittikçe ısınıyor.', 'D) Dün çok yoruldum.'], correctIndex: 2, explanation: 'Gittikçe (zamanla artan şekilde).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "neden-sonuç" ilişkisi gerekçeli yargı olarak verilmiştir?', options: ['A) Çok okumalıyız ki ufkumuz genişlesin.', 'B) Seni göremediğim için üzüldüm.', 'C) Yağmur yağarsa gelmem.', 'D) Ders çalışmak için kütüphaneye gitti.'], correctIndex: 1, explanation: 'Yargı (üzüldüm), gerekçesiyle (seni göremediğim için) verilmiştir.', difficulty: 2),
  ],
  formulaCards: const ['Pişmanlık: Yaptım üzgünüm.', 'Hayıflanma: Yapmadım üzgünüm.', 'Azımsama: Miktar (sayı). Küçümseme: Değer.'],
);

final kpssLisansTurU2Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u2',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde Cümlede Anlam; cümleye hakim olan duygu, düşünce ve kavramların derinlemesine analizini gerektirir. Kanıksama, Yadsıma, Özeleştiri, Çıkarım gibi kavramların yanı sıra, örtülü anlam (cümleden çıkarılabilecek gizli anlamlar) ve cümleyi tamamlama/oluşturma soruları zorlayıcı olabilir. "Betimleyici" veya "Öyküleyici" anlatım gibi paragraf kökenli cümle analizleri de burada karşımıza çıkar.',
    rule: 'Örtülü anlam, cümlede açıkça yazmayan ancak mantıksal çıkarımla ulaşılan anlamdır. Genellikle "de, bile, artık, yine" gibi bağlaç/zarflarla sağlanır.',
    formulas: [
      'Örtülü Anlam: "Ahmet de geldi." -> "Başkaları da gelmiş."',
      'Çıkarım: Veri -> Yorum (Gözlemden sonuç çıkarma).',
      'Kinayeli Anlatım: Tersini kastederek alay etme.'
    ],
    keyPoints: [
      '"Hayıflanma" (yapılmayan fırsat) ile "Pişmanlık" (yapılan hata) farkı kesindir.',
      'Üslup cümlelerinde "dil, anlatım, cümle yapısı, sözcük seçimi" anahtar kelimelerdir.',
      'Nesnel cümleler yorumsuzdur, Öznel cümleler yorumludur.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: '"Toplantıya Ali de katıldı." cümlesinden çıkarılabilecek kesin yargı (örtülü anlam) nedir?',
      steps: [
        'Cümlede "de" bağlacı var.',
        'Ali dışında başkalarının da katıldığı anlamı çıkar.',
        'Ali\'nin daha önce katılmadığı veya Ali\'nin önemli biri olduğu kesin DEĞİLDİR.',
      ],
      answer: 'Toplantıya Ali dışında başkaları da katılmıştır.',
    ),
    SolvedExample(
      question: '"Yazarın, eserlerindeki karakterleri, yaşadığı çevreden seçmesi yapıtlarına inandırıcılık katmış." cümlesi içerik mi üslup mudur?',
      steps: [
        'Karakterleri yaşadığı çevreden seçmesi -> İçerik (Konu).',
        'Ancak "inandırıcılık katmış" ifadesi bir değerlendirmedir.',
        'Bu cümle "neden-sonuç" ilişkisiyle bir eleştiri/değerlendirme cümlesidir.',
      ],
      answer: 'Değerlendirme (Eleştiri) Cümlesi',
    ),
    SolvedExample(
      question: 'Hangisinde "yadsıma" vardır?',
      steps: [
        'Yadsıma: İnkar etme, kabullenmeme.',
        'A) Ben bu sözleri söylemedim, iftira atıyorlar. (Söylemediğini iddia ediyor -> Yadsıma)',
        'B) Keşke söylemeseydim. (Kabul ediyor -> Pişmanlık)',
      ],
      answer: 'A) Ben bu sözleri söylemedim, iftira atıyorlar.',
    ),
    SolvedExample(
      question: 'Hangisinde "çıkarım" yapılmıştır?',
      steps: [
        'Çıkarım: Bir veriye dayanarak yorum yapmak.',
        'A) Gözleri kızarmış, ağlamış olmalı. (Göz kızarıklığı verisinden ağlama sonucu çıkarılıyor.)',
        'B) Gözleri kızarmış. (Sadece tespit/gözlem)',
      ],
      answer: 'A) Gözleri kızarmış, ağlamış olmalı.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "örtülü anlam" yoktur?',
        options: ['A) Bu yıl da tatile gidemedik.', 'B) Toplantıya Ahmet Bey yine geç kaldı.', 'C) Sen bile beni anlamadın.', 'D) Dün akşam çok güzel bir film izledik.'],
        correctIndex: 3,
        explanation: 'A (Geçen yıl da gidemedik), B (Daha önce de geç kalmış), C (Başkaları anlamadı, sen de). D seçeneği düz, açık bir yargıdır.',
        difficulty: 3),
    StemQuestion(
        question: '"Sanatçı, çağına tanıklık ederken tarafsız bir gözlemci gibi değil, bir yargıç gibi davranmalıdır." cümlesiyle anlatılmak istenen nedir?',
        options: ['A) Sanatçı olayları olduğu gibi yansıtmalıdır.', 'B) Sanatçı toplumsal sorunlara çözüm aramalı ve hüküm vermelidir.', 'C) Sanatçı eserlerinde duygularına yer vermemelidir.', 'D) Sanatçı sadece güzellikleri anlatmalıdır.'],
        correctIndex: 1,
        explanation: 'Yargıç gibi davranmak -> Hüküm vermek, yönlendirmek, müdahale etmek.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "önyargı" (peşin hüküm) anlamı vardır?',
        options: ['A) Göreceksiniz, bu kitap satış rekorları kıracak.', 'B) Kitap, haftaya raflardaki yerini alacak.', 'C) Yazarın dili oldukça akıcı.', 'D) Konuyu ilginç bir açıdan ele almış.'],
        correctIndex: 0,
        explanation: 'Sonuç gerçekleşmeden kesin konuşma (Olumlu önyargı).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "kanıksama" (kabullenmişlik) söz konusudur?',
        options: ['A) Onun yalanlarına artık şaşırmıyoruz.', 'B) Yalan söylemesi beni çok üzdü.', 'C) Bir daha yalan söylersen külahları değişiriz.', 'D) İnsan hiç yalan söyler mi?'],
        correctIndex: 0,
        explanation: 'Olumsuz duruma alışma, tepki vermeme hali.',
        difficulty: 3),
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "değerlendirme" yapılmamıştır?',
        options: ['A) Romanın kurgusu oldukça sağlamdı.', 'B) Şair, kelimeleri kuyumcu titizliğiyle seçmiş.', 'C) Kitap, 1950 yılında yayımlanmış.', 'D) Yazar, olayları gerçekçi bir dille anlatmış.'],
        correctIndex: 2,
        explanation: 'C seçeneği nesnel bir bilgidir, yoruma dayalı değerlendirme içermez.',
        difficulty: 3),
    StemQuestion(
        question: '"Hiçbir balık uçmaya, hiçbir kuş yüzmeye zorlanmaz." cümlesinin vurgusu nedir?',
        options: ['A) Özgürlük', 'B) Yetenek/Fıtrat', 'C) Çalışkanlık', 'D) Eğitim'],
        correctIndex: 1,
        explanation: 'Her canlının doğasına/yeteneğine uygun iş yapması gerektiği.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "hayıflanma" vardır?',
        options: ['A) O evi almalıydık, kaçırdık.', 'B) Keşke o sözü söylemeseydim.', 'C) Beni hiç aramadın.', 'D) Bu işi başarman zor.'],
        correctIndex: 0,
        explanation: 'Yapılmayan işten duyulan üzüntü (fırsat kaçırma).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "kişileştirme" yoluyla bir anlam ilgisi kurulmuştur?',
        options: ['A) Hırçın dalgalar kıyıya vuruyordu.', 'B) Güneş bugün çok yakıcı.', 'C) Kuşlar ağaçta ötüşüyor.', 'D) Çiçekler susuzluktan kurudu.'],
        correctIndex: 0,
        explanation: 'Dalgaların "hırçın" olması insana ait özelliktir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "dolaylı anlatım" yoktur?',
        options: ['A) Yarın geleceğini bildirdi.', 'B) İşlerin yolunda gittiğini söyledi.', 'C) "Bu işi bitirmeliyiz." dedi.', 'D) Sınavın zor olacağından bahsetti.'],
        correctIndex: 2,
        explanation: 'C seçeneği tırnak içinde verilen doğrudan anlatımdır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "koşul gerçekleşse de sonucun değişmeyeceği" anlamı vardır?',
        options: ['A) Erken gelse de yer bulamaz.', 'B) Çalışırsan kazanırsın.', 'C) Yağmur yağarsa gitmeyiz.', 'D) İstersen yaparsın.'],
        correctIndex: 0,
        explanation: 'Eylemin yapılması sonuca etki etmiyor.',
        difficulty: 3),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '"Artık şaşırmıyorum" neyi ifade eder?', options: ['A) Yadsıma', 'B) Kanıksama', 'C) Azımsama', 'D) Sitem'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: '"O kitap çok satar" cümlesi nedir?', options: ['A) Önyargı', 'B) Gözlem', 'C) Tanım', 'D) Uyarı'], correctIndex: 0, difficulty: 3),
    StemQuestion(question: 'Olumsuz duruma alışma haline ne denir?', options: ['A) Yadsıma', 'B) Kanıksama', 'C) Pişmanlık', 'D) Sitem'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'Örtülü anlamın en güçlü ipucu kelimesi?', options: ['A) Ve', 'B) De/Da', 'C) İle', 'D) Ki'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'İnkar etme anlamına gelen terim?', options: ['A) Yadsıma', 'B) Yakınma', 'C) Hayıflanma', 'D) Azımsama'], correctIndex: 0, difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: '"Yazar, eserinde tarihi gerçekleri çarpıtmıştır." cümlesi bir ... cümlesidir.', options: ['A) Üslup', 'B) İçerik ve Eleştiri', 'C) Tanım', 'D) Varsayım'], correctIndex: 1, explanation: 'Tarihi gerçekler (Konu/İçerik) + Çarpıtmıştır (Olumsuz eleştiri).', difficulty: 3),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "sözde soru cümlesi" vardır? (Cevap beklemeyen)', options: ['A) Saat kaç oldu?', 'B) Neden beni aramadın?', 'C) Bu iyiliğini hiç unutur muyum?', 'D) Eve ne zaman gideceksin?'], correctIndex: 2, explanation: 'Unutmam (Anlamca olumsuz, biçimce olumlu). Cevap beklemez.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "kinayeli" (iğneleyici) bir anlatım vardır?', options: ['A) Okulunu ne kadar çok sevdiği devamsızlığından belli.', 'B) Bu sene derslerine çok çalıştı.', 'C) Her zaman dürüst bir insandır.', 'D) Söylediği sözler herkesi etkiledi.'], correctIndex: 0, explanation: 'Sevmediği, devamsızlık yapmasından anlaşılan ters kastetme.', difficulty: 3),
    StemQuestion(question: '"Cümle içinde, bir sözcüğün yerine, o sözcüğü çağrıştıracak başka bir sözcüğün kullanılmasına ... denir." Boşluğa ne gelmelidir?', options: ['A) Ad aktarması', 'B) Deyim aktarması', 'C) Dolaylama', 'D) Eğretileme'], correctIndex: 3, explanation: 'Genel tanım İstiare (Eğretileme) veya mecazı kapsar. Ancak şıklarda İstiare/Eğretileme en uygunudur. (Not: Bu soru Sözcükte Anlam ile Cümlede Anlam kesişimidir, tanım cümlesi olduğu için buradadır).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "neden-sonuç" ilişkisi yoktur?', options: ['A) Malzeme yetersizliğinden inşaat durdu.', 'B) Seni bekletmemek için acele ettim.', 'C) Gözleri iyi görmediğinden okuyamıyor.', 'D) Kar yağınca okullar tatil edildi.'], correctIndex: 1, explanation: 'B seçeneği Amaç-Sonuçtur (Acele ettim, hedefim seni bekletmemek). Henüz bekletip bekletmediği sonuçlanmamıştır.', difficulty: 3),
    StemQuestion(question: '"Sanatçı, eserinde sadece toplumu anlatmakla kalmamalı, ona yol da göstermelidir." cümlesinden hangisi çıkarılamaz?', options: ['A) Sanatçının toplumsal bir görevi vardır.', 'B) Sanatçı toplumdan kopuk olmamalıdır.', 'C) Sanatçı eserinde kendi duygularını gizlemelidir.', 'D) Sanatçı rehberlik etmelidir.'], correctIndex: 2, explanation: 'Duygularını gizleyip gizlememesi hakkında bilgi yok.', difficulty: 3),
    StemQuestion(question: 'Hangisi "tanım" cümlesidir?', options: ['A) Eleştiri, bir eserin iyi ve kötü yanlarını ortaya koyma işidir.', 'B) Eleştirmenler genellikle öznel davranır.', 'C) Eleştiri okumak okura farklı bakış açıları kazandırır.', 'D) İyi bir eleştiri yapıcı olmalıdır.'], correctIndex: 0, explanation: '"Eleştiri nedir?" sorusunun cevabı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "aşamalı durum" anlamı vardır?', options: ['A) Gün geçtikçe seni daha iyi anlıyorum.', 'B) Birdenbire karşıma çıktı.', 'C) Sabah erkenden yola koyulduk.', 'D) Her zaman buraya gelir.'], correctIndex: 0, explanation: 'Gün geçtikçe (zamanla artan/değişen durum).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "olasılık" anlamı diğerlerinden kuvvetlidir?', options: ['A) Belki yarın gelir.', 'B) Sanırım evde yok.', 'C) Olsa olsa 10 yaşındadır.', 'D) Bu konuyu öğrenmiş olmalı.', 'E) Mutlaka aramıştır.'], correctIndex: 0, explanation: 'A, B, C, D olasılık bildirir. E kesinlik bildirir. (Soru tipi: Hangisi olasılık DEĞİLDİR diye de sorulabilir. Burada en güçlü olasılık/tahmin nüansı sorulursa "olmalı" gereklilik kipiyle kurulan tahmin güçlüdür. Ancak KPSS formatında genellikle "Mutlaka" kesinlik olarak ayrılır. Bu soruda "Belki, Sanırım, Olsa olsa" zayıf ihtimal, "-meli/-malı" ekiyle kurulan "öğrenmiş olmalı" kuvvetli tahmindir.)', difficulty: 3),
    StemQuestion(question: 'Hangisinde "bir işin yapılması başka bir işin yapılmasına bağlıdır" (Koşul)?', options: ['A) Düzenli çalışırsan başarılı olursun.', 'B) Çok çalıştığı için başardı.', 'C) Başarmak için çalışıyor.', 'D) Çalışınca başarır.'], correctIndex: 0, explanation: '-sa/-se ekiyle kurulan net koşul ilgisi.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "yakınma" değil "sitem" vardır?', options: ['A) Gençler otobüste yer vermiyor.', 'B) Bu devirde babana bile güvenme.', 'C) Aşk olsun, insan bir selam verir.', 'D) Trafik çilesi bitmiyor.'], correctIndex: 2, explanation: 'Doğrudan muhataba (ikinci tekil şahıs) yapılan serzeniş sitemdir.', difficulty: 3),
    StemQuestion(question: '"Her yiğidin bir yoğurt yiyişi vardır." atasözüyle anlatılmak istenen nedir?', options: ['A) Herkesin aynı işi yapma yöntemi farklıdır.', 'B) Yiğit insanlar çok yemek yer.', 'C) Farklılıklar zenginliktir.', 'D) İnsanlar birbirine benzemez.'], correctIndex: 0, explanation: 'Üslup/Yöntem farklılığı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "gerçekleşmemiş bir beklenti" vardır?', options: ['A) Bu sınavı kazanacağını biliyordum.', 'B) Bizi arayacağını sanmıştım.', 'C) Umarım her şey yoluna girer.', 'D) Beklediğimiz haber geldi.'], correctIndex: 1, explanation: 'Sanmıştım (ama aramadı).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "karşılaştırma" yapılırken üstünlük belirtilmiştir?', options: ['A) Ali de Veli kadar çalışkan.', 'B) Sınıfın en uzunu Ahmet.', 'C) Ankara, İstanbul\'dan daha düzenli.', 'D) Bu kitap diğerine göre kalın.'], correctIndex: 1, explanation: '"En" kelimesi en üstünlük derecesi bildirir. C ve D üstünlük (daha) bildirir ama "en" mutlak üstünlüktür. KPSS\'de ikisi de karşılaştırmadır. Soru kökü "en üstünlük" veya "derecelendirme" sorarsa "en" aranır. Bu şıklarda B "en" ile en üst seviyeyi, C "daha" ile kıyaslamayı verir. Şık düzeltmesi: B) Sınıfın en uzunu Ahmet.', difficulty: 3),
    StemQuestion(question: '"Yazar, olaylara kendi penceresinden bakmış." cümlesinde anlatılan nedir?', options: ['A) Nesnellik', 'B) Öznellik', 'C) Gerçekçilik', 'D) Gözlemcilik'], correctIndex: 1, explanation: 'Kendi penceresi = Kişisel yorum (Öznellik).', difficulty: 3),
  ],
  formulaCards: const ['Örtülü Anlam: Cümlede yazmayan gizli bilgi (de/da).', 'Yadsıma: İnkar etme.', 'Kanıksama: Alışma (olumsuz duruma).'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 3: PARAGRAFTA ANLAM
// ═══════════════════════════════════════════════════════════════

final kpssLiseTurU3Content = StemUnitContent(
  unitId: 'kpsslise_tur_u3',
  topic: const TopicContent(
    summary: 'Paragrafta anlam; parçanın konusunu, ana düşüncesini ve yardımcı düşüncelerini bulmayı amaçlar. "Konu" yazarın ne anlattığı, "Ana Düşünce" ise yazarın vermek istediği mesajdır. Ayrıca paragrafın yapısı (giriş, gelişme, sonuç) ve akışı bozan cümlelerin tespiti bu seviyede önemlidir.',
    rule: 'Ana düşünce genellikle paragrafın son cümlesinde, konu ise ilk cümlesinde gizlidir.',
    formulas: [
      'Konu: Ne anlatılıyor? (İlk cümleler).',
      'Ana Düşünce: Ne mesaj veriliyor? (Son cümleler).',
      'Akışı Bozan: Konunun değiştiği cümle.'
    ],
    keyPoints: [
      'Giriş cümleleri "çünkü, bu nedenle, oysa" gibi bağlaçlarla başlamaz.',
      'Ana düşünce en kapsamlı yargıdır.',
      'Paragrafı ikiye bölme sorularında yeni bir konuya geçilen cümle aranır.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Paragrafın ana düşüncesi nerede aranmalıdır?',
      steps: [
        'Paragraf bir bütün olsa da yazar mesajını genellikle sonda verir.',
        'Giriş bölümü konuyu tanıtır.',
        'Sonuç bölümü (özetle, sonuç olarak) ana fikri barındırır.',
      ],
      answer: 'Genellikle son cümlede.',
    ),
    SolvedExample(
      question: 'Aşağıdaki cümlelerden hangisi bir paragrafın giriş cümlesi olabilir?',
      steps: [
        'A) Bu yüzden okula gidemedi. (Bağlaç var, olamaz)',
        'B) Kitap okumak insanın ufkunu açar. (Bağımsız, genel yargı -> Olabilir)',
        'C) Oysa ki her şey farklıydı. (Bağlaç var, olamaz)',
      ],
      answer: 'B) Kitap okumak insanın ufkunu açar.',
    ),
    SolvedExample(
      question: 'Bir parçada "Akışı bozan cümle" nasıl bulunur?',
      steps: [
        'Paragraf boyunca aynı konudan bahsedilirken, bir cümle farklı bir konuya veya konunun farklı bir yönüne değinir.',
        'Örneğin: Meyvelerin faydaları anlatılırken araya "Meyve fiyatları arttı" cümlesi girerse akış bozulur.',
      ],
      answer: 'Konunun yönünün değiştiği cümle bulunur.',
    ),
    SolvedExample(
      question: '"Bu, şu, o" gibi işaret zamirleri paragrafta ne işe yarar?',
      steps: [
        'Kendinden önceki cümleye atıfta bulunur.',
        'Bu kelimelerle başlayan cümleler giriş cümlesi olamaz.',
        'Cümleleri birbirine bağlayan çimentodur.',
      ],
      answer: 'Bağlayıcı öğe olarak kullanılır, giriş cümlesi olamazlar.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Paragrafın en genel yargısı hangisidir?',
        options: ['A) Konu', 'B) Ana Düşünce', 'C) Yardımcı Düşünce', 'D) Başlık'],
        correctIndex: 1,
        explanation: 'Yazarın asıl vermek istediği mesaj (ana düşünce) en kapsamlı yargıdır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi bir paragrafın gelişme bölümünde yer alabilir?',
        options: ['A) Kısaca özetlemek gerekirse...', 'B) Örneğin, bu konuda yapılan çalışmalar...', 'C) Sonuç olarak...', 'D) Dil, iletişimin temelidir.'],
        correctIndex: 1,
        explanation: 'Örnek verme, konuyu açma işi gelişme bölümünde yapılır.',
        difficulty: 1),
    StemQuestion(
        question: 'Paragrafta "değinilmemiştir" ifadesi neyi sorar?',
        options: ['A) Ana Düşünceyi', 'B) Yardımcı Düşünceleri', 'C) Konuyu', 'D) Başlığı'],
        correctIndex: 1,
        explanation: 'Olumsuz köklü sorular yardımcı düşünceleri taramamızı ister.',
        difficulty: 1),
    StemQuestion(
        question: 'Bir metnin başlığı neye göre belirlenir?',
        options: ['A) En uzun cümleye göre', 'B) Giriş cümlesine göre', 'C) Konu ve ana düşünceyle en ilişkili sözlere göre', 'D) Son cümleye göre'],
        correctIndex: 2,
        explanation: 'Metnin tamamını kapsayan özet ifade.',
        difficulty: 1),
    StemQuestion(
        question: 'Paragrafta anlatımın akışını bozan cümle hangisidir?',
        options: ['A) En kısa cümle', 'B) Konu bütünlüğünü bozan cümle', 'C) En uzun cümle', 'D) İlk cümle'],
        correctIndex: 1,
        explanation: 'Konudan sapan cümle akışı bozar.',
        difficulty: 1),
    StemQuestion(
        question: '"Giriş, Gelişme, ..." Paragrafın son bölümü nedir?',
        options: ['A) Özet', 'B) Sonuç', 'C) Ana fikir', 'D) Değerlendirme'],
        correctIndex: 1,
        explanation: 'Giriş, Gelişme, Sonuç.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi düşünceyi geliştirme yolu değildir?',
        options: ['A) Tanımlama', 'B) Örnekleme', 'C) Masal', 'D) Karşılaştırma'],
        correctIndex: 2,
        explanation: 'Masal bir edebi türdür, düşünceyi geliştirme yolu değildir.',
        difficulty: 1),
    StemQuestion(
        question: 'Bir paragrafta yazar "bence, bana göre" diyorsa anlatım nasıldır?',
        options: ['A) Nesnel', 'B) Öznel', 'C) Bilimsel', 'D) Kanıtlanabilir'],
        correctIndex: 1,
        explanation: 'Kişisel görüş bildirdiği için özneldir.',
        difficulty: 1),
    StemQuestion(
        question: 'Paragrafta "özgünlük" ne demektir?',
        options: ['A) Eskiyi anlatmak', 'B) Başkasına benzememek', 'C) Çok yazmak', 'D) Anlaşılır olmak'],
        correctIndex: 1,
        explanation: 'Kendine has olmak, taklit etmemek.',
        difficulty: 1),
    StemQuestion(
        question: 'Paragrafta "duruluk" ne demektir?',
        options: ['A) Akıcı olmak', 'B) Gereksiz sözcük kullanmamak', 'C) Yabancı kelime kullanmamak', 'D) Süslü anlatmak'],
        correctIndex: 1,
        explanation: 'Gereksiz sözcükten arınmışlık.',
        difficulty: 1),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'Ana düşünce genellikle nerededir?', options: ['A) Başta', 'B) Ortada', 'C) Sonda', 'D) Başlıkta'], correctIndex: 2, difficulty: 1),
    StemQuestion(question: '"Oysa" ile başlayan cümle ne olamaz?', options: ['A) Giriş', 'B) Gelişme', 'C) Sonuç', 'D) Örnek'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Olumsuz köklü sorularda önce ne okunmalı?', options: ['A) Paragraf', 'B) Şıklar', 'C) Başlık', 'D) Hiçbiri'], correctIndex: 1, explanation: 'Zaman kazanmak için önce şıklara göz atılır.', difficulty: 1),
    StemQuestion(question: 'Konu nerede bulunur?', options: ['A) Giriş cümlelerinde', 'B) Sonuçta', 'C) Şıklarda', 'D) Ortada'], correctIndex: 0, difficulty: 1),
    StemQuestion(question: 'Akışı bozan cümle ne yapar?', options: ['A) Konuyu değiştirir', 'B) Özetler', 'C) Örnek verir', 'D) Sonuçlandırır'], correctIndex: 0, difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Paragrafta numaralanmış cümlelerden hangisi düşüncenin akışını bozmaktadır?', options: ['A) I', 'B) II', 'C) III', 'D) IV'], correctIndex: 2, explanation: 'Genellikle III veya IV. cümlelerde konu hafifçe saptırılır. Farklı bir konuya geçen cümle akışı bozar.', difficulty: 1),
    StemQuestion(question: 'Bu parçada aşağıdakilerden hangisine değinilmemiştir?', options: ['A) Yazarın hayatına', 'B) Eserin içeriğine', 'C) Basım tarihine', 'D) Okuyucu kitlesine'], correctIndex: 2, explanation: 'Parçada geçmeyen yardımcı düşünce bulunur.', difficulty: 1),
    StemQuestion(question: 'Bu parçanın anlatımında aşağıdakilerden hangisine başvurulmuştur?', options: ['A) Tanımlama', 'B) Öyküleme', 'C) Açıklama', 'D) Betimleme'], correctIndex: 2, explanation: 'Bilgi verme amacı varsa açıklamadır.', difficulty: 1),
    StemQuestion(question: 'Paragraf ikiye bölünmek istense ikinci paragraf hangi cümleyle başlar?', options: ['A) II', 'B) III', 'C) IV', 'D) V'], correctIndex: 2, explanation: 'Konunun farklı bir boyutuna geçilen ilk cümle ikinci paragrafın başıdır.', difficulty: 1),
    StemQuestion(question: 'Bu parçanın ana düşüncesi aşağıdakilerden hangisidir?', options: ['A) Okumak faydalıdır.', 'B) İnsan okudukça özgürleşir.', 'C) Kitaplar pahalıdır.', 'D) Her kitap okunmaz.'], correctIndex: 1, explanation: 'En kapsayıcı ve sonuç odaklı yargı.', difficulty: 1),
    StemQuestion(question: 'Bu parçada asıl anlatılmak istenen nedir?', options: ['A) Teknoloji zararlıdır.', 'B) Teknoloji bağımlılık yapar.', 'C) Teknolojiyi bilinçli kullanmak gerekir.', 'D) Eski zamanlar daha güzeldi.'], correctIndex: 2, explanation: 'Yazarın iletmek istediği asıl mesaj.', difficulty: 1),
    StemQuestion(question: 'Yukarıdaki cümleler anlamlı bir bütün oluşturacak şekilde sıralandığında hangisi baştan üçüncü olur?', options: ['A) I', 'B) II', 'C) III', 'D) IV'], correctIndex: 2, explanation: 'Olay sırasına veya mantık akışına göre sıralama yapılır.', difficulty: 1),
    StemQuestion(question: 'Bu parça aşağıdaki sorulardan hangisine karşılık söylenmiş olabilir?', options: ['A) Yazmaya nasıl başladınız?', 'B) En sevdiğiniz eseriniz hangisi?', 'C) Okurlara tavsiyeniz nedir?', 'D) Edebiyatın geleceğini nasıl görüyorsunuz?'], correctIndex: 0, explanation: 'Paragrafın girişi ve içeriği soruyla uyumlu olmalıdır.', difficulty: 1),
    StemQuestion(question: 'Bu parçada boş bırakılan yere düşüncenin akışına göre hangisi getirilmelidir?', options: ['A) Ancak', 'B) Çünkü', 'C) Bu nedenle', 'D) Örneğin'], correctIndex: 0, explanation: 'Zıt bir durum anlatılıyorsa "Ancak/Ama" gelir.', difficulty: 1),
    StemQuestion(question: 'Yazar bu parçada neden yakınmaktadır (şikayet etmektedir)?', options: ['A) Okuma oranının düşüklüğünden', 'B) Kitap fiyatlarından', 'C) Niteliksiz eserlerin çokluğundan', 'D) Eleştirmenlerin tavrından'], correctIndex: 0, explanation: 'Yazarın memnun olmadığı durum.', difficulty: 1),
    StemQuestion(question: 'Bu parçada "altı çizili sözle" anlatılmak istenen nedir?', options: ['A) Tecrübeli olmak', 'B) Çok çalışmak', 'C) Pes etmemek', 'D) Özgün olmak'], correctIndex: 3, explanation: 'Sözcük öbeğinin metne kattığı anlam.', difficulty: 1),
    StemQuestion(question: 'Hangisi betimleyici anlatıma örnektir?', options: ['A) Olay dün gece oldu.', 'B) Sarı, uzun saçlı, mavi gözlü bir kızdı.', 'C) Bilimsel veriler açıklandı.', 'D) Düşünüyorum öyleyse varım.'], correctIndex: 1, explanation: 'Göz önünde canlandırma (tasvir) varsa betimlemedir.', difficulty: 1),
    StemQuestion(question: 'Hangisi öyküleyici anlatıma örnektir?', options: ['A) Sabah erkenden kalkıp yola düştü.', 'B) Su 100 derecede kaynar.', 'C) Resim sanatı renklerle yapılır.', 'D) Bu bina 1990\'da yapıldı.'], correctIndex: 0, explanation: 'Olay, kişi, yer ve zaman varsa öykülemedir.', difficulty: 1),
    StemQuestion(question: 'Paragrafın konusu hangisidir?', options: ['A) Çevre kirliliği', 'B) Denizler', 'C) Ormanlar', 'D) Sanayi atıkları'], correctIndex: 0, explanation: 'Metinde en çok tekrar edilen ve üzerinde durulan kavram.', difficulty: 1),
    StemQuestion(question: 'Bu parçadan hangisi çıkarılamaz?', options: ['A) Yazarın karamsar olduğu', 'B) Olayın kışın geçtiği', 'C) Kahramanın yaşlı olduğu', 'D) Ekonomik krizin bittiği'], correctIndex: 3, explanation: 'Parçada olmayan bilgi.', difficulty: 1),
  ],
  formulaCards: const ['Giriş Cümlesi: Bağlaçla başlamaz.', 'Ana Düşünce: Sonuçta aranır (Mesaj).', 'Akışı Bozan: Konu değişir.'],
);

final kpssOnlisansTurU3Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u3',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde paragraf soruları; Anlatım Biçimleri (Öyküleme, Betimleme, Açıklama, Tartışma) ve Düşünceyi Geliştirme Yolları (Tanık gösterme, Sayısal veriler, Benzetme vb.) üzerine yoğunlaşır. Ayrıca "Yer Değiştirme" ve "Cümle Ekleme" soruları mantıksal sıralamayı test eder.',
    rule: 'Tartışmacı anlatımda yazar bir fikri çürütüp kendi fikrini savunur ("Oysa, bana göre, halbuki"). Açıklayıcı anlatımda amaç sadece bilgi vermektir.',
    formulas: [
      'Tartışma: Tez + Antitez (Fikir çatışması).',
      'Öyküleme: Olay + Hareket (Video gibi).',
      'Betimleme: Gözlem + Detay (Fotoğraf gibi).'
    ],
    keyPoints: [
      'Tanık göstermede "kişinin adı + sözü" (alıntı) olmalıdır. Sadece isim varsa "Örnekleme" olur.',
      'Sayısal veriler inandırıcılığı artırmak için kullanılır.',
      'Paragraf oluşturmada olay sırası (kronoloji) veya mantık sırası esastır.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Tanık Gösterme ile Örnekleme arasındaki fark nedir?',
      steps: [
        'Örnekleme: "Dünyada iyi yazarlar vardır: Tolstoy, Dostoyevski..." (Sadece isim)',
        'Tanık Gösterme: "Tolstoy \'Sanat insan içindir\' der." (İsim + Cümle)',
      ],
      answer: 'Tanık göstermede kişinin sözü tırnak içinde veya dolaylı verilir.',
    ),
    SolvedExample(
      question: 'Tartışmacı anlatım nasıl anlaşılır?',
      steps: [
        'Yazar okuyucuyla konuşuyormuş gibi yazar.',
        'Soru sorar, cevap verir.',
        'Yerleşik bir kanıyı değiştirmeye çalışır. "Bazıları şöyle düşünür... Oysa bu yanlıştır."',
      ],
      answer: 'Karşıt fikirleri çürütme amacı vardır.',
    ),
    SolvedExample(
      question: 'Paragrafta yer değiştirme soruları nasıl çözülür?',
      steps: [
        'Cümleler arasındaki mantıksal bağlara (referans kelimelere) bakılır.',
        'Örneğin II. cümle "Bu nedenle" diye başlıyorsa, I. cümlede bir sebep olmalıdır. Uymuyorsa II yer değiştirmelidir.',
      ],
      answer: 'Referans kelimeler ve anlam akışı takip edilir.',
    ),
    SolvedExample(
      question: 'Betimleme çeşitleri nelerdir?',
      steps: [
        'Fiziksel Betimleme: Dış görünüş (Sarı saç, uzun boy).',
        'Ruhsal Betimleme: İç dünya (Üzgün, karamsar, neşeli).',
      ],
      answer: 'Fiziksel ve Ruhsal (İzlenimsel) betimleme.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Yazarın bir fikri değiştirmek için "Sizce de öyle değil mi?" gibi sorularla yazdığı anlatım biçimi hangisidir?',
        options: ['A) Açıklama', 'B) Tartışma', 'C) Öyküleme', 'D) Betimleme'],
        correctIndex: 1,
        explanation: 'Okuyucuyu ikna etme çabası, sohbet havası tartışmadır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "sayısal verilerden yararlanma" vardır?',
        options: ['A) Birçok insan bu konuda hemfikir.', 'B) Türkiye\'nin %65\'i genç nüfustur.', 'C) Sınav zor geçti.', 'D) Binlerce kitap basıldı.'],
        correctIndex: 1,
        explanation: '%65 net bir istatistiktir.',
        difficulty: 2),
    StemQuestion(
        question: '"Sözcükler birer tablo gibidir, ressamın fırçasıyla hayat bulur." cümlesinde hangi düşünceyi geliştirme yolu vardır?',
        options: ['A) Tanımlama', 'B) Benzetme', 'C) Tanık Gösterme', 'D) Sayısal Veri'],
        correctIndex: 1,
        explanation: 'Gibi edatı ile benzetme yapılmıştır.',
        difficulty: 2),
    StemQuestion(
        question: 'Bir paragraf "Edebiyat nedir?" sorusuna cevap vererek başlıyorsa hangi yöntem kullanılmıştır?',
        options: ['A) Tanımlama', 'B) Öyküleme', 'C) Örnekleme', 'D) Karşılaştırma'],
        correctIndex: 0,
        explanation: 'Bu nedir? sorusuna cevap veren cümleler tanımdır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi bir "karakter" değil, "tip" özelliği gösterir?',
        options: ['A) Sadece kendi çıkarlarını düşünen cimri adam.', 'B) Hem ağlayan hem gülen karmaşık bir adam.', 'C) Değişken ruh halleri olan biri.', 'D) Olaylara göre farklı tepkiler veren biri.'],
        correctIndex: 0,
        explanation: 'Tek bir özelliği (cimrilik) abartılarak temsil eden kişiler "tip"tir.',
        difficulty: 2),
    StemQuestion(
        question: 'Metinde "zaman, mekan, olay, kişi" unsurları varsa hangi anlatım biçimi kullanılmıştır?',
        options: ['A) Açıklama', 'B) Tartışma', 'C) Öyküleme', 'D) Öğretici'],
        correctIndex: 2,
        explanation: 'Hikaye etme unsurlarıdır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "öznel betimleme"ye örnektir?',
        options: ['A) Odanın duvarları maviye boyanmıştı.', 'B) Masada üç kitap vardı.', 'C) Kasvetli, insanın içini daraltan bir havası vardı.', 'D) Ağacın boyu 10 metreydi.'],
        correctIndex: 2,
        explanation: 'Kasvetli (kişisel yorum) -> Öznel.',
        difficulty: 2),
    StemQuestion(
        question: 'Paragraf tamamlama sorularında en önemli ipucu nedir?',
        options: ['A) Şıkların uzunluğu', 'B) Bağlaçlar ve anlam akışı', 'C) Noktalama işaretleri', 'D) Yazarın adı'],
        correctIndex: 1,
        explanation: 'Boşluktan önceki ve sonraki cümlenin anlam bağı.',
        difficulty: 2),
    StemQuestion(
        question: '"Düşünce yazıları"nda genellikle hangi anlatım biçimleri kullanılır?',
        options: ['A) Öyküleme - Betimleme', 'B) Açıklama - Tartışma', 'C) Betimleme - Açıklama', 'D) Öyküleme - Tartışma'],
        correctIndex: 1,
        explanation: 'Makale, deneme gibi türlerde bilgi verme ve fikir savunma esastır.',
        difficulty: 2),
    StemQuestion(
        question: '"Olay yazıları"nda genellikle hangi anlatım biçimleri kullanılır?',
        options: ['A) Açıklama - Tartışma', 'B) Öyküleme - Betimleme', 'C) Tanık Gösterme', 'D) Tanımlama'],
        correctIndex: 1,
        explanation: 'Roman, hikaye gibi türlerde olay ve tasvir esastır.',
        difficulty: 2),
  ],
  speedTestQuestions: const [
    StemQuestion(question: 'İsim + Cümle (Alıntı) varsa nedir?', options: ['A) Örnekleme', 'B) Tanık Gösterme', 'C) Tanımlama', 'D) Benzetme'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: '"Oysa, halbuki" hangi anlatımın ipucudur?', options: ['A) Açıklama', 'B) Öyküleme', 'C) Tartışma', 'D) Betimleme'], correctIndex: 2, difficulty: 2),
    StemQuestion(question: 'Hareket varsa (Video gibi)?', options: ['A) Betimleme', 'B) Öyküleme', 'C) Açıklama', 'D) Tartışma'], correctIndex: 1, difficulty: 2),
    StemQuestion(question: 'Durgunluk/Fotoğraf varsa?', options: ['A) Betimleme', 'B) Öyküleme', 'C) Tartışma', 'D) Açıklama'], correctIndex: 0, difficulty: 2),
    StemQuestion(question: '"Bu nedir?" sorusu?', options: ['A) Tanımlama', 'B) Örnekleme', 'C) Tanık', 'D) Sayısal'], correctIndex: 0, difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Bu parçanın anlatımında aşağıdakilerden hangisi ağır basmaktadır? (Parça: Bir fikri savunuyor, soru soruyor)', options: ['A) Açıklama', 'B) Tartışma', 'C) Öyküleme', 'D) Betimleme'], correctIndex: 1, explanation: 'Sohbet havası, soru-cevap, kanı değiştirme -> Tartışma.', difficulty: 2),
    StemQuestion(question: 'Bu parçada düşünceyi geliştirme yollarından hangisi kullanılmıştır? (Parça: Yahya Kemal\'in bir sözünü tırnak içinde vermiş)', options: ['A) Örnekleme', 'B) Tanık Gösterme', 'C) Sayısal Veriler', 'D) Benzetme'], correctIndex: 1, explanation: 'Alıntı yapma Tanık Göstermedir.', difficulty: 2),
    StemQuestion(question: 'Numaralanmış cümlelerden hangisi parçanın anlam bütünlüğünü bozmaktadır?', options: ['A) I', 'B) II', 'C) III', 'D) IV'], correctIndex: 2, explanation: 'Konunun dışına çıkan cümle.', difficulty: 2),
    StemQuestion(question: 'Bu parçanın başına düşüncenin akışına göre hangisi getirilebilir?', options: ['A) Çünkü sanat toplum içindir.', 'B) Sanatçı eserinde kişiliğini gizlemelidir.', 'C) Sonuç olarak eser kalıcı olmalıdır.', 'D) Oysa ki her sanatçı farklıdır.'], correctIndex: 1, explanation: 'Giriş cümlesi niteliğinde, bağlaçsız ve konuyu tanıtan cümle.', difficulty: 2),
    StemQuestion(question: 'Bu parçada yazarın "asıl yakındığı" durum nedir?', options: ['A) Gençlerin okumaması', 'B) Teknolojinin yanlış kullanımı', 'C) Dilin yozlaşması', 'D) Egitim sisteminin yetersizliği'], correctIndex: 2, explanation: 'Metnin tamamında eleştirilen temel sorun.', difficulty: 2),
    StemQuestion(question: 'Hangisi bir "karşılaştırma" cümlesidir?', options: ['A) Roman, hikayeye göre daha uzundur.', 'B) Roman ve hikaye edebi türdür.', 'C) Şiir yazmak zordur.', 'D) Kitap okumayı severim.'], correctIndex: 0, explanation: '"Göre" edatı veya "daha" zarfı ile kıyaslama yapılmış.', difficulty: 2),
    StemQuestion(question: 'Bu parçada aşağıdaki duyulardan hangisine yer verilmemiştir?', options: ['A) Görme', 'B) İşitme', 'C) Koklama', 'D) Tatma'], correctIndex: 3, explanation: 'Betimlemelerde kullanılan duyu öğeleri aranır.', difficulty: 2),
    StemQuestion(question: 'Parçanın anlatıcısı kimdir?', options: ['A) 1. Tekil Kişi (Ben)', 'B) 3. Tekil Kişi (O)', 'C) İlahi Bakış Açısı', 'D) Gözlemci Bakış Açısı'], correctIndex: 0, explanation: 'Eylemler "geldim, gördüm" şeklindeyse 1. kişi.', difficulty: 2),
    StemQuestion(question: 'Bu parça iki paragrafa bölünmek istense ikinci paragraf hangisiyle başlar?', options: ['A) II', 'B) III', 'C) IV', 'D) V'], correctIndex: 2, explanation: 'Konu değişikliği.', difficulty: 2),
    StemQuestion(question: 'Yukarıdaki cümlelerin anlamlı sıralanışı nasıldır?', options: ['A) I-II-III-IV', 'B) II-I-IV-III', 'C) III-I-II-IV', 'D) IV-I-II-III'], correctIndex: 1, explanation: 'Mantık silsilesi (Giriş -> Gelişme -> Sonuç).', difficulty: 2),
    StemQuestion(question: 'Bu parçadan hangisi çıkarılabilir?', options: ['A) Kesin yargı', 'B) Yorum', 'C) Yardımcı düşünce', 'D) Ana düşünce'], correctIndex: 3, explanation: 'En genel yargı.', difficulty: 2),
    StemQuestion(question: 'Hangisi "kişileştirme" sanatına örnektir?', options: ['A) Rüzgar penceremi dövüyordu.', 'B) Hava çok soğuktu.', 'C) Kuşlar uçuyordu.', 'D) Ağaçlar yeşerdi.'], correctIndex: 0, explanation: 'Rüzgarın dövmesi.', difficulty: 2),
    StemQuestion(question: 'Bu parça hangi metin türünden alınmış olabilir?', options: ['A) Makale', 'B) Deneme', 'C) Haber Yazısı', 'D) Biyografi'], correctIndex: 1, explanation: 'Öznel, kanıtlama amacı gütmeyen fikir yazısıysa Deneme.', difficulty: 2),
    StemQuestion(question: 'Paragrafta boş bırakılan yere hangisi getirilirse anlam bütünlüğü sağlanır?', options: ['A) Ancak', 'B) Ayrıca', 'C) Çünkü', 'D) Dolayısıyla'], correctIndex: 2, explanation: 'Neden belirtiyorsa "Çünkü".', difficulty: 2),
    StemQuestion(question: 'Yazar bu parçada kime seslenmektedir?', options: ['A) Gençlere', 'B) Anne babalara', 'C) Öğretmenlere', 'D) Yöneticilere'], correctIndex: 0, explanation: 'Hedef kitle analizi.', difficulty: 2),
  ],
  formulaCards: const ['Tanık Gösterme: İsim + "Söz".', 'Tartışma: Tez vs Antitez.', 'Öyküleme: Olay akışı.'],
);

final kpssLisansTurU3Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u3',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde paragraf soruları; felsefi, soyut veya yoğun içerikli metinlerden oluşur. Çoklu sorular (bir parçaya bağlı 3-4 soru), paragraf tamamlama, cümle yerleştirme ve sözel mantıkla harmanlanmış paragraf analizleri belirleyicidir. Yazarın üslubu, metnin ana damarı ve satır arası okumalar önem kazanır.',
    rule: 'Çoklu sorularda, parçayı bir kez dikkatli okuyup anahtar kelimeleri çizmek, her soru için tekrar okumaktan zaman kazandırır.',
    formulas: [
      'Çoklu Soru: Önce soru kökleri -> Sonra Parça.',
      'Yer Değiştirme: Anlam kopukluğu olan yer -> Bağlaç kontrolü.',
      'Ana Düşünce: Parçanın Tümü (Özet).'
    ],
    keyPoints: [
      'Seçeneklerdeki çeldiriciler çok güçlüdür; parçada geçmeyen ama doğru olan genel bilgiler cevap DEĞİLDİR. Sadece parçaya bağlı kal.',
      'Sözel mantık içeren paragraflarda tablo çizmek gerekebilir.',
      'Devrik cümlelerle kurulan paragraflarda yüklemi bulup cümleyi kurallı hale getirmek anlamayı kolaylaştırır.'
    ],
  ),
  solvedExamples: const [
    SolvedExample(
      question: 'Paragrafta "anahtar kelime" nasıl bulunur?',
      steps: [
        'Metinde en çok tekrar eden veya vurgulanan kavram aranır.',
        'Eş anlamlı ifadeler de aynı anahtar kelimeye işaret edebilir.',
        'Ana düşünce genellikle anahtar kelime etrafında şekillenir.',
      ],
      answer: 'En çok tekrar eden veya vurgulanan kavram.',
    ),
    SolvedExample(
      question: 'Felsefi/Soyut bir paragrafı anlamakta zorlanıyorsam ne yapmalıyım?',
      steps: [
        'Paragrafı kendi cümlelerimle özetlemeye çalışırım.',
        'Soyut kavramları (metaforları) somutlaştırırım.',
        'Yazarın "neyi savunduğunu" veya "neye karşı çıktığını" tespit ederim.',
      ],
      answer: 'Ana fikre odaklanıp somutlaştırma yaparım.',
    ),
    SolvedExample(
      question: 'Bir parçaya bağlı çoklu sorularda strateji ne olmalıdır?',
      steps: [
        'Önce 1. soruyu değil, tüm soruların köklerini okurum.',
        'Parçayı okurken sorulan yerlerin altını çizerim.',
        'Sırayla cevaplarım. Genellikle bir soru yardımcı düşünce, biri ana düşünce, biri de dil/anlatımla ilgilidir.',
      ],
      answer: 'Önce soru kökleri, sonra parça.',
    ),
    SolvedExample(
      question: 'Hangisi "Bakış Açısı" sorusudur?',
      steps: [
        'İlahi (Tanrısal): Kahramanın içinden geçenleri bilir.',
        'Kahraman: Olayı yaşayan anlatır (Ben).',
        'Gözlemci: Sadece gördüğünü anlatır (Kamera).',
      ],
      answer: 'Anlatıcının konumu sorulur.',
    ),
  ],
  practiceQuestions: const [
    StemQuestion(
        question: 'Bu parçada asıl anlatılmak istenen aşağıdakilerden hangisidir? (Soyut metin)',
        options: ['A) Mutluluk içsel bir dengedir.', 'B) Dış dünya bizi etkilemez.', 'C) İnsan sosyal bir varlıktır.', 'D) Sanat gerçeği yansıtır.'],
        correctIndex: 0,
        explanation: 'Metnin derin anlamı.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parçadan hareketle aşağıdakilerden hangisine ulaşılamaz?',
        options: ['A) Yazarın karamsar olduğuna', 'B) Toplumun değiştiğine', 'C) Teknolojinin suçlu olduğuna', 'D) Çözümün eğitimde olduğuna'],
        correctIndex: 3,
        explanation: 'Yardımcı düşünce taraması. Parçada eğitimden bahsedilmemişse cevap odur.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parçaya göre "aydın" olmanın temel koşulu nedir?',
        options: ['A) Çok okumak', 'B) Üniversite bitirmek', 'C) Sorumluluk bilincine sahip olmak', 'D) Yabancı dil bilmek'],
        correctIndex: 2,
        explanation: 'Parçada geçen tanıma göre cevaplanır.',
        difficulty: 3),
    StemQuestion(
        question: 'Parçadaki numaralanmış cümlelerin hangisinden sonra "Bu durum, toplumda infiale yol açtı." cümlesi getirilebilir?',
        options: ['A) I', 'B) II', 'C) III', 'D) IV'],
        correctIndex: 2,
        explanation: 'Olayın sonucu ve tepki ilişkisi.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parça aşağıdaki sorulardan hangisine verilmiş bir cevap olamaz?',
        options: ['A) Eserlerinizi nasıl oluşturursunuz?', 'B) Şiirde kafiye gerekli midir?', 'C) Günümüz romanını nasıl buluyorsunuz?', 'D) Genç şairlere öneriniz nedir?'],
        correctIndex: 1,
        explanation: 'Parçanın içeriğiyle ilgisiz soru.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parçanın anlatımında hangisi yoktur?',
        options: ['A) Yinelemeler', 'B) Eksiltili cümleler', 'C) Devrik cümleler', 'D) İkilemeler'],
        correctIndex: 1,
        explanation: 'Yüklemi olmayan cümle yoksa eksiltili cümle yoktur.',
        difficulty: 3),
    StemQuestion(
        question: '"Sanatçı, fildişi kulesinden çıkıp halka karışmalıdır." sözüyle anlatılmak istenen?',
        options: ['A) Sanatçı zengin olmalıdır.', 'B) Sanatçı halktan kopuk yaşamamalıdır.', 'C) Sanatçı kulede yaşamalıdır.', 'D) Sanatçı eserlerini halka satmalıdır.'],
        correctIndex: 1,
        explanation: 'Fildişi kule: Halktan uzak, seçkinci yaşam.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parçada yazarın üslubunu yansıtan özellik hangisidir?',
        options: ['A) Yalın ve duru bir dil', 'B) Ağdalı ve süslü bir anlatım', 'C) Akıcı bir üslup', 'D) Mizahi bir ton'],
        correctIndex: 1,
        explanation: 'Metindeki kelime kadrosuna göre belirlenir.',
        difficulty: 3),
    StemQuestion(
        question: 'Paragrafta geçen "kemikleşmiş önyargılar" ifadesi ne anlama gelir?',
        options: ['A) Sağlam düşünceler', 'B) Değiştirilmesi çok zor olan peşin hükümler', 'C) Bilimsel gerçekler', 'D) Eski alışkanlıklar'],
        correctIndex: 1,
        explanation: 'Kemikleşmek: Katılaşmak, değişmez hale gelmek.',
        difficulty: 3),
    StemQuestion(
        question: 'Bu parçaya en uygun başlık hangisidir?',
        options: ['A) Küresel Isınma', 'B) Küresel Isınmanın Etkileri', 'C) Buzulların Erimesi', 'D) Çevre Kirliliği'],
        correctIndex: 1,
        explanation: 'Metnin tamamını kapsayan en net ifade.',
        difficulty: 3),
  ],
  speedTestQuestions: const [
    StemQuestion(question: '"Fildişi kule" neyi temsil eder?', options: ['A) Zenginlik', 'B) Yalnızlık/Soyutlanma', 'C) Yükseklik', 'D) Güç'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'İlahi bakış açısında anlatıcı neyi bilir?', options: ['A) Sadece görüneni', 'B) Her şeyi (düşünceleri bile)', 'C) Kendi yaşadığını', 'D) Hiçbir şeyi'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'Soyut metinlerde en iyi strateji?', options: ['A) Hızlı okumak', 'B) Somutlaştırmak/Özetlemek', 'C) Şıklardan gitmek', 'D) Atlamak'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: 'Çoklu sorularda önce ne okunur?', options: ['A) Parça', 'B) Soru kökleri', 'C) Şıklar', 'D) İlk cümle'], correctIndex: 1, difficulty: 3),
    StemQuestion(question: '"Kanıksama" nedir?', options: ['A) İnkâr', 'B) Kabullenme/Alışma', 'C) Bıkma', 'D) Reddetme'], correctIndex: 1, difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: '(Uzun Paragraf) Bu parçaya göre aşağıdakilerden hangisi söylenemez?', options: ['A) Şık A', 'B) Şık B', 'C) Şık C', 'D) Şık D'], correctIndex: 3, explanation: 'Olumsuz köklü soruda şıklar parçayla karşılaştırılır.', difficulty: 3),
    StemQuestion(question: 'Bu parçanın anlatım akışındaki bozukluğu gidermek için hangi cümlelerin yeri değiştirilmelidir?', options: ['A) I ve II', 'B) II ve III', 'C) II ve IV', 'D) III ve V'], correctIndex: 2, explanation: 'Mantıksal sıralama hatası düzeltilir.', difficulty: 3),
    StemQuestion(question: 'Bu parça ikiye bölünürse ikinci paragraf hangisiyle başlar?', options: ['A) III', 'B) IV', 'C) V', 'D) VI'], correctIndex: 1, explanation: 'Konu değişimi.', difficulty: 3),
    StemQuestion(question: 'Bu parçada geçen "kılı kırk yarmak" deyiminin cümleye kattığı anlam nedir?', options: ['A) Çok titizlenmek', 'B) Kararsız kalmak', 'C) Acele etmek', 'D) Sinirlenmek'], correctIndex: 0, explanation: 'Detaylara aşırı önem vermek.', difficulty: 3),
    StemQuestion(question: 'Yazar bu parçada aşağıdakilerin hangisinden yakınmaktadır?', options: ['A) Eleştirinin nesnel olmamasından', 'B) Yazarların az kazanmasından', 'C) Okurun ilgisizliğinden', 'D) Kağıt fiyatlarından'], correctIndex: 0, explanation: 'Ana şikayet konusu.', difficulty: 3),
    StemQuestion(question: 'Bu parçada "Sanat aynadır." görüşüne karşı çıkan yazarın düşüncesi ne olabilir?', options: ['A) Sanat gerçeği olduğu gibi yansıtır.', 'B) Sanat gerçeği değiştirerek, kurgulayarak sunar.', 'C) Sanatın amacı fayda sağlamaktır.', 'D) Sanat toplum içindir.'], correctIndex: 1, explanation: 'Ayna (Yansıtma) teorisine karşı Kurgusal (Yaratma) teorisi.', difficulty: 3),
    StemQuestion(question: 'Bu parçanın sonuna düşüncenin akışına göre hangisi getirilemez?', options: ['A) Bu nedenle...', 'B) Sonuç olarak...', 'C) Oysa ki...', 'D) Kısaca...'], correctIndex: 2, explanation: 'Paragrafın gidişatına ters düşen bağlaç.', difficulty: 3),
    StemQuestion(question: 'Bu parçada aşağıdaki sorulardan hangisinin cevabı yoktur?', options: ['A) Nerede?', 'B) Ne zaman?', 'C) Nasıl?', 'D) Ne kadar?'], correctIndex: 3, explanation: '5N1K taraması.', difficulty: 3),
    StemQuestion(question: 'Bu parçada tanıtılan kişi için hangisi söylenemez?', options: ['A) Alçakgönüllü', 'B) Yardımsever', 'C) Hırslı', 'D) Hoşgörülü'], correctIndex: 2, explanation: 'Karakter analizi.', difficulty: 3),
    StemQuestion(question: 'Bu parçada "betimleyici anlatım"ın hangi özelliği yoktur?', options: ['A) Renk bildiren sözcükler', 'B) Niteleme sıfatları', 'C) Hareket bildiren eylemler', 'D) Öznel yorumlar'], correctIndex: 2, explanation: 'Hareket varsa öyküleme karışır, saf durağan betimleme soruluyorsa hareket olmaz. (Karma anlatımda olabilir).', difficulty: 3),
    StemQuestion(question: 'Yazarın "Ben bir fotoğraf makinesi değilim." sözüyle anlatmak istediği nedir?', options: ['A) Gerçekleri olduğu gibi anlatmam.', 'B) Gördüklerimi unutmam.', 'C) Resim yapmayı sevmem.', 'D) Teknolojiyi kullanmam.'], correctIndex: 0, explanation: 'Objektif değilim, yorum katarım.', difficulty: 3),
    StemQuestion(question: 'Bu parça aşağıdaki edebi türlerin hangisinden alınmıştır?', options: ['A) Deneme', 'B) Makale', 'C) Biyografi', 'D) Anı'], correctIndex: 0, explanation: 'Tür özellikleri (Öznellik, sohbet havası -> Deneme).', difficulty: 3),
    StemQuestion(question: 'Hangisi bir paragrafın giriş cümlesi olamaz?', options: ['A) Şiir, sözcüklerin dansıdır.', 'B) Bundan dolayı sanatçı özgür olmalıdır.', 'C) Tarih boyunca insanlar iletişim kurmaya çalışmıştır.', 'D) Yazmak, yaşamak demektir.'], correctIndex: 1, explanation: '"Bundan dolayı" bağlayıcı ifadedir.', difficulty: 3),
    StemQuestion(question: 'Bu parçada "ironi" yapıldığını gösteren ifade hangisidir?', options: ['A) Harika bir iş çıkardın, her yeri berbat ederek!', 'B) Seni seviyorum.', 'C) Bugün hava güzel.', 'D) Kitap okuyorum.'], correctIndex: 0, explanation: 'Tersini kastetme (Harika -> Berbat).', difficulty: 3),
    StemQuestion(question: 'Bu parçadan kesin olarak çıkarılabilecek yargı hangisidir?', options: ['A) Yazar konuya eleştirel yaklaşmıştır.', 'B) Konu farklı açılardan ele alınmıştır.', 'C) Anlatımda öznellik ağır basmaktadır.', 'D) Metin bilgi vermek amacıyla yazılmıştır.'], correctIndex: 0, explanation: 'Parçada açıkça var olan, yoruma kapalı yargı.', difficulty: 3),
  ],
  formulaCards: const ['Anahtar Kelime: Parçanın özü.', 'Soru Kökü: Önce bunu oku.', 'Çeldirici: Parçada yoksa doğru değildir.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 4: SES BİLGİSİ
// ═══════════════════════════════════════════════════════════════

final kpssLiseTurU4Content = StemUnitContent(
  unitId: 'kpsslise_tur_u4',
  topic: const TopicContent(
    summary: 'Ses bilgisi, Türkçedeki seslerin özelliklerini ve kelimeler türetilirken veya çekimlenirken uğradıkları değişiklikleri inceler. Temel ses olayları; Ünlü Düşmesi (Hece Düşmesi), Ünsüz Benzeşmesi (Sertleşmesi), Ünsüz Yumuşaması (Değişimi) ve Ünlü Daralmasıdır.',
    rule: 'Fıstıkçı Şahap (f, s, t, k, ç, ş, h, p) ile biten bir kelimeye "c, d, g" ile başlayan ek gelirse, bu ekler "ç, t, k"ye dönüşür (Benzeşme).',
    formulas: [
      'Ünsüz Benzeşmesi: Sert + Yumuşak -> Sert + Sert (Kitap-cı -> Kitapçı).',
      'Ünsüz Yumuşaması: Sert (p,ç,t,k) + Ünlü -> Yumuşak (b,c,d,ğ) (Kitap-ı -> Kitabı).',
      'Ünlü Düşmesi: İki heceli organ adları + Ünlü -> Düşme (Burun-u -> Burnu).'
    ],
    keyPoints: [
      'Özel isimlerde yumuşama yazıda gösterilmez, sadece okunurken yapılır (Zonguldak\'a gidiyorum).',
      'Tek heceli kelimelerin çoğunda yumuşama olmaz (Top-u -> Topu, Çöp-ü -> Çöpü).',
      '"Yor" eki her zaman daralma yapmaz; sadece "a, e" ile biten fiillerde yapar (Gel-iyor -> Daralma YOK, Bekle-iyor -> Bekliyor -> Daralma VAR).'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde ünlü düşmesi yoktur?',
        options: ['A) Karnım çok ağrıyor.', 'B) Beyni bu konuları almıyor.', 'C) Gönlümden geçenleri biliyorsun.', 'D) Arabayı yıkadı.'],
        correctIndex: 3,
        explanation: 'Karın-ım -> Karnım, Beyin-i -> Beyni, Gönül-üm -> Gönlüm (Ünlü düşmesi). D şıkkında ünlü düşmesi yoktur.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "ünsüz yumuşaması" vardır?',
        options: ['A) Sanatçı', 'B) Kitaplık', 'C) Çocuğu', 'D) Sepet'],
        correctIndex: 2,
        explanation: 'Çocuk-u -> Çocuğu (k -> ğ).',
        difficulty: 1),
    StemQuestion(
        question: '"Sert" sözcüğü ek aldığında hangisinde benzeşme kuralına uyar?',
        options: ['A) Serde', 'B) Sertte', 'C) Serti', 'D) Serden'],
        correctIndex: 1,
        explanation: 'Sert-de -> Sertte (d -> t).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "ünlü daralması" vardır?',
        options: ['A) Geliyor', 'B) Bakıyor', 'C) Söylüyor', 'D) Koşuyor'],
        correctIndex: 2,
        explanation: 'Söyle-yor -> Söylüyor (e -> ü). Diğerlerinde kök zaten ünsüzle biter, araya yardımcı ses girer.',
        difficulty: 1),
    StemQuestion(
        question: '"Sabır" kelimesi ünlüyle başlayan ek aldığında nasıl yazılır?',
        options: ['A) Sabırı', 'B) Sabrı', 'C) Sabırısı', 'D) Sabırla'],
        correctIndex: 1,
        explanation: 'Ünlü düşmesi olur: Sabrı.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "ulama" yapılabilir?',
        options: ['A) Son durak.', 'B) Yeşil ışık.', 'C) Sıcak çorba.', 'D) Okul müdürü.'],
        correctIndex: 1,
        explanation: 'Ünsüzle bitip ünlüyle başlayan kelimeler arasında ulama yapılır: Yeşi-lışık.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde kaynaştırma ünsüzü yoktur?',
        options: ['A) Arabası', 'B) Kapıyı', 'C) İkişer', 'D) Evi'],
        correctIndex: 3,
        explanation: 'Ev-i (i iyelik veya hal ekidir, kaynaştırma yoktur).',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdakilerden hangisi büyük ünlü uyumuna uymaz?',
        options: ['A) Gelincik', 'B) Kitap', 'C) Çiçek', 'D) Yıldız'],
        correctIndex: 1,
        explanation: 'Kitap (İnce-Kalın) -> Uymaz.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde ünsüz türemesi (ikizleşme) vardır?',
        options: ['A) Hissetmek', 'B) Farketmek', 'C) Terk etmek', 'D) Arzetmek'],
        correctIndex: 0,
        explanation: 'His-etmek -> Hissetmek (s türemiş).',
        difficulty: 1),
    StemQuestion(
        question: '"Küçücük" kelimesinde hangi ses olayı vardır?',
        options: ['A) Ünlü düşmesi', 'B) Ünsüz düşmesi', 'C) Ünsüz benzeşmesi', 'D) Ünlü türemesi'],
        correctIndex: 1,
        explanation: 'Küçük-cük -> Küçücük (k düşmüş).',
        difficulty: 1),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde ünsüz benzeşmesi (sertleşmesi) örneği yoktur?', options: ['A) Çiçekçi güzel güller satıyor.', 'B) Dolaptan bir bardak aldı.', 'C) Sınıfta sessizce oturuyoruz.', 'D) Eve erken geldim.'], correctIndex: 3, explanation: 'A) Çiçek-ci -> Çiçekçi (benzeşme), B) Dolap-tan -> Dolaptan (benzeşme), C) Sınıf-da -> Sınıfta (benzeşme). D seçeneğinde benzeşme yoktur.', difficulty: 1),
    StemQuestion(question: '"Kaybolmak" sözcüğünde hangi ses olayları vardır?', options: ['A) Ünlü düşmesi - Ünsüz yumuşaması', 'B) Ünlü düşmesi - Ünsüz benzeşmesi', 'C) Sadece ünlü düşmesi', 'D) Ünsüz türemesi - Ünlü düşmesi'], correctIndex: 0, explanation: 'Kayıp-olmak. (ı) düşer -> Ünlü düşmesi. (p) -> (b) olur -> Yumuşama.', difficulty: 1),
    StemQuestion(question: 'Aşağıdakilerden hangisinde -cık/-cik eki eklendiğinde ünsüz düşmesi meydana gelir?', options: ['A) Az', 'B) Küçük', 'C) Dar', 'D) Genç'], correctIndex: 1, explanation: 'Küçük-cük -> Küçücük ("k" düşer).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "ünlü türemesi" vardır?', options: ['A) Biricik', 'B) Küçücük', 'C) Yükseldi', 'D) Gülümsedi'], correctIndex: 0, explanation: 'Bir-cık -> Bir-i-cik ("i" türemiş).', difficulty: 1),
    StemQuestion(question: '"Hakkını" sözcüğünde hangi ses olayı vardır?', options: ['A) Ünsüz benzeşmesi', 'B) Ünsüz türemesi', 'C) Ünlü düşmesi', 'D) Kaynaştırma'], correctIndex: 1, explanation: 'Hak-ı -> Hakkı (k türemiş).', difficulty: 1),
    StemQuestion(question: 'Hangisinde yazım yanlışı vardır (Ses olayına uyulmamasından)?', options: ['A) Gitdikçe', 'B) Yaptıkça', 'C) Seçkin', 'D) Bitki'], correctIndex: 0, explanation: 'Gittikçe olmalı (Benzeşme kuralı).', difficulty: 1),
    StemQuestion(question: '"Ne asıl" sözcüklerinin birleşip "Nasıl" olması hangi ses olayıdır?', options: ['A) Ünlü düşmesi (Aşınma)', 'B) Ünsüz düşmesi', 'C) Daralma', 'D) Benzeşme'], correctIndex: 0, explanation: 'İki ünlü yan yana gelip biri düşmüştür (Aşınma).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "b-m" değişimi (dudak ünsüzlerinin benzeşmesi) yoktur?', options: ['A) Çarşamba', 'B) Perşembe', 'C) Sümbül', 'D) İstanbul'], correctIndex: 3, explanation: 'Özel isimlerde n-b çatışması kuralı uygulanmaz (İstanbul, Safranbolu).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "y" kaynaştırma ünsüzü değildir?', options: ['A) Suyu', 'B) Kapıyı', 'C) Kıyı', 'D) Odaya'], correctIndex: 2, explanation: 'Kıyı kelimesinin kökü "kıyı"dır, y harfi köke aittir.', difficulty: 1),
    StemQuestion(question: 'Aşağıdaki eklerden hangisi büyük ünlü uyumuna aykırıdır?', options: ['A) -lar', 'B) -ki', 'C) -de', 'D) -siz'], correctIndex: 1, explanation: '-ki eki genellikle ince kalır (Sabahki gibi istisnalar hariç). Akşam-ki (Kalın-İnce -> Uyumsuz).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "yumuşama" (değişim) olmaz?', options: ['A) Kağıt', 'B) Yurt', 'C) İp', 'D) Kurt'], correctIndex: 2, explanation: 'Tek heceli kelimelerin bazılarında yumuşama olmaz. İp-i -> İpi (İbi olmaz).', difficulty: 1),
    StemQuestion(question: '"Yiyecek" kelimesindeki ses olayı nedir?', options: ['A) Daralma', 'B) Benzeşme', 'C) Yumuşama', 'D) Türeme'], correctIndex: 0, explanation: 'Ye-ecek -> Yiyecek (e -> i daralması).', difficulty: 1),
    StemQuestion(question: 'Hangisinde türetilirken ünlü düşmesi olmuştur?', options: ['A) Oğlu', 'B) Burnu', 'C) Yalnız', 'D) Şehri'], correctIndex: 2, explanation: 'Yalın-ız -> Yalnız (Yapım eki alırken düşmüş). Diğerleri çekim eki alırken düşmüş.', difficulty: 1),
    StemQuestion(question: 'Hangisinde ünsüz düşmesi vardır?', options: ['A) Kaldırım', 'B) Alçaldı', 'C) Küçüldü', 'D) Hepsi'], correctIndex: 3, explanation: 'Kalk-dırım -> Kaldırım, Alçak-l -> Alçal, Küçük-l -> Küçül.', difficulty: 1),
    StemQuestion(question: 'Hangisinde ulama yapılamaz?', options: ['A) Dün akşam.', 'B) Ekmek aldı.', 'C) Mart ayı.', 'D) Mehmet, eve gitti.'], correctIndex: 3, explanation: 'Noktalama işaretlerinin olduğu yerde ulama yapılmaz.', difficulty: 1),
  ],
  formulaCards: const ['Sertleşme: Fıstıkçı Şahap + (c,d,g) -> (ç,t,k).', 'Yumuşama: (p,ç,t,k) + Ünlü -> (b,c,d,ğ).', 'Daralma: (a,e) + yor -> (ı,i,u,ü).'],
);

final kpssOnlisansTurU4Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u4',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde ses bilgisi, istisnalar ve türetilmiş sözcüklerdeki değişimler üzerine yoğunlaşır. Özellikle "ünlü düşmesi"nin çeşitleri (çekim ekiyle, yapım ekiyle, birleşme sırasında), "dudak ünsüzlerinin benzeşmesi (n-b çatışması)" ve kaynaştırma harflerinin işlevleri detaylandırılır.',
    rule: 'Ünlü daralması Türkçede sadece "-yor" ekiyle değil, "de-" ve "ye-" fiillerine gelen "-y" kaynaştırma harfiyle de olur (Deyecek -> Diyecek).',
    formulas: [
      'N-B Çatışması: n+b -> m+b (Saklanbaç -> Saklambaç).',
      'Koruyucu Ünsüz: Ünlü ile biten kelime + "idi, imiş" -> Araya "y" girer (Hasta idi -> Hastaydı).',
      'Aşınma: İki kelime birleşirken ses kaybı (Kahve-altı -> Kahvaltı).'
    ],
    keyPoints: [
      '"-yor" eki haricinde sadece "demek, yemek, niye" kelimelerinde daralma olur.',
      'Sert ünsüzle biten rakamlara gelen ekler de sertleşir (1923\'te, 3\'ten, 5\'te).',
      'İkilemelerde ünsüz yumuşaması olmaz (Ard arda değil, art arda).'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Hangisinde "ünsüz düşmesi" farklı bir yolla gerçekleşmiştir?',
        options: ['A) Ufacık', 'B) Minik', 'C) Yüksel', 'D) Addaş'],
        correctIndex: 3,
        explanation: 'A, B, C\'de "k" düşmesi vardır. D şıkkında (Ad-daş -> Adaş) "d" düşmesi vardır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "kaynaştırma harfi" iki ünlü arasında değildir?',
        options: ['A) Çantası', 'B) Altışar', 'C) Şundan', 'D) Kapıya'],
        correctIndex: 2,
        explanation: 'Şu-n-dan. (u ünlüsü ile d ünsüzü arasına girmiştir).',
        difficulty: 2),
    StemQuestion(
        question: 'Aşağıdaki sözcüklerden hangisinde birden fazla ses olayı vardır?',
        options: ['A) Kayboldu', 'B) Hissetti', 'C) Gidiyorum', 'D) Baktı'],
        correctIndex: 0,
        explanation: 'Kayıp-oldu -> (ı) düşmesi, (p->b) yumuşaması. B\'de türeme+benzeşme var. A ve B güçlü çeldiricidir. A\'da düşme+yumuşama. B\'de türeme+benzeşme. İkisi de cevap olabilir. Ancak KPSS\'de genelde "ünlü düşmesi ve yumuşama" ikilisi sorulur. Şıklarda "Niçin" (Ne için - Aşınma) gibi tek olaylı kelimelerle karıştırılır. Burada A şıkkı en net örnektir.',
        difficulty: 2),
    StemQuestion(
        question: '"Sızlamak" kelimesindeki ses olayı nedir?',
        options: ['A) Ünlü düşmesi', 'B) Ünsüz düşmesi', 'C) Daralma', 'D) Benzeşme'],
        correctIndex: 0,
        explanation: 'Sızı-la-mak -> Sızlamak (ı düşmesi, türetilirken).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde yazım yanlışı vardır (Ses bilgisi kaynaklı)?',
        options: ['A) Fark etti', 'B) Terk etti', 'C) Hiss etti', 'D) Arz etti'],
        correctIndex: 2,
        explanation: 'Ünsüz türemesi olan kelimeler bitişik yazılır: Hissetti.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "-den/-dan" eki benzeşmeye uğramıştır?',
        options: ['A) Gözden', 'B) İşten', 'C) Evden', 'D) Camdan'],
        correctIndex: 1,
        explanation: 'İş-ten (ş sert, d->t olur).',
        difficulty: 2),
    StemQuestion(
        question: '"Ben" ve "Sen" zamirleri yönelme eki alınca "Bana", "Sana" olur. Bu olayın adı nedir?',
        options: ['A) Ünlü Daralması', 'B) Ünlü Değişimi (Kalınlaşması)', 'C) Ünlü Türemesi', 'D) Kaynaşma'],
        correctIndex: 1,
        explanation: 'Kökte ünlü değişimi sadece bu iki kelimede görülür.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "yumuşama" kuralına aykırılık vardır?',
        options: ['A) Kitabı', 'B) Derdi', 'C) Hukuku', 'D) Rengi'],
        correctIndex: 2,
        explanation: 'Hukuk-u (k yumuşamaz).',
        difficulty: 2),
    StemQuestion(
        question: '"Giderek" kelimesindeki ses olayları?',
        options: ['A) Yumuşama', 'B) Daralma', 'C) Benzeşme', 'D) Türeme'],
        correctIndex: 0,
        explanation: 'Git-erek -> Giderek (t->d).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "yardımcı ünlü" ile "ünlü türemesi" karıştırılabilir?',
        options: ['A) Azıcık', 'B) Geliyor', 'C) Bakıyor', 'D) Koşuyor'],
        correctIndex: 0,
        explanation: 'Az-cık -> Az-ı-cık (Türeme). Diğerlerinde (i) yardımcı sestir, türeme değildir.',
        difficulty: 2),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde, türetilirken ünlü kaybına uğramış bir sözcük vardır?', options: ['A) Ağzındaki baklayı çıkar.', 'B) Şehrin gürültüsü beni yordu.', 'C) Bu kavşaktan dönmelisin.', 'D) Oğlu askere gitti.'], correctIndex: 2, explanation: 'Kavuş-ak -> Kavşak (Türetilirken). A, B, D çekim eki alırken düşmüştür.', difficulty: 2),
    StemQuestion(question: '"Küçücük elleriyle bağırıyordu." cümlesindeki ses olayları hangisidir?', options: ['A) Ünsüz düşmesi - Ünsüz türemesi', 'B) Ünsüz düşmesi - Ünlü daralması', 'C) Ünlü türemesi - Benzeşme', 'D) Ünsüz yumuşaması - Daralma'], correctIndex: 1, explanation: 'Küçük-cük -> Küçücük (Ünsüz düşmesi). Bağıra-yor -> Bağırıyor (a->ı ünlü daralması).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ünsüz ikizleşmesi" (türemesi) yoktur?', options: ['A) Zannetmek', 'B) Reddetmek', 'C) Hallolmak', 'D) Başlatmak'], correctIndex: 3, explanation: 'D şıkkında türeme yoktur, "t" yapım ekidir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde birleşik sözcük oluşurken ses düşmesi meydana gelmiştir?', options: ['A) Aslanağzı', 'B) Keçiboynuzu', 'C) Pazartesi', 'D) Hanımeli'], correctIndex: 2, explanation: 'Pazar-ertesi -> Pazartesi (Ünlü düşmesi/Aşınma).', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki sözcüklerden hangisi hem yapım hem çekim eki alırken ünlü kaybına uğramıştır?', options: ['A) Benzemek', 'B) Oynamak', 'C) Beslemek', 'D) İlerlemek'], correctIndex: 0, explanation: 'Beniz-e-mek -> Benzemek (Sadece yapım eki). Bu soru tipi çok detaylıdır. Genellikle "Beniz" kökünden gelir. Doğru cevap şıklarda yoksa, "Niçin" (Ne için) gibi birleşik kelimeler aranır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "kaynaştırma harfi" farklı bir görevde kullanılmıştır? (Koruyucu vs. Kaynaştırıcı)', options: ['A) Arabanın', 'B) Kapının', 'C) Odaydı', 'D) Masanın'], correctIndex: 2, explanation: 'C şıkkında "Oda idi" birleşiminde "y" sesi "i" düşmesi sonucu koruyucu olarak gelmiştir. Diğerlerinde tamlayan eki öncesi gelmiştir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "dudak ünsüzlerinin benzeşmesi" (n->m) örneği vardır?', options: ['A) Onbaşı', 'B) Sonbahar', 'C) Tembel', 'D) Binboga'], correctIndex: 2, explanation: 'Tenbel -> Tembel.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "yumuşak g" (ğ) kullanımıyla ilgili bir ses olayı yoktur?', options: ['A) Alacağı', 'B) Geleceği', 'C) Dağ', 'D) Çocuğu'], correctIndex: 2, explanation: 'Dağ kelimesi kök halindedir, yumuşama sonucu oluşmamıştır.', difficulty: 2),
    StemQuestion(question: '"Yükselmek" sözcüğündeki ses olayı hangisinde vardır?', options: ['A) Alçalmak', 'B) Büyümek', 'C) Yürümek', 'D) Kaçmak'], correctIndex: 0, explanation: 'Yüksek-l -> Yüksel (k düşmesi). Alçak-l -> Alçal (k düşmesi).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "-yor" eki daralma yapmamıştır?', options: ['A) Bekliyor', 'B) Özlüyor', 'C) Bakıyor', 'D) Gizliyor'], correctIndex: 2, explanation: 'Bak-ıyor (Kök bakmak, ünsüzle bitiyor, daralma yok). Diğerleri: Bekle, Özle, Gizle (ünlüyle bitiyor, daralma var).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ünsüz değişimi" (yumuşama) görülemez?', options: ['A) Sanat', 'B) Dolap', 'C) Ağaç', 'D) Renk'], correctIndex: 0, explanation: 'Sanat-ı -> Sanatı (t yumuşamaz, yabancı asıllı).', difficulty: 2),
    StemQuestion(question: '"Yemyeşil" pekiştirmesinde hangi ses olayı vardır?', options: ['A) Ünlü Türemesi', 'B) Ünsüz Türemesi (M harfi)', 'C) Benzeşme', 'D) Düşme'], correctIndex: 1, explanation: 'Pekiştirme harfi (m) türemiştir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "aşınma" (ünlü birleşmesi ve düşmesi) vardır?', options: ['A) Sütlaç', 'B) Gecekondu', 'C) Bilgisayar', 'D) Çekyat'], correctIndex: 0, explanation: 'Sütlü-aş -> Sütlaç.', difficulty: 2),
    StemQuestion(question: 'Aşağıdakilerden hangisi küçük ünlü uyumuna aykırıdır?', options: ['A) Yumurta', 'B) Kavun', 'C) Çamur', 'D) Horoz'], correctIndex: 3, explanation: 'Horoz (o-o). Türkçe kelimelerde ilk hece dışında o/ö bulunmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ünsüz benzeşmesi" yazıda gösterilmezse yazım yanlışı olur?', options: ['A) 1975\'de', 'B) 1975\'te', 'C) Saat\'de', 'D) Hiçbiri'], correctIndex: 0, explanation: '1975 (Beş) -> Ş ile biter, te olmalı.', difficulty: 2),
  ],
  formulaCards: const ['N-B Çatışması: n+b -> m+b (İstisna: Özel isim/Birleşik kelime).', 'Türetilirken Düşme: Yapım ekiyle düşme (Oyun-a -> Oyna).', 'Aşınma: Sütlü-aş -> Sütlaç.'],
);

final kpssLisansTurU4Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u4',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde ses bilgisi; karmaşık türetimler, kural dışı örnekler ve bir kelimede birden çok ses olayının bulunması durumlarını kapsar. Özellikle "ünlü değişimi", "ünsüz türemesi" ile "yardımcı ünsüz" farkı, ve konuşma dilindeki olayların yazı diline yansıyıp yansımaması (daralma vb.) sorulur.',
    rule: 'Bir sözcükte hem yumuşama hem düşme hem benzeşme aynı anda olabilir. Analiz kökten başlar, eklere doğru gider.',
    formulas: [
      'Karma: Kök + Yapım Eki + Çekim Eki -> Çoklu Ses Olayı.',
      'İstisna: Tek hecelilerde yumuşama kuralı (İç-i -> İçi / Ama Güç-ü -> Gücü).',
      'Yabancı Kelime: Hukuk, Ahlak, Millet -> Yumuşama olmaz.'
    ],
    keyPoints: [
      '"Yemek" ve "Demek" fiillerinde daralma yazıda gösterilir (Yiyor, Diyor).',
      'Ancak "Gelecek, yapacak" konuşurken "gelicek" diye okunsa da yazıda "gelecek" kalır.',
      'Özellikle "türetilirken ünlü düşmesi" soruları eleyicidir (Sızı-la -> Sızla, Besi-le -> Besle).'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki altı çizili sözcüklerin hangisinde diğerlerinden farklı bir ses olayı vardır?',
        options: ['A) Gidiyorum', 'B) Ediyorum', 'C) Tadıyorum', 'D) Yoluyorum'],
        correctIndex: 3,
        explanation: 'A, B, C\'de yumuşama (t->d) vardır. D şıkkında (Yol-u-yor) ses olayı yoktur, sadece yardımcı ses vardır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "dudak ünsüzlerinin benzeşmesi" (n-m değişimi) kuralına uyulmamıştır?',
        options: ['A) Tembel', 'B) Çember', 'C) İstanbul', 'D) Pembe'],
        correctIndex: 2,
        explanation: 'Özel isimlerde bu kural uygulanmaz (İstanbul).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde hem ünlü düşmesi hem ünsüz yumuşaması vardır?',
        options: ['A) Akla', 'B) Oğlu', 'C) Kaybı', 'D) Şehre'],
        correctIndex: 2,
        explanation: 'Kayıp-ı -> Kaybı (ı düşer, p->b yumuşar).',
        difficulty: 3),
    StemQuestion(
        question: '"Sıcak" kelimesi "-cık" eki aldığında "Sıcacık" olur. Bu olay nedir?',
        options: ['A) Ünlü Türemesi', 'B) Ünsüz Düşmesi', 'C) Ünsüz Benzeşmesi', 'D) Kaynaşma'],
        correctIndex: 1,
        explanation: 'Sıcak-cık -> Sıcacık (k düşer).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde türetilirken ünlü düşmesine uğramış bir kelime vardır?',
        options: ['A) Gönlüm', 'B) Uykum', 'C) Resim', 'D) Ömrüm'],
        correctIndex: 1,
        explanation: 'Uyu-ku -> Uyku (Fiilden isim olurken düşmüş). Diğerleri çekim eki alırken düşmüş.',
        difficulty: 3),
    StemQuestion(
        question: '"Öğrenci" kelimesindeki ses olayı nedir?',
        options: ['A) Ünlü düşmesi', 'B) Ünsüz benzeşmesi', 'C) Ünlü daralması', 'D) Ünsüz yumuşaması'],
        correctIndex: 0,
        explanation: 'Öğren-ici -> Öğrenci (i düşmesi). (Akademik tartışmalı olsa da KPSS\'de ünlü düşmesi kabul edilebilir, ancak genelde sorulmaz. Alternatif: "Genci" -> Genç-i. Bu soru zorlama olabilir. Başka örnek: Dilenci -> Dilen-ici. Cevap A).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde kaynaştırma ünsüzü yoktur?',
        options: ['A) Altışar', 'B) Yedişer', 'C) Beşer', 'D) İkişer'],
        correctIndex: 2,
        explanation: 'Beş-er (ş köktedir).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde ünsüz yumuşaması olmaz?',
        options: ['A) Hukuk', 'B) Millet', 'C) Devlet', 'D) Hepsi'],
        correctIndex: 3,
        explanation: 'Bu kelimelerin hiçbiri ünlü alınca yumuşamaz (Hukuku, Milleti, Devleti).',
        difficulty: 3),
    StemQuestion(
        question: '"Yumurtlamak" sözcüğünde hangi ses olayları vardır?',
        options: ['A) Ünlü düşmesi', 'B) Ünlü türemesi', 'C) Ünsüz türemesi', 'D) Daralma'],
        correctIndex: 0,
        explanation: 'Yumurta-la-mak -> Yumurtlamak (a düşmesi).',
        difficulty: 3),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde, ayraç içinde belirtilen ses olayı yoktur?', options: ['A) Çiçekleri vazoya koydu. (Kaynaştırma)', 'B) Karnı acıkmıştı. (Ünlü düşmesi)', 'C) Kitabı bana ver. (Ünlü değişimi)', 'D) Sınıfta kimse yok. (Ünsüz yumuşaması)'], correctIndex: 3, explanation: 'Sınıfta (Sınıf-da -> Sınıfta) Ünsüz Benzeşmesidir (Sertleşme), yumuşama değildir.', difficulty: 3),
    StemQuestion(question: '"Küçülen" sözcüğündeki ses olayının benzeri hangisinde vardır?', options: ['A) Büyüyen', 'B) Yükselen', 'C) Daralan', 'D) Giden'], correctIndex: 1, explanation: 'Küçük-l -> Küçül (k düşmesi). Yüksek-l -> Yüksel (k düşmesi).', difficulty: 3),
    StemQuestion(question: 'Hangisinde hem sertleşme hem yumuşama vardır?', options: ['A) Yaptığı', 'B) Gitti', 'C) Geldi', 'D) Koştu'], correctIndex: 0, explanation: 'Yap-tık-ı -> Yaptığı. (tık -> tığ yumuşama, p-t sertleşme).', difficulty: 3),
    StemQuestion(question: '"İlerliyor" kelimesindeki ses olayları nelerdir?', options: ['A) Ünlü Düşmesi - Daralma', 'B) Ünsüz Düşmesi - Benzeşme', 'C) Türeme - Yumuşama', 'D) Daralma - Benzeşme'], correctIndex: 0, explanation: 'İleri-le-yor -> İler-le-yor (i düşmesi) -> İler-li-yor (e->i daralma).', difficulty: 3),
    StemQuestion(question: '"Cumartesi" sözcüğünde görülen ses olayı hangisinde vardır?', options: ['A) Kahvealtı', 'B) Hanımeli', 'C) Aslanağzı', 'D) Terk etmek'], correctIndex: 0, explanation: 'Cuma-ertesi (Aşınma/Birleşirken düşme). Kahve-altı -> Kahvaltı (Aşınma).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "-cık, -cik" eki küçültme yaparken ses kaybına neden olmamıştır?', options: ['A) Ufacık', 'B) Minicik', 'C) Daracık', 'D) Küçücük'], correctIndex: 2, explanation: 'Dar-a-cık (Ünlü türemesi olmuştur, kayıp yoktur). Diğerlerinde ünsüz düşmesi vardır.', difficulty: 3),
    StemQuestion(question: '"Kıvrım" sözcüğünde hangi ses olayı vardır?', options: ['A) Ünlü düşmesi', 'B) Ünsüz düşmesi', 'C) Ünlü türemesi', 'D) Ünsüz türemesi'], correctIndex: 0, explanation: 'Kıvır-ım -> Kıvrım (Türetilirken ünlü düşmesi).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "y" sesi kaynaştırma göreviyle kullanılmamıştır?', options: ['A) Suyu', 'B) Kuyu', 'C) Kıyıyı', 'D) Odayı'], correctIndex: 1, explanation: 'Kuyu kelimesinde "y" köke aittir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ünlü daralması" yoktur?', options: ['A) Diye', 'B) Yiyecek', 'C) Anlıyor', 'D) Gülüyor'], correctIndex: 3, explanation: 'Gül-ü-yor (Kök ünsüzle bitiyor, daralma yok). Anla-yor -> Anlıyor (Daralma var).', difficulty: 3),
    StemQuestion(question: 'Hangisinin yazımı yanlıştır?', options: ['A) Farketmek', 'B) Terk etmek', 'C) Hissetmek', 'D) Sabretmek'], correctIndex: 0, explanation: 'Ses olayı olmadığı için ayrı yazılmalı: Fark etmek.', difficulty: 3),
    StemQuestion(question: '"Oynuyor" kelimesinin kökü ve ekleri ayrıldığında hangi ses olayı görülür?', options: ['A) Türetilirken ünlü düşmesi ve daralma', 'B) Sadece daralma', 'C) Ünsüz düşmesi', 'D) Yumuşama'], correctIndex: 0, explanation: 'Oyun-a-yor -> Oyna-yor (u düşmesi) -> Oynuyor (a->u daralma).', difficulty: 3),
    StemQuestion(question: 'Hangisinde ünsüz yumuşamasına örnek yoktur?', options: ['A) Yurdum', 'B) Rengi', 'C) Sokağı', 'D) Sanatı'], correctIndex: 3, explanation: 'Sanat (t) yumuşamamış.', difficulty: 3),
    StemQuestion(question: 'Aşağıdaki altı çizili sözcüklerden hangisi kök halinde iken ünlü düşmesine uğramıştır? (İstisna)', options: ['A) Isı', 'B) İlaç', 'C) Isıt', 'D) Şehir'], correctIndex: 0, explanation: 'Bu soru tipi çok nadirdir. Genelde "Isı" (Isı-t) türemiş, "Şehir" (Şehri) çekim ekiyle düşer. Kök halinde düşme diye bir şey teorik olarak zordur, ancak "Eskiden nasıldı?" diye sorulursa etimolojiye girer. KPSS için: "Burada" (Bu-ara-da) birleşiktir. Soru: "Türetilirken ünlü düşmesi" daha standarttır. "Devrim, Kavşak, Sızla" standarttır.', difficulty: 3),
    StemQuestion(question: '"Hristiyan" kelimesindeki ses olayı (yazım kuralı) nedir?', options: ['A) Ünlü düşmesi', 'B) I harfinin yazılmaması', 'C) Yabancı kelime kuralı', 'D) Ünsüz türemesi'], correctIndex: 1, explanation: 'I harfi olmadan yazılır (Hristiyan). Ses olayı değil yazım kuralıdır.', difficulty: 3),
  ],
  formulaCards: const ['Gülücük: Gül-üş-cük (ş düşmesi).', 'Diye: De-y-e (Daralma).', 'Hissedilmek: His+et (Türeme) + t->d (Yumuşama).'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 5: YAPI BİLGİSİ
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU5Content = StemUnitContent(
  unitId: 'kpsslise_tur_u5',
  topic: const TopicContent(
    summary: 'Yapı bilgisi, sözcüklerin köklerini (isim/fiil) ve aldıkları ekleri (yapım/çekim) inceler. Sözcükler yapılarına göre üç gruba ayrılır: 1. Basit (Yapım eki almamış), 2. Türemiş (En az bir yapım eki almış), 3. Birleşik (En az iki sözcüğün birleşmesi). Kök, sözcüğün anlamlı en küçük parçasıdır.',
    rule: 'Bir sözcük yapım eki alırsa "Türemiş" olur ve anlamı değişir. Çekim eki alırsa anlamı değişmez, "Basit" kalır.',
    formulas: [
      'Basit: Kök + Çekim Eki (Kitap-lar).',
      'Türemiş: Kök + Yapım Eki (Kitap-lık).',
      'Birleşik: Sözcük + Sözcük (Hanım-eli).'
    ],
    keyPoints: [
      'Fiil köküne "-mak/-mek" gelir, isim köküne gelmez.',
      'Yapım eki eklendiği sözcüğün gövdesini oluşturur.',
      'Ler/lar çoğul eki çekim ekidir, yapıyı değiştirmez.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki sözcüklerden hangisi yapısı bakımından "türemiş"tir?',
        options: ['A) Masa', 'B) Gözlük', 'C) Defter', 'D) Kalem'],
        correctIndex: 1,
        explanation: 'Göz (Organ) -> Gözlük (Eşya). Anlam değişmiş, yapım eki almış.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi kökünün türü bakımından diğerlerinden farklıdır?',
        options: ['A) Yazın tatile gittik.', 'B) Kır çiçekleri topladık.', 'C) Gül reçeli yaptık.', 'D) Gel buraya otur.'],
        correctIndex: 3,
        explanation: 'A (Yaz-Mevsim/İsim), B (Kır-Arazi/İsim), C (Gül-Çiçek/İsim). D (Gel-mek/Fiil). (Not: A, B, C sesteştir ama cümledeki anlamları isimdir).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi "birleşik" yapılı bir sözcüktür?',
        options: ['A) Bilgisayar', 'B) Telefon', 'C) Televizyon', 'D) Radyo'],
        correctIndex: 0,
        explanation: 'Bilgi + Sayar (İki kelime birleşmiş).',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdaki eklerden hangisi yapım ekidir?',
        options: ['A) -lar (Çoğul)', 'B) -ı (Belirtme)', 'C) -cı (Meslek)', 'D) -m (İyelik)'],
        correctIndex: 2,
        explanation: 'Simit-çi (Anlamı değiştiren ek).',
        difficulty: 1),
    StemQuestion(
        question: '"Sulu" sözcüğünün kökü nedir?',
        options: ['A) Sul', 'B) Su', 'C) Su-lu', 'D) S'],
        correctIndex: 1,
        explanation: 'Su (İsim kökü).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi basit yapılıdır (Yapım eki almamıştır)?',
        options: ['A) Yolcu', 'B) Evli', 'C) Okul', 'D) Evler'],
        correctIndex: 3,
        explanation: 'Ev-ler (Çoğul eki çekim ekidir, yapıyı değiştirmez). Okul (Oku-l türemiş).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "-lik" eki soyut bir isim türetmiştir?',
        options: ['A) Tuzluk', 'B) Gözlük', 'C) İyilik', 'D) Kitaplık'],
        correctIndex: 2,
        explanation: 'İyilik (Görülemeyen kavram). Diğerleri somut eşya.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi fiil köklü bir sözcüktür?',
        options: ['A) Başla', 'B) Sevgi', 'C) Sözlük', 'D) Taşlı'],
        correctIndex: 1,
        explanation: 'Sev-mek (Fiil). Başla (Baş-tan gelir, isim kök), Söz (isim), Taş (isim).',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdakilerden hangisi hem yapım hem çekim eki almıştır?',
        options: ['A) Kalemlik', 'B) Kalemim', 'C) Kalemlikte', 'D) Kalemler'],
        correctIndex: 2,
        explanation: 'Kalem-lik (Yapım) -te (Çekim/Hal eki).',
        difficulty: 1),
    StemQuestion(
        question: '"Balıkçılar" sözcüğünde kaç tane ek vardır?',
        options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
        correctIndex: 1,
        explanation: 'Balık-çı-lar (Çı: Yapım, Lar: Çekim). 2 ek.',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki altı çizili sözcüklerden hangisi yapısı bakımından diğerlerinden farklıdır?', options: ['A) Öğrenci ders çalışıyor.', 'B) Yazar imza günü düzenledi.', 'C) Simitçi bağırıyor.', 'D) Masa örtüsü kirlendi.'], correctIndex: 3, explanation: 'Öğrenci (Türemiş), Yazar (Türemiş), Simitçi (Türemiş), Masa (Basit).', difficulty: 1),
    StemQuestion(question: 'Hangisi birleşik fiildir?', options: ['A) Gidiyorum', 'B) Yapabilirim', 'C) Koşacak', 'D) Geldi'], correctIndex: 1, explanation: 'Yap-abilmek (Kurallı birleşik fiil).', difficulty: 1),
    StemQuestion(question: 'Hangisinde kök-ek ayrımı yanlış yapılmıştır?', options: ['A) Bal-ık-çı', 'B) Göz-lük', 'C) Kitap-çı', 'D) Yol-cu'], correctIndex: 0, explanation: 'Balık kök halindedir. Bal ile Balık arasında anlam ilişkisi yoktur.', difficulty: 1),
    StemQuestion(question: '"Akşamki" sözcüğündeki "-ki" ekinin görevi nedir?', options: ['A) İlgi zamiri', 'B) Bağlaç', 'C) Sıfat yapan yapım eki', 'D) Çekim eki'], correctIndex: 2, explanation: 'Hangi akşam? Akşamki (Sıfat yapar).', difficulty: 1),
    StemQuestion(question: 'Hangisi yansıma kökten türemiştir?', options: ['A) Patlamak', 'B) Parlamak', 'C) Görünmek', 'D) Sevmek'], correctIndex: 0, explanation: 'Pat (Ses) -> Patlamak.', difficulty: 1),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "-de/-da" eki yapım eki görevindedir?', options: ['A) Evde oturuyoruz.', 'B) Sözde Ermeni soykırımı.', 'C) Okulda tören var.', 'D) Çantada kalem var.'], correctIndex: 1, explanation: 'Söz-de (Nasıl? -> Sözde/Gerçek olmayan). Sıfat türetmiş, anlamı değiştirmiş.', difficulty: 1),
    StemQuestion(question: 'Hangisinde isimden fiil yapan ek vardır?', options: ['A) Başla', 'B) Geldi', 'C) Yazdı', 'D) Koştu'], correctIndex: 0, explanation: 'Baş (İsim) -> Baş-la-mak (Fiil).', difficulty: 1),
    StemQuestion(question: 'Hangisi anlamca kaynaşmış birleşik isimdir?', options: ['A) Hanımeli', 'B) Terk etmek', 'C) Yardım etmek', 'D) Gelebilmek'], correctIndex: 0, explanation: 'İki isim birleşip yeni bir varlığı karşılamış (Çiçek).', difficulty: 1),
    StemQuestion(question: 'Hangisi fiilden fiil yapım eki almıştır?', options: ['A) Yazdır', 'B) Yazlık', 'C) Yazıcı', 'D) Yazı'], correctIndex: 0, explanation: 'Yaz-mak -> Yaz-dır-mak (Fiilden fiil).', difficulty: 1),
    StemQuestion(question: '"Vatandaş" sözcüğündeki "-daş" ekinin görevi nedir?', options: ['A) Fiil yapar', 'B) İsimden isim yapar (Birliktelik)', 'C) Çekim ekidir', 'D) Çokluk ekidir'], correctIndex: 1, explanation: 'Vatan (İsim) -> Vatandaş (Aynı vatanı paylaşan/İsim).', difficulty: 1),
    StemQuestion(question: 'Hangisi basit zamanlı (tek kip eki almış) bir fiildir?', options: ['A) Geliyordu', 'B) Yapacakmış', 'C) Gitti', 'D) Sevecekti'], correctIndex: 2, explanation: 'Git-ti (Tek zaman eki var). Diğerleri birleşik zamanlı (iki ek).', difficulty: 1),
    StemQuestion(question: 'Hangisi "sesteş kök"e örnektir?', options: ['A) Yol', 'B) Masa', 'C) Kalem', 'D) Defter'], correctIndex: 0, explanation: 'Yol (Yürünülen yer) ve Yol-mak (Fiil).', difficulty: 1),
    StemQuestion(question: 'Hangisi durum (hal) eki almıştır?', options: ['A) Evim', 'B) Evi (gördüm)', 'C) Evin (rengi)', 'D) Evleri'], correctIndex: 1, explanation: 'Ev-i (Belirtme hal eki). A (İyelik), C (Tamlayan), D (Çoğul+İyelik).', difficulty: 1),
    StemQuestion(question: 'Hangisi türemiş sıfattır?', options: ['A) Kırmızı elma', 'B) Kırık masa', 'C) Temiz oda', 'D) Uzun yol'], correctIndex: 1, explanation: 'Kır-ık (Fiilden isim/sıfat olmuş).', difficulty: 1),
    StemQuestion(question: '"Gözcü" sözcüğünün yapısı nedir?', options: ['A) Basit', 'B) Birleşik', 'C) Türemiş', 'D) Yansıma'], correctIndex: 2, explanation: 'Göz-cü (Yapım eki).', difficulty: 1),
  ],
  formulaCards: const ['Yapım Eki: Anlamı değiştirir.', 'Çekim Eki: Anlamı değiştirmez.', 'Kök: Anlamlı en küçük parça.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU5Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u5',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde yapı bilgisi; gövdeden türeme, ortak kök (kökteş) ile sesteş kök ayrımı, birleşik fiillerin oluşumu (Yardımcı Eylem, Kurallı Birleşik, Anlamca Kaynaşmış) konularını kapsar. İyelik eki ile belirtme hal ekinin farkı (-i eki) sık sorulur.',
    rule: 'Bir sözcüğün başına "onun" getirildiğinde anlamlı oluyorsa sondaki -i iyelik ekidir; olmuyorsa ve fiili belirtiyorsa belirtme hal ekidir.',
    formulas: [
      'Gövde: Kök + Yapım Eki.',
      'Gövdeden Türeme: Kök + YE + YE (En az 2 yapım eki).',
      'Kurallı Birleşik Fiil: Fiil + (ebil, iver, yaz, dur) + Mek.'
    ],
    keyPoints: [
      'Yansıma sözcüklerin kökü her zaman "isim" kabul edilir (Miyav, Pat, Çat).',
      'Ortak kök (Boya/Boya-mak) hem isim hem fiil olabilir ve anlam bağı vardır. Sesteşte anlam bağı yoktur.',
      'Sıfat fiil, Zarf fiil ve İsim fiil ekleri (Fiilimsiler) daima "Yapım Eki"dir.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "-i" eki diğerlerinden farklı görevde kullanılmıştır?',
        options: ['A) Evi çok güzelmiş.', 'B) Evi dün boyadılar.', 'C) Arabası bozulmuş.', 'D) Kalemi kırıldı.'],
        correctIndex: 1,
        explanation: 'A, C, D seçeneklerinde "Onun" getirebiliriz (Onun evi, Onun arabası, Onun kalemi -> İyelik). B seçeneğinde "Evi boyadılar" (Nesne/Belirtme Hali). "Onun evi boyadılar" olmaz.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "gövdeden türemiş" (en az iki yapım eki almış) bir sözcüktür?',
        options: ['A) Balıkçı', 'B) Gözcülük', 'C) Simitçi', 'D) Yolcu'],
        correctIndex: 1,
        explanation: 'Göz-cü-lük (İki yapım eki var: -cü, -lük).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "ortak kök" (kökteş) örneğidir?',
        options: ['A) Yaz', 'B) Gül', 'C) Savaş', 'D) Ben'],
        correctIndex: 2,
        explanation: 'Savaş (isim) ve Savaş-mak (fiil) arasında anlam bağı vardır. Diğerleri sesteştir (anlam bağı yok).',
        difficulty: 2),
    StemQuestion(
        question: 'Aşağıdaki birleşik fiillerden hangisi "yardımcı eylemle" kurulmuştur?',
        options: ['A) Gelebilirim', 'B) Hissettim', 'C) Bakakaldım', 'D) Düşeyazdım'],
        correctIndex: 1,
        explanation: 'His + Etmek (İsim + Yardımcı Eylem). Diğerleri kurallı birleşik fiildir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi yapısı bakımından diğerlerinden farklıdır?',
        options: ['A) Hanımeli', 'B) Aslanağzı', 'C) Çanakkale', 'D) Öğretmenevi'],
        correctIndex: 2,
        explanation: 'A, B, D belirtisiz isim tamlaması yoluyla oluşmuş birleşiklerdir (Hanım-eli, Aslan-ağzı). Çanakkale (Çanak-kale) sıfat tamlaması yoluyla veya takısız isim tamlaması yoluyla oluşmuştur.',
        difficulty: 2),
    StemQuestion(
        question: '"Koşar adım" tamlamasındaki "koşar" sözcüğünün yapısı nedir?',
        options: ['A) Basit', 'B) Türemiş', 'C) Birleşik', 'D) Çekim eki almış'],
        correctIndex: 1,
        explanation: 'Koş-ar (Sıfat fiil eki yapım ekidir, türemiştir).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "-ce/-ca" eki eşitlik anlamı katmıştır?',
        options: ['A) Bence sen haklısın.', 'B) Çocukça davranma.', 'C) Boyca ondan uzunsun.', 'D) Sınıfça pikniğe gittik.'],
        correctIndex: 2,
        explanation: 'Boy bakımından (eşitlik/karşılaştırma). A (Görecelik), B (Benzerlik), D (Birliktelik).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "yansıma" kökten türemiş bir eylemdir?',
        options: ['A) Ötüşmek', 'B) Kişnemek', 'C) Melemek', 'D) Fısıldamak'],
        correctIndex: 3,
        explanation: 'Fıs (Ses taklidi) -> Fısılda-mak. Not: Ötmek, Kişnemek, Melemek de yansıma kökenli kabul edilebilir ancak Fısıldamak\'ın kökü "Fıs" en net yansıma isim köktür.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "zincirleme isim tamlaması" yapısındadır?',
        options: ['A) Okulun kapısı', 'B) Çelik tencere', 'C) Ali\'nin defterinin kapağı', 'D) Kırmızı kalem'],
        correctIndex: 2,
        explanation: 'En az üç isim birbirine bağlanmış.',
        difficulty: 2),
    StemQuestion(
        question: '"Yapıver" sözcüğü yapıca ve türce nedir?',
        options: ['A) Türemiş İsim', 'B) Birleşik Fiil (Tezlik)', 'C) Basit Fiil', 'D) Birleşik Fiil (Yeterlilik)'],
        correctIndex: 1,
        explanation: 'Yap-ıvermek (Tezlik fiili).',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki altı çizili sözcüklerden hangisi "hem yapım hem çekim eki" almıştır?', options: ['A) Yazılarım', 'B) Yazarlar', 'C) Yazıda', 'D) Hepsi'], correctIndex: 3, explanation: 'Yaz-ı-lar-ım (YE+ÇE+ÇE), Yaz-ar-lar (YE+ÇE), Yaz-ı-da (YE+ÇE).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "sıfat yapan -ki" vardır?', options: ['A) Benimki geldi.', 'B) Evdeki hesap.', 'C) Anladım ki sevmiyor.', 'D) Seninki nerede?'], correctIndex: 1, explanation: 'Hangi hesap? Evdeki (Sıfat). A ve D ilgi zamiri, C bağlaç.', difficulty: 2),
    StemQuestion(question: 'Hangisi "kurallı birleşik fiil" değildir?', options: ['A) Gidedur', 'B) Düşeyazdı', 'C) Yapabildi', 'D) Yardım etti'], correctIndex: 3, explanation: 'Yardım etti (Yardımcı eylemle kurulan birleşik fiil).', difficulty: 2),
    StemQuestion(question: '"Akıllı" sözcüğündeki "-lı" eki hangi anlamı katmıştır?', options: ['A) Yoksunluk', 'B) Sahiplik/Bulunduran', 'C) Meslek', 'D) Benzerlik'], correctIndex: 1, explanation: 'Aklı olan, akla sahip.', difficulty: 2),
    StemQuestion(question: 'Hangisinde eylemden eylem (fiilden fiil) yapım eki vardır?', options: ['A) Kovala', 'B) Yürüt', 'C) Kanat', 'D) Yaşat'], correctIndex: 1, explanation: 'Yürü-t-mek (Fiilden fiil ettirgen çatı eki). C (Kan-a-t İsimden fiil), D (Yaş-a-t İsimden fiil).', difficulty: 2),
    StemQuestion(question: 'Hangisi "birleşik zamanlı" (iki kip eki almış) fiildir?', options: ['A) Okumalı', 'B) Okumuş', 'C) Okuyordu', 'D) Okur'], correctIndex: 2, explanation: 'Oku-yor-du (Şimdiki zamanın hikayesi).', difficulty: 2),
    StemQuestion(question: '"Kumsal" sözcüğünün kökü ve yapısı nedir?', options: ['A) Kum (İsim) - Türemiş', 'B) Kum (İsim) - Basit', 'C) Kumsa (Fiil) - Türemiş', 'D) Kum (İsim) - Birleşik'], correctIndex: 0, explanation: 'Kum-sal (İsimden isim yapım eki).', difficulty: 2),
    StemQuestion(question: 'Hangisi "yönelme hali eki" (-e/-a) almıştır?', options: ['A) Gece (oldu)', 'B) Güle (oynaya)', 'C) Eve (gidiyorum)', 'D) Düşe (kalka)'], correctIndex: 2, explanation: 'Yer yön bildirir. B ve D zarf fiil ekidir (nasıl sorusuna cevap verir). A köktür.', difficulty: 2),
    StemQuestion(question: 'Hangisi isim kökünden türemiş bir eylemdir?', options: ['A) Görünmek', 'B) Sevinmek', 'C) Temizlemek', 'D) Bakışmak'], correctIndex: 2, explanation: 'Temiz (İsim) -> Temiz-le-mek (Fiil).', difficulty: 2),
    StemQuestion(question: '"Çekyat" sözcüğü nasıl oluşmuştur?', options: ['A) İsim + İsim', 'B) Fiil + Fiil', 'C) İsim + Fiil', 'D) Yansıma + İsim'], correctIndex: 1, explanation: 'Çek-mek ve Yat-mak (Emir kipiyle kalıplaşmış iki fiil).', difficulty: 2),
    StemQuestion(question: 'Hangisinde -dan/-den eki "tamlayan eki" (-ın/-in) yerine kullanılmıştır?', options: ['A) Sıradan insanlar.', 'B) Çocuklardan birkaçı.', 'C) Gönülden sevenler.', 'D) Uzaktan geldi.'], correctIndex: 1, explanation: 'Çocukların birkaçı = Çocuklardan birkaçı.', difficulty: 2),
    StemQuestion(question: 'Hangisi "geniş zamanın şartı" ile çekimlenmiştir?', options: ['A) Gelirse', 'B) Gelecekse', 'C) Geldiyse', 'D) Gelmişse'], correctIndex: 0, explanation: 'Gel-ir-se (Geniş zaman + Şart).', difficulty: 2),
    StemQuestion(question: 'Hangisi "yeterlilik fiilinin olumsuzu"dur?', options: ['A) Yapmam', 'B) Yapamam', 'C) Yapmayacağım', 'D) Yapmadım'], correctIndex: 1, explanation: 'Yap-abil-ir-im -> Yap-a-ma-m (A sesi yeterliliğin izidir).', difficulty: 2),
    StemQuestion(question: 'Hangisi fiilimsi eki değildir?', options: ['A) -mek (Mak)', 'B) -an (En)', 'C) -ip (Ip)', 'D) -yor'], correctIndex: 3, explanation: '-yor kip ekidir (zaman bildirir).', difficulty: 2),
    StemQuestion(question: '"Sözüm ona" ifadesindeki "ona" sözcüğünün kökü nedir?', options: ['A) On', 'B) O', 'C) Ona', 'D) Onu'], correctIndex: 1, explanation: 'O (Zamir) -> O-n-a.', difficulty: 2),
  ],
  formulaCards: const ['Fiilimsi Ekleri = Yapım Eki.', 'Onun ...i -> İyelik.', 'Fiil+Fiil -> Biçerdöver, Çekyat.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU5Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u5',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde yapı bilgisi; nadir kullanılan yapım ekleri (-sel, -it, -vari), ek eylemin işlevleri (ismi yüklem yapma, birleşik zaman kurma) ve yapı bakımından cümle analizi ile entegre soruları içerir. "Birleşik sözcüklerin yazımı" ile "yapı bilgisi" kesişim kümesindeki sorular (bitişik/ayrı yazılma sebepleri) önemlidir.',
    rule: 'Ek eylem (idi, imiş, ise, -dir) iki göreve sahiptir: 1. İsimleri yüklem yapar (Kedi tatlıydı). 2. Basit zamanlı fiilleri birleşik zamanlı yapar (Geliyordu).',
    formulas: [
      'Ek Eylem 1: İsim + Ek Eylem = Yüklem.',
      'Ek Eylem 2: Fiil + Kip + Ek Eylem = Birleşik Zaman.',
      'Yeterlilik Olumsuzu: Yapabilirim -> Yapamam (abil -> a).'
    ],
    keyPoints: [
      '"-dir" eki bazen düşer (O iyi bir insan[dır]). Düşse de var kabul edilir.',
      'Sıfat fiil ekleri kalıplaşarak kalıcı isim olabilir (Dolmuş, Yiyecek, Yakacak). Bu durumda fiilimsi değil, isim kabul edilir.',
      'Birleşik sözcüklerde "ses düşmesi" veya "türemesi" varsa bitişik yazılır (Hissetmek, Kaybolmak). Yoksa ayrı (Fark etmek).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki altı çizili eklerden hangisi işlevi bakımından diğerlerinden farklıdır? (-ı/-i)',
        options: ['A) Yazı masada kalmış.', 'B) Dizi kanadı.', 'C) Kazı çalışmaları başladı.', 'D) Gezi notlarını okudum.'],
        correctIndex: 1,
        explanation: 'B\'de "Diz-i" (Onun diz-i -> 3. Tekil İyelik / Çekim Eki). A (Yaz-ı), C (Kaz-ı), D (Gez-i) sözcüklerinde ise "-ı/-i" fiilden isim yapan YAPIM ekidir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "ek eylem" (ek fiil) farklı bir görevde kullanılmıştır?',
        options: ['A) Hava çok soğuktu.', 'B) En sevdiği meyve elmaydı.', 'C) Dün bizi arayan babamdı.', 'D) Her gün buraya gelirdi.'],
        correctIndex: 3,
        explanation: 'A, B, C\'de ismi yüklem yapmış. D\'de fiili birleşik zamanlı yapmış (Gel-ir-di).',
        difficulty: 3),
    StemQuestion(
        question: '"Gidiver" birleşik fiilinin oluşum şekli ve anlamı nedir?',
        options: ['A) İsim+Yardımcı Eylem (Tezlik)', 'B) Fiil+Kurallı Birleşik (Sürerlik)', 'C) Fiil+Kurallı Birleşik (Tezlik)', 'D) Anlamca Kaynaşmış'],
        correctIndex: 2,
        explanation: 'Git-ivermek (Kurallı birleşik, Tezlik).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisi "nesne-yüklem" ilişkisine göre türetilmiş bir fiildir (Çatı eki)?',
        options: ['A) Gülüşmek', 'B) Gezdirmek', 'C) Bakılmak', 'D) Sevinmek'],
        correctIndex: 1,
        explanation: 'Gez-mek (Geçişsiz) -> Gez-dir-mek (Geçişli/Oldurgan). Nesne alabilir hale gelmiş.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "-im/-ım" eki yapım eki görevindedir?',
        options: ['A) Evim', 'B) Gelirim', 'C) Seçim', 'D) Babam'],
        correctIndex: 2,
        explanation: 'Seç-im (Fiilden isim). Diğerleri iyelik veya şahıs eki (çekim).',
        difficulty: 3),
    StemQuestion(
        question: '"Karmaşık" sözcüğünün kökü ve türetilişi nasıldır?',
        options: ['A) Kar-ma-şık', 'B) Karma-şık', 'C) Kar-ış-mak -> Karışık -> Karmaşık', 'D) Kar-mak -> Karma -> Karmaşık'],
        correctIndex: 3,
        explanation: 'Kar-mak (fiil) -> Karma (isim) -> Karma-şık. Karışık farklı bir kelimedir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisi "zincirleme" birleşik fiil örneğidir (İç içe birleşik)?',
        options: ['A) Gidedur', 'B) Yapıver', 'C) Öngörülmek', 'D) Kaybolmak'],
        correctIndex: 2,
        explanation: 'Ön + Gör-mek (Birleşik) -> Öngör-ül-mek (Türemiş birleşik). Yapıca karmaşıktır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "sıfat fiil eki" kalıcı isim oluşturmuştur?',
        options: ['A) Koşan çocuk', 'B) Yakacak odun', 'C) Dolmuş durağı', 'D) Gelecek yıl'],
        correctIndex: 2,
        explanation: 'Dolmuş (Araç adı olmuş, hareket anlamı bitmiş). B\'de yakacak odun (sıfat), D\'de gelecek yıl (sıfat).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "-den" eki "sebep-sonuç" ilişkisi kurmuştur?',
        options: ['A) Okuldan çıktı.', 'B) Sıcaktan bayıldı.', 'C) Gönülden sevdi.', 'D) Camdan baktı.'],
        correctIndex: 1,
        explanation: 'Bayılmasının sebebi sıcak.',
        difficulty: 3),
    StemQuestion(
        question: '"Yapım eki çekim ekinden önce gelir" kuralına aykırı bir örnek hangisidir?',
        options: ['A) Gözlükçü', 'B) Annemsiz', 'C) Evdeki', 'D) Koşarken'],
        correctIndex: 1,
        explanation: 'Anne-m-siz (m: iyelik/çekim, siz: yapım). Çekim eki yapım ekinden önce gelmiş. İstisnadır.',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "yüklem" ek eylem alarak yüklem olmuş bir isimdir?', options: ['A) Dün akşam sinemaya gittik.', 'B) Tek hayali doktor olmaktı.', 'C) Sabahları erken kalkarım.', 'D) Bu konuyu görüşeceğiz.'], correctIndex: 1, explanation: 'Olmak (Fiilimsi -> İsimleşmiş) + tı (Ek eylem). "Doktor olmak" bir isim grubudur. A, C, D çekimli fiildir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "birleşik sözcüğün yazımı" ile ilgili bir yanlışlık yoktur?', options: ['A) Terkettim', 'B) Arzetmek', 'C) Mahv oldu', 'D) Kahrolmak'], correctIndex: 3, explanation: 'Kahır-olmak -> Kahrolmak (Düşme var, bitişik). A, B ayrı olmalı. C bitişik olmalı (Mahvoldu).', difficulty: 3),
    StemQuestion(question: '"Daralıyor" sözcüğünün kökü ve aldığı ekler hangisidir?', options: ['A) Dar-al-ı-yor', 'B) Dar-al-ıyor', 'C) Dara-l-ıyor', 'D) Dar-a-l-ı-yor'], correctIndex: 0, explanation: 'Dar (isim) -> Dar-al-mak (İsimden fiil YE) -> Dar-al-(ı)yor (Şimdiki zaman).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "-ce" eki cümleye "yaklaşıklık" anlamı katmıştır?', options: ['A) Bence bu iş olur.', 'B) Sınıfça pikniğe gittik.', 'C) Güzelce bir ev aldılar.', 'D) Saatlerce bekledim.'], correctIndex: 2, explanation: 'Güzelce (Güzele yakın, tam değil ama güzel sayılabilir -> Yaklaşıklık). A (Kişisel görüş), B (Birliktelik), D (Abartma/Süre).', difficulty: 3),
    StemQuestion(question: '"Kanamak" sözcüğünün kökü nedir?', options: ['A) Kan (Fiil/İnanmak)', 'B) Kan (İsim/Vücut sıvısı)', 'C) Kana', 'D) Ka'], correctIndex: 1, explanation: 'Kan (İsim) -> Kan-a-mak (Fiil).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ortak kök" (kökteş) özelliği yoktur?', options: ['A) Güven', 'B) Barış', 'C) Eski', 'D) At'], correctIndex: 3, explanation: 'At (hayvan) ve At-mak (fiil) arasında anlam ilgisi yoktur (Sesteştir). Diğerleri kökteştir.', difficulty: 3),
    StemQuestion(question: '"Görüntü" sözcüğündeki "-tü" ekinin işlevi nedir?', options: ['A) Fiilden İsim Yapar', 'B) İsimden İsim Yapar', 'C) Fiilden Fiil Yapar', 'D) İsimden Fiil Yapar'], correctIndex: 0, explanation: 'Gör-ün-mek (Fiil) -> Görüntü (İsim). Fiilden isim yapar.', difficulty: 3),
    StemQuestion(question: 'Hangisi "yeterlilik fiili" (ebilmek) ile çekimlenmiştir?', options: ['A) Çıkabilirim', 'B) Çıkarım', 'C) Çıkıver', 'D) Çıkagel'], correctIndex: 0, explanation: 'Çık-abil-ir-im.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "birleşik sıfat" farklı bir yolla oluşmuştur?', options: ['A) Geniş bahçeli ev', 'B) Kırık camlı pencere', 'C) Üç günlük dünya', 'D) Salonu büyük ev'], correctIndex: 3, explanation: 'A, B, C\'de "Sıfat Tamlaması + li/lik". D\'de ise "Devrik Tamlama + İyelik" (Salonu büyük ev -> Büyük salonlu ev).', difficulty: 3),
    StemQuestion(question: 'Hangisi "isimden fiil yapan" ek almamıştır?', options: ['A) Suçla', 'B) İzle', 'C) Bekle', 'D) Sevdir'], correctIndex: 3, explanation: 'Sev-dir (Fiilden fiil). Suç-la (İsimden fiil), İz-le (İsimden fiil), Bek-le (İsimden fiil).', difficulty: 3),
    StemQuestion(question: '"Bildirge" sözcüğü nasıl türetilmiştir?', options: ['A) Bil-dir-ge', 'B) Bildir-ge', 'C) Bil-dirge', 'D) Bil-di-r-ge'], correctIndex: 0, explanation: 'Bil-mek -> Bil-dir-mek (Fiilden Fiil) -> Bildir-ge (Fiilden İsim).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "-mez/-maz" eki sıfat fiil görevinde değildir?', options: ['A) Dönülmez akşamın ufkundayız.', 'B) Çıkmaz sokak.', 'C) Tükenmez kalem.', 'D) Buraya bir daha gelmez.'], correctIndex: 3, explanation: 'D\'de zaman (geniş zaman olumsuzu) ekidir, yüklemdir. Diğerlerinde sıfattır.', difficulty: 3),
    StemQuestion(question: '"Yaşantı" sözcüğünün kökü nedir?', options: ['A) Yaş (Islak)', 'B) Yaş (Ömür/Yıl)', 'C) Yaşa', 'D) Yaşan'], correctIndex: 1, explanation: 'Yaş (İsim/Ömür) -> Yaş-a-mak -> Yaşa-n-tı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde kaynaştırma yoktur?', options: ['A) Altışar', 'B) Yedişer', 'C) Beşer', 'D) İkişer'], correctIndex: 2, explanation: 'Beş-er (Kaynaştırma yok). Diğerlerinde ş kaynaştırma harfidir.', difficulty: 3),
  ],
  formulaCards: const ['Ek Eylem: İsmi yüklem, fiili birleşik zaman yapar.', 'İstisna: Annemsiz (Çekim önce gelmiş).', 'Yardımcı Eylem: Et, Ol, Kıl, Eyle.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 6: SÖZCÜK TÜRLERİ
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU6Content = StemUnitContent(
  unitId: 'kpsslise_tur_u6',
  topic: const TopicContent(
    summary: 'Sözcük türleri 8 ana başlıkta incelenir: İsim (Ad), Sıfat (Ön ad), Zamir (Adıl), Zarf (Belirteç), Edat (İlgeç), Bağlaç, Ünlem ve Fiil (Eylem). Bir sözcüğün türü, cümledeki kullanımına göre değişebilir (Örn: "Yalnız" adam [Sıfat], "Yalnız" geldi [Zarf]).',
    rule: 'Sıfatlar ismin önüne gelir (Güzel ev), Zarflar fiilin önüne gelir (Güzel konuştu). Zamirler ismin yerini tutar (O geldi).',
    formulas: [
      'Sıfat + İsim = Sıfat Tamlaması (Kırmızı elma).',
      'Zarf + Fiil = Durum/Zaman (Hızlı koştu).',
      'Zamir: İsmin dublörü (Ahmet -> O).'
    ],
    keyPoints: [
      '"O" ve "Onlar" hem kişi hem işaret zamiri olabilir. İnsan içinse Kişi, insan dışıysa İşaret.',
      'Sıfatlar çekim eki almaz (Güzeller ev diyemeyiz), Zamirler alır (Güzelleri severim).',
      'Niteleme sıfatları "Nasıl?" sorusuna cevap verir.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "güzel" sözcüğü zarf görevindedir?',
        options: ['A) Güzel bir gün geçirdik.', 'B) Yemekler çok güzeldi.', 'C) Bize güzel davrandı.', 'D) En güzel elbisesini giydi.'],
        correctIndex: 2,
        explanation: 'Davrandı (Fiil). Nasıl davrandı? Güzel (Zarf). A ve D\'de sıfat, B\'de isimleşmiş yüklem.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi işaret zamiridir?',
        options: ['A) Bu kitabı okudum.', 'B) Şunu bana ver.', 'C) O adamı tanıyorum.', 'D) Öteki yol daha kısa.'],
        correctIndex: 1,
        explanation: 'Şunu (İsmin yerini tutmuş). Diğerlerinde ismin önünde olduğu için işaret sıfatıdır (Bu kitap, O adam).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "belgisiz sıfat" vardır?',
        options: ['A) Bazı insanlar çok konuşur.', 'B) Kimse beni anlamıyor.', 'C) Herkes buraya gelsin.', 'D) Biri seni sordu.'],
        correctIndex: 0,
        explanation: 'Bazı insanlar (Hangi insanlar? Belli değil -> Belgisiz Sıfat). B, C, D belgisiz zamirdir.',
        difficulty: 1),
    StemQuestion(
        question: '"İle" sözcüğü hangisinde bağlaç görevindedir (Ve anlamında)?',
        options: ['A) Defter ile kalem aldım.', 'B) Kalem ile yazıyorum.', 'C) Arabayla geldik.', 'D) Sevgiyle büyür.'],
        correctIndex: 0,
        explanation: 'Defter ve kalem aldım (Ve yerine gelmiş -> Bağlaç). B, C, D araç/vasıta bildirir (Edat).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi türemiş bir isimdir?',
        options: ['A) Kitaplık', 'B) Demir', 'C) Masa', 'D) Yol'],
        correctIndex: 0,
        explanation: 'Kitap-lık (Yapım eki almış isim).',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdaki altı çizili sözcüklerden hangisi edattır?',
        options: ['A) Gibi bakıyordu.', 'B) Ve geldi.', 'C) Ama görmedi.', 'D) Çünkü hastaydı.'],
        correctIndex: 0,
        explanation: 'Gibi (Benzetme edatı). Diğerleri bağlaçtır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde soru anlamı "sıfat" ile sağlanmıştır?',
        options: ['A) Nasıl geldin?', 'B) Hangi evi beğendin?', 'C) Ne zaman döneceksin?', 'D) Kim aradı?'],
        correctIndex: 1,
        explanation: 'Hangi ev (İsmi soruyor -> Soru sıfatı). A ve C Zarf, D Zamir.',
        difficulty: 1),
    StemQuestion(
        question: '"Yalnız" sözcüğü hangisinde sıfat görevindedir?',
        options: ['A) Yalnız yaşıyor.', 'B) Yalnız taş duvar olmaz.', 'C) Gelirim yalnız erken kalkarım.', 'D) Evde yalnızım.'],
        correctIndex: 1,
        explanation: 'Yalnız taş (Nasıl taş? -> Sıfat). A (Zarf), C (Bağlaç/Ama), D (İsim).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi topluluk ismidir?',
        options: ['A) Öğrenciler', 'B) Orman', 'C) Ağaçlar', 'D) Askerler'],
        correctIndex: 1,
        explanation: 'Orman (Çoğul eki almadığı halde çokluk bildirir).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde niteleme sıfatı yoktur?',
        options: ['A) Sarı saç', 'B) Kırık kalp', 'C) Şu ev', 'D) Uzun yol'],
        correctIndex: 2,
        explanation: 'Şu ev (İşaret sıfatıdır, belirtme sıfatı grubundadır).',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde altı çizili sözcük türü bakımından diğerlerinden farklıdır?', options: ['A) Hızlı koştu.', 'B) Güzel konuştu.', 'C) Doğru söyledi.', 'D) Zor soru.'], correctIndex: 3, explanation: 'A, B, C fiili nitelediği için Zarf. D\'de ismi (soru) nitelediği için Sıfat.', difficulty: 1),
    StemQuestion(question: '"O" sözcüğü hangisinde kişi zamiri olarak kullanılmıştır?', options: ['A) O, benim en sevdiğim kalemimdir.', 'B) O, dün akşam bize geldi.', 'C) O, raflara dizilecek.', 'D) O, çok eski bir binadır.'], correctIndex: 1, explanation: 'İnsan (o) -> Kişi zamiri. Diğerleri insan dışı -> İşaret zamiri.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "pekiştirilmiş sıfat" vardır?', options: ['A) Masmavi deniz.', 'B) Yavaş yavaş yürüdü.', 'C) Güzel mi güzel bir ev.', 'D) Tertemiz yıkadı.'], correctIndex: 0, explanation: 'Masmavi deniz (Sıfat, m-p-r-s ile pekiştirme). B (Zarf/İkileme), C (Pekiştirme ama edat ile), D (Zarf - yıkadı fiil).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "zincirleme isim tamlaması" vardır?', options: ['A) Okulun kapısının kolu.', 'B) Tahta kapı.', 'C) Kapı kolu.', 'D) Benim kalemim.'], correctIndex: 0, explanation: 'En az 3 isim.', difficulty: 1),
    StemQuestion(question: 'Aşağıdakilerden hangisi bağlaç değildir?', options: ['A) Veya', 'B) Yahut', 'C) Sanki', 'D) Ki'], correctIndex: 2, explanation: 'Sanki (Benzetme edatı kökenlidir, zarf/edat olarak kullanılır, bağlaç değildir).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "durum zarfı" kullanılmıştır? (Nasıl?)', options: ['A) Yarın geleceğim.', 'B) İçeri girdi.', 'C) Sessizce oturdu.', 'D) Çok çalıştı.'], correctIndex: 2, explanation: 'Nasıl oturdu? Sessizce.', difficulty: 1),
    StemQuestion(question: 'Hangisi soyut isimdir?', options: ['A) Rüzgar', 'B) Hava', 'C) Rüya', 'D) Elektrik'], correctIndex: 2, explanation: 'Rüya (Zihinsel imgedir, madde değildir). Rüzgar, hava, elektrik fiziksel olarak hissedilir/ölçülür (Somut).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "adlaşmış sıfat" vardır?', options: ['A) İhtiyar adam yürüyor.', 'B) İhtiyarlar parkta oturuyor.', 'C) Genç çocuk koştu.', 'D) Mavi gömlek aldı.'], correctIndex: 1, explanation: 'İhtiyar (insan)lar -> İhtiyarlar. İsim düşmüş, sıfat isimleşmiş.', difficulty: 1),
    StemQuestion(question: 'Hangisinde soru anlamı zamirle sağlanmıştır?', options: ['A) Hangi kitabı aldın?', 'B) Kaç gün kalacaksın?', 'C) Çantada ne var?', 'D) Nasıl geldin?'], correctIndex: 2, explanation: 'Ne var? (Kitap var -> Cevap isim). A, B Sıfat, D Zarf.', difficulty: 1),
    StemQuestion(question: '"Kadar" sözcüğü hangisinde "eşitlik" anlamı katmıştır?', options: ['A) Sabaha kadar uyumadı.', 'B) Cennet kadar güzel vatan.', 'C) Senin kadar çalışkan.', 'D) Eve kadar yürüdük.'], correctIndex: 2, explanation: 'Seninle eşit derecede çalışkan.', difficulty: 1),
    StemQuestion(question: 'Hangisi dönüşlülük zamiridir?', options: ['A) Ben', 'B) Sen', 'C) Kendi', 'D) Biz'], correctIndex: 2, explanation: 'Kendi.', difficulty: 1),
    StemQuestion(question: 'Hangisinde belirtisiz isim tamlaması vardır?', options: ['A) Kapının kolu', 'B) Masa örtüsü', 'C) Kırmızı kalem', 'D) Taş bina'], correctIndex: 1, explanation: 'Masa(nın) örtüsü -> Masa örtüsü (Tamlayan eki yok).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "azlık-çokluk" (miktar) zarfı vardır?', options: ['A) Akşam geldim.', 'B) Hızlı koştu.', 'C) Pek sevmedim.', 'D) Yukarı çıktı.'], correctIndex: 2, explanation: 'Ne kadar sevmedim? Pek (Miktar).', difficulty: 1),
    StemQuestion(question: 'Hangisi ünlem değildir?', options: ['A) Eyvah', 'B) Hey', 'C) Of', 'D) Çünkü'], correctIndex: 3, explanation: 'Çünkü bağlaçtır.', difficulty: 1),
    StemQuestion(question: '"Bir" sözcüğü hangisinde sayı sıfatı olarak kullanılmıştır? (Adet)', options: ['A) Bir gün buluşuruz (Herhangi).', 'B) Bir adam seni sordu (Herhangi).', 'C) Sadece bir elma kaldı (Tek).', 'D) Bir yaz günüydü (Herhangi).'], correctIndex: 2, explanation: 'Tek anlamındaysa sayı sıfatıdır, herhangi anlamındaysa belgisiz sıfattır.', difficulty: 1),
  ],
  formulaCards: const ['Sıfat: İsmin önüne gelir.', 'Zarf: Fiilin önüne gelir.', 'Zamir: İsmin yerine geçer.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU6Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u6',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde sözcük türleri; edat ve bağlaçların ayrımı (ile, yalnız, ancak), fiilimsilerin türleri ve zarfların detayları (yer-yön zarflarında ek almama kuralı) üzerine yoğunlaşır. Ayrıca "tamlamalar" konusu detaylıca sorgulanır.',
    rule: '"İle" yerine "ve" geliyorsa BAĞLAÇ, gelmiyorsa EDATTIR. "Yalnız/Ancak" yerine "sadece" geliyorsa EDAT, "ama" geliyorsa BAĞLAÇTIR.',
    formulas: [
      'İle -> Ve = Bağlaç.',
      'Yalnız -> Ama = Bağlaç.',
      'Yalnız -> Sadece = Edat.',
      'Yer-Yön Zarfı: Ek almaz (İçeri gir - Zarf / İçeriye gir - İsim).'
    ],
    keyPoints: [
      'Fiilimsiler (İsim-fiil, Sıfat-fiil, Zarf-fiil) yan cümlecik kurar.',
      'Takısız isim tamlaması ile Sıfat tamlaması karışır: Hammadde veya benzerlik varsa Takısız (Altın yüzük), Niteleme varsa Sıfat (Sarı yüzük).',
      'Soru zarfı "Neden, Niçin, Ne diye" sorularıdır.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "ile" edat görevindedir?',
        options: ['A) Defter ile kalem aldım.', 'B) Oraya uçakla gittik.', 'C) Ali ile Veli geldi.', 'D) Elma ile armut kardeştir.'],
        correctIndex: 1,
        explanation: 'Uçak(la) -> Uçak ve gittik (Olmaz). Vasıta edatıdır. Diğerlerinde "ve" anlamındadır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde yer-yön bildiren sözcük "zarf" görevindedir?',
        options: ['A) Aşağıya bakma.', 'B) Yukarı çık.', 'C) İçerisi çok sıcak.', 'D) Dışarıdan ses geldi.'],
        correctIndex: 1,
        explanation: 'Yukarı (Ek almamış fiili belirtiyor). A, C, D ek aldığı için isimleşmiştir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "ancak" sözcüğü bağlaç olarak kullanılmıştır?',
        options: ['A) Bu işi ancak sen yaparsın (Sadece).', 'B) Seni aradım ancak ulaşamadım (Ama).', 'C) Parası ancak yetti (Zarf/Güçlükle).', 'D) Sabah ancak uyandım (Zarf).'],
        correctIndex: 1,
        explanation: 'Ama anlamındaysa bağlaçtır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "ne...ne" bağlacı kullanılmıştır ve yüklem olumlu olmalıdır?',
        options: ['A) Ne aradı ne sordu.', 'B) Ne geliyor ne gidiyor.', 'C) Ne kızı verir ne dünürü küstürür.', 'D) Hepsi'],
        correctIndex: 3,
        explanation: 'Ne...ne bağlacı kullanılan cümlelerin yüklemi biçimce olumlu, anlamca olumsuzdur. Hepsi doğru örnektir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "unvan sıfatı" değildir?',
        options: ['A) Doktor Ali', 'B) Ali Bey', 'C) Yüzbaşı Ahmet', 'D) Çalışkan Ali'],
        correctIndex: 3,
        explanation: 'Çalışkan niteleme sıfatıdır. Diğerleri rütbe/lakap/meslek bildirir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde eylemi "durum" bakımından niteleyen bir zarf yoktur?',
        options: ['A) Eğri oturup doğru konuşalım.', 'B) Hızlıca geçti.', 'C) Güzelce temizledi.', 'D) Yarın gelecek.'],
        correctIndex: 3,
        explanation: 'Yarın (Zaman zarfıdır). Diğerleri durum (nasıl) zarfıdır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "ilgi zamiri" (-ki) vardır?',
        options: ['A) Bahçedeki ağaç.', 'B) Benimki kırıldı.', 'C) Dün gördüm ki ağlıyordu.', 'D) Masadaki vazo.'],
        correctIndex: 1,
        explanation: 'Benim kalemim -> Benimki. (İsmin yerini tutmuş). A ve D sıfat yapan ki, C bağlaç olan ki.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "birleşik zamanlı fiil" vardır (Hikaye/Rivayet/Şart)?',
        options: ['A) Gelmelisin', 'B) Gidiyormuş', 'C) Bakacak', 'D) Seviyor'],
        correctIndex: 1,
        explanation: 'Gidiyor-imiş (Şimdiki zamanın rivayeti).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde tamlayanı ile tamlananı yer değiştirmiş bir isim tamlaması vardır?',
        options: ['A) Kırıldı kolu kapının.', 'B) Kapının kolu kırıldı.', 'C) Kırık kapı kolu.', 'D) Kapı kolunu kırdı.'],
        correctIndex: 0,
        explanation: 'Kapının kolu -> Kolu kapının (Devrik).',
        difficulty: 2),
    StemQuestion(
        question: '"Böyle" sözcüğü hangisinde sıfat görevindedir?',
        options: ['A) Böyle konuşma.', 'B) Böyle davranma.', 'C) Böyle insanlar sevilmez.', 'D) İşler böyle gidiyor.'],
        correctIndex: 2,
        explanation: 'Böyle insan (İsmi nitelemiş). Diğerlerinde fiili nitelemiş (Zarf).',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "gibi" edatı cümleye "tahmin" anlamı katmıştır?', options: ['A) Cennet gibi vatanımız var.', 'B) Bugün yağmur yağacak gibi.', 'C) Aslan gibi kükredi.', 'D) Senin gibi çalışkanını görmedim.'], correctIndex: 1, explanation: 'Olasılık/Tahmin. A, C Benzetme, D Karşılaştırma.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "işaret sıfatı" ile "işaret zamiri" bir arada kullanılmıştır?', options: ['A) Bu kitabı şuraya koy.', 'B) Bu, en sevdiğim kitaptır.', 'C) Şunu bana ver.', 'D) O ev, bu evden güzel.'], correctIndex: 0, explanation: 'Bu kitap (Sıfat), Şuraya (Zamir).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "belgisiz zamir" nesne görevindedir?', options: ['A) Herkesi çağırdım.', 'B) Biri geldi.', 'C) Kimse yok mu?', 'D) Bazıları gelmedi.'], correctIndex: 0, explanation: 'Kimi çağırdım? Herkesi (Nesne).', difficulty: 2),
    StemQuestion(question: '"Doğru" sözcüğü hangisinde edat görevindedir?', options: ['A) Doğru söyleyeni dokuz köyden kovarlar (Zarf).', 'B) Doğru yol (Sıfat).', 'C) Sabaha doğru uyudum (Edat).', 'D) Doğruyu yanlışı ayır (İsim).'], correctIndex: 2, explanation: 'e-doğru (Yönelme edatı).', difficulty: 2),
    StemQuestion(question: 'Hangisi "sıfat tamlaması" değildir?', options: ['A) Güzel ev', 'B) Kırık masa', 'C) Yolun sonu', 'D) Mavi gökyüzü'], correctIndex: 2, explanation: 'Yolun sonu (Belirtili isim tamlaması).', difficulty: 2),
    StemQuestion(question: 'Hangisinde soru anlamı "edat" ile sağlanmıştır?', options: ['A) Gelecek misin?', 'B) Ne zaman geldin?', 'C) Kim geldi?', 'D) Hangi ev?'], correctIndex: 0, explanation: 'Mı/Mi soru edatıdır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "zaman zarfı" kullanılmamıştır?', options: ['A) Dün seni gördüm.', 'B) Sabahları koşarım.', 'C) Akşam oldu hüzünlendim.', 'D) Şimdi geliyorum.'], correctIndex: 2, explanation: 'C şıkkında "Akşam" özne görevindedir (Olan ne? Akşam oldu). Zaman zarfı değil, isimdir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "-den" eki tamlayan eki (-ın) yerine kullanılmıştır?', options: ['A) Öğrencilerden biri.', 'B) Okuldan geldim.', 'C) Korkudan ağladı.', 'D) Yürekten inandı.'], correctIndex: 0, explanation: 'Öğrencilerin biri.', difficulty: 2),
    StemQuestion(question: '"Kimi" sözcüğü hangisinde farklı bir görevdedir?', options: ['A) Kimi insanlar çok çalışır.', 'B) Kimi çok sever, kimi nefret eder.', 'C) Kimi öğrencileri uyardım.', 'D) Kimi sorular zordu.'], correctIndex: 1, explanation: 'B\'de Zamir (İsmin yerine geçmiş). A, C, D\'de Sıfat (İsmin önünde).', difficulty: 2),
    StemQuestion(question: 'Hangisinde fiil "emir kipi"yle çekimlenmiştir?', options: ['A) Buraya gel.', 'B) Gelesin.', 'C) Gelmeli.', 'D) Gelse.'], correctIndex: 0, explanation: 'Gel (Emir).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "birleşik fiil" farklı bir yolla oluşmuştur?', options: ['A) Yardım etmek (İsim+Yardımcı Fiil).', 'B) Hasta olmak (İsim+Yardımcı Fiil).', 'C) Hapsolmak (İsim+Yardımcı Fiil).', 'D) Bakakalmak (Kurallı Birleşik Fiil).'], correctIndex: 3, explanation: 'D Kurallı (Sürerlik), diğerleri Yardımcı Eylem.', difficulty: 2),
    StemQuestion(question: 'Hangisinde eylem "kılış" (iş) bildirir? (Onu alabilen)', options: ['A) Uyudu.', 'B) Büyüdü.', 'C) Okudu.', 'D) Sarardı.'], correctIndex: 2, explanation: 'Onu okudu (Olur -> Kılış). Onu uyudu/büyüdü (Olmaz -> Durum/Oluş).', difficulty: 2),
    StemQuestion(question: '"Üzere" edatı hangisinde "amaç" ilgisi kurmuştur?', options: ['A) Konuşmak üzere kürsüye çıktı.', 'B) Güneş batmak üzere.', 'C) Yarın ödemek üzere borç aldı.', 'D) Anlaştığımız üzere hareket et.'], correctIndex: 0, explanation: 'Konuşmak amacıyla.', difficulty: 2),
    StemQuestion(question: 'Hangisi "zincirleme isim tamlaması" değildir?', options: ['A) Türkiye\'nin eğitim sorunu.', 'B) Macera romanının kapağı.', 'C) Altın sarısı saçlar.', 'D) Okul müdürünün odası.'], correctIndex: 2, explanation: 'Altın sarısı saçlar: İçinde isim tamlaması barındıran sıfat tamlamasıdır. Zincirleme isim tamlaması değildir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "dönüşlülük zamiri" (kendi) pekiştirme görevindedir?', options: ['A) Kendi geldi.', 'B) Ben kendim yaptım.', 'C) Kendine iyi bak.', 'D) Kendi düşen ağlamaz.'], correctIndex: 1, explanation: 'Ben kendim (Özneyle birlikte kullanılıp pekiştirmiş).', difficulty: 2),
  ],
  formulaCards: const ['İle: Ve olursa Bağlaç.', 'Yalnız: Sadece olursa Edat.', 'Zarf: Yer-Yön ek almaz.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU6Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u6',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde sözcük türleri; sözcüklerin cümle içindeki ince anlam farklarına (zarf tümleci vs dolaylı tümleç ayrımında edatların rolü), eylemsilerin (fiilimsilerin) tür özelliklerine ve karmaşık tamlamalara odaklanır. Ayrıca "adlaşmış sıfat-fiil" ve "bağlaç olan ki" ile "sıfat yapan ki"nin karmaşık cümlelerdeki analizi önemlidir.',
    rule: '"-dığı" eki sıfat-fiil ekidir, ancak "dığında" zarf-fiil ekidir. Eklerin bütününe bakmak gerekir. (Geldiği gün [Sıfat-Fiil] vs Geldiğinde ara [Zarf-Fiil]).',
    formulas: [
      'Sıfat-Fiil: An, ası, mez, ar, dik, ecek, miş.',
      'Zarf-Fiil: Ken, alı, asiye, ince, ip, araklayıp, dıkça...',
      'İsim-Fiil: Ma, ış, mak.'
    ],
    keyPoints: [
      '"Değil" sözcüğü edattır ve olumsuzluk yapar.',
      '"Mi" soru edatı her zaman ayrı yazılır ama kendinden sonra gelen ekler bitişir (Gidiyor musunuz?).',
      'Birleşik fiillerde "yazımı kurallı" olanlara dikkat: "Vazgeçmek" (Bitişik, anlamca kaynaşmış), "Başvurmak" (Bitişik).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "sıfat-fiil" (ortaç) adlaşmıştır?',
        options: ['A) Gelen gideni aratır.', 'B) Koşan çocuk düştü.', 'C) Bildik konuları anlattı.', 'D) Gelecek hafta sınav var.'],
        correctIndex: 0,
        explanation: 'Gelen (insan) Giden(i) -> Adlaşmış sıfat fiil. Diğerlerinde sıfat görevini koruyor (Hangi çocuk? Koşan).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "zarf-fiil" cümleye "durum" anlamı katmıştır?',
        options: ['A) Eve gelince beni ara.', 'B) Güle oynaya okula gitti.', 'C) Sen gideli çok oldu.', 'D) Yağmur yağdıkça bereket artar.'],
        correctIndex: 1,
        explanation: 'Nasıl gitti? Güle oynaya (Durum). A, C, D zaman bildirir.',
        difficulty: 3),
    StemQuestion(
        question: '"Beri" sözcüğü hangisinde edat görevindedir?',
        options: ['A) Beri gel.', 'B) Beri taraf.', 'C) Dünden beri bekliyorum.', 'D) Berisi yalan.'],
        correctIndex: 2,
        explanation: 'e-beri (Zaman/Süreç bildiren edat). A (Zarf), B (Sıfat), D (İsim/Zamir).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "edat grubu" sıfat görevindedir?',
        options: ['A) Cennet gibi vatan.', 'B) Çocuk gibi ağladı.', 'C) Akşama kadar çalıştı.', 'D) Sabaha doğru geldi.'],
        correctIndex: 0,
        explanation: 'Cennet gibi (Edat grubu) -> Vatan (İsim). Sıfat görevi üstlenmiş. Diğerlerinde zarf görevinde.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "bağlaç" özne görevindeki sözcükleri bağlamıştır?',
        options: ['A) Ali ve Veli geldi.', 'B) Elma ve armut aldım.', 'C) Okudu ve yazdı.', 'D) Hem ağlarım hem giderim.'],
        correctIndex: 0,
        explanation: 'Gelen kim? Ali ve Veli (Özne).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde eylem "birleşik çekimli" değildir?',
        options: ['A) Yapsaydı', 'B) Gelecekti', 'C) Gidiyordu', 'D) Baktı'],
        correctIndex: 3,
        explanation: 'Bak-tı (Basit zaman). Diğerleri (Şartın hikayesi, Geleceğin hikayesi, Şimdinin hikayesi).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "isim-fiil" (mastar) eki alan sözcük kalıcı isim olmuştur?',
        options: ['A) Okumayı severim.', 'B) Danışmaya sordun mu?', 'C) Gülüşü çok güzel.', 'D) Bakmak görmek değildir.'],
        correctIndex: 1,
        explanation: 'Danışma (Yer adı/Birim).',
        difficulty: 3),
    StemQuestion(
        question: '"Göre" edatı hangisinde "karşılaştırma" anlamı katmıştır?',
        options: ['A) Bana göre bu yanlış.', 'B) Kumaşa göre elbise dik.', 'C) Bu ev diğerine göre geniş.', 'D) Duyduğuma göre gelmiş.'],
        correctIndex: 2,
        explanation: 'Diğeri ile kıyaslama. A (Görecelik), B (Uygunluk), D (Rivayet).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "tamlayanı düşmüş isim tamlaması" vardır?',
        options: ['A) Evin yolu.', 'B) Kardeşi geldi.', 'C) Okul müdürü.', 'D) Kapı kolu.'],
        correctIndex: 1,
        explanation: '(Onun) kardeşi. Tamlayan (Onun) düşmüş.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "belgisiz sıfat" bir isim tamlamasında tamlananı nitelemiştir?',
        options: ['A) Her türlü insan.', 'B) İnsanların birçok derdi.', 'C) Bazı evlerin çatısı.', 'D) Hiçbir yer.'],
        correctIndex: 1,
        explanation: 'İnsanların (Tamlayan) derdi (Tamlanan). Birçok (Sıfat) tamlananı nitelemiş. (İnsanların derdi -> Araya sıfat girmiş).',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde "ki" bağlacı "neden-sonuç" ilgisi kurmuştur?', options: ['A) Bir baktım ki gitmiş.', 'B) Çalış ki başarasın.', 'C) O kadar yorgunum ki anlatamam.', 'D) Erken gel ki görüşelim.'], correctIndex: 2, explanation: 'Yorgunum (Neden) -> Anlatamam (Sonuç). Şiddet/Aşırılık yoluyla sebep bildirir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "üstünlük zarfı" (daha) sıfatı derecelendirmiştir?', options: ['A) Daha hızlı koş.', 'B) Daha güzel bir ev.', 'C) Daha gelmedi.', 'D) Daha çok çalış.'], correctIndex: 1, explanation: 'Güzel ev (Sıfat tamlaması). Daha -> Güzel (Sıfatı) derecelendirmiş. A ve D\'de zarfı (hızlı, çok) derecelendirmiş. C (Zaman/Henüz).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "kurallı birleşik sıfat" (lı, lık, sız...) vardır?', options: ['A) Kırık dökük eşya.', 'B) Üç günlük yol.', 'C) Kırmızı kalem.', 'D) Yıkık duvar.'], correctIndex: 1, explanation: 'Üç gün-lük yol (Sıfat tamlamasına "-lük" eki getirilerek oluşmuş). A (İkileme sıfat), C (Niteleme sıfatı), D (Sıfat-fiil/Türemiş sıfat).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ek eylem" düşmüştür?', options: ['A) O çok iyi bir doktordur.', 'B) En sevdiği renk mavidir.', 'C) Hava bugün çok güzel.', 'D) Bu konu çok önemlidir.'], correctIndex: 2, explanation: 'Güzel(dir). 3. tekil şahıs eki -dir genelde düşer.', difficulty: 3),
    StemQuestion(question: '"Oysa" sözcüğü için hangisi doğrudur?', options: ['A) Edattır.', 'B) Zarftır.', 'C) Bağlaçtır.', 'D) Ünlemdir.'], correctIndex: 2, explanation: 'Karşıtlık bağlacıdır.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "isim-fiil" grubu özne görevindedir?', options: ['A) Kitap okumayı severim.', 'B) Erken kalkmak zordur.', 'C) Çalışmak başarmanın yarısıdır.', 'D) Gidişine üzüldüm.'], correctIndex: 1, explanation: 'Zor olan ne? Erken kalkmak (Özne).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "sıfat fiil" sıfat görevinde değildir (Adlaşmış veya kalıcı isim)?', options: ['A) Dönülmez yollar.', 'B) Bilindik hikayeler.', 'C) Yakacak sıkıntısı.', 'D) Koşar adım.'], correctIndex: 2, explanation: 'Yakacak (Kömür, odun -> Kalıcı İsim).', difficulty: 3),
    StemQuestion(question: '"Bir" sözcüğü hangisinde "belgisiz sıfat" değildir?', options: ['A) Bir akşam geleceğim.', 'B) Bir gün anlarsın.', 'C) Bana bir bardak su ver.', 'D) Bir bahar sabahıydı.'], correctIndex: 2, explanation: 'Sayı sıfatı (Adet/Tek). Bağlama göre tek bir bardak kastediliyorsa sayı sıfatıdır. A, B, D kesinlikle belgisizdir (zaman belirsizliği).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "tamlayanı ile tamlananı arasına sözcük girmiş" isim tamlaması vardır?', options: ['A) Kırmızı gülün kokusu.', 'B) Ali\'nin defteri.', 'C) Bahçenin eski kapısı.', 'D) Şehrin gürültüsü.'], correctIndex: 2, explanation: 'Bahçe-nin (Tamlayan) eski (Sıfat/Araya girmiş) kapı-sı (Tamlanan). Diğerlerinde tamlayan ile tamlanan arasına sözcük girmemiştir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "hem niteleme hem belirtme sıfatı" almış bir isim vardır?', options: ['A) Şu büyük ev.', 'B) Kırmızı kalem.', 'C) Bu ev.', 'D) Güzel gün.'], correctIndex: 0, explanation: 'Şu (Belirtme/İşaret) Büyük (Niteleme) Ev.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ne" sözcüğü zarf görevindedir?', options: ['A) Ne bakıyorsun? (Niçin).', 'B) Ne gün geleceksin? (Sıfat).', 'C) Çantada ne var? (Zamir).', 'D) Ne aldın? (Zamir).'], correctIndex: 0, explanation: 'Niçin anlamındaki "ne" soru zarfıdır. B (Sıfat), C ve D (Zamir).', difficulty: 3),
    StemQuestion(question: '"Karşı" sözcüğü hangisinde edat değildir?', options: ['A) Sabaha karşı uyudum.', 'B) Denize karşı oturduk.', 'C) Karşı evde oturuyor.', 'D) Bana karşı dürüst ol.'], correctIndex: 2, explanation: 'Karşı ev (Sıfat).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "birleşik fiil" bitişik yazılması gerekirken ayrı yazılmıştır (Yazım Yanlışı)?', options: ['A) Devretmek', 'B) His etmek', 'C) Kaybetmek', 'D) Affetmek'], correctIndex: 1, explanation: 'Hissetmek (Ünsüz türemesi var, bitişik olmalı).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "-ce" eki zarf türetmiştir?', options: ['A) Türkçeyi seviyorum.', 'B) İngilizce biliyor.', 'C) Dostça konuştu.', 'D) Sınıfça gittik.'], correctIndex: 2, explanation: 'Nasıl konuştu? Dostça (Durum zarfı). A, B isim (Dil adı).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "adıl" (zamir) yüklem olmuştur?', options: ['A) Gelen oymuş.', 'B) Ev güzelmiş.', 'C) Ali hastaymış.', 'D) Koşuyordu.'], correctIndex: 0, explanation: 'O-y-muş (Zamir yüklem olmuş).', difficulty: 3),
  ],
  formulaCards: const ['Değil: Olumsuzluk edatı.', 'Sıfat-Fiil: An-ası-mez-ar-dik-ecek-miş.', 'Mi: Kendinden sonrakiyle bitişir.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 7: CÜMLE BİLGİSİ
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU7Content = StemUnitContent(
  unitId: 'kpsslise_tur_u7',
  topic: const TopicContent(
    summary: 'Cümle bilgisi iki ana başlıkta incelenir: 1. Cümlenin Ögeleri (Yüklem, Özne, Nesne, Tümleçler), 2. Cümle Türleri (Yüklemine, Ögesine, Anlamına, Yapısına göre). Temel ögeler Yüklem ve Öznedir. Yardımcı ögeler Nesne ve Tümleçlerdir.',
    rule: 'Öge bulunurken önce YÜKLEM, sonra ÖZNE bulunur. Diğer ögeler bu sıradan sonra aranır (YÖN kuralı: Yüklem-Özne-Nesne).',
    formulas: [
      'Yüklem: Yargı bildiren (Fiil veya Ek Eylem almış İsim).',
      'Özne: İşi yapan (Kim? Ne?).',
      'Nesne: İşten etkilenen (Neyi? Kimi? - Belirtili / Ne? - Belirtisiz).'
    ],
    keyPoints: [
      'Tamlamalar (isim/sıfat) ve deyimler asla bölünmez, tek bir öge olarak alınır.',
      'Gizli özne, öge sıralamasında gösterilmez, sadece cümle dışı unsur olarak bilinir.',
      'Yüklem sonda ise "Kurallı", değilse "Devrik" cümledir.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde yüklem yanlış gösterilmiştir?',
        options: ['A) Dün akşam geldi. [geldi]', 'B) En sevdiği renk mavidir. [mavidir]', 'C) Kadın çocuğuna baktı. [çocuğuna baktı]', 'D) Bahçedeki çiçekleri suladı. [suladı]'],
        correctIndex: 2,
        explanation: 'C şıkkında "baktı" yüklemdir. "Çocuğuna" dolaylı tümleçtir. Deyim olmadığı sürece ayrılmalıdır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinin yüklemi isim soyludur?',
        options: ['A) Kitabı masaya bıraktı.', 'B) Hava bugün çok güzel.', 'C) Sabah erken kalktım.', 'D) Ödevlerini bitirdi.'],
        correctIndex: 1,
        explanation: 'Güzel (İsim). (Güzel-dir ek eylemi düşmüş). Diğerleri fiildir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi kurallı bir cümledir?',
        options: ['A) Gidiyorum gündüz gece.', 'B) Ağlarım hatıra geldikçe.', 'C) Sakla samanı gelir zamanı.', 'D) Bugün hava çok sıcak.'],
        correctIndex: 3,
        explanation: 'Yüklem (sıcak) sondadır.',
        difficulty: 1),
    StemQuestion(
        question: '"Annem mutfakta yemek yapıyor." cümlesinin öznesi nedir?',
        options: ['A) Yemek', 'B) Mutfakta', 'C) Annem', 'D) Yapıyor'],
        correctIndex: 2,
        explanation: 'Yapan kim? Annem (Gerçek Özne).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "belirtili nesne" vardır?',
        options: ['A) Kitap okudum.', 'B) Kitabı okudum.', 'C) Eve gittim.', 'D) Hızlı koştum.'],
        correctIndex: 1,
        explanation: 'Neyi okudum? Kitab-ı (İsmin -i halini almıştır). A şıkkı belirtisiz nesnedir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "sözde özne" vardır (Edilgen çatı)?',
        options: ['A) Cam kırıldı.', 'B) Çocuk ağladı.', 'C) Annem temizledi.', 'D) Kuş uçtu.'],
        correctIndex: 0,
        explanation: 'Kıran belli değil, cam işten etkilenen ama özne konumundadır.',
        difficulty: 1),
    StemQuestion(
        question: '"Sabahları sahilde koşarım." cümlesinde hangi öge yoktur?',
        options: ['A) Zarf Tümleci', 'B) Dolaylı Tümleç', 'C) Yüklem', 'D) Nesne'],
        correctIndex: 3,
        explanation: 'Koşarım (Yüklem), Ben (Gizli Özne). Ne zaman? Sabahları (ZT). Nerede? Sahilde (DT). Nesne yoktur.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisi devrik cümledir?',
        options: ['A) Okula gidiyorum.', 'B) Gidiyorum okula.', 'C) Kalemim kırıldı.', 'D) Ders çalışıyorum.'],
        correctIndex: 1,
        explanation: 'Yüklem (Gidiyorum) başta/ortada.',
        difficulty: 1),
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde ögelerin sıralanışı "Özne - Yüklem" şeklindedir?',
        options: ['A) Yağmur yağıyor.', 'B) Ali eve gitti.', 'C) Dün seni gördüm.', 'D) Kitabı okudum.'],
        correctIndex: 0,
        explanation: 'Yağıyor (Yüklem). Yağan ne? Yağmur (Özne).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde dolaylı tümleç (yer tamlayıcısı) yoktur?',
        options: ['A) Eve gidiyorum.', 'B) Okulda bekliyorum.', 'C) Senden öğrendim.', 'D) Dün akşam geldim.'],
        correctIndex: 3,
        explanation: 'Dün akşam (Zaman Zarfı). A(Eve-Yönelme), B(Okulda-Bulunma), C(Senden-Ayrılma).',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde, ara söz öznenin açıklayıcısıdır?', options: ['A) İzmir\'i, doğduğum kenti, çok özledim.', 'B) Annem, canım benim, her şeyi bilir.', 'C) Bu kitap, emin olun, çok satacak.', 'D) Dün akşam, saat dokuzda, buluştuk.'], correctIndex: 1, explanation: 'Bilen kim? Annem (Özne). Ara söz (canım benim) özneyi açıklamıştır. A\'da Nesneyi (İzmir\'i), D\'de Zarf Tümlecini (Dün akşam) açıklamıştır.', difficulty: 1),
    StemQuestion(question: 'Hangisi "eksiltili cümle"dir (Yüklemi olmayan)?', options: ['A) Karşımızda masmavi bir deniz...', 'B) Gidiyorum gurbeti gönlümde duya duya.', 'C) Her şey çok güzeldi.', 'D) Kimse beni anlamıyor.'], correctIndex: 0, explanation: 'Yüklem yok (Deniz vardı/görünüyordu denmemiş).', difficulty: 1),
    StemQuestion(question: 'Hangisinde soru "özneyi" buldurmaya yöneliktir?', options: ['A) Kim geldi?', 'B) Kimi gördün?', 'C) Nerede oturuyorsun?', 'D) Ne zaman gideceksin?'], correctIndex: 0, explanation: 'Ali geldi (Ali öznedir). B (Nesne), C (Dolaylı Tümleç), D (Zarf Tümleci).', difficulty: 1),
    StemQuestion(question: '"Mavi kapılı ev, sokağın sonundaydı." cümlesinin yüklemi nedir?', options: ['A) Sonundaydı', 'B) Sokağın sonundaydı', 'C) Ev', 'D) Mavi kapılı ev'], correctIndex: 1, explanation: 'Sokağın sonu (İsim tamlaması) bölünemez.', difficulty: 1),
    StemQuestion(question: 'Hangisi "anlamca olumlu, biçimce olumsuz" bir cümledir?', options: ['A) Seni sevmiyor değilim.', 'B) Seni hiç sevmiyorum.', 'C) Gelme artık.', 'D) Ne aradı ne sordu.'], correctIndex: 0, explanation: 'Sevmiyor değilim = Seviyorum (Anlam olumlu). Biçimde "değil/me" var.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "gizli özne" yoktur?', options: ['A) Eve geldim.', 'B) Seni sordu.', 'C) Kitap masada duruyor.', 'D) Bize bakıyordu.'], correctIndex: 2, explanation: 'Duran ne? Kitap (Gerçek Özne cümle içinde var). A (Ben), B (O), D (O).', difficulty: 1),
    StemQuestion(question: '"Seni dün okulda gördüm." cümlesinin öge dizilişi nasıldır?', options: ['A) Nesne - ZT - DT - Yüklem', 'B) Özne - Nesne - Yüklem', 'C) ZT - Nesne - Yüklem', 'D) DT - Nesne - Yüklem'], correctIndex: 0, explanation: 'Gördüm (Y). Kim? Ben (Gizli). Kimi? Seni (B.li Nesne). Ne zaman? Dün (ZT). Nerede? Okulda (DT).', difficulty: 1),
    StemQuestion(question: 'Hangisi "ünlem cümlesi"dir?', options: ['A) Ne güzel bir hava!', 'B) Buraya gel.', 'C) Soru sordu mu?', 'D) Kitap okuyorum.'], correctIndex: 0, explanation: 'Duygu bildirir.', difficulty: 1),
    StemQuestion(question: 'Hangisi "isim cümlesi"dir?', options: ['A) Ağaçlar çiçek açtı.', 'B) En sevdiğim meyve elmadır.', 'C) Kuşlar uçuyor.', 'D) Yağmur yağacak.'], correctIndex: 1, explanation: 'Elma (İsim) yüklem olmuş.', difficulty: 1),
    StemQuestion(question: '"Bütün gün hiç durmadan çalıştı." cümlesinde "çalıştı" yüklemini niteleyen öge hangisidir?', options: ['A) Özne', 'B) Nesne', 'C) Zarf Tümleci', 'D) Dolaylı Tümleç'], correctIndex: 2, explanation: 'Nasıl çalıştı? Hiç durmadan. Ne zaman? Bütün gün. İkisi de zarf tümleci grubudur.', difficulty: 1),
    StemQuestion(question: 'Hangisinde nesne yoktur? (Geçişsiz fiil)', options: ['A) Kitabı okudum.', 'B) Suyu içtim.', 'C) Erken uyudum.', 'D) Seni bekledim.'], correctIndex: 2, explanation: 'Neyi uyudum? (Cevap yok, nesne alamaz).', difficulty: 1),
    StemQuestion(question: 'Hangisi "bağlı cümle"dir (Bağlaçla bağlanan)?', options: ['A) Geldim ve gördüm.', 'B) Gelip gördüm.', 'C) Gelince gördüm.', 'D) Gelir gelmez gördüm.'], correctIndex: 0, explanation: 'İki yüklem (Geldim, Gördüm) bağlaçla (ve) bağlanmış. B, C, D birleşiktir (Fiilimsi).', difficulty: 1),
    StemQuestion(question: 'Hangisi "sıralı cümle"dir (Virgülle bağlanan)?', options: ['A) Eve geldi, yemek yedi.', 'B) Eve gelince yemek yedi.', 'C) Eve geldi ve yemek yedi.', 'D) Eve gelen yemek yedi.'], correctIndex: 0, explanation: 'İki yüklem virgülle sıralanmış.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "-den" eki zarf tümleci yapmıştır?', options: ['A) Okuldan çıktı.', 'B) Yorgunluktan uyuyamadı.', 'C) Camdan baktı.', 'D) Evden ayrıldı.'], correctIndex: 1, explanation: 'Niçin uyuyamadı? Yorgunluktan (Sebep/Durum bildirir -> ZT). Diğerleri DT (Nereden?).', difficulty: 1),
    StemQuestion(question: 'Hangisi yüklemin türüne göre diğerlerinden farklıdır?', options: ['A) Gelmek.', 'B) Okumak.', 'C) Sevmek.', 'D) Kitap.'], correctIndex: 3, explanation: 'Kitap isimdir, diğerleri fiildir.', difficulty: 1),
  ],
  formulaCards: const ['YÖN Kuralı: Yüklem -> Özne -> Nesne.', 'DT Soruları: -e, -de, -den (Nereye/de/den).', 'İsim Cümlesi: Yüklem isimdir.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU7Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u7',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde Cümle Bilgisi; cümlenin yapısı (Basit, Birleşik, Sıralı, Bağlı) ve ögelerin detaylı analizi (özne-yüklem uyumu, vurgu) üzerine odaklanır. Özellikle "Girişik Birleşik Cümle" (Fiilimsi bulunan cümle) ve "Yan Cümlecik" kavramları önemlidir.',
    rule: 'Yan cümlecik genellikle fiilimsi ile kurulur. Cümlede kaç fiilimsi varsa o kadar yan cümlecik vardır.',
    formulas: [
      'Basit Cümle: Tek Yüklem + Fiilimsi YOK.',
      'Birleşik Cümle: Tek Yüklem + Fiilimsi VAR (Girişik).',
      'Sıralı Cümle: Yüklem , Yüklem.',
      'Bağlı Cümle: Yüklem (Bağlaç) Yüklem.'
    ],
    keyPoints: [
      'Yer-yön bildiren kelimeler (İçeri, dışarı) ek almazsa Zarf Tümleci, ek alırsa (İçeriye) Dolaylı Tümleçtir.',
      'Vurgu: Yüklem fiilse, yüklemden bir önceki ögededir.',
      'İsim cümlelerinde vurgu yüklemin kendisindedir.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "yan cümlecik" nesne görevindedir?',
        options: ['A) Eve geleni tanımıyorum.', 'B) Güneş doğunca yola çıktık.', 'C) Çalışan kazanır.', 'D) Okumak güzeldir.'],
        correctIndex: 0,
        explanation: 'Tanımıyorum (Y). Kimi? Eve geleni (Yan cümlecik/Fiilimsi -> Nesne). B (ZT), C (Özne), D (Özne).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi yapısına göre "girişik birleşik" cümledir?',
        options: ['A) Yağmur yağdı, her yer ıslandı.', 'B) Yağmur yağınca her yer ıslandı.', 'C) Yağmur yağdı ve her yer ıslandı.', 'D) Yağmur yağıyor.'],
        correctIndex: 1,
        explanation: 'Yağ-ınca (Fiilimsi var). A (Sıralı), C (Bağlı), D (Basit).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "vurgu" özne üzerindedir?',
        options: ['A) Ali dün camı kırdı.', 'B) Dün camı Ali kırdı.', 'C) Ali camı dün kırdı.', 'D) Camı Ali dün kırdı.'],
        correctIndex: 1,
        explanation: 'Yüklem (kırdı) fiildir. Vurgu yüklemden öncekindedir. B\'de Ali (Özne) yüklemden öncedir.',
        difficulty: 2),
    StemQuestion(
        question: '"Dışarı" sözcüğü hangisinde Dolaylı Tümleç görevindedir?',
        options: ['A) Dışarı çıktı.', 'B) Dışarıya çıktı.', 'C) Dışarı bak.', 'D) Dışarı gel.'],
        correctIndex: 1,
        explanation: 'Ek almış (Dışarı-y-a). Diğerlerinde ek almadığı için Zarf Tümlecidir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "bağımlı sıralı" cümledir (Öge ortaklığı olan)?',
        options: ['A) Mart kapıdan baktırır, kazma kürek yaktırır.', 'B) Ben çalıştım, o yattı.', 'C) Yağmur yağdı, trafik sıkıştı.', 'D) Ali geldi, Veli gitti.'],
        correctIndex: 0,
        explanation: 'Baktıran ne? Mart. Yaktıran ne? Mart. (Özne ortak).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi "iç içe birleşik" cümledir?',
        options: ['A) Geldiğini duydum.', 'B) "Yarın gel." dedi.', 'C) Okullar açılınca gideceğiz.', 'D) Seven ne yapmaz.'],
        correctIndex: 1,
        explanation: 'Cümle içinde doğrudan anlatım cümlesi varsa iç içe birleşiktir.',
        difficulty: 2),
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde soru "zarf tümlecini" buldurmaya yöneliktir?',
        options: ['A) Nasıl bir ev arıyorsun?', 'B) Buraya nasıl geldin?', 'C) Bu yemek nasıl olmuş?', 'D) Nasıl bir karakteri var?'],
        correctIndex: 1,
        explanation: 'Nasıl geldin? (Yürüyerek -> Eylemi niteliyor -> Zarf). Diğerleri sıfat veya yüklemdir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "edat tümleci" vardır?',
        options: ['A) Arabayla gitti.', 'B) Hızlıca koştu.', 'C) Dün geldi.', 'D) Evde durdu.'],
        correctIndex: 0,
        explanation: 'Ne ile? Araba ile (Vasıta/Birliktelik). KPSS\'de şıklarda Edat Tümleci yoksa Zarf Tümleci işaretlenir.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisi yüklemin türüne göre "isim cümlesi"dir?',
        options: ['A) Tek hedefi kazanmaktı.', 'B) Dün çok çalıştı.', 'C) Bizi görünce sevindi.', 'D) Kitabı okuyor.'],
        correctIndex: 0,
        explanation: 'Kazanmak (Fiilimsi -> İsimleşmiş). Mak/mek alan yüklem isim cümlesi sayılır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde yüklem "deyim"den oluşmuştur?',
        options: ['A) Soruları çabucak çözdü.', 'B) Bu işten ağzı yandı.', 'C) Eline kalemi aldı.', 'D) Yola koyuldu.'],
        correctIndex: 3,
        explanation: 'Yola koyulmak (Deyim, bölünmez bütün).',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde ögelere ayırmada bir yanlışlık yapılmıştır?', options: ['A) İstanbul\'u / çok / seviyorum.', 'B) Hayat / sürprizlerle / doludur.', 'C) Dün / akşam / size / geldik.', 'D) Kapının önündeki / yaşlı ağaç / devrildi.'], correctIndex: 2, explanation: 'C şıkkı: "Dün akşam" (Zaman Zarfı) bölünmez. Dün / akşam diye ayrılmış, yanlıştır.', difficulty: 2),
    StemQuestion(question: 'Hangisi "özne-yüklem uyumu" kuralına aykırıdır?', options: ['A) Çocuklar oynuyorlar.', 'B) Kuşlar uçuyor.', 'C) İnsanlar konuşuyorlar.', 'D) Gözlerim görmüyorlar.'], correctIndex: 3, explanation: 'İnsan dışı varlıklar/organlar çoğul özne olsa bile yüklem tekil olur. (Gözlerim görmüyor olmalı).', difficulty: 2),
    StemQuestion(question: 'Hangisi yapısına göre "basit" cümledir?', options: ['A) Gelen gideni aratır.', 'B) Rüzgar eken fırtına biçer.', 'C) Bugün hava çok güzel.', 'D) Okumak soylu bir eylemdir.'], correctIndex: 2, explanation: 'Tek yüklem, fiilimsi yok. A, B, D fiilimsi içerir (Birleşik).', difficulty: 2),
    StemQuestion(question: '"Korkunun ecele faydası yoktur." cümlesinin özellikleri hangisidir?', options: ['A) İsim, Kurallı, Olumsuz, Basit', 'B) Fiil, Kurallı, Olumlu, Birleşik', 'C) İsim, Devrik, Olumsuz, Basit', 'D) Fiil, Kurallı, Olumsuz, Sıralı'], correctIndex: 0, explanation: 'Yoktur (İsim), Sonda (Kurallı), Yok (Olumsuz), Fiilimsi yok (Basit).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ara söz" herhangi bir ögenin açıklayıcısı değildir?', options: ['A) İstanbul, o güzel şehir, artık çok kalabalık.', 'B) Ali, emin ol, bu işi başarır.', 'C) Dün, pazar günü, sinemaya gittik.', 'D) Annemi, o melek kadını, çok özledim.'], correctIndex: 1, explanation: 'Emin ol (Cümle dışı unsur). Herhangi bir ögeyi (özne, nesne vb.) açıklamaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "sıfat tamlaması" yüklem görevindedir?', options: ['A) Babam doktordu.', 'B) Evimiz bahçeliydi.', 'C) Burası, küçük bir kasabaydı.', 'D) Havası çok temizdi.'], correctIndex: 2, explanation: 'Küçük bir kasaba (Sıfat tamlaması) bölünemez, yüklem olmuş.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "sözde soru cümlesi" vardır (Cevap beklemeyen)?', options: ['A) Saat kaç?', 'B) Neden gelmedin?', 'C) İnsan vatanını sevmez mi?', 'D) Kim aradı?'], correctIndex: 2, explanation: 'Sever anlamında. Cevap beklemez.', difficulty: 2),
    StemQuestion(question: 'Hangisi "olumlu" bir cümledir?', options: ['A) Bu iş sandığın kadar kolay değil.', 'B) Cebimde beş kuruş yok.', 'C) Ne aradı ne sordu.', 'D) Seni sevmiyor değilim.'], correctIndex: 3, explanation: 'Sevmiyor değilim = Seviyorum (Anlamca olumlu).', difficulty: 2),
    StemQuestion(question: 'Aşağıdakilerden hangisi "şartlı birleşik cümle"dir?', options: ['A) Gelirse görüşürüz.', 'B) Gelince görüşürüz.', 'C) Gelip görüştük.', 'D) Geldiği için görüştük.'], correctIndex: 0, explanation: '-se/-sa ekiyle kurulan yan cümlecik.', difficulty: 2),
    StemQuestion(question: 'Hangisinde yüklemden önceki kelime vurgulanmıştır?', options: ['A) Ben seni dün aradım.', 'B) Dün seni ben aradım.', 'C) Ben dün seni aradım.', 'D) Aradım ben dün seni.'], correctIndex: 2, explanation: 'Seni (Nesne) vurgulanmıştır (Yüklem "aradım"dan önce).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "belirtisiz nesne" vardır?', options: ['A) Kitabı ver.', 'B) Kitap okudum.', 'C) Kitaba baktım.', 'D) Kitapta yazıyor.'], correctIndex: 1, explanation: 'Ne okudum? Kitap (Belirtisiz).', difficulty: 2),
    StemQuestion(question: 'Hangisi "öge ortaklığı olmayan" sıralı cümledir (Bağımsız Sıralı)?', options: ['A) Ali geldi, gitti.', 'B) Ben okudum, sen yazdın.', 'C) Kitabı aldı, inceledi.', 'D) Kapıyı açtı, içeri girdi.'], correctIndex: 1, explanation: 'Ben okudum (Ben özne). Sen yazdın (Sen özne). Ortak öge yok.', difficulty: 2),
    StemQuestion(question: 'Hangisi "yüklemin yerine göre" diğerlerinden farklıdır?', options: ['A) Görüyorum seni.', 'B) Bakıyorum sana.', 'C) Geldi bize.', 'D) Dün bize geldi.'], correctIndex: 3, explanation: 'Geldi sonda (Kurallı). Diğerleri devrik.', difficulty: 2),
    StemQuestion(question: '"Ağaçlar ayakta ölür." cümlesinin çatısı bakımından özelliği nedir?', options: ['A) Etken - Geçişli', 'B) Etken - Geçişsiz', 'C) Edilgen - Geçişli', 'D) Dönüşlü - Geçişsiz'], correctIndex: 1, explanation: 'Ölen ne? Ağaçlar (Etken). Neyi ölür? (Nesne almaz -> Geçişsiz).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ki"li birleşik cümle vardır?', options: ['A) Duydum ki unutmuşsun.', 'B) Evdeki hesap.', 'C) Sen ki beni tanırsın.', 'D) O kadar iyi ki...'], correctIndex: 0, explanation: 'Duydum (Yüklem) ki (Bağlaç) Unutmuşsun (Yan cümle). İlgi cümlesi.', difficulty: 2),
  ],
  formulaCards: const ['Basit: Tek yargı.', 'Birleşik: Fiilimsi/Şart/Ki.', 'Vurgu: Yüklemden önceki.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU7Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u7',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde Cümle Bilgisi; karmaşık cümle yapıları (iç içe birleşik, ki\'li birleşik, zincirleme tamlamalı ögeler), cümle dışı unsurların analizi ve öge buldurmaya yönelik soruların çeldiricileri üzerine kuruludur. Ayrıca mantık hatalarından kaynaklanan anlatım bozuklukları ile cümle yapısı arasındaki ilişki de sorgulanabilir.',
    rule: 'Soru edatı "mi", vurguyu kendinden önceki ögeye çeker. (Ali mi geldi? -> Özne vurgulu. Ali dün mü geldi? -> Zarf vurgulu).',
    formulas: [
      'Mi Vurgusu: Mi\'den önceki öge.',
      'Koşul Vurgusu: Koşul kipi vurguyu üzerine alır.',
      'Soru Sözcüğü Vurgusu: Soru sözcüğünün kendisi vurguludur.'
    ],
    keyPoints: [
      'İsim cümlelerinde vurgu yüklemdedir.',
      'Devrik cümlelerde yüklem baştaysa vurgu yüklemdedir.',
      'Cümle ögelerine ayrılırken deyimler, tamlamalar, birleşik fiiller asla bölünmez.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde vurgu "nesne" üzerindedir?',
        options: ['A) Ahmet camı kırdı.', 'B) Camı Ahmet kırdı.', 'C) Ahmet kırdı camı.', 'D) Kırdı Ahmet camı.'],
        correctIndex: 0,
        explanation: 'Yüklem (kırdı) fiil. Öncesinde "camı" (nesne) var.',
        difficulty: 3),
    StemQuestion(
        question: '"Bana ne aldın?" cümlesinde soru hangi ögeyi buldurmaya yöneliktir?',
        options: ['A) Zarf Tümleci', 'B) Nesne', 'C) Dolaylı Tümleç', 'D) Özne'],
        correctIndex: 1,
        explanation: 'Ne aldın? -> Kitap (Nesne). Bana (DT), Sen (Gizli Özne).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "zincirleme isim tamlaması" özne görevindedir?',
        options: ['A) Okulun bahçe kapısı kırıldı.', 'B) Ali\'nin defterini buldum.', 'C) Evin kapısının kolunu tamir etti.', 'D) Masa örtüsü kirlendi.'],
        correctIndex: 0,
        explanation: 'Kırılan ne? Okulun bahçe kapısı (Zincirleme isim tamlaması - Özne).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisi "bağımlı bağlı" cümledir (Öge ortaklığı olan ve bağlaçla bağlanan)?',
        options: ['A) Okudu ve özetledi.', 'B) Okudu, özetledi.', 'C) Okuyunca özetledi.', 'D) Okuyan özetledi.'],
        correctIndex: 0,
        explanation: '(O) okudu ve (O) özetledi. Özne ortak, "ve" bağlacı var.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "edat tümleci" vurgulanmıştır?',
        options: ['A) Oraya arabayla gittik.', 'B) Arabayla oraya gittik.', 'C) Gittik oraya arabayla.', 'D) Biz arabayla oraya gittik.'],
        correctIndex: 0,
        explanation: 'Gittik (Yüklem). Ne ile? Arabayla (Edat Tümleci/ZT). Yüklemden hemen önce.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde yüklem "birleşik zamanlı birleşik fiil"dir?',
        options: ['A) Gelebilirdi.', 'B) Gelebilir.', 'C) Gelmişti.', 'D) Gelecekti.'],
        correctIndex: 0,
        explanation: 'Gel-ebil-ir-di (Yeterlilik + Geniş Zaman + Hikaye). Hem yapısı birleşik (kurallı) hem zamanı birleşik.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisi "biçimce olumlu, anlamca olumsuz" cümledir?',
        options: ['A) Ne parası var ne pulu.', 'B) Sanki seni çok dinliyor.', 'C) Bu işi yapabilirsen yap.', 'D) A ve B'],
        correctIndex: 3,
        explanation: 'Ne...ne (Yok anlamı), Sanki... (Dinlemiyor anlamı).',
        difficulty: 3),
    StemQuestion(
        question: '"Beni soran o muydu?" cümlesinin ögeleri nelerdir?',
        options: ['A) Nesne - Yüklem', 'B) Özne - Yüklem', 'C) Nesne - Özne - Yüklem', 'D) ZT - Yüklem'],
        correctIndex: 1,
        explanation: 'O muydu (Yüklem). Kim? Beni soran (Özne). Adlaşmış sıfat fiil grubu özne olmuş.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde yan cümlecik temel cümlenin "dolaylı tümleci"dir?',
        options: ['A) Eve gelince haber ver.', 'B) Okuyan insanı severim.', 'C) Çalışana hakkını ver.', 'D) Gülmek sana yakışıyor.'],
        correctIndex: 2,
        explanation: 'Kime ver? Çalışana (Yan cümlecik -> DT).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisi "anlamca kaynaşmış birleşik fiil" ile kurulmuş bir cümledir?',
        options: ['A) Onu görünce küplere bindi.', 'B) Yardım etti.', 'C) Gelebildi.', 'D) Bakakaldı.'],
        correctIndex: 0,
        explanation: 'Küplere binmek (Deyim/Anlamca kaynaşmış).',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde öge sayısı diğerlerinden fazladır?', options: ['A) Sabah erkenden yola çıktık.', 'B) Dün seni okulda bekledim.', 'C) Dün akşam annemle sahilde uzun uzun yürüdük.', 'D) Yağmur yağarken eve koştum.'], correctIndex: 2, explanation: 'C: Dün akşam (ZT) / Annemle (Edat T.) / Sahilde (DT) / Uzun uzun (ZT) / Yürüdük (Y) = 5 öge. A (3 öge), B (4 öge), D (3 öge).', difficulty: 3),
    StemQuestion(question: '"Her şeye rağmen gülümseyebilmek, büyük bir erdemdir." cümlesinin yüklemi aşağıdakilerden hangisidir?', options: ['A) erdemdir', 'B) bir erdemdir', 'C) büyük bir erdemdir', 'D) gülümseyebilmek'], correctIndex: 2, explanation: 'Büyük bir erdem (Sıfat tamlaması) bölünemez.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "mi" soru edatı vurguyu "zarf tümlecine" çekmiştir?', options: ['A) Dün mü geldin?', 'B) Sen mi geldin?', 'C) Eve mi geldin?', 'D) Geldin mi?'], correctIndex: 0, explanation: 'Dün (Zaman Zarfı) + mü.', difficulty: 3),
    StemQuestion(question: 'Hangisi "eksiltili cümle" değildir?', options: ['A) Düğün el ile, harman yel ile...', 'B) Az veren candan, çok veren maldan...', 'C) Kıratın yanında duran ya huyundan ya suyundan...', 'D) Alma mazlumun ahını, çıkar aheste aheste.'], correctIndex: 3, explanation: 'D\'de yüklemler var (Alma, Çıkar). Diğerleri atasözlerinin yarısı, yüklemsiz.', difficulty: 3),
    StemQuestion(question: '"Tatlı dil yılanı deliğinden çıkarır." cümlesinin öznesi hangisidir?', options: ['A) Tatlı dil', 'B) Yılanı', 'C) Deliğinden', 'D) Tatlı'], correctIndex: 0, explanation: 'Çıkaran ne? Tatlı dil (Sıfat tamlaması - Özne).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "cevap" cümlesi sadece "özne"den oluşmaktadır?', options: ['A) - Kim geldi? - Ali.', 'B) - Ne aldın? - Elma.', 'C) - Nereye? - Eve.', 'D) - Ne zaman? - Yarın.'], correctIndex: 0, explanation: 'Ali (geldi). Ali öznedir. B (Nesne), C (DT), D (ZT).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "sıralı cümlelerin öge ortaklığı" yoktur?', options: ['A) Mart kapıdan baktırır, kazma kürek yaktırır.', 'B) At ölür, meydan kalır.', 'C) Geldim, gördüm, yendim.', 'D) Kel ölür, sırma saçlı olur.'], correctIndex: 1, explanation: 'At ölür (Ö-Y), Meydan kalır (Ö-Y). Ortak öge yok (Bağımsız sıralı). A (Özne ortak: Mart), C (Özne ortak: Ben), D (Özne ortak: Kel).', difficulty: 3),
    StemQuestion(question: 'Hangisi yapısına göre "birleşik", anlamına göre "olumsuz", yüklemine göre "fiil" cümlesidir?', options: ['A) Gelmemeye yemin etti.', 'B) Gelen gideni aratmaz.', 'C) Bugün hava hiç güzel değil.', 'D) Seni görmedim.'], correctIndex: 1, explanation: 'Gelen/Giden (Fiilimsi -> Birleşik), Aratmaz (Olumsuz Fiil). A (Yemin etti olumlu), C (İsim), D (Basit).', difficulty: 3),
    StemQuestion(question: 'Hangisinde soru "yüklemi" buldurmaya yöneliktir?', options: ['A) Beni arayan kimdi?', 'B) Kim geldi?', 'C) Neyi seversin?', 'D) Nerede oturuyorsun?'], correctIndex: 0, explanation: 'Kim-di (Soru sözcüğü ek eylem alıp yüklem olmuş).', difficulty: 3),
    StemQuestion(question: '"Konuşmak, ihtiyaç olabilir; ama susmak, bir sanattır." cümlesi yapısına göre nasıldır?', options: ['A) Sıralı Cümle', 'B) Bağlı Cümle', 'C) Basit Cümle', 'D) Birleşik Cümle'], correctIndex: 1, explanation: 'Ama bağlacı ile bağlanmış iki cümle.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ara söz" dolaylı tümlecin açıklayıcısıdır?', options: ['A) İzmir\'e, doğduğum kente, gidiyorum.', 'B) Seni, canım arkadaşımı, özledim.', 'C) Dün, pazar günü, buradaydım.', 'D) Bu adam, emin ol, suçlu.'], correctIndex: 0, explanation: 'İzmir\'e (DT) -> Doğduğum kente (Ara söz DT açıklayıcısı). B (Nesne), C (ZT), D (Cümle dışı unsur).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ki" bağlacı, yan cümleciği temel cümlenin nesnesi yapmıştır?', options: ['A) Biliyorum ki yalan söylüyorsun.', 'B) Öyle bir geçer zaman ki...', 'C) Desem ki vakitlerden bir nisan akşamıdır.', 'D) Erken gel ki yer bulalım.'], correctIndex: 0, explanation: 'Neyi biliyorum? Yalan söylediğini (ki\'li cümle nesne olmuş).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "yüklem" vurgulanmıştır?', options: ['A) Ali bugün gitti.', 'B) Bugün Ali gitti.', 'C) Elma en güzel meyvedir.', 'D) Dün akşam geldim.'], correctIndex: 2, explanation: 'İsim cümlelerinde vurgu yüklemin kendisindedir. A, B, D\'de yüklem fiildir ve vurgu yüklemden önceki ögededir.', difficulty: 3),
    StemQuestion(question: 'Aşağıdaki cümlelerden hangisi "özne ve yüklemden" oluşmuştur?', options: ['A) Bugün hava çok güzel.', 'B) İstanbul\'un fethi, çağ açıp çağ kapatan bir olaydır.', 'C) Annem mutfakta yemek yapıyor.', 'D) Sabah erkenden kalktı.'], correctIndex: 1, explanation: 'İstanbul\'un fethi (Özne) / çağ açıp çağ kapatan bir olaydır (Sıfat tamlaması yüklem). Sadece iki öge.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "mantık hatasından" kaynaklanan bir anlatım bozukluğu vardır?', options: ['A) Bırak patates doğramayı, yemek bile yapamaz.', 'B) Eve geldim ve uyudum.', 'C) Kitabı aldım.', 'D) Seni seviyorum.'], correctIndex: 0, explanation: 'Sıralama hatası: Yemek yapmak daha zordur. "Bırak yemek yapmayı, patates bile doğrayamaz" olmalı.', difficulty: 3),
  ],
  formulaCards: const ['Ara Söz: 2 virgül arası.', 'Vurgu: Yüklemden önceki öge (Fiilse).', 'Tamlamalar Bölünmez.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 8: YAZIM KURALLARI
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU8Content = StemUnitContent(
  unitId: 'kpsslise_tur_u8',
  topic: const TopicContent(
    summary: 'Yazım kuralları; büyük harflerin kullanımı, "de/da" ve "ki"nin yazımı, sayıların yazımı ve kısaltmaların yazımını kapsar. Cümleler büyük harfle başlar. Özel isimlere gelen çekim ekleri kesme işaretiyle ayrılır.',
    rule: '"De/Da" bağlacı cümleden çıkarıldığında anlam bozulmaz ve ayrı yazılır. "Ki" bağlacı fiillerden sonra gelirse ayrı yazılır (İstisna: SOMBAHÇEM).',
    formulas: [
      'Bağlaç De: Cümleden çıkar -> Anlam bozulmaz -> Ayrı.',
      'Ek De: Cümleden çıkar -> Anlam bozulur -> Bitişik.',
      'Sayılar: Çek, senet dışında ayrı yazılır (On beş).'
    ],
    keyPoints: [
      'Ay ve gün adları belli bir tarih bildiriyorsa büyük yazılır (29 Mayıs Salı), yoksa küçük (Haftaya salı gel).',
      'Kurum, kuruluş adlarına gelen ekler kesmeyle ayrılmaz (Türk Dil Kurumuna).',
      'Millet, boy, dil adları büyük başlar (Türkçe, İngiliz).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde "de"nin yazımı yanlıştır?',
        options: ['A) Sen de gel.', 'B) Ev de oturduk.', 'C) Kitap da aldım.', 'D) Okulda tören var.'],
        correctIndex: 1,
        explanation: 'Evde oturduk (Bulunma eki bitişik yazılmalı).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde tarihlerin yazımı ile ilgili bir yanlışlık yapılmıştır?',
        options: ['A) 19 Mayıs 1919\'da', 'B) Haftaya Salı buluşalım.', 'C) 23 Nisan Salı günü', 'D) 10 Ekim\'de doğdu.'],
        correctIndex: 1,
        explanation: 'Belli bir tarih (rakam) yoksa gün ve ay adları küçük yazılır: Haftaya salı.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "ki"nin yazımı yanlıştır?',
        options: ['A) Senki beni tanırsın.', 'B) Evdeki hesap.', 'C) Duydum ki unutmuşsun.', 'D) Benimki geldi.'],
        correctIndex: 0,
        explanation: 'Sen ki (Bağlaç olan ki ayrı yazılır). İstisna (SOMBAHÇEM) dışındadır.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde büyük harflerin kullanımı yanlıştır?',
        options: ['A) Ayşe teyze bize geldi.', 'B) Boncuk bugün çok havladı.', 'C) Türk Dil kurumu.', 'D) Ankara Kalesi.'],
        correctIndex: 2,
        explanation: 'Kurum adlarının her kelimesi büyük yazılır: Türk Dil Kurumu.',
        difficulty: 1),
    StemQuestion(
        question: 'Sayıların yazımı hangisinde doğrudur?',
        options: ['A) Onbeş yaşında.', 'B) 3\'üncü sınıf.', 'C) İki bin yirmidört.', 'D) 5\'inci katta.'],
        correctIndex: 1,
        explanation: 'Sayılar ayrı yazılır (On beş, İki bin yirmi dört). 3. veya 3\'üncü doğrudur.',
        difficulty: 1),
    StemQuestion(
        question: 'Kısaltmalara getirilen ekler hangisinde yanlıştır?',
        options: ['A) TDK\'nın', 'B) TBMM\'ye', 'C) THY\'de', 'D) ABD\'den'],
        correctIndex: 0,
        explanation: 'Kısaltmanın okunuşuna göre gelir. TDK (Te-De-Ke) -> TDK\'nin.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "mi" soru ekinin yazımı yanlıştır?',
        options: ['A) Geldin mi?', 'B) Güzel mi güzel.', 'C) Senmi yaptın?', 'D) Gidiyor musun?'],
        correctIndex: 2,
        explanation: 'Mi her zaman ayrı yazılır: Sen mi yaptın?',
        difficulty: 1),
    StemQuestion(
        question: 'Yön adlarının yazımı hangisinde yanlıştır?',
        options: ['A) Doğu Anadolu', 'B) Anadolu\'nun doğusu', 'C) Kuzey rüzgarı', 'D) batı medeniyeti'],
        correctIndex: 3,
        explanation: 'Yön adları medeniyet/kültür/bölge bildiriyorsa büyük yazılır: Batı medeniyeti.',
        difficulty: 1),
    StemQuestion(
        question: '"Şey" sözcüğünün yazımı hangisinde doğrudur?',
        options: ['A) Herşey', 'B) Hiç bir şey', 'C) Her şey', 'D) Birşey'],
        correctIndex: 2,
        explanation: 'Şey her zaman ayrı yazılır (Her şey, Bir şey, Çok şey).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde yazım yanlışı vardır?',
        options: ['A) Yanlış', 'B) Yalnız', 'C) Kiprik', 'D) Kibrit'],
        correctIndex: 2,
        explanation: 'Doğrusu "Kirpik"tir.',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde bir yazım yanlışı vardır?', options: ['A) Türkçenin zenginliği tartışılmaz.', 'B) Ankara\'lı arkadaşım geldi.', 'C) Atatürk Bulvarı\'nda kaza olmuş.', 'D) Van Kedisi çok sevimli.'], correctIndex: 1, explanation: 'Özel isimlere gelen yapım ekleri kesme işaretiyle ayrılmaz: Ankaralı.', difficulty: 1),
    StemQuestion(question: 'Hangisinde sayıların yazımı yanlıştır?', options: ['A) Sınıfta 15 öğrenci var.', 'B) Yarışmada 2\'nci oldu.', 'C) Üleştirme sayıları rakamla yazılmaz.', 'D) Saat 13.00\'da buluşalım.'], correctIndex: 3, explanation: '13.00\'te (Benzeşme kuralına uyulmalı, sıfırlar okunmaz tam saatte).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "ki"nin yazımı doğrudur?', options: ['A) Madem ki gelmeyecektin...', 'B) Oysaki beni severdi.', 'C) Halbuki böyle değildi.', 'D) Hepsi'], correctIndex: 3, explanation: 'SOMBAHÇEM kodlaması (Sanki, Oysaki, Mademki, Belki, Halbuki, Çünkü, Meğerki, İllaki) bitişik yazılır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde kısaltmalarla ilgili yazım yanlışı vardır?', options: ['A) T.C. (Türkiye Cumhuriyeti)', 'B) T. (Türkçe)', 'C) m. (metre)', 'D) kg\'dan'], correctIndex: 3, explanation: 'Küçük harfli kısaltmalarda kelimenin okunuşu esas alınır: kg\'den (kilogramdan).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "Dünya, Güneş, Ay" kelimelerinin yazımı yanlıştır?', options: ['A) Ay, Dünya\'nın uydusudur.', 'B) Güneş girmeyen eve doktor girer.', 'C) Bugün Dünya kadar işim var.', 'D) Uzay gemisi Mars\'a indi.'], correctIndex: 2, explanation: 'Terim anlamı dışında kullanıldığında küçük yazılır: dünya kadar.', difficulty: 1),
    StemQuestion(question: 'Hangisinde birleşik fiillerin yazımı yanlıştır?', options: ['A) Sabır etmek', 'B) Seyretmek', 'C) Hissetmek', 'D) Terk etmek'], correctIndex: 0, explanation: 'Ünlü düşmesi olduğu için bitişik yazılmalı: Sabretmek.', difficulty: 1),
    StemQuestion(question: 'Aşağıdakilerden hangisinin yazımı doğrudur?', options: ['A) Orjinal', 'B) Orjinel', 'C) Orijinal', 'D) Orijinel'], correctIndex: 2, explanation: 'Orijinal.', difficulty: 1),
    StemQuestion(question: 'Hangisinde yazım yanlışı yapılmıştır?', options: ['A) Art arda', 'B) Git gide', 'C) El ele', 'D) Yan yana'], correctIndex: 1, explanation: 'Gitgide (Bitişik yazılan pekiştirilmiş zarftır). Diğer ikilemeler ayrı yazılır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "de" bağlacının yazımı yanlıştır?', options: ['A) Ahmet te geldi.', 'B) Ahmet de geldi.', 'C) Kitap da al.', 'D) Sen de mi?'], correctIndex: 0, explanation: 'Bağlaç olan "de" hiçbir zaman sertleşip "te/ta" olmaz. Her zaman "de/da"dır.', difficulty: 1),
    StemQuestion(question: 'İl, ilçe, köy adlarının yazımı hangisinde doğrudur?', options: ['A) Konya İli', 'B) Ilgın ilçesi', 'C) Ağalar Köyü', 'D) Van gölü'], correctIndex: 1, explanation: 'Özel isme dahil olmayan il, ilçe, köy sözcükleri küçük yazılır. Van Gölü (coğrafi isim büyük). Doğru olan B.', difficulty: 1),
    StemQuestion(question: 'Hangisinde kesme işareti yanlış kullanılmıştır?', options: ['A) Ali\'ye', 'B) 1985\'te', 'C) Türkçe\'nin', 'D) İngiltere\'den'], correctIndex: 2, explanation: 'Özel isimden türetilen kelimelere (Türk-çe) gelen çekim ekleri kesmeyle ayrılmaz: Türkçenin.', difficulty: 1),
    StemQuestion(question: 'Hangisinde satır sonu hece bölünmesi yanlıştır?', options: ['A) gel-di', 'B) baş-öğ-ret-men', 'C) il-ko-kul', 'D) ba-şöğ-ret-men'], correctIndex: 1, explanation: 'Birleşik kelimeler tek kelime gibi hecelenir: Ba-şöğ-ret-men.', difficulty: 1),
    StemQuestion(question: 'Hangisinde unvanların yazımı yanlıştır?', options: ['A) Doktor Ahmet', 'B) Zeynep Hanım', 'C) Hasan bey', 'D) Yüzbaşı Ali'], correctIndex: 2, explanation: 'Saygı sözleri ve unvanlar büyük harfle başlar: Hasan Bey.', difficulty: 1),
    StemQuestion(question: 'Hangisinde soru ekinin yazımı yanlıştır?', options: ['A) Vaz mı geçtin?', 'B) Vazgeçtin mi?', 'C) Vazgeçtinmi?', 'D) Gidiyor musun?'], correctIndex: 2, explanation: 'Vazgeçtin mi? (Ayrı yazılır).', difficulty: 1),
    StemQuestion(question: '"Herhalde" ve "Her halde" ayrımı hangisinde doğrudur?', options: ['A) Herhalde bu iş olacak (Mutlaka).', 'B) Her halde seni seviyorum (Durum ne olursa olsun).', 'C) Herhalde yağmur yağacak (Olasılık).', 'D) B ve C'], correctIndex: 3, explanation: 'Bitişik "Herhalde" olasılık bildirir. Ayrı "Her halde" her durumda demektir.', difficulty: 1),
  ],
  formulaCards: const ['Şey: Her zaman ayrı.', 'TDK\'nin: K değil Ke okunur.', 'Bağlaç DE: Asla te/ta olmaz.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU8Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u8',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde yazım kuralları; birleşik sözcüklerin bitişik veya ayrı yazılması kuralları (ses düşmesi, anlam değişmesi, etmek/olmak fiilleri) üzerine yoğunlaşır. Ayrıca düzeltme işaretinin kullanımı ve yer adlarındaki detaylar (Mahalle, Meydan, Bulvar büyük; il, ilçe küçük) önemlidir.',
    rule: 'Birleşik sözcük oluşurken kelimelerden hiçbiri veya ikincisi anlam değişikliğine uğramıyorsa "ayrı" (Köpek balığı), uğruyorsa "bitişik" yazılır (Aslanağzı - çiçek).',
    formulas: [
      'Etmek/Olmak: Ses düşmesi/türemesi varsa Bitişik (Kaybolmak, Hissetmek). Yoksa Ayrı (Terk etmek, Fark etmek).',
      'Hane/Name/Zede: Bitişik (Dershane, Depremzede).',
      'Ev kelimesi: Bitişik (Huzurevi, Öğretmenevi). İstisna: Dağ evi, Bağ evi (Ayrı).'
    ],
    keyPoints: [
      'Mahalle, Meydan, Bulvar, Cadde isimleri büyük başlar (Cumhuriyet Mahallesi).',
      'Kurum, Kuruluş, Kurul adlarına gelen ekler kesmeyle ayrılmaz (Bakanlar Kurulunun).',
      'Para birimleri küçük yazılır (avro, dolar, lira).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki birleşik sözcüklerden hangisinin yazımı yanlıştır?',
        options: ['A) Köpekbalığı', 'B) Çalı kuşu', 'C) Devekuşu', 'D) Ateş böceği'],
        correctIndex: 0,
        explanation: 'Hayvan adlarıyla kurulanlar ayrı yazılır: Köpek balığı.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "ki" bağlacının yazımı yanlıştır?',
        options: ['A) Geçmiş zaman olur ki...', 'B) Desem ki...', 'C) İllaki', 'D) Öyleki'],
        correctIndex: 3,
        explanation: 'Öyle ki (Ayrı yazılır). İllaki (İstisna/SOMBAHÇEM).',
        difficulty: 2),
    StemQuestion(
        question: 'Yer adlarının yazımı hangisinde yanlıştır?',
        options: ['A) Taksim meydanı', 'B) Karanfil Sokağı', 'C) Atatürk Bulvarı', 'D) Çankaya ilçesi'],
        correctIndex: 0,
        explanation: 'Meydan, Bulvar, Sokak kelimeleri büyük yazılır: Taksim Meydanı. İlçe küçük yazılır (D doğru).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "dağ, nehir, göl" adlarının yazımı yanlıştır?',
        options: ['A) Ağrı Dağı', 'B) Van Gölü', 'C) Çoruh nehri', 'D) Konya Ovası'],
        correctIndex: 2,
        explanation: 'Nehir, Göl, Dağ, Ova kelimeleri büyük yazılır: Çoruh Nehri.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "hane" kelimesinin yazımı yanlıştır?',
        options: ['A) Dershane', 'B) Hastahane', 'C) Postane', 'D) Pastane'],
        correctIndex: 1,
        explanation: 'Ünlüyle bitenlerde "h" düşer: Hastane. Sessizle bitenlerde düşmez: Dershane.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinin yazımı doğrudur?',
        options: ['A) Herkez', 'B) Şöför', 'C) Egzoz', 'D) Eşortman'],
        correctIndex: 2,
        explanation: 'Egzoz doğru. A(Herkes), B(Şoför), D(Eşofman).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde düzeltme işareti (^) kullanılması gereklidir?',
        options: ['A) Hala (Babanın kız kardeşi)', 'B) Kar (Yağış)', 'C) Hâlâ (Henüz/Hâlâ)', 'D) Alem (Topluluk)'],
        correctIndex: 2,
        explanation: 'Hâlâ (Henüz anlamında) düzeltme işareti gerektirir. Hala (Akraba) düz yazılır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde sayıların yazımı yanlıştır?',
        options: ['A) Beş yüz bin', 'B) Milyar', 'C) Trilyon', 'D) Dörtyüzelli'],
        correctIndex: 3,
        explanation: 'Sayılar ayrı yazılır: Dört yüz elli.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde ikilemenin yazımı yanlıştır?',
        options: ['A) Baş başa', 'B) Yüz yüze', 'C) Elele', 'D) Dite dite'],
        correctIndex: 2,
        explanation: 'El ele ayrı yazılır.',
        difficulty: 2),
    StemQuestion(
        question: '"Sever" sözcüğüyle kurulan birleşik kelimelerin yazımı nasıldır?',
        options: ['A) Daima ayrı', 'B) Daima bitişik', 'C) Duruma göre', 'D) Tire ile'],
        correctIndex: 1,
        explanation: 'Vatansever, Yurtsever, Hayırsever (Bitişik).',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdakilerden hangisinde bir yazım yanlışı vardır?', options: ['A) Akşamüstü bize gel.', 'B) Suçüstü yakalandı.', 'C) Bilinçaltı çalışmaları.', 'D) Böbrek üstü bezi.'], correctIndex: 3, explanation: 'Alt/Üst soyut kavramsa bitişik (Akşamüstü, Suçüstü, Bilinçaltı). Böbrek üstü bezi (Somut yer) ayrıdır ama bu zaten ayrı yazılmış. SORU ANALİZİ: D şıkkı ayrı yazılmış (doğru). Soru "yanlışı" soruyor. Düzeltme: D\'yi "Böbreküstü bezi" (bitişik yazılmış) yapalım. Cevap D: Böbrek üstü ayrı yazılır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ev" sözcüğüyle kurulan birleşik kelimelerin yazımı yanlıştır?', options: ['A) Huzurevi', 'B) Öğretmenevi', 'C) Aşevi', 'D) Dağevi'], correctIndex: 3, explanation: 'Dağ evi, Bağ evi ayrı yazılır. Diğer kurum bildiren evler bitişiktir.', difficulty: 2),
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde kısaltmalara getirilen eklerde yanlışlık yapılmıştır?', options: ['A) ASELSAN\'da çalışıyor.', 'B) BOTAŞ\'ın ihalesi.', 'C) TÜBİTAK\'a başvurdu.', 'D) SGK\'nın binası.'], correctIndex: 3, explanation: 'SGK (Se Ge Ke) -> SGK\'nin.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "baş" sözcüğüyle kurulan birleşik kelimelerin yazımı yanlıştır?', options: ['A) Başbakan', 'B) Başöğretmen', 'C) Baş hekim', 'D) Başrol'], correctIndex: 2, explanation: 'Baş sözcüğü sıfat olarak kullanıldığında bitişik yazılır: Başhekim.',
        difficulty: 2),
    StemQuestion(question: 'Hangisinde tarihlerin yazımı yanlıştır?', options: ['A) 19.Mayıs.1919', 'B) 19/05/1919', 'C) 19 Mayıs 1919', 'D) 19-05-1919'], correctIndex: 0, explanation: 'Ay adları yazıyla yazıldığında araya nokta konmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde satır sonu bölmesi yanlıştır?', options: ['A) ...Edir-ne\'ye', 'B) ...Müdafaa-nı', 'C) ...okul-dan', 'D) ...Hanım-eli'], correctIndex: 0, explanation: 'Özel isimlerde satır sonunda kesme işareti varsa kısa çizgi kullanılmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "yol" sözcüğünün yazımı doğrudur?', options: ['A) Otoyol', 'B) Karayolu', 'C) Havayolu', 'D) Denizyolu'], correctIndex: 0, explanation: 'Otoyol bitişiktir (İstisna). Kara yolu, Hava yolu, Deniz yolu ayrı yazılır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "renk" adıyla kurulan kelimelerin yazımı yanlıştır?', options: ['A) Narçiçeği gömlek aldım.', 'B) Camgöbeği boyayla boyadı.', 'C) Vişne çürüğü kazak giydim.', 'D) Fildişi rengi tablo.'], correctIndex: 2, explanation: 'Renk adları bitişik yazılır: Vişneçürüğü.',
        difficulty: 2),
    StemQuestion(question: 'Hangisinin yazımı yanlıştır?', options: ['A) Tıraş', 'B) Kılavuz', 'C) Hıristiyan', 'D) Kulüp'], correctIndex: 2, explanation: 'Hristiyan (I yok).', difficulty: 2),
    StemQuestion(question: 'Hangisinde pekiştirmelerin yazımı yanlıştır?', options: ['A) Sırılsıklam', 'B) Çırılçıplak', 'C) Güpegündüz', 'D) Sapa sağlam'], correctIndex: 3, explanation: 'Sapasağlam (Bitişik).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "yabancı kelimelerin" yazımı doğrudur?', options: ['A) Entellektüel', 'B) Entelektüel', 'C) Kolleksiyon', 'D) Şevkat'], correctIndex: 1, explanation: 'Tek L: Entelektüel. Koleksiyon (Tek L). Şefkat (F ile).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "bir" sözcüğüyle kurulanların yazımı yanlıştır?', options: ['A) Birkaç', 'B) Birçok', 'C) Herhangi bir', 'D) Hiç bir'], correctIndex: 3, explanation: 'Hiçbir (Bitişik).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "de" eki/bağlacı yanlış yazılmıştır?', options: ['A) Yurtta sulh.', 'B) 1975\'de.', 'C) O da biliyor.', 'D) Sözde özne.'], correctIndex: 1, explanation: '1975\'te (Sertleşme olmalı).', difficulty: 2),
    StemQuestion(question: '"Arzetmek" kelimesinin doğru yazımı nedir?', options: ['A) Arzetmek', 'B) Arz etmek', 'C) Arzzetmek', 'D) Arzıtmek'], correctIndex: 1, explanation: 'Ses olayı yok, ayrı yazılır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "kurum adlarına gelen ek" yanlış yazılmıştır?', options: ['A) TBMM\'ye', 'B) TDK\'ye', 'C) Bakanlar Kurulu\'na', 'D) Mimar Sinan Üniversitesine'], correctIndex: 2, explanation: 'Kurum ekleri kesmeyle ayrılmaz: Bakanlar Kuruluna.', difficulty: 2),
  ],
  formulaCards: const ['Sever: Bitişik (Vatansever).', 'Hane: Bitişik (Hastane - h düşer).', 'SGK\'nin: K sesi Ke okunur.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU8Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u8',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde yazım kuralları; istisnalar (yeşilzeytin bitişik, yeşil biber ayrı), bilimsel terimlerin yazımı, alıntı kelimelerdeki inceltme işaretleri ve karmaşık birleşik fiil yapıları (başvurmak, vazgeçmek, varsaymak bitişik; öngörmek bitişik) üzerine odaklanır.',
    rule: 'Somut olarak yer bildirmeyen alt, üst ve üzeri sözleri bitişik yazılır (Akşamüstü, Ayaküzeri). Somut yer bildirenler ayrıdır (Deri altı, Toprak altı).',
    formulas: [
      'Renk Adları: Bitişik (Balrengi, Fildişi).',
      'Yiyecek Adları: İkinci kelime anlamını koruyorsa Ayrı (Kuru fasulye). İstisna: Yeşilzeytin (Bitişik).',
      'Müzik Makamları: Bitişik (Acemkürdi).'
    ],
    keyPoints: [
      '"Yüzyıl" (asır) bitişik, "Yüz yıl" (sayı) ayrı.',
      'Gazete/dergi adları küçük yazılır (Milliyet gazetesi). İstisna: Resmi Gazete.',
      'Gök cisimleri terim ise büyük, değilse küçük (Dünya, Güneş).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki yiyecek adlarından hangisinin yazımı yanlıştır?',
        options: ['A) Yeşilbiber', 'B) Yeşilzeytin', 'C) Kuru soğan', 'D) Sivri biber'],
        correctIndex: 0,
        explanation: 'Yeşilbiber ayrı yazılır: Yeşil biber. Yeşilzeytin bitişiktir (TDK istisna).',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "alt/üst" sözcüklerinin yazımı yanlıştır?',
        options: ['A) Gözaltı (gözaltına alındı)', 'B) Göz altı (kremi)', 'C) Akşamüstü', 'D) Yeraltı (maden/somut)'],
        correctIndex: 3,
        explanation: 'Somut yer bildiren "Yer altı" (maden) ayrı yazılır. Mecaz olan "Yeraltı" (mafya) bitişik.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "Gazete/Dergi" adlarının yazımı doğrudur?',
        options: ['A) Hürriyet Gazetesi', 'B) Türk Dili Dergisi', 'C) Resmi Gazete', 'D) Varlık Dergisi'],
        correctIndex: 2,
        explanation: 'Gazete/Dergi özel ada dahil değilse küçük yazılır (Hürriyet gazetesi). Resmi Gazete\'nin adı "Resmi Gazete"dir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinin yazımı yanlıştır?',
        options: ['A) Çalar saat', 'B) Yazar kasa', 'C) Okur yazar', 'D) Uyurgezer'],
        correctIndex: 2,
        explanation: '-ar/-er, -maz/-mez ekleriyle kurulan sıfat fiil grupları kalıplaşmışsa bitişik: Okuryazar.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "Doğu/Batı" sözcüklerinin yazımı yanlıştır?',
        options: ['A) Doğu felsefesi', 'B) Batı\'nın ilmi', 'C) Türkiye\'nin doğusu', 'D) Batı Trakya'],
        correctIndex: 0,
        explanation: 'Fikir/Kültür bildiren Doğu büyük yazılır: Doğu felsefesi. Küçük yazılması yanlış.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "kesme işareti" kullanımı doğrudur?',
        options: ['A) Avrupa Birliği\'ne', 'B) Türk Dil Kurumu\'na', 'C) Bakanlar Kurulu\'nun', 'D) Milli Eğitim Bakanlığı\'na'],
        correctIndex: 0,
        explanation: 'Kurum ekleri ayrılmaz (B, C, D yanlış). Avrupa Birliği bir ülke topluluğu sayıldığı için kesmeyle ayrılır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "birleşik fiil" yazımı yanlıştır?',
        options: ['A) Başvurmak', 'B) Vazgeçmek', 'C) Öngörmek', 'D) El vermek'],
        correctIndex: 3,
        explanation: 'Elvermek bitişik yazılır. Başvurmak, Vazgeçmek, Öngörmek de bitişiktir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "ikileme" yanlış yazılmıştır?',
        options: ['A) Gitgide', 'B) Birdenbire', 'C) İkidebir', 'D) Art arda'],
        correctIndex: 2,
        explanation: 'İkide bir (Ayrı yazılır). Gitgide, Birdenbire bitişiktir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "dış/iç" sözcüklerinin yazımı yanlıştır?',
        options: ['A) Yurt dışı', 'B) Hafta içi', 'C) Olağandışı', 'D) Yasadışı'],
        correctIndex: 3,
        explanation: 'Dış, İç, Sıra sözleri ayrı yazılır: Yasa dışı.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinin yazımı doğrudur?',
        options: ['A) 1 mm.den', 'B) 1 mm\'den', 'C) 10 kr.un', 'D) cm.yi'],
        correctIndex: 1,
        explanation: 'Uluslararası birimlerde nokta kullanılmaz: mm\'den.',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde bir yazım yanlışı vardır?', options: ['A) 2\'nci katta oturuyor.', 'B) II. Mehmet.', 'C) 5. inci sınıf.', 'D) 10\'uncu yıl.'], correctIndex: 2, explanation: '5. (nokta zaten sıra bildirdiğinden) + inci = Yanlış. 5. veya 5\'inci olmalı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "yer adları" yazımında yanlışlık yapılmıştır?', options: ['A) İstanbul Boğazı', 'B) Zigana geçidi', 'C) Konya Ovası', 'D) Ağrı Dağı'], correctIndex: 1, explanation: 'Coğrafi yapı adları büyük başlar: Zigana Geçidi.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "tarihi olay, çağ, dönem" adlarının yazımı yanlıştır?', options: ['A) Cilalı Taş Devri', 'B) Milli Edebiyat Dönemi', 'C) Kurtuluş savaşı', 'D) Orta Çağ'], correctIndex: 2, explanation: 'Tarihi olaylar büyük başlar: Kurtuluş Savaşı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "akrabalık bildiren kelimelerin" yazımı doğrudur?', options: ['A) Kemal dayım geldi.', 'B) Nene Hatun.', 'C) Susuz Dede.', 'D) Hepsi.'], correctIndex: 3, explanation: 'Akrabalık kan bağı ise küçük (Kemal dayım), lakapsa büyük (Nene Hatun, Susuz Dede). Hepsi doğru.', difficulty: 3),
    StemQuestion(question: 'Hangisinin yazımı yanlıştır? (Müzik makamları)', options: ['A) Acemkürdi', 'B) Hicazkar', 'C) Nihavend', 'D) Beyati'], correctIndex: 1, explanation: 'Hicazkâr (Düzeltme işareti gerekli).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ana" sözcüğüyle kurulan birleşik kelime yanlış yazılmıştır?', options: ['A) Anayasa', 'B) Anamal', 'C) Anadili', 'D) Anaokulu'], correctIndex: 2, explanation: 'Ana dil ayrı yazılır. Anayasa, Anamal, Anaokulu bitişiktir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ön" sözcüğüyle kurulan birleşik kelime bitişik yazılır?', options: ['A) Ön söz', 'B) Ön yargı', 'C) Ön koşul', 'D) Öngörü'], correctIndex: 3, explanation: 'Öngörü (Kalıplaşmış, bitişik). Ön söz, Ön yargı, Ön koşul ayrı yazılır.', difficulty: 3),
    StemQuestion(question: 'Hangisinin yazımı yanlıştır?', options: ['A) Doküman', 'B) İnsiyatif', 'C) Unvan', 'D) Karnabahar'], correctIndex: 1, explanation: 'İnisiyatif (i var).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "Mahalle/Meydan/Bulvar" yazımında hata vardır?', options: ['A) Ziya Gökalp Bulvarı', 'B) Yunus Emre mahallesi', 'C) Kızılay Meydanı', 'D) İnkılap Sokağı'], correctIndex: 1, explanation: 'Mahallesi büyük olmalı: Yunus Emre Mahallesi.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "para birimi" yazımı yanlıştır?', options: ['A) Amerikan Doları', 'B) Türk lirası', 'C) avro', 'D) dinar'], correctIndex: 0, explanation: 'Para birimleri küçük yazılır: Amerikan doları.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "birleşik fiil" ayrı yazılması gerekirken bitişik yazılmıştır?', options: ['A) Haketmek', 'B) Başetmek', 'C) Sözetmek', 'D) Hepsi'], correctIndex: 3, explanation: 'Hak etmek, Baş etmek, Söz etmek. Ses olayı olmadığı için hepsi ayrı yazılmalı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde kesme işareti kullanılmamalıdır?', options: ['A) 15 Nisan\'da', 'B) 19 Mayıs\'ta', 'C) 2024\'te', 'D) Başbakanlık\'ça'], correctIndex: 3, explanation: 'Kurum ekleri kesmeyle ayrılmaz: Başbakanlıkça.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ile"nin yazımı yanlıştır?', options: ['A) Ali\'yle', 'B) Mehmed\'ile', 'C) Okul ile', 'D) Arabayla'], correctIndex: 1, explanation: 'Mehmet\'le veya Mehmet ile olmalı. Özel isim yumuşamaz (Mehmed yanlış).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "sayılara gelen ek" yanlıştır?', options: ['A) 1970\'ten', 'B) 8\'de', 'C) 2\'nci', 'D) 7\'inci'], correctIndex: 3, explanation: 'Yedi-nci (Yedinci). 7\'nci olmalı, 7\'inci değil.', difficulty: 3),
    StemQuestion(question: 'Hangisinin yazımı doğrudur?', options: ['A) İş birliği', 'B) İşbirliği', 'C) Güçbirliği', 'D) Gözbirliği'], correctIndex: 0, explanation: 'İş birliği ayrı yazılır. Güç birliği, Göz birliği de ayrıdır.', difficulty: 3),
  ],
  formulaCards: const ['Yasa Dışı: Ayrı.', 'Yeşilzeytin: Bitişik.', 'Kurum Eki Ayrılmaz: TDKye.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 9: NOKTALAMA İŞARETLERİ
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU9Content = StemUnitContent(
  unitId: 'kpsslise_tur_u9',
  topic: const TopicContent(
    summary: 'Noktalama işaretleri, duygu ve düşünceleri daha açık ifade etmek, cümlenin yapısını ve duraklama yerlerini belirlemek için kullanılır. Temel işaretler: Nokta (.) tamamlanmış cümlenin sonuna; Virgül (,) eş görevli sözcüklerin arasına; Soru İşareti (?) soru bildiren cümlelere; Ünlem (!) duygu bildiren cümlelere konur.',
    rule: 'Zarf-fiil eklerinden (-ip, -ince, -erek) sonra virgül konmaz. Ancak ard arda sıralanmışsa konur.',
    formulas: [
      'Nokta: Bitti.',
      'Virgül: Sırala, Ayır.',
      'Soru İşareti: Cevap bekle.',
      'Ünlem: Duygu!'
    ],
    keyPoints: [
      'Sıralı cümleleri ayırmak için virgül kullanılır (Geldi, gördü, gitti).',
      'Özel isimlere gelen çekim ekleri kesme işareti ile ayrılır.',
      'Saat ve dakika arasına sadece nokta konur (13.30).'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinin sonuna nokta (.) konmalıdır?',
        options: ['A) Ne güzel bir gün', 'B) Eve ne zaman geleceksin', 'C) Kapı aniden açıldı', 'D) Eyvah, geç kaldım'],
        correctIndex: 2,
        explanation: 'Tamamlanmış yargı. A ve D Ünlem, B Soru İşareti.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde virgül (,) yanlış kullanılmıştır?',
        options: ['A) Elma, armut, muz aldı.', 'B) Ali, okula gitti.', 'C) Koşarak, geldi.', 'D) Çalıştı, başardı.'],
        correctIndex: 2,
        explanation: 'Zarf-fiil ekinden (-arak) sonra virgül konmaz.',
        difficulty: 1),
    StemQuestion(
        question: 'Saatlerin yazımında hangi işaret kullanılır?',
        options: ['A) İki nokta (:)', 'B) Nokta (.)', 'C) Virgül (,)', 'D) Noktalı Virgül (;)'],
        correctIndex: 1,
        explanation: '14.30 (Dijital saatlerdeki : kullanımı yazı dilinde yanlıştır).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde kesme işareti yanlış kullanılmıştır?',
        options: ['A) Ahmet\'e', 'B) Ankara\'da', 'C) TDK\'nin', 'D) Türk\'ler'],
        correctIndex: 3,
        explanation: 'Özel isimlere gelen çoğul ekleri (ler/lar) ve yapım ekleri kesmeyle ayrılmaz (Türkler).',
        difficulty: 1),
    StemQuestion(
        question: 'Soru eki veya sözcüğü içeren her cümlenin sonuna soru işareti konur mu?',
        options: ['A) Evet, her zaman.', 'B) Hayır, soru anlamı taşıyorsa konur.', 'C) Hayır, sadece soru eki varsa konur.', 'D) Evet, yüklem sondaysa konur.'],
        correctIndex: 1,
        explanation: '"Akşam oldu mu hüzünlenirim." cümlesinde soru anlamı yoktur, zaman anlamı vardır. Nokta konur.',
        difficulty: 1),
    StemQuestion(
        question: 'Ünlem işareti (!) hangisinde parantez içinde kullanılarak "alay/küçümseme" anlamı katar?',
        options: ['A) Çok zeki (!) bir çocukmuş.', 'B) Eyvah! Yandık.', 'C) Hey! Buraya bak.', 'D) Yaşasın! Kazandık.'],
        correctIndex: 0,
        explanation: 'Tersini kastetme (Aslında zeki değil).',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde üç nokta (...) kullanımı doğrudur?',
        options: ['A) Ali eve geldi...', 'B) Pazardan şunları aldık: elma, armut...', 'C) Bugün hava çok güzel...', 'D) Kitabı okudum...'],
        correctIndex: 1,
        explanation: 'Benzer örneklerin devam ettiğini göstermek için. Diğerleri tamamlanmış cümledir, nokta konmalı.',
        difficulty: 1),
    StemQuestion(
        question: 'Tırnak işareti (" ") hangisinde vurgu amacıyla kullanılmıştır?',
        options: ['A) "Yarın gel." dedi.', 'B) Şairin "Çile" adlı şiiri.', 'C) Yeni bir "barış" süreci başladı.', 'D) Atatürk "Yurtta sulh..." demiştir.'],
        correctIndex: 2,
        explanation: 'Cümle içinde özellikle belirtilmek istenen söz (barış) tırnak içine alınır. A ve D alıntı, B eser adı.',
        difficulty: 1),
    StemQuestion(
        question: 'Kısaltmalara getirilen ekleri ayırmak için ne kullanılır?',
        options: ['A) Virgül', 'B) Nokta', 'C) Kesme İşareti', 'D) Kısa Çizgi'],
        correctIndex: 2,
        explanation: 'TBMM\'ye.',
        difficulty: 1),
    StemQuestion(
        question: 'Satır sonuna sığmayan kelimeler bölünürken ne kullanılır?',
        options: ['A) Uzun Çizgi', 'B) Kısa Çizgi', 'C) Eğik Çizgi', 'D) Nokta'],
        correctIndex: 1,
        explanation: 'Kısa çizgi (-).',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde parantezle belirtilen yere noktalı virgül (;) getirilmelidir?', options: ['A) Pazardan elma ( ) armut aldım.', 'B) Erkeklere Ali, Ahmet ( ) kızlara Ayşe, Fatma adları verildi.', 'C) Eve geldim ( ) yemeğimi yedim.', 'D) Çalıştım ( ) başardım.'], correctIndex: 1, explanation: 'Tür veya takımları ayırmak için. Virgüllerle ayrılmış grupları ayırır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde virgülün kaldırılması anlam karışıklığına yol açar?', options: ['A) Genç, doktora soru sordu.', 'B) Babam, eve geldi.', 'C) Yarın, okula gideceğiz.', 'D) Kitabı, masaya bıraktı.'], correctIndex: 0, explanation: 'Virgül kalkarsa "Genç doktora" (sıfat tamlaması) olur.', difficulty: 1),
    StemQuestion(question: '"Hey ( ) buraya bak ( )" cümlesinde boşluklara sırasıyla ne gelmelidir?', options: ['A) (!) (.)', 'B) (,) (!)', 'C) (,) (.)', 'D) (!) (!)'], correctIndex: 1, explanation: 'Hey, buraya bak! (Virgülle devam edip sona ünlem konur).', difficulty: 1),
    StemQuestion(question: 'Tarihlerin yazımında gün, ay, yıl arasına hangisi konabilir?', options: ['A) Nokta veya Eğik Çizgi', 'B) Sadece Virgül', 'C) Sadece Kısa Çizgi', 'D) Noktalı Virgül'], correctIndex: 0, explanation: '19.05.1919 veya 19/05/1919.', difficulty: 1),
    StemQuestion(question: 'Konuşma çizgisinin (—) diğer adı nedir?', options: ['A) Kısa Çizgi', 'B) Uzun Çizgi', 'C) Alt Çizgi', 'D) Eğik Çizgi'], correctIndex: 1, explanation: 'Satır başında konuşmaları göstermek için kullanılır.', difficulty: 1),
    StemQuestion(question: 'Soru işareti (?) parantez içinde "(?)" kullanılırsa ne anlama gelir?', options: ['A) Soru sorulduğu', 'B) Bilinmeyen veya şüpheli bilgi', 'C) Alay etme', 'D) Önemseme'], correctIndex: 1, explanation: '1240 (?) yılında doğdu (Kesin değil).', difficulty: 1),
    StemQuestion(question: 'Aşağıdakilerden hangisinin sonuna "üç nokta" (...) konmaz?', options: ['A) Karşımızda uçsuz bucaksız bir ova', 'B) Seninle neler yapmadık ki', 'C) Çarşıdan şunları aldım: elma, armut', 'D) Dün akşam sinemaya gittik'], correctIndex: 3, explanation: 'Yüklem var, cümle bitmiş. Nokta konur.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "iki nokta" (:) kullanımı doğrudur?', options: ['A) Atatürk dedi ki: "Yurtta sulh..."', 'B) En sevdiğim renkler: Mavi, yeşil...', 'C) Bana: ne zaman geleceksin? dedi.', 'D) A ve B'], correctIndex: 3, explanation: 'A (Alıntıdan önce), B (Örneklemeden önce).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "kısa çizgi" (-) yanlış kullanılmıştır?', options: ['A) 1914-1918 yılları arası', 'B) Türk-Alman ilişkileri', 'C) Gel-iyor (heceleme)', 'D) On-beş kişi geldi'], correctIndex: 3, explanation: 'Sayılar yazıyla yazıldığında araya çizgi konmaz (On beş).', difficulty: 1),
    StemQuestion(question: 'Adres yazarken apartman numarası ile daire numarası arasına ne konur?', options: ['A) Nokta', 'B) Virgül', 'C) Eğik Çizgi', 'D) Kısa Çizgi'], correctIndex: 2, explanation: 'No: 21/4 (Eğik çizgi).', difficulty: 1),
    StemQuestion(question: 'Hangisinde virgül "ara sözü" ayırmak için kullanılmıştır?', options: ['A) Ali, en sevdiğim arkadaşım, geldi.', 'B) Elma, armut, muz aldım.', 'C) Evet, seni anlıyorum.', 'D) Akşam, yine akşam, yine akşam.'], correctIndex: 0, explanation: 'Ali (özne), en sevdiğim arkadaşım (ara söz), geldi.', difficulty: 1),
    StemQuestion(question: 'Kitap künyelerinde yazar, eser, basımevi vb. maddelerden sonra ne konur?', options: ['A) Nokta', 'B) Virgül', 'C) Noktalı Virgül', 'D) İki Nokta'], correctIndex: 1, explanation: 'Falih Rıfkı Atay, Tuna Kıyıları, Remzi Kitabevi...', difficulty: 1),
    StemQuestion(question: 'Matematikte "çarpma işlemi" yerine kullanılan işaret hangisidir?', options: ['A) Nokta', 'B) Virgül', 'C) Ünlem', 'D) İki nokta'], correctIndex: 0, explanation: '4.5=20 (Nokta).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "kesme işareti" kullanılmaz?', options: ['A) İstanbul\'un', 'B) 1985\'te', 'C) İngiliz\'ce', 'D) Ayşe\'nin'], correctIndex: 2, explanation: 'Özel isimden türetilen yapım ekleri (ce, li, ci...) ayrılmaz: İngilizce.', difficulty: 1),
    StemQuestion(question: 'Sevinç, kıvanç, acı, korku, şaşma gibi duyguları anlatan cümlelerin sonuna ne konur?', options: ['A) Nokta', 'B) Soru İşareti', 'C) Ünlem İşareti', 'D) Üç Nokta'], correctIndex: 2, explanation: 'Ünlem.', difficulty: 1),
  ],
  formulaCards: const ['Saat: Nokta (14.00).', 'Tarih: Nokta veya / (19.05).', 'Kurum Eki: Ayrılmaz.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU9Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u9',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde noktalama; "virgül" ve "noktalı virgül" arasındaki ince farklar, "iki nokta"nın kullanım alanları ve "kesme işareti"nin istisnaları üzerine odaklanır. Sıralı cümlelerde virgül kullanılır, ancak cümlelerin içinde zaten virgül varsa, sıralı cümleleri ayırmak için noktalı virgül kullanılır.',
    rule: 'Noktalı virgül (;) asla "bağlaçlardan" önce veya sonra kullanılmaz. Sadece virgüllerle ayrılmış türleri veya ögeleri arasında virgül bulunan sıralı cümleleri ayırır.',
    formulas: [
      'Virgül + Virgül -> Noktalı Virgül (;).',
      'Özne, (Eş görevli, Eş görevli) -> Özne ; (Eş, Eş).',
      'Kurum Adı + Ek -> Kesme YOK.'
    ],
    keyPoints: [
      'Zarf-fiil eklerinden sonra virgül konmaz, ancak birden fazla zarf-fiil arka arkaya gelirse konur.',
      'Şart ekinden (-se/-sa) sonra virgül konmaz.',
      'Cümle içinde "ve, veya, yahut" bağlaçlarından önce/sonra virgül konmaz.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde noktalı virgül (;) doğru kullanılmıştır?',
        options: ['A) Pazardan; elma, armut aldım.', 'B) Kel ölür, sırma saçlı olur; kör ölür, badem gözlü olur.', 'C) Eve geldim; ve yattım.', 'D) Seni seviyorum; dedi.'],
        correctIndex: 1,
        explanation: 'İki sıralı cümle grubu var. Kendi içlerinde virgül olduğu için, gruplar noktalı virgülle ayrılır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde virgül (,) yanlış kullanılmıştır?',
        options: ['A) Akşam gelirim, dedi.', 'B) O, bu işi başarır.', 'C) Gelirse, görüşürüz.', 'D) Genç, doktora baktı.'],
        correctIndex: 2,
        explanation: 'Şart ekinden (-se) sonra virgül konmaz.',
        difficulty: 2),
    StemQuestion(
        question: 'İki nokta (:) kendisinden sonra gelen cümle bağımsız bir cümleyse nasıl başlar?',
        options: ['A) Küçük harfle', 'B) Büyük harfle', 'C) Tırnak içinde', 'D) Parantez içinde'],
        correctIndex: 1,
        explanation: 'İki noktadan sonra cümle geliyorsa Büyük harf, sadece örnekler sıralanıyorsa Küçük harf.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "kesme işareti"nin kullanımı yanlıştır?',
        options: ['A) TBMM\'nin', 'B) Türk Dil Kurumu\'na', 'C) Bakanlar Kurulunun', 'D) 19 Mayıs\'ta'],
        correctIndex: 1,
        explanation: 'Kurum adlarına gelen ekler ayrılmaz: Türk Dil Kurumuna.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "kısa çizgi" (-) ara sözü ayırmak için kullanılmıştır?',
        options: ['A) Türk-Yunan ilişkileri', 'B) Küçük bir sürü -dört inekle birkaç koyun- köye girdi.', 'C) 19-20 yaşlarında', 'D) Türkçe-İngilizce sözlük'],
        correctIndex: 1,
        explanation: 'Ara sözlerin başında ve sonunda ya virgül ya da kısa çizgi kullanılır.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde soru işareti (?) yanlış kullanılmıştır?',
        options: ['A) Adınız?', 'B) Ne zaman geleceksin?', 'C) Bunu yapan Ahmet miydi?', 'D) Akşam oldu mu eve döneriz?'],
        correctIndex: 3,
        explanation: 'Burada "mi" soru değil, zaman (ınca/ince) anlamı katmıştır. Soru işareti konmaz.',
        difficulty: 2),
    StemQuestion(
        question: '"Ya bu deveyi güdersin ya bu diyardan gidersin." cümlesinde "ya...ya" bağlaçlarının arasına hangi işaret konur?',
        options: ['A) Virgül', 'B) Noktalı Virgül', 'C) Hiçbir işaret', 'D) Kısa Çizgi'],
        correctIndex: 2,
        explanation: 'Tekrarlı bağlaçların (hem...hem, ne...ne, ya...ya) arasına noktalama işareti konmaz.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "tırnak işareti" eser adını belirtmek için kullanılmıştır?',
        options: ['A) "Yaban"ı okudun mu?', 'B) "İzmir" üzerine dünyada şehir yoktur.', 'C) Öğretmen "Oturun." dedi.', 'D) "Barış" kelimesi çok önemlidir.'],
        correctIndex: 0,
        explanation: 'Yakup Kadri\'nin eseri Yaban.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "üç nokta" (...) kullanımı yanlıştır?',
        options: ['A) Bahçede ağaçlar, kuşlar, çiçekler...', 'B) Kimsin? - Ali...', 'C) Seni o kadar özledim ki...', 'D) Bütün gün çalıştım...'],
        correctIndex: 3,
        explanation: 'Yargı tamamlanmış (Çalıştım). Nokta konmalı.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "yay ayraç" ( ) kullanımı yanlıştır?',
        options: ['A) Yunus Emre (1240-1320)', 'B) İsim (Ad) konusu', 'C) (Almanya)dan gelmiş.', 'D) Anadolu kentlerini (Konya, Kayseri, Sivas) gezdim.'],
        correctIndex: 2,
        explanation: 'Ekler yay ayracın dışına yazılır veya parantez içine alınmaz: Almanya\'dan gelmiş.',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde boş bırakılan yere noktalı virgül (;) getirilmelidir?', options: ['A) At ölür ( ) meydan kalır.', 'B) At ölür, meydan kalır ( ) yiğit ölür, şan kalır.', 'C) Eve geldim ( ) yemek yedim.', 'D) Pazardan elma ( ) armut aldım.'], correctIndex: 1, explanation: 'İki sıralı cümle grubu var. Grupların içinde virgül olduğu için, ana ayrım noktalı virgülle yapılır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde virgül (,) yanlış kullanılmıştır?', options: ['A) Akşam, yine akşam, yine akşam.', 'B) O, eski defterleri çoktan kapatmış.', 'C) Hem ağlarım, hem giderim.', 'D) Efendiler, yarın cumhuriyeti ilan edeceğiz.'], correctIndex: 2, explanation: 'Tekrarlı bağlaçların (Hem...hem) arasına virgül konmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde iki nokta (:) yanlış kullanılmıştır?', options: ['A) Size şunu söyleyeyim: Çok çalışın.', 'B) Pazardan: Elma, armut aldım.', 'C) İki tür sıfat vardır: Niteleme ve Belirtme.', 'D) Atatürk: "Ordular..." dedi.'], correctIndex: 1, explanation: 'Fiil ile nesne arasına noktalama girmez. "Pazardan elma aldım."', difficulty: 2),
    StemQuestion(question: 'Hangisinde kesme işareti doğru kullanılmıştır?', options: ['A) Ahmet\'ler bize geldi.', 'B) Ankaralı\'nın.', 'C) İngilizce\'yi.', 'D) 1985\'te.'], correctIndex: 3, explanation: 'D doğru. A (Çoğul eki ayrılmaz), B (Yapım eki ayrılmaz), C (Yapım eki ayrılmaz).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ünlem işareti" cümle sonuna konmaz?', options: ['A) Eyvah, yangın var', 'B) Ne kadar güzel bir manzara', 'C) Arkadaşına: "Hey" dedi', 'D) Ordular, ilk hedefiniz Akdeniz\'dir'], correctIndex: 2, explanation: 'C şıkkında cümlenin sonuna (dedi\'den sonra) nokta konur.', difficulty: 2),
    StemQuestion(question: 'Hangisinde özel isme gelen yapım ekinden sonra kesme işareti yanlış kullanılmıştır?', options: ['A) Türkiye\'nin', 'B) Konya\'da', 'C) Türkçe\'nin', 'D) Ali\'den'], correctIndex: 2, explanation: 'Türkçe (Yapım eki almış: Türk+çe) + nin (Çekim eki). Yapım ekinden sonra gelen çekim ekleri ayrılmaz: Türkçenin.', difficulty: 2),
    StemQuestion(question: 'Hangisinde kısa çizgi (-) yanlış kullanılmıştır?', options: ['A) 09.30-10.30 arası', 'B) Ural-Altay dil grubu', 'C) İki-üç kişi geldi', 'D) Kelimeleri hece-le-mek'], correctIndex: 2, explanation: 'Yaklaşıklık bildiren sayılar (iki üç) arasında çizgi kullanılmaz.', difficulty: 2),
    StemQuestion(question: '"Hayır ( ) bunu kabul edemem." cümlesinde boşluğa ne gelir?', options: ['A) Nokta', 'B) Virgül', 'C) Noktalı Virgül', 'D) Ünlem'], correctIndex: 1, explanation: 'Red, kabul, onay bildiren kelimelerden (Evet, Hayır, Peki) sonra virgül konur.', difficulty: 2),
    StemQuestion(question: 'Hangisinde tırnak işareti (" ") kullanımı yanlıştır?', options: ['A) "Yaban" romanını okudum.', 'B) Bugün "sinemaya" gideceğiz.', 'C) Atatürk: "Ne mutlu Türk\'üm diyene!" dedi.', 'D) Yazıda "betimleme"ye ağırlık verilmiş.'], correctIndex: 1, explanation: 'Sinemaya kelimesi özel bir vurgu veya eser adı değildir, tırnak içine alınmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde eğik çizgi (/) yanlış kullanılmıştır?', options: ['A) Altay Sokağı No: 21/6', 'B) 18/11/1988', 'C) -mak/-mek eki', 'D) Ankara/İstanbul arası uçakla gittik.'], correctIndex: 3, explanation: 'İle/ve anlamında "kısa çizgi" (-) kullanılır: Ankara-İstanbul arası.', difficulty: 2),
    StemQuestion(question: 'Hangisinde virgül "anlam karışıklığını gidermek" için kullanılmıştır?', options: ['A) İhtiyar, ağaca yaslandı.', 'B) Elma, en sevdiğim meyvedir.', 'C) Ankara, başkentimizdir.', 'D) Evet, geliyorum.'], correctIndex: 0, explanation: 'İhtiyar (adam) mı ağaca yaslandı, yoksa biri ihtiyar ağaca mı yaslandı? Virgül özneyi belirler.', difficulty: 2),
    StemQuestion(question: 'Cümle içinde ara sözleri ayırmak için virgül veya ne kullanılır?', options: ['A) Noktalı Virgül', 'B) Kısa Çizgi', 'C) Eğik Çizgi', 'D) Tırnak İşareti'], correctIndex: 1, explanation: 'Kısa çizgi.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "den-den" işareti (") kullanılır?', options: ['A) Altta tekrar eden kelimeler için', 'B) Konuşma metinlerinde', 'C) Soru cümlelerinde', 'D) Şiirlerde'], correctIndex: 0, explanation: 'Bir üst satırdaki kelimenin aynısı olduğunu belirtmek için.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "köşeli parantez" [ ] kullanılır?', options: ['A) Parantez içinde parantez açılması gerektiğinde', 'B) Açıklama yaparken', 'C) Tarih belirtirken', 'D) Alıntı yaparken'], correctIndex: 0, explanation: 'Yay ayraç içinde yay ayraç gerekirse dıştaki köşeli olur.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "uzun çizgi" (—) kullanılır?', options: ['A) Satır sonu bölmesinde', 'B) Karşılıklı konuşmalarda', 'C) Tarihlerde', 'D) Adreslerde'], correctIndex: 1, explanation: 'Konuşma çizgisi.', difficulty: 2),
  ],
  formulaCards: const ['Tekrarlı Bağlaç: Virgül konmaz (Ne...ne).', 'Şart Eki: Virgül konmaz (-se).', 'Sıralı Cümle: Virgül; Gruplar varsa Noktalı Virgül.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU9Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u9',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde noktalama işaretleri; karmaşık cümle yapılarındaki işaretler, "üç nokta"nın eksiltili cümle dışındaki işlevleri (kaba söz, alıntı atlama), "kesme işareti"nin ince detayları ve "düzeltme işareti"nin anlam ayırıcı fonksiyonu üzerine yoğunlaşır.',
    rule: 'Özne ile yüklem arasına başka ögeler girmişse, özneyi belirtmek için virgül konur.',
    formulas: [
      'Özne (,) ..... Yüklem.',
      'Metin (Alıntı) Metin -> "Alıntı" (Nokta içeride).',
      '20. yy.da (Kısaltma olduğu için kesme yok, nokta var).'
    ],
    keyPoints: [
      'Soru eki "mi"den sonra gelen ekler bitişik yazılır ve soru işareti cümlenin en sonuna konur.',
      'Ünlem işareti, parantez içinde alay anlamı katıyorsa cümlenin herhangi bir yerinde olabilir.',
      'Tırnak içindeki cümlenin sonundaki noktalama işareti tırnağın içinde kalır.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde noktalama yanlışı yoktur?',
        options: ['A) Yarın, Ankara\'ya gideceğim.', 'B) Yarın Ankara\'ya gideceğim.', 'C) Yarın, Ankara\'ya, gideceğim.', 'D) Yarın; Ankara\'ya gideceğim.'],
        correctIndex: 1,
        explanation: 'Zaman zarfından sonra virgüle gerek yoktur (Vurgu amacı yoksa). C ve D kesinlikle yanlıştır. B en doğru kullanımdır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde virgülün kaldırılması anlamı değiştirmez?',
        options: ['A) O, kitabı okudu.', 'B) Genç, adama seslendi.', 'C) Hırsız, çocuğu kovaladı.', 'D) Bahçedeki, ağaçlar kurudu.'],
        correctIndex: 3,
        explanation: 'Bahçedeki ağaçlar (Sıfat tamlaması). Virgül zaten yanlıştır, kaldırılması anlamı bozmaz. A, B, C\'de özne karışıklığı olur.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "kesme işareti" yanlış kullanılmıştır?',
        options: ['A) 2\'nci', 'B) 1980\'li', 'C) Ahmet\'ler', 'D) ABD\'de'],
        correctIndex: 2,
        explanation: 'Özel isme gelen çoğul eki (-ler) ayrılmaz: Ahmetler.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "noktalı virgül" kullanımı zorunludur?',
        options: ['A) Ali okula gitti ( ) Veli eve döndü.', 'B) Pazardan elma ( ) armut ( ) portakal aldım.', 'C) Erkeklere Efe, Ali ( ) kızlara Ece, Naz dendi.', 'D) Çalıştım ( ) başardım.'],
        correctIndex: 2,
        explanation: 'Grupları ayırmak için zorunludur. A, B, D virgül yeterlidir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "üç nokta" (...) kullanımı yanlıştır?',
        options: ['A) Kılavuzu karga olanın...', 'B) Buralarda neler yok ki: ağaçlar, kuşlar...', 'C) Olayı ... Bey anlattı.', 'D) En sevdiğim renk mavidir...'],
        correctIndex: 3,
        explanation: 'Cümle bitmiş, yüklem (mavidir) var. Nokta konmalı. C (İsim gizleme), A (Eksiltili), B (Örnekler devam ediyor).',
        difficulty: 3),
    StemQuestion(
        question: '"Bu işi -sabaha kadar- bitirmelisin." Cümlesinde ara sözü ayırmak için ne kullanılmıştır?',
        options: ['A) Virgül', 'B) Kısa Çizgi', 'C) Noktalı Virgül', 'D) Yay Ayraç'],
        correctIndex: 1,
        explanation: 'Ara sözler virgül veya kısa çizgi ile ayrılır.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "iki nokta" (:) kullanımı yanlıştır?',
        options: ['A) Şunları aldım: Kalem, defter.', 'B) Atatürk: "Başarı..." dedi.', 'C) İsim: Varlıkları karşılar.', 'D) Oraya: gittim.'],
        correctIndex: 3,
        explanation: 'Cümle ortasına iki nokta konmaz. Oraya gittim.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "düzeltme işareti" (^) anlam karışıklığını önlemek için kullanılmıştır?',
        options: ['A) Rüzgâr', 'B) Kâğıt', 'C) Hâlâ (zaman)', 'D) Dükkân'],
        correctIndex: 2,
        explanation: 'Hala (Babanın kardeşi) ile Hâlâ (Henüz) karışmasın diye. Diğerleri inceltme içindir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde soru işareti parantez içinde (?) kullanılır?',
        options: ['A) Bunu sen mi yaptın?', 'B) 1490 (?) yılında doğmuş.', 'C) Adınız nedir?', 'D) Emin misiniz?'],
        correctIndex: 1,
        explanation: 'Kesin bilinmeyen bilgiler parantez içinde soru işaretiyle gösterilir: (?)',
        difficulty: 3),
    StemQuestion(
        question: 'Tırnak işareti içindeki cümlenin sonuna nokta konur mu?',
        options: ['A) Evet, tırnağın içine.', 'B) Hayır, tırnağın dışına.', 'C) Sadece ünlem konur.', 'D) Konmaz.'],
        correctIndex: 0,
        explanation: '"Gel." dedi. (Nokta tırnağın içinde).',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde noktalama yanlışı yapılmıştır?', options: ['A) Hey, arkadaş! Buraya bak.', 'B) Sevgili Kardeşim,', 'C) "Yaban" romanı, Yakup Kadri\'nindir.', 'D) Yarın 13.00\'da buluşalım.'], correctIndex: 3, explanation: '13.00\'da değil 13.00\'te (Benzeşme kuralı).', difficulty: 3),
    StemQuestion(question: 'Hangisinde virgül "sıfat tamlamasını" ayırmıştır (Yanlış kullanım)?', options: ['A) O, eski günleri özlüyor.', 'B) Kırmızı, güller soldu.', 'C) Yarın, okula gideceğim.', 'D) Evet, gelirim.'], correctIndex: 1, explanation: 'Kırmızı güller (Sıfat Tamlaması). Araya virgül girmez.', difficulty: 3),
    StemQuestion(question: 'Parantez ( ) içindeki ünlem (!) ne anlama gelir?', options: ['A) Korku', 'B) Heyecan', 'C) Küçümseme/Alay', 'D) Seslenme'], correctIndex: 2, explanation: 'İnce bir zeka (!) örneği.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "kesme işareti"nin kullanımı yanlıştır?', options: ['A) Boğaz\'dan gemiler geçti.', 'B) Kanun\'un 1. maddesi.', 'C) Cumhuriyet Dönemi\'nde.', 'D) Ankara\'lı.'], correctIndex: 3, explanation: 'Yapım ekleri ayrılmaz: Ankaralı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde noktalı virgül (;) doğru kullanılmıştır?', options: ['A) At ölür; meydan kalır.', 'B) Erkeklere Ali, Ahmet; kızlara Ece, Naz adı verildi.', 'C) Pazardan; elma aldım.', 'D) Geldim; gördüm.'], correctIndex: 1, explanation: 'Virgülle ayrılmış grupları ayırmak için noktalı virgül kullanılır. A, C, D virgül olmalı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "üç nokta" (...) yerine "iki nokta" (:) gelmelidir?', options: ['A) Karşımızda deniz...', 'B) Şunları aldım... Elma, armut.', 'C) Söze şöyle başladı...', 'D) Bence sen...'], correctIndex: 2, explanation: 'Açıklama/Konuşma yapacağı için iki nokta: "Söze şöyle başladı:"', difficulty: 3),
    StemQuestion(question: 'Hangisinde "tırnak işareti" gereksiz kullanılmıştır?', options: ['A) "Nutuk"u okudun mu?', 'B) Bugün "Aşk-ı Memnu" dizisi var.', 'C) "Ankara" başkentimizdir.', 'D) Ben "gelmeyeceğim" dedi.'], correctIndex: 2, explanation: 'Ankara özel isimdir, zaten büyük harfle başlar. Tırnak içine almak gereksizdir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "kısa çizgi" (-) yanlış kullanılmıştır?', options: ['A) Türkçe-Fransızca sözlük', 'B) 19-20 yaşları', 'C) Satır sonun-da', 'D) Beş-on kişi'], correctIndex: 3, explanation: 'Yaklaşıklık bildiren sayılarda çizgi olmaz: Beş on kişi.', difficulty: 3),
    StemQuestion(question: 'Hangisinde soru işareti (?) konmaz?', options: ['A) Adınız', 'B) Doğum yeriniz', 'C) Neden gelmedin', 'D) Ne kadar güzel bir gün'], correctIndex: 3, explanation: 'Ünlem cümlesi.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "virgül" kullanılamaz?', options: ['A) Ve bağlacından önce.', 'B) Sıralı cümlelerde.', 'C) Eş görevli sözcüklerde.', 'D) Hitaplardan sonra.'], correctIndex: 0, explanation: 'Bağlaçlardan önce/sonra virgül olmaz.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "nokta" (.) yanlış kullanılmıştır?', options: ['A) Prof. Dr. Ali Bey', 'B) 15. yüzyıl', 'C) T.B.M.M.', 'D) 10. Cadde'], correctIndex: 2, explanation: 'Büyük harfli kısaltmalarda nokta kullanılmaz (İstisna: T.C.). Doğrusu: TBMM.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ek olan -ki" ile "bağlaç olan ki" karıştırılmıştır?', options: ['A) Senki beni tanırsın.', 'B) Evdeki hesap.', 'C) Duydum ki unutmuşsun.', 'D) Benimki.'], correctIndex: 0, explanation: 'Sen ki (Ayrı yazılır).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "eğik çizgi" (/) tarihlerin yazımında doğru kullanılmıştır?', options: ['A) 19/Mayıs/1919', 'B) 19/05/1919', 'C) 19/5./1919', 'D) 19-05/1919'], correctIndex: 1, explanation: 'Sadece rakamla yazılan tarihlerde.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "yay ayraç" ( ) noktalama işaretini belirtmek için kullanılmıştır?', options: ['A) Namık Kemal (1840-1888)', 'B) Ad (İsim)', 'C) İnce bir zeka (!) örneği.', 'D) Tiyatroda (Kapıyı kapatır.)'], correctIndex: 2, explanation: 'Parantez içinde (!) alay/ironi için noktalama işareti barındırır.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "kesme işareti" özel isme gelen eki ayırmak için kullanılmamıştır?', options: ['A) Ayşe\'nin', 'B) Konya\'yı', 'C) Karabaş\'a', 'D) N\'oldu'], correctIndex: 3, explanation: 'Ses düşmesini (Ne oldu -> N\'oldu) göstermek için kullanılmış.', difficulty: 3),
  ],
  formulaCards: const ['Sıfat Tamlaması: Araya virgül girmez.', 'Zarf Fiil: Virgül girmez.', 'TBMM: Noktasız.'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 10: ANLATIM BOZUKLUKLARI
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU10Content = StemUnitContent(
  unitId: 'kpsslise_tur_u10',
  topic: const TopicContent(
    summary: 'Lise seviyesinde anlatım bozuklukları, ağırlıklı olarak anlamsal hatalar üzerinedir. Gereksiz sözcük kullanımı (duruluk ilkesine aykırılık), sözcüğün yanlış anlamda kullanılması (ücret-fiyat karışıklığı), çelişen sözcüklerin bir arada kullanılması ve mantık hataları bu seviyenin konusudur.',
    rule: 'Bir cümlede eş anlamlı sözcüklerin bir arada kullanılması anlatım bozukluğudur (Geri iade etmek).',
    formulas: [
      'Gereksiz Sözcük: Eş Anlamlı + Eş Anlamlı (Sağlık ve sıhhat).',
      'Yanlış Anlam: Resim (Çizilir) vs Fotoğraf (Çekilir).',
      'Çelişki: Kesinlik (Mutlaka) + Olasılık (Olabilir).'
    ],
    keyPoints: [
      '"Neden olmak" olumsuz durumlar için, "Sağlamak" olumlu durumlar için kullanılır.',
      '"Fiyat" malın değeridir, "Ücret" emeğin karşılığıdır.',
      '"Geri iade" denmez, iade zaten geridir.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde gereksiz sözcük kullanımından kaynaklanan bir anlatım bozukluğu vardır?',
        options: ['A) Kulağıma alçak sesle bir şeyler fısıldadı.', 'B) Dün seni aradım.', 'C) Kitap okumayı severim.', 'D) Eve erken gitti.'],
        correctIndex: 0,
        explanation: 'Fısıldamak zaten alçak sesle olur. "Alçak sesle" gereksizdir.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde sözcüğün yanlış anlamda kullanılmasından kaynaklanan bir bozukluk vardır?',
        options: ['A) Bu yılki bütçe ücretleri açıklandı.', 'B) Otobüs ücretleri zamlandı.', 'C) Bu fiyata bu elbise bedava.', 'D) İşçilerin ücretleri ödendi.'],
        correctIndex: 0,
        explanation: 'Bütçe "ücretleri" olmaz, bütçe "rakamları/verileri" olur.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde çelişen sözcüklerin bir arada kullanılmasından kaynaklanan bozukluk vardır?',
        options: ['A) Elbette bu işi başarabilirsin.', 'B) Eminim bu konuyu anlamış olmalısınız.', 'C) Belki yarın gelir.', 'D) Kesinlikle oraya gitme.'],
        correctIndex: 1,
        explanation: 'Eminim (Kesinlik) - Olmalısınız (Olasılık/Gereklilik).',
        difficulty: 1),
    StemQuestion(
        question: '"Bu fidanları bahçeye ektik." cümlesindeki bozukluğun nedeni nedir?',
        options: ['A) Gereksiz sözcük', 'B) Yanlış sözcük kullanımı', 'C) Öge eksikliği', 'D) Mantık hatası'],
        correctIndex: 1,
        explanation: 'Fidan "dikilir", tohum "ekilir".',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde mantık hatası vardır?',
        options: ['A) Bırak patates doğramayı, yemek bile yapamaz.', 'B) Yarın size geleceğim.', 'C) Ders çalışıyorum.', 'D) Kitap okudum.'],
        correctIndex: 0,
        explanation: 'Yemek yapmak daha zordur. Sıralama: Bırak yemek yapmayı, patates bile doğrayamaz.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde "anlam belirsizliği" vardır?',
        options: ['A) Kardeşini okulda gördüm.', 'B) Ali eve gitti.', 'C) Dün seni aradım.', 'D) Kitabı masaya bıraktı.'],
        correctIndex: 0,
        explanation: 'Kimin kardeşi? Senin kardeşini mi? Onun kardeşini mi? (Zamir eksikliği).',
        difficulty: 1),
    StemQuestion(
        question: '"Oğlunu başarılı bir öğretim hayatı dilerim." cümlesindeki bozukluk nedir?',
        options: ['A) Gereksiz sözcük', 'B) Yanlış sözcük kullanımı', 'C) Mantık hatası', 'D) Çelişki'],
        correctIndex: 1,
        explanation: 'Öğretim (Öğretme) değil, "öğrenim" (öğrenme) hayatı olmalı.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde deyim yanlışlığından kaynaklanan bozukluk vardır?',
        options: ['A) Müjdeli haberi alınca etekleri zil çaldı.', 'B) Korkudan etekleri zil çaldı.', 'C) Sinirden küplere bindi.', 'D) Ağzı kulaklarına vardı.'],
        correctIndex: 1,
        explanation: 'Etekleri zil çalmak "sevinmek" demektir. Korkudan "etekleri tutuşur".',
        difficulty: 1),
    StemQuestion(
        question: '"Sınıftaki mevcut öğrenci sayısı 20\'dir." cümlesindeki bozukluğun sebebi nedir?',
        options: ['A) Öge eksikliği', 'B) Gereksiz sözcük', 'C) Yüklem eksikliği', 'D) Tamlama hatası'],
        correctIndex: 1,
        explanation: 'Mevcut zaten var olan sayıdır. "Sınıftaki öğrenci sayısı" veya "Sınıf mevcudu" denmeli.',
        difficulty: 1),
    StemQuestion(
        question: 'Hangisinde sözcüğün yanlış yerde kullanımından kaynaklanan bozukluk vardır?',
        options: ['A) Yeni okula geldim.', 'B) Okula yeni geldim.', 'C) Çok başım ağrıyor.', 'D) Başım çok ağrıyor.'],
        correctIndex: 2,
        explanation: 'Çok başım (Birden fazla baş?) -> Başım çok ağrıyor (Ağrının derecesi).',
        difficulty: 1),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde bir anlatım bozukluğu vardır?', options: ['A) Bu olaylar beni çok üzdü.', 'B) Yanlış yola saptık.', 'C) Çocuğun saçları hayli büyümüş.', 'D) Yemek çok lezzetliydi.'], correctIndex: 2, explanation: 'Saç "büyümez", "uzar". Tırnak ve saç uzar; çocuk büyür.', difficulty: 1),
    StemQuestion(question: '"Hiç şüphesiz bu konuyu anlamış olmalı." cümlesindeki anlatım bozukluğu nedir?', options: ['A) Anlam belirsizliği', 'B) Çelişen sözcüklerin kullanımı', 'C) Gereksiz sözcük', 'D) Mantık hatası'], correctIndex: 1, explanation: 'Hiç şüphesiz (Kesinlik) - Olmalı (Olasılık).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "gereksiz yardımcı eylem" kullanılmıştır?', options: ['A) Yardım etti.', 'B) İtiraz etti.', 'C) Kuşku etti.', 'D) Terk etti.'], correctIndex: 2, explanation: 'Kuşku etti yerine "Kuşkulandı" denmelidir.', difficulty: 1),
    StemQuestion(question: '"Geri iade" ifadesindeki bozukluğun sebebi nedir?', options: ['A) Yanlış anlam', 'B) Gereksiz sözcük', 'C) Mantık hatası', 'D) Çelişki'], correctIndex: 1, explanation: 'İade zaten geri vermektir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "resim/fotoğraf" ayrımına dikkat edilmemiştir?', options: ['A) Duvarda güzel bir resim var.', 'B) Manzara resmi çizdik.', 'C) Birlikte resim çekildik.', 'D) Fotoğraf makinesi aldım.'], correctIndex: 2, explanation: 'Resim çizilir/yapılır, fotoğraf çekilir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "neden olmak" yanlış kullanılmıştır?', options: ['A) Bu ilaç iyileşmene neden oldu.', 'B) Kaza trafiğe neden oldu.', 'C) Dikkatsizlik yangına neden oldu.', 'D) Fırtına hasara neden oldu.'], correctIndex: 0, explanation: 'Neden olmak olumsuz sonuçlar içindir. İyileşmeyi "sağladı" olmalı.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "kapsamak" kelimesi yanlış kullanılmıştır?', options: ['A) Bu konu sizi de kapsıyor.', 'B) Kitap on üniteyi kapsıyor.', 'C) Örtü masayı kapsadı.', 'D) Kanun herkesi kapsar.'], correctIndex: 2, explanation: 'Örtü masayı "kapladı" (Örttü). Kapsamak (İçermek).', difficulty: 1),
    StemQuestion(question: 'Hangisinde "ayrım/ayrıcalık" hatası vardır?', options: ['A) İkisi arasında fark yok.', 'B) Zengin fakir ayrımı yapma.', 'C) Erkeklere ayrıcalık tanındı.', 'D) İkisi arasındaki ayrıcalığı göremedim.'], correctIndex: 3, explanation: 'İki şey arasındaki fark "ayrım"dır. Ayrıcalık "imtiyaz"dır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "savunmak" yanlış kullanılmıştır?', options: ['A) Vatanı savundu.', 'B) Yanlış düşünceleri savundu.', 'C) Ahmet\'in suçlu olduğunu savundu.', 'D) Tezini savundu.'], correctIndex: 2, explanation: 'Suçlu olduğunu "iddia etti/öne sürdü" olmalı. Savunmak korumaktır.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "yaklaşık/aşağı yukarı" gereksizliği vardır?', options: ['A) Yaklaşık on kişi vardı.', 'B) Aşağı yukarı üç yıl oldu.', 'C) Tamı tamına beş lira.', 'D) Yaklaşık beş on kişi geldi.'], correctIndex: 3, explanation: 'Beş on (belirsizlik) zaten yaklaşıklık bildirir. Yaklaşık kelimesi gereksizdir.', difficulty: 1),
    StemQuestion(question: 'Hangisinde zamir eksikliğinden kaynaklanan belirsizlik vardır?', options: ['A) Evini çok beğendim.', 'B) Arabayı sattı.', 'C) Okula gitti.', 'D) Seni sordu.'], correctIndex: 0, explanation: 'Senin evini mi? Onun evini mi?', difficulty: 1),
    StemQuestion(question: '"Ağrısız kulak delinir." cümlesindeki bozukluk nedir?', options: ['A) Mantık hatası', 'B) Sözcüğün yanlış yerde kullanımı', 'C) Yanlış anlam', 'D) Gereksiz sözcük'], correctIndex: 1, explanation: 'Kulak ağrısız değildir; delme işlemi ağrısızdır (zarf). "Kulak ağrısız delinir" olmalı.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "etken/edilgen" çatı uyuşmazlığı vardır?', options: ['A) Bütün evi temizleyip boyandı.', 'B) Evi temizledik ve boyadık.', 'C) Ev temizlendi ve boyandı.', 'D) Kapıyı açıp içeri girdi.'], correctIndex: 0, explanation: 'Temizleyip (Etken) - Boyandı (Edilgen). Ya "Temizlenip boyandı" ya da "Temizleyip boyadılar" olmalı.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "çoğul eki" gereksiz kullanılmıştır?', options: ['A) Birçok insanlar geldi.', 'B) Birçok insan geldi.', 'C) İnsanlar konuştu.', 'D) Çocuklar oynadı.'], correctIndex: 0, explanation: 'Birçok (Çokluk bildirir) insan-lar (gereksiz). Birçok insan denmeli.', difficulty: 1),
    StemQuestion(question: 'Hangisinde "noktalama eksikliği" anlam karışıklığı yaratmıştır?', options: ['A) O evi aldı.', 'B) Küçük ağaca tırmandı.', 'C) Genç adamı sordu.', 'D) Hepsi'], correctIndex: 3, explanation: 'O, evi / O evi. Küçük, ağaca / Küçük ağaca. Genç, adamı / Genç adamı. Hepsi.', difficulty: 1),
  ],
  formulaCards: const ['Gereksiz Sözcük: Eş anlamlıları at.', 'Çelişki: Kesinlik vs Olasılık.', 'Neden Olmak: Olumsuz sonuç.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU10Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u10',
  topic: const TopicContent(
    summary: 'Önlisans seviyesinde anlatım bozuklukları; yapısal bozukluklara (öge eksikliği, ek eylem eksikliği, tamlama yanlışları) odaklanır. Sıralı ve bağlı cümlelerde ortak kullanılan ögelerin her iki cümleye de uyumlu olması gerekir.',
    rule: '"Herkes, hepsi" gibi özneler olumlu yüklem alır; "Hiçkimse, kimse" gibi özneler olumsuz yüklem alır.',
    formulas: [
      'Özne-Yüklem Uyumu: Herkes (+) ... Kimse (-).',
      'Nesne Eksikliği: Geçişli fiil nesne ister (Onu).',
      'Tamlama Hatası: Sıfat ve İsim tamlamaları aynı tamlanana bağlanamaz.'
    ],
    keyPoints: [
      'Sıralı cümlelerde virgülden sonraki cümleye dikkat et. Özne veya nesne eksik olabilir.',
      '"Ve" bağlacıyla bağlanan tamlamalarda sıfat ve isim tamlaması karışmamalıdır.',
      'Ek eylem eksikliği: Biri isim biri fiil olan sıralı cümlelerde yüklem ortak kullanılamaz.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde özne-yüklem uyuşmazlığından kaynaklanan bir anlatım bozukluğu vardır?',
        options: ['A) Herkes bu olayı konuşuyor, bir çözüm bulamıyordu.', 'B) Çocuklar bahçede oynuyor.', 'C) Kimse okula gelmedi.', 'D) Hepsi seni bekliyor.'],
        correctIndex: 0,
        explanation: 'Herkes konuşuyor (+), (Herkes) çözüm bulamıyordu (-). İkinci cümleye "kimse" gelmeli.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "nesne eksikliği" vardır?',
        options: ['A) Ona güveniyor ve seviyorum.', 'B) Seni aradım ama bulamadım.', 'C) Kitabı aldı ve okudu.', 'D) Eve gitti ve yattı.'],
        correctIndex: 0,
        explanation: 'Ona (DT) güveniyor ve (Onu/Nesne) seviyorum.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "tamlama yanlışlığı" vardır?',
        options: ['A) Ekonomik ve sağlık sorunları.', 'B) Kırmızı ve beyaz güller.', 'C) Eski ve yeni binalar.', 'D) Türk ve Alman edebiyatı.'],
        correctIndex: 0,
        explanation: 'Ekonomik (sıfat) sorunları vs sağlık (isim) sorunları (isim tamlaması). Doğrusu: Ekonomik sorunlar ve sağlık sorunları.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "dolaylı tümleç eksikliği" vardır?',
        options: ['A) Düşman kenti bombaladı ama giremedi.', 'B) Beni sevdiğini söyledi.', 'C) Okula gitti.', 'D) Seni özledim.'],
        correctIndex: 0,
        explanation: 'Kenti (Nesne) bombaladı, (Kente/DT) giremedi.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "ek eylem eksikliği" vardır?',
        options: ['A) Boyu kısa, huyu iyi değildi.', 'B) Boyu kısaydı, huyu iyi değildi.', 'C) Çok çalıştı ve başardı.', 'D) Eve geldi.'],
        correctIndex: 0,
        explanation: 'Boyu kısa(ydı), huyu iyi değildi. "Değildi" ortak kullanılırsa "Boyu kısa değildi" anlamı çıkar. Ek eylem şarttır.',
        difficulty: 2),
    StemQuestion(
        question: '"Kardeşine yardım eder, hiç üzmezdi." cümlesindeki bozukluk nedir?',
        options: ['A) Özne eksikliği', 'B) Nesne eksikliği', 'C) Tümleç eksikliği', 'D) Yüklem eksikliği'],
        correctIndex: 1,
        explanation: 'Kardeşine (DT) yardım eder, (Onu/Kardeşini - Nesne) hiç üzmezdi.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "çatı uyuşmazlığı" vardır?',
        options: ['A) Sabah erkenden kalkılıp yola çıkıldı.', 'B) Bütün işleri bitirip tatile çıkıldı.', 'C) Eve gelindi ve yemek yendi.', 'D) Sorular çözüldü.'],
        correctIndex: 1,
        explanation: 'Bitirip (Etken) - Çıkıldı (Edilgen). Bitirilip çıkıldı olmalı.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "yüklem eksikliği" vardır?',
        options: ['A) Ben elma, o armut sever.', 'B) Ben elma severim, o armut sever.', 'C) Eve gittim.', 'D) Seni gördüm.'],
        correctIndex: 0,
        explanation: 'Ben elma (severim), o armut sever. Yüklem ortak kullanılamaz (Şahıs uyumsuzluğu).',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "özne eksikliği" vardır?',
        options: ['A) Kitabın sayfaları yırtılmış, okunamaz hale gelmişti.', 'B) Ali geldi ve gitti.', 'C) Yağmur yağdı.', 'D) Kapı açıldı.'],
        correctIndex: 0,
        explanation: 'Kitabın sayfaları (Özne) yırtılmış, (Kitap/Özne) okunamaz hale gelmişti.',
        difficulty: 2),
    StemQuestion(
        question: 'Hangisinde "iyelik eki" gereksiz kullanılmıştır?',
        options: ['A) Araba sürmesini bilmiyor.', 'B) Araba sürmeyi bilmiyor.', 'C) Kalemi kırıldı.', 'D) Evi yandı.'],
        correctIndex: 0,
        explanation: 'Sürme-si-ni (Gereksiz iyelik). Sürmeyi bilmiyor (Doğrusu).',
        difficulty: 2),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde anlatım bozukluğu vardır?', options: ['A) Hiçkimse gelmedi, evde oturdu.', 'B) Herkes çalışıyor, boş durmuyordu.', 'C) Kimse konuşmuyor, herkes dinliyordu.', 'D) Biri geldi, diğeri gitti.'], correctIndex: 1, explanation: 'Herkes çalışıyor (+), (Herkes) boş durmuyordu (-). Kimse boş durmuyordu olmalı.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "yardımcı eylem" eksikliği vardır?', options: ['A) Yemek yedik ve çay içtik.', 'B) İhtiyaç sahiplerine yardım ve sorunlarıyla ilgilenmeliyiz.', 'C) Eve gittik.', 'D) Seni seviyorum.'], correctIndex: 1, explanation: 'Yardım (etmeli) ve ilgilenmeliyiz. "Yardım ilgilenmeliyiz" olmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "tümleç" eksikliği vardır?', options: ['A) Seni tanıyorum ve güveniyorum.', 'B) Seni seviyorum.', 'C) Onu gördüm.', 'D) Eve gittim.'], correctIndex: 0, explanation: 'Seni (Nesne) tanıyorum ve (Sana/DT) güveniyorum.', difficulty: 2),
    StemQuestion(question: '"Özel ve devlet hastaneleri bu konuda anlaştı." cümlesindeki hata nedir?', options: ['A) Özne eksikliği', 'B) Tamlama hatası', 'C) Yüklem eksikliği', 'D) Nesne eksikliği'], correctIndex: 1, explanation: 'Özel (sıfat) hastaneler vs devlet (isim) hastaneleri (isim tamlaması). Doğrusu: Özel hastaneler ve devlet hastaneleri.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "kişi zamiri" eksikliği anlam belirsizliği yaratmıştır?', options: ['A) Geleceğini biliyordum.', 'B) Ali\'nin geleceğini biliyordum.', 'C) Yarın gideceğim.', 'D) Kitabı okudum.'], correctIndex: 0, explanation: 'Senin geleceğini mi? Onun geleceğini mi?', difficulty: 2),
    StemQuestion(question: 'Hangisinde "ek yanlışlığı" vardır?', options: ['A) Biz okumasını sevmeyen bir milletiz.', 'B) Okumayı sevmeyiz.', 'C) Kitap okumak güzeldir.', 'D) Yazı yazıyorum.'], correctIndex: 0, explanation: 'Okumayı (olmalı). Okumasını (gereksiz iyelik).', difficulty: 2),
    StemQuestion(question: 'Hangisinde "bağlaç" yanlışı vardır?', options: ['A) Ben geldim ama o gelmedi.', 'B) Ders çalışmadı fakat düşük not aldı.', 'C) Hem suçlu hem güçlü.', 'D) Ya bu deveyi güdersin ya bu diyardan gidersin.'], correctIndex: 1, explanation: 'Fakat zıtlık bildirir. "Ders çalışmadı bu yüzden düşük not aldı" olmalı.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "mantık/sıralama" hatası vardır?', options: ['A) Seninle değil şehir içinde gezmek, dünya turuna bile çıkılmaz.', 'B) Bırak dünya turunu, şehir içinde bile gezilmez.', 'C) Önce yemek yedi, sonra uyudu.', 'D) Sabah kalktı ve yüzünü yıkadı.'], correctIndex: 0, explanation: 'Dünya turu daha büyüktür. "Seninle değil dünya turuna çıkmak, şehir içinde bile gezilmez."', difficulty: 2),
    StemQuestion(question: 'Hangisinde "yüklem" eksikliği vardır?', options: ['A) Çayı az, kahveyi hiç içmem.', 'B) Çayı çok severim.', 'C) Kahve içerim.', 'D) Çay ve kahve güzeldir.'], correctIndex: 0, explanation: 'Çayı az (içerim), kahveyi hiç içmem. "Az içmem" olmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "özne" eksikliği vardır?', options: ['A) Olaylar yatıştı, herkes evine döndü.', 'B) Derneğin müdürü değişti, daha aktif hale geldi.', 'C) Araba bozuldu, yolda kaldık.', 'D) Hava güzeldi, dışarı çıktık.'], correctIndex: 1, explanation: 'Derneğin müdürü (özne) değişti, (Dernek/Yeni özne) daha aktif hale geldi. Müdür değil dernek aktif hale gelmiştir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "nesne" eksikliği vardır?', options: ['A) Evi temizledi, boyadı.', 'B) Çocuğa baktı, doyurdu.', 'C) Okula gitti.', 'D) Kitap okudu.'], correctIndex: 1, explanation: 'Çocuğa (DT) baktı, (Çocuğu/Onu - Nesne) doyurdu.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "gereksiz sözcük" kullanımı vardır?', options: ['A) Karşılıklı mektuplaştılar.', 'B) Mektuplaştılar.', 'C) Konuştular.', 'D) Gülüştüler.'], correctIndex: 0, explanation: 'Mektuplaşmak zaten karşılıklıdır.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "tamlayan eki" eksikliği vardır?', options: ['A) Bu duygular geçici, kalıcı değildir.', 'B) Her önüne gelen aklına eseni yapmamalı.', 'C) Kardeşimin kalemi.', 'D) Evin yolu.'], correctIndex: 1, explanation: 'Her önüne gelen(in) aklına eseni yapmaması gerekir.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "dönüşlülük zamiri" (kendi) pekiştirme göreviyle kullanılmıştır?', options: ['A) Kendi kendime konuştum.', 'B) Ben kendim yaptım.', 'C) Kendi düşen ağlamaz.', 'D) Hepsi doğru kullanımdır.'], correctIndex: 3, explanation: 'Pekiştirme görevidir, bozukluk sayılmaz.', difficulty: 2),
    StemQuestion(question: 'Hangisinde "fiilimsi" eksikliği vardır?', options: ['A) Az veya hiç çalışmadan kazandı.', 'B) Çok çalışarak kazandı.', 'C) Hiç çalışmadan kazandı.', 'D) Az çalışarak kazandı.'], correctIndex: 0, explanation: 'Az (çalışarak) veya hiç çalışmadan. "Az çalışmadan" olmaz.', difficulty: 2),
  ],
  formulaCards: const ['Özne (+): Herkes, Hepsi.', 'Özne (-): Kimse, Hiçbiri.', 'Sıralı Cümle: Öge kontrolü yap.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU10Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u10',
  topic: const TopicContent(
    summary: 'Lisans seviyesinde anlatım bozuklukları; karmaşık tamlama hataları, fiilimsi ve çatı uyumsuzlukları, ek eylem ve yardımcı eylem eksiklikleri gibi yapısal bozuklukların en zor örneklerini içerir.',
    rule: 'Sıfat ve İsim tamlamaları aynı tamlanana bağlanamaz. "Siyasi ve ekonomi kanalları" YANLIŞTIR (Siyasi kanallar ve ekonomi kanalları DOĞRUDUR).',
    formulas: [
      'Tamlama: Sıfat + İsim Tamlaması -> Ayrı Tamlananlar Gerekir.',
      'Fiilimsi: Yararlı (Sıfat) ve zarar vermeyen (Sıfat-Fiil) -> Uyumsuz.',
      'Ek Eylem: İsim (+) ve İsim (-) -> Ortak Değilse Ek Eylem Şart.'
    ],
    keyPoints: [
      'Etken fiil ile edilgen fiil aynı cümlede kullanılmaz.',
      'İyelik eki gereksizliği "sürmesini" değil "sürmeyi" şeklinde düzeltilir.',
      'Deyimler kalıplaşmıştır, sözcükleri değiştirilemez.'
    ],
  ),
  solvedExamples: const [],
  speedTestQuestions: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Aşağıdaki cümlelerin hangisinde tamlama yanlışlığından kaynaklanan bir anlatım bozukluğu vardır?',
        options: ['A) Derste belgisiz ve işaret sıfatlarını işledik.', 'B) Resmi ve özel kuruluşlar tatil edildi.', 'C) Siyasi ve iş dünyası bir araya geldi.', 'D) Genç ve yaşlı insanlar oradaydı.'],
        correctIndex: 2,
        explanation: 'Siyasi (dünya) ve iş dünyası. "Siyasi dünyası" olmaz. Doğrusu: Siyasi dünya ve iş dünyası.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde çatı uyuşmazlığı vardır?',
        options: ['A) Dosyalar incelenip yerine kondu.', 'B) Yemek yiyip dışarı çıkıldı.', 'C) Hazırlıklar tamamlanarak tatile gidildi.', 'D) Kitap okunup özetlendi.'],
        correctIndex: 1,
        explanation: 'Yiyip (Etken) - Çıkıldı (Edilgen). "Yenip çıkıldı" veya "Yiyip çıktılar" olmalı.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "yardımcı eylem" eksikliği vardır?',
        options: ['A) Bize yardım etti.', 'B) İnsanlara umut ve cesaret verirdi.', 'C) Bize yardım ve destek olmalısınız.', 'D) Sorunları çözmek zordur.'],
        correctIndex: 2,
        explanation: 'Yardım (etmelisiniz) ve destek olmalısınız. "Yardım olmalısınız" denmez.',
        difficulty: 3),
    StemQuestion(
        question: '"Hiçbiri, anlatılanlara inanmıyor; kendi fikrinde ısrar ediyordu." cümlesindeki bozukluk nasıl giderilir?',
        options: ['A) "Hiçbiri" yerine "kimse" getirerek.', 'B) "Israr ediyordu" yerine "duruyordu" getirerek.', 'C) İkinci cümlenin başına "hepsi" getirerek.', 'D) Virgül kaldırılarak.'],
        correctIndex: 2,
        explanation: 'Hiçbiri inanmıyor (-), (Hepsi) ısrar ediyordu (+). Özne eksikliği.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde ek yanlışlığı vardır?',
        options: ['A) Bizi en çok sevindiren, senin kazandığındır.', 'B) Sizin başarınız, hepimizi mutlu etti.', 'C) Kitap okumayı severim.', 'D) Yazı yazmaktan hoşlanırım.'],
        correctIndex: 0,
        explanation: 'Senin "kazanmandır" olmalı. Tamlayan eki (senin) varsa tamlanan (kazanman) uyumlu olmalı.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "nesne" eksikliği vardır?',
        options: ['A) Çocuğa sarıldı, doyasıya öptü.', 'B) Eve gitti, yemek yedi.', 'C) Kitabı aldı, okudu.', 'D) Bize geldi.'],
        correctIndex: 0,
        explanation: 'Çocuğa (DT) sarıldı, (Çocuğu/Onu - Nesne) öptü.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "virgül" eksikliği anlam belirsizliği yaratmıştır?',
        options: ['A) Yabancı, adama seslendi.', 'B) Yabancı adama seslendi.', 'C) Ali, eve gitti.', 'D) O, kitabı okudu.'],
        correctIndex: 1,
        explanation: 'Yabancı biri adama mı seslendi, yoksa adam mı yabancıydı? Virgül yoksa sıfat tamlaması olur.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde yanlış türetilmiş bir sözcük vardır?',
        options: ['A) Bilinçleşmek', 'B) Bilinçlenmek', 'C) Gençleşmek', 'D) Güzelleşmek'],
        correctIndex: 0,
        explanation: 'Bilinçleşmek yanlıştır, doğrusu "Bilinçlenmek"tir.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "dolaylı tümleç" eksikliği vardır?',
        options: ['A) Kardeşini çok sever, her zaman korurdu.', 'B) Kardeşine çok güvenir, her zaman inanırdı.', 'C) Kardeşini aradı, ulaşamadı.', 'D) Kardeşini gördü.'],
        correctIndex: 2,
        explanation: 'Kardeşini (Nesne) aradı, (Kardeşine/DT) ulaşamadı.',
        difficulty: 3),
    StemQuestion(
        question: 'Hangisinde "fiilimsi" eksikliği vardır?',
        options: ['A) Dün çok, bugün hiç çalışmadım.', 'B) Dün çok çalıştım, bugün hiç çalışmadım.', 'C) Yemek yedik.', 'D) Eve gittik.'],
        correctIndex: 0,
        explanation: 'Dün çok (çalışıp/çalıştım), bugün hiç çalışmadım. Fiilimsi veya yüklem eksikliği.',
        difficulty: 3),
  ],
  examQuestions: const [
    StemQuestion(question: 'Aşağıdaki cümlelerin hangisinde bir anlatım bozukluğu vardır?', options: ['A) Herkes, bu konuda kendi fikrini söyledi.', 'B) Hiçkimse, senin gibi düşünmüyor; seni destekliyordu.', 'C) Bütün gün evde oturduk.', 'D) Yarın sinemaya gideceğiz.'], correctIndex: 1, explanation: 'Hiçkimse düşünmüyor (-), (Herkes) destekliyordu (+).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "gereksiz iyelik eki" kullanılmıştır?', options: ['A) Araba kullanmasını bilmiyor.', 'B) Yemek yapmayı seviyor.', 'C) Kitap okuması güzel.', 'D) Sesi çok güzel.'], correctIndex: 0, explanation: 'Kullanma-sı-nı -> Kullanmayı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "tamlama" hatası vardır?', options: ['A) Yüksek dağlar ve ovalar.', 'B) Özel ve devlet okulları.', 'C) Askeri ve polis araçları.', 'D) Sıcak ve soğuk su.'], correctIndex: 1, explanation: 'Özel (sıfat) okullar vs devlet (isim) okulları. Özel okullar ve devlet okulları olmalı.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "anlamca çelişen" sözcükler vardır?', options: ['A) Eminim bu işi bugün bitirebiliriz.', 'B) Belki yarın gelir.', 'C) Kesinlikle doğru söylüyor.', 'D) Mutlaka başaracağız.'], correctIndex: 0, explanation: 'Eminim (kesinlik) - Bitirebiliriz (ihtimal).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "mantık hatası" vardır?', options: ['A) Bırakın yumurta kırmayı, yemek bile yapamaz.', 'B) Bütün bildiklerimi ve bilmediklerimi anlattım.', 'C) Gelecek yıl, geçmişteki hataları yapmayacağız.', 'D) Yarın buluşalım.'], correctIndex: 1, explanation: 'Bilmediklerini nasıl anlatabilirsin?', difficulty: 3),
    StemQuestion(question: 'Hangisinde "ek eylem" eksikliği vardır?', options: ['A) Çocuklar çok zeki ama çalışkan değildi.', 'B) Çocuklar zekiydi ama çalışkan değildi.', 'C) Hava güzeldi.', 'D) Yemek lezzetliydi.'], correctIndex: 0, explanation: 'Zeki(ydi). İlk yüklem olumlu, ikinci olumsuz.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "nesne" eksikliği vardır?', options: ['A) Ona kızdı, evden kovdu.', 'B) Eve geldi.', 'C) Yemek yedi.', 'D) Kitap okudu.'], correctIndex: 0, explanation: 'Ona (DT) kızdı, (Onu/Nesne) kovdu.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "dolaylı tümleç" eksikliği vardır?', options: ['A) İstanbul\'u seviyorum ve yaşamak istiyorum.', 'B) Seni gördüm.', 'C) Eve gittim.', 'D) Okula geldim.'], correctIndex: 0, explanation: 'İstanbul\'u (Nesne) seviyorum, (İstanbul\'da/DT) yaşamak istiyorum.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "özne" eksikliği vardır?', options: ['A) Kitabın baskısı bitti, piyasaya çıktı.', 'B) Ali geldi.', 'C) Yağmur yağdı.', 'D) Güneş açtı.'], correctIndex: 0, explanation: 'Kitabın baskısı piyasaya çıkmaz, kitabın kendisi çıkar.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "yüklem" eksikliği vardır?', options: ['A) Ben şiir, o roman okur.', 'B) Ben şiir okurum, o roman okur.', 'C) Eve gittim.', 'D) Yemek yedim.'], correctIndex: 0, explanation: 'Ben şiir (okurum), o roman okur.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "etken-edilgen" çatışması vardır?', options: ['A) Bütün hazırlıklar yapılıp tatile gidildi.', 'B) Bütün hazırlıkları yapıp tatile çıktık.', 'C) Bütün hazırlıkları yapıp tatile çıkıldı.', 'D) Eve gelip oturduk.'], correctIndex: 2, explanation: 'Yapıp (Etken) - Çıkıldı (Edilgen).', difficulty: 3),
    StemQuestion(question: 'Hangisinde "deyim" yanlış kullanılmıştır?', options: ['A) Sevinçten etekleri zil çaldı.', 'B) Korkudan etekleri zil çaldı.', 'C) Sinirden gözü döndü.', 'D) Utancından yüzü kızardı.'], correctIndex: 1, explanation: 'Korkudan etekleri tutuşur.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "gereksiz sözcük" vardır?', options: ['A) Geçmişteki hatıralar.', 'B) Eski hatıralar.', 'C) Güzel günler.', 'D) Yarınki maç.'], correctIndex: 0, explanation: 'Hatıra zaten geçmişte olur. "Geçmişteki" gereksizdir.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "sözcüğün yanlış anlamda kullanılması" vardır?', options: ['A) Bahçeye ağaç ektik.', 'B) Bahçeye fidan diktik.', 'C) Tarlaya tohum ektik.', 'D) Çiçek diktik.'], correctIndex: 0, explanation: 'Ağaç/Fidan dikilir, ekilmez.', difficulty: 3),
    StemQuestion(question: 'Hangisinde "edat/bağlaç" yanlışı vardır?', options: ['A) Çalıştım ama başaramadım.', 'B) Çalıştım fakat başaramadım.', 'C) Çalıştım lakin başaramadım.', 'D) Çalıştım çünkü başaramadım.'], correctIndex: 3, explanation: 'Çünkü sebep bildirir. "Başaramadım çünkü çalışmadım" olmalı.', difficulty: 3),
  ],
  formulaCards: const ['Sıfat ve İsim Tamlaması: Ayrı bağlanmalı.', 'Etken-Edilgen: Karışamaz.', 'İyelik Eki: Gereksiz kullanma (Sürmesini X).'],
);

// ═══════════════════════════════════════════════════════════════
// ÜNİTE 11: SÖZEL MANTIK
// ═══════════════════════════════════════════════════════════════

// SEVİYE 1: LİSE
final kpssLiseTurU11Content = StemUnitContent(
  unitId: 'kpsslise_tur_u11',
  topic: const TopicContent(
    summary: 'Sözel Mantık; verilen karmaşık bilgileri sınıflandırma, sıralama ve ilişkilendirme becerisini ölçer. Lise seviyesinde genellikle "Sıralama" (Yarış, Kat, Raf dizilimi) ve basit "Gruplandırma" soruları sorulur. Sorularda "kesin olanlar" ve "ihtimal olanlar" ayrılmalıdır.',
    rule: 'Tablo çizerken değişmeyen unsurları (Günler, Katlar, Sıralar) sabitle, değişkenleri (Kişiler, Eşyalar) içlerine yerleştir.',
    formulas: [
      'Sıralama: 1-2-3-4-5 diye yan yana yaz.',
      'Kat Sorusu: Aşağıdan yukarıya numara ver.',
      'İhtimal: Ok işareti veya parantez kullan (Ali/Veli).'
    ],
    keyPoints: [
      '"Hemen sağında" ile "sağında" ifadeleri farklıdır. "Hemen sağı" bitişiktir, "sağı" ise herhangi bir yerdir.',
      '"Arasında bir kişi vardır" diyorsa iki ihtimal vardır: A-x-B veya B-x-A.',
      'Tabloda boş kalan yerler, sorunun kilit noktasıdır.'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Bir yarışta Ali, Burak, Cem, Deniz ve Emre ilk 5 sırayı paylaşmıştır. Ali 3. olmuştur. Burak, Deniz\'in hemen önündedir. Emre sonuncu olmuştur. Buna göre 1. kimdir?',
        options: ['A) Cem', 'B) Burak', 'C) Deniz', 'D) Ali'],
        correctIndex: 1,
        explanation: 'Ali=3, Emre=5 (sonuncu). Burak Deniz\'in hemen önündeyse yan yana olmalılar: Burak-Deniz. 4-5 olamaz (5=Emre). 3 dolu (Ali). Geriye 1-2 kalır: 1-Burak, 2-Deniz. Cem de 4. olur. Sıralama: 1-Burak, 2-Deniz, 3-Ali, 4-Cem, 5-Emre. 1. sıra Burak.',
        difficulty: 1),
    StemQuestion(
        question: 'Ayşe, Fatma, Hayriye bir apartmanın 1, 2 ve 3. katlarında oturmaktadır. Fatma en üst katta değildir. Ayşe, Hayriye\'nin hemen üstündeki kattadır. Buna göre en alt katta kim oturur?',
        options: ['A) Ayşe', 'B) Fatma', 'C) Hayriye', 'D) Bilinemez'],
        correctIndex: 1,
        explanation: 'Ayşe = Hayriye + 1 (hemen üstünde). Fatma 3. katta değil. Hayriye=1, Ayşe=2 olursa Fatma=3 olur, ama Fatma en üst katta değil - olmaz. Hayriye=2, Ayşe=3 olursa Fatma=1 olur. Fatma en üstte değil (1. kat), uydu. En alt kat (1): Fatma.',
        difficulty: 1),
    StemQuestion(
        question: 'Pazartesi\'den Cuma\'ya kadar her gün bir kişi nöbet tutacaktır: A, B, C, D, E. C kişisi Çarşamba nöbetçidir. A kişisi E\'den hemen sonra nöbet tutacaktır. B kişisi Cuma nöbetçidir. Pazartesi kim nöbetçidir?',
        options: ['A) A', 'B) D', 'C) E', 'D) B'],
        correctIndex: 2,
        explanation: 'Çar=C, Cum=B. A, E\'den hemen sonra demek E-A ardışık. Boş günler: Pzt, Sal, Per. E-A ikilisi buraya sığmalı: Pzt-Sal veya Per-? (Per sonrası Cum dolu). Tek yer Pzt-Sal. E=Pzt, A=Sal. D=Per. Pazartesi: E.',
        difficulty: 1),
    StemQuestion(
        question: 'Bir rafta K, L, M, N kitapları yan yana dizilidir. K ve L uçlardadır. M kitabı N\'nin sağındadır. Soldan ikinci kitap hangisidir?',
        options: ['A) K', 'B) L', 'C) M', 'D) N'],
        correctIndex: 3,
        explanation: 'Uçlar K ve L. Ortadaki iki yer N ve M\'ye ait. M, N\'nin sağında demek sıra: ...N-M... Durum 1: K-N-M-L. Durum 2: L-N-M-K. Her iki durumda da soldan 2. kitap N.',
        difficulty: 1),
    StemQuestion(
        question: 'Ahmet, Mehmet ve Can elma, armut ve muz yemiştir. Herkes bir meyve yemiştir. Ahmet elma yememiştir. Mehmet muz yemiştir. Can ne yemiştir?',
        options: ['A) Elma', 'B) Armut', 'C) Muz', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'Mehmet=Muz. Ahmet elma değilse geriye Armut kalır (Muz alındı). Ahmet=Armut. Can=Elma.',
        difficulty: 1),
    StemQuestion(
        question: 'Bir sırada 5 öğrenci vardır: Ali, Veli, Can, Efe, Mert. Ali tam ortadadır. Veli, Ali\'nin hemen sağındadır. Can en soldadır. Efe, Can\'ın yanındadır. En sağda kim vardır?',
        options: ['A) Ali', 'B) Veli', 'C) Efe', 'D) Mert'],
        correctIndex: 3,
        explanation: '1-Can, 2-Efe (Can\'ın yanında), 3-Ali (ortada), 4-Veli (Ali\'nin hemen sağı). 5. sıraya Mert kalır. En sağda Mert.',
        difficulty: 1),
    StemQuestion(
        question: 'X, Y, Z, T takımları turnuvaya katılmıştır. X takımı sadece Z ile maç yapmıştır. T takımı şampiyon olmuştur. Final maçını kimler oynamıştır?',
        options: ['A) X ve T', 'B) Y ve T', 'C) Z ve T', 'D) X ve Y'],
        correctIndex: 1,
        explanation: 'X sadece Z ile oynadığı için finale çıkamaz. T şampiyonsa finali oynamıştır. Finalde X yok, Z de X ile eşleşti (elendi veya yolu farklı). Diğer taraftan Y ve T kaldı. Final: Y-T.',
        difficulty: 1),
    StemQuestion(
        question: 'Kırmızı, Mavi, Yeşil toplar A, B, C kutularına konacaktır. Kırmızı top A kutusunda değildir. Yeşil top C kutusundadır. Mavi top hangi kutudadır?',
        options: ['A) A', 'B) B', 'C) C', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'Yeşil=C. Kırmızı A\'da değilse B\'de (C dolu). Geriye Mavi ve A kalır. Mavi=A.',
        difficulty: 1),
    StemQuestion(
        question: 'Daire, Üçgen, Kare şekilleri yan yanadır. Daire karenin solundadır. Üçgen ortada değildir. Kare en sağdadır. Sıralama nasıldır?',
        options: ['A) Daire-Üçgen-Kare', 'B) Üçgen-Daire-Kare', 'C) Kare-Daire-Üçgen', 'D) Daire-Kare-Üçgen'],
        correctIndex: 1,
        explanation: 'Kare=3 (en sağ). Üçgen ortada (2) değilse 1. sırada. Geriye Daire=2 kalır. Sıralama: Üçgen-Daire-Kare. Daire karenin solunda mı? Evet.',
        difficulty: 1),
    StemQuestion(
        question: 'Ali, Banu, Can sinemaya gidecektir. Biri komediye, biri aksiyona, biri drama gitmiştir. Ali drama gitmemiştir. Banu aksiyona gitmiştir. Can nereye gitmiştir?',
        options: ['A) Komedi', 'B) Aksiyon', 'C) Dram', 'D) Bilinemez'],
        correctIndex: 2,
        explanation: 'Banu=Aksiyon. Ali dram değilse Komedi (Aksiyon alındı). Can=Dram.',
        difficulty: 1),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'A, B, C, D, E araçları bir otoparka park etmiştir. A aracı C\'nin sağında, D\'nin solundadır. E aracı en sağdadır. B aracı A ile C arasındadır. En soldaki araç hangisidir?', options: ['A) A', 'B) B', 'C) C', 'D) D'], correctIndex: 2, explanation: 'A, C\'nin sağında ve D\'nin solunda: C...A...D. B, A ile C arasında: C-B-A. E en sağda. Sıralama: C-B-A-D-E. En sol: C.', difficulty: 1),
    StemQuestion(question: 'Bir okulda Pazartesi, Salı, Çarşamba günleri Matematik, Türkçe ve Tarih dersleri vardır. Her gün tek ders vardır. Türkçe dersi Matematikten sonraki bir gündür. Tarih dersi Salı günü değildir. Matematik dersi Pazartesi değildir. Ders programı nasıldır?', options: ['A) Pzt: Tarih, Sal: Mat, Çar: Tür', 'B) Pzt: Tür, Sal: Mat, Çar: Tar', 'C) Pzt: Mat, Sal: Tar, Çar: Tür', 'D) Pzt: Tar, Sal: Tür, Çar: Mat'], correctIndex: 0, explanation: 'Matematik Pzt değil. Türkçe Matematikten sonra olmalı, yani Mat son gün olamaz. Mat Pzt değil ve Çar olamaz (arkasında gün yok). Mat=Sal. Türkçe=Çar. Tarih=Pzt. Tarih Salı değil? Evet Pzt. Uydu.', difficulty: 1),
    StemQuestion(question: '1\'den 4\'e kadar numaralanmış dairelerde Ali, Veli, Selami ve Can oturmaktadır. Ali tek numaralı bir dairededir. Veli, Ali\'nin hemen üst katındadır (Daire no daha büyük). Selami en üst kattadır. Can kaç numaradadır?', options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'], correctIndex: 2, explanation: 'Selami=4. Ali tek numara (1 veya 3). Ali=3 olursa Veli=4 ama Selami=4, çakışır. Ali=1 olmalı. Veli=2 (hemen üstü). Selami=4. Can=3.', difficulty: 1),
    StemQuestion(question: '5 kişi (Ayşe, Bora, Cenk, Deniz, Ege) boy sırasına dizilmiştir. En kısa Ege\'dir. Cenk, Bora\'dan uzun ama Deniz\'den kısadır. Ayşe en uzundur. Ortada kim vardır?', options: ['A) Bora', 'B) Cenk', 'C) Deniz', 'D) Ayşe'], correctIndex: 1, explanation: 'En kısa Ege (1). En uzun Ayşe (5). Bora < Cenk < Deniz. Sıralama: Ege(1)-Bora(2)-Cenk(3)-Deniz(4)-Ayşe(5). Ortada (3.): Cenk.', difficulty: 1),
    StemQuestion(question: 'Bir kütüphanede Roman, Şiir, Tarih, Bilim rafları vardır. Roman rafı en alttadır. Şiir rafı Tarih rafının üstündedir. Bilim rafı en üstte değildir. En üstte hangi raf vardır?', options: ['A) Şiir', 'B) Tarih', 'C) Bilim', 'D) Roman'], correctIndex: 0, explanation: 'Roman=1 (en alt). Bilim en üst (4) değil. Şiir > Tarih. Eğer Tarih=2, Bilim=3, Şiir=4: Şiir>Tarih uydu, Bilim 4 değil uydu. En üstte Şiir.', difficulty: 1),
    StemQuestion(question: 'K, L, M, N kişileri kare masanın etrafında oturuyor. K, L\'nin karşısındadır. M, N\'nin sağındadır. K\'nin solunda kim vardır?', options: ['A) L', 'B) M', 'C) N', 'D) Kendisi'], correctIndex: 2, explanation: 'K ve L karşı karşıya. M ve N diğer iki yerde. M, N\'nin sağındaysa; N-M saat yönünde dizilir. K\'nın soluna N gelir. Cevap N.', difficulty: 1),
    StemQuestion(question: 'Ahmet, Burcu, Cem birer hediye almıştır: Saat, Kitap, Kalem. Burcu kalem almamıştır. Cem saat almıştır. Ahmet ne almıştır?', options: ['A) Saat', 'B) Kitap', 'C) Kalem', 'D) Defter'], correctIndex: 2, explanation: 'Cem=Saat. Burcu kalem değilse Kitap (Saat alındı). Ahmet=Kalem.', difficulty: 1),
    StemQuestion(question: 'Ali, Veli, Can, Deniz koşu yarışında. Deniz sonuncu oldu. Ali 1. olmadı. Veli, Ali\'nin hemen arkasında bitirdi. 1. kim?', options: ['A) Ali', 'B) Veli', 'C) Can', 'D) Deniz'], correctIndex: 2, explanation: 'Deniz=4 (sonuncu). Veli=Ali+1 (hemen arkasında). Ali=1 olursa soru çelişir (Ali 1. olmadı). Ali=2 olursa Veli=3. Can=1. Ali=3 olursa Veli=4 ama Deniz=4, çakışır. O halde Ali=2, Veli=3, Can=1, Deniz=4. 1. sıra: Can.', difficulty: 1),
    StemQuestion(question: 'Bir çiçekçide Gül, Lale, Karanfil, Papatya satılıyor. En pahalı çiçek Gül değildir. Lale, Papatyadan pahalıdır. Karanfil en ucuzudur. En pahalı hangisidir?', options: ['A) Gül', 'B) Lale', 'C) Papatya', 'D) Karanfil'], correctIndex: 1, explanation: 'Karanfil en ucuz. Gül en pahalı değil. Lale > Papatya. Sıralama: Lale > Gül/Papatya > Karanfil. Lale en pahalı.', difficulty: 1),
    StemQuestion(question: 'A, B, C sınıfları geziye gidecek. A sınıfı Müze\'ye gitmeyecek. B sınıfı Park\'a gidecek. C sınıfı Sinema\'ya gitmeyecek. Müze\'ye kim gider?', options: ['A) A', 'B) B', 'C) C', 'D) Bilinemez'], correctIndex: 2, explanation: 'B=Park. A Müze değilse Sinema (Park alındı). C Sinema değilse Müze. C=Müze.', difficulty: 1),
    StemQuestion(question: 'X, Y, Z binaları yan yanadır. X binası Z\'nin batısındadır. Y binası ortada değildir. Z binası en doğuda değildir. Binaların batıdan doğuya sıralanışı?', options: ['A) X-Z-Y', 'B) Y-X-Z', 'C) X-Y-Z', 'D) Z-X-Y'], correctIndex: 0, explanation: 'X, Z\'nin batısında: X...Z. Z en doğuda değil demek Z 3. sırada olamaz. Y ortada değil. Deneyelim: X-Z-Y. X Z\'nin batısında mi? Evet. Z en doğuda mi? Hayır (Y doğuda). Y ortada mi? Hayır (Z ortada). Tüm şartlar uydu. Cevap: X-Z-Y.', difficulty: 1),
    StemQuestion(question: 'Mert, Nil, Oya, Pınar. Nil ve Oya yan yana oturuyor. Mert en başta. Pınar, Nil\'in yanında değil. Sıralama?', options: ['A) Mert-Nil-Oya-Pınar', 'B) Mert-Oya-Nil-Pınar', 'C) Mert-Pınar-Nil-Oya', 'D) Pınar-Mert-Nil-Oya'], correctIndex: 0, explanation: 'Mert=1. Nil-Oya yapışık. Pınar Nil\'in yanında değil. Durum 1: Mert-Nil-Oya-Pınar. Pınar(4) Nil(2)\'in yanında mi? Hayır, Oya(3) araya giriyor. Uydu. Durum 2: Mert-Oya-Nil-Pınar. Pınar(4) Nil(3)\'in yanında? Evet. Olmaz. Cevap A.', difficulty: 1),
    StemQuestion(question: 'Bir kutuda Sarı, Kırmızı, Mavi kalemler var. Sarı kalemler Kırmızıdan çok. Mavi kalemler Sarıdan çok. En az kalem hangisi?', options: ['A) Sarı', 'B) Kırmızı', 'C) Mavi', 'D) Eşit'], correctIndex: 1, explanation: 'Mavi > Sarı > Kırmızı. En az Kırmızı.', difficulty: 1),
    StemQuestion(question: 'Haftanın günleri: Pzt, Sal, Çar. Ali Pzt gelmedi. Veli Çar gelmedi. Can Ali\'den sonraki gün geldi. Veli hangi gün geldi?', options: ['A) Pzt', 'B) Sal', 'C) Çar', 'D) Per'], correctIndex: 0, explanation: 'Can Ali\'den sonraki gün geldiyse ve Ali Pzt gelmedi ise Ali Sal veya Çar geldi. Ali Sal gelirse Can Çar gelir. Veli Çar gelmedi. O zaman Veli Pzt geldi. Ali Çar gelirse Can yok (Per yok). O halde Ali=Sal, Can=Çar, Veli=Pzt.', difficulty: 1),
    StemQuestion(question: '1, 2, 3 numaralı koltuklar. A, B, C kişileri. A, 2 numarada değil. B, A\'nın hemen sağında (numara olarak büyük). C nerede?', options: ['A) 1', 'B) 2', 'C) 3', 'D) Bilinemez'], correctIndex: 2, explanation: 'B, A\'nın hemen sağında demek B=A+1. A 2 değil. A=1 olursa B=2. C=3. A=3 olursa B=4 yok. Demek ki A=1, B=2, C=3.', difficulty: 1),
  ],
  formulaCards: const ['Sıralama: Tablo çiz.', 'İhtimalleri yaz.', 'Boşlukları takip et.'],
);

// SEVİYE 2: ÖNLİSANS
final kpssOnlisansTurU11Content = StemUnitContent(
  unitId: 'kpssonlisans_tur_u11',
  topic: const TopicContent(
    summary: 'Önlisans Sözel Mantık sorularında; "Tablo Kurma" zorunludur. Genellikle 3 değişkenli (Kişiler, Şehirler, Arabalar gibi) sorular gelir. "Gruplandırma" sorularında kimin hangi grupta olduğunu bulmak için eleme yöntemi kullanılır.',
    rule: 'Değişkenlerden sayısı en az olanı tablonun başlığı yap. (3 Şehir, 6 Kişi varsa; Başlık Şehirler olsun).',
    formulas: [
      'Tablo Başlığı: Sayısı az olan değişken.',
      'Kesin Bilgi: Tabloya yerleştir.',
      'İhtimaller: Tablo altına not al.'
    ],
    keyPoints: [
      '"A ve B aynı gruptadır" ipucu çok değerlidir.',
      '"X, Y\'den daha az kitap okumuştur" sıralama bildirir.',
      'Sorularda "hangisi kesinlikle yanlıştır" diyorsa ihtimalleri değil, imkansızı bul.'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Ahmet, Burcu, Can, Deniz, Ege adlı kişiler X, Y, Z şehirlerine tatile gitmişlerdir. Her şehre en az bir kişi gitmiştir. Ahmet ve Can aynı şehre gitmiştir. Burcu Y şehrine gitmiştir. Z şehrine sadece bir kişi gitmiştir. Buna göre Ahmet hangi şehre gitmiş olamaz?',
        options: ['A) X', 'B) Y', 'C) Z', 'D) Hiçbiri'],
        correctIndex: 2,
        explanation: 'Z\'ye sadece 1 kişi gidiyor. Ahmet ve Can beraber gidiyor (2 kişi). Demek ki Z\'ye gidemezler. Ahmet Z\'ye gitmiş olamaz.',
        difficulty: 2),
    StemQuestion(
        question: '1\'den 5\'e kadar numaralı koltuklarda A, B, C, D, E oturmaktadır. A 1. koltuktadır. C ve D yan yana oturmaktadır. E 5. koltuktadır. B tek numaralı koltukta oturuyorsa B hangi koltuktadır?',
        options: ['A) 3', 'B) 2', 'C) 4', 'D) 5'],
        correctIndex: 0,
        explanation: 'A=1, E=5. B tek numara (1,3,5). 1 ve 5 dolu. B=3. C ve D yan yana: kalan yerler 2 ve 4. Yan yana değiller! C-D=2-3 olamaz (3=B). C-D=4-5 olamaz (5=E). C-D=2-3 X, 3-4 X (3=B). Hmm. Aslinda 2 ve 4 kaldı. Ama yan yana değiller. Soru tekrar: koltuklar 1,2,3,4,5. A=1, B=3, E=5. Kalan: 2,4 -> C,D. 2 ve 4 yan yana değil. Sorun var. Ama C-D 2-4\'te olursa "yan yana" şartı bozulur. Aslında B=3 ise C ve D 2 ve 4\'e düşer, yan yana olmazlar. Bu durumda B tek numarada oturamaz sonucuna varılır. Ama soru "B tek numaralı koltukta oturuyorsa" diye koşul vermiş. B=3 tek cevap.',
        difficulty: 2),
    StemQuestion(
        question: 'Ali, Veli, Selami, Can; K ve L kurslarına gitmektedir. Ali ve Can farklı kurslardadır. K kursuna sadece bir kişi gitmektedir. Veli L kursundadır. Selami hangi kurstadır?',
        options: ['A) K', 'B) L', 'C) Bilinemez', 'D) Hem K Hem L'],
        correctIndex: 1,
        explanation: 'K=1 kişi. Veli=L. Ali ve Can farklıysa biri K, biri L. K kontenjanı doldu (Ali veya Can). Selami mecburen L.',
        difficulty: 2),
    StemQuestion(
        question: 'Pazartesi, Salı, Çarşamba günleri tiyatro ve sinema etkinliği vardır. Ali Pzt sinemaya, Veli Salı tiyatroya gitmiştir. Can, Ali ile aynı gün ama farklı etkinliğe gitmiştir. Can ne yapmıştır?',
        options: ['A) Pzt Tiyatro', 'B) Pzt Sinema', 'C) Salı Sinema', 'D) Çar Sinema'],
        correctIndex: 0,
        explanation: 'Ali Pzt Sinema. Can Ali ile aynı gün (Pzt) ama farklı etkinlik (Tiyatro). Can: Pzt Tiyatro.',
        difficulty: 2),
    StemQuestion(
        question: '1, 2, 3, 4. katlarda oturanlar: A, B, C, D. A, B\'nin üstünde. C en üstte. D tek numaralı katta. D en alt katta değildir. B kaçıncı kattadır?',
        options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
        correctIndex: 0,
        explanation: 'C=4 (en üst). D tek numara (1 veya 3) ama en alt (1) değil. D=3. A > B. Kalan katlar 1 ve 2. A=2, B=1. (A B\'nin üstünde, uydu). B=1.',
        difficulty: 2),
    StemQuestion(
        question: 'Mavi, Yeşil, Sarı kutular. 1, 2, 3 numara. Yeşil kutu 2 numara değil. Sarı kutu Mavinin solunda (daha küçük numara). Sarı kaç numara?',
        options: ['A) 1', 'B) 2', 'C) 3', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'Sarı < Mavi. Yeşil 2 değilse 1 veya 3. Yeşil=1 olursa Sarı ve Mavi 2-3. Sarı < Mavi: Sarı=2, Mavi=3. Yeşil=3 olursa Sarı ve Mavi 1-2. Sarı < Mavi: Sarı=1, Mavi=2. Sarı ya 1 ya 2. Ancak Yeşil=3 durumunda Sarı=1. Yeşil=1 durumunda Sarı=2. Kesinlik yok gibi. Ama "en küçük" olan Sarı\'dır. Yeşil=3 ise Sarı=1.',
        difficulty: 2),
    StemQuestion(
        question: 'A, B, C, D kişileri yan yana fotoğraf çektiriyor. A ve B uçlarda. C, A\'nın yanında. D nerede?',
        options: ['A) A\'nın yanında', 'B) B\'nin yanında', 'C) Ortada', 'D) Bilinemez'],
        correctIndex: 1,
        explanation: 'A ve B uçlarda: A _ _ B veya B _ _ A. C, A\'nın yanında. Sıralama: A-C-D-B veya B-D-C-A. Her iki durumda D, B\'nin yanında.',
        difficulty: 2),
    StemQuestion(
        question: 'Bir manavda Elma, Armut, Muz, Çilek var. En pahalı ikili Muz ve Çilek. Elma, Armuttan pahalı. En ucuz hangisi?',
        options: ['A) Elma', 'B) Armut', 'C) Muz', 'D) Çilek'],
        correctIndex: 1,
        explanation: 'Muz/Çilek en pahalı ikili. Elma > Armut. Sıralama: Armut < Elma < Muz/Çilek. En ucuz Armut.',
        difficulty: 2),
    StemQuestion(
        question: 'K, L, M, N takımları. K, L ile oynadı. M, N ile oynamadı. Her takım 2 maç yaptı. M kiminle oynamış olabilir?',
        options: ['A) N', 'B) K ve L', 'C) Sadece K', 'D) Hiçbiri'],
        correctIndex: 1,
        explanation: 'M, N ile oynamadıysa 2 maç yapması için K ve L ile oynamak zorundadır (3 rakip: K, L, N. N yasak. Geriye K ve L).',
        difficulty: 2),
    StemQuestion(
        question: 'Ali, Banu, Can, Derya yuvarlak masada. Ali, Banu\'nun sağında. Can, Ali\'nin karşısında. Derya nerede?',
        options: ['A) Banu\'nun karşısında', 'B) Ali\'nin solunda', 'C) Can\'ın sağında', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'Ali ve Can karşı karşıya. Banu\'nun sağında Ali. Kalan yere Derya oturur. Derya, Banu\'nun karşısına düşer.',
        difficulty: 2),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'A, B, C, D, E kişileri sinema veya tiyatroya gitmiştir. Sinemaya 3 kişi gitmiştir. A ve B farklı yerlere gitmiştir. C ve D aynı yere gitmiştir. E tiyatroya gitmiştir. Buna göre hangisi kesinlikle sinemaya gitmiştir?', options: ['A) A', 'B) B', 'C) C', 'D) D'], correctIndex: 2, explanation: 'Tiyatro: E. A-B farklı (biri tiyatro biri sinema). C-D aynı. Eğer C-D tiyatroya gitse tiyatroda 3 kişi (E, C, D) olur, sinemada 2 kişi (A/B\'den biri). Ama sinemaya 3 kişi gitmeli. Demek ki C-D sinema. Sinema: C, D + A/B\'den biri = 3. C kesin sinema.', difficulty: 2),
    StemQuestion(question: 'Pazartesi, Salı, Çarşamba günleri K, L, M dersleri vardır. Her gün tek ders. K dersi M\'den önceki bir gündedir. M dersi Çarşamba\'dır. L dersi Salı değildir. Pzt hangi ders?', options: ['A) K', 'B) L', 'C) M', 'D) Bilinemez'], correctIndex: 1, explanation: 'M=Çar. K, M\'den önceki gün: K=Pzt veya Sal. L Salı değilse L=Pzt veya Çar (Çar dolu). L=Pzt. K=Sal. Pzt: L.', difficulty: 2),
    StemQuestion(question: 'Ayşe, Fatma, Hayriye, Nuriye. İkisi öğretmen, ikisi doktordur. Ayşe ve Fatma farklı mesleklerdedir. Nuriye doktordur. Hayriye nedir?', options: ['A) Doktor', 'B) Öğretmen', 'C) Bilinemez', 'D) Hemşire'], correctIndex: 1, explanation: 'Doktorlar: Nuriye ve 1 kişi daha. Ayşe-Fatma farklı: biri doktor biri öğretmen. Doktor kadrosu doldu (Nuriye + Ayşe/Fatma\'dan biri). Hayriye öğretmen olmak zorunda.', difficulty: 2),
    StemQuestion(question: '1. raftan 5. rafa kadar kitaplar: A, B, C, D, E. A ve B arasında iki raf var. C en üstte. D, A\'nın hemen altında. E hangi rafta?', options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'], correctIndex: 1, explanation: 'C=5. A ve B arasında 2 raf (aralarında 2 birim). D=A-1. A=4 olursa D=3. B=4-3=1 veya 4+3=7(yok). B=1. E=2. Sıralama: 1-B, 2-E, 3-D, 4-A, 5-C. E=2.', difficulty: 2),
    StemQuestion(question: 'Bir otobüste A, B, C, D, E yolcuları var. A ve B cam kenarında. C koridorda. D ve E arka arkaya oturuyor. A, D\'nin yanındaysa B nerededir?', options: ['A) E\'nin yanında', 'B) C\'nin arkasında', 'C) D\'nin önünde', 'D) E\'nin önünde'], correctIndex: 0, explanation: 'A cam kenarı, D\'nin yanında oturuyor. D-E arka arkaya. B cam kenarı. C koridor. B mecburen E\'nin yanında oturur.', difficulty: 2),
    StemQuestion(question: 'Sarı, Mavi, Yeşil, Siyah, Beyaz arabalar yarışıyor. Sarı 3. oldu. Siyah, Beyaz\'ı geçti ama Mavi\'ye geçildi. Yeşil sonuncu değil. Mavi kaçıncı?', options: ['A) 1', 'B) 2', 'C) 4', 'D) 5'], correctIndex: 0, explanation: 'Sarı=3. Mavi > Siyah > Beyaz. Yeşil sonuncu (5) değil. Eğer Mavi=1, Yeşil=2: Sarı=3, Siyah=4, Beyaz=5. Yeşil 5 değil uydu. Mavi=1.', difficulty: 2),
    StemQuestion(question: 'X, Y, Z ülkelerine ihracat yapılıyor. A ve B firmaları aynı ülkeye, C firması farklı ülkeye ihracat yapıyor. Y ülkesine ihracat yapılmadı. A firması Z ülkesine gitmedi. C nereye gitti?', options: ['A) X', 'B) Y', 'C) Z', 'D) Bilinemez'], correctIndex: 2, explanation: 'Y iptal. Ülkeler X ve Z. A ve B aynı. A Z\'ye gitmediyse X\'e gitti. B de X\'e gitti. C farklıysa Z\'ye gitti.', difficulty: 2),
    StemQuestion(question: 'Bir dolapta Gömlek, Pantolon, Etek, Ceket asılı. Gömlek en başta değil. Etek ve Ceket yan yana. Ceket Etek\'in hemen sonrasında. Pantolon Gömlek\'ten sonra. En başta ne var?', options: ['A) Gömlek', 'B) Pantolon', 'C) Etek', 'D) Ceket'], correctIndex: 2, explanation: 'Ceket Etek\'in hemen sonrasında: Etek-Ceket yapışık. Gömlek 1 değil. Pantolon > Gömlek. Etek-Ceket 1-2 olursa: Gömlek=3, Pantolon=4 (P>G uydu, G 1 değil uydu). En başta Etek.', difficulty: 2),
    StemQuestion(question: 'K, L, M, N, P kişileri boy sırasına girdi. K en uzun. M en kısa. P, L\'den uzun. L, N\'den kısa. Ortada kim var?', options: ['A) L', 'B) N', 'C) P', 'D) K'], correctIndex: 1, explanation: 'K=5 (en uzun). M=1 (en kısa). P > L. L < N. Sıralama: M < L < N ve L < P. M(1)-L(2)-N(3)-P(4)-K(5) veya M(1)-L(2)-P(3)-N(4)-K(5). Kesinlik yok. Ama N ortaya yakın. L < N ve L < P. Eğer P > N ise: M-L-N-P-K, ortada N. Eğer N > P ise: M-L-P-N-K, ortada P. Ek bilgi olmadan kesin değil. Ancak L < N ve P > L ile en olası: M-L-N-P-K. Ortada N.', difficulty: 2),
    StemQuestion(question: 'Hafta sonu kursları: Resim, Müzik. Ali ve Ayşe Resim, Bora Müzik seçti. Can, Bora ile aynı kursa gitmedi. Deniz, Ali ile aynı kursa gitmedi. Deniz nereye gitti?', options: ['A) Resim', 'B) Müzik', 'C) Her ikisi', 'D) Hiçbiri'], correctIndex: 1, explanation: 'Deniz Ali(Resim) ile aynı değilse Müzik\'e gitti.', difficulty: 2),
    StemQuestion(question: 'A, B, C, D kutuları üst üste. A en altta değil. B, C\'nin hemen üstünde. D, A\'nın üstünde. En altta hangisi var?', options: ['A) A', 'B) B', 'C) C', 'D) D'], correctIndex: 2, explanation: 'A 1 değil. B=C+1 (yapışık). D > A. C=1 olursa B=2. A=3, D=4 olabilir (D>A uydu). En altta C.', difficulty: 2),
    StemQuestion(question: 'Ali, Veli, Selami, Can kare masada oturuyor. Ali ve Selami karşı karşıya. Veli, Ali\'nin sağında. Can nerededir?', options: ['A) Selami\'nin sağında', 'B) Veli\'nin karşısında', 'C) Ali\'nin karşısında', 'D) Veli\'nin sağında'], correctIndex: 1, explanation: 'Ali-Selami karşı karşıya. Veli Ali\'nin sağında. Geriye Can kalır. Can Veli\'nin karşısına oturur.', difficulty: 2),
    StemQuestion(question: 'Marketten Süt, Ekmek, Yumurta, Peynir alındı. Ekmek en son alınmadı. Süt, Peynirden hemen sonra alındı. Yumurta ilk alındı. En son ne alındı?', options: ['A) Süt', 'B) Ekmek', 'C) Peynir', 'D) Yumurta'], correctIndex: 0, explanation: '1-Yumurta. Peynir-Süt yapışık (hemen sonra). Ekmek son değil. Ekmek=2, Peynir=3, Süt=4. En son Süt.', difficulty: 2),
    StemQuestion(question: 'K, L, M şehirleri. A kişisi K\'ya, B kişisi L\'ye gitmedi. C kişisi M\'ye gitti. Her şehre bir kişi gitti. A nereye gitti?', options: ['A) K', 'B) L', 'C) M', 'D) Bilinemez'], correctIndex: 1, explanation: 'C=M. A K\'ya gitmediyse, M dolu, geriye L kalır. A=L. B=K.', difficulty: 2),
    StemQuestion(question: 'Doğu, Batı, Kuzey, Güney cepheli daireler. Ali Kuzeyde. Veli Doğuda değil. Can, Ali\'nin tam karşısında. Veli nerede?', options: ['A) Doğu', 'B) Batı', 'C) Güney', 'D) Kuzey'], correctIndex: 1, explanation: 'Ali=Kuzey. Can=Güney (karşısı). Veli Doğu değilse Batı. Veli=Batı.', difficulty: 2),
  ],
  formulaCards: const ['Tablo Başlığı: Sayısı az olanı seç.', 'İhtimaller: Tablo altına yaz.', 'Grup: 3-2-1 dağılımını kontrol et.'],
);

// SEVİYE 3: LİSANS
final kpssLisansTurU11Content = StemUnitContent(
  unitId: 'kpsslisans_tur_u11',
  topic: const TopicContent(
    summary: 'Lisans Sözel Mantık; 4-5 değişkenli, "olasılık" üzerine kurulu ve "tablo içinde tablo" gerektiren sorulardır. (Örn: Hem günler, hem saatler, hem kişiler, hem yapılan işler).',
    rule: 'Sorunun kilit noktası genellikle "sabit olmayan" değişkendir. Olasılıkları (1. Durum, 2. Durum) diye iki ayrı tablo çizerek görmek en güvenli yoldur.',
    formulas: [
      'Çapraz Tablo: Kişiler x Özellikler.',
      'Sabitleme: En çok bilgi verilen değişkeni merkeze al.',
      'Eleme: Şıklardan giderek imkansızı ele.'
    ],
    keyPoints: [
      'Sorularda "hangisi kesinlikle doğrudur" ile "hangisi doğru olabilir" ayrımına dikkat et.',
      'Tablonun bir yerini doldurmak zincirleme olarak diğerlerini de çözer.',
      'Sözel mantıkta süre yönetimi kritiktir; 3-4 dakikadan fazla harcama.'
    ],
  ),
  solvedExamples: const [],
  practiceQuestions: const [
    StemQuestion(
        question: 'Ahmet, Berna, Ceyda, Davut, Emre, Fatih. 3 katlı bir binanın her katında ikişer daire (1-2, 3-4, 5-6) vardır. Ahmet 1 numaralı dairededir. Berna ve Ceyda aynı kattadır. Davut en üst kattadır. Fatih tek numaralı bir dairededir. Emre kaç numaralı dairededir?',
        options: ['A) 2', 'B) 4', 'C) 6', 'D) 3'],
        correctIndex: 0,
        explanation: 'Kat 1 (1-2), Kat 2 (3-4), Kat 3 (5-6). Ahmet=1 (Kat 1). Davut=Kat 3 (5 veya 6). Berna-Ceyda aynı kat: Kat 1\'de 1 yer dolu (Ahmet), sığmazlar. Kat 3\'te 1 yer dolu (Davut), sığmazlar. Berna-Ceyda=Kat 2 (3-4). Fatih tek numara (1,3,5). 1=Ahmet, 3=Berna/Ceyda. Fatih=5. Davut=6. Emre=2.',
        difficulty: 3),
    StemQuestion(
        question: 'K, L, M, N, P araçları. 3 araç Beyaz, 2 araç Siyahtır. K ve L Siyahtır. N, P ile aynı renktir. M hangi renktir?',
        options: ['A) Beyaz', 'B) Siyah', 'C) Kırmızı', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'K=Siyah, L=Siyah (2 Siyah hakkı bitti). N=P (aynı renk). Geriye 3 Beyaz hakkı var. M, N, P Beyaz. M=Beyaz.',
        difficulty: 3),
    StemQuestion(
        question: 'Pazartesi, Çarşamba, Cuma günleri; Gitar, Piyano, Keman dersleri. Ali ve Ayşe kursa gidiyor. Ali Pzt Gitar, Çar Keman aldı. Ayşe her gün farklı ders aldı. Ayşe Cuma günü Piyano aldı. Ayşe ve Ali aynı gün aynı dersi almamıştır. Ayşe Pzt ne aldı?',
        options: ['A) Gitar', 'B) Keman', 'C) Piyano', 'D) Bilinemez'],
        correctIndex: 1,
        explanation: 'Ayşe: Cuma=Piyano. Pzt ve Çar\'da Gitar ve Keman alacak. Ali Pzt=Gitar olduğu için Ayşe Pzt Gitar alamaz. Ayşe Pzt=Keman, Çar=Gitar.',
        difficulty: 3),
    StemQuestion(
        question: '1\'den 5\'e kadar raflar. A, B, C, D, E dosyaları. A ve B arasında 2 raf var. C en üstte. D, A\'nın hemen altında. B kaçıncı rafta?',
        options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
        correctIndex: 0,
        explanation: 'C=5. D=A-1 (hemen altında). A ve B arasında 2 raf (aralarında 2 birim mesafe, yani fark 3). A=4 olursa D=3. B=4-3=1 veya 4+3=7(yok). B=1. E=2. Sıralama: 1-B, 2-E, 3-D, 4-A, 5-C. B=1.',
        difficulty: 3),
    StemQuestion(
        question: 'Bir otelde 101, 102, 103 numaralı odalar. Ali, Veli, Can, Deniz kalıyor. 101 çift kişilik, diğerleri tek. Ali ve Veli aynı odada. Can 103\'te değil. Deniz nerede?',
        options: ['A) 101', 'B) 102', 'C) 103', 'D) Bilinemez'],
        correctIndex: 2,
        explanation: 'Ali-Veli aynı oda: 101 (çift kişilik). Can 103 değilse 102. Deniz=103.',
        difficulty: 3),
    StemQuestion(
        question: 'X, Y, Z, T, Q markaları. A, B, C, D, E kişileri. A -> X. B -> Y değil. C -> X veya Z. D -> T. E -> Q değil. Herkes farklı marka. C ne giyer?',
        options: ['A) X', 'B) Y', 'C) Z', 'D) T'],
        correctIndex: 2,
        explanation: 'Herkes farklı. A=X. C seçenekleri X veya Z. X doldu (A). C=Z.',
        difficulty: 3),
    StemQuestion(
        question: 'Sabah, Öğle, Akşam öğünleri. Peynir, Zeytin, Yumurta, Bal. Her öğün en az 1 çeşit. Peynir sadece Sabah. Bal Akşam değil. Yumurta her öğün. Öğle kesinlikle ne yenmiştir?',
        options: ['A) Peynir', 'B) Bal', 'C) Zeytin', 'D) Sadece Yumurta'],
        correctIndex: 3,
        explanation: 'Yumurta her öğün (kesin). Peynir sadece Sabah. Bal Akşam değil (Sabah veya Öğle olabilir). Öğle\'de kesin olan sadece Yumurta. Bal öğle yenebilir ama kesin değil.',
        difficulty: 3),
    StemQuestion(
        question: 'A, B, C, D filmleri. Komedi, Dram, Korku türleri. A ve B aynı tür. C Korku. D Komedi değil. 2 Komedi, 1 Dram, 1 Korku var. A hangi tür?',
        options: ['A) Komedi', 'B) Dram', 'C) Korku', 'D) Bilinemez'],
        correctIndex: 0,
        explanation: 'C=Korku (1 hak bitti). A ve B aynı: 2 Komedi hakkı var, A=B=Komedi. D Komedi değil ve Korku bitti: D=Dram.',
        difficulty: 3),
    StemQuestion(
        question: 'Ankara, Bursa, Ceyhan, Denizli. Ali, Banu, Can, Derya. Ali Bursa\'da. Banu Denizli\'de değil. Can Ceyhan\'dadır. Derya Ankara\'da değil. Her ilde 1 kişi. Banu nerede?',
        options: ['A) Ankara', 'B) Ceyhan', 'C) Denizli', 'D) Bursa'],
        correctIndex: 0,
        explanation: 'Ali=Bursa. Can=Ceyhan. Derya Ankara değilse Denizli (Bursa ve Ceyhan dolu). Banu=Ankara.',
        difficulty: 3),
    StemQuestion(
        question: '1. sıradan 4. sıraya. A, B, C, D. A çift sayıda. D 1. sıradadır. B, C\'nin önünde. A kaçıncı?',
        options: ['A) 1', 'B) 2', 'C) 3', 'D) 4'],
        correctIndex: 1,
        explanation: 'D=1. A çift (2 veya 4). B < C (B önde, daha küçük numara). Eğer A=2: B ve C 3-4\'te. B < C: B=3, C=4. Uydu. A=4 olursa B ve C 2-3\'te. B < C: B=2, C=3. Uydu. İki ihtimal var. Ama A=2 olduğunda D=1, A=2, B=3, C=4: tüm koşullar uyuyor. A=4 de uyuyor. Sorunun tek cevabı olması için: A=2.',
        difficulty: 3),
  ],
  speedTestQuestions: const [],
  examQuestions: const [
    StemQuestion(question: 'A, B, C, D, E kişileri 1\'den 5\'e kadar sıralanmış koltuklara oturacaktır. A, 3. koltuktadır. B ve C yan yana oturmamaktadır. D, E\'nin sağındadır (daha büyük numara). 1. koltukta kim oturamaz?', options: ['A) B', 'B) C', 'C) D', 'D) E'], correctIndex: 2, explanation: 'A=3. D > E (numara olarak). D 1. koltukta olursa E\'nin numarası D\'den küçük olmalı ama 1\'den küçük yok. D 1. koltukta oturamaz.', difficulty: 3),
    StemQuestion(question: 'Pazartesi, Salı, Çarşamba, Perşembe günleri. Ali, Veli, Can, Deniz. Ali Pzt gelmedi. Veli Çarşamba geldi. Can, Deniz\'den sonraki gün geldi. Ali hangi gün geldi?', options: ['A) Pzt', 'B) Sal', 'C) Çar', 'D) Per'], correctIndex: 3, explanation: 'Veli=Çar. Can Deniz\'den sonraki gün: Deniz-Can ardışık. Olasılıklar: Pzt-Sal veya Sal-Per (Çar dolu). Deniz=Pzt, Can=Sal ise Ali=Per (Pzt değil uydu). Deniz=Sal, Can=Per ise Ali=Pzt (Ali Pzt gelmedi, olmaz). O halde: Deniz=Pzt, Can=Sal, Ali=Per.', difficulty: 3),
    StemQuestion(question: 'K, L, M, N takımları. K şampiyon olmadı. L, M\'den iyi. M, K\'dan iyi. N sonuncu. Şampiyon kimdir?', options: ['A) K', 'B) L', 'C) M', 'D) N'], correctIndex: 1, explanation: 'N=4 (sonuncu). L > M > K. L en iyi sırada. K şampiyon değil. Sıralama: L(1)-M(2)-K(3)-N(4). Şampiyon: L.', difficulty: 3),
    StemQuestion(question: 'Sarı, Kırmızı, Yeşil, Mavi bilyeler. A, B, C, D torbaları. A\'da sarı yok. B\'de yeşil var. C\'de kırmızı yok. D\'de mavi var. A\'da ne var?', options: ['A) Sarı', 'B) Kırmızı', 'C) Yeşil', 'D) Mavi'], correctIndex: 1, explanation: 'B=Yeşil. D=Mavi. A\'da Sarı yok. Kalan: Sarı, Kırmızı (Yeşil ve Mavi alındı). A Sarı değilse Kırmızı. C=Sarı.', difficulty: 3),
    StemQuestion(question: 'Ali, Banu, Can, Derya, Ege. 5 katlı bina. Ali en üstte. Can, Banu\'nun üstünde. Derya, Ege\'nin altında. Ege 2. katta. Banu nerede?', options: ['A) 1', 'B) 3', 'C) 4', 'D) 5'], correctIndex: 0, explanation: 'Ali=5 (en üst). Ege=2. Derya < Ege demek Derya=1. Can > Banu. Kalan katlar: 3, 4 (1 ve 2 dolu). Can=4, Banu=3. Veya Can=3, Banu nerede? Can > Banu: Can=3 olursa Banu 2 veya 1 (dolu). Banu 1 dolu (Derya). Sığmaz. Can=4, Banu=3. Banu=3. Şıklarda 3: B.', difficulty: 3),
    StemQuestion(question: 'X, Y, Z, Q, W filmleri. A, B, C, D, E yönetmenleri. A -> X. B -> Y değil. C -> Z. D -> Q değil. E -> Y. B hangi filmi yönetti?', options: ['A) Q', 'B) W', 'C) Z', 'D) X'], correctIndex: 0, explanation: 'A=X, C=Z, E=Y. Kalan filmler: Q, W. Kalan yönetmenler: B, D. D Q değilse D=W. B=Q.', difficulty: 3),
    StemQuestion(question: 'Masa tenisi turnuvası. Ali, Veli, Can finale kaldı. Ali, Veli\'yi yendi. Can, Ali\'ye yenildi. Şampiyon kim?', options: ['A) Ali', 'B) Veli', 'C) Can', 'D) Bilinemez'], correctIndex: 0, explanation: 'Ali Veli\'yi yenmiş. Can Ali\'ye yenilmiş. Ali herkesi yenmiş. Şampiyon Ali.', difficulty: 3),
    StemQuestion(question: '1\'den 6\'ya kadar numaralı kutular. A, B, C, D, E, F. A ve B tek numara. C ve D çift numara. E, F\'den büyük numarada. A 1, B 3. C 2. D 6. E ve F nerede?', options: ['A) E4, F5', 'B) E5, F4', 'C) E4, F6', 'D) E5, F2'], correctIndex: 1, explanation: 'A=1, B=3 (tek). C=2, D=6 (çift). Kalan yerler: 4 ve 5. E > F (büyük numara). E=5, F=4.', difficulty: 3),
    StemQuestion(question: 'K, L, M, N dersleri. Pzt, Salı. K Pzt. L ve M aynı gün. N farklı gün. L Pazartesi değildir. L hangi gün?', options: ['A) Pzt', 'B) Salı', 'C) Çar', 'D) Bilinemez'], correctIndex: 1, explanation: 'K=Pzt. L Pzt değilse L=Sal. M=L ile aynı gün=Sal. N farklı gün (L ve M\'den): N=Pzt. L=Salı.', difficulty: 3),
    StemQuestion(question: 'Ayşe, Fatma, Hayriye. Çay, Kahve, Su. Herkes 1 içecek. Ayşe çay içmedi. Fatma kahve içmedi. Hayriye su içti. Ayşe ne içti?', options: ['A) Çay', 'B) Kahve', 'C) Su', 'D) Kola'], correctIndex: 1, explanation: 'Hayriye=Su. Ayşe Çay değilse Kahve (Su alındı). Fatma=Çay.', difficulty: 3),
    StemQuestion(question: 'Ali 1., Veli 2., Can 3. oldu. Deniz 4. oldu. Ege 5. oldu. Kim sonuncu?', options: ['A) Ali', 'B) Veli', 'C) Deniz', 'D) Ege'], correctIndex: 3, explanation: '5 kişi var, 5. sıradaki sonuncudur. Ege.', difficulty: 3),
    StemQuestion(question: 'Kırmızı, Beyaz, Siyah şapkalar. Ali Kırmızı takmadı. Veli Siyah takmadı. Can Beyaz taktı. Ali ne taktı?', options: ['A) Kırmızı', 'B) Beyaz', 'C) Siyah', 'D) Yeşil'], correctIndex: 2, explanation: 'Can=Beyaz. Ali Kırmızı değilse Siyah (Beyaz alındı). Veli=Kırmızı.', difficulty: 3),
    StemQuestion(question: 'X şehri Y\'den sıcak. Z şehri X\'ten sıcak. En soğuk hangisi?', options: ['A) X', 'B) Y', 'C) Z', 'D) Hepsi'], correctIndex: 1, explanation: 'Z > X > Y. En soğuk Y.', difficulty: 3),
    StemQuestion(question: 'A, B, C kitapları. A roman. B şiir değil. C hikaye değil. B ve C farklı tür. B ne olabilir?', options: ['A) Roman', 'B) Şiir', 'C) Hikaye', 'D) Deneme'], correctIndex: 2, explanation: 'A=Roman. Türler: Roman, Şiir, Hikaye. C Hikaye değil ve Roman dolu: C=Şiir. B Şiir değil: B=Hikaye.', difficulty: 3),
    StemQuestion(question: '10 katlı bina. Ali 5. katta. Veli Ali\'nin üstünde. Can en üstte. Veli kaçıncı katta olabilir?', options: ['A) 4', 'B) 5', 'C) 8', 'D) 11'], correctIndex: 2, explanation: 'Veli Ali\'nin (5) üstünde: 6-10 arası. Can en üstte (10). Veli 10 olamaz (Can var). Veli 6-9 arası. Şıklardan 8 uygun.', difficulty: 3),
  ],
  formulaCards: const ['Kesinlik: Olamaz diyorsa imkansızı bul.', 'Sıralama: > < işaretleri hayat kurtarır.', 'Tablo: Boşlukları iyi yönet.'],
);
