import 'package:flutter/material.dart';
import 'package:studygram/services/url.dart';
import 'package:studygram/providers/create_post_provider.dart';
import 'package:studygram/services/post_service.dart';

class PostRepository {
  PostService postService;
  Status get status => postService.status;

  PostRepository({required this.postService});

  Future<Status> createPost(String token, String body) {
    return postService.createPost(token, body);
  }

  Future<Status> removePost(String token, int postID) {
    return postService.removePost(token, postID);
  }

  Future<List<dynamic>> getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers) async {
    final posts =
        await postService.getPosts(token, selectedUsers, excludedUsers);
    await postService.getPosts(token, selectedUsers, excludedUsers);
    return posts;
  }
}
