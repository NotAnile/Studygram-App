import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/bottom_navigation_bar_model.dart';

/// Bottom navigation bar used in the app.
class MyNavigationBar extends StatelessWidget {
  final Widget child;
  const MyNavigationBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationBarModel>(builder: (context, model, child) {
      void onItemTapped(int index) {
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

        model.setCurrentIndex(index);
      }

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
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_sharp),
                label: "Friend Requests"),
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Page"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
          currentIndex: model.currentIndex,
          selectedItemColor: Theme.of(context).hintColor,
          unselectedItemColor: Theme.of(context).focusColor,
          unselectedLabelStyle: TextStyle(color: Theme.of(context).focusColor),
          showUnselectedLabels: true,
          onTap: onItemTapped,
        ),
      );
    });
  }
}
