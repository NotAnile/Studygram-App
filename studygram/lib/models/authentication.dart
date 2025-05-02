import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './user.dart';
import 'package:provider/provider.dart';

class Authentication extends ChangeNotifier {
  String baseUrl = "https://studygram-server.azurewebsite.net";
  bool _isLoggedIn = true;
  String _token = "";
  String? _usernameError;

  bool get isLoggedIn => _isLoggedIn;
  String get getToken => _token;
  String? get usernameError => _usernameError;

  set setToken(String token) {
    _token = token;
  }

  void login(String username, String password, BuildContext context) async {
    final response = await http.post(Uri.parse("$baseUrl/user/login"),
        // application/json means we want to parse it as a json
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    // Checks if context is mounted to ensure that the widget associated with the context
    // has not been disposed or removed
    if (context.mounted) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        // Setting the token for the authentication model from the result
        _token = result['token'];
        Provider.of<UserModel>(context, listen: false).setUsername = username;
      }
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void createAccount(
      String username, String password, BuildContext context) async {
    // Resetting the error variables before the network call
    _usernameError = null;

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
        login(username, password, context);
      } else if (response.statusCode == 403) {
        _usernameError = "Username already taken";
      } else {
        // Add logic to handle when something else went wrong
      }
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
