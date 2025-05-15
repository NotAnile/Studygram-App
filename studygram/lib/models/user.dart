import 'package:flutter/material.dart';
import 'package:studygram/structure.dart';
import './url.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  bool _isInitialized = false;
  String _username = "";
  List<dynamic> _posts = [];
  int _amountOfPosts = 0;
  List<dynamic> _following = [];
  List<dynamic> _friends = [];
  List _friendRequests = [];
  Status _status = Status.idle;
  String _errorMessage = "";

  String get username => _username;
  List<dynamic> get posts => _posts;
  int get amountOfPosts => _amountOfPosts;
  List<dynamic> get following => _following;
  List<dynamic> get friends => _friends;
  List<dynamic> get friendRequests => _friendRequests;
  bool get isInitialized => _isInitialized;

  set setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  //** Initializes the usermodel and sets all the values by getting the data from backend. */
  void initialize(String username, String token) async {
    if (!_isInitialized) {
      _status = Status.loading;
      final String baseUrl = BaseUrl().baseUrl;

      // Making a call to backend to get data about the user
      final response = await http.get(
        Uri.parse("$baseUrl/profile/$username"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      // Handling the result depending on the status code
      if (response.statusCode == 200) {
        // Decoding the json to a map
        final Map<String, dynamic> data = json.decode(response.body);
        _isInitialized = true;
        _username = data['username'];
        _posts = data['posts'].map((json) => Post.fromJson(json)).toList();
        _amountOfPosts = data['post_count'];
        _following = data['following'];
        _friends = data['friends'];
        _friendRequests = data['friend_requests'];

        _status = Status.success;
        // Setting no error message since everything went well
        _errorMessage = "";
      } else {
        // Something went wrong, so error message is updated
        _status = Status.error;
        _errorMessage = json.decode(response.body)['message'];
      }
      notifyListeners();
    } else {
      // Model already initialized, so it does nothing
      return;
    }
  }

  void incrementPostCount() {
    _amountOfPosts += 1;
  }

  void decreasePostCount() {
    _amountOfPosts -= 1;
  }

  /// Adds the person that the user wants to follow to the list
  void followUser(String username) {
    if (!_following.contains(username)) {
      _following.add(username);
    }
    notifyListeners();
  }

  /// Removes the person that the user wants to unfollow to the list
  void unfollowUser(String username) {
    if (_following.contains(username)) {
      _following.remove(username);
    }
    notifyListeners();
  }
}
