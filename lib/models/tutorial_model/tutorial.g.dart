// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutorial _$TutorialFromJson(Map<String, dynamic> json) => Tutorial(
      json['tutorial_id'] as int?,
      json['appPlan'] as int?,
      json['title'] as String?,
      json['link'] as String?,
      json['createdAt'] as String?,
    );

Map<String, dynamic> _$TutorialToJson(Tutorial instance) => <String, dynamic>{
      'tutorial_id': instance.tutorial_id,
      'appPlan': instance.appPlan,
      'title': instance.title,
      'link': instance.link,
      'createdAt': instance.createdAt,
    };
