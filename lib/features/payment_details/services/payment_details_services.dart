import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/task_code/task_code.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//final navContext = NavigatorKeys.navKey.currentContext!;

class PaymentDetailsServices {
  Future<Payment> fetchPayment(
      {
      //required BuildContext context,
      required String paymentId}) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    Payment payment = Payment(
        name: PaymentName(
            name: '',
            category: Category(name: '', isActive: false),
            isActive: false),
        deadline: DateTime.now(),
        amount: -1,
        tasks: [
          Task(
              code: TaskCode(name: "", number: 0, user: "", abbr: ""),
              deadline: DateTime.now(),
              isActive: false,
              isCompleted: false,
              amountPaid: -1,
              instalmentNumber: 0)
        ],
        isActive: false,
        isCompleted: false,
        period: "",
        hasInstallments: false,
        installmentsQuantity: 0);

    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/payments/get/$paymentId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          //context: context,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            payment = Payment.fromJson(jsonDecode(res.body)[0]);
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }

    return payment;
  }

  Future<void> disablePayment(
      {
      //required BuildContext context,
      required String paymentId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http.put(
          Uri.parse('$uri/api/payments/disablePayment/$paymentId'),
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
                description: 'El pago se eliminó correctamente.',
                onPressed: () => Navigator.pushNamed(
                    NavigatorKeys.navKey.currentContext!, BottomBar.routeName));
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
