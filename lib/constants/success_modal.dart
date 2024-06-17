import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void successModal(
    {required BuildContext context,
    required String description,
    required VoidCallback onPressed}) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: const TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.center,
    animationDuration: const Duration(milliseconds: 500),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(
        color: GlobalVariables.primaryColor,
      ),
    ),
    titleStyle: const TextStyle(
        color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
    alertAlignment: Alignment.center,
  );

  Alert(
    context: context,
    style: alertStyle,
    type: AlertType.success,
    title: "Éxito!",
    desc: description,
    buttons: [
      DialogButton(
        onPressed: onPressed,
        color: GlobalVariables.cancelButtonColor,
        radius: BorderRadius.circular(50),
        child: const Text(
          "VOLVER",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  ).show();
}
