import 'package:flutter/material.dart';
import 'package:payments_management/features/creditor/services/creditor_services.dart';
import 'package:payments_management/models/creditor/creditor.dart';

class SelectCreditorFromPayment extends StatefulWidget {
  const SelectCreditorFromPayment({super.key});

  @override
  State<SelectCreditorFromPayment> createState() =>
      _SelectCreditorFromPaymentState();
}

class _SelectCreditorFromPaymentState extends State<SelectCreditorFromPayment> {
  final CreditorServices creditorServices = CreditorServices();
  List<Creditor>? creditors;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCreditors();
  }

  fetchCreditors() async {
    setState(() {
      _isLoading = true;
    });
    creditors = await creditorServices.fetchActiveCreditors();
    /*if (names != null && names != []) {
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
    }*/

//    setState(() {});

    setState(() {
      // _foundNames = names!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Asignación de obligación compartida"),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(
        //       child: const Text("Asignación de obligación compartida"),
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.close),
        //       onPressed: () => Navigator.pop(context),
        //     ),
        //   ],
        // ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              :
              /*vm.registros.isEmpty
                  ? const Center(
                      child: Text("No existen datos para mostrar."),
                    )*/
              //:
              Column(
                  children: [
                    Expanded(
                      child: creditors != null
                          ? ListView.separated(
                              itemCount: creditors!.length,
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 20,
                              ),
                              itemBuilder: (_, index) {
                                //final r = vm.registros[index];
                                return GestureDetector(
                                  onTap: () {
                                    debugPrint(creditors![index].id!);
                                    //    Navigator.pop(context);

                                    Navigator.pop(
                                        context,
                                        creditors![
                                            index]); // Devuelve 'Nombre 1'
                                  },
                                  child: ListTile(
                                    title: Text(creditors![index].name),
                                    // subtitle: Text(
                                    //   "descr",
                                    //   style: const TextStyle(
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    /*trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            final result = await showDialog(
                                                context: context,
                                                builder: (_) => Text("hola"));
                                            /*  if (result == true)
                                                  vm.cargarRegistros();*/
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text("Confirmar"),
                                                content: const Text(
                                                    "¿Eliminar este registro?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child:
                                                          const Text("Cancelar")),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child:
                                                          const Text("Eliminar")),
                                                ],
                                              ),
                                            );
                                            /* if (confirm == true) {
                                                  await vm.eliminarRegistro(index);
                                                }*/
                                          },
                                        ),
                                      ],
                                    ),*/
                                  ),
                                );
                              },
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No existen acreedores para mostrar.",
                                  style: TextStyle(fontSize: 20),
                                )
                              ],
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
        );
  }
}
