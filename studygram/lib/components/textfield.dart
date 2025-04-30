import 'package:flutter/material.dart';

//**Creates a textfield*/
class MyTextField extends StatelessWidget {
  final String labelText;
  // Takes in a text controller to use it to retrieve the current value of a textfield
  final TextEditingController controller;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                border: const OutlineInputBorder(), labelText: labelText)));
  }
}
