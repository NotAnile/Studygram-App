import 'package:flutter/material.dart';
import '../components/contentview.dart';
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
        "username": "Lorem",
        "comments": []
      },
    ];

    return Center(
      child: Column(
        children: [
          // Creates a list view to display all the posts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: ContentView(
                  contents:
                      jsonList.map((json) => Post.fromJson(json)).toList()),
            ),
          ),
        ],
      ),
    );
  }
}
