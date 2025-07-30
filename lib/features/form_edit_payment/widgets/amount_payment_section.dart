// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_textfield.dart';
import 'package:payments_management/features/form_edit_payment/services/amount_services.dart';
import 'package:payments_management/features/form_edit_payment/widgets/composicion_dialog.dart';
import 'package:payments_management/models/amount/amount.dart';

class Registro {
  DateTime fecha;
  String descripcion;
  double importe;

  Registro(
      {required this.fecha, required this.descripcion, required this.importe});
}

class AmountPaymentSection extends StatefulWidget {
  final TextEditingController controller;
  final String paymentId;
  const AmountPaymentSection(
      {Key? key, required this.controller, required this.paymentId})
      : super(key: key);

  @override
  State<AmountPaymentSection> createState() => _AmountPaymentSectionState();
}

class _AmountPaymentSectionState extends State<AmountPaymentSection> {
  double _importe = 0.0;
  // List<Amount> _registros = [];
  final AmountServices amountServices = AmountServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void openAddMoneyParts() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ComposicionDialog(
        // registros: _registros,
        paymentId: widget.paymentId,
        onAceptar: (nuevoImporte, nuevosRegistros) {
          setState(() {
            _importe = nuevoImporte;
            // _registros = nuevosRegistros;
            // _controller.text = _importe.toString();
            widget.controller.text = _importe.toString();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Importe:',
              style: TextStyle(fontSize: 18),
            ),
            GestureDetector(
                onTap: openAddMoneyParts, child: const Icon(Icons.add_comment))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextField(
          controller: widget.controller,
          hintText: 'Ingrese el importe',
          modal: true,
          isAmount: true,
          suffixIcon: const Icon(
            Icons.attach_money,
            size: 30,
          ),
        ),
      ],
    );
  }
}
