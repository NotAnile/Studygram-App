import 'package:flutter/material.dart';
import 'usercard.dart';
import 'package:go_router/go_router.dart';
import '../structure.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';

//**Listview to display all the posts in a column*/
class UserView extends StatefulWidget {
  final List<dynamic> friends;
  const UserView({super.key, required this.friends});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friends.length,
      itemBuilder: (context, index) {
        // Getting the right user with the index and returns a UserCard with the username
        return UserCard(username: widget.friends[index]);
      },
    );
  }
}

class FriendsView extends UserView {
  const FriendsView({super.key, required super.friends});

  @override
  State<UserView> createState() => _FriendsViewState();
}

// -------------------------------------------------FIX onTap below
class _FriendsViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.friends.length,
      itemBuilder: (context, index) {
        String username = widget.friends[index];
        // Getting the right username with the index and returns a UserCard with the username
        return GestureDetector(
          child: UserCard(username: username),
          onTap: () async {
            // Getting the comments for the post with that ID
            int postID = post.id;
            // Getting the post including comments from the backend
            Post postWithComments =
                await Provider.of<Feed>(context, listen: false).getPost(postID);
            // Sending the post as the extra parameter when navigating to the specific post page
            if (context.mounted) {
              context.push('/profile', extra: postWithComments);
            }
          },
        );
      },
    );
  }
}
