import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void errorModal(
    {required BuildContext context,
    required String description,
    int? closingTimes,
    VoidCallback? onTap}) {
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
    type: AlertType.error,
    title: "Error!",
    desc: description,
    buttons: [
      DialogButton(
        onPressed: onTap ??
            () {
              handleClose(context, closingTimes ?? 1);
            },
        color: GlobalVariables.cancelButtonColor,
        /*  () {
              //Navigator.pop(context);
              //Navigator.popUntil(context, (route) => false);
              //  Navigator.of(context).pop(2);
              Navigator.pop(context);
              Navigator.pop(context);
              switch (closingTimes) {
                case 1:
                  break;
                default:
              }
            },*/

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

void handleClose(BuildContext context, int closingTimes) {
  // Aquí manejas la lógica de cierre
  for (int i = 0; i < closingTimes; i++) {
    Navigator.pop(context);
  }
  // switch (closingTimes) {
  //   case 1:
  //     Navigator.pop(context);
  //     break;
  //   case 2:
  //     {
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //     }
  //     break;
  //   default:
  //     Navigator.pop(context);
  // }
}
