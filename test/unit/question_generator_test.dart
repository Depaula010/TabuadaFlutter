import 'package:flutter_test/flutter_test.dart';
import 'package:mestres_do_calculo/logic/game_engine/question_generator.dart';

void main() {
  late QuestionGenerator generator;

  setUp(() {
    generator = QuestionGenerator();
  });

  group('QuestionGenerator', () {
    test('deve gerar questão com resposta correta', () {
      final question = generator.generateQuestion(7, multiplierRange: [8, 8]);

      expect(question.multiplicand, 7);
      expect(question.multiplier, 8);
      expect(question.correctAnswer, 56);
    });

    test('deve gerar 4 opções de resposta', () {
      final question = generator.generateQuestion(5);

      expect(question.options.length, 4);
    });

    test('resposta correta deve estar nas opções', () {
      final question = generator.generateQuestion(3);

      expect(question.options, contains(question.correctAnswer));
    });

    test('não deve ter opções duplicadas', () {
      final question = generator.generateQuestion(9);

      final uniqueOptions = question.options.toSet();
      expect(uniqueOptions.length, question.options.length);
    });

    test('opções incorretas devem ser diferentes da correta', () {
      final question = generator.generateQuestion(4);

      final wrongOptions = question.options
          .where((opt) => opt != question.correctAnswer)
          .toList();

      expect(wrongOptions.length, 3);
      for (final option in wrongOptions) {
        expect(option, isNot(equals(question.correctAnswer)));
      }
    });

    test('deve gerar set de questões sem repetição de multiplicadores', () {
      final questions = generator.generateQuestionSet(6, 5);

      expect(questions.length, 5);

      final multipliers = questions.map((q) => q.multiplier).toSet();
      // Com 5 questões, esperamos pelo menos 5 multiplicadores únicos
      expect(multipliers.length, greaterThanOrEqualTo(5));
    });

    test('questão aleatória deve estar dentro do range de tabuadas', () {
      final question = generator.generateRandomQuestion(tablesRange: [1, 10]);

      expect(question.multiplicand, greaterThanOrEqualTo(1));
      expect(question.multiplicand, lessThanOrEqualTo(10));
      expect(question.multiplier, greaterThanOrEqualTo(1));
      expect(question.multiplier, lessThanOrEqualTo(10));
    });

    test('isCorrectAnswer deve validar resposta correta', () {
      final question = generator.generateQuestion(8, multiplierRange: [7, 7]);

      expect(question.isCorrectAnswer(56), isTrue);
      expect(question.isCorrectAnswer(55), isFalse);
      expect(question.isCorrectAnswer(64), isFalse);
    });

    test('questionText deve estar formatado corretamente', () {
      final question = generator.generateQuestion(2, multiplierRange: [3, 3]);

      expect(question.questionText, '2 × 3 = ?');
    });

    test('todas as opções devem ser positivas', () {
      // Testa várias vezes para cobrir aleatoriedade
      for (var i = 0; i < 10; i++) {
        final question = generator.generateQuestion(1 + (i % 10));

        for (final option in question.options) {
          expect(option, greaterThan(0));
        }
      }
    });

    test('copyWithShuffledOptions deve manter mesma questão', () {
      final original = generator.generateQuestion(5);
      final shuffled = original.copyWithShuffledOptions();

      expect(shuffled.multiplicand, original.multiplicand);
      expect(shuffled.multiplier, original.multiplier);
      expect(shuffled.correctAnswer, original.correctAnswer);
      expect(shuffled.options.toSet(), original.options.toSet());
    });
  });
}
