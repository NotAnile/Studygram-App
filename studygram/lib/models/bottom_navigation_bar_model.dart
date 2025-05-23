import 'package:flutter/material.dart';

/// Provider for getting the selected item of the navigation bar
class BottomNavigationBarModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
