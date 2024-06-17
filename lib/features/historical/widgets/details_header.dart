// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/constants/date_format.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/historical/widgets/state_payment_card.dart';
import 'package:payments_management/models/payment/payment.dart';

class DetailsHeader extends StatelessWidget {
  final Payment payment;
  const DetailsHeader({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Map> data = [
      {
        'label': 'ESTADO',
        'info': StatePaymentCard(
            isActive: payment.isActive, isCompleted: payment.isCompleted)
      },
      {'label': 'PERÍODO', 'info': payment.period},
      {'label': "CATEGORÍA", 'info': payment.name.category.name.toUpperCase()},
      {
        'label': "FECHA DE VTO",
        'info': datetimeToStringWithDash(payment.deadline)
      },
      {'label': "IMPORTE", 'info': '\$ ${formatMoney(payment.amount)}'},
      {'label': "USUARIO", 'info': capitalizeFirstLetter(payment.user!.name)}
    ];
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
                  child: Text(
                    "${data[index]['label']}=",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
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
