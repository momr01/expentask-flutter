import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/form_manage_name/screens/form_manage_name_screen.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/form_manage_name_arguments.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task_code/task_code.dart';

final FormEditPaymentServices formEditPaymentServices =
    FormEditPaymentServices();
final NamesServices namesServices = NamesServices();

void getDataToForm(context, PaymentName name) async {
  List<Category> categories = [];
  List<TaskCode> taskCodes = [];

  categories = await namesServices.fetchCategories(context: context);

  if (categories.isEmpty) {
    errorModal(
      context: context,
      description:
          "Debe crear al menos una categoría, antes de agregar un nombre.",
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
            context, BottomBar.routeName, arguments: 1, (route) => true);
      },
    );
  } else {
    taskCodes = await formEditPaymentServices.fetchTaskCodes();
    if (taskCodes.isEmpty) {
      errorModal(
        context: context,
        description:
            "Debe crear al menos un código, antes de agregar un nombre.",
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, arguments: 1, (route) => true);
        },
      );
    } else {
      //navigateToFormEditPayment(context, payment!, names, taskCodes);
      navigateToFormNameScreen(context, name, categories, taskCodes);
    }
  }
  // navigateToFormEditPayment(context, payment!);
}

void navigateToFormNameScreen(BuildContext context, PaymentName name,
    List<Category> categories, List<TaskCode> taskCodes) {
  Navigator.pushNamed(context, FormManageNameScreen.routeName,
      // arguments: PaymentName(
      //     name: "name",
      //     isActive: false,
      //     category: Category(name: "", isActive: false))
      arguments: FormManageNameArguments(name, categories, taskCodes));
}


  // void navigateToFormNameScreen(BuildContext context, List<Category> categories,
  //     List<TaskCode> taskCodes) {
  //   Navigator.pushNamed(context, FormManageNameScreen.routeName,
  //       // arguments: PaymentName(
  //       //     name: "name",
  //       //     isActive: false,
  //       //     category: Category(name: "", isActive: false))
  //       arguments: FormManageNameArguments(
  //           PaymentName(
  //               name: "name",
  //               isActive: false,
  //               category: Category(name: "", isActive: false)),
  //           categories,
  //           taskCodes));
  // }
