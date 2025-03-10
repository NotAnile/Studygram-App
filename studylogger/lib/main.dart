import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen()),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home screen",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyNavigationBar(
        defaultIndex: 0,
        child: const Text("Hej"),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notification screen",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyNavigationBar(
        defaultIndex: 1,
        child: const Text("AAAAAAAAAAAA"),
      ),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  final Widget child;
  int defaultIndex = 0;
  MyNavigationBar({super.key, required this.child, required this.defaultIndex});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  void _onItemTapped(int index) {
    setState(
      () {
        // Compares the page's navigation bar index with the selected index
        // and changes if the user selects a different page
        if (widget.defaultIndex != index) {
          if (index == 0) {
            _router.push("/");
          } else {
            _router.push("/notifications");
          }
        }
      },
    );
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
        currentIndex: widget.defaultIndex,
        selectedItemColor: const Color.fromARGB(255, 195, 151, 202),
        onTap: _onItemTapped,
      ),
    );
  }
}
