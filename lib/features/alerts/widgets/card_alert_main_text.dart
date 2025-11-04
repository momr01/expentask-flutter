// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/alerts/utils/alerts_utils.dart';
import 'package:payments_management/models/alert.dart';

class CardAlertMainText extends StatelessWidget {
  final Alert alert;
  const CardAlertMainText({
    Key? key,
    required this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: 'Tarea',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            children: [
          TextSpan(
            text: ' "${alert.taskName.toString().toUpperCase()}"',
            style: const TextStyle(
                fontSize: 18, color: GlobalVariables.primaryColor),
          ),
          TextSpan(
            text: alert.hasInstallments
                ? ' (cuota ${alert.installmentNumber})'
                : "",
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontStyle: FontStyle.italic),
          ),
          const TextSpan(
            text: ' de',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: ' ${alert.paymentName} ',
            style: const TextStyle(
                fontSize: 18, color: GlobalVariables.primaryColor),
          ),
          cardText(alert.daysNumber),
        ]));
  }
}
