// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class GroupLogo extends StatelessWidget {
  final String letter;
  const GroupLogo({
    Key? key,
    required this.letter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: GlobalVariables.secondaryColor,
          border: Border.all(color: Colors.black)),
      child: Align(
        child: Text(
          letter.toUpperCase(),
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
