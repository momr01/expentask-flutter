import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_buttons.dart';
import 'package:payments_management/common/widgets/modals/modal_form/modal_form_title.dart';

class FormInput {
  final String label;
  final TextEditingController controller;
  final String placeholder;

  FormInput(this.label, this.controller, this.placeholder);
}

class ModalFormDialog extends StatelessWidget {
  final String title;
  final Widget form;
  final String actionBtnText;
  final VoidCallback onComplete;
  final List<FormInput> controllers;

  const ModalFormDialog(
      {super.key,
      required this.title,
      required this.form,
      required this.actionBtnText,
      required this.controllers,
      required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ModalFormTitle(text: title),
            const SizedBox(height: 20),
            // DynamicForm(
            //   task: widget.task,
            //   formKey: _completeTaskFormKey,
            //   placeController: _placeController,
            //   amountPaidController: _amountPaidController,
            //   dateController: _dateCompletedController,
            //   onSelectDate: selectDate,
            // ),
            //form,
            Form(
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
                          ),
                          const SizedBox(
                            height: 20,
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
                onComplete();
              },
              // onCancel: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
