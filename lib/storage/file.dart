import 'dart:typed_data';

import '../common/index.dart';
import '../util/util.dart' as util;
import 'acl.dart';
import 'bucket.dart';
import 'signer.dart';

typedef GetExpirationDateResponse = List<DateTime>;

typedef GetExpirationDateCallback = void Function(Exception? err, DateTime? expirationDate, Metadata? apiResponse);

class PolicyDocument {
  PolicyDocument({required this.string, required this.base64, required this.signature});

  String string;
  String base64;
  String signature;
}

typedef GetSignedPolicyResponse = List<PolicyDocument>;

typedef GetSignedPolicyCallback = void Function(Exception? err, PolicyDocument? policy);

class GetSignedPolicyOptions {
  GetSignedPolicyOptions({
    required this.equals,
    required this.expires,
    required this.startsWith,
    this.acl,
    this.successRedirect,
    this.successStatus,
    this.contentLengthRange,
  });

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

class PolicyFields {
  PolicyFields() : values = <String, String>{};
  Map<String, String> values;
}

class GenerateSignedPostPolicyV4Options {
  GenerateSignedPostPolicyV4Options({
    required this.expires,
    this.bucketBoundHostname,
    this.virtualHostedStyle,
    this.conditions,
    this.fields,
  });

  dynamic expires; // string | number | Date;
  String? bucketBoundHostname;
  bool? virtualHostedStyle;
  List<Map<String, dynamic>>? conditions; // object[]
  PolicyFields? fields;
}

typedef GenerateSignedPostPolicyV4Callback = void Function(Exception? err, SignedPostPolicyV4Output? output);

typedef GenerateSignedPostPolicyV4Response = List<SignedPostPolicyV4Output>;

class SignedPostPolicyV4Output {
  SignedPostPolicyV4Output(this.url, this.fields);

  String url;
  PolicyFields fields;
}

class GetSignedUrlConfig {
  GetSignedUrlConfig({
    required this.action,
    this.version,
    this.virtualHostedStyle,
    this.cname,
    this.contentMd5,
    this.contentType,
    required this.expires,
    this.accessibleAt,
    this.promptSaveAs,
    this.responseDisposition,
    this.responseType,
    this.queryParams,
  });

  String action; // 'read' | 'write' | 'delete' | 'resumable';
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

class GetFileMetadataOptions {
  GetFileMetadataOptions([this.userProject]);

  String? userProject;
}

typedef GetFileMetadataResponse = List<Metadata>;

typedef GetFileMetadataCallback = void Function(Exception? err, Metadata? metadata, Metadata? apiResponse);

class GetFileOptions extends GetConfig {
  GetFileOptions([this.userProject]);

  String? userProject;
}

typedef GetFileResponse = List<dynamic>; // [File, Metadata];

typedef GetFileCallback = void Function(Exception? err, File? file, Metadata? apiResponse);

class FileExistsOptions {
  FileExistsOptions([this.userProject]);

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

class CreateResumableUploadOptions {
  CreateResumableUploadOptions({
    this.configPath,
    this.metadata,
    this.origin,
    this.offset,
    this.predefinedAcl,
    this.private,
    this.public,
    this.uri,
    this.userProject,
  });

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

class CreateWriteStreamOptions extends CreateResumableUploadOptions {
  CreateWriteStreamOptions({
    this.contentType,
    this.gzip,
    this.resumable,
    this.timeout,
    this.validation,
  });

  String? contentType;
  dynamic gzip; // string | boolean;
  bool? resumable;
  int? timeout;
  dynamic validation; // string | boolean;

}

class MakeFilePrivateOptions {
  MakeFilePrivateOptions([this.metadata, this.strict, this.userProject]);

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

class MoveOptions {
  MoveOptions([this.userProject]);

  String? userProject;
}

typedef RenameOptions = MoveOptions;

typedef RenameResponse = MoveResponse;

typedef RenameCallback = MoveCallback;

typedef RotateEncryptionKeyOptions = dynamic; // string | Buffer | EncryptionKeyOptions;

class EncryptionKeyOptions {
  EncryptionKeyOptions(this.encryptionKey, this.kmsKeyName);

