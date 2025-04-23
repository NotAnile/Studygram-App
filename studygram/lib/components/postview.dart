import 'package:flutter/material.dart';
import 'postcard.dart';
import '../structure.dart';

//**Listview to display all the posts in a column*/
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
        // Getting the right post with the index and returns a PostCard with the body and username
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
