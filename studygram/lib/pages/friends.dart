import 'package:flutter/material.dart';
import 'package:studygram/components/appbar.dart';
import 'package:studygram/components/textarea.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:provider/provider.dart';
import 'package:studygram/components/content_view.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/models/user.dart';
import '../models/settings_model.dart';

class FriendsPage extends StatelessWidget {
  final List<dynamic> friends;
  const FriendsPage({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserModel>(context, listen: false).username;
    return Scaffold(
      appBar: getMyAppBar(
          context,
          Text(
            "$username's friends",
            style: const TextStyle(color: Colors.white),
          )),
      body: Center(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UserView(users: friends),
            ),
          ),
        ]),
      ),
    );
  }
}
