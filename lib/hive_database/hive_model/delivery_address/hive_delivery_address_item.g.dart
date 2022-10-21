// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_delivery_address_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDeliveryAddressAdapter extends TypeAdapter<HiveDeliveryAddress> {
  @override
  final int typeId = 1;

  @override
  HiveDeliveryAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDeliveryAddress(
      id: fields[0] as int,
      name: fields[1] as String?,
      number: fields[2] as int?,
      address: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveDeliveryAddress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDeliveryAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
