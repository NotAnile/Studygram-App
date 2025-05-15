import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/userview.dart';

class FriendsPage extends StatelessWidget {
  final List<dynamic> friends;
  const FriendsPage({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getMyAppBar(
          context,
          const Text(
            "Friends",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(children: [
          friends.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text("Go touch some grass."),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserView(friends: friends),
                  ),
                ),
        ]),
      ),
    );
  }
}
