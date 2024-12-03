import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/features/categories/services/categories_services.dart';
import 'package:payments_management/features/form_manage_name/screens/form_manage_name_screen.dart';
import 'package:payments_management/features/tasks/services/tasks_services.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/form_manage_name_arguments.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task_code/task_code.dart';

final CategoriesServices categoriesServices = CategoriesServices();
final TasksServices tasksServices = TasksServices();

Future<void> getDataToForm(context, PaymentName name) async {
  List<Category> categories = [];
  List<TaskCode> taskCodes = [];

  categories = await categoriesServices.fetchCategories();

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
    taskCodes = await tasksServices.fetchUsableTaskCodes();
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
      navigateToFormNameScreen(context, name, categories, taskCodes);
    }
  }
}

void navigateToFormNameScreen(BuildContext context, PaymentName name,
    List<Category> categories, List<TaskCode> taskCodes) {
  Navigator.pushNamed(context, FormManageNameScreen.routeName,
      arguments: FormManageNameArguments(name, categories, taskCodes));
}
