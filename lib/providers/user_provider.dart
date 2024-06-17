import 'package:flutter/material.dart';
import 'package:payments_management/models/user/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      id: "",
      // username: "",
      email: "",
      password: "",
      name: "",
      isActive: false,
      dataEntry: DateTime.now(),
      type: "",
      token: "");

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }
}
