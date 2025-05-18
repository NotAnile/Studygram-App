import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:provider/provider.dart';

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
              color: Theme.of(context).colorScheme.onSurface,
              shadowColor: Theme.of(context).colorScheme.shadow,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: sizes[settings.size]['text'],
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                  ),
                  Icon(icon,
                      size: sizes[settings.size]['icon'],
                      color: Theme.of(context).primaryColor)
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
