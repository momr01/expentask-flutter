import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/utils/navigation_form_edit_payment.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment_edit.dart';
import 'package:payments_management/models/task_code/task_code.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FormEditPaymentServices {
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

  void editPayment({required PaymentEdit payment}) async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);

    List tasksMap = [];
    for (var task in payment.tasks) {
      tasksMap.add({'code': task.code, 'deadline': task.deadline});
    }

    Map body = {
      'name': payment.name,
      'deadline': payment.deadline,
      'amount': '${payment.amount}',
      'tasks': tasksMap
    };

    try {
      http.Response res = await http.put(
          Uri.parse(
              '$uri/api/payments/editPayment/${payment.id}?user=${userProvider.user.id}'),
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
                description: 'El pago se modificó correctamente.',
                onPressed: () => fromSuccessUpdateToPaymentDetails(
                    NavigatorKeys.navKey.currentContext!, payment.id));
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  Future<List<TaskCode>> fetchTaskCodes() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<TaskCode> codesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/task-codes/getAll?user=${userProvider.user.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              codesList.add(TaskCode.fromJson(jsonDecode(res.body)[i]));
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return codesList;
  }
}
