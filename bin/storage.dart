abstract class GetServiceAccountOptions {
  String? userProject;
}

// todo - type
abstract class ServiceAccount {
  String? emailAddress;
}

// todo - interface callback
abstract class GetServiceAccountCallback {}

abstract class CreateBucketQuery {
  late String project;
  late String userProject;
}

// todo - interface implements - import from cloud package
abstract class StorageOptions {
  bool? autoRetry;
  int? maxRetries;
  Future<dynamic>? future;

  // The API endpoint of the service used to make requests.
  // Defaults to `storage.googleapis.com`.
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
  dynamic retentionPolicy;
  bool? standard;
  String? storageClass;
  String? userProject;
  String? location;
  Versioning? versioning;
}

// todo - type

// todo - interface callback
abstract class BucketCallback {}

// todo - type

// todo - interface callback
abstract class GetBucketsCallback {}

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
  // todo - class
  //  metadata: HmacKeyMetadata;
  late String secret;
}

// todo - type - CreateHmacKeyResponse

abstract class CreateHmacKeyOptions {
  String? projectId;
  String? userProject;
}

// todo - interface callback - CreateHmacKeyCallback

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

// todo - interface callback
abstract class GetHmacKeysCallback {}

// todo - type - GetHmacKeysResponse

const PROTOCOL_REGEX = '/^(\w*):\/\//';

// todo - extend Service, add fields and methods
class Storage {}
