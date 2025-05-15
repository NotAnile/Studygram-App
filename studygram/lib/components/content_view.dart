import 'package:flutter/material.dart';
import 'postcard.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';

//**Listview to display all the comments in a column*/
class ContentView extends StatefulWidget {
  final List<dynamic> contents;
  const ContentView({super.key, required this.contents});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contents.length,
      itemBuilder: (context, index) {
        // Getting the right post with the index and returns a PostCard with the body and username
        return PostCard(post: widget.contents[index]);
      },
    );
  }
}

/// PostView is used to display posts and it extends ContentView which is used for comments.
/// The difference between PostView and ContentView is that PostView also gets the comments
class PostView extends ContentView {
  const PostView({super.key, required super.contents});

  @override
  State<ContentView> createState() => _PostViewState();
}

class _PostViewState extends State<ContentView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Feed>(builder: (context, feed, child) {
      return ListView.builder(
        itemCount: widget.contents.length,
        itemBuilder: (context, index) {
          Post post = widget.contents[index];
          // Getting the right post with the index and returns a PostCard with the body and username
          return GestureDetector(
            child: PostCard(post: post),
            onTap: () async {
              // Getting the comments for the post with that ID
              int postID = post.id;

              // Getting the access token
              String token = Provider.of<Authentication>(context, listen: false)
                  .accessToken;
              // Getting the post including comments from the backend
              Post postWithComments =
                  await Provider.of<Feed>(context, listen: false)
                      .getPost(postID, token);
              // Sending the post as the extra parameter when navigating to the specific post page
              if (context.mounted) {
                context.push('/post', extra: postWithComments);
              }
            },
          );
        },
      );
    });
  }
}
