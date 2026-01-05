import 'package:hive/hive.dart';

part 'trophy.g.dart';

/// Modelo de troféu desbloqueável
@HiveType(typeId: 1)
class Trophy extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String iconName; // Nome do ícone ou asset

  @HiveField(4)
  final TrophyCategory category;

  @HiveField(5)
  bool isUnlocked;

  @HiveField(6)
  DateTime? unlockedAt;

  Trophy({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Desbloqueia o troféu
  void unlock() {
    isUnlocked = true;
    unlockedAt = DateTime.now();
    save();
  }

  @override
  String toString() => 'Trophy($title, unlocked: $isUnlocked)';
}

@HiveType(typeId: 2)
enum TrophyCategory {
  @HiveField(0)
  beginner, // Troféus iniciais

  @HiveField(1)
  master, // Dominar tabuadas

  @HiveField(2)
  speed, // Relacionado a Time Attack

  @HiveField(3)
  perfectionist, // Sequências perfeitas

  @HiveField(4)
  collector, // Conquistas de coleção
}
