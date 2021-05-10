part of app;

mixin FirebaseAppInternals {
  final StreamController<String> _accessTokenController = StreamController<String>.broadcast();

  FirebaseAccessToken? _cachedToken;
  Future<FirebaseAccessToken>? _cachedTokenFuture;
  Timer? _tokenRefreshTimeout;

  Credential? get _credential;

  bool get _isDeleted;

  /// Gets an auth token for the associated app.
  ///
  /// [forceRefresh] Whether or not to force a token refresh.
  Future<FirebaseAccessToken> getToken({bool forceRefresh = false}) async {
    final FirebaseAccessToken? cachedToken = _cachedToken;
    final bool expired = cachedToken != null && cachedToken.expirationTime.isBefore(DateTime.now());

    final Future<FirebaseAccessToken>? cachedTokenFuture = _cachedTokenFuture;
    if (cachedTokenFuture != null && !forceRefresh && !expired) {
      return cachedTokenFuture.catchError((Object error) {
        // Update the cached token promise to avoid caching errors. Set it to resolve with the
        // cached token if we have one (and return that promise since the token has still not
        // expired).
        if (cachedToken != null) {
          _cachedTokenFuture = Future<FirebaseAccessToken>.value(cachedToken);
          return _cachedTokenFuture;
        }

        // Otherwise, set the cached token promise to null so that it will force a refresh next
        // time getToken() is called.
        _cachedTokenFuture = null;

        // And re-throw the caught error.
        throw error;
      });
    } else {
      // Clear the outstanding token refresh timeout.
      _tokenRefreshTimeout?.cancel();

      final Future<FirebaseAccessToken> cachedTokenFuture =
          Future<GoogleOAuthAccessToken>(_credential!.getAccessToken).then((GoogleOAuthAccessToken result) {
        final FirebaseAccessToken token =
            FirebaseAccessToken(accessToken: result.accessToken, expirationTime: DateTime.now().add(result.expiresIn));

        final FirebaseAccessToken? cachedToken = _cachedToken;

        final bool hasAccessTokenChanged = cachedToken != null && cachedToken.accessToken != token.accessToken;
        final bool hasExpirationChanged = cachedToken != null && cachedToken.expirationTime != token.expirationTime;
        if (cachedToken == null || hasAccessTokenChanged || hasExpirationChanged) {
          _cachedToken = token;
          _accessTokenController.add(token.accessToken);
        }

        // Establish a timeout to proactively refresh the token every minute starting at five
        // minutes before it expires. Once a token refresh succeeds, no further retries are
        // needed; if it fails, retry every minute until the token expires (resulting in a total
        // of four retries: at 4, 3, 2, and 1 minutes).
        Duration refreshTime = result.expiresIn - const Duration(minutes: 5);
        int numRetries = 4;

        // In the rare cases the token is short-lived (that is, it expires in less than five
        // minutes from when it was fetched), establish the timeout to refresh it after the
        // current minute ends and update the number of retries that should be attempted before
        // the token expires.
        if (refreshTime <= Duration.zero) {
          refreshTime = Duration(seconds: result.expiresIn.inSeconds % 60);
          numRetries = result.expiresIn.inSeconds ~/ 60 - 1;
        }

        // The token refresh timeout keeps the Node.js process alive, so only create it if this
        // instance has not already been deleted.
        if (numRetries > 0 && !_isDeleted) {
          setTokenRefreshTimeout(refreshTime, numRetries);
        }

        return token;
      }).catchError((dynamic error) {
        String errorMessage;
        try {
          errorMessage = error.message as String;
        } catch (_) {
          errorMessage = '$error';
        }

        errorMessage = 'Credential implementation provided to initializeApp() via the '
            '"credential" property failed to fetch a valid Google OAuth2 access token with the '
            'following error: "$errorMessage".';

        if (errorMessage.contains('invalid_grant')) {
          errorMessage += ' There are two likely causes: (1) your server time is not properly '
              'synced or (2) your certificate key file has been revoked. To solve (1), re-sync the '
              'time on your server. To solve (2), make sure the key ID for your key file is still '
              'present at https://console.firebase.google.com/iam-admin/serviceaccounts/project. If '
              'not, generate a new key file at '
              'https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk.';
        }

        throw FirebaseError.app(AppErrorCodes.INVALID_CREDENTIAL, errorMessage);
      });

      return _cachedTokenFuture = cachedTokenFuture;
    }
  }

  /// A stream that emits each time a token changes.
  Stream<String> get onTokenChange => _accessTokenController.stream;

  /// Deletes the FirebaseAppInternals instance.
  void delete() {
    // Cancel the token refresh timeout
    _tokenRefreshTimeout?.cancel();
  }

  /// Establishes timeout to refresh the Google OAuth2 access token used by the SDK.
  ///
  /// [delay] The delay to use for the timeout.
  /// [numRetries] The number of times to retry fetching a new token if the prior fetch failed.
  void setTokenRefreshTimeout(Duration delay, int numRetries) {
    _tokenRefreshTimeout = Timer(delay, () {
      getToken(forceRefresh: true).catchError(() {
        // Ignore the error since this might just be an intermittent failure. If we really cannot
        // refresh the token, an error will be logged once the existing token expires and we try
        // to fetch a fresh one.
        if (numRetries > 0) {
          setTokenRefreshTimeout(const Duration(seconds: 60), numRetries - 1);
        }
      });
    });
  }
}
