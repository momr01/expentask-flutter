// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/services/amount_services.dart';
import 'package:payments_management/features/notes/screens/notes_screen.dart';
import 'package:payments_management/features/payment_details/widgets/notes_row.dart';
import 'package:payments_management/models/amount/amount.dart';
import 'package:payments_management/models/payment/payment.dart';

class HeaderPayment extends StatefulWidget {
  final Payment payment;
  const HeaderPayment({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  State<HeaderPayment> createState() => _HeaderPaymentState();
}

class _HeaderPaymentState extends State<HeaderPayment> {
  String countCompletedTasks(List tasks) {
    List activeTasks = [];

    for (var task in tasks) {
      if (task.isActive) activeTasks.add(task);
    }
    int total = activeTasks.length;
    int completed = 0;

    for (var task in tasks) {
      if (task.isActive && task.isCompleted) completed++;
    }

    return '$completed/$total';
  }

  void openAmountsModal() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AmountsDialog(
              paymentId: widget.payment.id!,
            ) /*ComposicionDialog(
        // registros: _registros,
        paymentId: widget.paymentId,
        onAceptar: (nuevoImporte, nuevosRegistros) {
          setState(() {
            _importe = nuevoImporte;
            _registros = nuevosRegistros;
            // _controller.text = _importe.toString();
            widget.controller.text = _importe.toString();
          });
          Navigator.pop(context);
        },
      ),*/
        );
  }

  void openNotesModal() async {
    showDialog(
        context: context,
        builder: (_) => NotesScreen(
              isModal: true,
              //paymentId: widget.payment.id!,
              payment: widget.payment,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(
              widget.payment.name.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(countCompletedTasks(widget.payment.tasks),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 5),
        Row(children: [
          const Text("Vto", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Text(datetimeToString(widget.payment.deadline),
              style: const TextStyle(fontWeight: FontWeight.bold))
        ]),
        const SizedBox(height: 5),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              const Text("Importe",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text('\$ ${formatMoney(widget.payment.amount)}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          GestureDetector(
              onTap: () => openAmountsModal(), child: const Icon(Icons.comment))
        ]),
        const SizedBox(height: 5),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text("Notas asociadas:"),
                SizedBox(
                  width: 10,
                ),
                Text("0"),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => openNotesModal(),
                  child: const Icon(Icons.notes),
                )
              ],
            )
          ],
        )*/
        NotesRow(
          // id: widget.payment.id,
          payment: widget.payment,
        )
      ],
    );
  }
}

class AmountsDialog extends StatefulWidget {
  final String paymentId;
  const AmountsDialog({super.key, required this.paymentId});

  @override
  State<AmountsDialog> createState() => _AmountsDialogState();
}

class _AmountsDialogState extends State<AmountsDialog> {
  // late List<Amount> _registros;
  List<Amount> _registros = [];
  double _resumen = 0.0;
  bool _cargando = true;

  final AmountServices amountServices = AmountServices();

  @override
  void initState() {
    super.initState();
    //_registros = List.from(widget.registros);
    // _actualizarResumen();
    _cargarRegistros();
  }

  Future<void> _cargarRegistros() async {
    setState(() => _cargando = true);
    // final data = await obtenerRegistrosDesdeAPI();
    final data =
        await amountServices.fetchPaymentAmounts(paymentId: widget.paymentId);
    setState(() {
      _registros = data;
      _actualizarResumen();
      _cargando = false;
    });
  }

  void _actualizarResumen() {
    _resumen = _registros.fold(0.0, (suma, r) => suma + r.amount);
  }

  void _editarRegistro(int index) async {
    /*final result = await showDialog(
      context: context,
      builder: (_) => RegistroDialog(
        registro: _registros[index],
        paymentId: widget.paymentId,
      ),
    );*/

    // if (result == true) {
    await _cargarRegistros();
    // }
  }

  void _agregarRegistro() async {
    /* final result = await showDialog(
      context: context,
      builder: (_) => RegistroDialog(
        paymentId: widget.paymentId,
      ),
    );*/

    // if (result == true) {
    await _cargarRegistros();
    //}
    /*if (result != null) {
      setState(() {
        _registros.add(result);
        _actualizarResumen();
      });
    }*/
    // debugPrint(result.toString());
    /* if (result != null) {
      // debugPrint("entro aca");
      await _cargarRegistros();
      setState(() {
        _cargarRegistros();
      });
    }*/
  }

  /*void _eliminarRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
      _actualizarResumen();
    });
  }*/
  void _eliminarRegistro(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que quieres eliminar este registro?"),
        actions: [
          TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(
              child: Text("Eliminar"),
              onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirmar == true) {
      /* showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );*/
      try {
        /* await eliminarRegistroDesdeAPI(_registros[index].id!);
        setState(() {
          _registros.removeAt(index);
          _actualizarResumen();
        });*/
        await amountServices.disableAmount(amountId: _registros[index].id!);
        await _cargarRegistros();
      } finally {
        // Navigator.pop(context);
      }
    }
  }

  void _ajustarResumen(String tipo) {
    setState(() {
      if (tipo == "TOTAL") {
        _actualizarResumen();
      } else if (tipo == "MITAD") {
        _resumen = _resumen / 2;
      } else if (tipo == "CERO") {
        _resumen = 0.0;
      }
    });
  }

  // Crear un formateador con configuración local argentina
  /*final formatter = NumberFormat.currency(
    locale: 'es_AR',
    symbol: '\$',
    decimalDigits: 2,
  );

  final formatter = NumberFormat.currency(
    locale: 'es_AR',
    symbol: r'$',
    decimalDigits: 2,
    customPattern: "\u00A4#,##0.00", // Fuerza el símbolo adelante
  );*/
  final formatter = NumberFormat.currency(
    locale: 'es_AR',
    symbol: r'$',
    decimalDigits: 2,
    customPattern: "¤ #,##0.00", // ¤ (símbolo) seguido de espacio
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Composición del importe"),
          /*  IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )*/
        ],
      ),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: _cargando
            ? Center(child: CircularProgressIndicator())
            : _registros.isEmpty
                ? Center(
                    child: Text("No existen datos para mostrar."),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _registros.length,
                          itemBuilder: (_, index) {
                            final r = _registros[index];
                            return ListTile(
                              title: Text(
                                  "${DateFormat('dd/MM/yyyy').format(r.date)}"),
                              subtitle: Text(
                                "${r.description}",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                "${formatter.format(r.amount)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text("Resumen: ${_resumen.toStringAsFixed(2)}"),
                      Text(
                        "Resumen:  ${formatter.format(_resumen)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      /* const SizedBox(
                        height: 20,
                      ),*/
                    ],
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("CERRAR"),
        ),
      ],
    );
  }
}
