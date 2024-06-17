part of 'task_code.dart';

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
