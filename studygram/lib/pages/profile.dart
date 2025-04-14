import 'package:flutter/material.dart';
import 'package:studygram/components/postview.dart';
import '../structure.dart';
import '../data.dart';

//**Page for the current user where you can navigate to own posts,
// liked posts, friends, and session stats */
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
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
  // Lägg till en FutureBuilder här ..........................................................................
  // @override
  // Widget build(BuildContext context) async {
  //   List<dynamic> posts = await Data.getPosts(widget.username);
  //   return Center(child: Column(children: [Expanded(child:PostView(posts: posts))],),);
  // }
}
