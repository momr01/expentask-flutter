import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';

void fromSuccessEditToNames(context) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 1, (route) => false);
  // Navigator.popUntil(
  //     context,
  //    BottomBar.routeName, arguments: 1);

  // Navigator.popAndPushNamed(context, BottomBar.routeName, arguments: 1);
}
