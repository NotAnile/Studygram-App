import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/services/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:studygram/services/authentication.dart';
import 'package:studygram/services/url.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;

    Map textSizes = {Size.small: 15.0, Size.medium: 20.0, Size.large: 25.0};

    return Consumer<Settings>(builder: (context, model, child) {
      // Shows a snackbar if something went wrong
      if (model.status == Status.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(model.errorMessage)));
      }

      void changeSize(Size size) {
        try {
          model.changeSize(size, token);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }

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
                  changeSize(Size.small);
                },
                buttonText: "Small",
                textColor: Colors.white,
                backgroundColor: buttonColor,
                rectangleShape: false,
              ),
              MyTextButton(
                onPressed: () {
                  changeSize(Size.medium);
                },
                buttonText: "Medium",
                textColor: Colors.white,
                backgroundColor: buttonColor,
                rectangleShape: false,
              ),
              MyTextButton(
                onPressed: () {
                  changeSize(Size.large);
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
