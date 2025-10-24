// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_shared_duty.dart';

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

PaymentSharedDuty _$PaymentSharedDutyFromJson(Map<String, dynamic> json) =>
    PaymentSharedDuty(
      hasSharedDuty: json['hasSharedDuty'] as bool,
      creditorId:
          json['creditorId'] == null ? null : json['creditorId'] as String,
      creditorName:
          json['creditorName'] == null ? null : json['creditorName'] as String,
      sharedDutyId:
          json['sharedDutyId'] == null ? null : json['sharedDutyId'] as String,
    );

Map<String, dynamic> _$PaymentSharedDutyToJson(PaymentSharedDuty instance) =>
    <String, dynamic>{
      'hasSharedDuty': instance.hasSharedDuty,
      'creditorId': instance.creditorId?.toString(),
      'creditorName': instance.creditorName?.toString(),
      'sharedDutyId': instance.sharedDutyId?.toString(),
    };
