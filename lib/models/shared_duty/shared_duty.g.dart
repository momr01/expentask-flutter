// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_duty.dart';

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

SharedDuty _$SharedDutyFromJson(Map<String, dynamic> json) => SharedDuty(
    id: json['_id'] == null ? null : json['_id'] as String,
    description: json['description'] as String,
    isActive: json['isActive'] as bool,
    isCompleted: json['isCompleted'] as bool,
    dataEntry: json['dataEntry'] as String,
    user: UserHistorical.fromJson(json['user'][0]),
    creditor: Creditor.fromJson(json['creditor'][0]),
    payment: Payment.fromJson(json['payment']));

Map<String, dynamic> _$SharedDutyToJson(SharedDuty instance) =>
    <String, dynamic>{
      'id': instance.id?.toString(),
      'description': instance.description.toString(),
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'dataEntry': instance.dataEntry.toString(),
      'user': instance.user,
      'creditor': instance.creditor,
      'payment': instance.payment
    };
