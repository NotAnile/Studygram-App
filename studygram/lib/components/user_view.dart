import 'package:flutter/material.dart';
import 'package:studygram/models/settings_model.dart';
import 'user_card.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/components/loading_indicator.dart';

/// Listview to display all the users in a column.
/// Clicking on a card in this ListView will navigate
/// to that user's profile page.
/// If the given seeFriends bool is true, it will only display users that
/// the logged in user is friends with, otherwise it will
/// display all users that the logged in user is following.
class UserView extends StatelessWidget {
  final String username;
  final bool seeFriends;
  const UserView({super.key, required this.username, required this.seeFriends});

  @override
  Widget build(BuildContext context) {
    Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    final request = (seeFriends)
        ? Provider.of<FriendManager>(context, listen: false)
            .getFriends(username)
        : Provider.of<FriendManager>(context, listen: false)
            .getFollowing(username);

    return Consumer<FriendManager>(
      builder: (context, friendManagerModel, child) {
        return Consumer<Settings>(
          builder: (context, settings, state) {
            return FutureBuilder(
              future: request,
              builder: (context, snapshot) {
                // Showing the user that something went wrong if the request got an error
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "An error has occurred. Could not get friends.",
                    style: TextStyle(fontSize: sizes[settings.size]),
                  ));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  final friends = snapshot.data!;
                  // Showing a text that says no friends found if the user
                  // does not have any friends.
                  if (friends.isEmpty) {
                    return Text("No users found :(",
                        style: TextStyle(fontSize: sizes[settings.size]));
                  }
                  // Returns a list view with the users since the list of
                  // friends is not empty.
                  return Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            // Getting the right user with the index and returns a UserCard with the username
                            return UserCard(username: friends[index]);
                          },
                        )),
                  );
                } else {
                  // Shows a circular loading indicator if the request is loading.
                  return const LoadingIndicator();
                }
              },
            );
          },
        );
      },
    );
  }
}
