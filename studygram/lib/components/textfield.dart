import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  // Creating a text controller to use it to retrieve the current value of a textfield
  final myController = TextEditingController();
  MyTextField({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        child: TextField(
            controller: myController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(), labelText: labelText)));
  }
}
