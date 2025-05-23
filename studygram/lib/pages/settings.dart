import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/structure.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of<Authentication>(context, listen: false);
    String token = auth.accessToken;

    Settings settings = Provider.of<Settings>(context, listen: false);

    Map textSizes = {Size.small: 15.0, Size.medium: 20.0, Size.large: 25.0};

    return Consumer<Settings>(builder: (context, model, child) {
      // Shows a snackbar if something went wrong
      if (model.status == Status.error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(model.errorMessage)));
      }

      // Changes the size for settings
      void changeSize(Size size) {
        try {
          model.changeSettings(token, size, null, null);
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }

      Color buttonColor = Theme.of(context).primaryColor;
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title
              Text(
                "Sizes",
                style: TextStyle(
                  fontSize: textSizes[model.size],
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              // Wrapping the buttons so overflow doesn't occur
              Wrap(spacing: 10.0, runSpacing: 10.0, children: [
                MyTextButton(
                  onPressed: () {
                    changeSize(Size.small);
                  },
                  buttonText: "Small",
                  backgroundColor: buttonColor,
                  rectangleShape: false,
                ),
                MyTextButton(
                  onPressed: () {
                    changeSize(Size.medium);
                  },
                  buttonText: "Medium",
                  backgroundColor: buttonColor,
                  rectangleShape: false,
                ),
                MyTextButton(
                  onPressed: () {
                    changeSize(Size.large);
                  },
                  buttonText: "Large",
                  backgroundColor: buttonColor,
                  rectangleShape: false,
                ),
              ]),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // Title
                child: Text(
                  "Themes",
                  style: TextStyle(
                    fontSize: textSizes[model.size],
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // Switch to activate/deactivate dark mode
                  const Text("Dark Mode"),
                  SwitchButton(
                      // Checking if darkmode is already activated from before
                      alreadyToggled: (settings.themeMode == ThemeMode.dark),
                      // Sending up a function for changing settings to darkmode
                      // when the switch gets toggled
                      toggleFunction: () {
                        settings.changeSettings(
                            token, null, ThemeMode.dark, null);
                      },
                      // Function for changing settings back to lightmode
                      untoggleFunction: () {
                        settings.changeSettings(
                            token, null, ThemeMode.light, null);
                      }),
                ]),
              ),
              // Switch to activate/deactivate high constrast
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("High Contrast"),
                  SwitchButton(
                    // Checking if high contrast is already activated from before
                    alreadyToggled: settings.contrast,
                    toggleFunction: () {
                      settings.changeSettings(token, null, null, true);
                    },
                    untoggleFunction: () {
                      settings.changeSettings(token, null, null, false);
                    },
                  )
                ]),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // Log out button
                child: MyTextButton(
                  onPressed: () async {
                    await auth.logout();
                    // Shows snackbar if user got logged out
                    if (context.mounted) {
                      if (auth.status == Status.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Succesfully logged out")));
                      } else if (auth.status == Status.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              (auth.errorMessage.isEmpty
                                  ? "Unknown error"
                                  : auth.errorMessage),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  buttonText: "Log out",
                  backgroundColor: buttonColor,
                  rectangleShape: true,
                  wrapText: true,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Switch for toggling dark/light mode and contrast
/// The class takes in two functions which are used when the modes
/// are toggled/untoggled and a bool to know if the switch was already toggled
/// so that the switch is in the correct state
class SwitchButton extends StatefulWidget {
  final bool alreadyToggled;
  final void Function() toggleFunction;
  final void Function() untoggleFunction;
  const SwitchButton(
      {super.key,
      required this.alreadyToggled,
      required this.toggleFunction,
      required this.untoggleFunction});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    // Initializing toggled so it's in the correct state
    bool toggled = widget.alreadyToggled;
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Switch(
          value: toggled, // When the switch is toggled, the value gets changed
          activeColor: Theme.of(context).colorScheme.onSurfaceVariant,
          onChanged: (bool value) {
            // If the switch is toggled it will call the  given toggle function
            // otherwise it will call the given untoggle function
            if (!toggled) {
              setState(widget.toggleFunction);
            } else {
              setState(widget.untoggleFunction);
            }
            toggled = !toggled;
          },
        );
      },
    );
  }
}
