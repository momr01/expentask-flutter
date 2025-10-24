import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/shared_duty/screens/shared_duty_screen.dart';

void fromSuccessToSharedDutiesPage(context) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 0, (route) => false);

  // Navigator.pushNamedAndRemoveUntil(
  //     context, GroupsScreen.routeName, (route) => false);
  Navigator.pushNamed(context, SharedDutyScreen.routeName);
}

void fromCompleteToSharedDutiesPage(context, String usuario) {
  Navigator.pushNamedAndRemoveUntil(
      context, BottomBar.routeName, arguments: 0, (route) => false);

  // Navigator.pushNamedAndRemoveUntil(
  //     context, GroupsScreen.routeName, (route) => false);
  Navigator.pushNamed(context, SharedDutyScreen.routeName);
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObligacionesScreen(usuario: usuario),
      ));
}
