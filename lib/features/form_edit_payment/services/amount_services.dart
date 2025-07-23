import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/utils/navigation_form_edit_payment.dart';
import 'package:payments_management/models/amount/amount.dart';
import 'package:payments_management/models/payment/payment_edit.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AmountServices {
  Future<List<Amount>> fetchPaymentAmounts({required String paymentId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<Amount> amountList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/amounts/getPaymentAmounts/$paymentId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              amountList
                  // .add(Payment.fromJson(jsonEncode(jsonDecode(res.body)[i])));
                  .add(Amount.fromJson(jsonDecode(res.body)[i]));
              //from json accepts string, jsondecode is an object
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return amountList;
  }

  Future<void> addPaymentAmount(
      {required String date,
      required String description,
      required double amount,
      required String paymentId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {
      'date': date,
      'description': description,
      'amount': amount,
      'paymentId': paymentId
    };

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/amounts/add'),
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
                description: 'El importe se creó correctamente.',
                /* onPressed: () 
              {│
              Navigator.pop(NavigatorKeys.navKey.currentContext!);
              Navigator.pop(NavigatorKeys.navKey.currentContext!);
              }*/

                /* onPressed: () {
                  Navigator.pop(NavigatorKeys.navKey.currentContext!);
                  /* final context = NavigatorKeys.navKey.currentContext!;
                  Navigator.of(context).popUntil((route) => popCount++ >= 2);*/
                }*/
                onPressed: () {
                  final context = NavigatorKeys.navKey.currentContext!;
                  Navigator.of(context)
                      .pop(true); // Devuelve resultado al modal anterior
                  Navigator.of(context).pop(
                      true); // Devuelve resultado al listado o pantalla principal
                });
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> editAmount(
      {required String id,
      required String date,
      required String description,
      required double amount,
      required String paymentId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    Map body = {
      'date': date,
      'description': description,
      'amount': amount,
      'paymentId': paymentId
    };

    try {
      http.Response res = await http.put(Uri.parse('$uri/api/amounts/edit/$id'),
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
                description: 'El importe se modificó correctamente.',
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     context, BottomBar.routeName, arguments: 1, (route) => true),
                /* onPressed: () {
                  // fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
                  Navigator.pop(NavigatorKeys.navKey.currentContext!);
                  Navigator.pop(NavigatorKeys.navKey.currentContext!);
                });*/
                onPressed: () {
                  final context = NavigatorKeys.navKey.currentContext!;
                  Navigator.of(context)
                      .pop(true); // Devuelve resultado al modal anterior
                  Navigator.of(context).pop(
                      true); // Devuelve resultado al listado o pantalla principal
                });
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<void> disableAmount(
      {
      //required BuildContext context,
      required String amountId}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    try {
      http.Response res = await http
          .put(Uri.parse('$uri/api/amounts/disable/$amountId'), headers: {
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
                description: 'El importe se eliminó correctamente.',
                // onPressed: () => Navigator.popUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     ModalRoute.withName(GroupsScreen.routeName))
                // onPressed: () => Navigator.pushNamedAndRemoveUntil(
                //     NavigatorKeys.navKey.currentContext!,
                //     GroupsScreen.routeName,
                //     (route) => false),
                onPressed: () =>
                    //  fromSuccessToGroups(NavigatorKeys.navKey.currentContext!)
                    Navigator.pop(NavigatorKeys.navKey.currentContext!));
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
