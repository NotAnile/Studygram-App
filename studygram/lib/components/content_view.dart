import 'package:flutter/material.dart';
import 'package:studygram/components/commentcard.dart';
import 'postcard.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';

//**Listview to display all the comments in a column*/
class CommentView extends StatefulWidget {
  final List<dynamic> comments;
  const CommentView({super.key, required this.comments});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        Comment comment = widget.comments[index] as Comment;
        // Getting the right post with the index and returns a PostCard with the body and username
        return CommentCard(comment: comment);
      },
    );
  }
}

/// PostView is used to display posts and it extends CommentView which is used for comments.
/// The difference between PostView and CommentView is that PostView also gets the comments
class PostView extends StatefulWidget {
  final List<dynamic> posts;
  const PostView({super.key, required this.posts});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Feed>(builder: (context, feed, child) {
      return ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          Post post = widget.posts[index];
          // Getting the right post with the index and returns a PostCard with the body and username
          return GestureDetector(
            child: PostCard(post: post),
            onTap: () async {
              // Sending the post as the extra parameter when navigating to the specific post page
              if (context.mounted) {
                context.push('/post', extra: post.id);
              }
            },
          );
        },
      );
    });
  }
}
