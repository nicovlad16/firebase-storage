import '../common/index.dart';
import 'bucket.dart';
import 'hmacKey.dart';

abstract class GetServiceAccountOptions {
  String? userProject;
}

abstract class ServiceAccount {
  String? emailAddress;
}

typedef GetServiceAccountResponse = List<dynamic>; // [ServiceAccount, Metadata];

typedef GetServiceAccountCallback = void Function(
  Exception? err,
  ServiceAccount? serviceAccount,
  Metadata? apiResponse,
);

abstract class CreateBucketQuery {
  late String project;
  late String userProject;
}

abstract class StorageOptions extends ServiceOptions {
  bool? autoRetry;
  int? maxRetries;

  ///  **This option is deprecated.**
  ///  @todo Remove in next major release.
  Future<dynamic>? future;

  ///  The API endpoint of the service used to make requests.
  ///  Defaults to `storage.googleapis.com`.

  String? apiEndpoint;
}

abstract class BucketOptions {
  String? kmsKeyName;
  String? userProject;
}

abstract class Cors {
  int? maxAgeSeconds;
  List<String>? method;
  List<String>? origin;
  List<String>? responseHeader;
}

abstract class Versioning {
  bool? enabled;
}

abstract class CreateBucketRequest {
  bool? archive;
  bool? coldline;
  List<Cors>? cors;
  bool? dra;
  bool? multiRegional;
  bool? nearline;
  bool? regional;
  bool? requesterPays;
  Map<dynamic, dynamic>? retentionPolicy;
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
  Map<dynamic, dynamic>? nextQuery,
  Metadata? apiResponse,
);

abstract class GetBucketsRequest {
  String? prefix;
  String? project;
  bool? autoPaginate;
  int? maxApiCalls;
  int? maxResults;
  String? pageToken;
  String? userProject;
}

abstract class HmacKeyResourceResponse {
  late HmacKeyMetadata metadata;
  late String secret;
}

typedef CreateHmacKeyResponse = List<dynamic>; // [HmacKey, string, HmacKeyResourceResponse];

abstract class CreateHmacKeyOptions {
  String? projectId;
  String? userProject;
}

typedef CreateHmacKeyCallback = void Function(
  Exception? err,
  HmacKey? hmacKey,
  String? secret,
  HmacKeyResourceResponse? apiResponse,
);

abstract class GetHmacKeysOptions {
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
class Storage extends Service {}
