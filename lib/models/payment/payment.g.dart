part of 'payment.dart';

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
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
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
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
    };
