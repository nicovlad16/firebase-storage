import '../common/index.dart';
import 'channel.dart';
import 'file.dart';
import 'notification.dart';
import 'signer.dart';

abstract class SourceObject {
  late String name;
  int? generation;
}

abstract class CreateNotificationQuery {
  String? userProject;
}

abstract class MetadataOptions {
  late String predefinedAcl;
  String? userProject;
}

abstract class BucketOptions {
  String? userProject;
}

typedef GetFilesResponse = List<dynamic>; // [File[], {}, Metadata];

typedef GetFilesCallback = void Function(
  Exception? err,
  List<File>? files,
  Map<dynamic, dynamic>? nextQuery,
  Metadata? apiResponse,
);

abstract class WatchAllOptions {
  String? delimiter;
  int? maxResults;
  String? pageToken;
  String? prefix;
  String? projection;
  String? userProject;
  bool? versions;
}

abstract class AddLifecycleRuleOptions {
  bool? append;
}

abstract class LifecycleRule {
  dynamic action; // {type: string; storageClass?: string} | string;
  dynamic condition; // {[key: string]: boolean | Date | number | string};
  String? storageClass;
}

abstract class EnableLoggingOptions {
  dynamic bucket; // string | Bucket
  late String prefix;
}

abstract class GetFilesOptions {
  bool? autoPaginate;
  String? delimiter;

  /// @deprecated
  String? directory;
  String? endOffset;
  bool? includeTrailingDelimiter;
  String? prefix;
  int? maxApiCalls;
  int? maxResults;
  String? pageToken;
  String? startOffset;
  String? userProject;
  bool? versions;
}

abstract class CombineOptions {
  String? kmsKeyName;
  String? userProject;
}

typedef CombineCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

typedef CombineResponse = List<dynamic>; // [File, Metadata];

abstract class CreateChannelConfig extends WatchAllOptions {
  late String address;
}

abstract class CreateChannelOptions {
  String? userProject;
}

typedef CreateChannelResponse = List<dynamic>; // [Channel, Metadata];

typedef CreateChannelCallback = void Function(Exception? err, Channel? channel, Metadata? apiResponse);

abstract class CreateNotificationOptions {
  Map<String, String>? customAttributes;
  List<String>? eventTypes;
  String? objectNamePrefix;
  String? payloadFormat;
  String? userProject;
}

typedef CreateNotificationCallback = void Function(Exception? err, Notification? notification, Metadata? apiResponse);

typedef CreateNotificationResponse = List<dynamic>; // [Notification, Metadata];

abstract class DeleteBucketOptions {
  bool? ignoreNotFound;
  String? userProject;
}

typedef DeleteBucketResponse = List<Metadata>;

typedef DeleteBucketCallback = void Function(Exception? err, Metadata? apiResponse);

abstract class DeleteFilesOptions extends GetFilesOptions {
  bool? force;
}

typedef DeleteFilesCallback = void Function(
  dynamic err /* Error | Error[] | null */,
  Map<dynamic, dynamic>? apiResponse,
);

typedef DeleteLabelsResponse = List<Metadata>;

typedef DeleteLabelsCallback = SetLabelsCallback;

typedef DisableRequesterPaysResponse = List<Metadata>;

typedef DisableRequesterPaysCallback = void Function(Exception? err, Map<dynamic, dynamic>? apiResponse);

typedef EnableRequesterPaysResponse = List<Metadata>;

typedef EnableRequesterPaysCallback = void Function(Exception? err, Metadata? apiResponse);

abstract class BucketExistsOptions extends GetConfig {
  String? userProject;
}

typedef BucketExistsResponse = List<bool>;

typedef BucketExistsCallback = ExistsCallback;

abstract class GetBucketOptions extends GetConfig {
  String? userProject;
}

typedef GetBucketResponse = List<dynamic>; // [Bucket, Metadata];

typedef GetBucketCallback = void Function(Exception? err, Bucket? bucket, Metadata? apiResponse);

abstract class GetLabelsOptions {
  String? userProject;
}

typedef GetLabelsResponse = List<Metadata>;

typedef GetLabelsCallback = void Function(Exception? err, Map<dynamic, dynamic>? labels);

typedef GetBucketMetadataResponse = List<Metadata>;

