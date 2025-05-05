import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String _errorMessage = "";
  bool _showErrorMessage = false;

  String get errorMessage => _errorMessage;
  bool get showErrorMessage => _showErrorMessage;

  void setErrorMessage(String message) {
    _errorMessage = message;
  }

  void setShowErrorMessage(bool show) {
    _showErrorMessage = show;
  }
}
