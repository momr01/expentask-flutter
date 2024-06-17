import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/custom_app_bar.dart';
import 'package:payments_management/common/widgets/drawer/custom_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  static const String routeName = '/categories';
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context),
        drawer: const CustomDrawer(),
        body: Text('CATEGORIES'));
  }
}
