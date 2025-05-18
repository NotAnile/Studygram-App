import 'package:intl/intl.dart';

class Session {
  final DateTime starttime;
  final DateTime endtime;
  final int durationAsMinutes;
  final String subject;
  final String description;
  final int id;

  Session(
      {required this.starttime,
      required this.endtime,
      required this.durationAsMinutes,
      required this.subject,
      required this.description,
      required this.id});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        // Parses the starttime and endtime strings from "yyyy-mm-dd hh:mm:ss" to DateTime objects
        starttime: DateTime.parse(json["starttime"]),
        endtime: DateTime.parse(json["endtime"]),
        durationAsMinutes: json["duration_as_minutes"].toInt(),
        subject: json["subject"],
        description: json["description"],
        id: json["id"].toInt());
  }

  static Map<String, dynamic> toJson(Session session) {
    return {
      "starttime": DateFormat('yyyy-MM-dd HH:mm:ss').format(session.starttime),
      "endtime": DateFormat('yyyy-MM-dd HH:mm:ss').format(session.endtime),
      "subject": session.subject,
      "description": session.description
    };
  }

  /// Converts the date from the DateTime object into the format yyyy-MM-dd
  String getFormattedDate(DateTime date) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  /// Converts the time from the DateTime object into the format HH:mm
  String getFormattedTime(DateTime time) {
    final String formattedTime = DateFormat('HH:mm').format(time);
    return formattedTime;
  }

  /// Converts the duration time which is in minutes into both hours and minutes
  String getFormattedDuration(int durationAsMinutes) {
    int minutes = durationAsMinutes % 60;
    int hours = durationAsMinutes ~/ 60;

    return "$hours h $minutes mins";
  }
}
