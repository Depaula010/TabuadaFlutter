import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_progress.dart';
import '../models/trophy.dart';

/// Serviço de persistência local usando Hive
class HiveService {
  static const String _progressBoxName = 'game_progress';
  static const String _trophiesBoxName = 'trophies';
  static const String _settingsBoxName = 'settings';

  static late Box<GameProgress> _progressBox;
  static late Box<Trophy> _trophiesBox;
  static late Box _settingsBox;

  /// Inicializa o Hive e registra adaptadores
  static Future<void> init() async {
    await Hive.initFlutter();

    // Registra adaptadores (gerados pelo build_runner)
    Hive.registerAdapter(GameProgressAdapter());
    Hive.registerAdapter(TrophyAdapter());
    Hive.registerAdapter(TrophyCategoryAdapter());

    // Abre boxes
    _progressBox = await Hive.openBox<GameProgress>(_progressBoxName);
    _trophiesBox = await Hive.openBox<Trophy>(_trophiesBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);

    // Inicializa troféus padrão se não existirem
    if (_trophiesBox.isEmpty) {
      await _initializeDefaultTrophies();
    }
  }

  // ===== PROGRESSO =====

  /// Obtém o progresso de uma tabuada específica
  static GameProgress? getProgress(int tableNumber) {
    return _progressBox.get('table_$tableNumber');
  }

  /// Salva ou atualiza o progresso de uma tabuada
  static Future<void> saveProgress(GameProgress progress) async {
    await _progressBox.put('table_${progress.tableNumber}', progress);
  }

  /// Obtém todo o progresso (todas as tabuadas)
  static Map<int, GameProgress> getAllProgress() {
    final progressMap = <int, GameProgress>{};
    for (var i = 1; i <= 10; i++) {
      final progress = getProgress(i);
      if (progress != null) {
        progressMap[i] = progress;
      }
    }
    return progressMap;
  }

  /// Cria um novo progresso para uma tabuada se não existir
  static Future<GameProgress> getOrCreateProgress(int tableNumber) async {
    var progress = getProgress(tableNumber);
    if (progress == null) {
      progress = GameProgress(tableNumber: tableNumber);
      await saveProgress(progress);
    }
    return progress;
  }

  // ===== TROFÉUS =====

  /// Obtém todos os troféus
  static List<Trophy> getAllTrophies() {
    return _trophiesBox.values.toList();
  }

  /// Obtém troféus desbloqueados
  static List<Trophy> getUnlockedTrophies() {
    return _trophiesBox.values.where((trophy) => trophy.isUnlocked).toList();
  }

  /// Desbloqueia um troféu por ID
  static Future<void> unlockTrophy(String trophyId) async {
    final trophy = _trophiesBox.get(trophyId);
    if (trophy != null && !trophy.isUnlocked) {
      trophy.unlock();
      // IMPORTANTE: Salva o troféu no disco para persistência
      await _trophiesBox.put(trophyId, trophy);
    }
  }

  // ===== CONFIGURAÇÕES =====

  /// Salva uma configuração
  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Obtém uma configuração
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  /// Volume da música (0.0 - 1.0)
  static Future<void> setMusicVolume(double volume) async {
    await setSetting('music_volume', volume);
  }

  static double getMusicVolume() {
    return getSetting<double>('music_volume', defaultValue: 0.5) ?? 0.5;
  }

  /// Volume dos efeitos sonoros (0.0 - 1.0)
  static Future<void> setSfxVolume(double volume) async {
    await setSetting('sfx_volume', volume);
  }

  static double getSfxVolume() {
    return getSetting<double>('sfx_volume', defaultValue: 0.7) ?? 0.7;
  }

  /// Vibração habilitada
  static Future<void> setVibrationEnabled(bool enabled) async {
    await setSetting('vibration_enabled', enabled);
  }

  static bool isVibrationEnabled() {
    return getSetting<bool>('vibration_enabled', defaultValue: true) ?? true;
  }

  // ===== INICIALIZAÇÃO DE DADOS =====

  /// Inicializa os troféus padrão do jogo
  static Future<void> _initializeDefaultTrophies() async {
    final defaultTrophies = [
      Trophy(
        id: 'first_steps',
        title: 'Primeiros Passos',
        description: 'Complete sua primeira tabuada!',
        iconName: 'footsteps',
        category: TrophyCategory.beginner,
      ),
      Trophy(
        id: 'perfect_10',
        title: 'Perfeição Pura',
        description: 'Acerte 10 questões seguidas sem errar',
        iconName: 'diamond',
        category: TrophyCategory.perfectionist,
      ),
      Trophy(
        id: 'speed_demon',
        title: 'Raio de Cálculo',
        description: 'Complete uma tabuada em menos de 60 segundos',
        iconName: 'lightning',
        category: TrophyCategory.speed,
      ),
      Trophy(
        id: 'master_of_all',
        title: 'Mestre do Cálculo',
        description: 'Complete todas as tabuadas com 3 estrelas',
        iconName: 'crown',
        category: TrophyCategory.master,
      ),
      Trophy(
        id: 'time_attack_hero',
        title: 'Herói do Tempo',
        description: 'Alcance 50 pontos no modo Desafio Relâmpago',
        iconName: 'clock_star',
        category: TrophyCategory.speed,
      ),
    ];

    for (final trophy in defaultTrophies) {
      await _trophiesBox.put(trophy.id, trophy);
    }
  }

  /// Limpa todos os dados (útil para testes)
  static Future<void> clearAllData() async {
    await _progressBox.clear();
    await _trophiesBox.clear();
    await _settingsBox.clear();
    await _initializeDefaultTrophies();
  }
}
