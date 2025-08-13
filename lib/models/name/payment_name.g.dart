// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// PaymentName _$PaymentNameFromJson(Map<String, dynamic> json) => PaymentName(
//       id: json['id'] as String?,
//       name: json['name'] as String,
//       isActive: json['isActive'] as bool,
//       category: Category.fromJson(json['category'] as Map<String, dynamic>),
//       defaultTasks: (json['defaultTasks'] as List<dynamic>?)
//           ?.map((e) => e as String)
//           .toList(),
//     );

// Map<String, dynamic> _$PaymentNameToJson(PaymentName instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'isActive': instance.isActive,
//       'category': instance.category,
//       'defaultTasks': instance.defaultTasks,
//     };

PaymentName _$PaymentNameFromJson(Map<String, dynamic> json) => PaymentName(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    isActive: json['isActive'] as bool,
    category: Category.fromJson(json['category'][0]),
    // defaultTasks:
    //     json['defaultTasks'] == null ? [] : json['defaultTasks'] as List<String>
    defaultTasks: json['defaultTasks'] == null
        ? []
        : List<String>.from((json['defaultTasks']?.map((task) => task))));

Map<String, dynamic> _$PaymentNameToJson(PaymentName instance) =>
    <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'isActive': instance.isActive,
      'category': instance.category,
      'defaultTasks': instance.defaultTasks?.toList()
    };
