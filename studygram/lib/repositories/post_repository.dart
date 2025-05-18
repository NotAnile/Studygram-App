import 'package:flutter/material.dart';
import 'package:studygram/services/url.dart';
import 'package:studygram/providers/create_post_provider.dart';
import 'package:studygram/services/post_service.dart';

class PostRepository {
  PostService postService;
  Status get status => postService.status;
  Map<String, List<dynamic>?> cache = {
            'liked': null,
            'own': null,
            'following': null,
            'strangers': null,
        }

  PostRepository({required this.postService});

  Future<Status> createPost(String token, String body) {
    return postService.createPost(token, body);
  }

  Future<Status> removePost(String token, int postID) {
    return postService.removePost(token, postID);
  }

  dynamic getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers, String category, bool refresh) async {
    // Getting posts from cache if refresh is false and the cache isn't empty
    if (!refresh && cache[category] != null) {
      return cache[category];
    } else {
      final posts =
        await postService.getPosts(token, selectedUsers, excludedUsers);
      // Updating cache
      cache[category] = posts;
      return posts;
    }
  }
}
