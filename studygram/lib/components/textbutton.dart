import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import 'package:provider/provider.dart';

//**Creates a textbutton*/
class MyTextButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;
  final bool rectangleShape;
  final void Function() onPressed;
  final double? width;
  final double? height;
  // final String route;

  const MyTextButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.backgroundColor,
    required this.rectangleShape,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {'width': 300.0, 'height': 30.0},
      Size.medium: {'width': 400.0, 'height': 40.0},
      Size.large: {'width': 500.0, 'height': 50.0}
    };

    return Consumer<Settings>(
      builder: (context, model, state) {
        return SizedBox(
          width: width ?? sizes[model.size]['width'],
          height: height ?? sizes[model.size]['height'],
          child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(backgroundColor),
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
          ),
        );
      },
    );
  }
}
