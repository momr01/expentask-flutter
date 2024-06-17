// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/global_variables.dart';

class StatePaymentCard extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  const StatePaymentCard({
    Key? key,
    required this.isActive,
    required this.isCompleted,
  }) : super(key: key);

  String textState() {
    String text = "-";

    if (isCompleted) {
      text = "completados";
    } else if (isActive) {
      text = "pendientes";
    } else {
      text = "anulados";
    }

    return text.toUpperCase();
  }

  Color colorState() {
    Color color = Colors.grey;

    if (isCompleted) {
      color = GlobalVariables.historicalCompleted;
    } else if (isActive) {
      color = GlobalVariables.historicalPending;
    } else {
      color = GlobalVariables.historicalAnnulled;
    }

    return color;
  }

  @override
  Widget build(BuildContext context) {
    return ColorRoundedItem(
        colorBackCard: colorState(),
        colorBorderCard: colorState(),
        text: textState(),
        colorText: Colors.white);
  }
}
