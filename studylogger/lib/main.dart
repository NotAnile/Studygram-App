import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
    // return MaterialApp.router(
    //   routerConfig: _router,
    // );
  }
}

// final _router = GoRouter(
//   routes: [
//     GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
//   ],
// );

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyNavigationBar(child: Text("Hej"));
  }
}

class MyNavigationBar extends StatefulWidget {
  final Widget child;
  const MyNavigationBar({super.key, required this.child});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_sharp), label: "Notifications"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 195, 151, 202),
        onTap: _onItemTapped,
      ),
    );
  }
}
