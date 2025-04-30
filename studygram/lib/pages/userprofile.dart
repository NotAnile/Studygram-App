import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import '../data.dart';

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
