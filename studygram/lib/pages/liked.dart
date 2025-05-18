import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import 'package:studygram/services/like_manager.dart';
import 'package:provider/provider.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LikeManager>(builder: (context, model, child) {
      return Center(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostView(posts: model.likedPosts),
            ),
          ),
        ]),
      );
    });
  }
}
