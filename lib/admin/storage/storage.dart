import 'package:firebase_storage/admin/app/firebase_app.dart';
import 'package:firebase_storage/admin/auth/credential-internal.dart';
import 'package:firebase_storage/admin/auth/index.dart';
import 'package:firebase_storage/admin/utils/error.dart';
import 'package:firebase_storage/admin/utils/index.dart' as utils;
import 'package:firebase_storage/storage/bucket.dart';

import '../../storage/storage.dart' as storage;

class Storage implements storage.Storage {
  Storage(this._appInternal) {
    final String? projectId = utils.getExplicitProjectId(_appInternal);
    final Credential? credential = _appInternal.options.credential;

    if (credential is ServiceAccountCredential) {}
    // todo - finish constructor
    storageClient = storage.Storage();
  }

  /// @param name Optional name of the bucket to be retrieved. If name is not specified,
  /// retrieves a reference to the default bucket.
  /// @returns A [Bucket](https://cloud.google.com/nodejs/docs/reference/storage/latest/Bucket)
  /// instance as defined in the `@google-cloud/storage` package.
  Bucket bucket(String? name) {
    final String? bucketName = name ?? _appInternal.options.storageBucket;

    if (bucketName != null && bucketName.isNotEmpty) {
      return Bucket();
      // todo - return storageClient.bucket(bucketName);
    }
    throw FirebaseError.app(
      'storage/invalid-argument',
      'Bucket name not specified or invalid. Specify a valid bucket name '
          'via the storageBucket option when initializing the app, or '
          'specify the bucket name explicitly when calling the getBucket() method.',
    );
  }

  final FirebaseApp _appInternal;
  late storage.Storage storageClient;

  /// @return The app associated with this Storage instance.
  FirebaseApp get app {
    return _appInternal;
  }
}
