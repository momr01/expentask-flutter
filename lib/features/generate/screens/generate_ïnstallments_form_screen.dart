import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/common/widgets/modals/modal_confirmation/modal_confirmation.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/generate/services/generate_services.dart';
import 'package:payments_management/features/generate/widgets/select_section.dart';
import 'package:payments_management/models/generate_payment.dart';

class GenerateInstallmentsFormScreen extends StatefulWidget {
  static const String routeName = '/generate-installments-form';
  final int totalSelected;
  final List<GeneratePayment> payments;
  const GenerateInstallmentsFormScreen(
      {super.key, required this.totalSelected, required this.payments});

  @override
  State<GenerateInstallmentsFormScreen> createState() =>
      _GenerateInstallmentsFormScreenState();
}

class _GenerateInstallmentsFormScreenState
    extends State<GenerateInstallmentsFormScreen> {
  final _newPaymentsFormKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  //final TextEditingController _periodController = TextEditingController();

  int currentMonth = 1;
  int currentYear = 2023;

  final GenerateServices generateServices = GenerateServices();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

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
              //endText: confirmationLabel(),
            ));
  }

  // String modalLengthLabel() {
  //   String label = "";
  //   switch (widget.type) {
  //     case "individual":
  //       {
  //         label = "Pagos";
  //       }
  //       break;
  //     case "group":
  //       {
  //         label = "Grupos";
  //       }
  //       break;
  //     //default:
  //   }

  //   return label;
  // }

  // String confirmationLabel() {
  //   String label = "";
  //   switch (widget.type) {
  //     case "individual":
  //       {
  //         label = widget.totalSelected == 1 ? "pago" : 'pagos';
  //       }
  //       break;
  //     case "group":
  //       {
  //         label = widget.totalSelected == 1 ? "grupo" : 'grupos';
  //       }
  //       break;
  //     // default:
  //   }

  //   return label;
  // }

  void _navigateBackToHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, BottomBar.routeName, arguments: 0, (route) => false);
  }

  void validateForm() {
    if (_newPaymentsFormKey.currentState!.validate()) {
      openModalConfirmation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      //  insetPadding: const EdgeInsets.all(0),
      //content:
      appBar: customAppBar(context,
          isMainPage: false, onBack: _navigateBackToHomeScreen),

      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Text(
            'Generación de Pagos en Cuotas',
            style: TextStyle(fontSize: 30),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Expanded(
            child:
                // Builder(builder: (context) {
                //return
                SingleChildScrollView(
              child: Form(
                  key: _newPaymentsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cantidad de cuotas:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: "Ingrese la cantidad de cuotas",
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: GlobalVariables.greyBackgroundColor,
                          isDense: true,
                          errorStyle:
                              TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null ||
                              val.isEmpty ||
                              int.tryParse(val) != null) {
                            return "Ingrese la cantidad de cuotas";
                          }
                          return null;
                        },
                      ),
                      // CustomTextField(
                      //   controller: _quantityController,
                      //   hintText: 'Ingrese la cantidad de cuotas',
                      //   //   modal: true,
                      //   isAmount: true,
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      SelectSection(
                          text: 'mes de primera cuota',
                          value: currentMonth,
                          onChange: (int? value) {
                            currentMonth = value!;
                          },
                          items: generateMonths()),
                      SelectSection(
                          text: 'año de primera cuota',
                          value: currentYear,
                          onChange: (int? value) {
                            currentYear = value!;
                          },
                          items: generateYears()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Periodicidad:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: "Mensual",
                            icon: const Icon(Icons.arrow_downward),
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: GlobalVariables.greyBackgroundColor,
                                isDense: true),
                            // onChanged: (String? value) => onChange(value),
                            onChanged: (String? value) {},
                            items: [
                              "Mensual",
                              "Bimestral",
                              "Semestral",
                              "Anual"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            // items: items.map<DropdownMenuItem<int>>((int value) {
                            //   return DropdownMenuItem<int>(
                            //     value: value,
                            //     child: Text(value.toString()),
                            //   );
                            // }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
                            // onTap: () {
                            //   if (_newPaymentsFormKey.currentState!
                            //       .validate()) {
                            //     openModalConfirmation();
                            //   }
                            // }
                            onTap: validateForm,
                          ),
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
            )
            // }
            //)
            ,
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}
