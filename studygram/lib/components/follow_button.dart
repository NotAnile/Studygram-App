import 'package:flutter/material.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/structure.dart';

/// Button for following/unfollowing people that shows the text
/// "Following" or "Unfollowing" depending on whether the logged in
/// user is following the given username or not.
class FollowButton extends StatelessWidget {
  final String username;
  const FollowButton({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    Map textSizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<FriendManager>(
        builder: (context, friendManagerModel, child) {
      return MyTextButton(
        // Changing the buttontext depending on if the user
        // has already followed the person in this page or not
        buttonText:
            (!userModel.following.contains(username)) ? 'Follow ' : 'Unfollow',
        backgroundColor: Theme.of(context).primaryColor,
        rectangleShape: true,
        onPressed: () async {
          // Checking if the user is following the person already or not
          // to make the right call to backend to either follow or unfollow
          Status status;
          if (!userModel.following.contains(username)) {
            status = await friendManagerModel.addFriend(context, username);
          } else {
            status = await friendManagerModel.removeFriend(context, username);
          }
          // Shows snackbar to show user that something went wrong with
          if (status == Status.error && context.mounted) {
            Settings settings = Provider.of<Settings>(context, listen: false);

            String errorMessage = friendManagerModel.errorMessage;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (errorMessage.isEmpty ? "Unknown error" : errorMessage),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: textSizes[settings.size]),
                ),
              ),
            );
          }
        },
      );
    });
  }
}
