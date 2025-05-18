import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
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
        final request = model.getLikedPosts(token);
        return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("An error has occured"));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              List likedPosts = snapshot.data!;
              return Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostView(posts: likedPosts),
                      ),
                    ),
                  ],
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
