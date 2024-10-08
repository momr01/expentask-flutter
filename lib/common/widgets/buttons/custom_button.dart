// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final bool isDisabled;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.color,
      this.textColor,
      this.isDisabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onTap,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          disabledBackgroundColor: Colors.grey.shade500),
      child: Text(
        text,
        style: TextStyle(
            color: color == null
                ? Colors.white
                : isDisabled
                    ? Colors.grey.shade800
                    : textColor ?? Colors.black,
            fontSize: 25),
      ),
    );
  }
}
