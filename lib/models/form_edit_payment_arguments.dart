import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class FormEditPaymentArguments {
  final Payment payment;
  final List<PaymentName> names;
  final List<TaskCode> taskCodes;

  FormEditPaymentArguments(this.payment, this.names, this.taskCodes);
}
