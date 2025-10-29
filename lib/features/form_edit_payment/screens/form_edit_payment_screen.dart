// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/form_edit_payment/utils/form_edit_payment_utils.dart';
import 'package:payments_management/features/form_edit_payment/utils/navigation_form_edit_payment.dart';
import 'package:payments_management/features/form_edit_payment/widgets/amount_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/deadline_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/name_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/task_checkbox_item.dart';
import 'package:payments_management/features/form_edit_payment/widgets/tasks_payment_section.dart';
import 'package:payments_management/features/shared_duty/widgets/shared_duty_checkbox.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_edit.dart';
import 'package:payments_management/models/payment/payment_with_shared_duty.dart';
import 'package:payments_management/models/shared_duty/payment_shared_duty.dart';
import 'package:payments_management/models/task/edit_task_checkbox.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/models/task/task_edit.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class TaskDate {
  final String idTask;
  DateTime dateTask;

  TaskDate({required this.idTask, required this.dateTask});
}

class FormEditPayment extends StatefulWidget {
  static const String routeName = '/form-edit-payment';
  final PaymentWithSharedDuty payment;
  final List<PaymentName> names;
  final List<TaskCode> taskCodes;
//  final bool isSharedDuty;
  final PaymentSharedDuty sharedDuty;

  const FormEditPayment(
      {Key? key,
      required this.payment,
      required this.names,
      required this.taskCodes,
      required this.sharedDuty})
      : super(key: key);

  @override
  State<FormEditPayment> createState() => _FormEditPaymentState();
}

class _FormEditPaymentState extends State<FormEditPayment> {
  //variables
  List<EditTaskCheckbox> taskItems = [];
  bool tasksSectionIsExpanded = false;
  bool atLeastOneTaskIsChecked = true;
  late String _nameValue = "";
  DateTime _fecha = DateTime.now();
  List<TaskDate> _fechas = [];

  // late String creditorName = "";
  // late String creditorId = "";

  String creditorName = "";
  String creditorId = "";

  //form
  final _editPaymentFormKey = GlobalKey<FormState>();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  List<TextEditingController> controllers = [];

//services
  final FormEditPaymentServices formEditPaymentServices =
      FormEditPaymentServices();

  @override
  void initState() {
    super.initState;
    initControllersValues();
    setControllersAndCheckbox();
    checkAtLeastOneTrue();
    setTasksDates();

    creditorName = widget.sharedDuty.creditorName ?? "";
    creditorId = widget.sharedDuty.creditorId ?? "";

    // _fecha = widget.registro!.date;
  }

  @override
  void dispose() {
    super.dispose();
    disposeFormControllers();
  }

  //initialize every form controller
  initControllersValues() {
    _deadlineController.text =
        '${widget.payment.deadline.day}/${widget.payment.deadline.month}/${widget.payment.deadline.year}';
    _amountController.text = widget.payment.amount.toString();
    _nameValue = widget.payment.name.id!;
  }

  //dispose every form controller
  disposeFormControllers() {
    _deadlineController.dispose();
    _amountController.dispose();

    for (var i = 0; i < controllers.length; i++) {
      controllers[i].dispose();
    }
  }

//create controllers and checkbox of every task
  setControllersAndCheckbox() {
    setState(() {
      defineControllersAndCheckbox(
          widget.taskCodes, widget.payment, controllers, taskItems);
    });
  }

  void updateCreditorValues(String newCreditorName, String newCreditorId) {
    setState(() {
      creditorName = newCreditorName;
      creditorId = newCreditorId;
    });
  }

  setTasksDates() {
    for (var task in widget.payment.tasks) {
      setState(() {
        _fechas.add(TaskDate(idTask: task.id!, dateTask: task.deadline));
      });
    }
  }

//select date when check input date
  void selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      String formattedDate =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

      setState(() {
        controller.text = formattedDate;
      });
    }
  }

