import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/post_view.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/components/loading_indicator.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LikeManager>(
      builder: (context, model, child) {
        String token =
            Provider.of<Authentication>(context, listen: false).accessToken;

        // Getting the users liked posts
        final request = model.getLikedPosts(token);
        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            AppBar myAppBar = getMyAppBar(
                context,
                Text("Liked posts",
                    style: TextStyle(
                      color: Theme.of(context).highlightColor,
                    )));
            if (snapshot.hasError) {
              return Scaffold(
                  appBar: myAppBar,
                  body: const Center(child: Text("An error has occured")));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List likedPosts = snapshot.data!;
              return Scaffold(
                  appBar: myAppBar,
                  body: Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            // Displaying the posts with a PostView
                            child: PostView(posts: likedPosts),
                          ),
                        ),
                      ],
                    ),
                  ));
            } else {
              return Scaffold(
                appBar: myAppBar,
                body: const LoadingIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
