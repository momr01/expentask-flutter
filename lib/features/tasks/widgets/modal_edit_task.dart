// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class ModalEditTask extends StatefulWidget {
  final TaskCode code;
  const ModalEditTask({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  State<ModalEditTask> createState() => _ModalEditTaskState();
}

class _ModalEditTaskState extends State<ModalEditTask> {
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.code.name;
    _abbrController.text = widget.code.abbr;
    _numberController.text = widget.code.number.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _abbrController.dispose();
    _numberController.dispose();
  }

  final _editTaskFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abbrController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  void editTask() {
    debugPrint(_nameController.text);
    debugPrint(_abbrController.text);
    debugPrint(_numberController.text);
  }

  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: editTask,
              confirmText: 'editar',
              confirmColor: GlobalVariables.completeButtonColor!,
              middleText: 'modificar',
              endText: 'la tarea',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text(
            'Editar Tarea',
            style: TextStyle(fontSize: 30),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Form(
              key: _editTaskFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Ingrese el nombre',
                    modal: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Abreviatura:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _abbrController,
                    hintText: 'Ingrese la abreviatura',
                    modal: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Número:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _numberController,
                    hintText: 'Ingrese el número',
                    modal: true,
                    isAmount: true,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      CustomButtonOptions(
                          text: 'EDITAR',
                          color: GlobalVariables.completeButtonColor,
                          onTap: () {
                            if (_editTaskFormKey.currentState!.validate()) {
                              //openConfirmationCompleteTask();
                              //debugPrint('open confirmation modal');
                              openModalConfirmation();
                            }
                          }),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomButtonOptions(
                          text: 'CANCELAR',
                          color: GlobalVariables.cancelButtonColor,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              )),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
