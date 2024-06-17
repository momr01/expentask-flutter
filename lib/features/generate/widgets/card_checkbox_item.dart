// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/utils.dart';

class CardCheckboxItem extends StatelessWidget {
  final bool state;
  final String text;
  final Function(bool? value) onChanged;
  const CardCheckboxItem({
    Key? key,
    required this.state,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 0,
      child: Row(children: [
        Transform.scale(
          scale: 1.5,
          child: Checkbox(
            //activeColor: GlobalVariables.primaryColor,
            value: state,
            onChanged: (value) => onChanged(value),
          ),
        ),
        Flexible(
          child: Text(
            capitalizeFirstLetter(text),
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ]),
    );
  }
}
