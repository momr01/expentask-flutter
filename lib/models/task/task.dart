// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/task_code/task_code.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  final String? id;
  final TaskCode code;
  final DateTime deadline;
  final bool isActive;
  final bool isCompleted;
  final DateTime? dateCompleted;
  final String? place;
  final double amountPaid;
  final int instalmentNumber;

  Task(
      {this.id,
      required this.code,
      required this.deadline,
      required this.isActive,
      required this.isCompleted,
      this.dateCompleted,
      this.place,
      required this.amountPaid,
      required this.instalmentNumber});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class Task {
  String? id;
  //final int code;
  //final String name;
  final TaskCode code;
  final DateTime deadline;
  final bool isActive;
  final bool isCompleted;
  DateTime? dateCompleted;
  String? place;

  Task(
      {this.id,
      //required this.code,
      //required this.name,
      required this.code,
      required this.deadline,
      required this.isActive,
      required this.isCompleted,
      this.dateCompleted,
      this.place});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      //'code': code,
      // 'name': name,
      'code': code,
      'deadline': deadline,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'dateCompleted': dateCompleted,
      'place': place,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['_id'] != null ? map['_id'] as String : null,
      // code: map['code'] as int,
      // name: map['name'] as String,
      //deadline: convertToDateTime(map['deadline']),
      code: TaskCode.fromMap(map['code'][0]),
      deadline: DateTime.parse(map['deadline']),
      isActive: map['isActive'] as bool,
      isCompleted: map['isCompleted'] as bool,
      // dateCompleted: map['dateCompleted'] != null
      //     ? convertToDateTime(map['dateCompleted'])
      //     : null,
      dateCompleted: map['dateCompleted'] != null
          ? DateTime.parse(map['dateCompleted'])
          : null,
      place: map['place'] != null ? map['place'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}*/

// class TaskEdit {
//   String code;
//   String deadline;

//   TaskEdit({required this.code, required this.deadline});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'code': code,
//       'deadline': deadline,
//     };
//   }

//   factory TaskEdit.fromMap(Map<String, dynamic> map) {
//     return TaskEdit(
//       code: map['code'] as String,
//       deadline: map['deadline'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory TaskEdit.fromJson(String source) =>
//       TaskEdit.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class EditTaskCheckbox {
//   String? id;
//   String? name;
//   bool? state;
//   TextEditingController? controller;

//   EditTaskCheckbox({this.id, this.name, this.state, this.controller});
// }
