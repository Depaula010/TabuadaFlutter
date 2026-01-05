import 'package:hive/hive.dart';

part 'game_progress.g.dart';

/// Modelo de progresso do jogador
@HiveType(typeId: 0)
class GameProgress extends HiveObject {
  @HiveField(0)
  final int tableNumber; // Tabuada (1-10)

  @HiveField(1)
  int questionsAnswered;

  @HiveField(2)
  int correctAnswers;

  @HiveField(3)
  int wrongAnswers;

  @HiveField(4)
  int bestTimeAttackScore; // Melhor pontuação no modo Time Attack

  @HiveField(5)
  int fastestCompletionTime; // Tempo mais rápido em segundos

  @HiveField(6)
  bool isCompleted; // Se completou todas as questões desta tabuada

  @HiveField(7)
  int starsEarned; // Sistema de estrelas (0-3)

  @HiveField(8)
  DateTime? lastPlayedAt;

  GameProgress({
    required this.tableNumber,
    this.questionsAnswered = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.bestTimeAttackScore = 0,
    this.fastestCompletionTime = 0,
    this.isCompleted = false,
    this.starsEarned = 0,
    this.lastPlayedAt,
  });

  /// Percentual de acerto
  double get accuracy {
    if (questionsAnswered == 0) return 0.0;
    return (correctAnswers / questionsAnswered) * 100;
  }

  /// Registra uma resposta correta
  void recordCorrectAnswer() {
    correctAnswers++;
    questionsAnswered++;
    lastPlayedAt = DateTime.now();
    save();
  }

  /// Registra uma resposta errada
  void recordWrongAnswer() {
    wrongAnswers++;
    questionsAnswered++;
    lastPlayedAt = DateTime.now();
    save();
  }

  /// Atualiza o melhor tempo no Time Attack
  void updateBestTimeAttackScore(int score) {
    if (score > bestTimeAttackScore) {
      bestTimeAttackScore = score;
      save();
    }
  }

  /// Atualiza o tempo mais rápido de conclusão
  void updateFastestTime(int timeInSeconds) {
    if (fastestCompletionTime == 0 || timeInSeconds < fastestCompletionTime) {
      fastestCompletionTime = timeInSeconds;
      save();
    }
  }

  /// Marca a tabuada como completa e calcula estrelas
  void markCompleted() {
    isCompleted = true;
    starsEarned = _calculateStars();
    save();
  }

  /// Sistema de estrelas baseado na precisão
  int _calculateStars() {
    if (accuracy >= 95) return 3;
    if (accuracy >= 80) return 2;
    if (accuracy >= 60) return 1;
    return 0;
  }

  @override
  String toString() =>
      'GameProgress(tabuada: $tableNumber, precisão: ${accuracy.toStringAsFixed(1)}%, estrelas: $starsEarned)';
}
