// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/common/widgets/custom_currency_textfield.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/error_modal.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/utils/form_edit_payment_utils.dart';
import 'package:payments_management/features/home/services/home_services.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/task/task.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ModalCompleteTask extends StatefulWidget {
  final Task task;
  //final String idPayment;
  final Payment payment;
  final double amount;
  //final bool hasInstallments;
  const ModalCompleteTask(
      {Key? key,
      required this.task,
      //required this.idPayment,
      required this.amount,
      required this.payment
      // this.hasInstallments = false
      })
      : super(key: key);

  @override
  State<ModalCompleteTask> createState() => _ModalCompleteTaskState();
}

class _ModalCompleteTaskState extends State<ModalCompleteTask> {
  final _completeTaskFormKey = GlobalKey<FormState>();

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _amountPaidController = TextEditingController();
  final TextEditingController _dateCompletedController =
      TextEditingController();
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    //debugPrint(userProvider.user.email);
    _placeController.text =
        userProvider.user.email == "maxi.omr01@gmail.com" ? "Macro Maxi" : "";
    //_amountPaidController.text = widget.amount.toString();
    _amountPaidController.text = widget.payment.hasInstallments
        ?
        //(formatMoney(widget.amount / widget.payment.installmentsQuantity))
        (widget.amount / widget.payment.installmentsQuantity).toStringAsFixed(2)
        : widget.amount.toString();
    _dateCompletedController.text =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  }

  @override
  void dispose() {
    super.dispose();
    _placeController.dispose();
    _dateCompletedController.dispose();
  }

  void selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      String formattedDate =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

      setState(() {
        _dateCompletedController.text = formattedDate;
      });
    }
  }

  Future<void> completeTask() async {
    List<String> dateParts = _dateCompletedController.text.split('/');
    String completedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';

    await homeServices.completeTask(
        context: context,
        paymentId: widget.payment.id!,
        taskId: widget.task.id!,
        dateCompleted: completedDate,
        place: widget.task.code.number == 1 ? _placeController.text : "",
        amount: correctAmount(_amountPaidController.text).toString());
  }

  void validateFormData() {
    //debugPrint(stringMoneyToDouble(_amountPaidController.text).toString());
    if (double.tryParse(_amountPaidController.text) is double) {
      if (validateAmount(double.parse(_amountPaidController.text).toString())
          //||
          //stringMoneyToDouble(_amountPaidController.text) is double
          ) {
        openModalConfirmation();
      }
    } else {
      errorModal(
          context: context,
          description:
              "El importe abonado no es correcto. Verifique e intente nuevamente.");
    }
  }

  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: completeTask,
              confirmText: 'completar',
              confirmColor: GlobalVariables.completeButtonColor!,
              middleText: 'marcar como completa',
              endText: 'la tarea seleccionada',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            'Tarea "${capitalizeFirstLetter(widget.task.code.name)}"',
            style: const TextStyle(fontSize: 30),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Form(
              key: _completeTaskFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (widget.task.code.number == 1)
                  if (widget.task.code.name.toLowerCase() == "pagar"
                      //||
                      // widget.task.code.name.toLowerCase().contains("pay")
                      )
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medio de pago:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: _placeController,
                          hintText: 'Ingrese el medio de pago',
                          modal: true,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Importe abonado:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: _amountPaidController,
                          hintText: 'Ingrese el importe cancelado',
                          modal: true,
                          isAmount: true,
                        ),
                        // CustomCurrencyTextfield(
                        //   controller: _amountPaidController,
                        //   hintText: "Enter amount",
                        //   isAmount: true,
                        //   centeredText: true,
                        // ),
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Fecha:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _dateCompletedController,
                    hintText: 'Ingrese la fecha',
                    modal: true,
                    onTap: selectDate,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      CustomButtonOptions(
                          text: 'COMPLETAR',
                          color: GlobalVariables.completeButtonColor,
                          onTap: () {
                            if (_completeTaskFormKey.currentState!.validate()) {
                              //openConfirmationCompleteTask();
                              //debugPrint('open confirmation modal');
                              //  openModalConfirmation();
                              validateFormData();
                            }
                          }),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomButtonOptions(
                          text: 'CANCELAR',
                          color: GlobalVariables.cancelButtonColor,
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ],
                  )
                ],
              )),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
