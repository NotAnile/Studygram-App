import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//** Creates a card for navigation. When clicked it will navigate you to the given route.*/
class NagivationCard extends StatelessWidget {
  final String route;
  final String text;
  final IconData icon;
  const NagivationCard(
      {super.key, required this.route, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 250,
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 51, 42, 53)),
                ),
              ),
              Icon(icon,
                  size: 100, color: const Color.fromARGB(255, 151, 115, 156))
            ],
          ),
        ),
      ),
      onTap: () {
        context.go(route);
      },
    );
  }
}
