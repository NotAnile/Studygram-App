import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './url.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';
import 'package:studygram/structure.dart';

/// Provider handling the following and unfollowing users,
/// as well as getting followers, friends and friend requests.
class FriendManager extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";
  final String baseUrl = BaseUrl().baseUrl;

  Status get status => _status;
  String get errorMessage => _errorMessage;

  /// Tries to follow the given username and returns a status
  /// depending on how the operation goes.
  Future<Status> addFriend(BuildContext context, String friendUsername) async {
    _status = Status.loading;
    // Getting token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    // Creating a JSON to send to the server
    final response = await http.post(Uri.parse("$baseUrl/friend/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'username': friendUsername,
        }));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
      // Updates the UserModel
      if (context.mounted) {
        Provider.of<UserModel>(context, listen: false)
            .followUser(friendUsername);
      }
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      notifyListeners();
    }
    return _status;
  }

  /// Tries to unfollow the given username and returns
  /// a status depending on how the operation goes.
  Future<Status> removeFriend(
      BuildContext context, String friendUsername) async {
    _status = Status.loading;
    // Getting token
    String token =
        Provider.of<Authentication>(context, listen: false).accessToken;
    // Creating a JSON to send to the server
    final response = await http.delete(Uri.parse("$baseUrl/friend/remove"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'username': friendUsername,
        }));
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      //Updates the UserModel
      if (context.mounted) {
        Provider.of<UserModel>(context, listen: false)
            .unfollowUser(friendUsername);
      }
      notifyListeners();
      return Status.success;
    } else {
      _status = Status.error;
      // Something went wrong, so error message is updated
      _errorMessage = json.decode(response.body)['message'];
      notifyListeners();
      return Status.error;
    }
  }

  /// Returns a list with all the friends/mutuals of the given follower.
  Future<List<dynamic>> getFriends(String username) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.get(
      Uri.parse("$baseUrl/friends/all/$username"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
      return result['friends'];
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Gets a list with all users that the given username is following.
  Future<List<dynamic>> getFollowing(String username) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.get(
      Uri.parse("$baseUrl/following/all/$username"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
      return result['following'];
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      throw Exception(_errorMessage);
    }
  }

  /// Returns a list with all the friend requests (users that have
  /// followed but is not followed back) that has been sent
  /// to the logged in user.
  Future<List<dynamic>> getFriendRequests(String token) async {
    _status = Status.loading;
    // Creating a JSON to send to the server
    final response = await http.get(
      Uri.parse("$baseUrl/friendrequests/all"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final result = json.decode(response.body);
    // Handling the result depending on the status code
    if (response.statusCode == 200) {
      _status = Status.success;
      // Setting no error message since everything went well
      _errorMessage = "";
      notifyListeners();
      return result['friend_requests'];
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      throw Exception(_errorMessage);
    }
  }
}
