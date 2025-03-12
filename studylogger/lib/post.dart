import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String body;
  final String username;
  const Post({super.key, required this.body, required this.username});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Row(
          children: [
            Text(username),
          ],
        ),
        Row(children: [
          Text(body),
        ])
      ]),
    );
  }
}
