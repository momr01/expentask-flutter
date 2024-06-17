// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';

class DateSelectionFilterItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  const DateSelectionFilterItem({
    Key? key,
    required this.label,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Text('$label:'),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: CustomTextField(
            controller: controller,
            hintText: 'Seleccione una fecha válida',
            fillColor: Colors.white,
            centeredText: true,
            onTap: onTap,
          ))
        ],
      ),
    );
  }
}
