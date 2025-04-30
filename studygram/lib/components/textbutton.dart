import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import 'package:provider/provider.dart';

//**Creates a textbutton*/
class MyTextButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color buttonBGColor;
  final bool rectangleShape;
  final void Function() onPressed;
  // final String route;

  const MyTextButton({
    super.key,
    required this.buttonText,
    required this.textColor,
    required this.buttonBGColor,
    required this.rectangleShape,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {'width': 300, 'height': 30},
      Size.medium: {'width': 400, 'height': 40},
      Size.large: {'width': 500, 'height': 50}
    };

    return Consumer<Settings>(
      builder: (context, model, state) {
        return SizedBox(
          width: sizes[model.size]['width'],
          height: sizes[model.size]['height'],
          child: TextButton(
            onPressed: onPressed,
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
          ),
        );
      },
    );
  }
}
