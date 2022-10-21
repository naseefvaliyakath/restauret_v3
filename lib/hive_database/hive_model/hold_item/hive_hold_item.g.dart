// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_hold_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveHoldItemAdapter extends TypeAdapter<HiveHoldItem> {
  @override
  final int typeId = 0;

  @override
  HiveHoldItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveHoldItem(
      id: fields[0] as int,
      holdItem: (fields[1] as List?)?.cast<dynamic>(),
      date: fields[2] as String?,
      time: fields[3] as String?,
      totel: fields[4] as num?,
      orderType: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveHoldItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.holdItem)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.totel)
      ..writeByte(5)
      ..write(obj.orderType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveHoldItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
