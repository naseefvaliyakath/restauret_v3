// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      json['room_id'] as int?,
      json['roomName'] as String?,
      json['fdShopId'] as int?,
      json['createdAt'] as String?,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'room_id': instance.room_id,
      'roomName': instance.roomName,
      'fdShopId': instance.fdShopId,
      'createdAt': instance.createdAt,
    };
