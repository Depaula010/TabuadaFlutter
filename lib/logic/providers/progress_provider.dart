import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../data/models/game_progress.dart';
import '../../data/models/trophy.dart';
import '../../data/models/question.dart';
import '../../data/services/hive_service.dart';

/// Provider para gerenciar progresso e troféus
class ProgressProvider extends ChangeNotifier {
  Map<int, GameProgress> _currentOperationProgress = {};
  List<Trophy> _allTrophies = [];
  Operation _currentOperation = Operation.multiplication;

  ProgressProvider() {
    // Carrega dados sincronamente primeiro (sem notificar)
    _currentOperationProgress = HiveService.getAllProgressForOperation(_currentOperation);
    _allTrophies = HiveService.getAllTrophies();
    // Notifica após o frame atual para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Getters
  Map<int, GameProgress> get allProgress => _currentOperationProgress;
  List<Trophy> get allTrophies => _allTrophies;
  List<Trophy> get unlockedTrophies =>
      _allTrophies.where((t) => t.isUnlocked).toList();
  int get totalStars =>
      _currentOperationProgress.values.fold(0, (sum, progress) => sum + progress.starsEarned);
  int get completedTablesCount =>
      _currentOperationProgress.values.where((p) => p.isCompleted).length;
  Operation get currentOperation => _currentOperation;

  /// Carrega todo o progresso para uma operação específica
  void loadProgressForOperation(Operation operation) {
    _currentOperation = operation;
    _currentOperationProgress = HiveService.getAllProgressForOperation(operation);
    _allTrophies = HiveService.getAllTrophies();
    notifyListeners();
  }

  /// Obtém progresso de uma tabuada e operação específica
  GameProgress? getTableProgress(int tableNumber, Operation operation) {
    // Se é a operação atual em cache, usa o cache
    if (operation == _currentOperation) {
      return _currentOperationProgress[tableNumber];
    }
    // Caso contrário, busca direto do Hive
    return HiveService.getProgress(tableNumber, operation);
  }

  /// Verifica se uma tabuada está completa para uma operação
  bool isTableCompleted(int tableNumber, Operation operation) {
    final progress = getTableProgress(tableNumber, operation);
    return progress?.isCompleted ?? false;
  }

  /// Obtém quantidade de estrelas de uma tabuada para uma operação
  int getTableStars(int tableNumber, Operation operation) {
    final progress = getTableProgress(tableNumber, operation);
    return progress?.starsEarned ?? 0;
  }

  /// Percentual global de conclusão (todas as tabuadas da operação atual)
  double get globalCompletionPercentage {
    if (_currentOperationProgress.isEmpty) return 0.0;
    return (completedTablesCount / 10) * 100;
  }

  /// Melhor pontuação no Time Attack geral
  int get bestTimeAttackScore {
    return _currentOperationProgress.values
        .map((p) => p.bestTimeAttackScore)
        .fold(0, (a, b) => a > b ? a : b);
  }

  /// Atualiza o cache quando o progresso de uma operação é salvo
  void refreshProgress(Operation operation) {
    if (operation == _currentOperation) {
      _currentOperationProgress = HiveService.getAllProgressForOperation(operation);
      notifyListeners();
    }
  }
}
