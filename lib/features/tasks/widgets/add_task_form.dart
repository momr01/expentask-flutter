import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/tasks/services/tasks_services.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _abbrController.dispose();
  }

  bool _showForm = false;

  final _addTaskFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _abbrController = TextEditingController();
  final TasksServices tasksServices = TasksServices();

  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: addTask,
              confirmText: 'crear',
              confirmColor: Colors.blue,
              middleText: 'agregar',
              endText: 'la tarea',
            ));
  }

  Future<void> addTask() async {
    await tasksServices.addTaskCode(
        name: _nameController.text, abbr: _abbrController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: const BoxDecoration(
              color: GlobalVariables.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'AGREGAR NUEVA TAREA',
                  style: TextStyle(
                      color: GlobalVariables.whiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showForm = !_showForm;
                    });
                  },
                  child: Icon(
                    _showForm ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: GlobalVariables.whiteColor,
                  ),
                )
              ],
            ),
          ),
        ),
        _showForm
            ? Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Form(
                      key: _addTaskFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nombre:",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Ingrese un nombre",
                            modal: true,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            "Abreviatura:",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: _abbrController,
                            hintText: "Ingrese una abreviatura",
                            modal: true,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomButton(
                            text: 'CREAR',
                            onTap: () {
                              if (_addTaskFormKey.currentState!.validate()) {
                                openModalConfirmation();
                              }
                            },
                            color: GlobalVariables.secondaryColor,
                          )
                        ],
                      )),
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
