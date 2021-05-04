import 'dart:typed_data';

import '../common/index.dart';
import 'acl.dart';
import 'bucket.dart';
import 'signer.dart';

typedef GetExpirationDateResponse = List<DateTime>;

typedef GetExpirationDateCallback = void Function(Exception? err, DateTime? expirationDate, Metadata? apiResponse);

abstract class PolicyDocument {
  late String string;
  late String base64;
  late String signature;
}

typedef GetSignedPolicyResponse = List<PolicyDocument>;

typedef GetSignedPolicyCallback = void Function(Exception? err, PolicyDocument? policy);

abstract class GetSignedPolicyOptions {
// todo - equals?: string[] | string[][];
// todo - expires: string | number | Date;
// todo - startsWith?: string[] | string[][];
  String? acl;
  String? successRedirect;
  String? successStatus;
// todo - contentLengthRange?: {min?: number; max?: number};
}

typedef GenerateSignedPostPolicyV2Options = GetSignedPolicyOptions;

typedef GenerateSignedPostPolicyV2Response = GetSignedPolicyResponse;

typedef GenerateSignedPostPolicyV2Callback = GetSignedPolicyCallback;

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

typedef GenerateSignedPostPolicyV4Callback = void Function(Exception? err, SignedPostPolicyV4Output? output);

typedef GenerateSignedPostPolicyV4Response = List<SignedPostPolicyV4Output>;

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

typedef GetFileMetadataResponse = List<Metadata>;

typedef GetFileMetadataCallback = void Function(Exception? err, Metadata? metadata, Metadata? apiResponse);

//todo - import class
// abstract class GetFileOptions extends GetConfig {
// String? userProject;
// }

typedef GetFileResponse = List<dynamic>; // [File, Metadata];

typedef GetFileCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

abstract class FileExistsOptions {
  String? userProject;
}

typedef FileExistsResponse = List<bool>;

typedef FileExistsCallback = void Function(Exception? err, bool? exists);

abstract class DeleteFileOptions {
  bool? ignoreNotFound;
  String? userProject;
}

typedef DeleteFileResponse = List<Metadata>;

typedef DeleteFileCallback = void Function(Exception? err, Metadata? apiResponse);

typedef PredefinedAcl = String; // | 'authenticatedRead' | 'bucketOwnerFullControl' | 'bucketOwnerRead'
// | 'private' | 'projectPrivate' | 'publicRead';

abstract class CreateResumableUploadOptions {
  String? configPath;
  Metadata? metadata;
  String? origin;
  int? offset;
  PredefinedAcl? predefinedAcl;
  bool? private;
  bool? public;
  String? uri;
  String? userProject;
}

typedef CreateResumableUploadResponse = List<String>;

typedef CreateResumableUploadCallback = void Function(Exception? err, String? uri);

abstract class CreateWriteStreamOptions extends CreateResumableUploadOptions {
  String? contentType;

// todo - gzip?: string | boolean;
  bool? resumable;
  int? timeout;
//todo - validation?: string | boolean;
}

abstract class MakeFilePrivateOptions {
  Metadata? metadata;
  bool? strict;
  String? userProject;
}

typedef MakeFilePrivateResponse = List<Metadata>;

// todo - type - MakeFilePrivateCallback
// typedef MakeFilePrivateCallback = MakeFilePrivateCallback;

typedef IsPublicCallback = void Function(Exception? err, bool? resp);

typedef IsPublicResponse = List<bool>;

typedef MakeFilePublicResponse = List<Metadata>;

typedef MakeFilePublicCallback = void Function(Exception? err, Metadata? apiResponse);

typedef MoveResponse = List<Metadata>;

typedef MoveCallback = void Function(Exception? err, File? destinationFile, Metadata? apiResponse);

abstract class MoveOptions {
  String? userProject;
}

typedef RenameOptions = MoveOptions;

typedef RenameResponse = MoveResponse;

typedef RenameCallback = MoveCallback;

typedef RotateEncryptionKeyOptions = dynamic; // string | Buffer | EncryptionKeyOptions;

abstract class EncryptionKeyOptions {
//todo - encryptionKey?: string | Buffer;
  String? kmsKeyName;
}

typedef RotateEncryptionKeyCallback = CopyCallback;

typedef RotateEncryptionKeyResponse = CopyResponse;

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

const String _GS_URL_REGEXP = '/^gs:\/\/([a-z0-9_.-]+)\/(.+)\$/';

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
  Metadata? metadata;
  String? predefinedAcl;
  String? token;
  String? userProject;
}

typedef CopyResponse = List<dynamic>; // [File, Metadata];

typedef CopyCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

typedef DownloadResponse = List<ByteBuffer>;

typedef DownloadCallback = void Function(RequestError? err, ByteBuffer contents);

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
  void onUploadProgress(dynamic progressEvent);
}

typedef SaveCallback = void Function(Exception? err);

abstract class SetFileMetadataOptions {
  String? userProject;
}

typedef SetFileMetadataCallback = void Function(Exception? err, Metadata? apiResponse);

typedef SetFileMetadataResponse = List<Metadata>;

typedef SetStorageClassResponse = List<Metadata>;

abstract class SetStorageClassOptions {
  String? userProject;
}

abstract class SetStorageClassRequest extends SetStorageClassOptions {
  String? storageClass;
}

typedef SetStorageClassCallback = void Function(Exception? err, Metadata? apiResponse);

// todo - check if it should be Error or Exception
class RequestError extends Error {
  String? code;
  List<Exception>? errors;
}

const int SEVEN_DAYS = 7 * 24 * 60 * 60;

//todo - finish class
class File extends ServiceObject {
  File(this.bucket, this.name, FileOptions options);

  late Acl acl;

  Bucket bucket;

  // Storage storage;
  String? kmsKeyName;
  String? userProject;

  URLSigner? signer;
  Metadata metadata;
  String name;
  int? generation;

  //todo - parent!: Bucket;

  // todo - _encryptionKey?: string | Buffer;
  String? encryptionKeyBase64;
  String? encryptionKeyHash;

  // todo - Interceptor? _encryptionKeyInterceptor;
}
