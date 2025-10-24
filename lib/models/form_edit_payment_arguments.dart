import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';
import 'package:payments_management/models/shared_duty/payment_shared_duty.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class FormEditPaymentArguments {
  final PaymentWithSharedDuty payment;
  final List<PaymentName> names;
  final List<TaskCode> taskCodes;
  // final bool isSharedDuty;
  final PaymentSharedDuty sharedDuty;

  FormEditPaymentArguments(
      this.payment, this.names, this.taskCodes, this.sharedDuty);
}
