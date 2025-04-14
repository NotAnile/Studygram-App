import 'package:flutter/material.dart';
import 'postcard.dart';
import '../structure.dart';

class PostView extends StatefulWidget {
  final List<dynamic> posts;
  const PostView({super.key, required this.posts});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        Post post = widget.posts[index];
        String body = post.body;
        String username = post.username;
        return PostCard(
          body: body,
          username: username,
        );
      },
    );
  }
}
