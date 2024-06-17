import 'package:flutter/material.dart';

class ManagePaymentCheckboxItem {
  final String text;
  final bool isChecked;
  final TextEditingController controller;
  final Function() onTapController;
  final Function(bool? value) onChangeCheckbox;

  ManagePaymentCheckboxItem(
      {required this.text,
      required this.isChecked,
      required this.controller,
      required this.onTapController,
      required this.onChangeCheckbox});
}
