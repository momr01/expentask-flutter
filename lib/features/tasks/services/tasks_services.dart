import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/tasks/utils/navigation_tasks.dart';
import 'package:payments_management/models/task_code/task_code.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TasksServices {
  Future<List<TaskCode>> fetchTaskCodes() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<TaskCode> codesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/task-codes/getAll?user=${userProvider.user.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              codesList.add(TaskCode.fromJson(jsonDecode(res.body)[i]));
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return codesList;
  }

  void addTaskCode({required String name, required String abbr}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {'name': name, 'abbr': abbr};

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/task-codes/add'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                context: NavigatorKeys.navKey.currentContext!,
                description: 'La tarea se creó correctamente.',
                onPressed: () => fromSuccessAddToTasks(
                    NavigatorKeys.navKey.currentContext!));
          },
          closingTimes: 2);
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
      // errorModal(
      //     context: context,
      //     description:
      //         'No fue posible generar los pagos. Por favor, intente nuevamente más tarde.');
    }
  }

  void editTaskCode({required TaskCode task}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    /*   List tasksMap = [];
    for (var task in payment.tasks) {
      tasksMap.add({'code': task.code, 'deadline': task.deadline});
    }

    Map body = {
      'name': payment.name,
      'deadline': payment.deadline,
      'amount': '${payment.amount}',
      'tasks': tasksMap
    };

    try {
      http.Response res = await http.put(
          Uri.parse(
              '$uri/api/payments/editPayment/${payment.id}?user=${userProvider.user.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                context: NavigatorKeys.navKey.currentContext!,
                description: 'El pago se modificó correctamente.',
                onPressed: () => fromSuccessUpdateToPaymentDetails(
                    NavigatorKeys.navKey.currentContext!, payment.id));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }*/
  }
}
