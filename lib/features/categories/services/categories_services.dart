import 'dart:convert';

import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/models/category/category.dart';
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CategoriesServices {
  Future<List<Category>> fetchCategories() async {
    final userProvider = Provider.of<UserProvider>(
        NavigatorKeys.navKey.currentContext!,
        listen: false);
    List<Category> categoriesList = [];

    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/categories/getAll?user=${userProvider.user.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token
          });

      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              categoriesList.add(Category.fromJson(jsonDecode(res.body)[i]));
              // debugPrint(jsonDecode(res.body)[i]);
            }
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
    return categoriesList;
  }
}
