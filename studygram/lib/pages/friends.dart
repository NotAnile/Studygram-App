import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/user_view.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:studygram/models/friends_page_model.dart';

class FriendsPage extends StatelessWidget {
  final String username;
  const FriendsPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).primaryColorLight;
    Color selectedButtonColor = Theme.of(context).primaryColor;
    return Consumer<FriendsPageModel>(builder: (context, model, child) {
      bool seeFriends = model.seeFriends;
      // The user can choose to see the posts of the people they follow or are friends with (mutuals)
      void toggleMode(bool newSeeFriends) {
        // Changes the value iff the new value is different from
        // the current one
        if (seeFriends != newSeeFriends) {
          model.setSeeFriends(!seeFriends);
        }
      }

      return Scaffold(
        appBar: getMyAppBar(
            context,
            // If seeFriends is true, display text for friends
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
                    backgroundColor:
                        seeFriends ? selectedButtonColor : buttonColor,
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
                    backgroundColor:
                        seeFriends ? buttonColor : selectedButtonColor,
                    rectangleShape: true,
                    onPressed: () {
                      // Sets seeFriends to false if it is true
                      toggleMode(false);
                    }),
              )
            ]),
            const Divider(),
            // Displays the users
            UserView(
              username: username,
              seeFriends: seeFriends,
            ),
          ]),
        ),
      );
    });
  }
}
