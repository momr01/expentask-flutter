import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:payments_management/common/widgets/buttons/custom_button_options.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/form_edit_payment/services/amount_services.dart';
import 'package:payments_management/features/form_edit_payment/widgets/amount_payment_section.dart';
import 'package:payments_management/models/amount/amount.dart';

Future<void> eliminarRegistroDesdeAPI(String id) async {
  await Future.delayed(Duration(seconds: 1));
  print('Registro con id $id eliminado');
}

class ComposicionDialog extends StatefulWidget {
  final String paymentId;
  // final List<Amount> registros;
  final void Function(double nuevoImporte, List<Amount> nuevosRegistros)
      onAceptar;

  const ComposicionDialog(
      {
      //required this.registros,
      required this.onAceptar,
      required this.paymentId});

  @override
  _ComposicionDialogState createState() => _ComposicionDialogState();
}

class _ComposicionDialogState extends State<ComposicionDialog> {
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
    final result = await showDialog(
      context: context,
      builder: (_) => RegistroDialog(
        registro: _registros[index],
        paymentId: widget.paymentId,
      ),
    );

    if (result == true) {
      await _cargarRegistros();
    }
  }

  void _agregarRegistro() async {
    final result = await showDialog(
      context: context,
      builder: (_) => RegistroDialog(
        paymentId: widget.paymentId,
      ),
    );

    if (result == true) {
      await _cargarRegistros();
    }
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );
      try {
        await eliminarRegistroDesdeAPI(_registros[index].id!);
        setState(() {
          _registros.removeAt(index);
          _actualizarResumen();
        });
      } finally {
        Navigator.pop(context);
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Composición del importe"),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: _cargando
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _registros.length,
                      itemBuilder: (_, index) {
                        final r = _registros[index];
                        return ListTile(
                          title: Text(
                              "${DateFormat('dd/MM/yyyy').format(r.date)} - ${r.description}"),
                          subtitle: Text(
                            "${formatter.format(r.amount)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editarRegistro(index)),
                              IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _eliminarRegistro(index)),
                            ],
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

                  //Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children: [
                  // Text("Resumen: ${_resumen.toStringAsFixed(2)}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => _ajustarResumen("TOTAL"),
                          child: Text("TOTAL")),
                      TextButton(
                          onPressed: () => _ajustarResumen("MITAD"),
                          child: Text("MITAD")),
                      TextButton(
                          onPressed: () => _ajustarResumen("CERO"),
                          child: Text("CERO")),
                    ],
                  ),
                  // ],
                  //)
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => widget.onAceptar(_resumen, _registros),
          child: Text("Aceptar"),
        ),
        TextButton(
          onPressed: _agregarRegistro,
          //    child: Text("Agregar"),
          // child: Text(),
          child: Icon(Icons.add),
        ),
      ],
    );

    /* return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Composición del importe"),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _registros.length,
                itemBuilder: (_, index) {
                  final r = _registros[index];
                  return ListTile(
                    title: Text(
                        // "${DateFormat.yMd().format(r.date)} - ${r.description}"),
                        "${DateFormat('dd/MM/yyyy').format(r.date)} - ${r.description}"),
                    //  subtitle: Text("${r.amount.toStringAsFixed(2)}"),
                    subtitle: Text("${formatter.format(r.amount)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editarRegistro(index)),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _eliminarRegistro(index)),
                      ],
                    ),
                  );
                },
              ),
            ),
            //  Text("Resumen: ${_resumen.toStringAsFixed(2)}"),
            Text("Resumen: ${formatter.format(_resumen)}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Text("Resumen: ${_resumen.toStringAsFixed(2)}"),
                // Row(
                //   children: [
                TextButton(
                    onPressed: () => _ajustarResumen("TOTAL"),
                    child: Text("TOTAL")),
                TextButton(
                    onPressed: () => _ajustarResumen("MITAD"),
                    child: Text("MITAD")),
                TextButton(
                    onPressed: () => _ajustarResumen("CERO"),
                    child: Text("CERO")),
                //],
                // ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => widget.onAceptar(_resumen, _registros),
          child: Text("Aceptar"),
        ),
        TextButton(
          onPressed: _agregarRegistro,
          child: Text("Agregar"),
        ),
      ],
    );*/
  }
}

class RegistroDialog extends StatefulWidget {
  final String paymentId;
  final Amount? registro;

