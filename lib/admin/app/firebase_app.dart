library app;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/admin/auth/index.dart';
import 'package:firebase_storage/admin/utils/error.dart';

part 'firebase_access_token.dart';
part 'firebase_app_internals.dart';
part 'firebase_app_options.dart';
part 'lifecycle_event.dart';

const String kDefaultAppName = '[DEFAULT]';

/// Constant holding the environment variable name with the default config.
/// If the environment variable contains a string that starts with '{' it will be parsed as JSON,
/// otherwise it will be assumed to be pointing to a file.
const String kFirebaseConfigVar = 'FIREBASE_CONFIG';

class FirebaseApp with FirebaseAppInternals {
  FirebaseApp._({
    required String name,
    required FirebaseAppOptions options,
  })  : _name = name,
        _options = options;

  factory FirebaseApp.initializeApp({
    String appName = kDefaultAppName,
    Credential? credential,
    Map<String, String>? databaseAuthVariableOverride,
    String? databaseURL,
    String? serviceAccountId,
    String? storageBucket,
    String? projectId,
    String? httpAgent,
  }) {
    if (appName.isEmpty) {
      throw FirebaseError.app(
        AppErrorCodes.INVALID_APP_NAME,
        'Invalid Firebase app name "$appName" provided. App name must be a non-empty string.',
      );
    } else if (_apps.containsKey(appName)) {
      if (appName == kDefaultAppName) {
        throw FirebaseError.app(
          AppErrorCodes.DUPLICATE_APP,
          'The default Firebase app already exists. This means you called initializeApp() '
          'more than once without providing an app name as the second argument. In most cases '
          'you only need to call initializeApp() once. But if you do want to initialize '
          'multiple apps, pass a second argument to initializeApp() to give each app a unique '
          'name.',
        );
      } else {
        throw FirebaseError.app(
          AppErrorCodes.DUPLICATE_APP,
          'Firebase app named "$appName" already exists. This means you called initializeApp() '
          'more than once with the same app name as the second argument. Make sure you provide a '
          'unique name every time you call initializeApp().',
        );
      }
    }

    final FirebaseAppOptions options = _buildFirebaseOptions(
      credential: credential,
      databaseAuthVariableOverride: databaseAuthVariableOverride,
      databaseURL: databaseURL,
      serviceAccountId: serviceAccountId,
      storageBucket: storageBucket,
      projectId: projectId,
      httpAgent: httpAgent,
    );

    final FirebaseApp app = FirebaseApp._(name: appName, options: options);
    _lifecycleController.add(FirebaseAppLifecycleEvent(FirebaseAppLifecycleState.created, app));
    return _apps[appName] = app;
  }

  factory FirebaseApp.app({String appName = kDefaultAppName}) {
    if (appName.isEmpty) {
      throw FirebaseError.app(
        AppErrorCodes.INVALID_APP_NAME,
        'Invalid Firebase app name "$appName" provided. App name must be a non-empty string.',
      );
    } else if (!_apps.containsKey(appName)) {
      String errorMessage = (appName == kDefaultAppName)
          ? 'The default Firebase app does not exist. '
          : 'Firebase app named "$appName" does not exist. ';
      errorMessage += 'Make sure you call initializeApp() before using any of the Firebase services.';

      throw FirebaseError.app(AppErrorCodes.NO_APP, errorMessage);
    }

    return _apps[appName]!;
  }

  final String _name;
  final FirebaseAppOptions _options;

  static final Map<String, FirebaseApp> _apps = <String, FirebaseApp>{};
  static final StreamController<FirebaseAppLifecycleEvent> _lifecycleController =
      StreamController<FirebaseAppLifecycleEvent>.broadcast();

  /// Returns a list of all the non-deleted FirebaseApp instances.
  static List<FirebaseApp> get apps => _apps.values.toList();

  /// Emits on app-related events like app creation and deletion.
  static Stream<FirebaseAppLifecycleEvent> get onLifecycleEvent => _lifecycleController.stream;

  @override
  Credential? get _credential => _options.credential;

  @override
  bool _isDeleted = false;

  /// Returns the name for the FirebaseApp instance.
  String get name {
    _checkDestroyed();
    return _name;
  }

  /// Returns the options for the FirebaseApp instance.
  FirebaseAppOptions get options {
    _checkDestroyed();
    return _options;
  }

  /// Deletes the FirebaseApp instance.
  @override
  void delete() {
    _checkDestroyed();
    _apps.remove(_name);
    _lifecycleController.add(FirebaseAppLifecycleEvent(FirebaseAppLifecycleState.created, this));

    super.delete();
    _isDeleted = true;
  }

  void _checkDestroyed() {
    if (_isDeleted) {
      throw FirebaseError.app(
        AppErrorCodes.APP_DELETED,
        'Firebase app named "$_name" has already been deleted.',
      );
    }
  }

  /// Parse the file pointed to by the FIREBASE_CONFIG_VAR, if it exists.
  /// Or if the FIREBASE_CONFIG_ENV contains a valid JSON object, parse it directly.
  /// If the environment variable contains a string that starts with '{' it will be parsed as JSON,
  /// otherwise it will be assumed to be pointing to a file.
  static FirebaseAppOptions _buildFirebaseOptions({
    Credential? credential,
    Map<String, String>? databaseAuthVariableOverride,
    String? databaseURL,
    String? serviceAccountId,
    String? storageBucket,
    String? projectId,
    String? httpAgent,
  }) {
    credential ??= getApplicationDefault(httpAgent);

    if (databaseAuthVariableOverride == null ||
        databaseURL == null ||
        serviceAccountId == null ||
        storageBucket == null ||
        projectId == null ||
        httpAgent == null) {
      const String config = String.fromEnvironment(kFirebaseConfigVar);

      if (config.isNotEmpty) {
        String contents;
        Map<String, dynamic> options;
        try {
          contents = config.startsWith('{') ? config : File(config).readAsStringSync();
          options = jsonDecode(contents) as Map<String, dynamic>;
        } catch (error) {
          // Throw a nicely formed error message if the file contents cannot be parsed
          throw FirebaseError.app(
            AppErrorCodes.INVALID_APP_OPTIONS,
            'Failed to parse app options file: $error',
          );
        }

        databaseAuthVariableOverride =
            (databaseAuthVariableOverride ?? options['databaseAuthVariableOverride']) as Map<String, String>?;
        databaseURL = (databaseURL ?? options['databaseURL']) as String?;
        serviceAccountId = (serviceAccountId ?? options['serviceAccountId']) as String?;
        storageBucket = (storageBucket ?? options['storageBucket']) as String?;
        projectId = (projectId ?? options['projectId']) as String?;
        httpAgent = (httpAgent ?? options['httpAgent']) as String?;
      }
    }

    return FirebaseAppOptions(
      credential: credential,
      databaseAuthVariableOverride: databaseAuthVariableOverride,
      databaseURL: databaseURL,
      serviceAccountId: serviceAccountId,
      storageBucket: storageBucket,
      projectId: projectId,
      httpAgent: httpAgent,
    );
  }
}
