/// SOLICAP - Math RPG Modelleri

class MathRPGMonster {
  final String name;
  final String emoji;
  final int maxHp;
  final int attack;
  final bool isBoss;
  final int difficulty;

  const MathRPGMonster({
    required this.name,
    required this.emoji,
    required this.maxHp,
    required this.attack,
    required this.isBoss,
    required this.difficulty,
  });
}

class MathRPGQuestion {
  final String question;
  final List<String> options;
  final int correct;
  final int difficulty;
  final String category;

  const MathRPGQuestion({
    required this.question,
    required this.options,
    required this.correct,
    required this.difficulty,
    required this.category,
  });
}

class MathRPGLevel {
  final String levelName;
  final String ageGroup;
  final int timeLimit;
  final List<MathRPGMonster> monsters;
  final List<MathRPGQuestion> questions;

  const MathRPGLevel({
    required this.levelName,
    required this.ageGroup,
    required this.timeLimit,
    required this.monsters,
    required this.questions,
  });
}
