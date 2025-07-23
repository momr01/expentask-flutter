// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/form_edit_payment/services/form_edit_payment_services.dart';
import 'package:payments_management/features/form_edit_payment/utils/form_edit_payment_utils.dart';
import 'package:payments_management/features/form_edit_payment/utils/navigation_form_edit_payment.dart';
import 'package:payments_management/features/form_edit_payment/widgets/amount_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/deadline_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/name_payment_section.dart';
import 'package:payments_management/features/form_edit_payment/widgets/task_checkbox_item.dart';
import 'package:payments_management/features/form_edit_payment/widgets/tasks_payment_section.dart';
import 'package:payments_management/models/name/payment_name.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/payment/payment_edit.dart';
import 'package:payments_management/models/task/edit_task_checkbox.dart';
import 'package:payments_management/models/task/task_edit.dart';
import 'package:payments_management/models/task_code/task_code.dart';

class FormEditPayment extends StatefulWidget {
  static const String routeName = '/form-edit-payment';
  final Payment payment;
  final List<PaymentName> names;
  final List<TaskCode> taskCodes;

  const FormEditPayment({
    Key? key,
    required this.payment,
    required this.names,
    required this.taskCodes,
  }) : super(key: key);

  @override
  State<FormEditPayment> createState() => _FormEditPaymentState();
}

class _FormEditPaymentState extends State<FormEditPayment> {
  //variables
  List<EditTaskCheckbox> taskItems = [];
  bool tasksSectionIsExpanded = false;
  bool atLeastOneTaskIsChecked = true;
  late String _nameValue = "";

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

    for (var item in taskItems) {
      if (item.state!) {
        tasksModified.add(TaskEdit(
            code: item.id!,
            deadline: dateFormatWithDash(item.controller!.text)));
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

    await formEditPaymentServices.editPayment(payment: paymentModified);
  }

  @override
  Widget build(BuildContext context) {
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
                                  taskItems.isNotEmpty
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
                              ),
                            const SizedBox(height: 30),
                          ],
                        )
                      // : const SizedBox(height: 30),
                      : const SizedBox(),
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
