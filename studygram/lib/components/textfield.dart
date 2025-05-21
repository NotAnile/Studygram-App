import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';

/// A textfield that adjusts it's width according to the size settings.
class MyTextField extends StatelessWidget {
  final String labelText;
  // Takes in a text controller to use it to retrieve the current value of a textfield
  final TextEditingController controller;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    Map sizes = {Size.small: 300.0, Size.medium: 400.0, Size.large: 500.0};
    Map textsizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<Settings>(builder: (context, settings, state) {
      return SizedBox(
          width: sizes[settings.size] ?? sizes['medium'],
          child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(fontSize: textsizes[settings.size]),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: labelText)));
    });
  }
}
