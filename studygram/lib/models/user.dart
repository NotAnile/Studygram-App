import 'package:studygram/models/content.dart';
import 'package:studygram/models/session.dart';

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
            : [],
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
