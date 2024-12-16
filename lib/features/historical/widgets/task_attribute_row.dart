// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TaskAttributeRow extends StatelessWidget {
  final String attribute;
  final String value;
  final Color? color;
  const TaskAttributeRow(
      {Key? key, required this.attribute, required this.value, this.color})
      : super(key: key);

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
              style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: color ?? Colors.black),
              textAlign: TextAlign.end,
            ),
          ),
        )
      ],
    );
  }
}
