import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Size _size = Size.medium;

  Size get size => _size;

  void changeSize(Size size) {
    _size = size;
  }
}

enum Size { small, medium, large }
