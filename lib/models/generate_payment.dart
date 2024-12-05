import 'package:payments_management/models/name/payment_name.dart';

class GeneratePayment {
  final String id;
  final String name;
  bool state;
  final List<PaymentName>? namesList;

  GeneratePayment(
      {required this.id,
      required this.name,
      required this.state,
      this.namesList});

  factory GeneratePayment.fromJson(Map<String, dynamic> json) {
    return GeneratePayment(
        id: json['id'],
        name: json['name'],
        state: json['state'],
        namesList: json['namesList']);
  }
}
