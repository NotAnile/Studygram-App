import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../structure.dart';
import './url.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';

class FriendManager extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";

  Status get status => _status;
  String get errorMessage => _errorMessage;

  void addFriend(BuildContext context, String friendUsername) async {
    _status = Status.loading;
    final String baseUrl = BaseUrl().baseUrl;
    // Getting token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/friend/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'username': friendUsername,
        }));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = response.body;
    }
    notifyListeners();
  }

  void removeFriend(BuildContext context, String friendUsername) async {
    final String baseUrl = BaseUrl().baseUrl;
    // Getting token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    // Creating a JSON to send to the server
    final response = await http.delete(Uri.parse("$baseUrl/friend/remove"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'username': friendUsername,
        }));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
    }
    notifyListeners();
  }
}
