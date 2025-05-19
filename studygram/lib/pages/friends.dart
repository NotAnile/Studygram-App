import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/userview.dart';
import 'package:studygram/components/textbutton.dart';

class FriendsPage extends StatefulWidget {
  final String username;
  const FriendsPage({super.key, required this.username});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool seeFriends = false;

  // The user can choose to see the posts of the people they follow or explore
  void toggleMode(bool following) {
    if (seeFriends != following) {
      setState(() {
        seeFriends = !seeFriends;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: getMyAppBar(
          context,
          Text(
            seeFriends ? "Friends" : "Following",
            style: TextStyle(
              color: Theme.of(context).highlightColor,
            ),
          )),
      body: Center(
        child: Column(children: [
          Wrap(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextButton(
                  buttonText: "Friends",
                  backgroundColor: buttonColor,
                  rectangleShape: true,
                  onPressed: () {
                    // Sets seeFriends to true if it is false
                    toggleMode(true);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextButton(
                  buttonText: "Following",
                  backgroundColor: buttonColor,
                  rectangleShape: true,
                  onPressed: () {
                    // Sets seeFriends to false if it is true
                    toggleMode(false);
                  }),
            )
          ]),
          const Divider(),
          UserView(
            username: widget.username,
            seeFriends: seeFriends,
          ),
        ]),
      ),
    );
  }
}
