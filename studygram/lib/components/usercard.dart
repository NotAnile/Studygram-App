import 'package:flutter/material.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:go_router/go_router.dart';

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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  // Follow/unfollow button
                  MyTextButton(
                    // Changing the buttontext depending on if the user
                    // has already followed the person in this page or not
                    buttonText: (!userModel.following.contains(widget.username))
                        ? 'Follow'
                        : 'Unfollow',
                    textColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 191, 152, 197),
                    rectangleShape: true,
                    onPressed: () {
                      // Checking if the user is following the person already or not
                      // to make the right call to backend to either follow or unfollow
                      if (userModel.following.contains(widget.username)) {
                        friendManagerModel.addFriend(context, widget.username);

                        // Add the person that the user wants to follow to the following list
                        userModel.followUser(widget.username);
                      } else {
                        friendManagerModel.removeFriend(
                            context, widget.username);
                        userModel.unfollowUser(widget.username);
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
          context.push('/profile', extra: widget.username);
        },
      ),
    );
  }
}
