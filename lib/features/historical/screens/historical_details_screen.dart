// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/main_title.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/historical/widgets/details_header.dart';
import 'package:payments_management/features/historical/widgets/details_tasks.dart';
import 'package:payments_management/models/payment/payment.dart';

class HistoricalDetailsScreen extends StatelessWidget {
  static const String routeName = '/historical-payment-details';
  final Payment payment;
  const HistoricalDetailsScreen({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          // Navigator.push
        },
        child: Scaffold(
          appBar: customAppBar(context),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: MainTitle(
                  title: capitalizeFirstLetter(payment.name.name),
                  bold: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: DetailsHeader(payment: payment),
              )),
              Expanded(
                child: DetailsTasks(tasks: payment.tasks),
              )
            ],
          ),
        ));
  }
}
