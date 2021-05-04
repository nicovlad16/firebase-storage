abstract class GetCredentialsResponse {
  String? client_email;
}

abstract class AuthClient {
  Future<String> sign(String blobToSign);
  Future<GetCredentialsResponse> getCredentials();
}

abstract class BucketI {
  late String name;
}

abstract class FileI {
  late String name;
}

abstract class Query {
// todo - map - [key: string]: string;
}

abstract class GetSignedUrlConfigInternal {
  late int expiration;
  DateTime? accessibleAt;
  late String method;
// todo - extensionHeaders?: http.OutgoingHttpHeaders;
  Query? queryParams;
  String? cname;
  String? contentMd5;
  String? contentType;
  late String bucket;
  String? file;
}

abstract class SignedUrlQuery {
  int? generation;
// todo - 'response-content-type'?: string;
// todo - 'response-content-disposition'?: string;
}

abstract class V2SignedUrlQuery extends SignedUrlQuery {
  late String GoogleAccessId;
  late int Expires;
  late String Signature;
}

abstract class V4SignedUrlQuery extends V4UrlQuery {
// todo 'X-Goog-Signature': string;
}

abstract class V4UrlQuery extends SignedUrlQuery {
  // todo
// 'X-Goog-Algorithm': string;
// 'X-Goog-Credential': string;
// 'X-Goog-Date': string;
// 'X-Goog-Expires': number;
// 'X-Goog-SignedHeaders': string;
}

abstract class SignerGetSignedUrlConfig {
// todo - method: 'GET' | 'PUT' | 'DELETE' | 'POST';
// todo - expires: string | number | Date;
// todo - accessibleAt?: string | number | Date;
  bool? virtualHostedStyle;
// todo - version?: 'v2' | 'v4';
  String? cname;
//todo - extensionHeaders?: http.OutgoingHttpHeaders;
  Query? queryParams;
  String? contentMd5;
  String? contentType;
}

typedef SignerGetSignedUrlResponse = String;

typedef GetSignedUrlResponse = List<SignerGetSignedUrlResponse>;

typedef GetSignedUrlCallback = void Function(Exception? err, String? url);

// todo - type - ValueOf

// todo - type - HeaderValue

/*
 * Default signing version for getSignedUrl is 'v2'.
 */
const String DEFAULT_SIGNING_VERSION = 'v2';

const int SEVEN_DAYS = 604800;

const String _PATH_STYLED_HOST = 'https://storage.googleapis.com';

// todo - finish class
class URLSigner {
  AuthClient _authClient;
  BucketI _bucket;
  FileI? _fileI;

  URLSigner(this._authClient, this._bucket, this._fileI);
}

class SigningError extends Error {
  String name = 'SigningError';
}
