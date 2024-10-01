// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/historical/utils/historical_utils.dart';
import 'package:payments_management/features/historical/widgets/task_attribute_row.dart';
import 'package:payments_management/models/task/task.dart';

class DetailsTasks extends StatelessWidget {
  final List<Task> tasks;
  const DetailsTasks({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tasks[index].code.name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        TaskAttributeRow(
                          attribute: "Estado",
                          value: getTaskState(
                              tasks[index].isActive, tasks[index].isCompleted),
                        ),
                        TaskAttributeRow(
                            attribute: "Fecha de vto",
                            value: datetimeToStringWithDash(
                                tasks[index].deadline)),
                        tasks[index].dateCompleted != null
                            ? TaskAttributeRow(
                                attribute: "Fecha de resolución",
                                value: datetimeToStringWithDash(
                                    tasks[index].dateCompleted!))
                            : const SizedBox(),
                        tasks[index].place! == ""
                            ? const SizedBox()
                            : TaskAttributeRow(
                                attribute: "Medio de pago",
                                value: tasks[index].place!),
                        tasks[index].amountPaid == 0
                            ? const SizedBox()
                            : TaskAttributeRow(
                                attribute: "Importe abonado",
                                //   value: tasks[index].amountPaid.toString()
                                value:
                                    '\$ ${formatMoney(tasks[index].amountPaid)}',
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
