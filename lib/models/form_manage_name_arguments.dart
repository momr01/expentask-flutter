import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class FormManageNameArguments {
  final PaymentName name;
  final List<Category> categories;
  final List<TaskCode> taskCodes;

  FormManageNameArguments(this.name, this.categories, this.taskCodes);
}
