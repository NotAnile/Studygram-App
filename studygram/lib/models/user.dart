import 'package:flutter/material.dart';
import './url.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  String _username = "";
  int _amountOfPosts = 0;
  List<String> following = [];

  String get username => _username;
  int get amountOfPosts => _amountOfPosts;

  set setUsername(String username) {
    _username = username;
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
}
