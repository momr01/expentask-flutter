/*import 'dart:convert';

class Category {
  String? id;
  final String name;
  final bool isActive;

  Category({this.id, required this.name, required this.isActive});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isActive': isActive,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}*/

import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/name/payment_name.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final String? id;
  final String name;
  final bool isActive;
  final List<PaymentName>? listNames;

  Category(
      {this.id, required this.name, required this.isActive, this.listNames});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
