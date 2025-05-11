import 'package:flutter/material.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/create_account_model.dart';
import 'package:studygram/models/create_post_model.dart';
import 'package:studygram/models/feed.dart';
import 'package:studygram/models/user.dart';
import 'package:provider/provider.dart';
import './models/settings_model.dart';
import 'package:studygram/models/friend_manager.dart';
import 'router.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserModel()),
      ChangeNotifierProvider(create: (_) => Authentication()),
      ChangeNotifierProvider(create: (_) => Settings()),
      ChangeNotifierProvider(create: (_) => CreateAccountModel()),
      ChangeNotifierProvider(create: (_) => Feed()),
      ChangeNotifierProvider(create: (_) => CreatePostModel()),
      ChangeNotifierProvider(create: (_) => FriendManager())
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
