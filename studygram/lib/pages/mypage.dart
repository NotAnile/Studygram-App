import 'package:flutter/material.dart';
import 'package:studygram/components/navigation_card.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';

//**Page for the current user where you can navigate to own posts,
// liked posts, friends, and session stats */
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: NavigationCard(
                    route: '/profile',
                    text: 'My posts',
                    icon: Icons.person,
                    extra: userModel.username,
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(5),
                child: NavigationCard(
                  route: '/user/friends',
                  text: 'Friends',
                  icon: Icons.group,
                  extra: userModel
                      .friends, // send the user's list of friends when we go to friends page
                ),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(5),
                child: NavigationCard(
                  route: '/liked',
                  text: 'Liked',
                  icon: Icons.favorite,
                  extra: userModel.username,
                ),
              )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(5),
                child: NavigationCard(
                  route: '/',
                  text: 'Statistics',
                  icon: Icons.bar_chart,
                  extra: userModel.username,
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
