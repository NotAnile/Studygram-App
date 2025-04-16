import 'package:flutter/material.dart';

// Each post consists of a card
class PostCard extends StatelessWidget {
  final String body;
  final String username;
  const PostCard({super.key, required this.body, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(children: [
                Text(username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
              Row(children: [
                Text(body, style: const TextStyle(fontSize: 13)),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
