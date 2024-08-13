import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CategoriesServices {
  Future<List<Category>> fetchCategories(
      {required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Category> categoriesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/categories/getAll?user=${userProvider.user.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      //debugPrint(res.body);

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              //  categoriesList
              //      .add(Category.fromJson(jsonEncode(jsonDecode(res.body)[i])));
              //from json accepts string, jsondecode is an object
              categoriesList.add(Category.fromJson(jsonDecode(res.body)[i]));

              // namesList.add(PaymentName.fromJson(jsonDecode(res.body)[i]));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return categoriesList;
  }
}
