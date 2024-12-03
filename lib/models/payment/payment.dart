// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/user/user_historical.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final String? id;
  final PaymentName name;
  final DateTime deadline;
  final double amount;
  final List<Task> tasks;
  final bool isActive;
  final bool isCompleted;
  final String period;
  final UserHistorical? user;
  final String? dataEntry;
  final bool hasInstallments;
  final int installmentsQuantity;

  Payment(
      {this.id,
      required this.name,
      required this.deadline,
      required this.amount,
      required this.tasks,
      required this.isActive,
      required this.isCompleted,
      required this.period,
      this.user,
      this.dataEntry,
      required this.hasInstallments,
      required this.installmentsQuantity});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
/*import 'dart:convert';

import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/task/task_edit.dart';
import 'package:payments_management/models/user.dart';

class Payment {
  String? id;
  final PaymentName name;
  final DateTime deadline;
  final double amount;
  final List<Task> tasks;
  //final String tasks;
  final bool isActive;
  final bool isCompleted;
  final String period;
  UserHistorical? user;

  Payment(
      {this.id,
      required this.name,
      required this.deadline,
      required this.amount,
      required this.tasks,
      required this.isActive,
      required this.isCompleted,
      required this.period,
      this.user});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'deadline': deadline,
      'amount': amount,
      'tasks': tasks,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'period': period,
      'user': user
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['_id'] != null ? map['_id'] as String : null,
      //id: map['_id'],
      //name: PaymentName.fromMap(map['name'][0]),
      name: PaymentName.fromJson(map['name'][0]),
      deadline: DateTime.parse(map['deadline']),
      amount: double.parse(map['amount']),
      // tasks: List<Task>.from((map['tasks']?.map((x) => Task.fromMap(x)))),
      // tasks: List<Task>.from((map['tasks']?.map((x) => Task.fromMap(x)))),
      tasks: List<Task>.from((map['tasks']?.map((x) => Task.fromJson(x)))),
      //tasks: "hola",
      // isActive: map['isActive'] as bool,
      // isCompleted: map['isCompleted'] as bool,
      // isActive: map['isActive'] ?? false,
      //   isCompleted: map['isCompleted'] ?? false,
      isActive: map['isActive'],
      isCompleted: map['isCompleted'],
      period: map['period'],
      user: map['user'] != null ? UserHistorical.fromMap(map['user'][0]) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Payment.fromJson(String source) =>
      Payment.fromMap(json.decode(source) as Map<String, dynamic>);

  Payment copyWith(
      {String? id,
      PaymentName? name,
      DateTime? deadline,
      double? amount,
      List<Task>? tasks,
      bool? isActive,
      bool? isCompleted,
      String? period}) {
    return Payment(
        id: id ?? this.id,
        name: name ?? this.name,
        deadline: deadline ?? this.deadline,
        amount: amount ?? this.amount,
        tasks: tasks ?? this.tasks,
        isActive: isActive ?? this.isActive,
        isCompleted: isCompleted ?? this.isCompleted,
        period: period ?? this.period);
  }
}

class PaymentEdit {
  String id;
  String name;
  String deadline;
  double amount;
  List<TaskEdit> tasks;
  bool? isActive;
  bool? isCompleted;

  PaymentEdit({
    required this.id,
    required this.name,
    required this.deadline,
    required this.amount,
    required this.tasks,
    this.isActive,
    this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'deadline': deadline,
      'amount': amount,
      'tasks': tasks.toList(),
      'isActive': isActive,
      'isCompleted': isCompleted,
    };
  }

  factory PaymentEdit.fromMap(Map<String, dynamic> map) {
    return PaymentEdit(
      // id: map['_id'] as String,
      // name: map['name'] as String,
      // deadline: map['deadline'] as String,
      id: map['_id'],
      name: map['name'],
      deadline: map['deadline'],
      amount: double.parse(map['amount']),
      //tasks: List<TaskEdit>.from((map['tasks'] as List<int>).map<TaskEdit>((x) => TaskEdit.fromMap(x as Map<String,dynamic>),),),
      // tasks: List<TaskEdit>.from((map['tasks']?.map((x) => Task.fromMap(x)))),
      tasks: List<TaskEdit>.from((map['tasks']?.map((x) => Task.fromJson(x)))),
      isActive: map['isActive'] != null ? map['isActive'] as bool : false,
      isCompleted:
          map['isCompleted'] != null ? map['isCompleted'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentEdit.fromJson(String source) =>
      PaymentEdit.fromMap(json.decode(source) as Map<String, dynamic>);
}
*/