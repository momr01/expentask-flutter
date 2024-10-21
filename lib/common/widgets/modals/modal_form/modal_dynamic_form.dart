import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_buttons.dart';
import 'package:payments_management/common/widgets/modals/modal_form/model.form_input.dart';

class ModalDynamicForm extends StatelessWidget {
  final GlobalKey<FormState> modalFormKey;
  final List<FormInput> controllers;
  final String actionBtnText;
  final VoidCallback onComplete;
  const ModalDynamicForm(
      {super.key,
      required this.modalFormKey,
      required this.controllers,
      required this.actionBtnText,
      required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
            key: modalFormKey,
            child: Column(
              // children: [
              //   CustomTextField(controller: controller1, hintText: "hintText")
              // ],
              children: controllers
                  .map((e) => Column(
                        children: [
                          CustomTextField(
                            controller: e.controller,
                            hintText: e.placeholder,
                            withLabel: true,
                            labelText: e.label,
                            modal: true,
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ))
                  .toList(),
            )),
        const SizedBox(height: 20),
        ModalFormButtons(
          actionText: actionBtnText,
          onComplete: () {
            // if (_completeTaskFormKey.currentState!.validate()) {
            //   validateFormData();
            // }
            if (modalFormKey.currentState!.validate()) {
              onComplete();
            }
          },
          // onCancel: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
