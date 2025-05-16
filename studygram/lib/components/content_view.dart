import 'package:flutter/material.dart';
import 'package:studygram/components/commentcard.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/models/post_page_model.dart';
import 'postcard.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/authentication.dart';

//**Listview to display all the comments in a column*/
class CommentView extends StatefulWidget {
  final int postID;
  const CommentView({super.key, required this.postID});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommentViewModel>(builder: (context, model, child) {
      // Getting the access token
      String token =
          Provider.of<Authentication>(context, listen: false).accessToken;
      Feed feed = Provider.of<Feed>(context, listen: false);
      // Getting the post including comments from the backend
      Future<dynamic> request = feed.getComments(widget.postID, token);
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
            final comments = snapshot.data!;
            if (comments.isEmpty) {
              return const Expanded(child: Text("No comments yet"));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  Comment comment = comments[index] as Comment;
                  // Getting the right post with the index and returns a PostCard with the body and username
                  return CommentCard(comment: comment);
                },
              ),
            );
          } else {
            return const LoadingIndicator();
          }
        },
      );
    });
  }
}

/// ListView of posts. If given selectedUsers and excludedUsers, it will get
/// posts from the backend with these parameters. Otherwise it will show the given posts.
class PostView extends StatefulWidget {
  final List<dynamic>? selectedUsers;
  final List<dynamic>? excludedUsers;
  final List<dynamic> posts;
  const PostView(
      {super.key, this.selectedUsers, this.excludedUsers, required this.posts});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    // Getting the posts from backend with these parameters
    if (widget.selectedUsers != null && widget.excludedUsers != null) {
      String token =
          Provider.of<Authentication>(context, listen: false).accessToken;

      return Consumer<LikeManager>(builder: (context, likeManager, child) {
        return Consumer<Feed>(builder: (context, feed, child) {
          return FutureBuilder(
              future: feed.getPosts(
                  token, widget.selectedUsers!, widget.excludedUsers!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    "An error has occurred. Could not get posts.",
                    style: TextStyle(fontSize: 16.0),
                  ));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final posts = snapshot.data!;

                  if (posts.isEmpty) {
                    return const Text("No posts found",
                        style: TextStyle(fontSize: 16.0));
                  }
                  return Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            Post post = posts[index];
                            // Getting the right post with the index and returns a PostCard with the body and username
                            return GestureDetector(
                              child: PostCard(post: post),
                              onTap: () async {
                                // Sending the post as the extra parameter when navigating to the specific post page
                                if (context.mounted) {
                                  context.push('/post', extra: post);
                                }
                              },
                            );
                          },
                        )),
                  );
                } else {
                  return const LoadingIndicator();
                }
              });
        });
      });
    } else {
      // We recieved posts to display
      if (widget.posts.isEmpty) {
        return const Text("No posts found", style: TextStyle(fontSize: 16.0));
      } else {
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
                  context.push('/post', extra: post);
                }
              },
            );
          },
        );
      }
    }
  }
}
