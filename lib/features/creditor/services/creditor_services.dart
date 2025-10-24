import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/creditor/screens/creditor_screen.dart';
import 'package:payments_management/features/creditor/utils/creditor_utils.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/models/creditor/creditor.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CreditorServices {
  Future<List<Creditor>> fetchActiveCreditors() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<Creditor> creditorList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/creditors/getActive'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              creditorList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(Creditor.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return creditorList;
  }

  Future<void> editCreditor(
      {required String id,
      required String name,
      required String description}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {'name': name, 'description': description};

    try {
      http.Response res =
          await http.put(Uri.parse('$uri/api/creditors/edit/$id'),
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
              description: 'El acreedor se modificó correctamente.',
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     context, BottomBar.routeName, arguments: 1, (route) => true),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              // onPressed: () {}
              onPressed: () => fromSuccessToCreditorsPage(
                  NavigatorKeys.navKey.currentContext!),
            );
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> addCreditor(
      {required String name, required String description}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {'name': name, 'description': description};

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/creditors/add'),
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
              description: 'El acreedor se creó correctamente.',
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     GroupsScreen.routeName,
              //     (route) => true),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              //onPressed: () {}
              onPressed: () => fromSuccessToCreditorsPage(
                  NavigatorKeys.navKey.currentContext!),
            );
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> disableCreditor(
      {
      //required BuildContext context,
      required String creditorId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http
          .put(Uri.parse('$uri/api/creditors/disable/$creditorId'), headers: {
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
                description: 'El acreedor se eliminó correctamente.',
                // onPressed: () => Navigator.popUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     ModalRoute.withName(GroupsScreen.routeName))
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     GroupsScreen.routeName,
                //     (route) => false),
                // onPressed: () =>
                //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
                // onPressed: () =>
                //     Navigator.pop(NavigatorKeys.navKey.currentContext!)
                //onPressed: () {}
                // onPressed: () {
                //   Navigator.pushNamedAndRemoveUntil(
                //       NavigatorKeys.navKey.currentContext!,
                //       BottomBar.routeName,
                //       arguments: 0,
                //       (route) => false);

                //   // Navigator.pushNamedAndRemoveUntil(
                //   //     context, GroupsScreen.routeName, (route) => false);
                //   Navigator.pushNamed(NavigatorKeys.navKey.currentContext!,
                //       CreditorScreen.routeName);
                onPressed: () => fromSuccessToCreditorsPage(
                    NavigatorKeys.navKey.currentContext!)
                // }

                );
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

/*
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
  }*/
}
