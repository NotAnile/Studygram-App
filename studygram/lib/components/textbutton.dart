import 'package:flutter/material.dart';

//**Creates a textbutton*/
class MyTextButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color buttonBGColor;
  final bool rectangleShape;
  // final String route;

  const MyTextButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.buttonBGColor,
    required this.rectangleShape,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttonBGColor),
        shape: (rectangleShape)
            ? WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              )
            : null,
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
