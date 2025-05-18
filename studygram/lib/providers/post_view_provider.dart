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

  PostViewProvider({
    required this.postService,
    required this.postRepository,
  });

  String get errorMessage => _errorMessage;
  Status get status => _status;

  set status(Status value) {
    _status = value;
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
}
