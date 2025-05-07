import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import 'package:studygram/structure.dart';
import 'package:studygram/models/settings_model.dart';

//**Page that contains all the posts and followers of a user */
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserModel>(context, listen: false).username;
    Future<dynamic> request =
        Provider.of<Feed>(context, listen: true).getProfile(username);
    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("An error has occured");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          User user = snapshot.data!;
          List posts = user.posts;
          return Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25)),
                        ),
                        NumberedBox(
                            title: "Friends", number: user.friends.length),
                        NumberedBox(title: "Posts", number: user.posts.length),
                      ],
                    )),
                const Divider(),
                posts.isEmpty
                    ? const Text("This user has no posts")
                    : Expanded(child: ContentView(contents: posts))
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
      Size.small: {'width': 300.0, 'height': 30.0},
      Size.medium: {'width': 400.0, 'height': 40.0},
      Size.large: {'width': 500.0, 'height': 50.0}
    };

    return Consumer<Settings>(
      builder: (context, model, state) {
        return SizedBox(
          width: sizes[model.size]['width'] ?? sizes[Size.medium]['width'],
          height: sizes[model.size]['height'] ?? sizes[Size.medium]['height'],
          child: Column(
            children: [
              Row(
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))
                ],
              ),
              Row(
                children: [
                  Text("$number",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
