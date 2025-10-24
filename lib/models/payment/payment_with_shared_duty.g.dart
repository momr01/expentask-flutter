// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_with_shared_duty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
//       id: json['id'] as String?,
//       name: PaymentName.fromJson(json['name'] as Map<String, dynamic>),
//       deadline: DateTime.parse(json['deadline'] as String),
//       amount: (json['amount'] as num).toDouble(),
//       tasks: (json['tasks'] as List<dynamic>)
//           .map((e) => Task.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       isActive: json['isActive'] as bool,
//       isCompleted: json['isCompleted'] as bool,
//       period: json['period'] as String,
//       user: json['user'] == null
//           ? null
//           : UserHistorical.fromJson(json['user'] as Map<String, dynamic>),
//       dataEntry: json['dataEntry'] as String?,
//       hasInstallments: json['hasInstallments'] as bool,
//       installmentsQuantity: (json['installmentsQuantity'] as num).toInt(),
//     );

// Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
//       'id': instance.id,
//       'name': instance.name,
//       'deadline': instance.deadline.toIso8601String(),
//       'amount': instance.amount,
//       'tasks': instance.tasks,
//       'isActive': instance.isActive,
//       'isCompleted': instance.isCompleted,
//       'period': instance.period,
//       'user': instance.user,
//       'dataEntry': instance.dataEntry,
//       'hasInstallments': instance.hasInstallments,
//       'installmentsQuantity': instance.installmentsQuantity,
//     };

PaymentWithSharedDuty _$PaymentWithSharedDutyFromJson(
        Map<String, dynamic> json) =>
    PaymentWithSharedDuty(
      id: json['_id'] == null ? null : json['_id'] as String,
      name: PaymentName.fromJson(json['name'][0]),
      deadline: DateTime.parse(json['deadline']),
      amount: double.parse(json['amount']),
      //tasks: json['tasks'] as List<Task>,
      tasks: List<Task>.from((json['tasks']?.map((x) => Task.fromJson(x)))),
      isActive: json['isActive'] as bool,
      isCompleted: json['isCompleted'] as bool,
      period: json['period'] as String,
      user: json['user'] == null
          ? null
          : UserHistorical.fromJson(json['user'][0]),
      dataEntry: json['dataEntry'] == null ? null : json['dataEntry'] as String,
      hasInstallments: json['hasInstallments'] as bool,
      installmentsQuantity: json['installmentsQuantity'] as int,
      /* sharedDuty: json['sharedDuty'] != null
          ? Map<String, dynamic>.from(json['sharedDuty'])
          : <String, dynamic>{},*/
      sharedDuty: PaymentSharedDuty.fromJson(json['sharedDuty']),
    );

Map<String, dynamic> _$PaymentWithSharedDutyToJson(
        PaymentWithSharedDuty instance) =>
    <String, dynamic>{
      '_id': instance.id?.toString(),
      'name': instance.name,
      'deadline': instance.deadline,
      'amount': instance.amount,
      'tasks': instance.tasks,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'period': instance.period,
      'user': instance.user?.toString(),
      'dataEntry': instance.dataEntry?.toString(),
      'hasInstallments': instance.hasInstallments,
      'installmentsQuantity': instance.installmentsQuantity,
      'sharedDuty': instance.sharedDuty,
    };
