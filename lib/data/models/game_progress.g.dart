// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 0;

  @override
  GameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameProgress(
      tableNumber: fields[0] as int,
      questionsAnswered: fields[1] as int,
      correctAnswers: fields[2] as int,
      wrongAnswers: fields[3] as int,
      bestTimeAttackScore: fields[4] as int,
      fastestCompletionTime: fields[5] as int,
      isCompleted: fields[6] as bool,
      starsEarned: fields[7] as int,
      lastPlayedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.tableNumber)
      ..writeByte(1)
      ..write(obj.questionsAnswered)
      ..writeByte(2)
      ..write(obj.correctAnswers)
      ..writeByte(3)
      ..write(obj.wrongAnswers)
      ..writeByte(4)
      ..write(obj.bestTimeAttackScore)
      ..writeByte(5)
      ..write(obj.fastestCompletionTime)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.starsEarned)
      ..writeByte(8)
      ..write(obj.lastPlayedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
