import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/components/follow_button.dart';
import 'package:go_router/go_router.dart';

/// A card that consists of a username and a follow/unfollow button
/// which takes you to their profile page when clicked.
class UserCard extends StatefulWidget {
  final String username;
  const UserCard({super.key, required this.username});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, state) {
      Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.username,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: sizes[settings.size])),
                      // Follow/unfollow button
                      FollowButton(username: widget.username)
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Go to the user's profile when clicking on it
          onTap: () {
            context.go('/profile', extra: widget.username);
          },
        ),
      );
    });
  }
}
