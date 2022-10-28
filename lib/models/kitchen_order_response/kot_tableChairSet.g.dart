// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_tableChairSet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KotTableChairSet _$KotTableChairSetFromJson(Map<String, dynamic> json) =>
    KotTableChairSet(
      json['Kot_id'] as int?,
      json['tableId'] as int,
      json['position'] as String?,
      json['chrIndex'] as int?,
      json['tbChrIndexInDb'] as int?,
    );

Map<String, dynamic> _$KotTableChairSetToJson(KotTableChairSet instance) =>
    <String, dynamic>{
      'Kot_id': instance.Kot_id,
      'tableId': instance.tableId,
      'position': instance.position,
      'chrIndex': instance.chrIndex,
      'tbChrIndexInDb': instance.tbChrIndexInDb,
    };
