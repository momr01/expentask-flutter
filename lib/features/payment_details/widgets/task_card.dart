import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/payment_details/widgets/card_status.dart';
import 'package:payments_management/models/task/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  String daysUntilDeadline(DateTime date) {
    DateTime dateNow = DateTime.now();
    DateTime dateNowWithoutHour = dateNow.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    Duration difference = date.difference(dateNowWithoutHour);
    int days = difference.inDays;

    if (days > 0) {
      return "Quedan ${difference.inDays} días.";
    } else {
      return "Van ${difference.inDays * -1} días de atraso!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey.shade300,
        margin: EdgeInsets.zero,
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          ),
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black, width: 1),
                      bottom: BorderSide(color: Colors.black, width: 1))),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(child: CardStatus(isCompleted: task.isCompleted)),
                      Text(
                          task.isCompleted
                              ? datetimeToString(task.dateCompleted!)
                              : daysUntilDeadline(task.deadline),
                          style: TextStyle(
                              color: task.isCompleted
                                  ? Colors.black
                                  : Colors.red.shade900,
                              fontWeight: task.isCompleted
                                  ? FontWeight.normal
                                  : FontWeight.bold)),
                    ]),
                const SizedBox(height: 5),
                Row(children: [
                  Text(capitalizeFirstLetter(task.code.name),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 5),
                Row(children: [
                  const SizedBox(width: 20),
                  task.code.number == 1 ? Text(task.place!) : const Text("")
                ])
              ])),
        ));
  }
}
