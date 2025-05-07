import 'package:flutter/material.dart';
import '../components/content_view.dart';
import '../structure.dart';
//import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary json data for testing since receiving json from backend has not been implemented yet
    List jsonList = [
      {
        "body": "Hej lorem ipsum asdaskdhagsd0",
        "username": "Lorem1",
        "comments": [
          {
            "body": "Comment1",
            "username": "Commenter1",
            "id": 1,
          },
          {
            "body": "Comment2",
            "username": "Commenter1",
            "id": 2,
          },
        ],
        "id": 1,
      },
    ];

    return Center(
      child: Column(
        children: [
          // Creates a list view to display all the posts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: PostView(
                  contents:
                      jsonList.map((json) => Post.fromJson(json)).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
