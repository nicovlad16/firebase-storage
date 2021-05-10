import 'package:firebase_storage/admin/firebase-namespace-api.dart';

const DEFAULT_APP_NAME = '[DEFAULT]';

/// Returns the App instance with the provided name (or the default App instance
/// if no name is provided).
///
/// @param appName Optional name of the FirebaseApp instance to return.
/// @return The App instance which has the provided name.
App app
(

String appName = DEFAULT_APP_NAME
) {
if (typeof appName !== 'string' || appName === '') {
throw new FirebaseAppError(
AppErrorCodes.INVALID_APP_NAME,
`Invalid Firebase app name "${appName}" provided. App name must be a non-empty string.`,
);
} else if (!(appName in this.apps_)) {
let errorMessage: string = (appName === DEFAULT_APP_NAME)
? 'The default Firebase app does not exist. ' : `Firebase app named "${appName}" does not exist. `;
errorMessage += 'Make sure you call initializeApp() before using any of the Firebase services.';

throw new FirebaseAppError(AppErrorCodes.NO_APP, errorMessage);
}

return this.apps_[appName];
}


/// Returns an array of all the non-deleted App instances.
List<App> get apps {
// Return a copy so the caller cannot mutate the array
  return Object.keys(this.apps_).map((appName) => this.apps_[appName]);
}