import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/shared_duty/utils/shared_duty_utils.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';
import 'package:payments_management/models/shared_duty/shared_duty.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SharedDutyServices {
  Future<List<SharedDuty>> fetchSharedDuties() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<SharedDuty> sharedDutiesList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/shared-duty/getAll'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              sharedDutiesList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(SharedDuty.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return sharedDutiesList;
  }

  Future<List<SharedDuty>> fetchSharedDutiesByCreditor(
      String creditorId) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<SharedDuty> sharedDutiesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/shared-duty/get-by-creditor/$creditorId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              sharedDutiesList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(SharedDuty.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return sharedDutiesList;
  }

  Future<void> editSharedDuty(
      {required String id,
      required String creditor,
      required String payment}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {'creditor': creditor, 'payment': payment};

    try {
      http.Response res =
          await http.put(Uri.parse('$uri/api/shared-duty/edit/$id'),
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
              description:
                  'La obligaciçon compartida se modificó correctamente.',
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     context, BottomBar.routeName, arguments: 1, (route) => true),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              //onPressed: () {}
              onPressed: () => fromSuccessToSharedDutiesPage(
                  NavigatorKeys.navKey.currentContext!),
            );
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> addSharedDuty(
      {required String creditor,
      required String payment,
      required String description}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {
      'creditor': creditor,
      'payment': payment,
      'description': description
    };

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/shared-duty/add'),
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
              description: 'La obligación compartida se creó correctamente.',
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     GroupsScreen.routeName,
              //     (route) => true),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              //onPressed: () {}
              // onPressed: () => fromSuccessToSharedDutiesPage(
              //     NavigatorKeys.navKey.currentContext!),
              onPressed: () => fromCompleteToSharedDutiesPage(
                  NavigatorKeys.navKey.currentContext!, creditor),
            );
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> disableSharedDuty(
      {
      //required BuildContext context,
      required String sharedDutyId,
      required String usuario}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http.put(
          Uri.parse('$uri/api/shared-duty/disable/$sharedDutyId'),
          headers: {
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
              description: 'La obligación compartida se eliminó correctamente.',
              // onPressed: () => Navigator.popUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     ModalRoute.withName(GroupsScreen.routeName))
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     GroupsScreen.routeName,
              //     (route) => false),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              //onPressed: () {}
              // onPressed: () => fromSuccessToSharedDutiesPage(
              //     NavigatorKeys.navKey.currentContext!),
              onPressed: () => fromCompleteToSharedDutiesPage(
                  NavigatorKeys.navKey.currentContext!, usuario),
            );
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> finishSharedDuty(
      {
      //required BuildContext context,
      required String sharedDutyId,
      required String usuario}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http.put(
          Uri.parse('$uri/api/shared-duty/finish/$sharedDutyId'),
          headers: {
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
              description:
                  'La obligación compartida se completó correctamente.',
              // onPressed: () => Navigator.popUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     ModalRoute.withName(GroupsScreen.routeName))
              // onPressed: () => Navigator.pushNamedAndRemoveUntil(
              //     NavigatorKeys.navKey.currentContext!,
              //     GroupsScreen.routeName,
              //     (route) => false),
              // onPressed: () =>
              //     fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
              //onPressed: () {}
              /* onPressed: () => fromSuccessToSharedDutiesPage(
                  NavigatorKeys.navKey.currentContext!),*/
              onPressed: () => fromCompleteToSharedDutiesPage(
                  NavigatorKeys.navKey.currentContext!, usuario),
              // onPressed: () =>
              //     Navigator.pop(NavigatorKeys.navKey.currentContext!),
            );
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
