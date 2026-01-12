import 'package:flutter_test/flutter_test.dart';
import 'package:mestres_do_calculo/data/models/question.dart';
import 'package:mestres_do_calculo/logic/game_engine/question_generator.dart';

void main() {
  late QuestionGenerator generator;

  setUp(() {
    generator = QuestionGenerator();
  });

  // ============================================================
  // TESTES DE MULTIPLICAÇÃO (mantendo compatibilidade)
  // ============================================================
  group('QuestionGenerator - Multiplicação', () {
    test('deve gerar questão de multiplicação com resposta correta', () {
      final question = generator.generateQuestion(
        7,
        operation: Operation.multiplication,
        secondOperandRange: [8, 8],
      );

      expect(question.operandA, 7);
      expect(question.operandB, 8);
      expect(question.operation, Operation.multiplication);
      expect(question.correctAnswer, 56);
    });

    test('deve gerar 4 opções de resposta', () {
      final question = generator.generateQuestion(5, operation: Operation.multiplication);

      expect(question.options.length, 4);
    });

    test('resposta correta deve estar nas opções', () {
      final question = generator.generateQuestion(3, operation: Operation.multiplication);

      expect(question.options, contains(question.correctAnswer));
    });

    test('não deve ter opções duplicadas', () {
      final question = generator.generateQuestion(9, operation: Operation.multiplication);

      final uniqueOptions = question.options.toSet();
      expect(uniqueOptions.length, question.options.length);
    });

    test('opções incorretas devem ser diferentes da correta', () {
      final question = generator.generateQuestion(4, operation: Operation.multiplication);

      final wrongOptions = question.options
          .where((opt) => opt != question.correctAnswer)
          .toList();

      expect(wrongOptions.length, 3);
      for (final option in wrongOptions) {
        expect(option, isNot(equals(question.correctAnswer)));
      }
    });

    test('questionText deve exibir símbolo de multiplicação', () {
      final question = generator.generateQuestion(
        2,
        operation: Operation.multiplication,
        secondOperandRange: [3, 3],
      );

      expect(question.questionText, '2 × 3 = ?');
    });
  });

  // ============================================================
  // TESTES DE ADIÇÃO
  // ============================================================
  group('QuestionGenerator - Adição', () {
    test('deve gerar questão de adição com resposta correta', () {
      final question = generator.generateQuestion(
        7,
        operation: Operation.addition,
        secondOperandRange: [5, 5],
      );

      expect(question.operandA, 7);
      expect(question.operandB, 5);
      expect(question.operation, Operation.addition);
      expect(question.correctAnswer, 12);
    });

    test('questionText deve exibir símbolo de adição', () {
      final question = generator.generateQuestion(
        4,
        operation: Operation.addition,
        secondOperandRange: [3, 3],
      );

      expect(question.questionText, '4 + 3 = ?');
    });

    test('deve gerar 4 opções válidas', () {
      final question = generator.generateQuestion(5, operation: Operation.addition);

      expect(question.options.length, 4);
      expect(question.options, contains(question.correctAnswer));
    });

    test('todas as opções devem ser positivas', () {
      for (var i = 0; i < 10; i++) {
        final question = generator.generateQuestion(
          1 + (i % 10),
          operation: Operation.addition,
        );

        for (final option in question.options) {
          expect(option, greaterThan(0));
        }
      }
    });
  });

  // ============================================================
  // TESTES DE SUBTRAÇÃO
  // ============================================================
  group('QuestionGenerator - Subtração', () {
    test('deve gerar questão de subtração com resposta não-negativa', () {
      for (var i = 0; i < 20; i++) {
        final question = generator.generateQuestion(
          5,
          operation: Operation.subtraction,
        );

        expect(question.correctAnswer, greaterThanOrEqualTo(0),
            reason: 'Subtração deve ter resultado não-negativo');
        expect(question.operandA, greaterThanOrEqualTo(question.operandB),
            reason: 'operandA deve ser >= operandB para evitar negativos');
      }
    });

    test('questionText deve exibir símbolo de subtração', () {
      final question = generator.generateQuestion(
        5,
        operation: Operation.subtraction,
        secondOperandRange: [3, 3],
      );

      // operandA = 5 + 3 = 8, operandB = 3, resultado = 5
      expect(question.questionText, '8 - 3 = ?');
      expect(question.correctAnswer, 5);
    });

    test('deve gerar 4 opções válidas', () {
      final question = generator.generateQuestion(5, operation: Operation.subtraction);

      expect(question.options.length, 4);
      expect(question.options, contains(question.correctAnswer));
    });
  });

  // ============================================================
  // TESTES DE DIVISÃO
  // ============================================================
  group('QuestionGenerator - Divisão', () {
    test('deve gerar divisões exatas (sem resto)', () {
      for (var i = 0; i < 20; i++) {
        final divisor = 2 + (i % 9); // Divisores de 2 a 10
        final question = generator.generateQuestion(
          divisor,
          operation: Operation.division,
        );

        // Verifica que é divisão exata
        expect(question.operandA % question.operandB, 0,
            reason: 'Divisão deve ser exata (sem resto)');
        expect(question.operandA ~/ question.operandB, question.correctAnswer);
      }
    });

    test('questionText deve exibir símbolo de divisão', () {
      final question = generator.generateQuestion(
        4,
        operation: Operation.division,
        secondOperandRange: [3, 3],
      );

      // dividend = 4 * 3 = 12, divisor = 4, quotient = 3
      expect(question.questionText, '12 ÷ 4 = ?');
      expect(question.correctAnswer, 3);
    });

    test('deve gerar 4 opções válidas', () {
      final question = generator.generateQuestion(5, operation: Operation.division);

      expect(question.options.length, 4);
      expect(question.options, contains(question.correctAnswer));
    });

    test('todas as opções devem ser positivas', () {
      for (var i = 0; i < 10; i++) {
        final question = generator.generateQuestion(
          2 + (i % 9),
          operation: Operation.division,
        );

        for (final option in question.options) {
          expect(option, greaterThan(0));
        }
      }
    });
  });

  // ============================================================
  // TESTES GERAIS
  // ============================================================
  group('QuestionGenerator - Geral', () {
    test('deve gerar set de questões sem repetição', () {
      final questions = generator.generateQuestionSet(
        6,
        5,
        operation: Operation.multiplication,
      );

      expect(questions.length, 5);

      final operandBs = questions.map((q) => q.operandB).toSet();
      expect(operandBs.length, greaterThanOrEqualTo(5));
    });

    test('questão aleatória deve estar dentro do range', () {
      final question = generator.generateRandomQuestion(
        operation: Operation.multiplication,
        tablesRange: [1, 10],
      );

      expect(question.operandA, greaterThanOrEqualTo(1));
      expect(question.operandA, lessThanOrEqualTo(10));
    });

    test('isCorrectAnswer deve validar resposta correta', () {
      final question = generator.generateQuestion(
        8,
        operation: Operation.multiplication,
        secondOperandRange: [7, 7],
      );

      expect(question.isCorrectAnswer(56), isTrue);
      expect(question.isCorrectAnswer(55), isFalse);
      expect(question.isCorrectAnswer(64), isFalse);
    });

    test('copyWithShuffledOptions deve manter mesma questão', () {
      final original = generator.generateQuestion(5, operation: Operation.multiplication);
      final shuffled = original.copyWithShuffledOptions();

      expect(shuffled.operandA, original.operandA);
      expect(shuffled.operandB, original.operandB);
      expect(shuffled.operation, original.operation);
      expect(shuffled.correctAnswer, original.correctAnswer);
      expect(shuffled.options.toSet(), original.options.toSet());
    });
  });

  // ============================================================
  // TESTES DO ENUM OPERATION
  // ============================================================
  group('Operation enum', () {
    test('deve retornar símbolos corretos', () {
      expect(Operation.addition.symbol, '+');
      expect(Operation.subtraction.symbol, '-');
      expect(Operation.multiplication.symbol, '×');
      expect(Operation.division.symbol, '÷');
    });

    test('deve retornar nomes em português', () {
      expect(Operation.addition.displayName, 'Adição');
      expect(Operation.subtraction.displayName, 'Subtração');
      expect(Operation.multiplication.displayName, 'Multiplicação');
      expect(Operation.division.displayName, 'Divisão');
    });
  });
}
