import 'package:flutter/material.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/bottom_navigation_bar_model.dart';
import 'package:studygram/models/create_account_model.dart';
import 'package:studygram/models/create_post_model.dart';
import 'package:studygram/models/feed.dart';
import 'package:studygram/models/friends_page_model.dart';
import 'package:studygram/models/home_page_model.dart';
import 'package:studygram/models/session_view_model.dart';
import 'package:studygram/models/timer_model.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import './models/settings_model.dart';
import 'package:studygram/models/friend_manager.dart';
import 'package:studygram/models/like_manager.dart';
import 'package:studygram/models/comment_view_model.dart';
import 'package:studygram/models/user_search_bar_model.dart';
import 'router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => Settings()),
        ChangeNotifierProvider(create: (_) => CreateAccountModel()),
        ChangeNotifierProvider(create: (_) => Feed()),
        ChangeNotifierProvider(create: (_) => CreatePostModel()),
        ChangeNotifierProvider(create: (_) => FriendManager()),
        ChangeNotifierProvider(create: (_) => LikeManager()),
        ChangeNotifierProvider(create: (_) => CommentViewModel()),
        ChangeNotifierProvider(create: (_) => TimerModel()),
        ChangeNotifierProvider(create: (_) => WatchModel()),
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
        ChangeNotifierProvider(create: (_) => UserSearchBarModel()),
        ChangeNotifierProvider(create: (_) => BottomNavigationBarModel()),
        ChangeNotifierProvider(create: (_) => FriendsPageModel()),
        ChangeNotifierProvider(create: (_) => HomePageModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyRouter();
  }
}
