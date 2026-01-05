/// Modelo de questão de tabuada
class Question {
  final int multiplicand; // Primeiro número (ex: 7 em 7×8)
  final int multiplier; // Segundo número (ex: 8 em 7×8)
  final int correctAnswer;
  final List<int> options; // 4 opções: 1 correta + 3 incorretas

  Question({
    required this.multiplicand,
    required this.multiplier,
    required this.correctAnswer,
    required this.options,
  });

  /// Getter para exibir a questão formatada
  String get questionText => '$multiplicand × $multiplier = ?';

  /// Verifica se a resposta está correta
  bool isCorrectAnswer(int answer) => answer == correctAnswer;

  /// Cria uma cópia da questão com opções embaralhadas
  Question copyWithShuffledOptions() {
    final shuffledOptions = List<int>.from(options)..shuffle();
    return Question(
      multiplicand: multiplicand,
      multiplier: multiplier,
      correctAnswer: correctAnswer,
      options: shuffledOptions,
    );
  }

  @override
  String toString() =>
      'Question($multiplicand × $multiplier = $correctAnswer, options: $options)';
}
