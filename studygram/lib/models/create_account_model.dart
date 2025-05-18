import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import './authentication.dart';
import './url.dart';

class CreateAccountModel extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;
  Status get status => _status;

  Future<Status> createAccount(
      String username, String password, BuildContext context) async {
    _status = Status.loading;
    final String baseUrl = BaseUrl().baseUrl;
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
        Status loginStatus =
            await Provider.of<Authentication>(context, listen: false)
                .login(username, password, context);
        // Checking if login was successful
        if (loginStatus == Status.success) {
          _status = Status.success;
        } else {
          _errorMessage = "Account created but could not log in";
          _status = Status.error;
        }
      } else if (response.statusCode == 403) {
        _errorMessage = "Username already taken";
        _status = Status.error;
      } else {
        _errorMessage = "Unknown error";
        _status = Status.error;
      }
    }
    notifyListeners();
    return _status;
  }

// Setting error message for create account page
  void setErrorMessage(String message) {
    _errorMessage = message;
    _status = Status.error;
  }
}
