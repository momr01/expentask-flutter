/*import 'dart:convert';

import 'package:payments_management/models/category.dart';

class PaymentName {
  String? id;
  final String name;
  final Category category;
  final bool isActive;
  List<String>? defaultTasks;

  PaymentName(
      {this.id,
      required this.name,
      required this.category,
      required this.isActive,
      this.defaultTasks});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'isActive': isActive,
      'defaultTasks': defaultTasks,
    };
  }

  factory PaymentName.fromMap(Map<String, dynamic> map) {
    return PaymentName(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] as String,
      //category: Category.fromMap(map['category'][0]),
      category: Category.fromJson(map['category']),
      isActive: map['isActive'] as bool,
      defaultTasks: map['defaultTasks'] != null
          ? List<String>.from((map['defaultTasks']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentName.fromJson(String source) =>
      PaymentName.fromMap(json.decode(source) as Map<String, dynamic>);
}
*/

import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/category/category.dart';

part 'payment_name.g.dart';

@JsonSerializable()
class PaymentName {
  final String? id;
  final String name;
  final bool isActive;
  final Category category;
  final List<String>? defaultTasks;

  PaymentName(
      {this.id,
      required this.name,
      required this.isActive,
      required this.category,
      this.defaultTasks});

  factory PaymentName.fromJson(Map<String, dynamic> json) =>
      _$PaymentNameFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentNameToJson(this);
}
