import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_model.dart';

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
    return Consumer<Settings>(builder: (context, settings, state) {
      // Gets the textsize
      Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
      return SizedBox(
          width: width,
          child: TextField(
              minLines: 1,
              maxLines: 8,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              controller: controller,
              obscureText: obscureText,
              style: TextStyle(fontSize: sizes[settings.size]),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), labelText: labelText)));
    });
  }
}
