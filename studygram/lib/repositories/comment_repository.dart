import 'package:flutter/material.dart';
import 'package:studygram/services/url.dart';
import 'package:studygram/providers/create_post_provider.dart';
import 'package:studygram/services/post_service.dart';

class CommentRepository {
  CommentService commentService;
  Status get status => commentService.status;

  CommentRepository({required this.commentService});

  Future<Status> createPost(String token, String body) {
    return commentService.createPost(token, body);
  }

  Future<Status> removePost(String token, int postID) {
    return commentService.removePost(token, postID);
  }

  Future<List<dynamic>> getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers) async {
    final posts =
        await commentService.getPosts(token, selectedUsers, excludedUsers);
    await commentService.getPosts(token, selectedUsers, excludedUsers);
    return posts;
  }
}
