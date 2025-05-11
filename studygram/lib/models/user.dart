import 'package:flutter/material.dart';
import './url.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  bool _isInitialized = false;
  String _username = "";
  int _amountOfPosts = 0;
  List<String> following = [];

  String get username => _username;
  int get amountOfPosts => _amountOfPosts;

  set setUsername(String username) {
    _username = username;
  }

  //** Initializes the usermodel and sets all the values by getting the data from backend. */
  void initialize(String username) async {
    if (!_isInitialized) {
      // Making a call to backend to get data
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

  void followUser(String username) {
    // Adds the person that the user wants to follow to the list
    following.add(username);
  }

  void unfollowUser(String username) {
    // Adds the person that the user wants to follow to the list
    following.remove(username);
  }
}
