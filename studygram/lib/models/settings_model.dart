import 'package:flutter/material.dart';
import './url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settings extends ChangeNotifier {
  Size _size = Size.medium;
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  Size get size => _size;
  Status get status => _status;
  String get errorMessage => _errorMessage;

  void getSize(String token) async {
    final response = await http
        .get(Uri.parse("$baseUrl/settings"), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    });
    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      _size = Size.fromString(result['size']);
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = response.body;
    }
    notifyListeners();
  }

  /// Updates the size of widgets and text in the app
  void changeSize(Size size, String token) async {
    _size = size;

    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/update/settings"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'size': Size.asString(size),
        }));
    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}

enum Size {
  small,
  medium,
  large;

  static Size fromString(String string) {
    switch (string.toLowerCase()) {
      case 'small':
        return Size.small;
      case 'medium':
        return Size.medium;
      case 'large':
        return Size.large;
      default:
        throw ArgumentError('Unknown size: $string');
    }
  }

  static String asString(Size size) {
    switch (size) {
      case small:
        return "small";
      case medium:
        return "medium";
      case large:
        return "large";
      default:
        throw ArgumentError('Unknown size: $size');
    }
  }
}
