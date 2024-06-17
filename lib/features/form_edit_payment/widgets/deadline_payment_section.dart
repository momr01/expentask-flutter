// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';

class DeadlinePaymentSection extends StatelessWidget {
  final Function(TextEditingController value) onTap;
  final TextEditingController controller;
  const DeadlinePaymentSection({
    Key? key,
    required this.onTap,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha de vencimiento:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          controller: controller,
          hintText: 'Ingrese la fecha de vencimiento',
          modal: true,
          suffixIcon: const Icon(
            Icons.calendar_month,
            size: 30,
          ),
          onTap: () => onTap(controller),
        ),
      ],
    );
  }
}
