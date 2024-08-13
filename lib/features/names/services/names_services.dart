import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NamesServices {
  Future<List<PaymentName>> fetchPaymentNames() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<PaymentName> namesList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/names/getAll'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              namesList.add(PaymentName.fromJson(jsonDecode(res.body)[i]));
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return namesList;
  }

  void disableName(
      {required BuildContext context, required String nameId}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http
          .put(Uri.parse('$uri/api/names/disableName/$nameId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            successModal(
                context: context,
                description: 'El nombre se eliminó correctamente.',
                onPressed: () => Navigator.pushNamed(
                    context, BottomBar.routeName,
                    arguments: 1));
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
