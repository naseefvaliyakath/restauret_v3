// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frequent_food.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrequentFoodAdapter extends TypeAdapter<FrequentFood> {
  @override
  final int typeId = 2;

  @override
  FrequentFood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrequentFood(
      id: fields[0] as int,
      fdId: fields[1] as int?,
      count: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FrequentFood obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fdId)
      ..writeByte(2)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequentFoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
