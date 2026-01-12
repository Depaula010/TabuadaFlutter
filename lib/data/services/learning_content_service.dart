import '../models/question.dart';

/// Modelo para um card de conteúdo educativo
class LearningCard {
  final String title;        // Título do card (ex: "Tabuada do 3")
  final String explanation;  // Explicação do conceito
  final String visualTip;    // Dica visual/prática
  final List<String> examples; // Exemplos práticos

  const LearningCard({
    required this.title,
    required this.explanation,
    required this.visualTip,
    required this.examples,
  });
}

/// Serviço que fornece conteúdo educativo para o módulo "Aprender"
/// 
/// Retorna cards de explicação baseados na operação e número selecionados.
/// O conteúdo é adequado para crianças de 6 a 12 anos.
class LearningContentService {
  LearningContentService._(); // Construtor privado

  /// Retorna um card de conteúdo para a operação e número especificados
  static LearningCard getContent(Operation operation, int number) {
    switch (operation) {
      case Operation.addition:
        return _getAdditionContent(number);
      case Operation.subtraction:
        return _getSubtractionContent(number);
      case Operation.multiplication:
        return _getMultiplicationContent(number);
      case Operation.division:
        return _getDivisionContent(number);
    }
  }

  /// Retorna o conteúdo introdutório para uma operação (sem número específico)
  static LearningCard getOperationIntro(Operation operation) {
    switch (operation) {
      case Operation.addition:
        return const LearningCard(
          title: 'O que é Adição?',
          explanation: 'Adição é juntar coisas! Quando você tem alguns objetos '
              'e ganha mais, você está fazendo uma adição. O símbolo da adição é o "+".',
          visualTip: '🍎 + 🍎🍎 = 🍎🍎🍎\n'
              'Uma maçã mais duas maçãs é igual a três maçãs!',
          examples: [
            '2 + 3 = 5 (dois mais três é igual a cinco)',
            '4 + 1 = 5 (quatro mais um é igual a cinco)',
            '5 + 5 = 10 (cinco mais cinco é igual a dez)',
          ],
        );

      case Operation.subtraction:
        return const LearningCard(
          title: 'O que é Subtração?',
          explanation: 'Subtração é tirar coisas! Quando você tem alguns objetos '
              'e perde ou dá alguns, você está fazendo uma subtração. O símbolo é o "-".',
          visualTip: '🍎🍎🍎 - 🍎 = 🍎🍎\n'
              'Três maçãs menos uma maçã é igual a duas maçãs!',
          examples: [
            '5 - 2 = 3 (cinco menos dois é igual a três)',
            '7 - 4 = 3 (sete menos quatro é igual a três)',
            '10 - 5 = 5 (dez menos cinco é igual a cinco)',
          ],
        );

      case Operation.multiplication:
        return const LearningCard(
          title: 'O que é Multiplicação?',
          explanation: 'Multiplicação é somar o mesmo número várias vezes! '
              'É como ter grupos iguais de coisas. O símbolo é o "×".',
          visualTip: '🍎🍎 × 3 = 🍎🍎 + 🍎🍎 + 🍎🍎 = 🍎🍎🍎🍎🍎🍎\n'
              'Duas maçãs vezes três é como ter três grupos de duas maçãs!',
          examples: [
            '2 × 3 = 6 (dois vezes três é igual a seis)',
            '4 × 2 = 8 (quatro vezes dois é igual a oito)',
            '5 × 5 = 25 (cinco vezes cinco é igual a vinte e cinco)',
          ],
        );

      case Operation.division:
        return const LearningCard(
          title: 'O que é Divisão?',
          explanation: 'Divisão é repartir igualmente! Quando você divide algo, '
              'está separando em partes iguais. O símbolo é o "÷".',
          visualTip: '🍎🍎🍎🍎🍎🍎 ÷ 2 = 🍎🍎🍎\n'
              'Seis maçãs divididas por dois é igual a três maçãs para cada um!',
          examples: [
            '6 ÷ 2 = 3 (seis dividido por dois é igual a três)',
            '8 ÷ 4 = 2 (oito dividido por quatro é igual a dois)',
            '10 ÷ 5 = 2 (dez dividido por cinco é igual a dois)',
          ],
        );
    }
  }

  // ============================================================
  // CONTEÚDO ESPECÍFICO POR OPERAÇÃO E NÚMERO
  // ============================================================

