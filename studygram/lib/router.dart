import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/settings_model.dart';
import 'package:studygram/pages/create_account.dart';
import 'package:studygram/pages/create_post.dart';
import 'package:studygram/pages/home.dart';
import 'package:studygram/pages/liked.dart';
import 'package:studygram/pages/friend_requests.dart';
import 'package:studygram/pages/mypage.dart';
import 'package:studygram/pages/post.dart';
import 'package:provider/provider.dart';
import 'package:studygram/pages/timer.dart';
import 'package:studygram/structure.dart';
import 'pages/login.dart';
import 'package:studygram/pages/userprofile.dart';
import 'components/navigationbar.dart';
import 'package:studygram/pages/settings.dart';
import 'package:studygram/pages/friends.dart';
import 'package:studygram/pages/study_history.dart';
import 'package:studygram/themes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class MyRouter extends StatelessWidget {
  const MyRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: true);

    final router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      refreshListenable: auth, // Refreshes the page when the user logs in
      redirect: (context, state) {
        // Checking if the user is logged in
        if (!auth.isLoggedIn) {
          // Make the redirect to create account page if the user goes there
          if (state.fullPath == '/create/account') {
            return '/create/account';
          } else {
            // Otherwise redirect to login page so the user can't access the rest of the app
            return '/login';
          }
        } else {
          return null;
        }
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/create/account',
          builder: (context, state) => const CreateAccountPage(),
        ),
        GoRoute(
          path: '/create/post',
          builder: (context, state) => const CreatePostPage(),
        ),
        GoRoute(
          path: '/post',
          builder: (context, state) {
            final post =
                state.extra! as Post; // Gets the post for the post page
            return PostPage(post: post);
          },
        ),
        GoRoute(
          path: '/friends',
          builder: (context, state) {
            final username = state.extra! as String;
            return FriendsPage(username: username);
          },
        ),
        GoRoute(
            path: '/studyhistory',
            builder: (context, state) {
              return const StudyHistoryPage();
            }),
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
              path: '/friendrequests',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const FriendRequestsPage(),
            ),
            GoRoute(
              path: '/mypage',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const MyPage(),
            ),
            GoRoute(
              path: '/settings',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const SettingsPage(),
            ),
            GoRoute(
              path: '/timer',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const TimerPage(),
            ),
            GoRoute(
              path: '/profile',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) {
                final String username = state.extra!
                    as String; // Getting the username for the userprofile page
                return UserProfilePage(username: username);
              },
            ),
            GoRoute(
              path: '/liked',
              parentNavigatorKey: _shellNavigatorKey,
              builder: (context, state) => const LikedPage(),
            ),
          ],
        )
      ],
    );

    // Setting the right mode depending on the settings
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return MaterialApp.router(
          theme: settings.contrast ? highContrastLightTheme : lightTheme,
          darkTheme: settings.contrast ? highContrastDarkTheme : darkTheme,
          themeMode: settings.themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
