import 'package:flutter/material.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studygram/structure.dart';

/// Provider for the user search bar that handles the
/// network call to get all the usernames in the suggestions
/// of the search bar.
class UserSearchBarModel extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";
  List<dynamic> _suggestions = [];
  final String baseUrl = BaseUrl().baseUrl;

  String get errorMessage => _errorMessage;
  Status get status => _status;

  List<dynamic> get suggestions => _suggestions;

  void setSuggestions(List<dynamic> suggestions) {
    _suggestions = suggestions;
    notifyListeners();
  }

  /// Gets a list of usernames with the given prefix. The given limit determines the
  /// maximum length of the list.
  Future<List<dynamic>> search(String prefix, int limit) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.post(
      Uri.parse("$baseUrl/search/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'prefix': prefix,
          'limit': limit,
        },
      ),
    );
    // Handling the result depending on the status code
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      return result['users'];
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      throw Exception(_errorMessage);
    }
  }
}
