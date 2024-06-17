// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';

class AmountPaymentSection extends StatelessWidget {
  final TextEditingController controller;
  const AmountPaymentSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Importe:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          controller: controller,
          hintText: 'Ingrese el importe',
          modal: true,
          isAmount: true,
          suffixIcon: const Icon(
            Icons.attach_money,
            size: 30,
          ),
        ),
      ],
    );
  }
}
