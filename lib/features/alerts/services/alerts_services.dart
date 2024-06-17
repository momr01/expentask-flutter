import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/alert.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AlertsServices {
  Future<List<Alert>> fetchAlerts({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Alert> alertList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/payments/getAlerts'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              alertList
                  .add(Alert.fromJson(jsonEncode(jsonDecode(res.body)[i])));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return alertList;
  }

  Future<int> numberOfAlerts({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    int total = 0;

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/payments/totalAlerts'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            total = jsonDecode(res.body)['alerts'];
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return total;
  }
}
