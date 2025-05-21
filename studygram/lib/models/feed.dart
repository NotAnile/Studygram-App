import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../structure.dart';
import '../url.dart';

/// Provider for handling anything that has to do with posts
/// for example when displaying posts for homepage and profile page
class Feed extends ChangeNotifier {
  final String baseUrl = BaseUrl().baseUrl;
  final int postLimit = 20;
  Status _status = Status.idle;
  String _errorMessage = "";

  Status get status => _status;
  String get errorMessage => _errorMessage;

  /// Returns a list of the posts for a given username.
  Future<dynamic> getProfile(String username, String token) async {
    _status = Status.loading;
    final response = await http.get(
      Uri.parse("$baseUrl/profile/$username"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
    );
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return User.fromJson(result);
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Returns a post object for the given post id.
  Future<dynamic> getPost(int postID, String token) async {
    _status = Status.loading;
    final response = await http.get(
      Uri.parse("$baseUrl/post/$postID"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
    );

    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return Post.fromJson(result);
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Tries to remove the post with the given post id and returns
  /// a status depending on how the operation went.
  Future<Status> removePost(int postID, String token) async {
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
      notifyListeners();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
    }
    return _status;
  }

  /// Returns a list of comments for the given post id.
  Future<dynamic> getComments(int postID, String token) async {
    _status = Status.loading;
    final response = await http.get(
      Uri.parse("$baseUrl/posts/$postID/comments"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return result.map((json) => Comment.fromJson(json)).toList();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Returns a list with posts (maximum of 20 of the most recent posts) of the selected users.
  Future<List<dynamic>> getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers) async {
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
