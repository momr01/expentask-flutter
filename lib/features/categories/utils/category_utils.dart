import 'package:flutter/material.dart';
import 'package:payments_management/features/categories/screens/categories_screen.dart';

void fromSuccessToCategoryScreen(context) {
  Navigator.popUntil(
      context,
      ModalRoute.withName(
        CategoriesScreen.routeName,
      ));

  Navigator.popAndPushNamed(context, CategoriesScreen.routeName);
}
