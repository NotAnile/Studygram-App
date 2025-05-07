import 'package:flutter/material.dart';
import '../structure.dart';
import '../components/postcard.dart';
import '../components/content_view.dart';
import 'package:go_router/go_router.dart';

//**The page for viewing a single post, including its comments*/
class PostPage extends StatelessWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 151, 115, 156),
          leading: GoRouter.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                )
              : null,
        ),
        body: Center(
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
        )));
  }
}
