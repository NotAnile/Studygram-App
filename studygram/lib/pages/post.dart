import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/structure.dart';
import '../components/postcard.dart';
import '../components/content_view.dart';
import 'package:studygram/components/textfield.dart';
import 'package:studygram/models/authentication.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/post_page_model.dart';

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
      CommentViewModel model =
          Provider.of<CommentViewModel>(context, listen: false);
      return Scaffold(
        appBar: getMyAppBar(
            context,
            Text(
              "$username's post",
              style: TextStyle(
                color: Theme.of(context).highlightColor,
              ),
            )),
        body: Center(
          child: Column(
            children: [
              PostCard(post: post),
              const Divider(),
              CommentView(
                postID: post.id,
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
                          if (context.mounted) {
                            if (status == Status.error) {
                              // Show snackbar for error message
                              String errorMessage = model.errorMessage;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    (errorMessage.isEmpty
                                        ? "Unknown error: Could not comment."
                                        : errorMessage),
                                  ),
                                ),
                              );
                            } else {
                              // The comment was succesfully added so the controller's text is resetted
                              commentController.text = "";

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Comment succesfully added"),
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
  }
}
