// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/form_edit_payment/widgets/composicion_dialog.dart';
import 'package:payments_management/features/historical/widgets/state_payment_card.dart';
import 'package:payments_management/features/payment_details/widgets/header_payment.dart';
import 'package:payments_management/models/payment/payment.dart';

class DetailsHeader extends StatefulWidget {
  final Payment payment;
  const DetailsHeader({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  State<DetailsHeader> createState() => _DetailsHeaderState();
}

class _DetailsHeaderState extends State<DetailsHeader> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Map> data = [
      {
        'label': 'ESTADO',
        'info': StatePaymentCard(
            isActive: widget.payment.isActive,
            isCompleted: widget.payment.isCompleted)
      },
      {'label': 'PERÍODO', 'info': widget.payment.period},
      {
        'label': "CATEGORÍA",
        'info': widget.payment.name.category.name.toUpperCase()
      },
      {
        'label': "FECHA DE VTO",
        'info': datetimeToStringWithDash(widget.payment.deadline)
      },
      {'label': "IMPORTE", 'info': '\$ ${formatMoney(widget.payment.amount)}'},
      {
        'label': "USUARIO",
        'info': capitalizeFirstLetter(widget.payment.user!.name)
      }
    ];

    void openAmountsModal() async {
      await showDialog(
          context: context,
          barrierDismissible: false,
          /* builder: (_) => AmountsDialog(
                paymentId: widget.payment.id!,
              )*/
          builder: (_) => ComposicionProvider(
                paymentId: widget.payment.id!,
                /*onAceptar: (nuevoImporte, nuevosRegistros) {
              setState(() {
                // _importe = nuevoImporte;
                // _registros = nuevosRegistros;
                // _controller.text = _importe.toString();
                // widget.controller.text = _importe.toString();
              });
              Navigator.pop(context);
            }*/
                // onAceptar: null,
                onlySee: true,
              )

          /*ComposicionDialog(
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

    return ListView.separated(
        itemCount: data.length,
        separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
        itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (width / 2) - 5,
                  child: Row(
                    children: [
                      Text(
                        "${data[index]['label']}=",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      data[index]['label'] == "IMPORTE"
                          ? GestureDetector(
                              onTap: openAmountsModal,
                              child: const Icon(Icons.info))
                          : const SizedBox()
                    ],
                  ),
                ),
                data[index]['info'].runtimeType == String
                    ? Flexible(
                        child: SizedBox(
                          width: (width / 2) - 5,
                          child: Text(
                            data[index]['info'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )
                    : data[index]['info'],
              ],
            ));
  }
}
