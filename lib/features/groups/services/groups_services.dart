import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GroupsServices {
  Future<List<Group>> fetchActiveGroups() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<Group> groupList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/groups/getActive'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              groupList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(Group.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return groupList;
  }

  Future<void> editGroup(
      {required String id,
      required String name,
      required List<GroupNameCheckbox> paymentNames}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    List<String> names = [];
    for (var name in paymentNames) {
      names.add(name.id!);
    }

    Map body = {'name': name, 'paymentNames': names};

    try {
      http.Response res = await http.put(Uri.parse('$uri/api/groups/edit/$id'),
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
                description: 'El grupo se modificó correctamente.',
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     context, BottomBar.routeName, arguments: 1, (route) => true),
                onPressed: () =>
                    fromSuccessToGroups(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> addGroup(
      {required String name,
      required List<GroupNameCheckbox> paymentNames}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    List<String> names = [];
    for (var name in paymentNames) {
      names.add(name.id!);
    }

    Map body = {'name': name, 'paymentNames': names};

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/groups/add'),
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
                description: 'El grupo se creó correctamente.',
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     GroupsScreen.routeName,
                //     (route) => true),
                onPressed: () =>
                    fromSuccessToGroups(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> disableGroup(
      {
      //required BuildContext context,
      required String groupId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http
          .put(Uri.parse('$uri/api/groups/disable/$groupId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          //context: context,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                // context: context,
                context: NavigatorKeys.navKey.currentContext!,
                description: 'El grupo se eliminó correctamente.',
                // onPressed: () => Navigator.popUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     ModalRoute.withName(GroupsScreen.routeName))
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     GroupsScreen.routeName,
                //     (route) => false),
                onPressed: () =>
                    fromSuccessToGroups(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
