part of app;

/// Type representing the options object passed into initializeApp().
class FirebaseAppOptions {
  FirebaseAppOptions({
    required this.credential,
    this.databaseAuthVariableOverride,
    this.databaseURL,
    this.serviceAccountId,
    this.storageBucket,
    this.projectId,
    this.httpAgent,
  });

  final Credential? credential;
  final Map<String, String>? databaseAuthVariableOverride;
  final String? databaseURL;
  final String? serviceAccountId;
  final String? storageBucket;
  final String? projectId;
  final String? httpAgent;
}
