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
    TimerModel timerModel = Provider.of<TimerModel>(context, listen: true);
    Stopwatch stopwatch = timerModel.stopwatch;

    return Consumer<TimerModel>(
      builder: (context, timerModel, child) {
        return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Watch(),
              ),
              Wrap(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                      buttonText: "Reset",
                      textColor: Colors.white,
                      backgroundColor: (stopwatch.isRunning)
                          ? const Color.fromARGB(255, 218, 116, 109)
                          : const Color.fromARGB(255, 146, 221, 148),
                      rectangleShape: true,
                      onPressed: () {
                        timerModel.resetTimer();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                      buttonText: (stopwatch.isRunning) ? "Pause" : "Start",
                      textColor: Colors.white,
                      backgroundColor: (stopwatch.isRunning)
                          ? const Color.fromARGB(255, 218, 116, 109)
                          : const Color.fromARGB(255, 146, 221, 148),
                      rectangleShape: true,
                      onPressed: () {
                        timerModel.handleStartStop();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextButton(
                      buttonText: "Finish",
                      textColor: Colors.white,
                      backgroundColor: Colors.indigoAccent,
                      rectangleShape: true,
                      onPressed: () {
                        timerModel.finish(token);
                      }),
                )
              ]),
            ],
          ),
        );
      },
    );
  }
}

/// Class for the timer
class Watch extends StatefulWidget {
  const Watch({super.key});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {"width": 500.0, "height": 250.0},
      Size.medium: {"width": 600.0, "height": 300.0},
      Size.large: {"width": 700.0, "height": 350.0},
    };

    Map textSizes = {
      Size.small: 20.0,
      Size.medium: 25.0,
      Size.large: 30.0,
    };

    return Consumer<TimerModel>(
      builder: (context, timerModel, child) {
        return Consumer<Settings>(
          builder: (context, settings, child) {
            return SizedBox(
              width: sizes[settings.size]["width"],
              height: sizes[settings.size]["height"],
              child: Center(
                child: Text(
                  timerModel.returnFormattedText(),
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
