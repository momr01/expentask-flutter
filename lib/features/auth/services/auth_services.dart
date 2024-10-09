import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/constants/error_handling.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/navigator_keys.dart';
import 'package:payments_management/constants/success_modal.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/auth/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:payments_management/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  //sign up user
  Future<void> signUpUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) async {
    try {
      Map body = {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword
      };

      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: jsonEncode(body),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () {
            successModal(
                context: NavigatorKeys.navKey.currentContext!,
                description:
                    'Se creó la cuenta con éxito. Use sus credenciales para ingresar.',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      NavigatorKeys.navKey.currentContext!,
                      LoginScreen.routeName,
                      (route) => false);
                });
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  //sign in user
  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandle(
          response: res,
          context: NavigatorKeys.navKey.currentContext!,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(NavigatorKeys.navKey.currentContext!,
                    listen: false)
                .setUser(res.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);

            NavigatorKeys.navKey.currentState?.pushNamedAndRemoveUntil(
                BottomBar.routeName, arguments: 0, (route) => false);
          });
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  //get user data
  Future<void> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response) {
        //get user data
        http.Response userRes = await http
            .get(Uri.parse('$uri/api/get-user-data'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });

        var userProvider = Provider.of<UserProvider>(
            NavigatorKeys.navKey.currentContext!,
            listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }

  //get user data
  Future<bool> getDataFromUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response) {
        //get user data
        http.Response userRes = await http
            .get(Uri.parse('$uri/api/get-user-data'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });

        var userProvider = Provider.of<UserProvider>(
            NavigatorKeys.navKey.currentContext!,
            listen: false);
        userProvider.setUser(userRes.body);
      }

      return true;
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
      return false;
    }
  }

  void logOut() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();

      NavigatorKeys.navKey.currentState
          ?.pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(NavigatorKeys.navKey.currentContext!, e.toString());
    }
  }
}
