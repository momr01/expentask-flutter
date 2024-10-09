// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';

class CustomDrawerItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String route;
  final bool closeSession;
  final List<HistoricalFilter> args;
  const CustomDrawerItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.route,
      required this.closeSession,
      required this.args})
      : super(key: key);

  void navigateToScreen(BuildContext context, String route) {
    // Navigator.popUntil(context, ModalRoute.withName(BottomBar.routeName));
    // Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
        context, BottomBar.routeName, arguments: 0, (route) => false);
    Navigator.pushNamed(context, route, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    AuthServices authServices = AuthServices();

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide()),
      ),
      child: ListTile(
          leading: icon,
          title: Text(title),
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != route) {
              if (closeSession) {
                authServices.logOut(
                    //context
                    );
              } else {
                navigateToScreen(context, route);
              }
            }
          }),
    );
  }
}
