import 'package:flutter/material.dart';
import '../structure.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/authentication.dart';
import 'package:go_router/go_router.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    String accessToken =
        Provider.of<Authentication>(context, listen: false).accessToken;
    bool isLiked = widget.post.isLiked;
    int likeCount = widget.post.likeCount;

    void handleLike(bool liked) {
      setState(() {
        isLiked = !isLiked;
        // Updates like count
        if (liked) {
          likeCount += 1;
        } else {
          likeCount -= 1;
        }
      });
    }

    return Consumer<LikeManager>(builder: (context, likeManager, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        // Likes the post when user double taps on card
        // if they haven't already liked it
        child: GestureDetector(
          onDoubleTap: () {
            if (!isLiked) {
              likeManager.likePost(accessToken, widget.post);
              handleLike(true);
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(children: [
                    // If you click on the user's name, then go to their profile page
                    GestureDetector(
                      child: Text(widget.post.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      onTap: () {
                        context.go('/profile');
                      },
                    ),
                  ]),
                  Row(
                    children: [
                      // The post's body/message
                      Flexible(
                        // Makes the text wrap so it doesn't overflow
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.post.body,
                            softWrap: true,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$likeCount",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // Heart icon
                      // Likes or removes the like on a single tap on the heart icon
                      GestureDetector(
                        onTap: () {
                          if (!isLiked) {
                            likeManager.likePost(accessToken, widget.post);
                            handleLike(true);
                          } else {
                            likeManager.unlikePost(accessToken, widget.post);
                            handleLike(false);
                          }
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked
                              ? const Color.fromARGB(255, 233, 107, 98)
                              : Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
