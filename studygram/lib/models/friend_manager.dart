import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './url.dart';
import 'package:provider/provider.dart';
import 'package:studygram/models/authentication.dart';
import 'package:studygram/models/user.dart';

class FriendManager extends ChangeNotifier {
  Status _status = Status.idle;
  String _errorMessage = "";
  final String baseUrl = BaseUrl().baseUrl;

  Status get status => _status;
  String get errorMessage => _errorMessage;

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
      // Updates the UserModel
      if (context.mounted) {
        Provider.of<UserModel>(context, listen: false)
            .followUser(friendUsername);
        notifyListeners();
        return Status.success;
      }
    } else {
      // Something went wrong, so error message is updated
      _status = Status.error;
      _errorMessage = json.decode(response.body)['message'];
      notifyListeners();
    }
    return Status.error;
  }

  Future<Status> removeFriend(
      BuildContext context, String friendUsername) async {
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
      //Updates the FriendModel
      Provider.of<UserModel>(context, listen: false)
          .unfollowUser(friendUsername);
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
