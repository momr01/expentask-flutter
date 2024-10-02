import 'package:flutter/material.dart';
import 'package:payments_management/features/tasks/screens/tasks_screen.dart';

void fromSuccessAddToTasks(context) {
  Navigator.popUntil(context, ModalRoute.withName(TasksScreen.routeName));

  Navigator.popAndPushNamed(context, TasksScreen.routeName);

  // Navigator.popAndPushNamed(context, PaymentDetailsScreen.routeName,
  //     arguments: idPayment);
}
