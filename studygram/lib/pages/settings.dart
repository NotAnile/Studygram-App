import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;

    Map textSizes = {Size.small: 15.0, Size.medium: 20.0, Size.large: 25.0};

    return Consumer<Settings>(builder: (context, model, child) {
      Color buttonColor = const Color.fromARGB(255, 151, 115, 156);
      return Center(
        child: Column(
          children: [
            Text(
              "Sizes",
              style: TextStyle(fontSize: textSizes[model.size]),
            ),
            const Divider(),
            Wrap(spacing: 10.0, runSpacing: 10.0, children: [
              MyTextButton(
                onPressed: () {
                  model.changeSize(Size.small, token);
                },
                buttonText: "Small",
                textColor: Colors.white,
                backgroundColor: buttonColor,
                rectangleShape: false,
              ),
              MyTextButton(
                onPressed: () {
                  model.changeSize(Size.medium, token);
                },
                buttonText: "Medium",
                textColor: Colors.white,
                backgroundColor: buttonColor,
                rectangleShape: false,
              ),
              MyTextButton(
                onPressed: () {
                  model.changeSize(Size.large, token);
                },
                buttonText: "Large",
                textColor: Colors.white,
                backgroundColor: buttonColor,
                rectangleShape: false,
              ),
            ])
          ],
        ),
      );
    });
  }
}
