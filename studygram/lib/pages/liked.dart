import 'package:flutter/material.dart';
import 'package:studygram/components/content_view.dart';
import 'package:studygram/components/textbutton.dart';
import '../models/feed.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/user.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    return Consumer<UserModel>(builder: (context, model, child) {
      return Center(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostView(contents: userModel.likedPosts),
            ),
          ),
        ]),
      );
    });
  }
}
