import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/features/creditor/screens/creditor_screen.dart';

void fromSuccessToCreditorsPage(context) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 0, (route) => false);

  // Navigator.pushNamedAndRemoveUntil(
  //     context, GroupsScreen.routeName, (route) => false);
  Navigator.pushNamed(context, CreditorScreen.routeName);
}
