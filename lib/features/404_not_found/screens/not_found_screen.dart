import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/buttons/custom_button.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/features/404_not_found/utils/navigation_not_found.dart';

class NotFoundScreen extends StatefulWidget {
  static const String routeName = '/404-not-found';
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(backDeviceInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(backDeviceInterceptor);
  }

  bool backDeviceInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Image.asset(
                'assets/images/expentask-logo-color.png',
                width: 80,
              ),
            ),
          ),
          Expanded(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/404-error.png',
                  width: width / 2,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Página no encontrada / Página no existe',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: CustomButton(
              text: 'VOLVER',
              onTap: () => fromNotFoundToHome(context),
              color: GlobalVariables.historicalPending,
              textColor: GlobalVariables.whiteColor,
            ),
          )
        ],
      ),
    ));
  }
}
