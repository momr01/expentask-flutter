// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/features/alerts/utils/alerts_utils.dart';
import 'package:payments_management/features/alerts/widgets/card_alert_deadline_text.dart';
import 'package:payments_management/features/alerts/widgets/card_alert_main_text.dart';
import 'package:payments_management/models/alert.dart';

class CardAlert extends StatelessWidget {
  final Alert alert;
  const CardAlert({
    Key? key,
    required this.alert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              child: Row(children: [
                Container(
                  decoration: BoxDecoration(
                    color: cardColor(alert.daysNumber),
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.mark_chat_unread,
                          size: 40, color: Colors.white)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardAlertMainText(
                          alert: alert,
                        ),
                        const SizedBox(height: 30),
                        CardAlertDeadlineText(
                          deadline: alert.taskDeadline,
                        )
                      ]),
                ),
              ]),
            )),
      ),
    );
  }
}
