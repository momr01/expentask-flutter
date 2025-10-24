import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';
import 'package:payments_management/models/task/edit_task_checkbox.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/task_code/task_code.dart';

//get date as string to fill the input
String getInputDate(Task task) {
  if (task.isActive) {
    return '${task.deadline.day}/${task.deadline.month}/${task.deadline.year}';
  } else {
    return '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  }
}

//validate type and content of amount
bool validateAmount(String controller) {
  if (double.tryParse(controller) != null) {
    if (double.parse(controller) >= 0) {
      return true;
    } else {
      return false;
    }
  }

  String commaToDot = controller.replaceAll(',', '.');
  if (double.tryParse(commaToDot) != null) {
    if (double.parse(commaToDot) >= 0) {
      return true;
    } else {
      return false;
    }
  }

  return false;
}

//return correct form of double amount
double correctAmount(String controllerValue) {
  return double.tryParse(controllerValue) != null
      ? double.parse(controllerValue)
      : double.parse(controllerValue.replaceAll(',', '.'));
}

//create controllers and checkbox of every task
defineControllersAndCheckbox(
    List<TaskCode> taskCodes,
    PaymentWithSharedDuty payment,
    List<TextEditingController> controllers,
    List<EditTaskCheckbox> taskItems) {
  // debugPrint(payment.tasks.length.toString());
  for (var i = 0; i < taskCodes.length; i++) {
    DateTime dateNow = DateTime.now();

    var textEditingController = TextEditingController(
        text: payment.tasks.firstWhereOrNull(
                    (task) => task.code.number == taskCodes[i].number) !=
                null
            ? getInputDate(payment.tasks
                .firstWhere((task) => task.code.number == taskCodes[i].number))
            : '${dateNow.day}/${dateNow.month}/${dateNow.year}');

    controllers.add(textEditingController);

    taskItems.add(EditTaskCheckbox(
        id: taskCodes[i].id,
        name: taskCodes[i].name,
        state: payment.tasks.firstWhereOrNull(
                    (element) => element.code.id == taskCodes[i].id) !=
                null
            ? payment.tasks
                .firstWhere((element) => element.code.id == taskCodes[i].id)
                .isActive
            : false,
        controller: controllers[i]));
  }
}
