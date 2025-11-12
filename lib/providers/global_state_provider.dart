import 'package:flutter/material.dart';

class GlobalStateProvider extends ChangeNotifier {
  bool _refreshHomeScreen = false;

  bool get refreshHomeScreen => _refreshHomeScreen;

  void setRefreshHomeScreen(bool value) {
    _refreshHomeScreen = value;
    notifyListeners();
  }
}
