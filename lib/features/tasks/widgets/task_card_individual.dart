// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/tasks/widgets/modal_edit_task.dart';
import 'package:payments_management/models/task_code/task_code.dart';

enum SampleItem { editar, eliminar }

class TaskCardIndividual extends StatefulWidget {
  final TaskCode code;
  const TaskCardIndividual({
    Key? key,
    required this.code,
  }) : super(key: key);

  @override
  State<TaskCardIndividual> createState() => _TaskCardIndividualState();
}

class _TaskCardIndividualState extends State<TaskCardIndividual> {
  SampleItem? selectedItem;

  void openEditTaskModal() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalEditTask(
              code: widget.code,
            ));
  }

  Future<void> disableTask() async {
    debugPrint(widget.code.id);
  }

  void openDeleteConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: disableTask,
              confirmText: 'eliminar',
              confirmColor: Colors.red,
              middleText: 'eliminar',
              endText: 'la tarea',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
          color: GlobalVariables.whiteColor,
          border: Border.all(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<SampleItem>(
                  initialValue: selectedItem,
                  onSelected: (SampleItem item) {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<SampleItem>>[
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.editar,
                      onTap: openEditTaskModal,
                      child: const Text('EDITAR'),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<SampleItem>(
                      value: SampleItem.eliminar,
                      onTap: openDeleteConfirmation,
                      child: const Text('ELIMINAR'),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 85,
              height: 85,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: GlobalVariables.primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    widget.code.number.toString(),
                    style: const TextStyle(
                        fontSize: 45,
                        color: GlobalVariables.secondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Nombre: ${capitalizeFirstLetter(widget.code.name)}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text('Número: ${widget.code.number}'),
            Text('Abreviatura: "${capitalizeFirstLetter(widget.code.abbr)}"')
          ],
        ),
      ),
    );
  }
}
