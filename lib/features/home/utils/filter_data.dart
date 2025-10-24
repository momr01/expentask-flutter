import 'package:payments_management/models/payment/payment.dart';

List<Map<String, dynamic>> filterData = [
  {
    "id": 4,
    "name": "mes",
    "type": "month",
    "state": true,
    "filter": (List<Payment> payments) => payments
        .where((payment) => payment.tasks.any((task) =>
            !task.isCompleted &&
            task.deadline.month == DateTime.now().month &&
            task.deadline.year == DateTime.now().year))
        .toList(),
  },
  {
    "id": 2,
    "name": "individuales",
    "type": "individual",
    "state": false,
    "filter": (List<Payment> payments) =>
        payments.where((payment) => !payment.hasInstallments).toList(),
  },
  {
    "id": 3,
    "name": "cuotas",
    "type": "installments",
    "state": false,
    "filter": (List<Payment> payments) =>
        payments.where((payment) => payment.hasInstallments).toList(),
  },
  {
    "id": 5,
    "name": "vencidos",
    "type": "expired",
    "state": false,
    "filter": (List<Payment> payments) => payments
        .where((payment) => payment.tasks.any((task) =>
                !task.isCompleted && task.deadline.isBefore(DateTime.now())
            /*task.deadline.month == DateTime.now().month &&
            task.deadline.year == DateTime.now().year*/
            ))
        .toList(),
  },
  {
    "id": 1,
    "name": "todos",
    "type": "all",
    "state": false,
    "filter": (List<Payment> payments) => payments,
  },
];
