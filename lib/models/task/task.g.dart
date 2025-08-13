// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Task _$TaskFromJson(Map<String, dynamic> json) => Task(
//       id: json['id'] as String?,
//       code: TaskCode.fromJson(json['code'] as Map<String, dynamic>),
//       deadline: DateTime.parse(json['deadline'] as String),
//       isActive: json['isActive'] as bool,
//       isCompleted: json['isCompleted'] as bool,
//       dateCompleted: json['dateCompleted'] == null
//           ? null
//           : DateTime.parse(json['dateCompleted'] as String),
//       place: json['place'] as String?,
//       amountPaid: (json['amountPaid'] as num).toDouble(),
//       instalmentNumber: (json['instalmentNumber'] as num).toInt(),
//     );

// Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
//       'id': instance.id,
//       'code': instance.code,
//       'deadline': instance.deadline.toIso8601String(),
//       'isActive': instance.isActive,
//       'isCompleted': instance.isCompleted,
//       'dateCompleted': instance.dateCompleted?.toIso8601String(),
//       'place': instance.place,
//       'amountPaid': instance.amountPaid,
//       'instalmentNumber': instance.instalmentNumber,
//     };

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
    id: json['_id'] == null ? null : json['_id'] as String,
    code: TaskCode.fromJson(json['code'][0]),
    deadline: DateTime.parse(json['deadline']),
    isActive: json['isActive'] as bool,
    isCompleted: json['isCompleted'] as bool,
    dateCompleted: json['dateCompleted'] == null
        ? null
        : DateTime.parse(json['dateCompleted']),
    place: json['place'] == null ? null : json['place'] as String,
    amountPaid: double.parse(json['amountPaid']),
    instalmentNumber: json['instalmentNumber'] as int);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'code': instance.code,
      'deadline': instance.deadline,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'dateCompleted': instance.dateCompleted?.toString(),
      'place': instance.place?.toString(),
      'amountPaid': instance.amountPaid,
      'instalmentNumber': instance.instalmentNumber
    };
