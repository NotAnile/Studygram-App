import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/repositories/post_repository.dart';
import 'package:studygram/services/post_service.dart';
import 'dart:convert';
import '../services/url.dart';

class CreatePostProvider extends ChangeNotifier {
  final PostService postService;
  final PostRepository postRepository;
  String _errorMessage = "";
  Status _status = Status.idle;

  CreatePostProvider({
    required this.postService,
    required this.postRepository,
  });

  String get errorMessage => _errorMessage;
  Status get status => _status;

  set status(Status value) {
    _status = value;
  }

  Future<void> createPost(String token, String body) async {
    _status = Status.loading;
    final newStatus = await postRepository.createPost(token, body);
    _status = newStatus;
    if (_status == Status.error) {
      _errorMessage = postService.errorMessage;
    }
    notifyListeners();
  }

  Future<Status> createPost(String token, String body) async {
    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/posts"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        // We don't need to send the username when we use the token
        body: jsonEncode(<String, String>{'body': body.trim()}));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      // Setting no error message since everything went well
      _errorMessage = "";
      return Status.success;
    } else {
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      return Status.error;
    }
  }
}
