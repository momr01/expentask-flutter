// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/widgets/composicion_dialog.dart';
import 'package:payments_management/features/notes/screens/notes_screen.dart';
import 'package:payments_management/features/payment_details/widgets/notes_row.dart';
import 'package:payments_management/models/payment/payment.dart';

class HeaderPayment extends StatefulWidget {
  final Payment payment;
  const HeaderPayment({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  State<HeaderPayment> createState() => _HeaderPaymentState();
}

class _HeaderPaymentState extends State<HeaderPayment> {
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

  void openAmountsModal() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ComposicionProvider(
              paymentId: widget.payment.id!,
              onlySee: true,
            ));
  }

  void openNotesModal() async {
    showDialog(
        context: context,
        builder: (_) => NotesScreen(
              isModal: true,
              payment: widget.payment,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(
              widget.payment.name.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(countCompletedTasks(widget.payment.tasks),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 5),
        Row(children: [
          const Text("Vto", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(datetimeToString(widget.payment.deadline),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const Text("Importe",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text('\$ ${formatMoney(widget.payment.amount)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          GestureDetector(
              onTap: () => openAmountsModal(), child: const Icon(Icons.comment))
        ]),
        const SizedBox(height: 5),
        NotesRow(
          payment: widget.payment,
        )
      ],
    );
  }
}
