/// SOLICAP - Kelime Oyunu Verileri
/// 50 seviye: 1-15 (4 harf), 16-35 (5 harf), 36-50 (6 harf)

class WordGameLevel {
  final int id;
  final List<String> letters;
  final List<WordEntry> words;

  const WordGameLevel({required this.id, required this.letters, required this.words});
}

class WordEntry {
  final String en;
  final String tr;

  const WordEntry({required this.en, required this.tr});
}

const List<WordGameLevel> wordGameLevels = [
  WordGameLevel(id: 1, letters: ['S', 'T', 'A', 'R'], words: [
    WordEntry(en: 'STAR', tr: 'Yıldız'), WordEntry(en: 'ARTS', tr: 'Sanatlar'),
    WordEntry(en: 'RATS', tr: 'Fareler'), WordEntry(en: 'ART', tr: 'Sanat'),
    WordEntry(en: 'RAT', tr: 'Fare'), WordEntry(en: 'TAR', tr: 'Katran'),
  ]),
  WordGameLevel(id: 2, letters: ['P', 'A', 'R', 'T'], words: [
    WordEntry(en: 'PART', tr: 'Bölüm'), WordEntry(en: 'ART', tr: 'Sanat'),
    WordEntry(en: 'TAR', tr: 'Katran'), WordEntry(en: 'RAT', tr: 'Fare'),
    WordEntry(en: 'RAP', tr: 'Rap'), WordEntry(en: 'PAT', tr: 'Okşamak'),
  ]),
  WordGameLevel(id: 3, letters: ['D', 'E', 'A', 'R'], words: [
    WordEntry(en: 'DEAR', tr: 'Sevgili'), WordEntry(en: 'DARE', tr: 'Cesaret etmek'),
    WordEntry(en: 'READ', tr: 'Okumak'), WordEntry(en: 'RED', tr: 'Kırmızı'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'ARE', tr: 'Olmak'),
  ]),
  WordGameLevel(id: 4, letters: ['B', 'E', 'A', 'R'], words: [
    WordEntry(en: 'BEAR', tr: 'Ayı'), WordEntry(en: 'BARE', tr: 'Çıplak'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'ARE', tr: 'Olmak'),
    WordEntry(en: 'BAR', tr: 'Bar'),
  ]),
  WordGameLevel(id: 5, letters: ['S', 'E', 'A', 'T'], words: [
    WordEntry(en: 'SEAT', tr: 'Koltuk'), WordEntry(en: 'EAST', tr: 'Doğu'),
    WordEntry(en: 'TEA', tr: 'Çay'), WordEntry(en: 'SEA', tr: 'Deniz'),
    WordEntry(en: 'EAT', tr: 'Yemek'),
  ]),
  WordGameLevel(id: 6, letters: ['G', 'O', 'L', 'D'], words: [
    WordEntry(en: 'GOLD', tr: 'Altın'), WordEntry(en: 'DOG', tr: 'Köpek'),
    WordEntry(en: 'LOG', tr: 'Kütük'), WordEntry(en: 'GOD', tr: 'Tanrı'),
  ]),
  WordGameLevel(id: 7, letters: ['C', 'O', 'L', 'D'], words: [
    WordEntry(en: 'COLD', tr: 'Soğuk'), WordEntry(en: 'OLD', tr: 'Eski'),
    WordEntry(en: 'DOC', tr: 'Doktor'),
  ]),
  WordGameLevel(id: 8, letters: ['P', 'L', 'A', 'Y'], words: [
    WordEntry(en: 'PLAY', tr: 'Oyun'), WordEntry(en: 'LAP', tr: 'Tur'),
    WordEntry(en: 'PAL', tr: 'Dost'), WordEntry(en: 'LAY', tr: 'Koymak'),
    WordEntry(en: 'PAY', tr: 'Ödemek'),
  ]),
  WordGameLevel(id: 9, letters: ['N', 'A', 'M', 'E'], words: [
    WordEntry(en: 'NAME', tr: 'İsim'), WordEntry(en: 'MEAN', tr: 'Anlamına gelmek'),
    WordEntry(en: 'MAN', tr: 'Adam'), WordEntry(en: 'MEN', tr: 'Adamlar'),
  ]),
  WordGameLevel(id: 10, letters: ['T', 'I', 'M', 'E'], words: [
    WordEntry(en: 'TIME', tr: 'Zaman'), WordEntry(en: 'TIE', tr: 'Kravat'),
    WordEntry(en: 'ITEM', tr: 'Öğe'), WordEntry(en: 'MET', tr: 'Buluştu'),
  ]),
  WordGameLevel(id: 11, letters: ['B', 'I', 'R', 'D'], words: [
    WordEntry(en: 'BIRD', tr: 'Kuş'), WordEntry(en: 'RID', tr: 'Kurtulmak'),
    WordEntry(en: 'RIB', tr: 'Kaburga'), WordEntry(en: 'BID', tr: 'Teklif'),
  ]),
  WordGameLevel(id: 12, letters: ['W', 'O', 'R', 'D'], words: [
    WordEntry(en: 'WORD', tr: 'Kelime'), WordEntry(en: 'ROW', tr: 'Sıra'),
    WordEntry(en: 'ROD', tr: 'Çubuk'),
  ]),
  WordGameLevel(id: 13, letters: ['C', 'A', 'R', 'E'], words: [
    WordEntry(en: 'CARE', tr: 'Bakım'), WordEntry(en: 'RACE', tr: 'Yarış'),
    WordEntry(en: 'CAR', tr: 'Araba'), WordEntry(en: 'EAR', tr: 'Kulak'),
    WordEntry(en: 'ARE', tr: 'Olmak'),
  ]),
  WordGameLevel(id: 14, letters: ['F', 'A', 'C', 'T'], words: [
    WordEntry(en: 'FACT', tr: 'Gerçek'), WordEntry(en: 'CAT', tr: 'Kedi'),
    WordEntry(en: 'ACT', tr: 'Hareket etmek'), WordEntry(en: 'FAT', tr: 'Şişman'),
  ]),
  WordGameLevel(id: 15, letters: ['H', 'E', 'A', 'R'], words: [
    WordEntry(en: 'HEAR', tr: 'Duymak'), WordEntry(en: 'HARE', tr: 'Tavşan'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'ERA', tr: 'Dönem'),
  ]),
  // ── 5 Harfli Seviyeler (16-35) ──
  WordGameLevel(id: 16, letters: ['P', 'L', 'A', 'N', 'T'], words: [
    WordEntry(en: 'PLANT', tr: 'Bitki'), WordEntry(en: 'PLAN', tr: 'Plan'),
    WordEntry(en: 'PANT', tr: 'Nefes nefese'), WordEntry(en: 'ANT', tr: 'Karınca'),
    WordEntry(en: 'PAN', tr: 'Tava'),
  ]),
  WordGameLevel(id: 17, letters: ['W', 'A', 'T', 'E', 'R'], words: [
    WordEntry(en: 'WATER', tr: 'Su'), WordEntry(en: 'TEAR', tr: 'Gözyaşı'),
    WordEntry(en: 'RATE', tr: 'Oran'), WordEntry(en: 'RAW', tr: 'Çiğ'),
    WordEntry(en: 'WAR', tr: 'Savaş'), WordEntry(en: 'ART', tr: 'Sanat'),
  ]),
  WordGameLevel(id: 18, letters: ['S', 'T', 'O', 'N', 'E'], words: [
    WordEntry(en: 'STONE', tr: 'Taş'), WordEntry(en: 'TONE', tr: 'Ton'),
    WordEntry(en: 'NOT', tr: 'Değil'), WordEntry(en: 'NET', tr: 'Ağ'),
    WordEntry(en: 'TEN', tr: 'On'), WordEntry(en: 'ONE', tr: 'Bir'),
  ]),
  WordGameLevel(id: 19, letters: ['H', 'E', 'A', 'R', 'T'], words: [
    WordEntry(en: 'HEART', tr: 'Kalp'), WordEntry(en: 'HEAR', tr: 'Duymak'),
    WordEntry(en: 'HEAT', tr: 'Isı'), WordEntry(en: 'ART', tr: 'Sanat'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'HAT', tr: 'Şapka'),
  ]),
  WordGameLevel(id: 20, letters: ['B', 'R', 'E', 'A', 'D'], words: [
    WordEntry(en: 'BREAD', tr: 'Ekmek'), WordEntry(en: 'BEAR', tr: 'Ayı'),
    WordEntry(en: 'READ', tr: 'Okumak'), WordEntry(en: 'DEAR', tr: 'Sevgili'),
    WordEntry(en: 'DARE', tr: 'Cesaret etmek'), WordEntry(en: 'RED', tr: 'Kırmızı'),
  ]),
  WordGameLevel(id: 21, letters: ['C', 'L', 'E', 'A', 'R'], words: [
    WordEntry(en: 'CLEAR', tr: 'Temiz'), WordEntry(en: 'REAL', tr: 'Gerçek'),
    WordEntry(en: 'CARE', tr: 'Bakım'), WordEntry(en: 'RACE', tr: 'Yarış'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'CAR', tr: 'Araba'),
  ]),
  WordGameLevel(id: 22, letters: ['T', 'R', 'A', 'I', 'N'], words: [
    WordEntry(en: 'TRAIN', tr: 'Tren'), WordEntry(en: 'RAIN', tr: 'Yağmur'),
    WordEntry(en: 'RAT', tr: 'Fare'), WordEntry(en: 'ART', tr: 'Sanat'),
    WordEntry(en: 'TAR', tr: 'Katran'), WordEntry(en: 'AIR', tr: 'Hava'),
  ]),
  WordGameLevel(id: 23, letters: ['S', 'H', 'I', 'R', 'T'], words: [
    WordEntry(en: 'SHIRT', tr: 'Gömlek'), WordEntry(en: 'HIT', tr: 'Vurmak'),
    WordEntry(en: 'HIS', tr: 'Onun'), WordEntry(en: 'SIR', tr: 'Efendi'),
    WordEntry(en: 'SIT', tr: 'Oturmak'),
  ]),
  WordGameLevel(id: 24, letters: ['L', 'I', 'G', 'H', 'T'], words: [
    WordEntry(en: 'LIGHT', tr: 'Işık'), WordEntry(en: 'HIT', tr: 'Vurmak'),
    WordEntry(en: 'LIT', tr: 'Aydınlık'),
  ]),
  WordGameLevel(id: 25, letters: ['S', 'P', 'A', 'C', 'E'], words: [
    WordEntry(en: 'SPACE', tr: 'Uzay'), WordEntry(en: 'PACE', tr: 'Hız'),
    WordEntry(en: 'CAP', tr: 'Şapka'), WordEntry(en: 'APE', tr: 'Maymun'),
    WordEntry(en: 'PEA', tr: 'Bezelye'), WordEntry(en: 'SEA', tr: 'Deniz'),
  ]),
  WordGameLevel(id: 26, letters: ['F', 'R', 'U', 'I', 'T'], words: [
    WordEntry(en: 'FRUIT', tr: 'Meyve'), WordEntry(en: 'FIT', tr: 'Uygun'),
    WordEntry(en: 'FUR', tr: 'Kürk'), WordEntry(en: 'RIFT', tr: 'Çatlak'),
  ]),
  WordGameLevel(id: 27, letters: ['S', 'W', 'E', 'E', 'T'], words: [
    WordEntry(en: 'SWEET', tr: 'Tatlı'), WordEntry(en: 'WEST', tr: 'Batı'),
    WordEntry(en: 'WET', tr: 'Islak'), WordEntry(en: 'SEE', tr: 'Görmek'),
    WordEntry(en: 'SET', tr: 'Ayar'),
  ]),
  WordGameLevel(id: 28, letters: ['S', 'O', 'U', 'N', 'D'], words: [
    WordEntry(en: 'SOUND', tr: 'Ses'), WordEntry(en: 'SUN', tr: 'Güneş'),
    WordEntry(en: 'SON', tr: 'Oğul'), WordEntry(en: 'NOD', tr: 'Başını sallamak'),
  ]),
  WordGameLevel(id: 29, letters: ['P', 'A', 'P', 'E', 'R'], words: [
    WordEntry(en: 'PAPER', tr: 'Kağıt'), WordEntry(en: 'PEAR', tr: 'Armut'),
    WordEntry(en: 'REAP', tr: 'Biçmek'), WordEntry(en: 'EAR', tr: 'Kulak'),
    WordEntry(en: 'PEA', tr: 'Bezelye'),
  ]),
  WordGameLevel(id: 30, letters: ['G', 'R', 'E', 'A', 'T'], words: [
    WordEntry(en: 'GREAT', tr: 'Harika'), WordEntry(en: 'RATE', tr: 'Oran'),
    WordEntry(en: 'TEAR', tr: 'Gözyaşı'), WordEntry(en: 'GEAR', tr: 'Vites'),
    WordEntry(en: 'GET', tr: 'Almak'), WordEntry(en: 'ART', tr: 'Sanat'),
  ]),
  WordGameLevel(id: 31, letters: ['B', 'O', 'A', 'R', 'D'], words: [
    WordEntry(en: 'BOARD', tr: 'Tahta'), WordEntry(en: 'ROAD', tr: 'Yol'),
    WordEntry(en: 'BAD', tr: 'Kötü'), WordEntry(en: 'ROB', tr: 'Soymak'),
    WordEntry(en: 'ROD', tr: 'Çubuk'),
  ]),
  WordGameLevel(id: 32, letters: ['M', 'O', 'U', 'S', 'E'], words: [
    WordEntry(en: 'MOUSE', tr: 'Fare'), WordEntry(en: 'MUSE', tr: 'İlham'),
    WordEntry(en: 'SUM', tr: 'Toplam'), WordEntry(en: 'USE', tr: 'Kullanmak'),
    WordEntry(en: 'SUE', tr: 'Dava etmek'),
  ]),
  WordGameLevel(id: 33, letters: ['A', 'P', 'P', 'L', 'E'], words: [
    WordEntry(en: 'APPLE', tr: 'Elma'), WordEntry(en: 'PALE', tr: 'Soluk'),
    WordEntry(en: 'PEA', tr: 'Bezelye'), WordEntry(en: 'LAP', tr: 'Tur'),
    WordEntry(en: 'PAL', tr: 'Dost'), WordEntry(en: 'APE', tr: 'Maymun'),
  ]),
  WordGameLevel(id: 34, letters: ['S', 'M', 'A', 'R', 'T'], words: [
    WordEntry(en: 'SMART', tr: 'Akıllı'), WordEntry(en: 'MART', tr: 'Market'),
    WordEntry(en: 'STAR', tr: 'Yıldız'), WordEntry(en: 'ART', tr: 'Sanat'),
    WordEntry(en: 'MAT', tr: 'Mat'), WordEntry(en: 'RAT', tr: 'Fare'),
  ]),
  WordGameLevel(id: 35, letters: ['B', 'R', 'A', 'I', 'N'], words: [
    WordEntry(en: 'BRAIN', tr: 'Beyin'), WordEntry(en: 'RAIN', tr: 'Yağmur'),
    WordEntry(en: 'BAN', tr: 'Yasak'), WordEntry(en: 'RAN', tr: 'Koştu'),
    WordEntry(en: 'BAR', tr: 'Bar'),
  ]),
  // ── 6 Harfli Seviyeler (36-50) ──
  WordGameLevel(id: 36, letters: ['A', 'N', 'I', 'M', 'A', 'L'], words: [
    WordEntry(en: 'ANIMAL', tr: 'Hayvan'), WordEntry(en: 'MAIL', tr: 'Posta'),
    WordEntry(en: 'NAIL', tr: 'Çivi'), WordEntry(en: 'MAIN', tr: 'Ana'),
    WordEntry(en: 'MAN', tr: 'Adam'),
  ]),
  WordGameLevel(id: 37, letters: ['S', 'P', 'R', 'I', 'N', 'G'], words: [
    WordEntry(en: 'SPRING', tr: 'Bahar'), WordEntry(en: 'RING', tr: 'Yüzük'),
    WordEntry(en: 'PIG', tr: 'Domuz'), WordEntry(en: 'PIN', tr: 'İğne'),
    WordEntry(en: 'SIGN', tr: 'İşaret'), WordEntry(en: 'SING', tr: 'Şarkı söylemek'),
  ]),
  WordGameLevel(id: 38, letters: ['N', 'A', 'T', 'U', 'R', 'E'], words: [
    WordEntry(en: 'NATURE', tr: 'Doğa'), WordEntry(en: 'RATE', tr: 'Oran'),
    WordEntry(en: 'TEAR', tr: 'Gözyaşı'), WordEntry(en: 'TRUE', tr: 'Doğru'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'NET', tr: 'Ağ'),
  ]),
  WordGameLevel(id: 39, letters: ['M', 'O', 'T', 'H', 'E', 'R'], words: [
    WordEntry(en: 'MOTHER', tr: 'Anne'), WordEntry(en: 'OTHER', tr: 'Diğer'),
    WordEntry(en: 'THEM', tr: 'Onları'), WordEntry(en: 'MORE', tr: 'Daha'),
    WordEntry(en: 'HERO', tr: 'Kahraman'), WordEntry(en: 'HOT', tr: 'Sıcak'),
  ]),
  WordGameLevel(id: 40, letters: ['F', 'L', 'O', 'W', 'E', 'R'], words: [
    WordEntry(en: 'FLOWER', tr: 'Çiçek'), WordEntry(en: 'LOWER', tr: 'Daha düşük'),
    WordEntry(en: 'FLOW', tr: 'Akış'), WordEntry(en: 'WOLF', tr: 'Kurt'),
    WordEntry(en: 'ROLE', tr: 'Rol'), WordEntry(en: 'OWL', tr: 'Baykuş'),
  ]),
  WordGameLevel(id: 41, letters: ['W', 'I', 'N', 'T', 'E', 'R'], words: [
    WordEntry(en: 'WINTER', tr: 'Kış'), WordEntry(en: 'TWIN', tr: 'İkiz'),
    WordEntry(en: 'TIRE', tr: 'Lastik'), WordEntry(en: 'WIRE', tr: 'Tel'),
    WordEntry(en: 'WINE', tr: 'Şarap'), WordEntry(en: 'WIN', tr: 'Kazanmak'),
  ]),
  WordGameLevel(id: 42, letters: ['S', 'U', 'M', 'M', 'E', 'R'], words: [
    WordEntry(en: 'SUMMER', tr: 'Yaz'), WordEntry(en: 'USER', tr: 'Kullanıcı'),
    WordEntry(en: 'SURE', tr: 'Emin'), WordEntry(en: 'SUM', tr: 'Toplam'),
    WordEntry(en: 'RUM', tr: 'Rom'), WordEntry(en: 'USE', tr: 'Kullanmak'),
  ]),
  WordGameLevel(id: 43, letters: ['P', 'E', 'R', 'S', 'O', 'N'], words: [
    WordEntry(en: 'PERSON', tr: 'Kişi'), WordEntry(en: 'ROPE', tr: 'İp'),
    WordEntry(en: 'NOSE', tr: 'Burun'), WordEntry(en: 'ROSE', tr: 'Gül'),
    WordEntry(en: 'SON', tr: 'Oğul'), WordEntry(en: 'PEN', tr: 'Kalem'),
  ]),
  WordGameLevel(id: 44, letters: ['D', 'O', 'C', 'T', 'O', 'R'], words: [
    WordEntry(en: 'DOCTOR', tr: 'Doktor'), WordEntry(en: 'DOOR', tr: 'Kapı'),
    WordEntry(en: 'ROOT', tr: 'Kök'), WordEntry(en: 'COT', tr: 'Bebek yatağı'),
    WordEntry(en: 'DOT', tr: 'Nokta'),
  ]),
  WordGameLevel(id: 45, letters: ['M', 'A', 'R', 'K', 'E', 'T'], words: [
    WordEntry(en: 'MARKET', tr: 'Pazar'), WordEntry(en: 'MAKER', tr: 'Yapıcı'),
    WordEntry(en: 'MAKE', tr: 'Yapmak'), WordEntry(en: 'TAKE', tr: 'Almak'),
    WordEntry(en: 'TEAM', tr: 'Takım'), WordEntry(en: 'RATE', tr: 'Oran'),
  ]),
  WordGameLevel(id: 46, letters: ['C', 'A', 'M', 'E', 'R', 'A'], words: [
    WordEntry(en: 'CAMERA', tr: 'Kamera'), WordEntry(en: 'CREAM', tr: 'Krema'),
    WordEntry(en: 'RACE', tr: 'Yarış'), WordEntry(en: 'CARE', tr: 'Bakım'),
    WordEntry(en: 'CAR', tr: 'Araba'), WordEntry(en: 'ARE', tr: 'Olmak'),
  ]),
  WordGameLevel(id: 47, letters: ['B', 'U', 'T', 'T', 'E', 'R'], words: [
    WordEntry(en: 'BUTTER', tr: 'Tereyağı'), WordEntry(en: 'TUBE', tr: 'Tüp'),
    WordEntry(en: 'TRUE', tr: 'Doğru'), WordEntry(en: 'BUT', tr: 'Ama'),
    WordEntry(en: 'TUB', tr: 'Küvet'), WordEntry(en: 'RUB', tr: 'Ovmak'),
  ]),
  WordGameLevel(id: 48, letters: ['G', 'A', 'R', 'D', 'E', 'N'], words: [
    WordEntry(en: 'GARDEN', tr: 'Bahçe'), WordEntry(en: 'ANGER', tr: 'Öfke'),
    WordEntry(en: 'GEAR', tr: 'Vites'), WordEntry(en: 'READ', tr: 'Okumak'),
    WordEntry(en: 'DEAR', tr: 'Sevgili'), WordEntry(en: 'RED', tr: 'Kırmızı'),
  ]),
  WordGameLevel(id: 49, letters: ['C', 'A', 'S', 'T', 'L', 'E'], words: [
    WordEntry(en: 'CASTLE', tr: 'Kale'), WordEntry(en: 'TALE', tr: 'Masal'),
    WordEntry(en: 'SALE', tr: 'Satış'), WordEntry(en: 'LATE', tr: 'Geç'),
    WordEntry(en: 'EAST', tr: 'Doğu'), WordEntry(en: 'CAT', tr: 'Kedi'),
  ]),
  WordGameLevel(id: 50, letters: ['P', 'L', 'A', 'Y', 'E', 'R'], words: [
    WordEntry(en: 'PLAYER', tr: 'Oyuncu'), WordEntry(en: 'PLAY', tr: 'Oyun'),
    WordEntry(en: 'PEAR', tr: 'Armut'), WordEntry(en: 'REAL', tr: 'Gerçek'),
    WordEntry(en: 'EAR', tr: 'Kulak'), WordEntry(en: 'PAY', tr: 'Ödemek'),
  ]),
];
