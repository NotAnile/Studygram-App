import 'package:flutter/material.dart';
import 'package:studygram/components/contentview.dart';
import 'package:studygram/components/navigationcard.dart';
import '../data.dart';

//**Page for the current user where you can navigate to own posts,
// liked posts, friends, and session stats */
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NagivationCard(
                    route: '/', text: 'My posts', icon: Icons.person),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NagivationCard(
                    route: '/', text: 'Friends', icon: Icons.group),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NagivationCard(
                    route: '/', text: 'Liked', icon: Icons.favorite),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NagivationCard(
                    route: '/', text: 'Settings', icon: Icons.settings),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

//**Page that contains all the posts and followers of a user */
class UserProfilePage extends StatefulWidget {
  final String username;
  const UserProfilePage({super.key, required this.username});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> request = Data.getPosts(widget.username);
    return FutureBuilder(
      future: request,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("An error has occured"));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          List<dynamic> posts = snapshot.data!;
          return Center(
            child: Column(
              children: [Expanded(child: ContentView(contents: posts))],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
