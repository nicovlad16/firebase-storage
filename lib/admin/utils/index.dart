import 'dart:io';

import 'package:firebase_storage/admin/app/firebase_app.dart';
import 'package:firebase_storage/admin/auth/credential-internal.dart';
import 'package:firebase_storage/admin/auth/index.dart';

/// Returns the Google Cloud project ID associated with a Firebase app, if it's explicitly
/// specified in either the Firebase app options, credentials or the local environment.
/// Otherwise returns null.
///
/// @param app A Firebase app to get the project ID from.
///
/// @return A project ID string or null.
String? getExplicitProjectId(FirebaseApp app) {
  final FirebaseAppOptions options = app.options;
  if (options.projectId != null && options.projectId!.isNotEmpty) {
    return options.projectId;
  }

  final Credential? credential = app.options.credential;
  if (credential is ServiceAccountCredential) {
    return credential.projectId;
  }

  final String? projectId = Platform.environment['GOOGLE_CLOUD_PROJECT'] ?? Platform.environment['GCLOUD_PROJECT'];
  if (projectId != null && projectId.isNotEmpty) {
    return projectId;
  }
  return null;
}
