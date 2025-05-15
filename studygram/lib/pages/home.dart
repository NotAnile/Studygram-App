import 'package:flutter/material.dart';
import 'package:studygram/models/like_manager.dart';
import '../components/content_view.dart';
import '../structure.dart';
import '../models/feed.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'package:studygram/components/textbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool seeFollowing = true;

  // The user can choose to see the posts of the people they follow or explore
  void toggleMode(bool following) {
    if (seeFollowing != following) {
      setState(() {
        seeFollowing = !seeFollowing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LikeManager>(builder: (context, likeManager, child) {
      return Consumer<UserModel>(builder: (context, userModel, child) {
        Color buttonColor = const Color.fromARGB(255, 151, 115, 156);
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
            UserModel userModel =
                Provider.of<UserModel>(context, listen: false);
            List<dynamic> selectedUsers = seeFollowing ? userModel.friends : [];
            List<dynamic> excludedUsers = [userModel.username];
            // Excludes the users friend if the togg
            if (seeFollowing) {
              userModel.friends.add(userModel.username);
            }
            ;
            return FutureBuilder(
              future: feed.getPosts(token, selectedUsers, excludedUsers),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child:
                          Text("An error has occurred. Could not get posts."));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextButton(
                                  buttonText: "Following",
                                  textColor: Colors.white,
                                  backgroundColor: buttonColor,
                                  rectangleShape: true,
                                  onPressed: () {
                                    // Sets seeFollowing to true if it is false
                                    toggleMode(true);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyTextButton(
                                  buttonText: "Explore",
                                  textColor: Colors.white,
                                  backgroundColor: buttonColor,
                                  rectangleShape: true,
                                  onPressed: () {
                                    // Sets seeFollowing to false if it is true
                                    toggleMode(false);
                                  }),
                            )
                          ]),
                      const Divider(),
                      // Creates a list view to display all the posts
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
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
    });
  }
}
