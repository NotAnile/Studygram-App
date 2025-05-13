import 'package:flutter/material.dart';
import '../components/content_view.dart';
import '../structure.dart';
import '../models/feed.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'package:studygram/components/textbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = const Color.fromARGB(255, 151, 115, 156);
    FeedScreen feed = FeedScreen();
    return const Center(
        child: Column(
      children: [
        Row(children: [
          MyTextButton(
              buttonText: "Following",
              textColor: Colors.white,
              backgroundColor: buttonColor,
              rectangleShape: true,
              onPressed: () {feed.toggleMode();}),
          MyTextButton(
              buttonText: "Explore",
              textColor: Colors.white,
              backgroundColor: buttonColor,
              rectangleShape: true,
              onPressed: () {feed.toggleMode();})
        ]),
        Divider(),
        feed,
      ],
    ));
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();

  void toggleMode() {
    _FeedScreenState().toggleMode();
  }
}

class _FeedScreenState extends State<FeedScreen> {
  bool seeFollowing = true;

  void toggleMode() {
    setState(() {
      seeFollowing = !seeFollowing;
    })
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
      // Checking if the usermodel is initalized before showing the feed
      if (!userModel.isInitialized) {
        return const SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(),
        );
      }
      // UserModel is initialized so we can load and show the feed
      String token =
          Provider.of<Authentication>(context, listen: false).accessToken;
      return Consumer<Feed>(
        builder: (context, feed, child) {
          UserModel userModel = Provider.of<UserModel>(context, listen: false);
          List<dynamic> selectedUsers = seeFollowing ? userModel.friends : [];
          List<dynamic> excludedUsers = seeFollowing ? [userModel.username] : userModel.friends.add(userModel.username);
          return FutureBuilder(
            future: feed.getPosts(token, selectedUsers, excluded_users),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    "An error has occurred. Could not get posts.");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data!;
                return Column(
                  children: [
                    // Creates a list view to display all the posts
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: (data.isEmpty)
                            ? const Text("No posts found")
                            : PostView(contents: data),
                      ),
                    )
                  ],
                );
              } else {
                return const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      );
    });
  }
}
