import 'package:flutter/material.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/settings_model.dart';

/// Page for the current user where you can navigate to own posts,
/// liked posts, friends, and study history
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    return Center(
      child: SingleChildScrollView(
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
                      // Sending up the username to get the profile for the this user
                      extra: userModel.username,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: NavigationCard(
                    route: '/friends',
                    text: 'Friends',
                    icon: Icons.group,
                    extra: userModel.username,
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
                    route: '/studyhistory',
                    text: 'Study History',
                    icon: Icons.bar_chart,
                    extra: userModel.username,
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A card where you navigate to a place when clicked
class NavigationCard extends StatelessWidget {
  final String route;
  final String text;
  final IconData icon;
  final dynamic extra;
  const NavigationCard(
      {super.key,
      required this.route,
      required this.text,
      required this.icon,
      this.extra});

  @override
  Widget build(BuildContext context) {
    Map sizes = {
      Size.small: {'text': 20.0, 'icon': 80.0},
      Size.medium: {'text': 25.0, 'icon': 100.0},
      Size.large: {'text': 30.0, 'icon': 120.0},
    };

    return Consumer<Settings>(
      builder: (context, settings, child) {
        return GestureDetector(
          child: SizedBox(
            height: 250,
            child: Card(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      text,
                      // Title for the card
                      style: TextStyle(
                          fontSize: sizes[settings.size]['text'],
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  // Image for the card
                  Icon(icon,
                      size: sizes[settings.size]['icon'],
                      color: Theme.of(context).primaryColorLight)
                ],
              ),
            ),
          ),
          onTap: () {
            context.push(route, extra: extra);
          },
        );
      },
    );
  }
}
