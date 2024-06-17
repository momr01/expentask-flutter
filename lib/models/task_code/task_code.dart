// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'task_code.g.dart';

@JsonSerializable()
class TaskCode {
  final String? id;
  final String name;
  final String user;
  final int number;
  final String abbr;

  TaskCode(
      {this.id,
      required this.name,
      required this.user,
      required this.number,
      required this.abbr});

  factory TaskCode.fromJson(Map<String, dynamic> json) =>
      _$TaskCodeFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCodeToJson(this);
}
/*import 'dart:convert';

class TaskCode {
  String? id;
  final String name;
  final String user;
  final int number;
  final String abbr;

  TaskCode(
      {this.id,
      required this.name,
      required this.user,
      required this.number,
      required this.abbr});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'user': user,
      'number': number,
      'abbr': abbr
    };
  }

  factory TaskCode.fromMap(Map<String, dynamic> map) {
    return TaskCode(
        id: map['_id'] != null ? map['_id'] as String : null,
        name: map['name'] as String,
        user: map['user'] as String,
        number: map['number'] as int,
        abbr: map['abbr'] as String);
  }

  String toJson() => json.encode(toMap());

  factory TaskCode.fromJson(String source) =>
      TaskCode.fromMap(json.decode(source) as Map<String, dynamic>);
}
*/