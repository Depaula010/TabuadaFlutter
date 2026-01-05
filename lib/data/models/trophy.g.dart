// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trophy.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrophyAdapter extends TypeAdapter<Trophy> {
  @override
  final int typeId = 1;

  @override
  Trophy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trophy(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      iconName: fields[3] as String,
      category: fields[4] as TrophyCategory,
      isUnlocked: fields[5] as bool,
      unlockedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Trophy obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.iconName)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.isUnlocked)
      ..writeByte(6)
      ..write(obj.unlockedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrophyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrophyCategoryAdapter extends TypeAdapter<TrophyCategory> {
  @override
  final int typeId = 2;

  @override
  TrophyCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TrophyCategory.beginner;
      case 1:
        return TrophyCategory.master;
      case 2:
        return TrophyCategory.speed;
      case 3:
        return TrophyCategory.perfectionist;
      case 4:
        return TrophyCategory.collector;
      default:
        return TrophyCategory.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, TrophyCategory obj) {
    switch (obj) {
      case TrophyCategory.beginner:
        writer.writeByte(0);
        break;
      case TrophyCategory.master:
        writer.writeByte(1);
        break;
      case TrophyCategory.speed:
        writer.writeByte(2);
        break;
      case TrophyCategory.perfectionist:
        writer.writeByte(3);
        break;
      case TrophyCategory.collector:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrophyCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
