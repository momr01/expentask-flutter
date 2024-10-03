import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<Payment>> fetchUndonePayments({required context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Payment> paymentList = [];

    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/payments/getUndonePayments'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              paymentList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(Payment.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return paymentList;
  }

  Future<void> completeTask(
      {required context,
      required String paymentId,
      required String taskId,
      required String dateCompleted,
      required String amount,
      String? place}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Map body = {
        'method': place ?? "",
        'taskId': taskId,
        'date': dateCompleted,
        'amountPaid': amount
      };

      http.Response res =
          await http.put(Uri.parse('$uri/api/payments/completeTask/$paymentId'),
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
              description: 'La tarea se marcó como COMPLETA.',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    BottomBar.routeName,
                    arguments: 0,
                    (route) => false,
                  ));
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
