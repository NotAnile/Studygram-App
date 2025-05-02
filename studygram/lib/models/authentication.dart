import 'package:flutter/material.dart';

class Authentication extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _token = "";

  bool get isLoggedIn => _isLoggedIn;
  String get getToken => _token;

  set setToken(String token) {
    _token = token;
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
