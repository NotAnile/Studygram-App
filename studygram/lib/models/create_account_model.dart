import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import './authentication.dart';

class CreateAccountModel extends ChangeNotifier {
  String baseUrl = "http://127.0.0.1:5003";
  String _errorMessage = "";
  bool _showErrorMessage = false;

  String get errorMessage => _errorMessage;
  bool get showErrorMessage => _showErrorMessage;

  void createAccount(
      String username, String password, BuildContext context) async {
    final response = await http.post(Uri.parse("$baseUrl/user"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    // Checks if context is mounted to ensure that the widget associated with the context
    // has not been disposed or removed
    if (context.mounted) {
      if (response.statusCode == 200) {
        // Logging in since the user was succesfully created
        Provider.of<Authentication>(context, listen: false)
            .login(username, password, context);
        notifyListeners();
      } else if (response.statusCode == 403) {
        _errorMessage = "Username already taken";
        _showErrorMessage = true;
        notifyListeners();
      } else {
        // Add logic to handle when something else went wrong
      }
    }
  }

// Setting error message for create account page
  void setErrorMessage(String message) {
    _errorMessage = message;
  }

  void setShowErrorMessage(bool show) {
    _showErrorMessage = show;
  }
}
