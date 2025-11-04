// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/generate/screens/generate_%C3%AFnstallments_form_screen.dart';
import 'package:payments_management/features/generate/widgets/card_checkbox_item.dart';
import 'package:payments_management/features/generate/widgets/message_empty.dart';
import 'package:payments_management/features/generate/widgets/modal_generate.dart';
import 'package:payments_management/models/generate_payment.dart';

class GenerateDetailsIndividualScreen extends StatefulWidget {
  static const String routeName = '/generate-payments-individual';
  // final String type;
  final String title;
  final List<GeneratePayment> payments;
  final String type;
  const GenerateDetailsIndividualScreen(
      {Key? key,
      required this.title,
      // required this.type,
      required this.payments,
      this.type = "individual"})
      : super(key: key);

  @override
  State<GenerateDetailsIndividualScreen> createState() =>
      _GenerateDetailsScreenState();
}

class _GenerateDetailsScreenState
    extends State<GenerateDetailsIndividualScreen> {
  // List<GeneratePayment> items = [];
  bool totalIsChecked = true;

  final TextEditingController _searchController = TextEditingController();
  List<GeneratePayment> filteredPayments = [];

  // @override
  // void initState() {
  //   super.initState();

  //   switch (widget.type) {
  //     case "individual":
  //       {
  //         items.add(widget.payments);
  //       }

  //       break;
  //     default:
  //   }

  //   for (var payment in widget.payments) {
  //     if (payment.namesList != null) {
  //       for (var item in payment.namesList!) {
  //         items
  //             .add(GeneratePayment(id: item.id!, name: item.name, state: true));
  //       }
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    filteredPayments = List.from(widget.payments);
  }

/* void checkedSelectAll() {
    int checkedNames = 0;
    for (var payment in widget.payments) {
      if (payment.state) checkedNames++;
    }

    if (checkedNames == widget.payments.length) {
      totalIsChecked = true;
    } else {
      totalIsChecked = false;
    }
  }

  void updateAllPayments(bool val) {
    if (val) {
      for (var payment in widget.payments) {
        payment.state = true;
      }
    } else {
      for (var payment in widget.payments) {
        payment.state = false;
      }
    }
  }*/

  void checkedSelectAll() {
    int checkedNames = 0;
    for (var payment in filteredPayments) {
      if (payment.state) checkedNames++;
    }
    totalIsChecked = checkedNames == filteredPayments.length;
  }

  void updateAllPayments(bool val) {
    for (var payment in filteredPayments) {
      payment.state = val;
    }
  }

  void onChangeCheckboxEverything(value) {
    setState(() {
      totalIsChecked = value!;
      updateAllPayments(value);
      checkedSelectAll();
    });
  }

  void defineRedirect() {
    switch (widget.type) {
      case "individual":
        openGenerateModal();

        break;
      case "installments":
        openInstallmentsScreen();
        break;
      //default:
    }
  }

  void openGenerateModal() async {
    // for (var element in widget.payments) {
    //   if (element.namesList != null) {
    //     debugPrint(element.namesList!.length.toString());
    //     for (var el2 in element.namesList!) {
    //       debugPrint(el2.name);
    //     }
    //   }
    // }

    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalGenerate(
            totalSelected: widget.payments
                .where((payment) => payment.state == true)
                .length,
            payments: widget.payments));
  }

  void openInstallmentsScreen() async {
    await Navigator.pushNamed(context, GenerateInstallmentsFormScreen.routeName,
        arguments: [
          widget.payments.where((payment) => payment.state == true).length,
          widget.payments
        ]);
  }

  /*void onChangeCheckboxEverything(value) {
    setState(() {
      totalIsChecked = value!;
      updateAllPayments(value);
      checkedSelectAll();
    });
  }*/

  void filterPayments(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredPayments = List.from(widget.payments);
      } else {
        filteredPayments = widget.payments
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
      checkedSelectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            MainTitle(title: widget.title),
            const SizedBox(
              height: 30,
            ),

            // 🔍 Buscador dinámico
            TextField(
              controller: _searchController,
              onChanged: filterPayments,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          filterPayments('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            CardCheckboxItem(
                state: totalIsChecked,
                text: 'Seleccionar Todo',
                onChanged: (value) => onChangeCheckboxEverything(value)),
            /*  widget.payments.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.payments.length,
                        itemBuilder: (context, index) {
                          return CardCheckboxItem(
                            state: widget.payments[index].state,
                            text: widget.payments[index].name,
                            onChanged: (value) {
                              setState(() {
                                widget.payments[index].state = value!;
                                checkedSelectAll();
                              });
                            },
                          );
                        }),
                  )
                : const MessageEmpty(),*/
            // 📋 Lista filtrada
            filteredPayments.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredPayments.length,
                      itemBuilder: (context, index) {
                        final payment = filteredPayments[index];
                        return CardCheckboxItem(
                          state: payment.state,
                          text: payment.name,
                          onChanged: (value) {
                            setState(() {
                              payment.state = value!;
                              checkedSelectAll();
                            });
                          },
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(child: Text('¡No existen resultados!')),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30)
                  .copyWith(top: 40),
              child: widget.payments
                      .where((payment) => payment.state == true)
                      .isNotEmpty
                  ? CustomButton(
                      text: 'GENERAR',
                      color: GlobalVariables.completeButtonColor,
                      textColor: Colors.white,
                      //  onTap: openGenerateModal,
                      onTap: defineRedirect,
                    )
                  : null,
            )
          ],
        ),
      ),
      //  ),
    );
  }
}
