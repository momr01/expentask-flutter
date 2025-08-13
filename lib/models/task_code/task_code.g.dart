// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// TaskCode _$TaskCodeFromJson(Map<String, dynamic> json) => TaskCode(
//       id: json['id'] as String?,
//       name: json['name'] as String,
//       user: json['user'] as String,
//       number: (json['number'] as num).toInt(),
//       abbr: json['abbr'] as String,
//     );

// Map<String, dynamic> _$TaskCodeToJson(TaskCode instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'user': instance.user,
//       'number': instance.number,
//       'abbr': instance.abbr,
//     };

TaskCode _$TaskCodeFromJson(Map<String, dynamic> json) => TaskCode(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    user: json['user'] as String,
    number: json['number'] as int,
    abbr: json['abbr'] as String);

Map<String, dynamic> _$TaskCodeToJson(TaskCode instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'user': instance.user,
      'number': instance.number,
      'abbr': instance.abbr
    };
