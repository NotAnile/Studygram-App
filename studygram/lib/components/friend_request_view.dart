import 'package:flutter/material.dart';
import 'package:studygram/models/settings_model.dart';
import 'usercard.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/components/loading_indicator.dart';
import '../models/authentication.dart';

//**Listview to display all the users in a column*/
class FriendRequestView extends StatelessWidget {
  const FriendRequestView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Getting token for the request
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    final request = Provider.of<FriendManager>(context, listen: false)
        .getFriendRequests(token);

    // Gets the textsize
    Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<Settings>(builder: (context, settings, child) {
      return FutureBuilder(
        future: request,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "An error has occurred. Could not get friend requests.",
              style: TextStyle(fontSize: sizes[settings.size]),
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final friendRequests = snapshot.data!;
            if (friendRequests.isEmpty) {
              return Text(
                "No friend requests found.",
                style: TextStyle(fontSize: sizes[settings.size]),
              );
            }
            return Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: friendRequests.length,
                    itemBuilder: (context, index) {
                      // Getting the right user with the index and returns a UserCard with the username
                      return UserCard(username: friendRequests[index]);
                    },
                  )),
            );
          } else {
            return const LoadingIndicator();
          }
        },
      );
    });
  }
}
