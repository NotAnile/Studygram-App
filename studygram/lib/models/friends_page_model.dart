import 'package:flutter/material.dart';

/// Provider for the modes in friends page
class FriendsPageModel extends ChangeNotifier {
  bool _seeFriends = false;

  bool get seeFriends => _seeFriends;

  void setSeeFriends(bool seeFriends) {
    _seeFriends = seeFriends;
    notifyListeners();
  }
}
