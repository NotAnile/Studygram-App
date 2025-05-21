import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/structure.dart';
import '../components/post_card.dart';
import 'package:studygram/components/textfield.dart';
import 'package:studygram/models/authentication.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/comment_view_model.dart';
import 'package:studygram/components/comment_card.dart';
import 'package:studygram/components/loading_indicator.dart';
import '../models/feed.dart';
import 'package:studygram/models/settings_model.dart';

/// The page for viewing a single post, including its comments
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
      // Controller for comment
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
              // Creating a post card with the post we want to display
              PostCard(post: post),
              const Divider(),
              // Displaying the comments for this specific post
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
                      // Textfield to write a comment
                      child: MyTextField(
                          labelText: "Comment your thoughts",
                          controller: commentController,
                          obscureText: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // Button to submit the comment
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

/// Listview to display all the comments in a post
class CommentView extends StatelessWidget {
  final int postID;
  const CommentView({super.key, required this.postID});

  @override
  Widget build(BuildContext context) {
    Map textSize = {Size.small: 14.0, Size.medium: 16.0, Size.large: 18.0};
    Settings settings = Provider.of<Settings>(context, listen: false);

    return Consumer<CommentViewModel>(
      builder: (context, model, child) {
        // Getting the access token
        String token =
            Provider.of<Authentication>(context, listen: false).accessToken;
        Feed feed = Provider.of<Feed>(context, listen: false);
        // Getting the comments from the backend
        Future<dynamic> request = feed.getComments(postID, token);
        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            // Checking for errors
            if (snapshot.hasError) {
              String errorMessage = feed.errorMessage;
              return Center(
                  child: Text(
                errorMessage.isEmpty
                    ? "An error has occurred. Could not get post."
                    : errorMessage,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: textSize[settings.size]),
              ));
            }
            // No errors occured so display comments if the list isn't empty
            if (snapshot.connectionState == ConnectionState.done) {
              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return Expanded(
                    child: Text("No comments yet",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: textSize[settings.size])));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    // Getting the right comment with the index and returns a CommentCard with the body and username
                    Comment comment = comments[index] as Comment;
                    return CommentCard(comment: comment);
                  },
                ),
              );
            } else {
              return const LoadingIndicator();
            }
          },
        );
      },
    );
  }
}
