import 'package:firebase_storage/storage/acl.dart';
import 'package:firebase_storage/storage/iam.dart';
import 'package:firebase_storage/storage/storage.dart';

import '../common/index.dart';
import '../util/util.dart' as util;
import 'channel.dart';
import 'file.dart';
import 'notification.dart';
import 'signer.dart';

class SourceObject {
  SourceObject(this.name, [this.generation]);

  String name;
  int? generation;
}

class CreateNotificationQuery {
  CreateNotificationQuery([this.userProject]);

  String? userProject;
}

class MetadataOptions {
  MetadataOptions(this.predefinedAcl, [this.userProject]);

  String predefinedAcl;
  String? userProject;
}

class BucketOptions {
  BucketOptions({this.kmsKeyName, this.userProject});

  String? kmsKeyName;

  String? userProject;
}

typedef GetFilesResponse = List<dynamic>; // [File[], {}, Metadata];

typedef GetFilesCallback = void Function(
  Exception? err,
  List<File>? files,
  Map<dynamic, dynamic>? nextQuery,
  Metadata? apiResponse,
);

class WatchAllOptions {
  WatchAllOptions({
    this.delimiter,
    this.maxResults,
    this.pageToken,
    this.prefix,
    this.projection,
    this.userProject,
    this.versions,
  });

  String? delimiter;
  int? maxResults;
  String? pageToken;
  String? prefix;
  String? projection;
  String? userProject;
  bool? versions;
}

class AddLifecycleRuleOptions {
  AddLifecycleRuleOptions([this.append]);

  bool? append;
}

class LifecycleRule {
  LifecycleRule({required this.action, required this.condition, this.storageClass});

  dynamic action; // {type: string; storageClass?: string} | string;
  dynamic condition; // {[key: string]: boolean | Date | number | string};
  String? storageClass;
}

class EnableLoggingOptions {
  EnableLoggingOptions(this.bucket, this.prefix);

  dynamic bucket; // string | Bucket
  String prefix;
}

class GetFilesOptions {
  GetFilesOptions({
    this.autoPaginate,
    this.delimiter,
    this.directory,
    this.endOffset,
    this.includeTrailingDelimiter,
    this.prefix,
    this.maxApiCalls,
    this.maxResults,
    this.pageToken,
    this.startOffset,
    this.userProject,
    this.versions,
  });

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

class CombineOptions {
  CombineOptions({this.kmsKeyName, this.userProject});

  String? kmsKeyName;
  String? userProject;
}

typedef CombineCallback = void Function(Exception? err, File? file, Metadata apiResponse);

typedef CombineResponse = List<dynamic>; // [File, Metadata];

class CreateChannelConfig extends WatchAllOptions {
  CreateChannelConfig(this.address);

  String address;
}

class CreateChannelOptions {
  CreateChannelOptions([this.userProject]);

  String? userProject;
}

typedef CreateChannelResponse = List<dynamic>; // [Channel, Metadata];

typedef CreateChannelCallback = void Function(Exception? err, Channel? channel, Metadata apiResponse);

class CreateNotificationOptions {
  CreateNotificationOptions({
    this.customAttributes,
    this.eventTypes,
    this.objectNamePrefix,
    this.payloadFormat,
    this.userProject,
  });

  Map<String, String>? customAttributes;
  List<String>? eventTypes;
  String? objectNamePrefix;
  String? payloadFormat;
  String? userProject;
}

typedef CreateNotificationCallback = void Function(Exception? err, Notification? notification, Metadata apiResponse);

typedef CreateNotificationResponse = List<dynamic>; // [Notification, Metadata];

class DeleteBucketOptions {
  DeleteBucketOptions({this.ignoreNotFound, this.userProject});

  bool? ignoreNotFound;
  String? userProject;
}

typedef DeleteBucketResponse = List<Metadata>;

typedef DeleteBucketCallback = void Function(Exception? err, Metadata? apiResponse);

class DeleteFilesOptions extends GetFilesOptions {
  DeleteFilesOptions({this.force});

  bool? force;
}

typedef DeleteFilesCallback = void Function(
  dynamic err /* Error | Error[] | null */,
  Map<String, dynamic>? apiResponse,
);

typedef DeleteLabelsResponse = List<Metadata>;

typedef DeleteLabelsCallback = SetLabelsCallback;

typedef DisableRequesterPaysResponse = List<Metadata>;

typedef DisableRequesterPaysCallback = void Function(Exception? err, Map<String, dynamic>? apiResponse);

typedef EnableRequesterPaysResponse = List<Metadata>;

typedef EnableRequesterPaysCallback = void Function(Exception? err, Metadata? apiResponse);

class BucketExistsOptions extends GetConfig {
  BucketExistsOptions({this.userProject});

  String? userProject;
}

typedef BucketExistsResponse = List<bool>;

typedef BucketExistsCallback = ExistsCallback;

class GetBucketOptions extends GetConfig {
  GetBucketOptions({this.userProject});

  String? userProject;
}

typedef GetBucketResponse = List<dynamic>; // [Bucket, Metadata];

typedef GetBucketCallback = void Function(Exception? err, Bucket? bucket, Metadata apiResponse);

class GetLabelsOptions {
  GetLabelsOptions({this.userProject});

  String? userProject;
}

typedef GetLabelsResponse = List<Metadata>;

typedef GetLabelsCallback = void Function(Exception? err, Map<String, dynamic>? labels);

typedef GetBucketMetadataResponse = List<Metadata>;

typedef GetBucketMetadataCallback = void Function(Exception? err, Metadata? metadata, Metadata apiResponse);

class GetBucketMetadataOptions {
  GetBucketMetadataOptions({this.userProject});

