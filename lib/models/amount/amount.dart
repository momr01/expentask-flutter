import 'package:json_annotation/json_annotation.dart';

part 'amount.g.dart';

@JsonSerializable()
class Amount {
  final String? id;
  final String description;
  final double amount;
  final DateTime date;
  final String dataEntry;
  final bool isActive;
  final String payment;

  Amount(
      {this.id,
      required this.description,
      required this.amount,
      required this.date,
      required this.dataEntry,
      required this.isActive,
      required this.payment});

  factory Amount.fromJson(Map<String, dynamic> json) => _$AmountFromJson(json);

  Map<String, dynamic> toJson() => _$AmountToJson(this);
}
