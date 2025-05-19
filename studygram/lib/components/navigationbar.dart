import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/create_post_model.dart';
import 'package:provider/provider.dart';

class MyNavigationBar extends StatefulWidget {
  final Widget child;
  const MyNavigationBar({super.key, required this.child});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int currentIndex = 0;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/friendrequests');
        break;
      case 2:
        context.go('/timer');
        break;
      case 3:
        context.go('/mypage');
        break;
      case 4:
        context.go('/settings');
        break;
      default:
        context.go('/');
        break;
    }

    setState(
      () {
        currentIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: GoRouterState.of(context).uri.toString() == "/"
          ? Builder(
              builder: (context) => FloatingActionButton.small(
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add),
                onPressed: () {
                  context.push('/create/post');
                },
              ),
            )
          : null,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_sharp), label: "Friend Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Page"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).hintColor,
        unselectedItemColor: Theme.of(context).focusColor,
        unselectedLabelStyle: TextStyle(color: Theme.of(context).focusColor),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
