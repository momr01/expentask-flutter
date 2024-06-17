/*import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/constants/date_format.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final bool isActive;
  final DateTime dataEntry;
  final String type;
  final String token;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.name,
      required this.isActive,
      required this.dataEntry,
      required this.type,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}*/

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:payments_management/constants/date_format.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final bool isActive;
  final DateTime dataEntry;
  final String type;
  final String token;

  User({
    required this.id,
    // required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.isActive,
    required this.dataEntry,
    required this.type,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'isActive': isActive,
      'dataEntry': dataEntry.millisecondsSinceEpoch,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      isActive: map['isActive'],
      //dataEntry: DateTime.parse(map['dataEntry']),
      dataEntry: stringToDateTime(map['dataEntry']),
      type: map['type'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
