import 'package:json_annotation/json_annotation.dart';
import 'package:payments_management/models/creditor/creditor.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/user/user.dart';
import 'package:payments_management/models/user/user_historical.dart';

part 'shared_duty.g.dart';

@JsonSerializable()
class SharedDuty {
  final String? id;
  final String description;
  final bool isActive;
  final bool isCompleted;
  final String dataEntry;
  final UserHistorical user;
  final Creditor creditor;
  final Payment payment;

  SharedDuty(
      {this.id,
      required this.description,
      required this.isActive,
      required this.isCompleted,
      required this.dataEntry,
      required this.user,
      required this.creditor,
      required this.payment});

  factory SharedDuty.fromJson(Map<String, dynamic> json) =>
      _$SharedDutyFromJson(json);

  Map<String, dynamic> toJson() => _$SharedDutyToJson(this);
}
