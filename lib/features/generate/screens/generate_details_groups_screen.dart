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

class GenerateDetailsGroupsScreen extends StatefulWidget {
  static const String routeName = '/generate-payments-groups';
  // final String type;
  final String title;
  final List<GeneratePayment> payments;
  const GenerateDetailsGroupsScreen({
    Key? key,
    required this.title,
    // required this.type,
    required this.payments,
  }) : super(key: key);

  @override
  State<GenerateDetailsGroupsScreen> createState() =>
      _GenerateDetailsScreenState();
}

class _GenerateDetailsScreenState extends State<GenerateDetailsGroupsScreen> {
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
    /*  for (var group in widget.payments) {
      if (group.namesList!.isNotEmpty) {
        for (var element in group.namesList!) {
          debugPrint(element.name);
        }
      }
    }*/
    filteredPayments = widget.payments;
  }

/*  void checkedSelectAll() {
    int checkedNames = 0;
    for (var payment in widget.payments) {
      if (payment.state) checkedNames++;
    }

    if (checkedNames == widget.payments.length) {
      totalIsChecked = true;
    } else {
      totalIsChecked = false;
    }
  }*/
  void checkedSelectAll() {
    int checkedNames = filteredPayments.where((p) => p.state).length;
    totalIsChecked =
        checkedNames == filteredPayments.length && filteredPayments.isNotEmpty;
  }

/*
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
  void updateAllPayments(bool val) {
    for (var payment in filteredPayments) {
      payment.state = val;
      // Actualizamos también en la lista original
      final original = widget.payments.firstWhere((p) => p.id == payment.id);
      original.state = val;
    }
  }

  List<GeneratePayment> generateGroupContent(List<GeneratePayment> list) {
    List<GeneratePayment> finalList = [];

    for (var element in list) {
      if (element.state) {
        for (var payment in element.namesList!) {
          finalList.add(GeneratePayment(
              id: payment.id!, name: payment.name, state: true));
        }
      }
    }

    return finalList;
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
              totalSelected:
                  //widget.payments
                  filteredPayments
                      .where((payment) => payment.state == true)
                      .length,
              // payments: widget.payments
              // payments: generateGroupContent(widget.payments),
              payments: generateGroupContent(filteredPayments),
              type: "group",
              //  payments: widget.payments
              //       .where((payment) => payment.state == true),
            ));
  }

  void onChangeCheckboxEverything(value) {
    setState(() {
      totalIsChecked = value!;
      updateAllPayments(value);
      checkedSelectAll();
    });
  }

  void filterPayments(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredPayments = List.from(widget.payments);
      } else {
        filteredPayments = widget.payments
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }

      // Solo marca “Seleccionar todo” si TODOS los visibles están marcados
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
                          onChangeCheckboxEverything(true);
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
            /* widget.payments.isNotEmpty
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
            filteredPayments.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredPayments.length,
                      itemBuilder: (context, index) {
                        final payment = filteredPayments[index];
                        return CardCheckboxItem(
                            state: payment.state,
                            text: payment.name,
                            /*onChanged: (value) {
                            setState(() {
                              payment.state = value!;
                              checkedSelectAll();
                            });
                          },*/
                            onChanged: (value) {
                              setState(() {
                                payment.state = value!;
                                // Actualizamos también en la lista original
                                final original = widget.payments
                                    .firstWhere((p) => p.id == payment.id);
                                original.state = value;
                                checkedSelectAll();
                              });
                            });
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(child: Text('¡No existen resultados!')),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30)
                  .copyWith(top: 40),
              child:
                  //widget.payments
                  filteredPayments
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
