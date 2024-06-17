// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/features/historical/utils/historical_utils.dart';
import 'package:payments_management/features/historical/widgets/state_payment_card.dart';
import 'package:payments_management/models/payment/payment.dart';

class HistoricalItemCard extends StatelessWidget {
  final Payment payment;
  const HistoricalItemCard({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToHistoricalDetailsScreen(context, payment),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      payment.name.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  StatePaymentCard(
                    isActive: payment.isActive,
                    isCompleted: payment.isCompleted,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Período = ${payment.period}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    String.fromCharCode(Icons.add.codePoint),
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: Icons.add.fontFamily,
                      package: Icons.add.fontPackage,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
