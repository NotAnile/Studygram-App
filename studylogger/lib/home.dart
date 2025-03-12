import 'package:flutter/material.dart';
import 'package:studylogger/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Post(body: "Hej lorem ipsum asdaskdhagsd0", username: "Lorem")
        ],
      ),
    );
  }
}
