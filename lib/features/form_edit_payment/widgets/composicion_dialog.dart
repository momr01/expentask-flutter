import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payments_management/features/form_edit_payment/services/amount_services.dart';
import 'package:payments_management/models/amount/amount.dart';
import 'package:provider/provider.dart';

/*Future<void> eliminarRegistroDesdeAPI(String id) async {
  await Future.delayed(Duration(seconds: 1));
  print('Registro con id $id eliminado');
}*/

/*
class ComposicionDialog extends StatefulWidget {
  final String paymentId;
  final void Function(double nuevoImporte, List<Amount> nuevosRegistros)
      onAceptar;

  const ComposicionDialog(
      {Key? key, required this.onAceptar, required this.paymentId})
      : super(key: key);

  @override
  State<ComposicionDialog> createState() => _ComposicionDialogState();
}

class _ComposicionDialogState extends State<ComposicionDialog> {
  List<Amount> _registros = [];
  double _resumen = 0.0;
  bool _cargando = true;

  final AmountServices amountServices = AmountServices();

  @override
  void initState() {
    super.initState();
    _cargarRegistros();
  }

  Future<void> _cargarRegistros() async {
    setState(() => _cargando = true);
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
  }

  void _eliminarRegistro(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content:
            const Text("¿Estás seguro de que quieres eliminar este registro?"),
        actions: [
          TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(
              child: const Text("Eliminar"),
              onPressed: () => Navigator.pop(ctx, true)),
        ],
      ),
    );

    if (confirmar == true) {
      try {
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
          const Text("Composición del importe"),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
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
                            formatter.format(r.amount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarRegistro(index)),
                              IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
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
                  Text(
                    "Resumen:  ${formatter.format(_resumen)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => _ajustarResumen("TOTAL"),
                          child: const Text("TOTAL")),
                      TextButton(
                          onPressed: () => _ajustarResumen("MITAD"),
                          child: const Text("MITAD")),
                      TextButton(
                          onPressed: () => _ajustarResumen("CERO"),
                          child: const Text("CERO")),
                    ],
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => widget.onAceptar(_resumen, _registros),
          child: const Text("Aceptar"),
        ),
        TextButton(
          onPressed: _agregarRegistro,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
*/

class ComposicionViewModel extends ChangeNotifier {
  final String paymentId;
  final AmountServices _amountServices = AmountServices();

  List<Amount> registros = [];
  double resumen = 0.0;
  bool cargando = true;

  ComposicionViewModel({required this.paymentId}) {
    cargarRegistros();
  }

  Future<void> cargarRegistros() async {
    cargando = true;
    notifyListeners();

    registros = await _amountServices.fetchPaymentAmounts(paymentId: paymentId);
    _actualizarResumen();

    cargando = false;
    notifyListeners();
  }

  void _actualizarResumen() {
    resumen = registros.fold(0.0, (suma, r) => suma + r.amount);
  }

  void ajustarResumen(String tipo) {
    if (tipo == "TOTAL") {
      _actualizarResumen();
    } else if (tipo == "MITAD") {
      resumen = resumen / 2;
    } else if (tipo == "CERO") {
      resumen = 0.0;
    }
    notifyListeners();
  }

  Future<void> eliminarRegistro(int index) async {
    await _amountServices.disableAmount(amountId: registros[index].id!);
    await cargarRegistros();
  }
}

class ComposicionProvider extends StatelessWidget {
  final String paymentId;
  final void Function(double resumen, List<Amount> registros) onAceptar;

  const ComposicionProvider({
    super.key,
    required this.paymentId,
    required this.onAceptar,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComposicionViewModel(paymentId: paymentId),
      child: ComposicionDialog(onAceptar: onAceptar),
    );
  }
}

class ComposicionDialog extends StatelessWidget {
  final void Function(double resumen, List<Amount> registros) onAceptar;

  const ComposicionDialog({super.key, required this.onAceptar});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ComposicionViewModel>();
    final formatter = NumberFormat.currency(locale: 'es_AR', symbol: r'$');

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Composición del importe"),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: vm.cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.registros.length,
                      itemBuilder: (_, index) {
                        final r = vm.registros[index];
                        return ListTile(
                          title: Text(
                              "${DateFormat('dd/MM/yyyy').format(r.date)} - ${r.description}"),
                          subtitle: Text(
                            formatter.format(r.amount),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (_) => RegistroDialog(
                                      registro: r,
                                      paymentId: vm.paymentId,
                                    ),
                                  );
                                  if (result == true) vm.cargarRegistros();
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Confirmar"),
                                      content: const Text(
                                          "¿Eliminar este registro?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancelar")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Eliminar")),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await vm.eliminarRegistro(index);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Resumen: ${formatter.format(vm.resumen)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
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
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => onAceptar(vm.resumen, vm.registros),
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
      ],
    );
  }
}

class RegistroDialog extends StatefulWidget {
  final String paymentId;
  final Amount? registro;

  const RegistroDialog({Key? key, this.registro, required this.paymentId})
      : super(key: key);

  @override
  State<RegistroDialog> createState() => _RegistroDialogState();
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
    await amountServices.addPaymentAmount(
        date: date,
        description: description,
        amount: amount,
        paymentId: paymentId);
  }

  editAmountDetail(String date, String description, double amount,
      String paymentId, String amountId) async {
    await amountServices.editAmount(
        id: amountId,
        date: date,
        description: description,
        amount: amount,
        paymentId: paymentId);
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

      if (widget.registro != null) {
        await editAmountDetail(_fecha.toString(), descripcion, importe,
            widget.paymentId, widget.registro!.id!);
      } else {
        await createAmountDetail(
            _fecha.toString(), descripcion, importe, widget.paymentId);
      }
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
                decoration: const InputDecoration(labelText: "Descripción"),
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
                decoration: const InputDecoration(labelText: "Importe"),
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
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: _aceptar,
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
