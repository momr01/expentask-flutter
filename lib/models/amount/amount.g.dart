// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
//       id: json['id'] as String?,
//       description: json['description'] as String,
//       amount: (json['amount'] as num).toDouble(),
//       date: DateTime.parse(json['date'] as String),
//       dataEntry: json['dataEntry'] as String,
//       isActive: json['isActive'] as bool,
//       payment: json['payment'] as String,
//     );

// Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
//       'id': instance.id,
//       'description': instance.description,
//       'amount': instance.amount,
//       'date': instance.date.toIso8601String(),
//       'dataEntry': instance.dataEntry,
//       'isActive': instance.isActive,
//       'payment': instance.payment,
//     };

Amount _$AmountFromJson(Map<String, dynamic> json) => Amount(
    id: json['_id'] == null ? null : json['_id'] as String,
    description: json['description'] as String,
    // dataEntry: DateTime.parse(json['dataEntry']),
    amount: double.parse(json['amount']),
    date: DateTime.parse(json['date']),
    dataEntry: json['dataEntry'] as String,
    isActive: json['isActive'] as bool,
    payment: json['payment'] as String);

Map<String, dynamic> _$AmountToJson(Amount instance) => <String, dynamic>{
      '_id': instance.id?.toString(),
      'description': instance.description,
      'date': instance.date,
      'dataEntry': instance.dataEntry,
      'isActive': instance.isActive,
      'payment': instance.payment,
    };
