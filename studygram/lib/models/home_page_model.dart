import 'package:flutter/material.dart';

/// Provider for the modes in home page
class HomePageModel extends ChangeNotifier {
  bool _seeFollowing = true;

  bool get seeFollowing => _seeFollowing;

  void setSeeFollowing(bool seeFollowing) {
    _seeFollowing = seeFollowing;
    notifyListeners();
  }
}
