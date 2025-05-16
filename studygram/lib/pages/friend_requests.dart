import 'package:flutter/material.dart';
import 'package:studygram/components/friend_request_view.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FriendRequestView(),
    );
  }
}
