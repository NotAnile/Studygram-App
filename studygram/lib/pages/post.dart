import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textbutton.dart';
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
  final int postID;
  const PostPage({super.key, required this.postID});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    // Getting the access token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    Feed feed = Provider.of<Feed>(context, listen: false);
    // Getting the post including comments from the backend
    Future<dynamic> request = feed.getPost(widget.postID, token);

    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          String errorMessage = feed.errorMessage;
          return Center(
              child: Text(errorMessage.isEmpty
                  ? "An error has occurred. Could not get post."
                  : errorMessage));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final post = snapshot.data!;
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
                    (post.comments.isEmpty)
                        ? const Expanded(child: Text("No comments yet"))
                        : Expanded(
                            child: CommentView(
                              comments: post.comments,
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
                                String token = Provider.of<Authentication>(
                                        context,
                                        listen: false)
                                    .accessToken;
                                Status status = await model.addComment(token,
                                    widget.postID, commentController.text);
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
        } else {
          return const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
