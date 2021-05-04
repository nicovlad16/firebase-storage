// todo - type - GetExpirationDateResponse

// todo - interface callback - GetExpirationDateCallback

import 'bucket.dart';

abstract class PolicyDocument {
  late String string;
  late String base64;
  late String signature;
}

// todo - type - GetSignedPolicyResponse

// todo - interface callback - GetSignedPolicyCallback

abstract class GetSignedPolicyOptions {
// todo - equals?: string[] | string[][];
// todo - expires: string | number | Date;
// todo - startsWith?: string[] | string[][];
  String? acl;
  String? successRedirect;
  String? successStatus;
// todo - contentLengthRange?: {min?: number; max?: number};
}

// todo - type - GenerateSignedPostPolicyV2Options

// todo - type - GenerateSignedPostPolicyV2Response

// todo - type - GenerateSignedPostPolicyV2Callback

abstract class PolicyFields {
  // todo - map
}

abstract class GenerateSignedPostPolicyV4Options {
// todo - expires: string | number | Date;
  String? bucketBoundHostname;
  bool? virtualHostedStyle;

//todo - conditions?: object[];
  PolicyFields? fields;
}

// todo - interface callback - GenerateSignedPostPolicyV4Callback

// todo - type - GenerateSignedPostPolicyV4Response

abstract class SignedPostPolicyV4Output {
  late String url;
  late PolicyFields fields;
}

abstract class GetSignedUrlConfig {
// todo - late String action: 'read' | 'write' | 'delete' | 'resumable';
//todo - version?: 'v2' | 'v4';
  bool? virtualHostedStyle;
  String? cname;
  String? contentMd5;
  String? contentType;

//todo - expires: string | number | Date;
//todo - accessibleAt?: string | number | Date;
//todo - extensionHeaders?: http.OutgoingHttpHeaders;
  String? promptSaveAs;
  String? responseDisposition;
  String? responseType;
//todo - queryParams?: Query;
}

abstract class GetFileMetadataOptions {
  String? userProject;
}

// todo - type - GetFileMetadataResponse

// todo - interface callback - GetFileMetadataCallback

//todo - import class
// abstract class GetFileOptions extends GetConfig {
// String? userProject;
// }

// todo - type - GetFileResponse

// todo - interface callback - GetFileCallback

abstract class FileExistsOptions {
  String? userProject;
}

// todo - type - FileExistsResponse

// todo - interface callback - FileExistsCallback

abstract class DeleteFileOptions {
  bool? ignoreNotFound;
  String? userProject;
}

// todo - type - DeleteFileResponse

// todo - interface callback - DeleteFileCallback

// todo - type - PredefinedAcl

abstract class CreateResumableUploadOptions {
  String? configPath;

// todo - Metadata? metadata;
  String? origin;
  int? offset;

//todo predefinedAcl?: PredefinedAcl;
  bool? private;
  bool? public;
  String? uri;
  String? userProject;
}

// todo - type - CreateResumableUploadResponse

// todo - interface callback - CreateResumableUploadResponse

abstract class CreateWriteStreamOptions extends CreateResumableUploadOptions {
  String? contentType;

// todo - gzip?: string | boolean;
  bool? resumable;
  int? timeout;
//todo - validation?: string | boolean;
}

abstract class MakeFilePrivateOptions {
//todo - Metadata?: metadata;
  bool? strict;
  String? userProject;
}

// todo - type - MakeFilePrivateResponse
// todo - type - MakeFilePrivateCallback

// todo - interface callback - IsPublicCallback

// todo - type - IsPublicResponse
// todo - type - MakeFilePublicResponse

// todo - interface callback - MakeFilePublicCallback

// todo - type - MoveResponse

// todo - interface callback - MoveCallback

abstract class MoveOptions {
  String? userProject;
}

// todo - type - RenameOptions
// todo - type - RenameResponse
// todo - type - RenameCallback
// todo - type - RotateEncryptionKeyOptions

abstract class EncryptionKeyOptions {
//todo - encryptionKey?: string | Buffer;
  String? kmsKeyName;
}

// todo - type - RotateEncryptionKeyCallback
// todo - type - RotateEncryptionKeyResponse

enum ActionToHTTPMethod {
  // todo - add default values
  read,
  write,
  delete,
  resumable,
}

class ResumableUploadError extends Error {
  String name = 'ResumableUploadError';
}

const String STORAGE_POST_POLICY_BASE_URL = 'https://storage.googleapis.com';

const String GS_URL_REGEXP = '/^gs:\/\/([a-z0-9_.-]+)\/(.+)\$/';

abstract class FileOptions {
//todo - encryptionKey?: string | Buffer;
// todo - generation?: number | string;
  String? kmsKeyName;
  String? userProject;
}

abstract class CopyOptions {
  String? cacheControl;
  String? contentEncoding;
  String? contentType;
  String? contentDisposition;
  String? destinationKmsKeyName;

// Metadata? metadata;
  String? predefinedAcl;
  String? token;
  String? userProject;
}

// todo - type - CopyResponse

// todo - interface callback - CopyCallback

// todo - type - DownloadResponse

// todo - interface callback - DownloadCallback

//todo - import class
// abstract class DownloadOptions extends CreateReadStreamOptions {
// String? destination;
// }

abstract class CopyQuery {
  String? sourceGeneration;
  String? rewriteToken;
  String? userProject;
  String? destinationKmsKeyName;
  String? destinationPredefinedAcl;
}

abstract class FileQuery {
  late String alt;
  int? generation;
  String? userProject;
}

abstract class CreateReadStreamOptions {
  String? userProject;

// todo - validation?: 'md5' | 'crc32c' | false | true;
  int? start;
  int? end;
  bool? decompress;
}

abstract class SaveOptions extends CreateWriteStreamOptions {
// eslint-disable-next-line @typescript-eslint/no-explicit-any
  void onUploadProgress(dynamic progressEvent);
}

// todo - interface callback - SaveCallback

abstract class SetFileMetadataOptions {
  String? userProject;
}

// todo - interface callback - SetFileMetadataCallback

// todo - type - SetFileMetadataResponse

// todo - type - SetStorageClassResponse

abstract class SetStorageClassOptions {
  String? userProject;
}

abstract class SetStorageClassRequest extends SetStorageClassOptions {
  String? storageClass;
}

// todo - interface callback - SetStorageClassCallback

class RequestError extends Error {
  String? code;
  List<Error>? errors;
}

const SEVEN_DAYS = 7 * 24 * 60 * 60;

// todo - extends ServiceObject
//todo - finish class
class File {
  // Acl acl;

  Bucket bucket;

  // Storage storage;
  String? kmsKeyName;
  String? userProject;

  //todo - URLSigner? signer;
  //todo - Metadata metadata;
  String name;

  int? generation;

  //todo - parent!: Bucket;

  // todo - _encryptionKey?: string | Buffer;
  String? encryptionKeyBase64;
  String? encryptionKeyHash;

  // todo - Interceptor? _encryptionKeyInterceptor;

  File(this.bucket, this.name, FileOptions options);
}
