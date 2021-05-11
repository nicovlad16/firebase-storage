import 'package:firebase_storage/storage/channel.dart';

import '../common/index.dart';
import 'bucket.dart';
import 'hmacKey.dart';

class GetServiceAccountOptions {
  String? userProject;
}

class ServiceAccount {
  ServiceAccount([this.emailAddress]);

  String? emailAddress;
}

typedef GetServiceAccountResponse = List<dynamic>; // [ServiceAccount, Metadata];

typedef GetServiceAccountCallback = void Function(
  Exception? err,
  ServiceAccount? serviceAccount,
  Metadata? apiResponse,
);

class CreateBucketQuery {
  CreateBucketQuery({required this.project, required this.userProject});

  String project;
  String userProject;
}

class StorageOptions extends ServiceOptions {
  StorageOptions(this.autoRetry, this.maxRetries, this.future, this.apiEndpoint);

  bool? autoRetry;
  int? maxRetries;

  ///  **This option is deprecated.**
  ///  @todo Remove in next major release.
  Future<dynamic>? future;

  ///  The API endpoint of the service used to make requests.
  ///  Defaults to `storage.googleapis.com`.
  String? apiEndpoint;
}

class BucketOptions {
  BucketOptions({this.kmsKeyName, this.userProject});

  String? kmsKeyName;

  String? userProject;
}

class Cors {
  Cors({this.maxAgeSeconds, this.method, this.origin, this.responseHeader});

  int? maxAgeSeconds;
  List<String>? method;
  List<String>? origin;
  List<String>? responseHeader;
}

class Versioning {
  Versioning([this.enabled]);

  bool? enabled;
}

class CreateBucketRequest {
  CreateBucketRequest({
    this.archive,
    this.coldline,
    this.cors,
    this.dra,
    this.multiRegional,
    this.nearline,
    this.regional,
    this.requesterPays,
    this.retentionPolicy,
    this.standard,
    this.storageClass,
    this.userProject,
    this.location,
    this.versioning,
  });

  bool? archive;
  bool? coldline;
  List<Cors>? cors;
  bool? dra;
  bool? multiRegional;
  bool? nearline;
  bool? regional;
  bool? requesterPays;
  Map<String, dynamic>? retentionPolicy;
  bool? standard;
  String? storageClass;
  String? userProject;
  String? location;
  Versioning? versioning;
}

typedef CreateBucketResponse = List<dynamic>; // [Bucket, Metadata];

typedef BucketCallback = void Function(Exception? err, Bucket? bucket, Metadata? apiResponse);

typedef GetBucketsResponse = List<dynamic>; // [Bucket[], {}, Metadata];

typedef GetBucketsCallback = void Function(
  Exception? err,
  List<Bucket>? buckets,
  Map<String, dynamic>? nextQuery,
  Metadata? apiResponse,
);

class GetBucketsRequest {
  GetBucketsRequest(
      {this.prefix,
      this.project,
      this.autoPaginate,
      this.maxApiCalls,
      this.maxResults,
      this.pageToken,
      this.userProject});

  String? prefix;
  String? project;
  bool? autoPaginate;
  int? maxApiCalls;
  int? maxResults;
  String? pageToken;
  String? userProject;
}

class HmacKeyResourceResponse {
  HmacKeyResourceResponse(this.metadata, this.secret);

  HmacKeyMetadata metadata;
  String secret;
}

typedef CreateHmacKeyResponse = List<dynamic>; // [HmacKey, string, HmacKeyResourceResponse];

class CreateHmacKeyOptions {
  CreateHmacKeyOptions({this.projectId, this.userProject});

  String? projectId;
  String? userProject;
}

typedef CreateHmacKeyCallback = void Function(
  Exception? err,
  HmacKey? hmacKey,
  String? secret,
  HmacKeyResourceResponse? apiResponse,
);

class GetHmacKeysOptions {
  GetHmacKeysOptions(
      {this.projectId,
      this.serviceAccountEmail,
      this.showDeletedKeys,
      this.autoPaginate,
      this.maxApiCalls,
      this.maxResults,
      this.pageToken,
      this.userProject});

  String? projectId;
  String? serviceAccountEmail;
  bool? showDeletedKeys;
  bool? autoPaginate;
  int? maxApiCalls;
  int? maxResults;
  String? pageToken;
  String? userProject;
}

typedef GetHmacKeysCallback = void Function(
  Exception? err,
  List<HmacKey>? hmacKeys,
  Map<dynamic, dynamic>? nextQuery,
  Metadata? apiResponse,
);

typedef GetHmacKeysResponse = List<List<HmacKey>>;

const String PROTOCOL_REGEX = '/^(\w*):\/\//';

// todo - finish class
class Storage extends Service {
  Storage(ServiceConfig config, ServiceOptions options) : super(config, options);

  static late Bucket bucket;
  static late Channel channel;
  // static late File file;
  static late HmacKey hmacKey;

  // static Acl acl = Acl(<String, dynamic>{
  //   'OWNER_ROLE': 'OWNER',
  //   'READER_ROLE': 'READER',
  //   'WRITER_ROLE': 'WRITER',
  // });
}
