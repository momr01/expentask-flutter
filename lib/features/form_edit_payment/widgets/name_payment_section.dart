// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/name/payment_name.dart';

class NamePaymentSection extends StatelessWidget {
  final String nameValue;
  final List<PaymentName>? names;
  final Function(String? value) onChange;
  const NamePaymentSection({
    Key? key,
    required this.nameValue,
    this.names,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nombre:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: nameValue,
          icon: const Icon(Icons.arrow_downward),
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: GlobalVariables.greyBackgroundColor,
              isDense: true),
          onChanged: (String? value) => onChange(value),
          items: names != null
              ? names!.map<DropdownMenuItem<String>>((PaymentName value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(capitalizeFirstLetter(value.name),
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  );
                }).toList()
              : [],
        ),
      ],
    );
  }
}
