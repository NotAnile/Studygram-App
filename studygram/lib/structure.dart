// Commented out url for the time being
class User {
  final String username;
  // final String url;
  final List posts;
  final List sessions;
  User(
      {required this.username,
      // required this.url,
      required this.posts,
      required this.sessions});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json["username"],
        // url: json["url"],
        posts: json["posts"].map((json) => Post.fromJson(json)).toList(),
        sessions:
            json["sessions"].map((json) => Session.fromJson(json)).toList());
  }

  static Map<String, dynamic> toJson(User user) {
    return {
      "username": user.username,
      "posts": user.posts.map((post) => Post.toJson(post)).toList()
    };
  }
}

class Post {
  final String body;
  final String username;
  final List comments;
  Post({required this.body, required this.username, required this.comments});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        body: json["body"],
        username: json["username"],
        comments: (json["comments"] == [])
            ? []
            : json["comments"]
                .map((comment) => Comment.fromJson(comment))
                .toList());
  }

  static Map<String, dynamic> toJson(Post post) {
    return {"body": post.body, "username": post.username};
  }
}

class Comment {
  final String body;
  final String username;
  Comment({required this.body, required this.username});
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(body: json["body"], username: json["username"]);
  }

  static Map<String, dynamic> toJson(Comment comment) {
    return {"body": comment.body, "username": comment.username};
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
