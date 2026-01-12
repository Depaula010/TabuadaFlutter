import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../data/models/game_progress.dart';
import '../../data/models/trophy.dart';
import '../../data/services/hive_service.dart';

/// Provider para gerenciar progresso e troféus
class ProgressProvider extends ChangeNotifier {
  Map<int, GameProgress> _allProgress = {};
  List<Trophy> _allTrophies = [];

  ProgressProvider() {
    // Carrega dados sincronamente primeiro (sem notificar)
    _allProgress = HiveService.getAllProgress();
    _allTrophies = HiveService.getAllTrophies();
    // Notifica após o frame atual para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Getters
  Map<int, GameProgress> get allProgress => _allProgress;
  List<Trophy> get allTrophies => _allTrophies;
  List<Trophy> get unlockedTrophies =>
      _allTrophies.where((t) => t.isUnlocked).toList();
  int get totalStars =>
      _allProgress.values.fold(0, (sum, progress) => sum + progress.starsEarned);
  int get completedTablesCount =>
      _allProgress.values.where((p) => p.isCompleted).length;

  /// Carrega todo o progresso do Hive
  Future<void> loadProgress() async {
    _allProgress = HiveService.getAllProgress();
    _allTrophies = HiveService.getAllTrophies();
    notifyListeners();
  }

  /// Obtém progresso de uma tabuada específica
  GameProgress? getTableProgress(int tableNumber) {
    return _allProgress[tableNumber];
  }

  /// Verifica se uma tabuada está completa
  bool isTableCompleted(int tableNumber) {
    return _allProgress[tableNumber]?.isCompleted ?? false;
  }

  /// Obtém quantidade de estrelas de uma tabuada
  int getTableStars(int tableNumber) {
    return _allProgress[tableNumber]?.starsEarned ?? 0;
  }

  /// Percentual global de conclusão (todas as tabuadas)
  double get globalCompletionPercentage {
    if (_allProgress.isEmpty) return 0.0;
    return (completedTablesCount / 10) * 100;
  }

  /// Melhor pontuação no Time Attack geral
  int get bestTimeAttackScore {
    return _allProgress.values
        .map((p) => p.bestTimeAttackScore)
        .fold(0, (a, b) => a > b ? a : b);
  }
}
