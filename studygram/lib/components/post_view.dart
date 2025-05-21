import 'package:flutter/material.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/models/create_post_model.dart';
import 'post_card.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/settings_model.dart';

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
              return Consumer<CreatePostModel>(
                  builder: (context, model, child) {
                // FutureBuilder to handle to UI when fetching posts from the server
                return FutureBuilder(
                  // Selected users are the users we want to get the posts from
                  future: feed.getPosts(token, selectedUsers!, excludedUsers!),
                  builder: (context, snapshot) {
                    // Error handling if the request got an error
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        "An error has occurred. Could not get posts.",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: textSize[settings.size]),
                      ));
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      final posts = snapshot.data!;
                      // Shows a text if no posts are found
                      if (posts.isEmpty) {
                        return Text("No posts found",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: textSize[settings.size]));
                      }
                      // Listview of all posts
                      return Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
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
              });
            },
          );
        },
      );
    } else {
      // The wiget recieved posts to display so no call to the server is needed
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