  dynamic encryptionKey; // string | Buffer;
  String? kmsKeyName;
}

typedef RotateEncryptionKeyCallback = CopyCallback;

typedef RotateEncryptionKeyResponse = CopyResponse;

class ActionToHTTPMethod {
  const ActionToHTTPMethod._(this._method);

  final String _method;

  static const ActionToHTTPMethod read = ActionToHTTPMethod._('GET');
  static const ActionToHTTPMethod write = ActionToHTTPMethod._('PUT');
  static const ActionToHTTPMethod delete = ActionToHTTPMethod._('DELETE');
  static const ActionToHTTPMethod resumable = ActionToHTTPMethod._('POST');
}

class _ResumableUploadError extends Error {
  String name = 'ResumableUploadError';
}

const String STORAGE_POST_POLICY_BASE_URL = 'https://storage.googleapis.com';

const String _GS_URL_REGEXP = '/^gs:\/\/([a-z0-9_.-]+)\/(.+)\$/';

class FileOptions {
  FileOptions({this.encryptionKey, this.generation, this.kmsKeyName, this.userProject});

  dynamic encryptionKey; // string | Buffer;
  dynamic generation; // number | string;
  String? kmsKeyName;
  String? userProject;
}

class CopyOptions {
  CopyOptions({
    this.cacheControl,
    this.contentEncoding,
    this.contentType,
    this.contentDisposition,
    this.destinationKmsKeyName,
    this.metadata,
    this.predefinedAcl,
    this.token,
    this.userProject,
  });

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

class DownloadOptions extends CreateReadStreamOptions {
  DownloadOptions([this.destination]);

  String? destination;
}

class CopyQuery {
  CopyQuery({
    this.sourceGeneration,
    this.rewriteToken,
    this.userProject,
    this.destinationKmsKeyName,
    this.destinationPredefinedAcl,
  });

  String? sourceGeneration;
  String? rewriteToken;
  String? userProject;
  String? destinationKmsKeyName;
  String? destinationPredefinedAcl;
}

class FileQuery {
  FileQuery({required this.alt, this.generation, this.userProject});

  String alt;
  int? generation;
  String? userProject;
}

class CreateReadStreamOptions {
  CreateReadStreamOptions({this.userProject, this.validation, this.start, this.end, this.decompress});

  String? userProject;
  dynamic validation; // 'md5' | 'crc32c' | false | true;
  int? start;
  int? end;
  bool? decompress;
}

class SaveOptions extends CreateWriteStreamOptions {
  util.OnUploadProgressCallback? onUploadProgress;
}

typedef SaveCallback = void Function(Exception? err);

class SetFileMetadataOptions {
  SetFileMetadataOptions([this.userProject]);

  String? userProject;
}

typedef SetFileMetadataCallback = void Function(Exception? err, Metadata? apiResponse);

typedef SetFileMetadataResponse = List<Metadata>;

typedef SetStorageClassResponse = List<Metadata>;

class SetStorageClassOptions {
  SetStorageClassOptions([this.userProject]);

  String? userProject;
}

class SetStorageClassRequest extends SetStorageClassOptions {
  SetStorageClassRequest([this.storageClass]);

  String? storageClass;
}

typedef SetStorageClassCallback = void Function(Exception? err, Metadata? apiResponse);

// todo - check if it should be Error or Exception
class RequestError extends Error {
  String? code;
  List<Error>? errors;
}

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

    /*
    final client = HttpClient();
    final HttpClientRequest item = await client.open('GET', 'google.com', 80, '/');
    item.headers['sas'] = 'sasa';
    item.headers['content-type'] = 'text/plain;utf-8';
    item.add(utf8.encode('sasa'));
    final HttpClientResponse response = await item.close();
    response.listen((List<int> event) {});
    */

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
