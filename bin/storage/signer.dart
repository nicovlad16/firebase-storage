import '../common/index.dart';

class GetCredentialsResponse {
  GetCredentialsResponse(this.client_email);

  // ignore: non_constant_identifier_names
  final String? client_email;
}

typedef SignCallback = Future<String> Function(String blobToSign);

typedef GetCredentialsCallback = Future<GetCredentialsResponse> Function();

class AuthClient {
  AuthClient(this.sign, this.getCredentials);

  SignCallback sign;
  GetCredentialsCallback getCredentials;
}

class BucketI {
  BucketI(this.name);

  String name;
}

class FileI {
  FileI(this.name);

  String name;
}

class Query {
  Query() : values = <String, dynamic>{};
  Map<dynamic, dynamic> values;
}

class GetSignedUrlConfigInternal {
  GetSignedUrlConfigInternal(
      {required this.expiration,
      this.accessibleAt,
      required this.method,
      this.queryParams,
      this.cname,
      this.contentMd5,
      this.contentType,
      required this.bucket,
      this.file});

  int expiration;
  DateTime? accessibleAt;
  String method;

// todo - extensionHeaders?: http.OutgoingHttpHeaders;
  Query? queryParams;
  String? cname;
  String? contentMd5;
  String? contentType;
  String bucket;
  String? file;
}

class SignedUrlQuery {
  int? generation;
// todo - 'response-content-type'?: string;
// todo - 'response-content-disposition'?: string;
}

class V2SignedUrlQuery extends SignedUrlQuery {
  late String GoogleAccessId;
  late int Expires;
  late String Signature;
}

class V4SignedUrlQuery extends V4UrlQuery {
// todo 'X-Goog-Signature': string;
}

class V4UrlQuery extends SignedUrlQuery {
  // todo
// 'X-Goog-Algorithm': string;
// 'X-Goog-Credential': string;
// 'X-Goog-Date': string;
// 'X-Goog-Expires': number;
// 'X-Goog-SignedHeaders': string;
}

class SignerGetSignedUrlConfig {
  SignerGetSignedUrlConfig({
    required this.method,
    required this.expires,
    required this.accessibleAt,
    this.virtualHostedStyle,
    this.version,
    this.cname,
    this.queryParams,
    this.contentMd5,
    this.contentType,
  });

  String method; // 'GET' | 'PUT' | 'DELETE' | 'POST';
  dynamic expires; // string | number | Date;
  dynamic accessibleAt; // string | number | Date;
  bool? virtualHostedStyle;
  String? version; // 'v2' | 'v4';
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
  URLSigner(this._authClient, this._bucket, this._file);

  AuthClient _authClient;
  BucketI _bucket;
  FileI? _file;

  Future<SignerGetSignedUrlResponse> getSignedUrl(SignerGetSignedUrlConfig cfg) async {
    final int expiresInSeconds = parseExpires(cfg.expires);
    final String method = cfg.method;
    final int accessibleAtInSeconds = parseAccessibleAt(cfg.accessibleAt);

    if (expiresInSeconds < accessibleAtInSeconds) {
      throw Exception('An expiration date cannot be before accessible date.');
    }

    String? customHost;
    // Default style is `path`.
    final bool isVirtualHostedStyle = cfg.virtualHostedStyle ?? false;

    if (cfg.cname != null) {
      customHost = cfg.cname;
    } else if (isVirtualHostedStyle) {
      customHost = 'https://${_bucket.name}.storage.googleapis.com';
    }

    const int secondsToMilliseconds = 1000;

    final GetSignedUrlConfigInternal config = GetSignedUrlConfigInternal(
      expiration: expiresInSeconds,
      method: method,
      bucket: _bucket.name,
      accessibleAt: null,
      // todo - add value
      file: _file != null ? encodeURI(_file!.name, false) : null,
    );

    if (customHost != null) {
      config.cname = customHost;
    }

    final String version = cfg.version ?? DEFAULT_SIGNING_VERSION;

    SignedUrlQuery signedUrlQuery;

    if (version == 'v2') {
      signedUrlQuery = await getSignedUrlV2(config);
    } else if (version == 'v4') {
      signedUrlQuery = await getSignedUrlV4(config);
    } else {
      throw Exception('Invalid signed URL version: $version. Supported versions are \'v2\' and \'v4\'.');
    }

    final Query query = Query();
    if (cfg.queryParams != null) {
      query.values = cfg.queryParams!.values;
    }
    // todo - url in dart

    // todo - finish method

    const SignerGetSignedUrlResponse signedUrlResponse = '';
    return signedUrlResponse;
  }

  Future<SignedUrlQuery> getSignedUrlV2(GetSignedUrlConfigInternal config) async {
    // todo - method
    return SignedUrlQuery();
  }

  Future<SignedUrlQuery> getSignedUrlV4(GetSignedUrlConfigInternal config) async {
    // todo - method
    return SignedUrlQuery();
  }

  String getCanonicalRequest(
      String method, String path, String query, String headers, String signedHeaders, String? contentSha256) {
    return <dynamic>[method, path, query, headers, signedHeaders, contentSha256 ?? 'UNSIGNED-PAYLOAD'].join('\n');
  }

  dynamic getCanonicalQueryParams(Query query) {
    // todo - method
  }

  String getResourcePath(bool cname, String bucket, String? file) {
    if (cname) {
      return '/' + (file ?? '');
    } else if (file != null) {
      return '/$bucket/$file';
    } else {
      return '/$bucket';
    }
  }

  int parseExpires(dynamic expires /* string | number | Date */, {DateTime? current}) {
    current ??= DateTime.now();
    final int expiresInMSeconds = expires.microsecondsSinceEpoch;
    if (expiresInMSeconds.isNaN) {
      throw Exception('The expiration date provided was invalid.');
    }
    if (expiresInMSeconds < current.microsecondsSinceEpoch) {
      throw Exception('An expiration date cannot be in the past.');
    }
    return (expiresInMSeconds / 1000).floor(); // The API expects seconds.
  }

  int parseAccessibleAt(dynamic accessibleAt /* string | number | Date */) {
    final DateTime currentDateTime = DateTime.now();
    final int accessibleAtInMSeconds =
        accessibleAt == null ? accessibleAt.microsecondsSinceEpoch : currentDateTime.microsecondsSinceEpoch;
    if (accessibleAtInMSeconds.isNaN) {
      throw Exception('The accessible at date provided was invalid.');
    }
    return (accessibleAtInMSeconds / 1000).floor(); // The API expects seconds.
  }
}

class SigningError extends Error {
  String name = 'SigningError';
}
