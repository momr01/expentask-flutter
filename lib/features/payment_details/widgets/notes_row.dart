import 'package:flutter/material.dart';
import 'package:payments_management/features/notes/screens/notes_screen.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';

class NotesRow extends StatefulWidget {
  final bool isPayment;
  //final String? id;
  final PaymentWithSharedDuty? payment;
  final PaymentName? name;
  const NotesRow(
      {super.key,
      //this.id,
      this.isPayment = true,
      this.payment,
      this.name});

  @override
  State<NotesRow> createState() => _NotesRowState();
}

class _NotesRowState extends State<NotesRow> {
  void openNotesModal() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => NotesScreen(
              hasId: true,
              isModal: true,
              // paymentId: widget.isPayment ? widget.id : null,
              // nameId: widget.isPayment ? null : widget.id,
              payment: widget.isPayment ? widget.payment : null,
              name: widget.isPayment ? null : widget.name,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text("Notas"),
            // SizedBox(
            //   width: 10,
            // ),
            // Text("0"),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => openNotesModal(),
              child: const Icon(Icons.notes),
            )
          ],
        )
      ],
    );
  }
}
