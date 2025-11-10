// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/auth/services/auth_services.dart';

class CustomDrawerItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String route;
  final bool closeSession;
  final List args;
  const CustomDrawerItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.route,
      required this.closeSession,
      required this.args})
      : super(key: key);

  void navigateToScreen(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(
        context, BottomBar.routeName, arguments: 0, (route) => false);
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _confirmLogOut(BuildContext context, AuthServices authServices) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Cerrar Sesión"),
          ],
        ),
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿Desea cerrar su sesión?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => authServices.logOut(),
            child: const Text(
              "Cerrar Sesión",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx, "cancelar"),
              child: const Text("Cancelar")),
        ],
      ),
    );
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
            /*onTap: () {
              if (ModalRoute.of(context)?.settings.name != route) {
                if (closeSession) {
                  _confirmLogOut(context, authServices);
                }
              } else {
                navigateToScreen(context, route);
              }
            }*/
            onTap: () {
              if (closeSession) {
                _confirmLogOut(context, authServices);
                return;
              }

              // Si estoy ya en esa pantalla, no vuelvo a navegar
              if (ModalRoute.of(context)?.settings.name == route) {
                return;
              }

              // Navegar normalmente
              navigateToScreen(context, route);
            }));
  }
}
