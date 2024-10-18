import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class AlertDialogLoading extends StatelessWidget {
  const AlertDialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(10),
      content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircularProgressIndicator(
                  strokeWidth: 6,
                ), // Muestra el loading si está activo
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Enviando datos...',
                  style: TextStyle(
                      color: GlobalVariables.primaryColor, fontSize: 25),
                )
              ]))),
    );
  }
}
