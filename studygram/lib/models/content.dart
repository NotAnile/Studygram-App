/// Abstract class for posts and comments
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
  // Inherits the body and username from the Tile class
  Post(
      {required super.body,
      required super.username,
      required this.comments,
      required this.isLiked,
      required super.id,
      required this.likeCount});

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
