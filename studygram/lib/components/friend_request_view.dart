import 'package:flutter/material.dart';
import 'usercard.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/components/loading_indicator.dart';
import '../models/authentication.dart';

//**Listview to display all the users in a column*/
class FriendRequestView extends StatefulWidget {
  const FriendRequestView({
    super.key,
  });

  @override
  State<FriendRequestView> createState() => _FriendRequestViewState();
}

class _FriendRequestViewState extends State<FriendRequestView> {
  @override
  Widget build(BuildContext context) {
    // Getting token for the request
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    final request = Provider.of<FriendManager>(context, listen: false)
        .getFriendRequests(token);

    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text(
                  "An error has occurred. Could not get friend requests."));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final friendRequests = snapshot.data!;
          if (friendRequests.isEmpty) {
            return const Text("No friend requests found.");
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
  }
}