  /// Conteúdo para ADIÇÃO com um número específico
  static LearningCard _getAdditionContent(int number) {
    return LearningCard(
      title: 'Adição com o número $number',
      explanation: 'Vamos aprender a somar com o número $number! '
          'Somar é juntar quantidades. Quando adicionamos $number a outro número, '
          'estamos aumentando a quantidade em $number unidades.',
      visualTip: _generateVisualTipAddition(number),
      examples: _generateExamplesAddition(number),
    );
  }

  /// Conteúdo para SUBTRAÇÃO com um número específico
  static LearningCard _getSubtractionContent(int number) {
    return LearningCard(
      title: 'Subtração com o número $number',
      explanation: 'Vamos aprender a subtrair com o número $number! '
          'Subtrair é tirar uma quantidade. Quando subtraímos $number, '
          'estamos diminuindo a quantidade em $number unidades.',
      visualTip: _generateVisualTipSubtraction(number),
      examples: _generateExamplesSubtraction(number),
    );
  }

  /// Conteúdo para MULTIPLICAÇÃO (tabuada) com um número específico
  static LearningCard _getMultiplicationContent(int number) {
    return LearningCard(
      title: 'Tabuada do $number',
      explanation: 'A tabuada do $number mostra os resultados de multiplicar '
          '$number por outros números. Multiplicar $number por um número é o mesmo '
          'que somar o $number esse número de vezes!',
      visualTip: _generateVisualTipMultiplication(number),
      examples: _generateExamplesMultiplication(number),
    );
  }

  /// Conteúdo para DIVISÃO com um número específico
  static LearningCard _getDivisionContent(int number) {
    return LearningCard(
      title: 'Divisão por $number',
      explanation: 'Vamos aprender a dividir por $number! '
          'Dividir por $number significa separar em $number partes iguais. '
          'É como repartir igualmente entre $number pessoas!',
      visualTip: _generateVisualTipDivision(number),
      examples: _generateExamplesDivision(number),
    );
  }

  // ============================================================
  // GERADORES DE DICAS VISUAIS
  // ============================================================

  static String _generateVisualTipAddition(int number) {
    const emoji = '⭐';
    final base = emoji * number;
    return '$number + 3 = ?\n'
        '$base + $emoji$emoji$emoji = ${emoji * (number + 3)}\n'
        'Juntamos $number estrelas com 3 estrelas e temos ${number + 3} estrelas!';
  }

  static String _generateVisualTipSubtraction(int number) {
    final total = number + 5;
    return '$total - $number = ?\n'
        'Se você tem $total balas e come $number, '
        'ficam ${total - number} balas!';
  }

  static String _generateVisualTipMultiplication(int number) {
    const times = 4;
    const emoji = '🌟';
    final group = emoji * number;
    return '$number × $times = ?\n'
        'É como ter $times grupos de $number estrelas:\n'
        '$group + $group + $group + $group = ${emoji * (number * times)}\n'
        'Ou seja, somar o $number exatamente $times vezes!';
  }

  static String _generateVisualTipDivision(int number) {
    final total = number * 3;
    return '$total ÷ $number = ?\n'
        'Se você tem $total doces e quer dividir igualmente '
        'em $number grupos, cada grupo terá 3 doces!';
  }

  // ============================================================
  // GERADORES DE EXEMPLOS
  // ============================================================

  static List<String> _generateExamplesAddition(int number) {
    return [
      '$number + 1 = ${number + 1}',
      '$number + 5 = ${number + 5}',
      '$number + 10 = ${number + 10}',
      '${number + 3} + $number = ${(number + 3) + number}',
    ];
  }

  static List<String> _generateExamplesSubtraction(int number) {
    return [
      '${number + 5} - $number = 5',
      '${number + 10} - $number = 10',
      '${number * 2} - $number = $number',
      '${number + 3} - 3 = $number',
    ];
  }

  static List<String> _generateExamplesMultiplication(int number) {
    return [
      '$number × 1 = $number',
      '$number × 2 = ${number * 2}',
      '$number × 5 = ${number * 5}',
      '$number × 10 = ${number * 10}',
    ];
  }

  static List<String> _generateExamplesDivision(int number) {
    return [
      '${number * 2} ÷ $number = 2',
      '${number * 5} ÷ $number = 5',
      '${number * 10} ÷ $number = 10',
      '$number ÷ $number = 1',
    ];
  }
}
