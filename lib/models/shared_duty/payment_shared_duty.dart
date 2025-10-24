import 'package:json_annotation/json_annotation.dart';

part 'payment_shared_duty.g.dart';

@JsonSerializable()
class PaymentSharedDuty {
  final bool hasSharedDuty;
  final String? creditorId;
  final String? creditorName;
  final String? sharedDutyId;

  PaymentSharedDuty({
    required this.hasSharedDuty,
    this.creditorId,
    this.creditorName,
    this.sharedDutyId,
  });

  factory PaymentSharedDuty.fromJson(Map<String, dynamic> json) =>
      _$PaymentSharedDutyFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSharedDutyToJson(this);
}
