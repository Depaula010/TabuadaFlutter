import 'dart:math';
import '../../data/models/question.dart';

/// Motor de geração de questões com alternativas inteligentes
/// Suporta as 4 operações básicas: Adição, Subtração, Multiplicação e Divisão
class QuestionGenerator {
  final Random _random = Random();

  /// Gera uma questão matemática para um número e operação específicos
  /// 
  /// Parâmetros:
  /// - [tableNumber]: Número base (ex: na tabuada do 7, é o 7)
  /// - [operation]: Tipo de operação matemática
  /// - [secondOperandRange]: Range do segundo operando (ex: [1, 10])
  Question generateQuestion(
    int tableNumber, {
    Operation operation = Operation.multiplication,
    List<int>? secondOperandRange,
  }) {
    final range = secondOperandRange ?? [1, 10];
    
    switch (operation) {
      case Operation.addition:
        return _generateAdditionQuestion(tableNumber, range);
      case Operation.subtraction:
        return _generateSubtractionQuestion(tableNumber, range);
      case Operation.multiplication:
        return _generateMultiplicationQuestion(tableNumber, range);
      case Operation.division:
        return _generateDivisionQuestion(tableNumber, range);
    }
  }

  /// Gera uma questão de ADIÇÃO
  /// Exemplo: 7 + 8 = ?
  Question _generateAdditionQuestion(int baseNumber, List<int> range) {
    final operandB = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final correctAnswer = baseNumber + operandB;
    
    final wrongOptions = _generateWrongAnswersForAddition(
      baseNumber,
      operandB,
      correctAnswer,
    );

    final allOptions = [correctAnswer, ...wrongOptions]..shuffle();

    return Question(
      operandA: baseNumber,
      operandB: operandB,
      operation: Operation.addition,
      correctAnswer: correctAnswer,
      options: allOptions,
    );
  }

  /// Gera uma questão de SUBTRAÇÃO
  /// Garante que o resultado NUNCA seja negativo (operandA >= operandB)
  /// Exemplo: 15 - 7 = ?
  Question _generateSubtractionQuestion(int baseNumber, List<int> range) {
    final operandB = range[0] + _random.nextInt(range[1] - range[0] + 1);
    
    // Garante que operandA >= operandB para evitar resultados negativos
    final operandA = baseNumber + operandB; // Assim: (baseNumber + operandB) - operandB = baseNumber
    final correctAnswer = operandA - operandB;
    
    final wrongOptions = _generateWrongAnswersForSubtraction(
      operandA,
      operandB,
      correctAnswer,
    );

    final allOptions = [correctAnswer, ...wrongOptions]..shuffle();

    return Question(
      operandA: operandA,
      operandB: operandB,
      operation: Operation.subtraction,
      correctAnswer: correctAnswer,
      options: allOptions,
    );
  }

  /// Gera uma questão de MULTIPLICAÇÃO (tabuada)
  /// Exemplo: 7 × 8 = ?
  Question _generateMultiplicationQuestion(int tableNumber, List<int> range) {
    final operandB = range[0] + _random.nextInt(range[1] - range[0] + 1);
    final correctAnswer = tableNumber * operandB;
    
    final wrongOptions = _generateWrongAnswersForMultiplication(
      tableNumber,
      operandB,
      correctAnswer,
    );

    final allOptions = [correctAnswer, ...wrongOptions]..shuffle();

    return Question(
      operandA: tableNumber,
      operandB: operandB,
      operation: Operation.multiplication,
      correctAnswer: correctAnswer,
      options: allOptions,
    );
  }

  /// Gera uma questão de DIVISÃO
  /// Garante divisões EXATAS (sem resto) usando multiplicação invertida
  /// Exemplo: Se 7 × 8 = 56, então 56 ÷ 7 = 8
  Question _generateDivisionQuestion(int divisor, List<int> range) {
    // Gera o quociente (resultado da divisão)
    final quotient = range[0] + _random.nextInt(range[1] - range[0] + 1);
    
    // Calcula o dividendo para garantir divisão exata
    final dividend = divisor * quotient; // dividend ÷ divisor = quotient
    
    final wrongOptions = _generateWrongAnswersForDivision(
      dividend,
      divisor,
      quotient,
    );

    final allOptions = [quotient, ...wrongOptions]..shuffle();

    return Question(
      operandA: dividend,
      operandB: divisor,
      operation: Operation.division,
      correctAnswer: quotient,
      options: allOptions,
    );
  }

  /// Gera uma questão aleatória para qualquer tabuada/número
  Question generateRandomQuestion({
    Operation operation = Operation.multiplication,
    List<int>? tablesRange,
  }) {
    final range = tablesRange ?? [1, 10];
    final randomTable = range[0] + _random.nextInt(range[1] - range[0] + 1);
    return generateQuestion(randomTable, operation: operation);
  }

  /// Gera um conjunto de questões para um número/tabuada específico
  List<Question> generateQuestionSet(
    int tableNumber,
    int count, {
    Operation operation = Operation.multiplication,
  }) {
    final questions = <Question>[];
    final usedSecondOperands = <int>{};

    while (questions.length < count && usedSecondOperands.length < 10) {
      final secondOperand = 1 + _random.nextInt(10);
      
      if (!usedSecondOperands.contains(secondOperand)) {
        usedSecondOperands.add(secondOperand);
        questions.add(generateQuestion(
          tableNumber,
          operation: operation,
          secondOperandRange: [secondOperand, secondOperand],
        ));
      }
    }

    // Se precisar de mais questões que operandos únicos, permite repetição
    while (questions.length < count) {
      questions.add(generateQuestion(tableNumber, operation: operation));
    }

    return questions..shuffle();
  }

