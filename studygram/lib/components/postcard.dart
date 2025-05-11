import 'package:flutter/material.dart';
import '../structure.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/models/authentication.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class ContentCard extends StatefulWidget {
  final Content content; // Content is a post
  const ContentCard({super.key, required this.content});

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool isLiked = false;

  void handleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String accessToken =
        Provider.of<Authentication>(context, listen: false).accessToken;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Likes the post when user double taps on card
      // if they haven't already liked it
      child: GestureDetector(
        onDoubleTap: () {
          if (!userModel.likedPosts.contains(widget.content)) {
            userModel.likePost(accessToken, widget.content);
            handleLike();
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(children: [
                  Text(widget.content.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.content.body,
                        style: const TextStyle(fontSize: 13)),
                    // Likes or removes the like on a single tap on the heart icon
                    GestureDetector(
                      onTap: () {
                        (!userModel.likedPosts.contains(widget.content))
                            ? userModel.likePost(accessToken, widget.content)
                            : userModel.unlikePost(accessToken, widget.content);

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

// class ContentCard extends StatelessWidget {
//   final Content content; // Content is a post
//   ContentCard({super.key, required this.content});

//   bool isLiked = false;

//   void handleLike() {
//     isLiked = !isLiked;
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserModel userModel = Provider.of<UserModel>(context, listen: false);

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             children: [
//               Row(children: [
//                 Text(content.username,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 14)),
//               ]),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text(content.body, style: const TextStyle(fontSize: 13)),
//                 GestureDetector(
//                   onDoubleTap: () {
//                     (!userModel.likedPosts.contains(content))
//                         ? userModel.likePost(context, content)
//                         : userModel.unlikePost(context, content);
//                   },
//                   child: Icon(
//                     Icons.favorite_border,
//                     color: Colors.grey,
//                   ),
//                 )
//               ])
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
