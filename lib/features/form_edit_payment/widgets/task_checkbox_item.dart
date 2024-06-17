// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/task/edit_task_checkbox.dart';

class TaskCheckboxItem extends StatelessWidget {
  final EditTaskCheckbox item;
  final Function(bool? value) onChangeCheckbox;
  final VoidCallback onChangeDate;
  const TaskCheckboxItem({
    Key? key,
    required this.item,
    required this.onChangeCheckbox,
    required this.onChangeDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: GlobalVariables.primaryColor,
          value: item.state,
          onChanged: (bool? value) => onChangeCheckbox(value),
        ),
        const SizedBox(width: 20),
        SizedBox(width: 150, child: Text(capitalizeFirstLetter(item.name!)))
      ]),
      Flexible(
          child: SizedBox(
        width: 120,
        child: CustomTextField(
          controller: item.controller!,
          hintText: 'Seleccione una fecha válida',
          maxLines: 1,
          modal: true,
          onTap: onChangeDate,
        ),
      )),
    ]);
  }
}
