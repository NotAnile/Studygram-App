import 'package:flutter/material.dart';
import 'postcard.dart';

//**Listview to display all the posts in a column*/
class ContentView extends StatefulWidget {
  final List<dynamic> contents;
  const ContentView({super.key, required this.contents});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contents.length,
      itemBuilder: (context, index) {
        // Getting the right post with the index and returns a PostCard with the body and username
        return ContentCard(content: widget.contents[index]);
      },
    );
  }
}
