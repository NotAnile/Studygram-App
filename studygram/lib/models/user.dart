import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'structure.dart';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  String _username = "";
  int _amountOfPosts = 0;

  String get username => _username;
  int get amountOfPosts => _amountOfPosts;

  set setUsername(String username) {
    _username = username;
  }

  set _setAmountOfPosts(int amount) {
    _amountOfPosts = amount;
  }
}