  const RegistroDialog({this.registro, required this.paymentId});

  @override
  _RegistroDialogState createState() => _RegistroDialogState();
}

class _RegistroDialogState extends State<RegistroDialog> {
  final _descripcionController = TextEditingController();
  final _importeController = TextEditingController();
  DateTime _fecha = DateTime.now();
  final AmountServices amountServices = AmountServices();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.registro != null) {
      _fecha = widget.registro!.date;
      _descripcionController.text = widget.registro!.description;
      _importeController.text = widget.registro!.amount.toString();
    }
  }

  createAmountDetail(
      String date, String description, double amount, String paymentId) async {
    /* setState(() {
      // _isLoading = true;
    });*/
    /* List<Payment> beforeFilter =
        await historicalServices.fetchAllPayments(context: context);

    payments = customFilter(beforeFilter);*/

    await amountServices.addPaymentAmount(
        date: date,
        description: description,
        amount: amount,
        paymentId: paymentId);
/*    setState(() {
      //amountServices.fetchPaymentAmounts(paymentId: paymentId);
//      _foundPayments = payments!;

      // _foundPayments.sort((a, b) {
      // Extraer año y mes de cada período
      // final yearA = int.parse(a.period.split('-')[1]);
      // final monthA = int.parse(a.period.split('-')[0]);
      // final yearB = int.parse(b.period.split('-')[1]);
      // final monthB = int.parse(b.period.split('-')[0]);

      // // Ordenar primero por año y luego por mes
      // if (yearA == yearB) {
      //   return monthA.compareTo(monthB);
      // }
      // return yearA.compareTo(yearB);

      //  });
      // _isLoading = false;
    });*/
  }

  editAmountDetail(String date, String description, double amount,
      String paymentId, String amountId) async {
    /* setState(() {
      // _isLoading = true;
    });*/
    /* List<Payment> beforeFilter =
        await historicalServices.fetchAllPayments(context: context);

    payments = customFilter(beforeFilter);*/

    await amountServices.editAmount(
        id: amountId,
        date: date,
        description: description,
        amount: amount,
        paymentId: paymentId);
/*    setState(() {
      //amountServices.fetchPaymentAmounts(paymentId: paymentId);
//      _foundPayments = payments!;

      // _foundPayments.sort((a, b) {
      // Extraer año y mes de cada período
      // final yearA = int.parse(a.period.split('-')[1]);
      // final monthA = int.parse(a.period.split('-')[0]);
      // final yearB = int.parse(b.period.split('-')[1]);
      // final monthB = int.parse(b.period.split('-')[0]);

      // // Ordenar primero por año y luego por mes
      // if (yearA == yearB) {
      //   return monthA.compareTo(monthB);
      // }
      // return yearA.compareTo(yearB);

      //  });
      // _isLoading = false;
    });*/
  }

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  void _aceptar() async {
    if (_formKey.currentState!.validate()) {
      final descripcion = _descripcionController.text;
      final importe = double.tryParse(_importeController.text) ?? 0.0;

      /*Navigator.pop(
      context,
      Registro(
        fecha: _fecha,
        descripcion: descripcion,
        importe: importe,
      ),
    );*/

      if (widget.registro != null) {
        await editAmountDetail(_fecha.toString(), descripcion, importe,
            widget.paymentId, widget.registro!.id!);
      } else {
        await createAmountDetail(
            _fecha.toString(), descripcion, importe, widget.paymentId);
      }

      // Navigator.pop(NavigatorKeys.navKey.currentContext!);

      /* Navigator.pop(context, "OK"
          /* Registro(
        // id: widget.registro?.id ?? DateTime.now().millisecondsSinceEpoch,
        fecha: _fecha,
        descripcion: descripcion,
        importe: importe,
      ),*/
          );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.registro != null ? "Editar Registro" : "Nuevo Registro"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextButton(
                  onPressed: _seleccionarFecha,
                  // child: Text("Fecha: ${DateFormat.yMd().format(_fecha)}"),
                  child: Text(
                      "Fecha: ${DateFormat('dd/MM/yyyy').format(_fecha)}")),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: "Descripción"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La descripción es obligatoria";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _importeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Importe"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "El importe es obligatorio";
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return "Debe ser un número válido";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        ),
        TextButton(
          onPressed: _aceptar,
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}
