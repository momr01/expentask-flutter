import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_dynamic_form.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_title.dart';
import 'package:payments_management/common/widgets/modals/modal_form/model.form_input.dart';
import 'package:payments_management/constants/utils.dart';

class ModalFormDialog extends StatelessWidget {
  final String title;
  final String actionBtnText;
  final VoidCallback onComplete;
  final List<FormInput> controllers;
  final GlobalKey<FormState> modalFormKey;

  const ModalFormDialog(
      {super.key,
      required this.title,
      required this.actionBtnText,
      required this.controllers,
      required this.onComplete,
      required this.modalFormKey});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ModalFormTitle(text: capitalizeFirstLetter(title)),
            const SizedBox(height: 20),
            ModalDynamicForm(
                modalFormKey: modalFormKey,
                controllers: controllers,
                actionBtnText: actionBtnText,
                onComplete: onComplete)
          ],
        ),
      ),
    );
  }
}
