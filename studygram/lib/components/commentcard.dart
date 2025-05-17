import 'package:flutter/material.dart';
import 'package:studygram/models/settings_model.dart';
import '../structure.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    Map textsizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};

    return Consumer<Settings>(builder: (context, settings, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(children: [
                  // If you click on the user's name, then go to their profile page
                  GestureDetector(
                    child: Text(comment.username,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: textsizes[settings.size])),
                    onTap: () {
                      context.go('/profile', extra: comment.username);
                    },
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(comment.body,
                        style:
                            TextStyle(fontSize: textsizes[settings.size] - 1)),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
