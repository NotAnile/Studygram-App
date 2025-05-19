import 'package:flutter/material.dart';
import 'package:studygram/components/loading_indicator.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/url.dart';
import '../components/content_view.dart';
import '../models/feed.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/components/user_search_bar.dart';

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
    return Consumer<UserModel>(builder: (context, userModel, child) {
      Color buttonColor = Theme.of(context).primaryColor;
      // Checking if the usermodel is initalized before showing the feed
      if (!userModel.isInitialized) {
        // Tries to initialize if something went wrong with initialization
        if (userModel.status == Status.error) {
          String token =
              Provider.of<Authentication>(context, listen: false).accessToken;
          userModel.initialize(token);
        }
        return const LoadingIndicator();
      }

      return Consumer<Feed>(builder: (context, feed, child) {
        // Shows snackbar if anything went wrong
        if (feed.status == Status.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(feed.errorMessage)));
        }

        // Creating a list with the user's friends and their own username
        List<dynamic> following = userModel.friends;
        following.add(userModel.username);
        // Getting the users that we want to display on the feed
        List<dynamic> selectedUsers = seeFollowing ? following : [];
        List<dynamic> excludedUsers = [];
        // Excludes the user's following list if the toggleMode is on Explore
        if (!seeFollowing) {
          excludedUsers = following;
        }

        return Column(
          children: [
            Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyTextButton(
                    buttonText: "Following",
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
                    backgroundColor: buttonColor,
                    rectangleShape: true,
                    onPressed: () {
                      // Sets seeFollowing to false if it is true
                      toggleMode(false);
                    }),
              )
            ]),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: UserSearchBar(),
            ),
            const Divider(),
            // Creates a list view to display all the posts
            PostView(
              posts: const [],
              selectedUsers: selectedUsers,
              excludedUsers: excludedUsers,
            ),
          ],
        );
      });
    });
  }
}
