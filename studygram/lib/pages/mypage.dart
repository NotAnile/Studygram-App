import 'package:flutter/material.dart';
import 'package:studygram/components/navigation_card.dart';

//**Page for the current user where you can navigate to own posts,
// liked posts, friends, and session stats */
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NavigationCard(
                    route: '/', text: 'My posts', icon: Icons.person),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NavigationCard(
                    route: '/', text: 'Friends', icon: Icons.group),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NavigationCard(
                    route: '/', text: 'Liked', icon: Icons.favorite),
              )),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5),
                child: NavigationCard(
                    route: '/', text: 'Statistics', icon: Icons.bar_chart),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
