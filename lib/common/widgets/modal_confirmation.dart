// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/constants/global_variables.dart';

class ModalConfirmation extends StatelessWidget {
  final VoidCallback onTap;
  final String confirmText;
  final Color confirmColor;
  final String middleText;
  final String endText;
  const ModalConfirmation({
    Key? key,
    required this.onTap,
    required this.confirmText,
    required this.confirmColor,
    required this.middleText,
    required this.endText,
  }) : super(key: key);

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
            CustomButtonOptions(
              text: confirmText.toUpperCase(),
              onTap: onTap,
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