typedef GetBucketMetadataCallback = void Function(Exception? err, Metadata? metadata, Metadata? apiResponse);

abstract class GetBucketMetadataOptions {
  String? userProject;
}

abstract class GetBucketSignedUrlConfig {
  String action = 'list';
  String? version; // 'v2' | 'v4';
  String? cname;
  bool? virtualHostedStyle;
  dynamic expires; // string | number | Date;
// todo - extensionHeaders?: http.OutgoingHttpHeaders;
  Query? queryParams;
}

enum BucketActionToHTTPMethod {
  // todo - list = 'GET',
  list,
}

abstract class GetNotificationsOptions {
  String? userProject;
}

typedef GetNotificationsCallback = void Function(
  Exception? err,
  List<Notification>? notifications,
  Metadata? apiResponse,
);

typedef GetNotificationsResponse = List<dynamic>; // [Notification[], Metadata];

abstract class MakeBucketPrivateOptions {
  bool? includeFiles;
  bool? force;
  Metadata? metadata;
  String? userProject;
}

abstract class MakeBucketPrivateRequest extends MakeBucketPrivateOptions {
  bool? private;
}

typedef MakeBucketPrivateResponse = List<List<File>>;

typedef MakeBucketPrivateCallback = void Function(Exception? err, List<File>? files);

abstract class MakeBucketPublicOptions {
  bool? includeFiles;
  bool? force;
}

typedef MakeBucketPublicCallback = void Function(Exception? err, List<File>? files);

typedef MakeBucketPublicResponse = List<List<File>>;

abstract class SetBucketMetadataOptions {
  String? userProject;
}

typedef SetBucketMetadataResponse = List<Metadata>;

typedef SetBucketMetadataCallback = void Function(Exception? err, Metadata? metadata);

typedef BucketLockCallback = void Function(Exception? err, Metadata? apiResponse);

typedef BucketLockResponse = List<Metadata>;

abstract class Labels {
// todo - [key: string]: string;
}

abstract class SetLabelsOptions {
  String? userProject;
}

typedef SetLabelsResponse = List<Metadata>;

typedef SetLabelsCallback = void Function(Exception? err, Metadata? metadata);

abstract class SetBucketStorageClassOptions {
  String? userProject;
}

typedef SetBucketStorageClassCallback = void Function(Exception? err);

typedef UploadResponse = List<dynamic>; // [File, Metadata];

typedef UploadCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

abstract class UploadOptionsBase extends CreateResumableUploadOptions {}

abstract class UploadOptions extends CreateWriteStreamOptions {
  dynamic destination; // string | File;
  dynamic encryptionKey; // string | Buffer;
  String? kmsKeyName;

  void onUploadProgress(dynamic progressEvent);
}

abstract class MakeAllFilesPublicPrivateOptions {
  bool? force;
  bool? private;
  bool? public;
  String? userProject;
}

typedef MakeAllFilesPublicPrivateCallback = void Function(
  dynamic err, // Error | Error[] | null
  List<File>? files,
);

typedef MakeAllFilesPublicPrivateResponse = List<List<File>>;

const int _RESUMABLE_THRESHOLD = 5000000;

// todo - finish class
class Bucket extends ServiceObject {
  // Bucket(Storage storage, String name, BucketOptions? options) {
  //   // todo - options
  //
  //   // Allow for "gs://"-style input, and strip any trailing slashes.
  //   name = name.replaceAll('/^gs:\/\//', '').replaceAll('/\/+\$/', '');
  //
  //   final Map<dynamic, dynamic> requestQueryObject = <dynamic, dynamic>{};
  //
  //   userProject = options!.userProject;
  //   if (userProject.runtimeType == String) {
  //     requestQueryObject['userProject'] = userProject;
  //   }
  //
  //   this.storage = storage;
  //   this.name = name;
  //   this.userProject = userProject;
  // }

  Metadata metadata;
  // String name;

  /// A reference to the {@link Storage} associated with this {@link Bucket}
  /// instance.
  /// @name Bucket#storage
  /// @type {Storage}
  // Storage storage;

  /// A user project to apply to each request from this bucket.
  /// @name Bucket#userProject
  /// @type {string}
  String? userProject;

  // Acl acl;
  // Iam iam;
  //
  // Function getFilesStream;
  // URLSigner signer;

// String getId() {
//   return '';
// }
}
