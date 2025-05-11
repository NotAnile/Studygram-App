import 'package:flutter/material.dart';
import '../components/content_view.dart';
import '../structure.dart';
import '../models/feed.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    return Consumer<Feed>(
      builder: (context, feed, child) {
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        List<dynamic> selectedUsers = userModel.friends;
        return FutureBuilder(
          future: feed.getPosts(token, selectedUsers, [userModel.username]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text("An error has occurred. Could not get posts."));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data!;
              return Center(
                child: Column(
                  children: [
                    // Creates a list view to display all the posts
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: PostView(contents: data),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
