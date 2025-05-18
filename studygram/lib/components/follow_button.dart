import 'package:flutter/material.dart';
import 'package:studygram/services/friend_manager.dart';
import 'package:studygram/services/user.dart';
import 'package:studygram/services/url.dart';
import 'package:studygram/services/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:studygram/components/textbutton.dart';

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
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 191, 152, 197),
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
                  style: TextStyle(fontSize: textSizes[settings.size]),
                ),
              ),
            );
          }
        },
      );
    });
  }
}
