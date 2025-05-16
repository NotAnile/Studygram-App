import 'package:flutter/material.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:studygram/components/commentcard.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'postcard.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/authentication.dart';

//**Listview to display all the comments in a column*/
class CommentView extends StatefulWidget {
  final List<dynamic> comments;
  const CommentView({super.key, required this.comments});

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.comments.length,
      itemBuilder: (context, index) {
        Comment comment = widget.comments[index] as Comment;
        // Getting the right post with the index and returns a PostCard with the body and username
        return CommentCard(comment: comment);
      },
    );
  }
}

/// PostView is used to display posts and it extends CommentView which is used for comments.
/// The difference between PostView and CommentView is that PostView also gets the comments
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
    if (widget.selectedUsers != null && widget.excludedUsers != null) {
      Authentication auth = Provider.of<Authentication>(context, listen: false);
      // Getting the posts
      String token = auth.accessToken;

      Dio dio = auth.setupAuthenticatedDio(auth.baseUrl);

      return Consumer<LikeManager>(builder: (context, likeManager, child) {
        return Consumer<Feed>(builder: (context, feed, child) {
          return FutureBuilder(
              future: feed.getPosts(
                  token, widget.selectedUsers!, widget.excludedUsers!, dio),
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
                                  context.push('/post', extra: post.id);
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
                  context.push('/post', extra: post.id);
                }
              },
            );
          },
        );
      }
    }
  }
}
