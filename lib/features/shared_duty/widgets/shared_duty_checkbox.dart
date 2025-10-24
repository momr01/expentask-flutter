import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/creditor/widgets/select_creditor_from_payment.dart';
import 'package:payments_management/models/creditor/creditor.dart';
import 'package:payments_management/models/shared_duty/payment_shared_duty.dart';

class SharedDutyCheckbox extends StatefulWidget {
  //final bool defaultValue;
  final PaymentSharedDuty sharedDuty;
  final bool isEdit;
  final String creditorName;
  final String creditorId;
  final Function(String, String) onValueChanged;
  const SharedDutyCheckbox(
      {super.key,
      required this.sharedDuty,
      this.isEdit = false,
      required this.creditorName,
      required this.creditorId,
      required this.onValueChanged});

  @override
  State<SharedDutyCheckbox> createState() => _SharedDutyCheckboxState();
}

class _SharedDutyCheckboxState extends State<SharedDutyCheckbox> {
  late bool isSharedDuty = false;
  // late String creditorName = "";
  // late String creditorId = "";

  @override
  void initState() {
    // creditorName =
    //     widget.sharedDuty.hasSharedDuty ? widget.sharedDuty.creditorName! : "";
    // creditorId =
    //     widget.sharedDuty.hasSharedDuty ? widget.sharedDuty.creditorId! : "";
    // widget.onValueChanged(
    //     widget.sharedDuty.hasSharedDuty ? widget.sharedDuty.creditorName! : "",
    //     widget.sharedDuty.hasSharedDuty ? widget.sharedDuty.creditorId! : "");
    isSharedDuty = widget.sharedDuty.hasSharedDuty ||
            widget.creditorName != "" ||
            widget.creditorId != ""
        ? true
        : false;
    super.initState();
  }

  Future<void> openCreditorsNamesModal() async {
    final result = await showDialog<Creditor>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SelectCreditorFromPayment();

          /*  return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: const Text(
                                            "Asignación de obligación compartida"),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    height: 400,
                                    child: false
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        :
                                        /*vm.registros.isEmpty
                  ? const Center(
                      child: Text("No existen datos para mostrar."),
                    )*/
                                        //:
                                        Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount: 10,
                                                  itemBuilder: (_, index) {
                                                    //final r = vm.registros[index];
                                                    return ListTile(
                                                      title: Text("hola"),
                                                      subtitle: Text(
                                                        "descr",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.edit),
                                                            onPressed:
                                                                () async {
                                                              final result =
                                                                  await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              Text("hola"));
                                                              /*  if (result == true)
                                                vm.cargarRegistros();*/
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red),
                                                            onPressed:
                                                                () async {
                                                              final confirm =
                                                                  await showDialog<
                                                                      bool>(
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      "Confirmar"),
                                                                  content:
                                                                      const Text(
                                                                          "¿Eliminar este registro?"),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            false),
                                                                        child: const Text(
                                                                            "Cancelar")),
                                                                    TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            true),
                                                                        child: const Text(
                                                                            "Eliminar")),
                                                                  ],
                                                                ),
                                                              );
                                                              /* if (confirm == true) {
                                                await vm.eliminarRegistro(index);
                                              }*/
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              /*Text(
                          "Resumen: ${formatter.format(vm.resumen)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),*/
                                              /* onlySee
                            ? const SizedBox()
                            : */
                                              /*  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () => vm.ajustarResumen("TOTAL"),
                                      child: const Text("TOTAL")),
                                  TextButton(
                                      onPressed: () => vm.ajustarResumen("MITAD"),
                                      child: const Text("MITAD")),
                                  TextButton(
                                      onPressed: () => vm.ajustarResumen("CERO"),
                                      child: const Text("CERO")),
                                ],
                              ),*/
                                            ],
                                          ),
                                  ),
                                  actions:
                                      //onlySee
                                      //  ?
                                      [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("CERRAR"),
                                    ),
                                  ]
                                  /*   : [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () => onAceptar!(vm.resumen, vm.registros),
                  child: const Text("Aceptar"),
                ),
                TextButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => RegistroDialog(paymentId: vm.paymentId),
                    );
                    if (result == true) vm.cargarRegistros();
                  },
                  child: const Icon(Icons.add),
                ),
              ],*/
                                  );*/
        });

    //debugPrint(result.toString());
    if (result != null) {
      // debugPrint('Nombres seleccionados: ${result.join(', ')}');
      debugPrint(result.name);
      // Realiza acciones con los nombres seleccionados
      setState(() {
        // for (var element in result) {
        //   finalNamesList.add(element);
        // }
        // creditorName = result.name;
        // creditorId = result.id!;
        widget.onValueChanged(result.name, result.id!);
      });

      //setState(() {});
    } else {
      setState(() {
        isSharedDuty = widget.sharedDuty.hasSharedDuty ||
                widget.creditorName != "" ||
                widget.creditorId != ""
            ? true
            : false;
      });

      debugPrint('No se seleccionó ningún nombre');
    }
    /*
    final result = await showDialog<List>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalSelectNames(
              selectedNames: finalNamesList,
            ));

    if (!context.mounted) return;
    setState(() {
      finalNamesList.clear();
    });

    //debugPrint(result.toString());
    if (result != null && result.isNotEmpty) {
      // debugPrint('Nombres seleccionados: ${result.join(', ')}');
      debugPrint(result.length.toString());
      // Realiza acciones con los nombres seleccionados
      setState(() {
        for (var element in result) {
          finalNamesList.add(element);
        }
      });

      //setState(() {});
    } else {
      debugPrint('No se seleccionó ningún nombre');
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "¿Es obligación compartida?",
                style: TextStyle(
                  color: GlobalVariables.primaryColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.isEdit ? 20 : 14,
                ),
              ),
              isSharedDuty
                  ? widget.creditorName == ""
                      ? const SizedBox()
                      : Row(
                          children: [
                            const Icon(Icons.arrow_right_rounded),
                            Text(
                              // widget.sharedDuty.creditorName!,
                              widget.creditorName,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black87),
                            )
                          ],
                        )
                  : const SizedBox()
            ],
          ),
          Checkbox(
            value: isSharedDuty,
            // onChanged: (value) {
            /*setState(() {
                    isSharedDuty = value!;
                  });*/
            //  },
            onChanged: widget.isEdit
                ? (value) {
                    setState(() {
                      isSharedDuty = value!;

                      if (value) {
                        openCreditorsNamesModal();
                      } else {
                        // creditorName = "";
                        // creditorId = "";

                        widget.onValueChanged("", "");
                      }
                    });
                  }
                : null,

            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔑
            visualDensity:
                VisualDensity.compact, // opcional, achica padding interno
          )
        ],
      ),
    );
  }
}