  String? userProject;
}

class GetBucketSignedUrlConfig {
  GetBucketSignedUrlConfig({
    this.version,
    this.cname,
    this.virtualHostedStyle,
    this.expires,
    this.queryParams,
  }) : action = 'list';

  String action;
  String? version; // 'v2' | 'v4';
  String? cname;
  bool? virtualHostedStyle;
  dynamic expires; // string | number | Date;
// todo - extensionHeaders?: http.OutgoingHttpHeaders;
  Query? queryParams;
}

class BucketActionToHTTPMethod {
  const BucketActionToHTTPMethod._(this._method);

  final String _method;

  static const BucketActionToHTTPMethod list = BucketActionToHTTPMethod._('GET');
}

abstract class GetNotificationsOptions {
  String? userProject;
}

typedef GetNotificationsCallback = void Function(
  Exception? err,
  List<Notification>? notifications,
  Metadata apiResponse,
);

typedef GetNotificationsResponse = List<dynamic>; // [Notification[], Metadata];

class MakeBucketPrivateOptions {
  MakeBucketPrivateOptions({this.includeFiles, this.force, this.metadata, this.userProject});

  bool? includeFiles;
  bool? force;
  Metadata? metadata;
  String? userProject;
}

class MakeBucketPrivateRequest extends MakeBucketPrivateOptions {
  MakeBucketPrivateRequest([this.private]);

  bool? private;
}

typedef MakeBucketPrivateResponse = List<List<File>>;

typedef MakeBucketPrivateCallback = void Function(Exception? err, List<File>? files);

class MakeBucketPublicOptions {
  MakeBucketPublicOptions({this.includeFiles, this.force});

  bool? includeFiles;
  bool? force;
}

typedef MakeBucketPublicCallback = void Function(Exception? err, List<File>? files);

typedef MakeBucketPublicResponse = List<List<File>>;

class SetBucketMetadataOptions {
  SetBucketMetadataOptions([this.userProject]);

  String? userProject;
}

typedef SetBucketMetadataResponse = List<Metadata>;

typedef SetBucketMetadataCallback = void Function(Exception? err, Metadata? metadata);

typedef BucketLockCallback = void Function(Exception? err, Metadata? apiResponse);

typedef BucketLockResponse = List<Metadata>;

class Labels {
  Labels() : values = <String, String>{};
  Map<String, String> values;
}

class SetLabelsOptions {
  SetLabelsOptions([this.userProject]);

  String? userProject;
}

typedef SetLabelsResponse = List<Metadata>;

typedef SetLabelsCallback = void Function(Exception? err, Metadata? metadata);

class SetBucketStorageClassOptions {
  SetBucketStorageClassOptions([this.userProject]);

  String? userProject;
}

typedef SetBucketStorageClassCallback = void Function(Exception? err);

typedef UploadResponse = List<dynamic>; // [File, Metadata];

typedef UploadCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

class UploadOptionsBase extends CreateResumableUploadOptions {}

class UploadOptions extends CreateWriteStreamOptions {
  UploadOptions({required this.destination, required this.encryptionKey, this.kmsKeyName, this.onUploadProgress});

  dynamic destination; // string | File;
  dynamic encryptionKey; // string | Buffer;
  String? kmsKeyName;
  util.OnUploadProgressCallback? onUploadProgress;
}

class MakeAllFilesPublicPrivateOptions {
  MakeAllFilesPublicPrivateOptions({this.force, this.private, this.public, this.userProject});

  bool? force;
  bool? private;
  bool? public;
  String? userProject;
}

typedef MakeAllFilesPublicPrivateCallback = void Function(
  dynamic err, // Error | Error[] | null
  List<File>? files,
);

typedef MakeAllFilesPublicPrivateResponse = List<List<File>>; // [File[]];

const int _RESUMABLE_THRESHOLD = 5000000;

// todo - finish class
class Bucket extends ServiceObject {
  Bucket(this.storage, String name, [BucketOptions? options])
      :
        // Allow for "gs://"-style input, and strip any trailing slashes.
        name = name.replaceAll(RegExp('^gs://'), '').replaceAll(RegExp('/\+\$'), ''),
        super(ServiceObjectConfig(baseUrl: '/b', id: name, parent: storage)) {
    // todo - options

    if (options != null) {
      userProject = options.userProject;
    }

    final AclOptions aclOptions = AclOptions('/acl');
    acl = Acl(aclOptions);
    iam = Iam(this);

    // todo - finish constructor
  }

  Metadata metadata;
  String name;

  /// A reference to the {@link Storage} associated with this {@link Bucket}
  /// instance.
  /// @name Bucket#storage
  /// @type {Storage}
  Storage storage;

  /// A reference to the {@link Storage} associated with this {@link Bucket}
  /// instance.
  /// @name Bucket#storage
  /// @type {Storage}
  // Storage storage;

  /// A user project to apply to each request from this bucket.
  /// @name Bucket#userProject
  /// @type {string}
  late String? userProject;

  late Acl acl;
  late Iam iam;

  late Function getFilesStream;
  late URLSigner signer;

  String getId() {
    return id!;
  }

  @override
  Future<void> request(DecorateRequestOptions reqOpts, BodyResponseCallback? callback) async {
    if (userProject != null && (reqOpts.qs['userProject'] == null)) {
      reqOpts.qs['userProject'] = userProject;
    }
    return super.request(reqOpts, callback!);
  }
}
