import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/constants/global_variables.dart';

class AlertDialogBase extends StatelessWidget {
  //final Future<void> Function() onTap;
  final Future<void> Function() handleConfirm;
  final String confirmText;
  final Color confirmColor;
  final String middleText;
  final String endText;
  const AlertDialogBase(
      {super.key,
      // required this.onTap,
      required this.handleConfirm,
      required this.confirmText,
      required this.confirmColor,
      required this.middleText,
      required this.endText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: '¿Está seguro de',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: ' $middleText ',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: GlobalVariables.primaryColor),
                          ),
                          TextSpan(
                            text: '$endText?',
                          ),
                        ])))),
        actions: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // _isLoading
            //     ? const CircularProgressIndicator() // Muestra el loading si está activo
            //     :
            CustomButtonOptions(
              text: confirmText.toUpperCase(),
              //onTap: widget.onTap,
              onTap: handleConfirm,
              color: confirmColor,
            ),
            const SizedBox(
              width: 10,
            ),
            CustomButtonOptions(
              text: 'CANCELAR',
              onTap: () {
                Navigator.pop(context);
              },
              color: GlobalVariables.cancelButtonColor,
            )
          ]),
          const SizedBox(
            height: 30,
          )
        ]);
  }
}
