import 'dart:async';
import 'package:flutter/material.dart';
import './url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TimerModel extends ChangeNotifier {
  Stopwatch stopwatch = Stopwatch();
  String baseUrl = BaseUrl().baseUrl;
  bool _initialized = false;
  String startDate = "";
  String startTime = "";

  Status _status = Status.idle;
  String _errorMessage = "";

  String get errorMessage => _errorMessage;
  Status get status => _status;

  late Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    notifyListeners();
  });

  void initialize() {
    if (!_initialized) {
      _initialized = true;
      startDate = getCurrentDate();
      startTime = getCurrentTime();
      notifyListeners();
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

  String getCurrentDate() {
    final now = DateTime.now();

    int day = now.day;
    int month = now.month;
    int year = now.year;

    return "$day/$month/$year";
  }

  String getCurrentTime() {
    final now = DateTime.now();

    String hour = now.hour.toString().padLeft(2, "0");
    String minute = now.minute.toString().padLeft(2, "0");

    return "$hour:$minute";
  }

  Map<String, String> elapsedTimeToJSON() {
    var elapsed = stopwatch.elapsed.inSeconds;

    String minutes = ((elapsed ~/ 60) % 60).toString().padLeft(2, "0");
    String hours = ((elapsed ~/ 3600) % 60).toString().padLeft(2, "0");

    return {"endtime": "$hours:$minutes", "enddate": getCurrentDate()};
  }

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
    notifyListeners();
  }

  void resetTimer() {
    stopwatch = Stopwatch();
    notifyListeners();
  }

  void finish(String token) async {
    // Sends data to server about the finished session
    // Creating a JSON to send to the server
    final response = await http.post(
      Uri.parse("$baseUrl/session/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = result['message'];
    }
    notifyListeners();
  }
}
