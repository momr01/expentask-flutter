import 'package:flutter/material.dart';
import 'package:payments_management/features/tasks/screens/tasks_screen.dart';

void fromSuccessToTasks(context) {
  Navigator.popUntil(context, ModalRoute.withName(TasksScreen.routeName));

  Navigator.popAndPushNamed(context, TasksScreen.routeName);
}

// void fromSuccessUpdateToTasks(context, String idPayment) {
//   Navigator.popUntil(
//       context,
//       ModalRoute.withName(
//         PaymentDetailsScreen.routeName,
//       ));

//   Navigator.popAndPushNamed(context, PaymentDetailsScreen.routeName,
//       arguments: idPayment);
// }
