// Commented out url for the time being
class User {
  String username;
  // final String url;
  List posts;
  List sessions;
  List friends;
  List friendRequests;
  User(
      {required this.username,
      // required this.url,
      required this.posts,
      required this.sessions,
      required this.friends,
      required this.friendRequests});
  // Converts a Map (decoded JSON) into a User object.
  // .fromJson allows you to create a User object from a JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json["username"],
        // url: json["url"],
        posts: json["posts"].map((json) => Post.fromJson(json)).toList(),
        sessions: json["sessions"] != null
            ? json["sessions"].map((json) => Session.fromJson(json)).toList()
            : [],
        friends: json['friends'],
        friendRequests: json['friend_requests']);
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

abstract class Content {
  final String body;
  final String username;
  final int id;
  Content({required this.body, required this.username, required this.id});
}

class Post extends Content {
  final List comments;
  bool isLiked;
  // Inherits the body and username from the Tile class
  Post({
    required super.body,
    required super.username,
    required this.comments,
    required this.isLiked,
    required super.id,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
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
        isLiked: json["isLiked"]);
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

class Session {
  final String starttime;
  final String endtime;
  final String startdate;
  final String username;
  final String subject;
  final String description;

  Session(
      {required this.starttime,
      required this.endtime,
      required this.startdate,
      required this.username,
      required this.subject,
      required this.description});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        starttime: json["starttime"],
        endtime: json["endtime"],
        startdate: json["startdate"],
        username: json["username"],
        subject: json["subject"],
        description: json["description"]);
  }

  static Map<String, dynamic> toJson(Session session) {
    return {
      "starttime": session.starttime,
      "endtime": session.endtime,
      "startdate": session.startdate,
      "username": session.username,
      "subject": session.subject,
      "description": session.description
    };
  }
}
