// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creditor.dart';

Creditor _$CreditorFromJson(Map<String, dynamic> json) => Creditor(
      id: json['_id'] == null ? null : json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      dataEntry: json['dataEntry'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$CreditorToJson(Creditor instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'description': instance.description,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
    };
