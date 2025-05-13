import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './user.dart';
import 'package:provider/provider.dart';
import './url.dart';
import 'package:studygram/models/settings_model.dart';

class Authentication extends ChangeNotifier {
  bool _isLoggedIn = false;
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  String _accessToken = "";
  String _refreshToken = "";

  bool get isLoggedIn => _isLoggedIn;
  Status get status => _status;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get errorMessage => _errorMessage;

  Future<Status> login(
      String username, String password, BuildContext context) async {
    _status = Status.loading;
    final response = await http.post(Uri.parse("$baseUrl/user/login"),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        },
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    // Getting the result
    final Map<String, dynamic> result = json.decode(response.body);
    // Checks if context is mounted to ensure that the widget associated with the context
    // has not been disposed or removed
    if (context.mounted) {
      if (response.statusCode == 200) {
        // Setting the token for the authentication model from the result
        _accessToken = result['access_token'];
        _refreshToken = result['refresh_token'];

        // Setting up user model and updating isLoggedIn bool
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        userModel.setUsername = username;
        userModel.initialize(username);

        // Getting the size that the user has chosen
        Provider.of<Settings>(context, listen: false).getSize(_accessToken);

        _isLoggedIn = true;
        _status = Status.success;
      } else {
        _errorMessage = result['message'];
        _status = Status.error;
      }
    }
    notifyListeners();
    return _status;
  }

  void logout() async {
    final String token = _accessToken;
    final response = await http.post(
      Uri.parse("$baseUrl/user/logout"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      _isLoggedIn = false;
      _status = Status.success;
    } else {
      _status = Status.error;
    }
    notifyListeners();
  }
}