  // ============================================================
  // GERADORES DE ALTERNATIVAS INCORRETAS POR OPERAÇÃO
  // ============================================================

  /// Alternativas incorretas para ADIÇÃO
  /// Estratégias: erros de contagem, confusão com subtração
  List<int> _generateWrongAnswersForAddition(
    int operandA,
    int operandB,
    int correctAnswer,
  ) {
    final wrongAnswers = <int>{};

    // Estratégia 1: Erro de contagem (±1, ±2)
    for (final delta in [1, -1, 2, -2]) {
      final option = correctAnswer + delta;
      if (option > 0 && option != correctAnswer) {
        wrongAnswers.add(option);
      }
    }

    // Estratégia 2: Confusão com subtração
    final subtraction = (operandA - operandB).abs();
    if (subtraction != correctAnswer && subtraction > 0) {
      wrongAnswers.add(subtraction);
    }

    // Estratégia 3: Confusão com multiplicação
    final multiplication = operandA * operandB;
    if (multiplication != correctAnswer && multiplication > 0) {
      wrongAnswers.add(multiplication);
    }

    // Preenche com variações aleatórias se necessário
    _fillWithRandomVariations(wrongAnswers, correctAnswer, 3);

    return wrongAnswers.take(3).toList();
  }

  /// Alternativas incorretas para SUBTRAÇÃO
  /// Estratégias: erros de contagem, confusão com adição, inversão
  List<int> _generateWrongAnswersForSubtraction(
    int operandA,
    int operandB,
    int correctAnswer,
  ) {
    final wrongAnswers = <int>{};

    // Estratégia 1: Erro de contagem (±1, ±2)
    for (final delta in [1, -1, 2, -2]) {
      final option = correctAnswer + delta;
      if (option > 0 && option != correctAnswer) {
        wrongAnswers.add(option);
      }
    }

    // Estratégia 2: Confusão com adição
    final addition = operandA + operandB;
    if (addition != correctAnswer) {
      wrongAnswers.add(addition);
    }

    // Estratégia 3: Inversão (operandB - operandA, se positivo)
    if (operandB > operandA) {
      final inverted = operandB - operandA;
      if (inverted != correctAnswer) {
        wrongAnswers.add(inverted);
      }
    }

    // Preenche com variações aleatórias se necessário
    _fillWithRandomVariations(wrongAnswers, correctAnswer, 3);

    return wrongAnswers.take(3).toList();
  }

  /// Alternativas incorretas para MULTIPLICAÇÃO (original)
  /// Estratégias: tabuada adjacente, confusão com adição
  List<int> _generateWrongAnswersForMultiplication(
    int operandA,
    int operandB,
    int correctAnswer,
  ) {
    final wrongAnswers = <int>{};

    // Estratégia 1: Correto ± 1 (erro de contagem)
    final option1 = correctAnswer + (_random.nextBool() ? 1 : -1);
    if (option1 > 0 && option1 != correctAnswer) {
      wrongAnswers.add(option1);
    }

    // Estratégia 2: Tabuada adjacente
    final adjacentOperandB = operandB + (_random.nextBool() ? 1 : -1);
    if (adjacentOperandB > 0 && adjacentOperandB <= 10) {
      final option2 = operandA * adjacentOperandB;
      if (option2 != correctAnswer) {
        wrongAnswers.add(option2);
      }
    }

    // Estratégia 3: Confusão de operação (adição)
    final option3 = operandA + operandB;
    if (option3 != correctAnswer && option3 > 0) {
      wrongAnswers.add(option3);
    }

    // Preenche com variações aleatórias se necessário
    _fillWithRandomVariations(wrongAnswers, correctAnswer, 3);

    return wrongAnswers.take(3).toList();
  }

  /// Alternativas incorretas para DIVISÃO
  /// Estratégias: quocientes adjacentes, confusão com divisor
  List<int> _generateWrongAnswersForDivision(
    int dividend,
    int divisor,
    int correctAnswer,
  ) {
    final wrongAnswers = <int>{};

    // Estratégia 1: Quociente adjacente (±1, ±2)
    for (final delta in [1, -1, 2, -2]) {
      final option = correctAnswer + delta;
      if (option > 0 && option != correctAnswer) {
        wrongAnswers.add(option);
        if (wrongAnswers.length >= 2) break;
      }
    }

    // Estratégia 2: Confusão com o divisor
    if (divisor != correctAnswer && divisor > 0) {
      wrongAnswers.add(divisor);
    }

    // Estratégia 3: Confusão com multiplicação (dividend * divisor é muito grande, use outros)
    // Usar o dividendo dividido por outro número próximo
    final nearbyDivisor = divisor + (_random.nextBool() ? 1 : -1);
    if (nearbyDivisor > 0 && dividend % nearbyDivisor == 0) {
      final nearbyQuotient = dividend ~/ nearbyDivisor;
      if (nearbyQuotient != correctAnswer && nearbyQuotient > 0) {
        wrongAnswers.add(nearbyQuotient);
      }
    }

    // Preenche com variações aleatórias se necessário
    _fillWithRandomVariations(wrongAnswers, correctAnswer, 3);

    return wrongAnswers.take(3).toList();
  }

  /// Método auxiliar para preencher com variações aleatórias
  void _fillWithRandomVariations(Set<int> answers, int correctAnswer, int target) {
    while (answers.length < target) {
      final variation = _random.nextInt(10) + 1; // 1 a 10
      final option = correctAnswer + (_random.nextBool() ? variation : -variation);
      
      if (option > 0 && option != correctAnswer && !answers.contains(option)) {
        answers.add(option);
      }
    }
  }
}
