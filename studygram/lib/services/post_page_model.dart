import 'package:flutter/material.dart';
import 'url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentViewModel extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";
  final String baseUrl = BaseUrl().baseUrl;

  String get errorMessage => _errorMessage;
  Status get status => _status;

  Future<Status> addComment(String token, int postID, String comment) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.post(
      Uri.parse("$baseUrl/posts/comment/$postID"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(
        <String, String>{
          'message': comment,
        },
      ),
    );
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
      return Status.success;
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      return Status.error;
    }
  }

  Future<Status> removeComment(String token, int commentID) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.delete(
      Uri.parse("$baseUrl/comment/delete/$commentID"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
    }
    return _status;
  }
}
