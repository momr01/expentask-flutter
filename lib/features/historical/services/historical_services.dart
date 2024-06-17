import 'dart:convert';

import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HistoricalServices {
  Future<List<Payment>> fetchAllPayments({required context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Payment> paymentList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/payments/getAll'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              paymentList.add(Payment.fromJson(jsonDecode(res.body)[i]));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return paymentList;
  }
}
