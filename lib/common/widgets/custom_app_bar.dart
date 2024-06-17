import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';

PreferredSize customAppBar(context, {bool isMainPage = true, var onBack}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(120.0),
    child: AppBar(
      leading: isMainPage
          ? null
          : GestureDetector(onTap: onBack, child: const Icon(Icons.arrow_back)),
      toolbarHeight: 120.0,
      title: GestureDetector(
        onTap: () {
          if (ModalRoute.of(context)?.settings.name != BottomBar.routeName) {
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBar.routeName, arguments: 0, (route) => false);
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              Image.asset('assets/images/expentask-logo.png',
                  width: 30, fit: BoxFit.scaleDown),
              Image.asset(
                'assets/images/expentask-official.png',
              )
            ])),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
}
