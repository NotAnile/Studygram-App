import 'package:flutter/material.dart';
import '../structure.dart';

//**A card that consists of a username and a text (body). Each post consists of a card.*/
class ContentCard extends StatelessWidget {
  final Content content;
  const ContentCard({super.key, required this.content});

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
                Text(content.username,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
              Row(children: [
                Text(content.body, style: const TextStyle(fontSize: 13)),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
