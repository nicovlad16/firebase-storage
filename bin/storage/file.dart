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
  dynamic equals; // string[] | string[][];
  dynamic expires; // string | number | Date;
  dynamic startsWith; // string[] | string[][];
  String? acl;
  String? successRedirect;
  String? successStatus;
  Map<String, int>? contentLengthRange; // {min?: number; max?: number};
}

typedef GenerateSignedPostPolicyV2Options = GetSignedPolicyOptions;

typedef GenerateSignedPostPolicyV2Response = GetSignedPolicyResponse;

typedef GenerateSignedPostPolicyV2Callback = GetSignedPolicyCallback;

abstract class PolicyFields {
  // todo - map
}

abstract class GenerateSignedPostPolicyV4Options {
  dynamic expires; // string | number | Date;
  String? bucketBoundHostname;
  bool? virtualHostedStyle;
  List<Map<dynamic, dynamic>>? conditions; // object[]
  PolicyFields? fields;
}

typedef GenerateSignedPostPolicyV4Callback = void Function(Exception? err, SignedPostPolicyV4Output? output);

typedef GenerateSignedPostPolicyV4Response = List<SignedPostPolicyV4Output>;

abstract class SignedPostPolicyV4Output {
  late String url;
  late PolicyFields fields;
}

abstract class GetSignedUrlConfig {
  late String action; // 'read' | 'write' | 'delete' | 'resumable';
  String? version; // 'v2' | 'v4';
  bool? virtualHostedStyle;
  String? cname;
  String? contentMd5;
  String? contentType;
  dynamic expires; // string | number | Date;
  dynamic accessibleAt; // string | number | Date;
//todo - extensionHeaders?: http.OutgoingHttpHeaders;
  String? promptSaveAs;
  String? responseDisposition;
  String? responseType;
  Query? queryParams;
}

abstract class GetFileMetadataOptions {
  String? userProject;
}

typedef GetFileMetadataResponse = List<Metadata>;

typedef GetFileMetadataCallback = void Function(Exception? err, Metadata? metadata, Metadata? apiResponse);

abstract class GetFileOptions extends GetConfig {
  String? userProject;
}

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

typedef PredefinedAcl = String;
// | 'authenticatedRead' | 'bucketOwnerFullControl' | 'bucketOwnerRead' | 'private' | 'projectPrivate' | 'publicRead';

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
  dynamic gzip; // string | boolean;
  bool? resumable;
  int? timeout;
  dynamic validation; // string | boolean;
}

abstract class MakeFilePrivateOptions {
  Metadata? metadata;
  bool? strict;
  String? userProject;
}

typedef MakeFilePrivateResponse = List<Metadata>;

typedef MakeFilePrivateCallback = SetFileMetadataCallback;

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
  dynamic encryptionKey; // string | Buffer;
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
  dynamic encryptionKey; // string | Buffer;
  dynamic generation; // number | string;
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

abstract class DownloadOptions extends CreateReadStreamOptions {
  String? destination;
}

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
  dynamic validation; // 'md5' | 'crc32c' | false | true;
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
  List<Error>? errors;
}

const int SEVEN_DAYS = 7 * 24 * 60 * 60;

//todo - finish class
class File extends ServiceObject {
  File(this.bucket, this.name, FileOptions options) {
    // todo - finish constructor
    final Map<dynamic, dynamic> requestQueryObject = <dynamic, dynamic>{};
    int? generation;

    if (generation != null) {
      if (options.generation.runtimeType == String) {
        generation = int.tryParse(options.generation);
      } else {
        generation = options.generation;
      }
      if (!generation!.isNaN) {
        requestQueryObject['generation'] = generation;
      }
    }

    kmsKeyName = options.kmsKeyName;

    if (options.encryptionKey != null) {
      _encryptionKey = options.encryptionKey;
    }
  }

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

  dynamic _encryptionKey; // string | Buffer;
  String? _encryptionKeyBase64;
  String? _encryptionKeyHash;

// todo - Interceptor? _encryptionKeyInterceptor;
}
