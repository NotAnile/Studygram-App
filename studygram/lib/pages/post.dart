import 'package:flutter/material.dart';
import '../structure.dart';
import '../components/postcard.dart';
import '../components/content_view.dart';

//**The page for viewing a single post, including its comments*/
class PostPage extends StatelessWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ContentCard(content: post),
        (post.comments.isEmpty)
            ? const Text("No comments yet")
            : Expanded(
                child: ContentView(
                  contents: post.comments,
                ),
              )
      ],
    ));
  }
}
