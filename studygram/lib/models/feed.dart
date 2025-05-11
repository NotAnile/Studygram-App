import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../structure.dart';
import './url.dart';

class Feed extends ChangeNotifier {
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
  Future<dynamic> getProfile(BuildContext context, String username) async {
    // Checks if the username exists in the cache already
    if (_postCache.containsKey(username)) {
      return _postCache[username];
    }
    final String baseUrl = BaseUrl().baseUrl;
    final response = await http.get(Uri.parse("$baseUrl/profile/$username"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      return User.fromJson(result);
    } else if (response.statusCode == 404) {
      throw Exception("User does not exist.");
    } else {
      throw Exception("Could not get posts.");
    }
  }
}
