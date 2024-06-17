// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class SelectSection extends StatelessWidget {
  final String text;
  final int value;
  final Function(int? value) onChange;
  final List<int> items;
  const SelectSection({
    Key? key,
    required this.text,
    required this.value,
    required this.onChange,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seleccionar $text:',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField<int>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.arrow_downward),
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: GlobalVariables.greyBackgroundColor,
              isDense: true),
          onChanged: (int? value) => onChange(value),
          items: items.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
