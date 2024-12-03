import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/common/widgets/bottom_bar.dart';
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
  Future<List<TaskCode>> fetchOwnTaskCodes() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<TaskCode> codesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse(
              '$uri/api/task-codes/getActiveOwn?user=${userProvider.user.id}'),
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

  Future<List<TaskCode>> fetchUsableTaskCodes() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<TaskCode> codesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse(
              '$uri/api/task-codes/getActiveUsable?user=${userProvider.user.id}'),
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

  Future<void> addTaskCode({required String name, required String abbr}) async {
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
                onPressed: () =>
                    fromSuccessToTasks(NavigatorKeys.navKey.currentContext!));
          },
          closingTimes: 2);
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> editTaskCode({required TaskCode task}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {'name': task.name, 'abbr': task.abbr, "number": task.number};

    try {
      http.Response res = await http.put(
          Uri.parse(
              '$uri/api/task-codes/editTaskCode/${task.id}?user=${userProvider.user.id}'),
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
                description: 'La tarea se modificó correctamente.',
                onPressed: () =>
                    fromSuccessToTasks(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> disableTaskCode({required String taskId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http.put(
          Uri.parse('$uri/api/task-codes/disableTaskCode/$taskId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                context: NavigatorKeys.navKey.currentContext!,
                description: 'La tarea se eliminó correctamente.',
                // onPressed: () => Navigator.pushNamed(
                //     NavigatorKeys.navKey.currentContext!, BottomBar.routeName)
                onPressed: () =>
                    fromSuccessToTasks(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
