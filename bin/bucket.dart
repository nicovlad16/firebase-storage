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

// todo - type - GetFilesResponse
// todo - interface callback - GetFilesResponse

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
// todo - action: {type: string; storageClass?: string} | string;
// todo - condition: {[key: string]: boolean | Date | number | string};
  String? storageClass;
}

abstract class EnableLoggingOptions {
// todo - bucket?: string | Bucket;
  late String prefix;
}

abstract class GetFilesOptions {
  bool? autoPaginate;
  String? delimiter;

  /** @deprecated */
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

// todo - interface callback - CombineCallback

// todo - type - CombineResponse

abstract class CreateChannelConfig extends WatchAllOptions {
  late String address;
}

abstract class CreateChannelOptions {
  String? userProject;
}

// todo - type - CreateChannelResponse

// todo - interface callback - CreateChannelResponse

abstract class CreateNotificationOptions {
  Map<String, String>? customAttributes;
  List<String>? eventTypes;
  String? objectNamePrefix;
  String? payloadFormat;
  String? userProject;
}

// todo - interface callback - CreateNotificationCallback

// todo - type - CreateNotificationResponse

abstract class DeleteBucketOptions {
  bool? ignoreNotFound;
  String? userProject;
}

// todo - type - DeleteBucketResponse

// todo - interface callback - DeleteBucketCallback

abstract class DeleteFilesOptions extends GetFilesOptions {
  bool? force;
}

// todo - interface callback - DeleteFilesCallback

// todo - type - DeleteLabelsResponse

// todo - interface callback - DeleteLabelsCallback

// todo - type - DisableRequesterPaysResponse

// todo - interface callback - DisableRequesterPaysCallback

// todo - type - EnableRequesterPaysResponse

// todo - interface callback - EnableRequesterPaysCallback

// todo - import class
// abstract class BucketExistsOptions extends GetConfig {
// String? userProject;
// }

// todo - type - BucketExistsResponse

// todo - interface callback - BucketExistsCallback

// todo - import class
// abstract class GetBucketOptions extends GetConfig {
// String? userProject;
// }

// todo - type - GetBucketResponse

// todo - interface callback - GetBucketCallback

abstract class GetLabelsOptions {
  String? userProject;
}

// todo - type - GetLabelsResponse

// todo - interface callback - GetLabelsCallback

// todo - type - GetBucketMetadataResponse

// todo - interface callback - GetBucketMetadataCallback

abstract class GetBucketMetadataOptions {
  String? userProject;
}

abstract class GetBucketSignedUrlConfig {
  String action = 'list';
  String? version; // todo - : 'v2' | 'v4';
  String? cname;
  bool? virtualHostedStyle;
// todo - expires: string | number | Date;
// todo - extensionHeaders?: http.OutgoingHttpHeaders;
// todo - queryParams?: Query;
}

enum BucketActionToHTTPMethod {
  // todo - list = 'GET',
  list,
}

abstract class GetNotificationsOptions {
  String? userProject;
}

// todo - interface callback - GetNotificationsCallback

// todo - type - GetNotificationsResponse

abstract class MakeBucketPrivateOptions {
  bool? includeFiles;
  bool? force;
// todo - import metadata?: Metadata;
  String? userProject;
}

abstract class MakeBucketPrivateRequest extends MakeBucketPrivateOptions {
  bool? private;
}

// todo - type - MakeBucketPrivateResponse

// todo - interface callback - MakeBucketPrivateResponse

abstract class MakeBucketPublicOptions {
  bool? includeFiles;
  bool? force;
}

// todo - interface callback - MakeBucketPublicCallback

// todo - type - MakeBucketPublicResponse

abstract class SetBucketMetadataOptions {
  String? userProject;
}

// todo - type - SetBucketMetadataResponse

// todo - interface callback - SetBucketMetadataResponse

// todo - interface callback - BucketLockCallback

// todo - type - BucketLockResponse

abstract class Labels {
// todo - [key: string]: string;
}

abstract class SetLabelsOptions {
  String? userProject;
}

// todo - type - SetLabelsResponse

// todo - interface callback - SetLabelsCallback

abstract class SetBucketStorageClassOptions {
  String? userProject;
}

// todo - type - SetBucketStorageClassCallback

// todo - interface callback - UploadResponse

// todo - interface callback - UploadCallback

// todo - import class
// abstract class UploadOptions
// extends CreateResumableUploadOptions,
// CreateWriteStreamOptions {
// // todo - destination?: string | File;
// // todo - encryptionKey?: string | Buffer;
// String? kmsKeyName;
// String? resumable;
// int? timeout;
// // eslint-disable-next-line @typescript-eslint/no-explicit-any
// // todo - onUploadProgress?: (progressEvent: any) => void;
// }

abstract class MakeAllFilesPublicPrivateOptions {
  bool? force;
  bool? private;
  bool? public;
  String? userProject;
}

// todo - interface callback - MakeAllFilesPublicPrivateCallback

// todo - type - MakeAllFilesPublicPrivateResponse

const RESUMABLE_THRESHOLD = 5000000;

// todo - extends ServiceObject
// todo - finish class
class Bucket {
  // Metadata metadata;
  // String name;
  // Storage storae;
  String? userProject;

  // String getId() {
  //   return '';
  // }

  // Acl acl;
  // Iam iam;
}
