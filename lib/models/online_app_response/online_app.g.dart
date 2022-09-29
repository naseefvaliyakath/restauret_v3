// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_app.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineApp _$OnlineAppFromJson(Map<String, dynamic> json) => OnlineApp(
      json['onlineApp_id'] as int?,
      json['fdShopId'] as int?,
      json['appName'] as String?,
      json['appImg'] as String?,
    );

Map<String, dynamic> _$OnlineAppToJson(OnlineApp instance) => <String, dynamic>{
      'onlineApp_id': instance.onlineApp_id,
      'fdShopId': instance.fdShopId,
      'appName': instance.appName,
      'appImg': instance.appImg,
    };
