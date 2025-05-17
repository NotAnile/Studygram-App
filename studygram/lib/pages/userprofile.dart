import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import 'package:studygram/components/follow_button.dart';
import 'package:studygram/models/authentication.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/structure.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:go_router/go_router.dart';

//**Page that contains all the posts and followers of a specific user */
class UserProfilePage extends StatelessWidget {
  final String username;
  const UserProfilePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    Future<dynamic> request =
        Provider.of<Feed>(context, listen: true).getProfile(username, token);

    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("An error has occured"));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          User user = snapshot.data!;
          List posts = user.posts;

          return Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/friends', extra: user.friends);
                      },
                      child: NumberedBox(
                          title: "Friends", number: user.friends.length),
                    ),
                    NumberedBox(title: "Posts", number: user.posts.length),
                    FollowButton(username: username)
                  ],
                ),
                const Divider(),
                posts.isEmpty
                    ? const Text("This user has no posts")
                    : PostView(
                        posts: const [],
                        selectedUsers: [username],
                        excludedUsers: const [],
                      )
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NumberedBox extends StatelessWidget {
  final String title;
  final int number;
  const NumberedBox({super.key, required this.title, required this.number});

  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {"title": 15.0, "number": 12.5},
      Size.medium: {"title": 20.0, "number": 17.5},
      Size.large: {"title": 25.0, "number": 22.5},
    };

    return Consumer<Settings>(
      builder: (context, model, state) {
        return Column(
          children: [
            Row(
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sizes[model.size]["title"]))
              ],
            ),
            Row(
              children: [
                Text("$number",
                    style: TextStyle(fontSize: sizes[model.size]["number"]))
              ],
            )
          ],
        );
      },
    );
  }
}
