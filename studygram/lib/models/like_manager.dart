import 'package:flutter/material.dart';
import 'package:studygram/structure.dart';
import '../url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Provider for handling liking and unliking posts, as well
/// as getting the liked posts.
class LikeManager extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;
  Status get status => _status;

  /// Adds the post that the user has liked to the list
  Future<void> likePost(String token, Content post) async {
    _status = Status.loading;
    final String baseUrl = BaseUrl().baseUrl;
    int postID = post.id;

    // Creating a JSON to send to the server
    final response = await http.post(
      Uri.parse("$baseUrl/posts/like/$postID"),
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
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
    }
    notifyListeners();
  }

  /// Removes the post that the user wants to unlike from the list
  Future<void> unlikePost(String token, Content post) async {
    final String baseUrl = BaseUrl().baseUrl;
    int postID = post.id;

    // Creating a JSON to send to the server
    final response = await http.delete(
      Uri.parse("$baseUrl/posts/unlike/$postID"),
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
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
    }
    notifyListeners();
  }

  /// Returns a list of all the liked posts of the logged in user.
  Future<List<dynamic>> getLikedPosts(String token) async {
    final String baseUrl = BaseUrl().baseUrl;

    // Creating a JSON to send to the server
    final response = await http.get(
      Uri.parse("$baseUrl/liked/posts"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    // Handling the result depending on the status code
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      return result['liked_posts'].map((json) => Post.fromJson(json)).toList();
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      throw Exception(_errorMessage);
    }
  }
}
