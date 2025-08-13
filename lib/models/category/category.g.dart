// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
//       id: json['id'] as String?,
//       name: json['name'] as String,
//       isActive: json['isActive'] as bool,
//       listNames: (json['listNames'] as List<dynamic>?)
//           ?.map((e) => PaymentName.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );

// Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'isActive': instance.isActive,
//       'listNames': instance.listNames,
//     };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    isActive: json['isActive'] as bool,
    listNames: json['listNames'] == null
        ? []
        : List<PaymentName>.from(
            (json['listNames']?.map((x) => PaymentName.fromJson(x)))));

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'isActive': instance.isActive,
      'listNames': instance.listNames?.toList()
    };
