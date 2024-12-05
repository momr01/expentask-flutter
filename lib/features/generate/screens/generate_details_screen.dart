// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/generate/widgets/card_checkbox_item.dart';
import 'package:payments_management/features/generate/widgets/message_empty.dart';
import 'package:payments_management/features/generate/widgets/modal_generate.dart';
import 'package:payments_management/models/generate_payment.dart';

class GenerateDetailsScreen extends StatefulWidget {
  static const String routeName = '/generate-payments-groups';
  // final String type;
  final String title;
  final List<GeneratePayment> payments;
  const GenerateDetailsScreen({
    Key? key,
    required this.title,
    // required this.type,
    required this.payments,
  }) : super(key: key);

  @override
  State<GenerateDetailsScreen> createState() => _GenerateDetailsScreenState();
}

class _GenerateDetailsScreenState extends State<GenerateDetailsScreen> {
  List<GeneratePayment> items = [];
  bool totalIsChecked = true;

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

  void checkedSelectAll() {
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

  void onChangeCheckboxEverything(value) {
    setState(() {
      totalIsChecked = value!;
      updateAllPayments(value);
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
            CardCheckboxItem(
                state: totalIsChecked,
                text: 'Seleccionar Todo',
                onChanged: (value) => onChangeCheckboxEverything(value)),
            widget.payments.isNotEmpty
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
                : const MessageEmpty(),
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
                      onTap: openGenerateModal,
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
