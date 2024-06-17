import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class MessageEmpty extends StatelessWidget {
  const MessageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 20),
      child: Text(
        'No existen nombres disponibles para generar pagos en forma masiva!',
        style: TextStyle(
            fontSize: 20,
            color: GlobalVariables.primaryColor,
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
