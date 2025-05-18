import 'package:flutter/material.dart';
import '../services/settings_model.dart';
import 'package:provider/provider.dart';

//**Creates a textbutton*/
class MyTextButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;
  final bool rectangleShape;
  final bool? wrapText;
  final void Function() onPressed;
  final double? width;
  final double? height;

  const MyTextButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.backgroundColor,
    required this.rectangleShape,
    required this.onPressed,
    this.wrapText,
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

    // Gets the textsize
    Map textsizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<Settings>(
      builder: (context, settings, state) {
        if (wrapText != null && wrapText!) {
          return TextButton(
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
          );
        } else {
          return SizedBox(
            width: width ?? sizes[settings.size]['width'],
            height: height ?? sizes[settings.size]['height'],
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
                style: TextStyle(
                    color: textColor, fontSize: textsizes[settings.size]),
              ),
            ),
          );
        }
      },
    );
  }
}
