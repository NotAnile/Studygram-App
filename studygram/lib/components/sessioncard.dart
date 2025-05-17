import 'package:flutter/material.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/components/textbutton.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/url.dart';
import 'package:studygram/structure.dart';

/// A card that consists of a username and a follow/unfollow button which takes you to their profile page when clicked.
class Sessioncard extends StatefulWidget {
  final Session session;
  const Sessioncard({super.key, required this.session});

  @override
  State<Sessioncard> createState() => _SessioncardState();
}

class _SessioncardState extends State<Sessioncard> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    final DateTime starttime = widget.session.starttime;
    final DateTime endtime = widget.session.endtime;

    return Consumer<Settings>(
      builder: (context, settings, state) {
        Map sizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: sizes[settings.size],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
