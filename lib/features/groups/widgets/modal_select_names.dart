import 'package:flutter/material.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/groups/screens/manage_group_screen.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/features/names/services/names_services.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/group/group_name_checkbox.dart';
import 'package:payments_management/models/name/payment_name.dart';

class ModalSelectNames extends StatefulWidget {
  final List<GroupNameCheckbox> selectedNames;
  const ModalSelectNames({super.key, required this.selectedNames});

  @override
  State<ModalSelectNames> createState() => _ModalSelectNamesState();
}

class _ModalSelectNamesState extends State<ModalSelectNames> {
  List<PaymentName>? names;
  List<GroupNameCheckbox> namesList = [];
  final NamesServices namesServices = NamesServices();
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPaymentNames();
  }

  fetchPaymentNames() async {
    // setState(() {
    //   _isLoading = true;
    // });
    names = await namesServices.fetchPaymentNames();
    if (names != null && names != []) {
      for (var name in names!) {
        namesList
            .add(GroupNameCheckbox(id: name.id, name: name.name, state: false));
      }
    }

    if (widget.selectedNames.isNotEmpty) {
      for (var name in widget.selectedNames) {
        // GroupNameCheckbox foundItem =
        //     namesList.where((element) => element.id == name.id).first;

        // debugPrint(foundItem.name.toString());
        namesList.where((element) => element.id == name.id).first.state = true;
      }
    }

    setState(() {});

    // setState(() {
    //   // _foundNames = names!;
    //   _isLoading = false;
    // });
  }

  void openModalConfirmation() async {
    // showDialog<String>(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) => ModalConfirmation(
    //           onTap: completeTask,
    //           confirmText: 'editar',
    //           confirmColor: GlobalVariables.completeButtonColor!,
    //           middleText: 'marcar como completa',
    //           endText: 'la tarea seleccionada',
    //         ));
  }

  void applyNamesSelection() {
    List<GroupNameCheckbox> selectedNames = [];
    if (namesList != []) {
      for (var name in namesList) {
        if (name.state!) {
          debugPrint(name.name);
          selectedNames.add(name);
        }
      }
    }

    //fromSelectionToForm(context, namesList);

    Navigator.pop(context, selectedNames); // Devuelve 'Nombre 1'
  }

  void fromSelectionToForm(context, List<GroupNameCheckbox> finalSelection) {
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, ManageGroupScreen.routeName, arguments: [
      Group(name: "", dataEntry: "", isActive: false, paymentNames: []),
      finalSelection
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: EdgeInsets.zero,
      icon: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
            onTap: applyNamesSelection,
            child: const Text(
              'Aplicar',
              style: TextStyle(fontSize: 18),
            )),
        InkWell(
            onTap: () => closeModalSelectNames(context),
            child: Icon(Icons.close_sharp,
                color: Theme.of(context).colorScheme.primary))
      ]),
      iconPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: names != null
              ? ListView.builder(
                  itemCount: namesList.length,
                  itemBuilder: (_, i) {
                    return Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide())),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                capitalizeFirstLetter(namesList[i].name!),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            // Text(
                            //   //'Seguro Tres Provincias',
                            //   names![i].name,
                            //   style: const TextStyle(fontSize: 16),
                            // ),
                            Checkbox(
                              value: namesList[i].state,
                              // onChanged: (value) {},
                              onChanged: (bool? value) {
                                setState(() {
                                  namesList[i].state = value!;
                                });
                              },
                            )
                          ],

                          //.toList()
                        ),
                      ),
                    );
                  },
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No existen nombres para mostrar.",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                )
          //  Container(
          //     decoration:
          //         const BoxDecoration(border: Border(bottom: BorderSide())),
          //     child: Padding(
          //         padding:
          //             const EdgeInsets.only(left: 10, top: 10, bottom: 10),
          //         child: Text("nada")),
          //   ),
          ),
    );
  }
}
