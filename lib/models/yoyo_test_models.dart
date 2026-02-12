/// SOLICAP - YoYo Test Modelleri - AYT
/// Deneme sınavı / hız antrenmanı

class YoYoQuestion {
  final String question;
  final List<String> options;
  final int correct;
  final String difficulty; // "easy", "medium", "hard"
  final String topic;

  const YoYoQuestion({
    required this.question,
    required this.options,
    required this.correct,
    required this.difficulty,
    required this.topic,
  });
}

class YoYoSubject {
  final String name;
  final String emoji;
  final List<YoYoQuestion> questions;

  const YoYoSubject({
    required this.name,
    required this.emoji,
    required this.questions,
  });

  /// Seviye için 6 random soru getir (2 easy + 2 medium + 2 hard)
  List<YoYoQuestion> getQuestionsForLevel(Set<int> usedIndices) {
    final easy = <int>[];
    final medium = <int>[];
    final hard = <int>[];

    for (int i = 0; i < questions.length; i++) {
      if (usedIndices.contains(i)) continue;
      switch (questions[i].difficulty) {
        case 'easy':
          easy.add(i);
          break;
        case 'medium':
          medium.add(i);
          break;
        case 'hard':
          hard.add(i);
          break;
      }
    }

    easy.shuffle();
    medium.shuffle();
    hard.shuffle();

    final selected = <int>[];
    selected.addAll(easy.take(2));
    selected.addAll(medium.take(2));
    selected.addAll(hard.take(2));
    selected.shuffle(); // Karışık sırala

    usedIndices.addAll(selected);
    return selected.map((i) => questions[i]).toList();
  }
}

/// Seviye süreleri (saniye cinsinden)
const List<int> yoyoLevelTimes = [
  420, // Seviye 1: 7:00
  390, // Seviye 2: 6:30
  360, // Seviye 3: 6:00
  330, // Seviye 4: 5:30
  300, // Seviye 5: 5:00
  270, // Seviye 6: 4:30
  240, // Seviye 7: 4:00
];
