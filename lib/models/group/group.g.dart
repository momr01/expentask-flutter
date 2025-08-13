// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Group _$GroupFromJson(Map<String, dynamic> json) => Group(
//       id: json['id'] as String?,
//       name: json['name'] as String,
//       dataEntry: json['dataEntry'] as String,
//       isActive: json['isActive'] as bool,
//       paymentNames: (json['paymentNames'] as List<dynamic>)
//           .map((e) => PaymentName.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );

// Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'dataEntry': instance.dataEntry,
//       'isActive': instance.isActive,
//       'paymentNames': instance.paymentNames,
//     };

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
    id: json['_id'] == null ? null : json['_id'] as String,
    name: json['name'] as String,
    // dataEntry: DateTime.parse(json['dataEntry']),
    dataEntry: json['dataEntry'] as String,
    isActive: json['isActive'] as bool,
    paymentNames: List<PaymentName>.from(
        (json['paymentNames']?.map((x) => PaymentName.fromJson(x)))));

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
      'paymentNames': instance.paymentNames,
    };
