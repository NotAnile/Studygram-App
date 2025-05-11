import 'package:flutter/material.dart';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  String _username = "";
  int _amountOfPosts = 0;

  String get username => _username;
  int get amountOfPosts => _amountOfPosts;

  set setUsername(String username) {
    _username = username;
  }

  void addPost() {
    _amountOfPosts += 1;
  }

  void removePost() {
    _amountOfPosts -= 1;
  }
}
