import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

// Code taken from https://medium.com/@edawarekaro/secure-authentication-in-flutter-implementing-refresh-tokens-with-dio-e3ebef1f56ef

/// Auth token pair.
class AuthTokenPair {
  /// Access-token for accessing server resources for an authorized user.
  final String accessToken;

  /// Refresh-token for updating the access-token.
  final String refreshToken;

  /// Create an instance of AuthTokenPair.
  const AuthTokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  /// Create an instance of AuthTokenPair from json.
  factory AuthTokenPair.fromJson(Map<String, dynamic> json) {
    return AuthTokenPair(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Convert an instance of AuthTokenPair to json.
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

/// Implementation of TokenStorage for securely storing authentication tokens
class TokenStorageImpl implements TokenStorage<AuthTokenPair> {
  final FlutterSecureStorage _secureStorage;

  /// Creates a new TokenStorageImpl with the given secure storage
  const TokenStorageImpl(this._secureStorage);
  @override
  Future<AuthTokenPair?> read() async {
    final tokenJson =
        await _secureStorage.read(key: TokensStorageKeys.authToken.keyName);
    if (tokenJson == null) return null;
    return AuthTokenPair.fromJson(
        jsonDecode(tokenJson) as Map<String, dynamic>);
  }

  @override
  Future<void> write(AuthTokenPair token) {
    return _secureStorage.write(
      key: TokensStorageKeys.authToken.keyName,
      value: jsonEncode(token.toJson()),
    );
  }

  @override
  Future<void> delete() async {
    for (final key in TokensStorageKeys.values) {
      await _secureStorage.delete(key: key.keyName);
    }
  }
}

/// Keys for TokenStorageImpl
enum TokensStorageKeys {
  // Making the authToken enum have the keyName 'app_auth_token' to prevent typos
  authToken('app_auth_token');

  final String keyName;
  const TokensStorageKeys(this.keyName);
}

/// Interceptor that handles token refresh when receiving 401 unauthorized responses
class TokenRefreshInterceptor {
  final TokenStorage<AuthTokenPair> _tokenStorage;

  /// Creates a new TokenRefreshInterceptor with the given token storage
  TokenRefreshInterceptor(this._tokenStorage);

  /// Get Fresh interceptor configured for token management
  Fresh<AuthTokenPair> get fresh => Fresh<AuthTokenPair>(
        tokenStorage: _tokenStorage,
        tokenHeader: (token) {
          // This function is called for every request to add the token to headers
          return {
            'Authorization': 'Bearer ${token.accessToken}',
          };
        },
        refreshToken: (token, client) async {
          // This function is called when a 401 error is received
          try {
            final response = await client.post(
              '/refresh',
              data: {
                'refreshToken': token!.refreshToken,
                'accessToken': token.accessToken,
              },
            );

            final newTokens = response.data;
            return AuthTokenPair(
              accessToken: newTokens['accessToken'],
              refreshToken: newTokens['refreshToken'],
            );
          } catch (e) {
            // If refresh fails, throw to trigger logout
            throw RevokeTokenException();
          }
        },
        shouldRefresh: (response) {
          // Determine if we should attempt a token refresh
          return response?.statusCode == 401;
        },
      );
}
