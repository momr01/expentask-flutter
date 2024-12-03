import 'package:flutter/material.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/home/widgets/button_complete_task.dart';
import 'package:payments_management/features/payment_details/screens/payment_details_screen.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  const PaymentCard({super.key, required this.payment});

  double countCompletedTasks(List tasks) {
    List activeTasks = [];

    for (var task in tasks) {
      if (task.isActive) activeTasks.add(task);
    }
    int total = activeTasks.length;

    int completed = 0;

    for (var task in tasks) {
      if (task.isActive && task.isCompleted) completed++;
    }

    return completed / total;
  }

  int numberToPercent(List tasks) {
    double totalCompleted = countCompletedTasks(tasks);
    return (totalCompleted * 100).toInt();
  }

  void navigateToPaymentInfoScreen(BuildContext context, String paymentId) {
    Navigator.pushNamed(context, PaymentDetailsScreen.routeName,
        arguments: paymentId);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 0,
      //color: Colors.grey.shade300,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        width: width - 30,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                    onTap: () =>
                        navigateToPaymentInfoScreen(context, payment.id!),
                    child: const Icon(Icons.visibility_rounded,
                        size: 30, color: Colors.black)),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.grey.shade300),
                //   onPressed: () =>
                //       navigateToPaymentInfoScreen(context, payment.id!),
                //   child: const Icon(Icons.visibility_rounded,
                //       size: 30, color: Colors.black),
                // ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    payment.hasInstallments
                        ? new CircularPercentIndicator(
                            radius: 55,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 15.0,
                            percent: 0.5,
                            center: new Text(
                              "18/18",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.butt,
                            backgroundColor: Colors.yellow,
                            progressColor: Colors.red,
                          )
                        : CircularPercentIndicator(
                            radius: 55,
                            lineWidth: 15.0,
                            percent: countCompletedTasks(payment.tasks),
                            center: Text(
                              '${numberToPercent(payment.tasks)}%',
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            progressColor: Colors.green,
                          ),
                    Expanded(
                        child: Column(children: [
                      Text(
                        capitalizeFirstLetter(payment.name.name),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                          //'Vto ${datetimeToString(payment.deadline)}',
                          'Período ${payment.period}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]))
                  ],
                ),
                const SizedBox(height: 10),
                payment.hasInstallments
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      )
                    : Center(
                        child: Wrap(spacing: 20.0, runSpacing: 10.0, children: [
                        for (var task in payment.tasks)
                          if (task.isActive)
                            ButtonCompleteTask(
                                task: task,
                                idPayment: payment.id!,
                                amount: payment.amount)
                      ])),
                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}
