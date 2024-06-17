import 'package:flutter/material.dart';
import 'package:payments_management/features/groups/utils/navigation_groups.dart';
import 'package:payments_management/models/name/payment_name.dart';

class ModalSelectNames extends StatefulWidget {
  const ModalSelectNames({super.key});

  @override
  State<ModalSelectNames> createState() => _ModalSelectNamesState();
}

class _ModalSelectNamesState extends State<ModalSelectNames> {
  List<PaymentName>? names;

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

  void applyNamesSelection() {}

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
        child: ListView.builder(
          itemCount: 50,
          itemBuilder: (_, i) {
            return Container(
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Seguro Tres Provincias',
                      style: TextStyle(fontSize: 16),
                    ),
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
