import 'package:flutter/material.dart';
import 'package:studygram/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary json data for testing since receiving json from backend has not been implemented yet
    List jsonList = [
      {"body": "Hej lorem ipsum asdaskdhagsd0", "username": "Lorem"},
    ];
    return Center(
      child: Column(
        children: [
          // Creates a list view to display all the posts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: ListView.builder(
                itemCount: jsonList.length,
                itemBuilder: (context, index) {
                  Map json = jsonList[index];
                  String body = json["body"];
                  String username = json["username"];
                  return Post(
                    body: body,
                    username: username,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
