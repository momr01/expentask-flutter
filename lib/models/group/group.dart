import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/name/payment_name.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  final String? id;
  final String name;
  final String dataEntry;
  final bool isActive;
  final List<PaymentName> paymentNames;

  Group(
      {this.id,
      required this.name,
      required this.dataEntry,
      required this.isActive,
      required this.paymentNames});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
