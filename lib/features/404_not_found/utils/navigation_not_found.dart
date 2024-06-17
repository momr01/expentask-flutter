import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';

void fromNotFoundToHome(context) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 0, (route) => false);
}
