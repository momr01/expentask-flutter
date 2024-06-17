// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/task/task_edit.dart';

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
