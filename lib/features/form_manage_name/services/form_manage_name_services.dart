import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/task_code/task_code.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FormManageNameServices {
  void editName(
      {required BuildContext context,
      required String id,
      required String name,
      required String category,
      required List<String> defaultTasks}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<String> tasks = [];
    for (var task in defaultTasks) {
      tasks.add(task);
    }

    Map body = {'name': name, 'category': category, 'defaultTasks': tasks};

    try {
      http.Response res =
          await http.put(Uri.parse('$uri/api/names/editName/$id'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            successModal(
              context: context,
              description: 'El nombre se modificó correctamente.',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, arguments: 1, (route) => true),
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void addName(
      {required BuildContext context,
      required String name,
      required String categoryId,
      required List<String> defaultTasks}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<String> tasks = [];
    for (var task in defaultTasks) {
      tasks.add(task);
    }

    Map body = {'name': name, 'categoryId': categoryId, 'defaultTasks': tasks};

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/names/add'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          },
          body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            successModal(
              context: context,
              description: 'El nombre se creó correctamente.',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, arguments: 1, (route) => true),
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
