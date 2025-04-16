import 'package:flutter/material.dart';
import '../components/postview.dart';

class CommentsPage extends StatelessWidget {
  final List<dynamic> comments;
  const CommentsPage({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: [PostView(posts: comments)]));
  }
}
