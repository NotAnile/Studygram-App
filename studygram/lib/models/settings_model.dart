import 'package:flutter/material.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studygram/structure.dart';

/// Provider for the settings of the app, which includes
/// the sizes of texts and widgets and the apptheme.
class Settings extends ChangeNotifier {
  Size _size = Size.medium;
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  ThemeMode _themeMode = ThemeMode.system;
  bool _contrast = false;

  Size get size => _size;
  ThemeMode get themeMode => _themeMode;
  bool get contrast => _contrast;
  Status get status => _status;
  String get errorMessage => _errorMessage;

  void getSettings(String token) async {
    _status = Status.loading;
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
      _themeMode =
          result['theme'] == "light" ? ThemeMode.light : ThemeMode.dark;
      _contrast = result['contrast'];
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = response.body;
    }
    notifyListeners();
  }

  /// Updates the size of widgets and text in the app
  void changeSettings(
      String token, Size? size, ThemeMode? themeMode, bool? contrast) async {
    _status = Status.loading;
    // Updating settings internally
    if (size != null) {
      _size = size;
    }
    if (themeMode != null) {
      _themeMode = themeMode;
    }
    if (contrast != null) {
      _contrast = contrast;
    }
    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/update/settings"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          // Sends the current settings if any of the given parameters for size, theme or
          // contrast are null
          'size': Size.asString(_size),
          'theme': (_themeMode == ThemeMode.light) ? 'light' : 'dark',
          'contrast': _contrast,
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

/// Enum for the different sizes of the text and widgets in the app.
enum Size {
  small,
  medium,
  large;

  /// Converts a String to a Size enum make the
  /// data conversions easier when getting data
  /// from the server.
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

  /// Converts a Size enum to a String to make the
  /// data conversions easier for the network calls.
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
