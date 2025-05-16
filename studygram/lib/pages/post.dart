import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/structure.dart';
import '../components/postcard.dart';
import '../components/content_view.dart';
import 'package:studygram/components/textfield.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/post_page_model.dart';
import 'package:studygram/models/url.dart';

//**The page for viewing a single post, including its comments*/
class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LikeManager>(builder: (context, likeManager, child) {
      Post post = widget.post;
      String username = post.username;

      TextEditingController commentController = TextEditingController();
      return Consumer<PostPageModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: getMyAppBar(
              context,
              Text(
                "$username's post",
                style: const TextStyle(color: Colors.white),
              )),
          body: Center(
            child: Column(
              children: [
                PostCard(post: post),
                const Divider(),
                (post.comments.isEmpty)
                    ? const Expanded(child: Text("No comments yet"))
                    : Expanded(
                        child: CommentView(
                          postID: post.id,
                        ),
                      ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                            labelText: "Comment your thoughts",
                            controller: commentController,
                            obscureText: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextButton(
                          buttonText: "Comment",
                          textColor: Colors.black,
                          backgroundColor:
                              const Color.fromARGB(255, 208, 167, 214),
                          rectangleShape: true,
                          onPressed: () async {
                            // Getting token
                            String token = Provider.of<Authentication>(context,
                                    listen: false)
                                .accessToken;
                            Status status = await model.addComment(
                                token, post.id, commentController.text);
                            if (status == Status.error) {
                              // Show snackbar for error message
                              String errorMessage = model.errorMessage;
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      (errorMessage.isEmpty
                                          ? "Unknown error: Could not comment."
                                          : errorMessage),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          wrapText: true,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
