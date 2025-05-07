import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(username,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          ),
          const UserPosts()
        ],
      ),
    );
  }
}

class UserPosts extends StatefulWidget {
  const UserPosts({super.key});

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserModel>(context, listen: false).username;
    Future<dynamic> request =
        Provider.of<Feed>(context, listen: true).getPosts(username);
    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("An error has occured");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<dynamic> posts = snapshot.data!;
          return posts.isEmpty
              ? const Text("This user has no posts")
              : Expanded(child: ContentView(contents: posts));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
