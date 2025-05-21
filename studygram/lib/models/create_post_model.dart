import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url.dart';
import 'package:studygram/structure.dart';

/// Provider for the create post page.
/// Handles the server calls to create posts.
class CreatePostModel extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;
  Status get status => _status;

  /// Tries to create a post with the given body and returns a
  /// status depending on how the operation went.
  Future<Status> createPost(String token, String body) async {
    final String baseUrl = BaseUrl().baseUrl;
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
      _status = Status.success;
      _errorMessage = "";
      notifyListeners();
      return _status;
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      return _status;
    }
  }
}
