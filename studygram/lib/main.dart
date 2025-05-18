import 'package:flutter/material.dart';
import 'package:studygram/providers/post_view_provider.dart';
import 'package:studygram/repositories/post_repository.dart';
import 'package:studygram/services/authentication.dart';
import 'package:studygram/services/create_account_model.dart';
import 'package:studygram/providers/create_post_provider.dart';
import 'package:studygram/services/feed.dart';
import 'package:studygram/services/post_service.dart';
import 'package:studygram/services/session_view_model.dart';
import 'package:studygram/services/timer_model.dart';
import 'package:studygram/services/user.dart';
import 'package:provider/provider.dart';
import 'services/settings_model.dart';
import 'package:studygram/services/friend_manager.dart';
import 'package:studygram/services/like_manager.dart';
import 'package:studygram/services/post_page_model.dart';
import 'package:studygram/services/user_search_bar_model.dart';
import 'router.dart';

void main() {
  PostService postService = PostService();
  PostRepository postRepository = PostRepository(postService: postService);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserModel()),
      ChangeNotifierProvider(create: (_) => Authentication()),
      ChangeNotifierProvider(create: (_) => Settings()),
      ChangeNotifierProvider(create: (_) => CreateAccountModel()),
      ChangeNotifierProvider(create: (_) => Feed()),
      ChangeNotifierProvider(
          create: (_) => CreatePostProvider(
              postService: postService, postRepository: postRepository)),
      ChangeNotifierProvider(
          create: (_) => PostViewProvider(
              postService: postService, postRepository: postRepository)),
      ChangeNotifierProvider(create: (_) => FriendManager()),
      ChangeNotifierProvider(create: (_) => LikeManager()),
      ChangeNotifierProvider(create: (_) => CommentViewModel()),
      ChangeNotifierProvider(create: (_) => TimerModel()),
      ChangeNotifierProvider(create: (_) => WatchModel()),
      ChangeNotifierProvider(create: (_) => SessionViewModel()),
      ChangeNotifierProvider(create: (_) => UserSearchBarModel()),
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
