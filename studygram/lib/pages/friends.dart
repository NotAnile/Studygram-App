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
    Color buttonColor = const Color.fromARGB(255, 151, 115, 156);
    return Scaffold(
      appBar: getMyAppBar(
          context,
          Text(
            seeFriends ? "Friends" : "Following",
            style: const TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextButton(
                  buttonText: "Friends",
                  textColor: Colors.white,
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
                  textColor: Colors.white,
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
            seeMutuals: seeFriends,
          ),
        ]),
      ),
    );
  }
}
