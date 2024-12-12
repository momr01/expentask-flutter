import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GenerateServices {
  Future<void> generatePayments(
      {required BuildContext context,
      required List<String> names,
      required int month,
      required int year}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<String> finalNames = [];
    for (var name in names) {
      //debugPrint(name)
      finalNames.add(name);
    }

    Map body = {'names': finalNames, 'month': month, 'year': year};

    try {
      http.Response res =
          await http.post(Uri.parse('$uri/api/payments/add-individual'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            debugPrint(res.body);
            successModal(
              context: context,
              description: 'Los pagos se agregaron correctamente.',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, arguments: 2, (route) => false),
            );
          },
          closingTimes: 2);
    } catch (e) {
      showSnackBar(context, e.toString());
      // errorModal(
      //     context: context,
      //     description:
      //         'No fue posible generar los pagos. Por favor, intente nuevamente más tarde.');
    }
  }

  Future<void> generateInstallments(
      {required BuildContext context,
      required List<String> names,
      required int month,
      required int year,
      required int quantity}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    List<String> finalNames = [];
    for (var name in names) {
      //debugPrint(name)
      finalNames.add(name);
    }

    Map body = {
      'names': finalNames,
      'month': month,
      'year': year,
      'quantity': quantity
    };

    try {
      http.Response res =
          await http.post(Uri.parse('$uri/api/payments/add-installments'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token
              },
              body: jsonEncode(body));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            debugPrint(res.body);
            successModal(
              context: context,
              description: 'Los pagos se agregaron correctamente.',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, BottomBar.routeName, arguments: 2, (route) => false),
            );
          },
          closingTimes: 2);
    } catch (e) {
      showSnackBar(context, e.toString());
      // errorModal(
      //     context: context,
      //     description:
      //         'No fue posible generar los pagos. Por favor, intente nuevamente más tarde.');
    }
  }
}
