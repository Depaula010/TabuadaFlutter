/// Enum representando as 4 operações matemáticas básicas
enum Operation {
  addition,      // Adição (+)
  subtraction,   // Subtração (-)
  multiplication, // Multiplicação (×)
  division,      // Divisão (÷)
}

/// Extensão para obter o símbolo da operação
extension OperationSymbol on Operation {
  /// Retorna o símbolo matemático da operação
  String get symbol {
    switch (this) {
      case Operation.addition:
        return '+';
      case Operation.subtraction:
        return '-';
      case Operation.multiplication:
        return '×';
      case Operation.division:
        return '÷';
    }
  }

  /// Retorna o nome da operação em português
  String get displayName {
    switch (this) {
      case Operation.addition:
        return 'Adição';
      case Operation.subtraction:
        return 'Subtração';
      case Operation.multiplication:
        return 'Multiplicação';
      case Operation.division:
        return 'Divisão';
    }
  }
}

/// Modelo de questão matemática genérico para as 4 operações
class Question {
  final int operandA;        // Primeiro operando (ex: 7 em 7 + 8)
  final int operandB;        // Segundo operando (ex: 8 em 7 + 8)
  final Operation operation; // Tipo da operação
  final int correctAnswer;
  final List<int> options;   // 4 opções: 1 correta + 3 incorretas

  Question({
    required this.operandA,
    required this.operandB,
    required this.operation,
    required this.correctAnswer,
    required this.options,
  });

  /// Getter para exibir a questão formatada com símbolo correto
  String get questionText => '$operandA ${operation.symbol} $operandB = ?';

  /// Verifica se a resposta está correta
  bool isCorrectAnswer(int answer) => answer == correctAnswer;

  /// Cria uma cópia da questão com opções embaralhadas
  Question copyWithShuffledOptions() {
    final shuffledOptions = List<int>.from(options)..shuffle();
    return Question(
      operandA: operandA,
      operandB: operandB,
      operation: operation,
      correctAnswer: correctAnswer,
      options: shuffledOptions,
    );
  }

  @override
  String toString() =>
      'Question($operandA ${operation.symbol} $operandB = $correctAnswer, options: $options)';
}
