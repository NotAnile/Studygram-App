import 'dart:async';

import 'package:flutter/material.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/timer_model.dart';
import '../components/textfield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/url.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/components/textbutton.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;

    WatchModel watchModel = Provider.of<WatchModel>(context, listen: false);

    TextEditingController subjectController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Consumer<Settings>(builder: (context, settings, child) {
      Map buttonWidth = {
        Size.small: 150.0,
        Size.medium: 175.0,
        Size.large: 200.0
      };

      Map textsize = {Size.small: 20.0, Size.medium: 22.5, Size.large: 25.0};

      return Consumer<TimerModel>(
        builder: (context, timerModel, child) {
          // Shows error if something went wrong
          if (timerModel.status == Status.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(timerModel.errorMessage)));
          }

          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Log your study session",
                      style: TextStyle(fontSize: textsize[settings.size])),
                ),
                const Watch(),
                Wrap(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextButton(
                        buttonText: "Reset",
                        textColor: Colors.black,
                        backgroundColor:
                            const Color.fromARGB(255, 216, 199, 221),
                        rectangleShape: true,
                        width: buttonWidth[settings.size],
                        onPressed: () {
                          timerModel.resetTimer(watchModel);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextButton(
                        buttonText: (watchModel.stopwatch.isRunning)
                            ? "Pause"
                            : "Start",
                        textColor: Colors.white,
                        backgroundColor: (watchModel.stopwatch.isRunning)
                            ? const Color.fromARGB(255, 218, 116, 109)
                            : const Color.fromARGB(255, 146, 221, 148),
                        rectangleShape: true,
                        width: buttonWidth[settings.size],
                        onPressed: () {
                          timerModel.handleStartStop(watchModel);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyTextButton(
                        buttonText: "Finish",
                        textColor: Colors.black,
                        backgroundColor:
                            const Color.fromARGB(255, 216, 199, 221),
                        rectangleShape: true,
                        width: buttonWidth[settings.size],
                        onPressed: () {
                          // Checking if the time is over 1 minute
                          if (watchModel.stopwatch.elapsed.inSeconds < 60) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Can't save sessions under one minute")));
                          } else {
                            timerModel.finish(
                                token,
                                watchModel,
                                subjectController.text,
                                descriptionController.text);
                          }
                        }),
                  )
                ]),
                const Divider(),
                SizedBox.expand(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextField(
                          labelText: "Subject",
                          controller: subjectController,
                          obscureText: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextField(
                          labelText: "Description",
                          controller: descriptionController,
                          obscureText: false),
                    ),
                  ],
                ))
              ],
            ),
          );
        },
      );
    });
  }
}

/// Displays the elapsed time of the TimerModel
class Watch extends StatelessWidget {
  const Watch({super.key});

  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {"width": 450.0, "height": 225.0},
      Size.medium: {"width": 500.0, "height": 250.0},
      Size.large: {"width": 550.0, "height": 275.0},
    };

    Map textSizes = {
      Size.small: 30.0,
      Size.medium: 40.0,
      Size.large: 50.0,
    };

    return Consumer<WatchModel>(
      builder: (context, watchModel, child) {
        return Consumer<Settings>(
          builder: (context, settings, child) {
            return SizedBox(
              width: sizes[settings.size]["width"],
              height: sizes[settings.size]["height"],
              child: Center(
                child: Text(
                  watchModel.returnFormattedText(),
                  style: TextStyle(fontSize: textSizes[settings.size]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
