import 'dart:math';
import '../../data/models/question.dart';

/// Motor de geração de questões com alternativas inteligentes
class QuestionGenerator {
  final Random _random = Random();

  /// Gera uma questão de tabuada para um número específico
  /// 
  /// Parâmetros:
  /// - [tableNumber]: Número da tabuada (1-10)
  /// - [multiplierRange]: Range de multiplicadores (ex: [1, 10])
  Question generateQuestion(int tableNumber, {List<int>? multiplierRange}) {
    final range = multiplierRange ?? [1, 10];
    final multiplier = range[0] + _random.nextInt(range[1] - range[0] + 1);
    
    final correctAnswer = tableNumber * multiplier;
    final wrongOptions = _generateIntelligentWrongAnswers(
      tableNumber,
      multiplier,
      correctAnswer,
    );

    final allOptions = [correctAnswer, ...wrongOptions]..shuffle();

    return Question(
      multiplicand: tableNumber,
      multiplier: multiplier,
      correctAnswer: correctAnswer,
      options: allOptions,
    );
  }

  /// Gera uma questão aleatória (qualquer tabuada)
  Question generateRandomQuestion({List<int>? tablesRange}) {
    final range = tablesRange ?? [1, 10];
    final randomTable = range[0] + _random.nextInt(range[1] - range[0] + 1);
    return generateQuestion(randomTable);
  }

  /// Gera um conjunto de questões para uma tabuada específica
  List<Question> generateQuestionSet(int tableNumber, int count) {
    final questions = <Question>[];
    final usedMultipliers = <int>{};

    while (questions.length < count && usedMultipliers.length < 10) {
      final multiplier = 1 + _random.nextInt(10);
      
      if (!usedMultipliers.contains(multiplier)) {
        usedMultipliers.add(multiplier);
        questions.add(generateQuestion(tableNumber, multiplierRange: [multiplier, multiplier]));
      }
    }

    // Se precisar de mais questões que multiplicadores únicos, permite repetição
    while (questions.length < count) {
      questions.add(generateQuestion(tableNumber));
    }

    return questions..shuffle();
  }

  /// Algoritmo de geração de alternativas incorretas plausíveis
  /// 
  /// Estratégias:
  /// 1. Correto ± 1 (erro de contagem)
  /// 2. Multiplicand × (Multiplier ± 1) (tabuada adjacente)
  /// 3. Multiplicand + Multiplier (confusão de operação)
  /// 4. Correto ± valor aleatório pequeno (para diversidade)
  List<int> _generateIntelligentWrongAnswers(
    int multiplicand,
    int multiplier,
    int correctAnswer,
  ) {
    final wrongAnswers = <int>{};

    // Estratégia 1: Correto ± 1
    final option1 = correctAnswer + (_random.nextBool() ? 1 : -1);
    if (option1 > 0 && option1 != correctAnswer) {
      wrongAnswers.add(option1);
    }

    // Estratégia 2: Tabuada adjacente
    final adjacentMultiplier = multiplier + (_random.nextBool() ? 1 : -1);
    if (adjacentMultiplier > 0 && adjacentMultiplier <= 10) {
      final option2 = multiplicand * adjacentMultiplier;
      if (option2 != correctAnswer) {
        wrongAnswers.add(option2);
      }
    }

    // Estratégia 3: Confusão de operação (adição)
    final option3 = multiplicand + multiplier;
    if (option3 != correctAnswer && option3 > 0) {
      wrongAnswers.add(option3);
    }

    // Estratégia 4: Variação aleatória pequena
    while (wrongAnswers.length < 3) {
      final variation = _random.nextInt(10) + 1; // 1 a 10
      final option = correctAnswer + (_random.nextBool() ? variation : -variation);
      
      if (option > 0 && option != correctAnswer && !wrongAnswers.contains(option)) {
        wrongAnswers.add(option);
      }
    }

    return wrongAnswers.take(3).toList();
  }
}
