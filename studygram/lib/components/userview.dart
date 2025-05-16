import 'package:flutter/material.dart';
import 'package:studygram/models/settings_model.dart';
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

    Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<Settings>(builder: (context, settings, state) {
      return FutureBuilder(
          future: request,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                "An error has occurred. Could not get friends.",
                style: TextStyle(fontSize: sizes[settings.size]),
              ));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final friends = snapshot.data!;
              if (friends.isEmpty) {
                return Text("No friends found. Go touch some grass.",
                    style: TextStyle(fontSize: sizes[settings.size]));
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
    });
  }
}
