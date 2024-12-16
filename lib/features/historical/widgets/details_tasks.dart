// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/historical/utils/historical_utils.dart';
import 'package:payments_management/features/historical/widgets/task_attribute_row.dart';
import 'package:payments_management/models/task/task.dart';

class DetailsTasks extends StatefulWidget {
  final List<Task> tasks;
  const DetailsTasks({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  State<DetailsTasks> createState() => _DetailsTasksState();
}

class _DetailsTasksState extends State<DetailsTasks> {
  List<Function> sortOptions = [
    // (a, b) => b.isCompleted.toString().compareTo(a.isCompleted.toString()),
    (a, b) => a.instalmentNumber.compareTo(b.instalmentNumber),
    // (a, b) => a.deadline.compareTo(b.deadline),
    (a, b) => a.code.name.compareTo(b.code.name),
  ];

  @override
  void initState() {
    widget.tasks.sort((a, b) {
      for (var compare in sortOptions) {
        int result = compare(a, b);
        if (result != 0) return result;
      }
      return 0; // Si todos los comparadores devuelven 0, los elementos son iguales
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide())),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tasks[index].code.name.toUpperCase(),
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
                          value: getTaskState(widget.tasks[index].isActive,
                              widget.tasks[index].isCompleted),
                          color: getTaskStateColor(widget.tasks[index].isActive,
                              widget.tasks[index].isCompleted),
                        ),
                        TaskAttributeRow(
                            attribute: "Fecha de vto",
                            value: datetimeToStringWithDash(
                                widget.tasks[index].deadline)),
                        widget.tasks[index].dateCompleted != null
                            ? TaskAttributeRow(
                                attribute: "Fecha de resolución",
                                value: datetimeToStringWithDash(
                                    widget.tasks[index].dateCompleted!))
                            : const SizedBox(),
                        widget.tasks[index].place! == ""
                            ? const SizedBox()
                            : TaskAttributeRow(
                                attribute: "Medio de pago",
                                value: widget.tasks[index].place!),
                        widget.tasks[index].amountPaid == 0
                            ? const SizedBox()
                            : TaskAttributeRow(
                                attribute: "Importe abonado",
                                //   value: tasks[index].amountPaid.toString()
                                value:
                                    '\$ ${formatMoney(widget.tasks[index].amountPaid)}',
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
