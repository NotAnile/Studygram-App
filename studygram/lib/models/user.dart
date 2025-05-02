import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'structure.dart';

//**To be implemented*/
class UserModel extends ChangeNotifier {
  String _username = "";

  String get username => _username;

  set setUsername(String username) {
    _username = username;
  }
}
