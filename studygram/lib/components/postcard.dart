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
    LikeManager likeManager = Provider.of<LikeManager>(context, listen: false);
    String accessToken =
        Provider.of<Authentication>(context, listen: false).accessToken;
    bool isLiked = widget.post.isLiked;

    void handleLike() {
      setState(() {
        isLiked = !isLiked;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Likes the post when user double taps on card
      // if they haven't already liked it
      child: GestureDetector(
        onDoubleTap: () {
          if (!isLiked) {
            likeManager.likePost(accessToken, widget.post);
            handleLike();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.post.body,
                        style: const TextStyle(fontSize: 13)),
                    // Likes or removes the like on a single tap on the heart icon
                    GestureDetector(
                      onTap: () {
                        if (!isLiked) {
                          likeManager.likePost(accessToken, widget.post);
                        } else {
                          likeManager.unlikePost(accessToken, widget.post);
                        }
                        handleLike();
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
  }
}
