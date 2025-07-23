// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
  // final double importe;
  final TextEditingController controller;
  final String paymentId;
  const AmountPaymentSection(
      {Key? key, required this.controller, required this.paymentId
      // required this.importe
      })
      : super(key: key);

  @override
  State<AmountPaymentSection> createState() => _AmountPaymentSectionState();
}

class _AmountPaymentSectionState extends State<AmountPaymentSection> {
  double _importe = 0.0;
  List<Amount> _registros = [];
  final AmountServices amountServices = AmountServices();
  // void openAddMoneyParts() async {
  //   showDialog<String>(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => ModalAddMoneyParts());
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchAmounts();
  }

  /* fetchAmounts() async {
    setState(() {
      // _isLoading = true;
    });
    /* List<Payment> beforeFilter =
        await historicalServices.fetchAllPayments(context: context);

    payments = customFilter(beforeFilter);*/

    _registros =
        await amountServices.fetchPaymentAmounts(paymentId: widget.paymentId);
    setState(() {
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
    });
  }*/

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
            _registros = nuevosRegistros;
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
        // const Text(
        //   'Importe:',
        //   style: TextStyle(fontSize: 18),
        // ),
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
