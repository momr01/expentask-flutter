import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
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

  //int firstIncompleteInstalment(Payment payment) {
  Map<String, int> installmentsQuantityData(Payment payment) {
// if (payment.hasInstallments) {
    //debugPrint(payment.id);

    List allNumbers = [];
    List undoneNumbers = [];

    for (var i = 0; i < payment.tasks.length; i++) {
      //debugPrint(payment.tasks[i].instalmentNumber.toString());
      allNumbers.add(payment.tasks[i].instalmentNumber);

      if (!payment.tasks[i].isCompleted) {
        undoneNumbers.add(payment.tasks[i].instalmentNumber);
      }
    }
    List allFinalList = allNumbers.toSet().toList();
    List finalList = undoneNumbers.toSet().toList();
    // debugPrint(finalList[0].toString());
    //}

    // debugPrint(finalList.length.toString());
    finalList.sort();

    Map<String, int> data = {
      "firstInstalment": finalList[0],
      "doneInstallments": allFinalList.length - finalList.length
    };

    // return finalList[0];
    //debugPrint(finalList[0].toString());
    // for (var element in finalList) {
    //   debugPrint(element.toString());
    // }
    return data;
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
              //  crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Text(payment.name.category.name),
                    //  Flexible(
                    //    child:
                    ColorRoundedItem(
                      colorBackCard: Colors.purple,
                      colorBorderCard: Colors.purple,
                      text: capitalizeFirstLetter(payment.name.category.name),
                      colorText: Colors.white,
                      sizeText: 13,
                    ),
                    //),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    GestureDetector(
                        onTap: () =>
                            navigateToPaymentInfoScreen(context, payment.id!),
                        child: const Icon(Icons.visibility_rounded,
                            size: 30, color: Colors.black)),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

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
                        ? CircularPercentIndicator(
                            radius: 55,
                            animation: true,
                            animationDuration: 1500,
                            lineWidth: 15.0,
                            //percent: 0.5,
                            percent: countCompletedTasks(payment.tasks),
                            center: Text(
                              "${installmentsQuantityData(payment)["doneInstallments"]} /${payment.installmentsQuantity}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.butt,
                            // backgroundColor: Colors.yellow,
                            progressColor: Colors.green,
                          )
                        : CircularPercentIndicator(
                            radius: 55,
                            lineWidth: 15.0,
                            animation: true,
                            animationDuration: 1500,
                            restartAnimation: true,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 20),
                            decoration: BoxDecoration(
                                color: GlobalVariables.whiteColor,
                                // border: Border.all(),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.35),
                                    blurRadius: 15,
                                    spreadRadius: 0,
                                    offset: Offset(
                                      0,
                                      5,
                                    ),
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Text(
                                  "CUOTA ${installmentsQuantityData(payment)["firstInstalment"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: GlobalVariables.primaryColor),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Wrap(
                                    spacing: 20.0,
                                    runSpacing: 10.0,
                                    children: [
                                      for (var task in payment.tasks)
                                        if (task.isActive &&
                                            task.instalmentNumber ==
                                                installmentsQuantityData(
                                                    payment)["firstInstalment"])
                                          ButtonCompleteTask(
                                              task: task,
                                              // idPayment: payment.id!,
                                              payment: payment,
                                              amount: payment.amount)
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Vence el ${formatDateWithTime(payment.tasks.where((element) => element.instalmentNumber == installmentsQuantityData(payment)["firstInstalment"]).first.deadline.toString())}",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            )),
                      )
                    // Center(
                    //     child: Flexible(
                    //         child: SizedBox(
                    //     height: 100,
                    //     child: ListView.separated(
                    //       separatorBuilder: (context, index) => const SizedBox(
                    //         width: 20,
                    //       ),
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return Text("hola");
                    //       },
                    //       itemCount: 18,
                    //     ),
                    //   )))
                    : Center(
                        child: Wrap(spacing: 20.0, runSpacing: 10.0, children: [
                        for (var task in payment.tasks)
                          if (task.isActive)
                            ButtonCompleteTask(
                                task: task,
                                // idPayment: payment.id!,
                                payment: payment,
                                amount: payment.amount)
                      ])),
                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}
