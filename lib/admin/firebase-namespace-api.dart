import 'package:firebase_storage/admin/auth/index.dart';

/// Available options to pass to [`initializeApp()`](admin#.initializeApp).
class AppOptions {
  /// A {@link credential.Credential `Credential`} object used to
  /// authenticate the Admin SDK.
  ///
  /// See [Initialize the SDK](/docs/admin/setup#initialize_the_sdk) for detailed
  /// documentation and code samples.
  Credential? credential;

  /// The object to use as the [`auth`](/docs/reference/security/database/#auth)
  /// variable in your Realtime Database Rules when the Admin SDK reads from or
  /// writes to the Realtime Database. This allows you to downscope the Admin SDK
  /// from its default full read and write privileges.
  ///
  /// You can pass `null` to act as an unauthenticated client.
  ///
  /// See
  /// [Authenticate with limited privileges](/docs/database/admin/start#authenticate-with-limited-privileges)
  /// for detailed documentation and code samples.
  Map<String, dynamic>? databaseAuthVariableOverride;

  /// The URL of the Realtime Database from which to read and write data.
  String? databaseURL;

  /// The ID of the service account to be used for signing custom tokens. This
  /// can be found in the `client_email` field of a service account JSON file.
  String? serviceAccountId;

  /// The name of the Google Cloud Storage bucket used for storing application data.
  /// Use only the bucket name without any prefixes or additions (do *not* prefix
  /// the name with "gs://").
  String? storageBucket;

  /// The ID of the Google Cloud project associated with the App.
  String? projectId;

  /// An [HTTP Agent](https://nodejs.org/api/http.html#http_class_http_agent)
  /// to be used when making outgoing HTTP calls. This Agent instance is used
  /// by all services that make REST calls (e.g. `auth`, `messaging`,
  /// `projectManagement`).
  ///
  /// Realtime Database and Firestore use other means of communicating with
  /// the backend servers, so they do not use this HTTP Agent. `Credential`
  /// instances also do not use this HTTP Agent, but instead support
  /// specifying an HTTP Agent in the corresponding factory methods.

// todo - http client
// httpAgent?: Agent;
}

class App {
  App(this.name, this.options);

  /// The (read-only) name for this app.
  ///
  /// The default app's name is `"[DEFAULT]"`.
  ///
  /// @example
  /// ```javascript
  /// // The default app's name is "[DEFAULT]"
  /// admin.initializeApp(defaultAppConfig);
  /// console.log(admin.app().name);  // "[DEFAULT]"
  /// ```
  ///
  /// @example
  /// ```javascript
  /// // A named app's name is what you provide to initializeApp()
  /// var otherApp = admin.initializeApp(otherAppConfig, "other");
  /// console.log(otherApp.name);  // "other"
  /// ```
  String name;

  /// The (read-only) configuration options for this app. These are the original
  /// parameters given in
  /// {@link
  ///   https://firebase.google.com/docs/reference/admin/node/admin#.initializeApp
  ///   `admin.initializeApp()`}.
  ///
  /// @example
  /// ```javascript
  /// var app = admin.initializeApp(config);
  /// console.log(app.options.credential === config.credential);  // true
  /// console.log(app.options.databaseURL === config.databaseURL);  // true
  /// ```
  AppOptions options;

// todo - methods
// auth(): auth.Auth;
// database(url?: string): database.Database;
// firestore(): firestore.Firestore;
// instanceId(): instanceId.InstanceId;
// machineLearning(): machineLearning.MachineLearning;
// messaging(): messaging.Messaging;
// projectManagement(): projectManagement.ProjectManagement;
// remoteConfig(): remoteConfig.RemoteConfig;
// securityRules(): securityRules.SecurityRules;
// storage(): storage.Storage;

  /// Renders this local `FirebaseApp` unusable and frees the resources of
  /// all associated services (though it does *not* clean up any backend
  /// resources). When running the SDK locally, this method
  /// must be called to ensure graceful termination of the process.
  ///
  /// @example
  /// ```javascript
  /// app.delete()
  ///   .then(function() {
  ///     console.log("App deleted successfully");
  ///   })
  ///   .catch(function(error) {
  ///     console.log("Error deleting app:", error);
  ///   });
  /// ```

// todo - method
// Future<void> delete();
}