//verify at least one task is checked, so it is possible to update
  void checkAtLeastOneTrue() {
    int checkedTasks = 0;

    for (var item in taskItems) {
      debugPrint(item.state.toString());
      if (item.state!) checkedTasks++;
    }
    if (checkedTasks >= 1) {
      atLeastOneTaskIsChecked = true;
    } else {
      atLeastOneTaskIsChecked = false;
    }
  }

//validate type of amount
  bool formCustomValidations() {
    debugPrint("desde form para editar: " + creditorName + " - " + creditorId);
    if (validateAmount(_amountController.text)) {
      return true;
    } else {
      return false;
    }
  }

//open the modal that requires confirmation about edit
  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: editPayment,
              confirmText: 'editar',
              confirmColor: Colors.blue,
              middleText: 'editar',
              endText: 'el pago',
            ));
  }

//edit function
  Future<void> editPayment() async {
    List<TaskEdit> tasksModified = [];

    if (widget.payment.hasInstallments) {
      for (var installment in _fechas) {
        tasksModified.add(TaskEdit(
            code: installment.idTask,
            // deadline: dateFormatWithDash(installment.dateTask.toString())
            deadline: DateFormat('yyyy-MM-dd').format(installment.dateTask)));
      }
    } else {
      for (var item in taskItems) {
        if (item.state!) {
          tasksModified.add(TaskEdit(
              code: item.id!,
              deadline: dateFormatWithDash(item.controller!.text)));
        }
      }
    }

    PaymentEdit paymentModified = PaymentEdit(
        id: widget.payment.id!,
        name: _nameValue,
        deadline: dateFormatWithDash(_deadlineController.text),
        hasInstallments: widget.payment.hasInstallments,
        amount: double.tryParse(_amountController.text) != null
            ? double.parse(_amountController.text)
            : double.parse(_amountController.text.replaceAll(',', '.')),
        tasks: tasksModified);

    await formEditPaymentServices.editPayment(
        withInstallments: widget.payment.hasInstallments,
        payment: paymentModified,
        creditorId: creditorId,
        sharedDutyId: widget.sharedDuty.sharedDutyId != null
            ? widget.sharedDuty.sharedDutyId!
            : "");

    for (var element in paymentModified.tasks) {
      debugPrint(element.code);
      debugPrint(element.deadline);
    }
    // debugPrint(paymentModified.)
  }

  void _seleccionarFecha(Task task) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: _fecha,
      initialDate:
          _fechas.where((element) => element.idTask == task.id!).first.dateTask,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // setState(() => _fecha = picked);
      setState(() => _fechas
          .where((element) => element.idTask == task.id!)
          .first
          .dateTask = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      widget.payment.installmentsQuantity,
      (i) => i + 1,
    );

    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            const MainTitle(title: 'Editar pago'),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _editPaymentFormKey,
              child: Column(
                children: [
                  NamePaymentSection(
                    nameValue: _nameValue,
                    names: widget.names,
                    onChange: (String? value) {
                      setState(() {
                        _nameValue = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  !widget.payment.hasInstallments
                      ? Column(
                          children: [
                            DeadlinePaymentSection(
                                onTap: (controller) => selectDate(controller),
                                controller: _deadlineController),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  AmountPaymentSection(
                    controller: _amountController,
                    paymentId: widget.payment.id!,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  !widget.payment.hasInstallments
                      ? Column(
                          children: [
                            TasksPaymentSection(
                              isExpanded: tasksSectionIsExpanded,
                              onTap: () {
                                setState(() {
                                  tasksSectionIsExpanded =
                                      !tasksSectionIsExpanded;
                                });
                              },
                            ),
                            if (tasksSectionIsExpanded)
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(right: 50, left: 20),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Tareas'),
                                          Text('Vto')
                                        ]),
                                  ),
                                  const SizedBox(height: 10),
                                  // 🔹 Altura fija con scroll interno
                                  taskItems.isNotEmpty
                                      ? SizedBox(
                                          height:
                                              200, // 👈 altura fija, ajustala a lo que necesites
                                          child: ListView.separated(
                                            itemCount: taskItems.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 10),
                                            itemBuilder: (context, index) {
                                              return TaskCheckboxItem(
                                                item: taskItems[index],
                                                onChangeCheckbox:
                                                    (bool? value) {
                                                  setState(() {
                                                    taskItems[index].state =
                                                        value!;
                                                    checkAtLeastOneTrue();
                                                  });
                                                },
                                                onChangeDate: () => selectDate(
                                                    taskItems[index]
                                                        .controller!),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          child: const Center(
                                            child: Text(
                                              'Sin Datos',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            /* taskItems.isNotEmpty
                                      ? ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(
                                                height: 10,
                                              ),
                                          shrinkWrap: true,
                                          itemCount: taskItems.length,
                                          itemBuilder: (context, index) {
                                            return TaskCheckboxItem(
                                                item: taskItems[index],
                                                onChangeCheckbox:
                                                    (bool? value) {
                                                  setState(() {
                                                    taskItems[index].state =
                                                        value!;
                                                    checkAtLeastOneTrue();
                                                  });
                                                },
                                                onChangeDate: () => selectDate(
                                                    taskItems[index]
                                                        .controller!));
                                          })
                                      : Container(
                                          alignment: Alignment.center,
                                          child: const Center(
                                            child: Text(
                                              'Sin Datos',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                ],
                              ),*/
                            const SizedBox(
                              height: 20,
                            ),
                            SharedDutyCheckbox(
                              //  defaultValue: widget.isSharedDuty,
                              sharedDuty: widget.sharedDuty,
                              isEdit: true,
                              // creditorId: "",
                              // creditorName: "",
                              // onValueChanged: (p0, p1) {},
                              onValueChanged: updateCreditorValues,
                              creditorId: creditorId,
                              creditorName: creditorName,
                            ),
                            const SizedBox(height: 30),
                          ],
                        )
                      // : const SizedBox(height: 30),
                      //  : const SizedBox(),
                      : Column(children: [
                          TasksPaymentSection(
                            isExpanded: tasksSectionIsExpanded,
                            onTap: () {
                              setState(() {
                                tasksSectionIsExpanded =
                                    !tasksSectionIsExpanded;
                              });
                            },
                            label: "Cuotas",
                          ),
                          /*  GestureDetector(
                            onTap: () {
                              setState(() {
                                tasksSectionIsExpanded =
                                    !tasksSectionIsExpanded;
                              });
                            },
                            child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: GlobalVariables.greyBackgroundColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Cuotas:',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Icon(tasksSectionIsExpanded
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down)
                                    ],
                                  ),
                                )),
                          ),*/
                          if (tasksSectionIsExpanded)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 50, left: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Cuotas / Tareas'),
                                        Text('Vto')
                                      ]),
                                ),
                                const SizedBox(height: 10),
                                // 🔹 Altura fija con scroll interno
                                // taskItems.isNotEmpty
                                //  ?
                                /*  SizedBox(
                                  height: 200,
                                  child: ListView.separated(
                                    itemCount: items.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final currentInstalment = widget.payment
                                          .tasks[index].instalmentNumber;

                                      // Filtramos todos los items que tengan el mismo número de cuota
                                      final matchingTasks = widget.payment.tasks
                                          .where((t) =>
                                              t.instalmentNumber ==
                                              currentInstalment)
                                          .toList();

                                      // Renderizamos una fila por cada tarea que comparte esa cuota
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: matchingTasks.map((task) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // ✅ Checkbox + texto
                                              Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      activeColor:
                                                          GlobalVariables
                                                              .primaryColor,
                                                      // value: task.state,
                                                      value: true,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          //task.state = value!;
                                                          checkAtLeastOneTrue();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        '${task.instalmentNumber} - ${task.code.name}',
                                                        style: const TextStyle(
                                                            fontSize: 14),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // 📅 Campo de fecha + ícono
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: CustomTextField(
                                                        // controller: task.controller!,
                                                        controller:
                                                            _amountController,
                                                        hintText: 'Fecha',
                                                        //readOnly: true,
                                                        //   onTap: () => selectDate(task.controller!),
                                                        onTap: () => selectDate(
                                                            _amountController),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.calendar_today,
                                                          size: 20),
                                                      // onPressed: () => selectDate(task.controller!),
                                                      onPressed: () =>
                                                          selectDate(
                                                              _amountController),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                )*/

                                SizedBox(
                                  height: 200,
                                  child: Builder(builder: (context) {
                                    // ✅ 1. Agrupar tasks por número de cuota
                                    final groupedTasks = <int, List<Task>>{};
                                    for (var task in widget.payment.tasks) {
                                      final cuota = task.instalmentNumber ?? 0;
                                      groupedTasks
                                          .putIfAbsent(cuota, () => [])
                                          .add(task);
                                    }

                                    final cuotas = groupedTasks.keys.toList()
                                      ..sort();

                                    // ✅ 2. Renderizar una card por cuota
                                    return ListView.separated(
                                      itemCount: cuotas.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) {
                                        final cuota = cuotas[index];
                                        final tareas = groupedTasks[cuota]!;

                                        return Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Encabezado de la cuota
                                                Text(
                                                  "Cuota $cuota",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),

                                                // ✅ 3. Renderizar todas las tareas de esta cuota en filas
                                                Column(
                                                  children: [
                                                    for (var t in tareas)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              /*   Checkbox(
                                                                checkColor:
                                                                    Colors
                                                                        .white,
                                                                activeColor:
                                                                    GlobalVariables
                                                                        .primaryColor,
                                                                // value: t.state ?? false,
                                                                value: true ??
                                                                    false,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    // t.state = value ?? false;
                                                                  });
                                                                },
                                                              ),*/
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                capitalizeFirstLetter(
                                                                    t.code
                                                                        .name),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                          // Si querés agregar fecha o campo editable, lo ponés aquí:
                                                          // SizedBox(width: 120, child: CustomTextField(...))
                                                          TextButton(
                                                              /* onPressed: t.isCompleted ?? () {
                                                                  _seleccionarFecha(
                                                                      t)  } : null,*/
                                                              onPressed:
                                                                  (t.isCompleted ??
                                                                          false)
                                                                      ? null
                                                                      : () =>
                                                                          _seleccionarFecha(
                                                                              t),

                                                              // child: Text("Fecha: ${DateFormat.yMd().format(_fecha)}"),
                                                              child: Text(
                                                                  "${DateFormat('dd/MM/yyyy').format(_fechas.where((element) => element.idTask == t.id!).first.dateTask)}")),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                )

                                /*SizedBox(
                                  height:
                                      200, // 👈 altura fija, ajustala a lo que necesites
                                  child: Builder(
                                    builder: (context) {
                                       // ✅ 1. Agrupar tasks por número de cuota
    final groupedTasks = <int, List<Task>>{};
    for (var task in widget.payment.tasks) {
      final cuota = task.instalmentNumber ?? 0;
      groupedTasks.putIfAbsent(cuota, () => []).add(task);
    }

    final cuotas = groupedTasks.keys.toList()..sort();
    
                                      return ListView.separated(
                                        // itemCount: taskItems.length,
                                        // itemCount: widget.payment.tasks.length,
                                        itemCount: cuotas.length,
                                        // widget.payment.installmentsQuantity,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                      // for (var i = 1; i <= widget.payment.installmentsQuantity; i++) {
                                      //   if()
                                      
                                      //}
                                      // for (var element in collection) {
                                      
                                      // }
                                          /*  for (var i = 1;
                                              i <=
                                                  widget
                                                      .payment.installmentsQuantity;
                                              i++) {*/
                                          //  return
                                          /*  TaskCheckboxItem(
                                                //  item: taskItems[index],
                                                item: widget.payment.tasks[index],
                                                  onChangeCheckbox: (bool? value) {
                                                    setState(() {
                                                      taskItems[index].state =
                                                          value!;
                                                      checkAtLeastOneTrue();
                                                    });
                                                  },
                                                  onChangeDate: () => selectDate(
                                                      taskItems[index].controller!),
                                                );*/
                                                final cuota = cuotas[index];
        final tareas = groupedTasks[cuota]!;

                                          return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(children: [
                                                  Checkbox(
                                                      checkColor: Colors.white,
                                                      activeColor: GlobalVariables
                                                          .primaryColor,
                                                      // value: item.state,
                                                      value: true,
                                                      onChanged: (bool? value) =>
                                                          // onChangeCheckbox(value),
                                                          {}),
                                                  const SizedBox(width: 20),
                                                  for (var item in items)
                                                    if (item ==
                                                        widget.payment.tasks[index]
                                                            .instalmentNumber)
                                                      SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                              // capitalizeFirstLetter(
                                                              //     item.name!))
                                                              capitalizeFirstLetter(
                                                                  '${items[index]} - ${widget.payment.tasks[index].code.name}                                                       ')))
                                                ]),
                                                /* Flexible(
                                                    child: SizedBox(
                                                  width: 120,
                                                  child: CustomTextField(
                                                    controller: item.controller!,
                                                    hintText:
                                                        'Seleccione una fecha válida',
                                                    maxLines: 1,
                                                    modal: true,
                                                    onTap: onChangeDate,
                                                  ),
                                                )),*/
                                              ]);
                                          // }
                                      
                                          /*return
                                              /*  TaskCheckboxItem(
                                                //  item: taskItems[index],
                                                item: widget.payment.tasks[index],
                                                  onChangeCheckbox: (bool? value) {
                                                    setState(() {
                                                      taskItems[index].state =
                                                          value!;
                                                      checkAtLeastOneTrue();
                                                    });
                                                  },
                                                  onChangeDate: () => selectDate(
                                                      taskItems[index].controller!),
                                                );*/
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                Row(children: [
                                                  Checkbox(
                                                      checkColor: Colors.white,
                                                      activeColor: GlobalVariables
                                                          .primaryColor,
                                                      // value: item.state,
                                                      value: true,
                                                      onChanged: (bool? value) =>
                                                          // onChangeCheckbox(value),
                                                          {}),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                          // capitalizeFirstLetter(
                                                          //     item.name!))
                                                          capitalizeFirstLetter(
                                                              '${widget.payment.tasks[index].instalmentNumber} - ${widget.payment.tasks[index].code.name}                                                       ')))
                                                ]),
                                                /* Flexible(
                                                    child: SizedBox(
                                                  width: 120,
                                                  child: CustomTextField(
                                                    controller: item.controller!,
                                                    hintText:
                                                        'Seleccione una fecha válida',
                                                    maxLines: 1,
                                                    modal: true,
                                                    onTap: onChangeDate,
                                                  ),
                                                )),*/
                                              ]);*/
                                        },
                                      );
                                    }
                                  ),
                                )*/
                                /*   : Container(
                                        alignment: Alignment.center,
                                        child: const Center(
                                          child: Text(
                                            'Sin Datos',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),*/
                              ],
                            ),
                          const SizedBox(
                            height: 30,
                          )
                        ]),
                  if (atLeastOneTaskIsChecked)
                    CustomButton(
                        text: 'EDITAR',
                        color: GlobalVariables.completeButtonColor,
                        onTap: () {
                          if (_editPaymentFormKey.currentState!.validate() &&
                              formCustomValidations()) {
                            openModalConfirmation();
                          }
                        }),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: 'CANCELAR',
                    color: GlobalVariables.greyBackgroundColor,
                    onTap: () => cancelUpdateForm(context),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
