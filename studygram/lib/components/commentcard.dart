import 'package:flutter/material.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/settings_model.dart';
import '../structure.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/post_page_model.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/components/delete_button.dart';
import 'package:studygram/models/url.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    Map textsizes = {Size.small: 12.0, Size.medium: 14.0, Size.large: 16.0};
    String username = Provider.of<UserModel>(context, listen: false).username;

    return Consumer<Settings>(builder: (context, settings, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // If you click on the user's name, then go to their profile page
                      GestureDetector(
                        child: Text(comment.username,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: textsizes[settings.size])),
                        onTap: () {
                          context.go('/profile', extra: comment.username);
                        },
                      ),
                      // Checking if we own the comment, and if so display a delete button
                      (username == comment.username)
                          ? DeleteButton(onPressed: () async {
                              String token = Provider.of<Authentication>(
                                      context,
                                      listen: false)
                                  .accessToken;

                              CommentViewModel commentViewModel =
                                  Provider.of<CommentViewModel>(context,
                                      listen: false);
                              Status status = await commentViewModel
                                  .removeComment(token, comment.id);
                              // Showing a snackbar to notify the user about how the login went
                              if (context.mounted) {
                                if (status == Status.success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Succesfully deleted comment")));
                                } else if (status == Status.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (commentViewModel.errorMessage.isEmpty
                                            ? "Unknown error"
                                            : commentViewModel.errorMessage),
                                      ),
                                    ),
                                  );
                                }
                              }
                            })
                          : const Text(""),
                    ]),
                Row(
                  children: [
                    Text(
                      comment.body,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: textsizes[settings.size] - 1),
                    ),
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
