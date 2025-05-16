import 'package:flutter/material.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/url.dart';

/// A card that consists of a username and a follow/unfollow button which takes you to their profile page when clicked.
class UserCard extends StatefulWidget {
  final String username;
  const UserCard({super.key, required this.username});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    FriendManager friendManagerModel =
        Provider.of<FriendManager>(context, listen: false);

    bool isFollowing = userModel.following.contains(widget.username);
    void handleFollow() {
      setState(() {
        isFollowing = !isFollowing;
      });
    }

    return Consumer<Settings>(builder: (context, settings, state) {
      Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: sizes[settings.size])),
                    // Follow/unfollow button
                    MyTextButton(
                      // Changing the buttontext depending on if the user
                      // has already followed the person in this page or not
                      buttonText: (!isFollowing) ? 'Follow' : 'Unfollow',
                      textColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 191, 152, 197),
                      rectangleShape: true,
                      onPressed: () async {
                        Status? status;
                        // Checking if the user is following the person already or not
                        // to make the right call to backend to either follow or unfollow
                        if (!isFollowing) {
                          // Add the person that the user wants to follow to the following list
                          status = await friendManagerModel.addFriend(
                              context, widget.username);
                        } else {
                          status = await friendManagerModel.removeFriend(
                              context, widget.username);
                        }
                        // Checking what status we got
                        if (status == Status.success) {
                          handleFollow();
                        } else {
                          // Showing a snackbar to let the user know that something went wrong whilst handling the follow/unfollow request
                          if (context.mounted) {
                            String errorMessage =
                                friendManagerModel.errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  (errorMessage.isEmpty
                                      ? "Unknown error"
                                      : errorMessage),
                                  style:
                                      TextStyle(fontSize: sizes[settings.size]),
                                ),
                              ),
                            );
                          }
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          // Go to the user's profile when clicking on it
          onTap: () {
            context.go('/profile', extra: widget.username);
          },
        ),
      );
    });
  }
}
