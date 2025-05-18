import 'dart:async';
import 'package:flutter/material.dart';
import 'url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimerModel extends ChangeNotifier {
  String baseUrl = BaseUrl().baseUrl;
  bool _initialized = false;
  String startDate = "";
  String startTime = "";

  Status _status = Status.idle;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;
  Status get status => _status;

  /// Sets the start date and start time for the study session
  void initialize() {
    if (!_initialized) {
      _initialized = true;
      startDate = getCurrentDate();
      startTime = getCurrentTime();
    }
  }

  /// Gets the current date in the format DD/MM/YY
  String getCurrentDate() {
    final now = DateTime.now();

    String day = now.day.toString().padLeft(2, "0");
    String month = now.month.toString().padLeft(2, "0");
    int year = now.year;

    return "$year-$month-$day";
  }

  /// Gets the current time as hours and minutes in the format HH:MM
  String getCurrentTime() {
    final now = DateTime.now();

    String hour = now.hour.toString().padLeft(2, "0");
    String minute = now.minute.toString().padLeft(2, "0");

    return "$hour:$minute:00";
  }

  /// Stops or starts the watchmodel, as well as initializes the timermodel
  /// if the timermodel isn't initialized
  void handleStartStop(WatchModel watchModel) {
    if (!_initialized) {
      initialize();
    }
    watchModel.handleStartStop();
    notifyListeners();
  }

  /// Resets the timer
  void resetTimer(WatchModel watchModel) {
    startDate = "";
    startTime = "";
    watchModel.reset();
    _initialized = false;
    notifyListeners();
  }

  void finish(String token, WatchModel watchModel, String subject,
      String description) async {
    watchModel.stopwatch.stop();
    // Sends data to server about the finished session
    // Creating a JSON to send to the server
    final response = await http.post(
      Uri.parse("$baseUrl/session/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(
        {
          'startdate': startDate,
          'starttime': startTime,
          'enddate': getCurrentDate(),
          'endtime': getCurrentTime(),
          'subject': subject,
          'description': description
        },
      ),
    );

    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      resetTimer(watchModel);
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}

class WatchModel extends ChangeNotifier {
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        notifyListeners();
      },
    );
  }

  /// Stops the stopwatch and the timer, and creates a new stopwatch instance.
  void reset() {
    stopwatch.stop();
    timer.cancel();
    stopwatch = Stopwatch();
    notifyListeners();
  }

  /// Starts or stops the stopwatch depending on whether or not it is running.
  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      timer.cancel();
    } else {
      startTimer();
      stopwatch.start();
    }
  }

  /// Returns the elapsed time in the format HH:MM:SS
  String returnFormattedText() {
    var elapsed = stopwatch.elapsed.inSeconds;

    String seconds = (elapsed % 60).toString().padLeft(2, "0");
    String minutes = ((elapsed ~/ 60) % 60).toString().padLeft(2, "0");
    String hours = ((elapsed ~/ 3600) % 60).toString().padLeft(2, "0");

    return "$hours:$minutes:$seconds";
  }

  /// Returns a formated string of the elapsed time in hours and minutes.
  String getElapsedTime() {
    var elapsed = stopwatch.elapsed.inSeconds;

    String minutes = ((elapsed ~/ 60) % 60).toString().padLeft(2, "0");
    String hours = ((elapsed ~/ 3600) % 60).toString().padLeft(2, "0");

    return "$hours:$minutes";
  }
}
