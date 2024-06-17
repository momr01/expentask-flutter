// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ColorRoundedItem extends StatelessWidget {
  final Color colorBackCard;
  final Color colorBorderCard;
  final String text;
  final Color colorText;
  final VoidCallback? onTap;
  final double? sizeText;
  const ColorRoundedItem({
    Key? key,
    required this.colorBackCard,
    required this.colorBorderCard,
    required this.text,
    required this.colorText,
    this.onTap,
    this.sizeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colorBackCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorBorderCard,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: SizedBox(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 0.5,
                      color: colorText,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeText ?? 15))),
        ),
      ),
    );
  }
}
