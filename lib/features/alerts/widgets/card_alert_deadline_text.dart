// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';

class CardAlertDeadlineText extends StatelessWidget {
  final DateTime deadline;
  const CardAlertDeadlineText({
    Key? key,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: 'Vencimiento',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
            children: [
          TextSpan(
            text: ' ${datetimeToString(deadline)}',
          ),
        ]));
  }
}
