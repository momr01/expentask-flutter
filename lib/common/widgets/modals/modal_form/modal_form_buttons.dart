import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/constants/global_variables.dart';

class ModalFormButtons extends StatelessWidget {
  final VoidCallback onComplete;
  // final VoidCallback onCancel;
  final String actionText;
  const ModalFormButtons(
      {super.key, required this.onComplete, required this.actionText
      //required this.onCancel
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomButtonOptions(
          text: actionText.toUpperCase(),
          color: GlobalVariables.completeButtonColor,
          onTap: onComplete,
        ),
        const SizedBox(width: 20),
        CustomButtonOptions(
          text: 'CANCELAR',
          color: GlobalVariables.cancelButtonColor,
          //onTap: onCancel,
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
