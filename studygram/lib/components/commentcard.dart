import 'package:flutter/material.dart';
import '../structure.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class CommentCard extends StatefulWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    // String accessToken =
    //     Provider.of<Authentication>(context, listen: false).accessToken;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(children: [
                // If you click on the user's name, then go to their profile page
                Text(widget.comment.username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.comment.body,
                      style: const TextStyle(fontSize: 13)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
