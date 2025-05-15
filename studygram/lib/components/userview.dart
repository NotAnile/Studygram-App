import 'package:flutter/material.dart';
import 'usercard.dart';

//**Listview to display all the users in a column*/
class UserView extends StatefulWidget {
  final List<dynamic> friends;
  const UserView({super.key, required this.friends});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friends.length,
      itemBuilder: (context, index) {
        // Getting the right user with the index and returns a UserCard with the username
        return UserCard(username: widget.friends[index]);
      },
    );
  }
}
