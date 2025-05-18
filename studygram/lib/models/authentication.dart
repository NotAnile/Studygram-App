import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './user.dart';
import 'package:provider/provider.dart';
import './url.dart';
import 'package:studygram/models/settings_model.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fresh_dio/fresh_dio.dart';
// import 'package:dio/dio.dart';
// import 'package:studygram/token.dart';

class Authentication extends ChangeNotifier {
  bool _isLoggedIn = false;
  final String baseUrl = BaseUrl().baseUrl;
  Status _status = Status.idle;
  String _errorMessage = "";
  String _accessToken = "";
  String _refreshToken = "";
  // final TokenStorageImpl tokenStorage =
  //     const TokenStorageImpl(FlutterSecureStorage());

  bool get isLoggedIn => _isLoggedIn;
  Status get status => _status;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get errorMessage => _errorMessage;

  Future<Status> login(
      String username, String password, BuildContext context) async {
    _status = Status.loading;
    final response = await http.post(Uri.parse("$baseUrl/user/login"),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        },
        body: jsonEncode(
            <String, String>{'username': username, 'password': password}));
    // Getting the result
    final Map<String, dynamic> result = json.decode(response.body);
    // Checks if context is mounted to ensure that the widget associated with the context
    // has not been disposed or removed
    if (context.mounted) {
      if (response.statusCode == 200) {
        // Setting the token for the authentication model from the result
        _accessToken = result['access_token'];
        _refreshToken = result['refresh_token'];

        // await tokenStorage.write(AuthTokenPair(
        //     accessToken: result['access_token'],
        //     refreshToken: result['refresh_token']));

        // Setting up user model and updating isLoggedIn bool
        if (context.mounted) {
          UserModel userModel = Provider.of<UserModel>(context, listen: false);
          userModel.setUsername = username;
          userModel.initialize(_accessToken);

          // Getting the size that the user has chosen
          Provider.of<Settings>(context, listen: false)
              .getSettings(_accessToken);
        }

        _isLoggedIn = true;
        _status = Status.success;
      } else {
        _errorMessage = result['message'];
        _status = Status.error;
      }
    }
    notifyListeners();
    return _status;
  }

  void logout() async {
    final String token = _accessToken;
    final response = await http.post(
      Uri.parse("$baseUrl/user/logout"),
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // application/json means we want to parse it as a json
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      _isLoggedIn = false;
      _status = Status.success;
    } else {
      _status = Status.error;
    }
    notifyListeners();
  }

  // /// Creates and configures a Dio HTTP client with authentication
  // Dio setupAuthenticatedDio(String baseUrl) {
  //   final dio = Dio(
  //     BaseOptions(
  //       baseUrl: baseUrl,
  //       connectTimeout: const Duration(seconds: 30),
  //       receiveTimeout: const Duration(seconds: 30),
  //       sendTimeout: const Duration(seconds: 30),
  //     ),
  //   );

  //   // Set up token refresh interceptor
  //   final tokenRefreshInterceptor = TokenRefreshInterceptor(tokenStorage);
  //   final fresh = tokenRefreshInterceptor.fresh;

  //   // Add the Fresh interceptor to Dio
  //   dio.interceptors.add(fresh);

  //   // Log out listener to handle authentication failures
  //   fresh.authenticationStatus.listen((status) {
  //     if (status == AuthenticationStatus.unauthenticated) {
  //       _isLoggedIn = false;
  //     }
  //   });

  //   return dio;
  // }
}
