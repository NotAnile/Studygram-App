import 'package:intl/intl.dart';

/// This file contains datamodels used in the app.

/// Enum class with statuses for async operations
enum Status {
  idle,
  loading,
  success,
  error,
}

class User {
  String username;
  List posts;
  List sessions;
  List friends;
  List friendRequests;
  User(
      {required this.username,
      required this.posts,
      required this.sessions,
      required this.friends,
      required this.friendRequests});
  // Converts a Map (decoded JSON) into a User object.
  // .fromJson allows you to create a User object from a JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json["username"],
        posts: json["posts"].map((json) => Post.fromJson(json)).toList(),
        sessions: json["sessions"] != null
            ? json["sessions"].map((json) => Session.fromJson(json)).toList()
            : [], // If the user has no sessions, then use an empty list
        friends: json['friends'] ?? [],
        friendRequests: json['friend_requests'] ?? []);
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      "username": user.username,
      "posts": user.posts.map((post) => Post.toJson(post)).toList(),
      "friends": user.friends,
      "friend_requests": user.friendRequests
    };
  }
}

// The content class has the basics fields for a post and comment
abstract class Content {
  final String body;
  final String username;
  final int id;
  Content({required this.body, required this.username, required this.id});
}

class Post extends Content {
  final List comments;
  bool isLiked;
  int likeCount;
  // Inherits the body, username and id from the Content class
  Post(
      {required super.body,
      required super.username,
      required this.comments,
      required this.isLiked,
      required super.id,
      required this.likeCount});

  factory Post.fromJson(Map<String, dynamic> json) {
    // If the id is a string, then we want to parse it to an int
    bool parseToInt = json['id'] is String;

    return Post(
        id: parseToInt ? int.parse(json['id']) : json['id'],
        body: json["body"],
        username: json["username"],
        comments: (json["comments"] == null)
            ? []
            : json["comments"]
                .map((comment) => Comment.fromJson(comment))
                .toList(),
        isLiked: json["isLiked"],
        likeCount: json["like_count"]);
  }

  static Map<String, dynamic> toJson(Post post) {
    return {
      "id": post.id,
      "body": post.body,
      "username": post.username,
      "comments":
          post.comments.map((comment) => Comment.toJson(comment)).toList(),
      "isLiked": post.isLiked
    };
  }
}

class Comment extends Content {
  // Inherits the body, username and id from the Content class
  Comment({required super.body, required super.username, required super.id});
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      body: json["message"],
      username: json["username"],
      id: json["id"],
    );
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {
      "message": comment.body,
      "username": comment.username,
      "id": comment.id,
    };
  }
}

/// Datamodel for study sessions.
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
