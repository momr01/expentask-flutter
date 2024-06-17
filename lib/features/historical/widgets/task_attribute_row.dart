// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TaskAttributeRow extends StatelessWidget {
  final String attribute;
  final String value;
  const TaskAttributeRow({
    Key? key,
    required this.attribute,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "\u2022 $attribute=",
          style: const TextStyle(
              fontSize: 17, letterSpacing: 1, fontWeight: FontWeight.w700),
        ),
        Flexible(
          child: SizedBox(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 17, letterSpacing: 1, fontWeight: FontWeight.w700),
              textAlign: TextAlign.end,
            ),
          ),
        )
      ],
    );
  }
}
