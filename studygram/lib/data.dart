import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'structure.dart';

class Data {
  static String baseUrl = "https://studygram-server.azurewebsite.net";
  static final Map<String, dynamic> _postCache = {};
  static const int maximumCacheLength = 20;

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

  //**Returns a list of the posts for a given username. If the user does not exist
  //it will return a text saying the user was not found. */
  static Future<dynamic> getPosts(String username) async {
    // Checks if the username exists in the cache already
    if (_postCache.containsKey(username)) {
      return _postCache[username];
    }

    final response = await http.get(Uri.parse("$baseUrl/posts/$username"));
    if (response.statusCode == 200) {
      final List<dynamic> postList = json.decode(response.body);
      return postList.map((json) => Post.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return Text("User $username not found");
    } else {
      throw Exception("Could not get posts.");
    }
  }
}
