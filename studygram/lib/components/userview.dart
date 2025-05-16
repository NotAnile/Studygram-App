import 'package:flutter/material.dart';
import 'usercard.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/components/loading_indicator.dart';

//**Listview to display all the users in a column*/
class UserView extends StatefulWidget {
  final String username;
  final bool seeFriends;
  const UserView({super.key, required this.username, required this.seeFriends});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    final request = Provider.of<FriendManager>(context, listen: false)
        .getFriends(widget.username);

    return FutureBuilder(
        future: request,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text("An error has occurred. Could not get friends."));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final friends = snapshot.data!;
            if (friends.isEmpty) {
              return const Text("No friends found. Go touch some grass.");
            }
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
            return const LoadingIndicator();
          }
        });
  }
}
