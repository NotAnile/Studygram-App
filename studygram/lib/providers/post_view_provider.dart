import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/repositories/post_repository.dart';
import 'package:studygram/services/post_service.dart';
import 'dart:convert';
import '../services/url.dart';

class PostViewProvider extends ChangeNotifier {
  final PostService postService;
  final PostRepository postRepository;
  String _errorMessage = "";
  Status _status = Status.idle;
  bool refresh = false;

  PostViewProvider({
    required this.postService,
    required this.postRepository,
  });

  String get errorMessage => _errorMessage;
  Status get status => _status;

  set status(Status value) {
    _status = value;
  }

  /// Function to call to refresh the posts for the post view
  void refresh() {
    refresh = true;
    notifyListeners();
  }

  Future<void> removePost(String token, int postID) async {
    _status = Status.loading;
    final newStatus = await postRepository.removePost(token, postID);
    _status = newStatus;
    if (_status == Status.error) {
      _errorMessage = postService.errorMessage;
    }
    notifyListeners();
  }

  /// Returns posts from cache of the given category if refresh is false. 
  /// Otherwise it will return a Future of posts from the server.
  dynamic getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers, String category) async {
    _status = Status.loading;
    final posts =
        await postRepository.getPosts(token, selectedUsers, excludedUsers, category, refresh);
    // Updates the refresh bool if it is true
    if (refresh) {
      refresh = false;
    }
    // Updating the status
    _status = postRepository.status;
    if (_status == Status.error) {
      _errorMessage = postService.errorMessage;
    }
    return posts;
  }
}
