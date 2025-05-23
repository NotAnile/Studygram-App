import 'package:flutter/material.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/models/feed.dart';
import 'package:studygram/models/settings_model.dart';
import '../structure.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/authentication.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/components/delete_button.dart';
import 'package:studygram/models/user.dart';

/// A card to display a post. It consists of a username and a text (body).
class PostCard extends StatelessWidget {
  final int postID;
  const PostCard({super.key, required this.postID});

  @override
  Widget build(BuildContext context) {
    String accessToken =
        Provider.of<Authentication>(context, listen: false).accessToken;
    String username = Provider.of<UserModel>(context, listen: false).username;

    return Consumer<Settings>(builder: (context, settings, child) {
      // Gets the size settings for the textsize
      Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

      return Consumer<LikeManager>(builder: (context, likeManager, child) {
        // Getting the post from the server
        Feed feed = Provider.of<Feed>(context, listen: false);
        String token =
            Provider.of<Authentication>(context, listen: false).accessToken;
        final request = feed.getPost(postID, token);

        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            // Showing the user that something went wrong if the request got an error
            if (snapshot.hasError) {
              // Getting the correct text sizes for the error text
              Map sizes = {
                Size.small: 12.0,
                Size.medium: 14.0,
                Size.large: 16.0
              };
              Settings settings = Provider.of<Settings>(context, listen: false);
              return Center(
                  child: Text(
                "An error has occurred. Could not get friends.",
                style: TextStyle(fontSize: sizes[settings.size]),
              ));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Post post = snapshot.data!;
              int likeCount = post.likeCount;
              bool isLiked = post.isLiked;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                // Likes the post when user double taps on card
                // if they haven't already liked it
                child: GestureDetector(
                  onDoubleTap: () async {
                    if (!isLiked) {
                      await likeManager.likePost(accessToken, post);
                    }
                  },
                  child: Card(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // If you click on the user's name, then go to their profile page
                                GestureDetector(
                                  child: Text(post.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: sizes[settings.size] + 1)),
                                  onTap: () {
                                    context.go('/profile',
                                        extra: post.username);
                                  },
                                ),
                                // Showing a delete button depending on if it's the user's own post or not
                                (username == post.username)
                                    // Deletes the post if the user clicks on button
                                    ? DeleteButton(
                                        onPressed: () async {
                                          Status status = await feed.removePost(
                                              post.id, accessToken);
                                          // Showing a snackbar to notify the user about how the login went
                                          if (context.mounted) {
                                            if (status == Status.success) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Succesfully deleted post")));
                                            } else if (status == Status.error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    (feed.errorMessage.isEmpty
                                                        ? "Unknown error"
                                                        : feed.errorMessage),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      )
                                    : const Text("")
                              ]),
                          Row(
                            children: [
                              // The post's body/message
                              Flexible(
                                // Makes the text wrap so it doesn't overflow
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    post.body,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: sizes[settings.size]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$likeCount",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),

                              // Heart icon
                              // Likes or removes the like on a single tap on the heart icon
                              GestureDetector(
                                onTap: () async {
                                  if (!isLiked) {
                                    await likeManager.likePost(
                                        accessToken, post);
                                  } else {
                                    await likeManager.unlikePost(
                                        accessToken, post);
                                  }
                                },
                                child: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked
                                      ? const Color.fromARGB(255, 233, 107, 98)
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const LoadingIndicator();
            }
          },
        );
      });
    });
  }
}
