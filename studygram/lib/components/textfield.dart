import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';

//**Creates a textfield*/
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
    Map sizes = {Size.small: 300, Size.medium: 400, Size.large: 500};

    return Consumer<Settings>(builder: (context, model, state) {
      return SizedBox(
          width: sizes[model.size] ?? sizes['medium'],
          child: TextField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: labelText)));
    });
  }
}
