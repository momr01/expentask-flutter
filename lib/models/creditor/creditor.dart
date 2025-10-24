import 'package:json_annotation/json_annotation.dart';

part 'creditor.g.dart';

@JsonSerializable()
class Creditor {
  final String? id;
  final String name;
  final String description;
  final String dataEntry;
  final bool isActive;

  Creditor({
    this.id,
    required this.name,
    required this.description,
    required this.dataEntry,
    required this.isActive,
  });

  factory Creditor.fromJson(Map<String, dynamic> json) =>
      _$CreditorFromJson(json);

  Map<String, dynamic> toJson() => _$CreditorToJson(this);
}
