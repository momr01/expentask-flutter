// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class DefaultTasksSection extends StatelessWidget {
  final List<TaskCode> defaultTasks;
  final List<TaskCode> selectedTasks;
  final Function(TaskCode task) onPressed;
  final Function(TaskCode task) onDeleted;
  const DefaultTasksSection({
    Key? key,
    required this.defaultTasks,
    required this.selectedTasks,
    required this.onPressed,
    required this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tareas predefinidas:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 50,
          child: defaultTasks.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ActionChip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(
                              color: GlobalVariables.primaryColor)),
                      backgroundColor: GlobalVariables.greyBackgroundColor,
                      avatar: const CircleAvatar(
                        backgroundColor: GlobalVariables.primaryColor,
                        child: Icon(
                          Icons.add,
                          color: GlobalVariables.greyBackgroundColor,
                          size: 20,
                        ),
                      ),
                      label: Text(
                        capitalizeFirstLetter(defaultTasks[index].name),
                        style: const TextStyle(
                            color: GlobalVariables.primaryColor),
                      ),
                      onPressed: () => onPressed(defaultTasks[index]),
                    );
                  },
                  itemCount: defaultTasks.length,
                )
              : const Text(
                  'Sin datos!',
                  style: TextStyle(
                      color: GlobalVariables.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(5),
              color: GlobalVariables.greyBackgroundColor),
          child: selectedTasks.isNotEmpty
              ? Wrap(
                  children: selectedTasks
                      .map((task) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Chip(
                                backgroundColor: GlobalVariables.primaryColor,
                                onDeleted: () => onDeleted(task),
                                deleteIconColor: Colors.white,
                                label: Text(
                                  capitalizeFirstLetter(task.name),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ))
                      .toList())
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  child: Text('Debe seleccionar al menos 1 tarea!'),
                ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
