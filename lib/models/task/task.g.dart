part of 'task.dart';

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
    id: json['_id'] == null ? null : json['_id'] as String,
    code: TaskCode.fromJson(json['code'][0]),
    deadline: DateTime.parse(json['deadline']),
    isActive: json['isActive'] as bool,
    isCompleted: json['isCompleted'] as bool,
    dateCompleted: json['dateCompleted'] == null
        ? null
        : DateTime.parse(json['dateCompleted']),
    place: json['place'] == null ? null : json['place'] as String);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'code': instance.code,
      'deadline': instance.deadline,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'dateCompleted': instance.dateCompleted?.toString(),
      'place': instance.place?.toString()
    };
