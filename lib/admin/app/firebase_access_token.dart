part of app;

/// Type representing a Firebase OAuth access token (derived from a Google OAuth2 access token) which
/// can be used to authenticate to Firebase services such as the Realtime Database and Auth.
class FirebaseAccessToken {
  const FirebaseAccessToken({
    required this.accessToken,
    required this.expirationTime,
  });

  final String accessToken;
  final DateTime expirationTime;
}
