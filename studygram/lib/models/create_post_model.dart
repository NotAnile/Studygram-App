import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import 'package:go_router/go_router.dart';
import './url.dart';

class CreatePostModel extends ChangeNotifier {
  String _errorMessage = "";
  bool _showErrorMessage = false;

  String get errorMessage => _errorMessage;
  bool get showErrorMessage => _showErrorMessage;

  void createPost(BuildContext context, String body) async {
    final String baseUrl = BaseUrl().baseUrl;
    // Getting token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/posts"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        // We don't need to send the username when we use the token
        body: jsonEncode(<String, String>{'body': body.trim()}));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      // Setting no error message since everything went well
      _errorMessage = "";
      _showErrorMessage = false;
      // Updating the post count of the user and pops the user back to home screen
      if (context.mounted) {
        Provider.of<UserModel>(context, listen: false).incrementPostCount();
        context.pop();
      }
    } else {
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      _showErrorMessage = true;
    }
    notifyListeners();
  }

// Setting error message for create account page
  void setErrorMessage(String message) {
    _errorMessage = message;
  }

  void setShowErrorMessage(bool show) {
    _showErrorMessage = show;
  }
}
