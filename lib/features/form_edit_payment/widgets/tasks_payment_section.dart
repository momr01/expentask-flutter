// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class TasksPaymentSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  const TasksPaymentSection({
    Key? key,
    required this.isExpanded,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: GlobalVariables.greyBackgroundColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tareas:',
                  style: TextStyle(fontSize: 18),
                ),
                Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down)
              ],
            ),
          )),
    );
  }
}
