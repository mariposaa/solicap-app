/// SOLICAP - Math RPG Oyun Verileri
/// 3 yaş grubu: 7-10, 11-14, 15-18

import '../models/math_rpg_models.dart';

final List<MathRPGLevel> mathRPGLevels = [
  // ═══════════════════════════════════════════
  // 🟢 7-10 YAŞ — ÇIRAK
  // ═══════════════════════════════════════════
  MathRPGLevel(
    levelName: 'Çırak',
    ageGroup: '7-10',
    timeLimit: 15,
    monsters: const [
      MathRPGMonster(name: 'Sümük', emoji: '🟢', maxHp: 50, attack: 5, isBoss: false, difficulty: 1),
      MathRPGMonster(name: 'Yarasa', emoji: '🦇', maxHp: 60, attack: 7, isBoss: false, difficulty: 1),
      MathRPGMonster(name: 'Örümcek', emoji: '🕷️', maxHp: 70, attack: 9, isBoss: false, difficulty: 2),
      MathRPGMonster(name: 'Goblin', emoji: '👺', maxHp: 80, attack: 12, isBoss: false, difficulty: 3),
      MathRPGMonster(name: 'İskelet', emoji: '💀', maxHp: 90, attack: 15, isBoss: false, difficulty: 4),
      MathRPGMonster(name: 'Troll Kral', emoji: '👹', maxHp: 150, attack: 25, isBoss: true, difficulty: 5),
    ],
    questions: const [
      // Difficulty 1
      MathRPGQuestion(question: '5 + 3 = ?', options: ['7', '8', '9', '6'], correct: 1, difficulty: 1, category: 'toplama'),
      MathRPGQuestion(question: '10 - 4 = ?', options: ['5', '4', '6', '7'], correct: 2, difficulty: 1, category: 'çıkarma'),
      MathRPGQuestion(question: '2 + 2 = ?', options: ['4', '5', '3', '22'], correct: 0, difficulty: 1, category: 'toplama'),
      MathRPGQuestion(question: '6 + 4 = ?', options: ['9', '11', '12', '10'], correct: 3, difficulty: 1, category: 'toplama'),
      MathRPGQuestion(question: '9 - 2 = ?', options: ['6', '8', '7', '5'], correct: 2, difficulty: 1, category: 'çıkarma'),
      // Difficulty 2
      MathRPGQuestion(question: '15 + 5 = ?', options: ['20', '25', '18', '19'], correct: 0, difficulty: 2, category: 'toplama'),
      MathRPGQuestion(question: '20 - 5 = ?', options: ['14', '16', '15', '10'], correct: 2, difficulty: 2, category: 'çıkarma'),
      MathRPGQuestion(question: '12 + 7 = ?', options: ['18', '20', '19', '21'], correct: 2, difficulty: 2, category: 'toplama'),
      MathRPGQuestion(question: '3 x 2 = ?', options: ['5', '6', '9', '1'], correct: 1, difficulty: 2, category: 'çarpma'),
      MathRPGQuestion(question: '4 x 1 = ?', options: ['4', '5', '3', '1'], correct: 0, difficulty: 2, category: 'çarpma'),
      // Difficulty 3
      MathRPGQuestion(question: '5 x 3 = ?', options: ['12', '14', '16', '15'], correct: 3, difficulty: 3, category: 'çarpma'),
      MathRPGQuestion(question: '10 / 2 = ?', options: ['4', '5', '6', '2'], correct: 1, difficulty: 3, category: 'bölme'),
      MathRPGQuestion(question: '30 - 15 = ?', options: ['15', '10', '20', '5'], correct: 0, difficulty: 3, category: 'çıkarma'),
      MathRPGQuestion(question: '4 x 4 = ?', options: ['12', '14', '16', '18'], correct: 2, difficulty: 3, category: 'çarpma'),
      MathRPGQuestion(question: '8 / 2 = ?', options: ['2', '3', '5', '4'], correct: 3, difficulty: 3, category: 'bölme'),
      MathRPGQuestion(question: '6 x 3 = ?', options: ['18', '12', '15', '21'], correct: 0, difficulty: 3, category: 'çarpma'),
      MathRPGQuestion(question: '20 / 4 = ?', options: ['4', '6', '5', '3'], correct: 2, difficulty: 3, category: 'bölme'),
      MathRPGQuestion(question: '25 + 25 = ?', options: ['40', '60', '45', '50'], correct: 3, difficulty: 3, category: 'toplama'),
      MathRPGQuestion(question: '50 - 20 = ?', options: ['30', '20', '40', '25'], correct: 0, difficulty: 3, category: 'çıkarma'),
      MathRPGQuestion(question: '12 / 3 = ?', options: ['3', '5', '4', '6'], correct: 2, difficulty: 3, category: 'bölme'),
      // Difficulty 4
      MathRPGQuestion(question: '7 x 5 = ?', options: ['30', '40', '32', '35'], correct: 3, difficulty: 4, category: 'çarpma'),
      MathRPGQuestion(question: '8 x 4 = ?', options: ['32', '28', '36', '30'], correct: 0, difficulty: 4, category: 'çarpma'),
      MathRPGQuestion(question: '30 / 5 = ?', options: ['5', '7', '6', '4'], correct: 2, difficulty: 4, category: 'bölme'),
      MathRPGQuestion(question: '100 - 40 = ?', options: ['50', '70', '40', '60'], correct: 3, difficulty: 4, category: 'çıkarma'),
      MathRPGQuestion(question: '9 x 3 = ?', options: ['24', '27', '21', '30'], correct: 1, difficulty: 4, category: 'çarpma'),
      // Difficulty 5
      MathRPGQuestion(question: '81 / 9 = ?', options: ['8', '7', '9', '6'], correct: 2, difficulty: 5, category: 'bölme'),
      MathRPGQuestion(question: '6 x 8 = ?', options: ['48', '42', '54', '56'], correct: 0, difficulty: 5, category: 'çarpma'),
      MathRPGQuestion(question: '7 x 7 = ?', options: ['42', '48', '50', '49'], correct: 3, difficulty: 5, category: 'çarpma'),
      MathRPGQuestion(question: '56 / 8 = ?', options: ['6', '7', '8', '9'], correct: 1, difficulty: 5, category: 'bölme'),
      MathRPGQuestion(question: '144 / 12 = ?', options: ['10', '11', '12', '13'], correct: 2, difficulty: 5, category: 'bölme'),
    ],
  ),

  // ═══════════════════════════════════════════
  // 🔵 11-14 YAŞ — SAVAŞÇI
  // ═══════════════════════════════════════════
  MathRPGLevel(
    levelName: 'Savaşçı',
    ageGroup: '11-14',
    timeLimit: 20,
    monsters: const [
      MathRPGMonster(name: 'Ork', emoji: '🧟', maxHp: 80, attack: 10, isBoss: false, difficulty: 1),
      MathRPGMonster(name: 'Kurt', emoji: '🐺', maxHp: 90, attack: 12, isBoss: false, difficulty: 2),
      MathRPGMonster(name: 'Mumya', emoji: '🤕', maxHp: 100, attack: 15, isBoss: false, difficulty: 2),
      MathRPGMonster(name: 'Hayalet', emoji: '👻', maxHp: 110, attack: 18, isBoss: false, difficulty: 3),
      MathRPGMonster(name: 'Golem', emoji: '🗿', maxHp: 130, attack: 22, isBoss: false, difficulty: 4),
      MathRPGMonster(name: 'Ejderha', emoji: '🐉', maxHp: 200, attack: 35, isBoss: true, difficulty: 5),
    ],
    questions: const [
      // Difficulty 1
      MathRPGQuestion(question: '1/2 + 1/2 = ?', options: ['1/4', '1', '2', '0.5'], correct: 1, difficulty: 1, category: 'kesirler'),
      MathRPGQuestion(question: '3x = 12 ise x kaçtır?', options: ['3', '5', '4', '6'], correct: 2, difficulty: 1, category: 'denklemler'),
      MathRPGQuestion(question: "20'nin %50'si kaçtır?", options: ['10', '5', '15', '2'], correct: 0, difficulty: 1, category: 'yüzdeler'),
      MathRPGQuestion(question: 'Bir karenin bir kenarı 4 ise alanı?', options: ['8', '12', '16', '20'], correct: 2, difficulty: 1, category: 'geometri'),
      MathRPGQuestion(question: '2/5 + 1/5 = ?', options: ['3/10', '3/5', '2/5', '1/5'], correct: 1, difficulty: 1, category: 'kesirler'),
      // Difficulty 2
      MathRPGQuestion(question: 'x + 7 = 15 ise x kaçtır?', options: ['7', '8', '9', '6'], correct: 1, difficulty: 2, category: 'denklemler'),
      MathRPGQuestion(question: "100'ün %25'i kaçtır?", options: ['20', '30', '25', '50'], correct: 2, difficulty: 2, category: 'yüzdeler'),
      MathRPGQuestion(question: 'Üçgenin iç açıları toplamı?', options: ['180', '360', '90', '270'], correct: 0, difficulty: 2, category: 'geometri'),
      MathRPGQuestion(question: '3/4 - 1/4 = ?', options: ['1/4', '1/2', '3/4', '1'], correct: 1, difficulty: 2, category: 'kesirler'),
      MathRPGQuestion(question: '5x - 5 = 20 ise x kaçtır?', options: ['4', '6', '5', '3'], correct: 2, difficulty: 2, category: 'denklemler'),
      // Difficulty 3
      MathRPGQuestion(question: "200'ün %10'u kaçtır?", options: ['10', '25', '20', '30'], correct: 2, difficulty: 3, category: 'yüzdeler'),
      MathRPGQuestion(question: 'Dik açının ölçüsü kaç derecedir?', options: ['45', '180', '60', '90'], correct: 3, difficulty: 3, category: 'geometri'),
      MathRPGQuestion(question: '2/3 x 3/4 = ?', options: ['1/2', '6/7', '5/12', '2/4'], correct: 0, difficulty: 3, category: 'kesirler'),
      MathRPGQuestion(question: '2x + 10 = 40 ise x kaçtır?', options: ['10', '20', '15', '25'], correct: 2, difficulty: 3, category: 'denklemler'),
      MathRPGQuestion(question: "50'nin %20'si kaçtır?", options: ['5', '15', '20', '10'], correct: 3, difficulty: 3, category: 'yüzdeler'),
      // Difficulty 4
      MathRPGQuestion(question: 'Yarıçapı 2 olan dairenin çevresi? (π=3)', options: ['6', '12', '18', '24'], correct: 1, difficulty: 4, category: 'geometri'),
      MathRPGQuestion(question: '1 tam 1/2 + 1/2 = ?', options: ['1.5', '2', '2.5', '3'], correct: 1, difficulty: 4, category: 'kesirler'),
      MathRPGQuestion(question: '4x/2 = 10 ise x kaçtır?', options: ['4', '5', '6', '10'], correct: 1, difficulty: 4, category: 'denklemler'),
      MathRPGQuestion(question: "150'nin %30'u kaçtır?", options: ['40', '50', '45', '35'], correct: 2, difficulty: 4, category: 'yüzdeler'),
      MathRPGQuestion(question: 'Karenin çevresi 20 ise alanı?', options: ['20', '30', '25', '16'], correct: 2, difficulty: 4, category: 'geometri'),
      // Difficulty 5
      MathRPGQuestion(question: '5/6 / 1/6 = ?', options: ['1', '6', '5', '1/5'], correct: 2, difficulty: 5, category: 'kesirler'),
      MathRPGQuestion(question: '3(x - 2) = 12 ise x kaçtır?', options: ['4', '5', '6', '7'], correct: 2, difficulty: 5, category: 'denklemler'),
      MathRPGQuestion(question: "80'in %75'i kaçtır?", options: ['50', '60', '70', '40'], correct: 1, difficulty: 5, category: 'yüzdeler'),
      MathRPGQuestion(question: 'Dik üçgende 3-4-? üçgeni', options: ['5', '6', '7', '8'], correct: 0, difficulty: 5, category: 'geometri'),
      MathRPGQuestion(question: '2x + 3x = 25 ise x?', options: ['3', '4', '5', '6'], correct: 2, difficulty: 5, category: 'denklemler'),
      MathRPGQuestion(question: 'Alan 36 ise karenin kenarı?', options: ['4', '5', '6', '9'], correct: 2, difficulty: 5, category: 'geometri'),
      MathRPGQuestion(question: "400'ün %1'i kaçtır?", options: ['40', '1', '4', '0.4'], correct: 2, difficulty: 5, category: 'yüzdeler'),
      MathRPGQuestion(question: 'x/3 + 2 = 5 ise x?', options: ['6', '9', '12', '15'], correct: 1, difficulty: 5, category: 'denklemler'),
      MathRPGQuestion(question: "1/2'nin yarısı kaçtır?", options: ['1/2', '1/8', '1', '1/4'], correct: 3, difficulty: 5, category: 'kesirler'),
      MathRPGQuestion(question: 'Düzgün altıgenin dış açısı?', options: ['45', '60', '90', '72'], correct: 1, difficulty: 5, category: 'geometri'),
    ],
  ),

  // ═══════════════════════════════════════════
  // 🟣 15-18 YAŞ — BÜYÜCÜ
  // ═══════════════════════════════════════════
  MathRPGLevel(
    levelName: 'Büyücü',
    ageGroup: '15-18',
    timeLimit: 25,
    monsters: const [
      MathRPGMonster(name: 'Gölge', emoji: '👤', maxHp: 100, attack: 15, isBoss: false, difficulty: 1),
      MathRPGMonster(name: 'Alev Cini', emoji: '🔥', maxHp: 120, attack: 20, isBoss: false, difficulty: 2),
      MathRPGMonster(name: 'Buz Devi', emoji: '🥶', maxHp: 150, attack: 25, isBoss: false, difficulty: 3),
      MathRPGMonster(name: 'Kara Şövalye', emoji: '⚔️', maxHp: 180, attack: 30, isBoss: false, difficulty: 4),
      MathRPGMonster(name: 'Lich', emoji: '🧙‍♂️', maxHp: 220, attack: 40, isBoss: false, difficulty: 5),
      MathRPGMonster(name: 'Karanlık Lord', emoji: '👿', maxHp: 300, attack: 50, isBoss: true, difficulty: 5),
    ],
    questions: const [
      // Difficulty 1
      MathRPGQuestion(question: 'f(x) = 2x + 1 ise f(3) = ?', options: ['6', '7', '8', '5'], correct: 1, difficulty: 1, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'sin(30°) kaçtır?', options: ['1/2', '√3/2', '1', '0'], correct: 0, difficulty: 1, category: 'trigonometri'),
      MathRPGQuestion(question: 'log₁₀(100) = ?', options: ['1', '10', '2', '100'], correct: 2, difficulty: 1, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(x²) türevi nedir?', options: ['x', '2x', 'x²', '2'], correct: 1, difficulty: 1, category: 'türev'),
      MathRPGQuestion(question: 'f(x) = x - 5 ise f(10) = ?', options: ['0', '10', '15', '5'], correct: 3, difficulty: 1, category: 'fonksiyonlar'),
      // Difficulty 2
      MathRPGQuestion(question: 'cos(0°) kaçtır?', options: ['0', '1', '-1', '1/2'], correct: 1, difficulty: 2, category: 'trigonometri'),
      MathRPGQuestion(question: 'log₂(8) = ?', options: ['2', '4', '3', '8'], correct: 2, difficulty: 2, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(5x) türevi nedir?', options: ['5x', 'x', '0', '5'], correct: 3, difficulty: 2, category: 'türev'),
      MathRPGQuestion(question: 'f(x) = x² ise f(4) = ?', options: ['8', '12', '16', '20'], correct: 2, difficulty: 2, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'tan(45°) kaçtır?', options: ['0', '1', '√3', '∞'], correct: 1, difficulty: 2, category: 'trigonometri'),
      // Difficulty 3
      MathRPGQuestion(question: 'ln(e) = ?', options: ['0', '1', 'e', '10'], correct: 1, difficulty: 3, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(3x²) türevi nedir?', options: ['3x', '6x', '6x²', '9x'], correct: 1, difficulty: 3, category: 'türev'),
      MathRPGQuestion(question: 'f(x) = 3x - 2, f⁻¹(x) nedir?', options: ['(x+2)/3', '(x-2)/3', '3x+2', 'x/3'], correct: 0, difficulty: 3, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'sin(90°) kaçtır?', options: ['0', '1', '-1', '1/2'], correct: 1, difficulty: 3, category: 'trigonometri'),
      MathRPGQuestion(question: 'log₃(27) = ?', options: ['9', '2', '3', '1'], correct: 2, difficulty: 3, category: 'logaritma'),
      // Difficulty 4
      MathRPGQuestion(question: 'd/dx(sabit sayı) türevi?', options: ['0', '1', 'x', 'Sonsuz'], correct: 0, difficulty: 4, category: 'türev'),
      MathRPGQuestion(question: 'f(x)=x²+1, f(f(1)) = ?', options: ['2', '4', '5', '3'], correct: 2, difficulty: 4, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'cos(60°) kaçtır?', options: ['√3/2', '1', '1/2', '0'], correct: 2, difficulty: 4, category: 'trigonometri'),
      MathRPGQuestion(question: 'log(1) = ?', options: ['1', '0', '10', 'e'], correct: 1, difficulty: 4, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(x³) türevi?', options: ['3x', '3x²', 'x²', '3'], correct: 1, difficulty: 4, category: 'türev'),
      // Difficulty 5
      MathRPGQuestion(question: 'f(x)=2ˣ ise f(3)=?', options: ['6', '9', '8', '12'], correct: 2, difficulty: 5, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'sin²(x) + cos²(x) = ?', options: ['0', '2', 'sin(2x)', '1'], correct: 3, difficulty: 5, category: 'trigonometri'),
      MathRPGQuestion(question: 'log₅(125) + log₅(5) = ?', options: ['3', '4', '5', '25'], correct: 1, difficulty: 5, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(sin(x)) türevi?', options: ['-cos(x)', 'sin(x)', 'cos(x)', '-sin(x)'], correct: 2, difficulty: 5, category: 'türev'),
      MathRPGQuestion(question: 'Birim fonksiyon f(x) nedir?', options: ['x', '1', '0', 'x²'], correct: 0, difficulty: 5, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'tan(x) = sin(x) / ?', options: ['tan(x)', 'sec(x)', 'cot(x)', 'cos(x)'], correct: 3, difficulty: 5, category: 'trigonometri'),
      MathRPGQuestion(question: 'log₂(16) - log₂(4) = ?', options: ['4', '2', '12', '8'], correct: 1, difficulty: 5, category: 'logaritma'),
      MathRPGQuestion(question: 'd/dx(eˣ) türevi?', options: ['x·eˣ', 'eˣ', 'e', 'x'], correct: 1, difficulty: 5, category: 'türev'),
      MathRPGQuestion(question: 'f(x) = |x|, f(-3) = ?', options: ['-3', '3', '0', '9'], correct: 1, difficulty: 5, category: 'fonksiyonlar'),
      MathRPGQuestion(question: 'cot(45°) kaçtır?', options: ['0', '1', '√3', '1/2'], correct: 1, difficulty: 5, category: 'trigonometri'),
    ],
  ),
];
