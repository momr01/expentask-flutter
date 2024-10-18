import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool modal;
  final VoidCallback? onTap;
  final Icon? suffixIcon;
  final bool? isAmount;
  final Color? fillColor;
  final bool centeredText;
  final bool withLabel;
  final String labelText;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.suffixIcon,
      this.modal = false,
      this.onTap,
      this.isAmount,
      this.maxLines = 1,
      this.fillColor,
      this.centeredText = false,
      this.withLabel = false,
      this.labelText = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        withLabel
            ? Text(
                labelText,
                style: const TextStyle(fontSize: 18),
              )
            : const SizedBox(),
        withLabel
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(),
        TextFormField(
          textAlign: centeredText ? TextAlign.center : TextAlign.start,
          controller: controller,
          keyboardType:
              isAmount != null && isAmount! ? TextInputType.number : null,
          decoration: InputDecoration(
            suffixIcon: suffixIcon ?? suffixIcon,
            hintText: hintText,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            filled: true,
            fillColor: fillColor ?? GlobalVariables.greyBackgroundColor,
            isDense: true,
            errorStyle: TextStyle(
                color: modal ? Colors.red : Colors.yellow, fontSize: 14),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return hintText;
            }
            return null;
          },
          maxLines: maxLines,
          onTap: onTap,
        ),
      ],
    );
  }
}
