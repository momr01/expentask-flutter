// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/generate/services/generate_services.dart';
import 'package:payments_management/features/generate/widgets/select_section.dart';
import 'package:payments_management/models/generate_payment.dart';

class ModalGenerate extends StatefulWidget {
  final int totalSelected;
  final List<GeneratePayment> payments;
  const ModalGenerate({
    Key? key,
    required this.totalSelected,
    required this.payments,
  }) : super(key: key);

  @override
  State<ModalGenerate> createState() => _ModalGenerateState();
}

class _ModalGenerateState extends State<ModalGenerate> {
  final _newPaymentsFormKey = GlobalKey<FormState>();

  int currentMonth = 1;
  int currentYear = 2023;

  final GenerateServices generateServices = GenerateServices();

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now().month;
    currentYear = DateTime.now().year;
  }

  List<int> generateMonths() {
    List<int> months = [];

    for (var i = 1; i <= 12; i++) {
      months.add(i);
    }

    return months;
  }

  List<int> generateYears() {
    List<int> years = [];
    for (var i = 2023; i <= 2050; i++) {
      years.add(i);
    }

    return years;
  }

  Future<void> generatePayments() async {
    List<String> names = [];
    for (var payment in widget.payments) {
      if (payment.state) {
        names.add(payment.id);
      }
    }

    await generateServices.generatePayments(
        context: context, names: names, month: currentMonth, year: currentYear);
  }

  void openModalConfirmation() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalConfirmation(
              onTap: generatePayments,
              confirmText: 'confirmar',
              confirmColor: GlobalVariables.completeButtonColor!,
              middleText: 'generar ${widget.totalSelected}',
              endText: widget.totalSelected == 1 ? "pago" : 'pagos',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      insetPadding: const EdgeInsets.all(0),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        const Text(
          'Generación Masiva de Pagos',
          style: TextStyle(fontSize: 30),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Form(
            key: _newPaymentsFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectSection(
                    text: 'mes',
                    value: currentMonth,
                    onChange: (int? value) {
                      currentMonth = value!;
                    },
                    items: generateMonths()),
                SelectSection(
                    text: 'año',
                    value: currentYear,
                    onChange: (int? value) {
                      currentYear = value!;
                    },
                    items: generateYears()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pagos a generar:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(widget.totalSelected.toString(),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    CustomButtonOptions(
                        text: 'CONFIRMAR',
                        color: GlobalVariables.completeButtonColor,
                        onTap: () {
                          if (_newPaymentsFormKey.currentState!.validate()) {
                            openModalConfirmation();
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
    );
  }
}
