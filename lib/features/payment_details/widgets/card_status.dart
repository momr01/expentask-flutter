// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';

class CardStatus extends StatelessWidget {
  final bool isCompleted;
  const CardStatus({
    Key? key,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status = "Pendiente";

    Color colorStrong = Colors.red.shade900;
    Color colorLight = Colors.red.shade50;

    if (isCompleted) {
      status = "Listo";
      colorStrong = Colors.green.shade900;
      colorLight = Colors.green.shade50;
    }

    return ColorRoundedItem(
        colorBackCard: colorLight,
        colorBorderCard: colorStrong,
        text: status,
        colorText: colorStrong);
  }
}
