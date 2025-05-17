import 'package:flutter/material.dart';
import 'package:studygram/structure.dart';
import './url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudyHistoryModel extends ChangeNotifier {
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  Status get status => _status;
  String get errorMessage => _errorMessage;

  /// Gets a list containing all sessions of the user
  Future<List<dynamic>> getSessions(String token) async {
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
      return result.map((json) => Session.fromJson(json)).toList();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }
}
