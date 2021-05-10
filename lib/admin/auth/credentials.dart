part of auth;

/// Interface for Google OAuth 2.0 access tokens.
class GoogleOAuthAccessToken {
  GoogleOAuthAccessToken(this.accessToken, this.expiresIn);

  factory GoogleOAuthAccessToken.fromJson(Map<String, dynamic> json) {
    final String accessToken = json['access_token'] as String;
    final int expiresIn = json['expires_in'] as int;

    return GoogleOAuthAccessToken(accessToken, Duration(seconds: expiresIn));
  }

  final String accessToken;
  final Duration expiresIn;
}

/// Interface for things that generate access tokens.
abstract class Credential {
  Future<GoogleOAuthAccessToken> getAccessToken();
}

Credential? getApplicationDefault(String? httpAgent) {}
