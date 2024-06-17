// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';

class NameSection extends StatelessWidget {
  final TextEditingController nameController;
  const NameSection({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Nombre:',
        style: TextStyle(fontSize: 18),
      ),
      const SizedBox(
        height: 10,
      ),
      CustomTextField(
        controller: nameController,
        hintText: 'Ingrese el nombre',
        modal: true,
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
