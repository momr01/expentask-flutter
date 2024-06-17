// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/models/payment/payment.dart';

class HeaderPayment extends StatelessWidget {
  final Payment payment;
  const HeaderPayment({
    Key? key,
    required this.payment,
  }) : super(key: key);

  String countCompletedTasks(List tasks) {
    List activeTasks = [];

    for (var task in tasks) {
      if (task.isActive) activeTasks.add(task);
    }
    int total = activeTasks.length;
    int completed = 0;

    for (var task in tasks) {
      if (task.isActive && task.isCompleted) completed++;
    }

    return '$completed/$total';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(
              payment.name.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(countCompletedTasks(payment.tasks),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 15),
        Row(children: [
          const Text("Vto", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(datetimeToString(payment.deadline),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 15),
        Row(children: [
          const Text("Importe", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text('\$ ${payment.amount}',
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
      ],
    );
  }
}
