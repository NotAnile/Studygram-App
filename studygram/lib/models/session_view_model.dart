import 'package:flutter/material.dart';
import 'package:studygram/structure.dart';
import './url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Provider for the session view widget in the study history page.
/// This class handles getting study sessions and deleting them.
class SessionViewModel extends ChangeNotifier {
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  Status get status => _status;
  String get errorMessage => _errorMessage;

  /// Gets a list containing all sessions of the user
  Future<List<dynamic>> getSessions(String token) async {
    _status = Status.loading;
    final response = await http.get(
      Uri.parse("$baseUrl/sessions/all"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    // Adding all the posts from json to a list
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return result['sessions'].map((json) => Session.fromJson(json)).toList();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Removes the given session from the user's study sessions
  Future<Status> deleteSession(String token, int sessionId) async {
    _status = Status.loading;
    final response = await http.delete(
      Uri.parse("$baseUrl/session/delete"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'id': sessionId,
        },
      ),
    );

    // Adding all the posts from json to a list
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      _errorMessage = "";
      notifyListeners();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
    }
    return _status;
  }
}
