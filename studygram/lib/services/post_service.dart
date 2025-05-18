import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/models/content.dart';
import 'dart:convert';
import 'url.dart';

/// PostService handles all the calls to the backend for posts
class PostService {
  String _errorMessage = "";
  Status _status = Status.idle;

  Status get status => _status;
  String get errorMessage => _errorMessage;
  final String baseUrl = BaseUrl().baseUrl;

  Future<Status> createPost(String token, String body) async {
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
      return Status.success;
    } else {
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      return Status.error;
    }
  }

  Future<Status> removePost(String token, int postID) async {
    _status = Status.loading;
    final response = await http.delete(
      Uri.parse("$baseUrl/posts/delete/$postID"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
    }
    return _status;
  }

  ///Returns a list with posts for the given post id.
  Future<List<dynamic>> getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers) async {
    const int postLimit = 20;
    final response = await http.post(
      Uri.parse("$baseUrl/posts/all"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'selected_users': selectedUsers,
          'excluded_users': excludedUsers,
          'post_count': postLimit
        },
      ),
    );

    // Adding all the posts from json to a list
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return result.map((json) => Post.fromJson(json)).toList();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }
}
