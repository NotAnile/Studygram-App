import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/pages/home.dart';
import 'package:studygram/pages/notifications.dart';
import 'package:studygram/pages/mypage.dart';
import 'package:studygram/pages/post.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import './structure.dart';
import 'pages/login.dart';
import './models/settings_model.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserModel()),
      ChangeNotifierProvider(create: (_) => Authentication()),
      ChangeNotifierProvider(create: (_) => Settings()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyRouter();
  }
}

class MyRouter extends StatelessWidget {
  const MyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: true);

    final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      refreshListenable: auth,
      redirect: (context, state) {
        // Checking if the user is logged in
        if (!auth.isLoggedIn) {
          return '/login';
        } else {
          return null;
        }
      },
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MyNavigationBar(child: child),
          routes: [
            GoRoute(
              path: '/',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/notifications',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const NotificationScreen(),
            ),
            GoRoute(
              path: '/mypage',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const MyPage(),
            ),
            GoRoute(
              path: '/post',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) {
                final post =
                    state.extra! as Post; // Gets the post for the post page
                return PostPage(post: post);
              },
            ),
            GoRoute(
              path: '/settings',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const MyPage(),
            ),
            GoRoute(
              path: '/timer',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const MyPage(),
            ),
            GoRoute(
              path: '/login',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const LoginPage(),
            ),
          ],
        )
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

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
        // ---------------------------- Arrow to pop - to be implemented
        // leading: GoRouter.of(context).canPop()
        //     ? IconButton(
        //         icon: const Icon(Icons.arrow_back),
        //         onPressed: () => context.pop(),
        //       )
        //     : null,
      ),
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
