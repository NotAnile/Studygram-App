import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studygram/services/authentication.dart';
import 'package:studygram/screens/auth/create_account.dart';
import 'package:studygram/screens/feed/create_post.dart';
import 'package:studygram/screens/feed/home.dart';
import 'package:studygram/screens/account/liked.dart';
import 'package:studygram/screens/friends/friend_requests.dart';
import 'package:studygram/screens/account/mypage.dart';
import 'package:studygram/screens/feed/post.dart';
import 'package:provider/provider.dart';
import 'package:studygram/screens/study/timer.dart';
import 'package:studygram/models/content.dart';
import 'screens/auth/login.dart';
import 'package:studygram/screens/feed/userprofile.dart';
import 'components/navigationbar.dart';
import 'package:studygram/screens/account/settings.dart';
import 'package:studygram/screens/friends/friends.dart';
import 'package:studygram/screens/study/study_history.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

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

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
