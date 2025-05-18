import 'package:flutter/material.dart';
import 'package:studygram/components/commentcard.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/services/post_page_model.dart';
import 'postcard.dart';
import 'package:go_router/go_router.dart';
import '../models/content.dart';
import '../services/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/services/like_manager.dart';
import 'package:studygram/services/authentication.dart';
import 'package:studygram/services/settings_model.dart';

//**Listview to display all the comments in a column*/
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
        // Getting the post including comments from the backend
        Future<dynamic> request = feed.getComments(postID, token);
        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              String errorMessage = feed.errorMessage;
              return Center(
                  child: Text(
                errorMessage.isEmpty
                    ? "An error has occurred. Could not get post."
                    : errorMessage,
                style: TextStyle(fontSize: textSize[settings.size]),
              ));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return Expanded(
                    child: Text("No comments yet",
                        style: TextStyle(fontSize: textSize[settings.size])));
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
      },
    );
  }
}

/// ListView of posts. If given selectedUsers and excludedUsers, it will get
/// posts from the backend with these parameters. Otherwise it will show the given posts.
class PostView extends StatelessWidget {
  final List<dynamic>? selectedUsers;
  final List<dynamic>? excludedUsers;
  final List<dynamic> posts;
  const PostView(
      {super.key, this.selectedUsers, this.excludedUsers, required this.posts});

  @override
  Widget build(BuildContext context) {
    Map textSize = {Size.small: 14.0, Size.medium: 16.0, Size.large: 18.0};
    // Getting the settings for textsize
    Settings settings = Provider.of<Settings>(context, listen: false);
    // Getting the posts from backend with these parameters
    if (selectedUsers != null && excludedUsers != null) {
      String token =
          Provider.of<Authentication>(context, listen: false).accessToken;

      return Consumer<LikeManager>(
        builder: (context, likeManager, child) {
          return Consumer<Feed>(
            builder: (context, feed, child) {
              return FutureBuilder(
                future: feed.getPosts(token, selectedUsers!, excludedUsers!),
                builder: (context, snapshot) {
                  // Error handling if the request got an error
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "An error has occurred. Could not get posts.",
                      style: TextStyle(fontSize: textSize[settings.size]),
                    ));
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    final posts = snapshot.data!;
                    // Shows a text if no posts are found
                    if (posts.isEmpty) {
                      return Text("No posts found",
                          style: TextStyle(fontSize: textSize[settings.size]));
                    }
                    // Listview of all posts
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
                        ),
                      ),
                    );
                  } else {
                    // The request is still loading
                    return const LoadingIndicator();
                  }
                },
              );
            },
          );
        },
      );
    } else {
      // We recieved posts to display
      if (posts.isEmpty) {
        return Text("No posts found",
            style: TextStyle(fontSize: textSize[settings.size]));
      } else {
        return ListView.builder(
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
        );
      }
    }
  }
}
