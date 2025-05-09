import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        context.go('/notifications');
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
        backgroundColor: const Color.fromARGB(255, 151, 115, 156),
      ),
      floatingActionButton: GoRouterState.of(context).uri.toString() == "/"
          ? Builder(
              builder: (context) => FloatingActionButton.small(
                backgroundColor: const Color.fromARGB(255, 229, 200, 243),
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
            )
          : null,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_sharp), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "My page"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 195, 151, 202),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
