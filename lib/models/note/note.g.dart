// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Note _$NoteFromJson(Map<String, dynamic> json) => Note(
//       id: json['id'] as String?,
//       title: json['title'] as String,
//       content: json['content'] as String,
//       dataEntry: json['dataEntry'] as String,
//       isActive: json['isActive'] as bool,
//       associatedType: json['associatedType'] as String?,
//       associatedValue: json['associatedValue'] as String?,
//       name: json['name'] == null
//           ? null
//           : NameNote.fromJson(json['name'] as Map<String, dynamic>),
//       payment: json['payment'] == null
//           ? null
//           : PaymentNote.fromJson(json['payment'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
//       'id': instance.id,
//       'title': instance.title,
//       'content': instance.content,
//       'dataEntry': instance.dataEntry,
//       'isActive': instance.isActive,
//       'associatedType': instance.associatedType,
//       'associatedValue': instance.associatedValue,
//       'payment': instance.payment,
//       'name': instance.name,
//     };

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['_id'] == null ? null : json['_id'] as String,
      title: json['title'] as String,
      // dataEntry: DateTime.parse(json['dataEntry']),
      content: json['content'] as String,
      dataEntry: json['dataEntry'] as String,
      isActive: json['isActive'] as bool,
      associatedType: json['associatedType'] == null
          ? null
          : json['associatedType'] as String,
      associatedValue: json['associatedValue'] == null
          ? null
          : json['associatedValue'] as String,
      payment: json['payment'] != null
          ? PaymentNote.fromJson(json['payment'])
          : null,
      name: json['name'] != null ? NameNote.fromJson(json['name']) : null,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'title': instance.title,
      'content': instance.content,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
      'associatedType': instance.associatedType?.toString(),
      'associatedValue': instance.associatedValue?.toString(),
      if (instance.payment != null) 'payment': instance.payment!.toString(),
      if (instance.name != null) 'name': instance.name!.toString(),
    };
