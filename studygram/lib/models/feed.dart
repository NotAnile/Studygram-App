import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../structure.dart';
import './url.dart';

class Feed extends ChangeNotifier {
  static final Map<String, dynamic> _postCache = {};
  static const int maximumCacheLength = 20;
  final String baseUrl = BaseUrl().baseUrl;
  final int postLimit = 20;
  Status _status = Status.idle;
  String _errorMessage = "";

  Status get status => _status;
  String get errorMessage => _errorMessage;

  // Using a cache to prevent unnecessary network calls so if we've already searched on a user
  // (in this application run) we don't need to do a network call again
  //**Adds the key value pair to the given cache if the key does not exist yet,
  //otherwise it will update the value for the given key in the cache. */
  void addToCache(Map<String, dynamic> cache, String key, dynamic value) {
    // Checks if the cache has reached the maximum length and clears if yes
    if (cache.length == maximumCacheLength) {
      cache = {};
    }
    // Updates the cache with the new value if it already contains the key
    if (cache.containsKey(key)) {
      cache.update(key, (val) => value);
      return;
    } else {
      // Adds the new key and value to the cache
      cache[key] = value;
    }
  }

  //**Returns a list of the posts for a given username.*/
  Future<dynamic> getProfile(String username, String token) async {
    // Checks if the username exists in the cache already
    if (_postCache.containsKey(username)) {
      return _postCache[username];
    }
    final response = await http.get(
      Uri.parse("$baseUrl/profile/$username"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
    );
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return User.fromJson(result);
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  //**Returns a post object for the given post id. */
  Future<dynamic> getPost(int postID, String token) async {
    _status = Status.loading;
    final response = await http.get(
      Uri.parse("$baseUrl/post/$postID"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
    );
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return Post.fromJson(result);
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }

  //**Returns a list with posts for the given post id. */
  Future<List<dynamic>> getPosts(String token, List<dynamic> selectedUsers,
      List<dynamic> excludedUsers) async {
    final response = await http.post(
      Uri.parse("$baseUrl/posts/all"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'selected_users': selectedUsers,
          'excluded_users': excludedUsers,
          'post_count': postLimit
        },
      ),
    );

    // Adding all the posts from json to a list
    final result = json.decode(response.body);
    if (response.statusCode == 200) {
      _status = Status.success;
      return result.map((json) => Post.fromJson(json)).toList();
    } else {
      _status = Status.error;
      _errorMessage = result['message'];
      throw Exception(_errorMessage);
    }
  }
}
