import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings_model.dart';

//**Creates a textfield*/
class TextArea extends StatelessWidget {
  final String labelText;
  // Takes in a text controller to use it to retrieve the current value of a textfield
  final TextEditingController controller;
  final bool obscureText;
  final double width;

  const TextArea(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.obscureText,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, model, state) {
      return SizedBox(
          width: width,
          child: TextField(
              minLines: 1,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: labelText)));
    });
  }
}
