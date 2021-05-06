import 'package:firebase_storage/storage/util.dart';

class GetCredentialsResponse {
  GetCredentialsResponse({this.client_email});

  // ignore: non_constant_identifier_names
  final String? client_email;
}

typedef SignCallback = Future<String> Function(String blobToSign);

typedef GetCredentialsCallback = Future<GetCredentialsResponse> Function();

class AuthClient {
  AuthClient({required this.sign, required this.getCredentials});

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
  Map<String, dynamic> values;
}

class GetSignedUrlConfigInternal {
  GetSignedUrlConfigInternal(
      {required this.expiration,
      this.accessibleAt,
      required this.method,
      this.extensionHeaders,
      this.queryParams,
      this.cname,
      this.contentMd5,
      this.contentType,
      required this.bucket,
      this.file});

  int expiration;
  DateTime? accessibleAt;
  String method;
  Map<String, dynamic>? extensionHeaders;
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
  V2SignedUrlQuery({required this.GoogleAccessId, required this.Expires, required this.Signature});

  String GoogleAccessId;
  int Expires;
  String Signature;
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
    this.accessibleAt,
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

const String PATH_STYLED_HOST = 'https://storage.googleapis.com';

// todo - finish class
class URLSigner {
  URLSigner(this._authClient, this._bucket, this._file);

  AuthClient _authClient;
  BucketI _bucket;
  FileI? _file;

  AuthClient get authClient => _authClient;

  BucketI get bucket => _bucket;

  FileI? get file => _file;

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
      signedUrlQuery = await _getSignedUrlV2(config);
    } else if (version == 'v4') {
      signedUrlQuery = await _getSignedUrlV4(config);
    } else {
      throw Exception('Invalid signed URL version: $version. Supported versions are \'v2\' and \'v4\'.');
    }

    final Query query = Query();
    if (cfg.queryParams != null) {
      query.values = cfg.queryParams!.values;
    }
    final Uri signedUrl = Uri.parse(config.cname ?? PATH_STYLED_HOST).replace(
      path: getResourcePath(config.cname != null, _bucket.name, config.file),
      queryParameters: query.values,
    );

    // todo - finish method

    return signedUrl.toString();
  }

  Future<SignedUrlQuery> _getSignedUrlV2(GetSignedUrlConfigInternal config) async {
    final dynamic canonicalHeadersString = getCanonicalHeaders(config.extensionHeaders ?? <String, dynamic>{});

    final String resourcePath = getResourcePath(false, config.bucket, config.file);

    final String blobToSign = <String>[
      config.method,
      config.contentMd5 ?? '',
      config.contentType ?? '',
      config.expiration.toString(),
      canonicalHeadersString + resourcePath,
    ].join('\n');

    final Future<V2SignedUrlQuery> Function() sign = () async {
      final AuthClient authClient = _authClient;
      try {
        final String signature = await authClient.sign(blobToSign);
        final GetCredentialsResponse credentials = await authClient.getCredentials();

        return V2SignedUrlQuery(
          GoogleAccessId: credentials.client_email!,
          Expires: config.expiration,
          Signature: signature,
        );
      } catch (err, stackTrace) {
        final SigningError signingErr = SigningError(err.toString(), stackTrace);
        throw signingErr;
      }
    };

    // todo - finish method
    return sign();
  }

  Future<SignedUrlQuery> _getSignedUrlV4(GetSignedUrlConfigInternal config) async {
    config.accessibleAt = config.accessibleAt ?? DateTime.now();

    const double millisecondsToSeconds = 1.0 / 1000.0;
    final num expiresPeriodInSeconds =
        config.expiration - config.accessibleAt!.millisecondsSinceEpoch * millisecondsToSeconds;

    // v4 limit expiration to be 7 days maximum
    if (expiresPeriodInSeconds > SEVEN_DAYS) {
      throw Exception('Max allowed expiration is seven days ($SEVEN_DAYS seconds).');
    }

    // todo - extensionHeaders
    final Uri fqdn = Uri.parse(config.cname ?? PATH_STYLED_HOST);

    // todo - method
    return SignedUrlQuery();
  }

  /// Create canonical headers for signing v4 url.
  ///
  /// The canonical headers for v4-signing a request demands header names are
  /// first lowercased, followed by sorting the header names.
  /// Then, construct the canonical headers part of the request:
  ///  <lowercasedHeaderName> + ":" + Trim(<value>) + "\n"
  ///  ..
  ///  <lowercasedHeaderName> + ":" + Trim(<value>) + "\n"
  ///
  /// @param headers
  /// @private
  String getCanonicalHeaders(Map<String, dynamic /* number | string | string[] | undefined */ > headers) {
    // Sort headers by their lowercased names
    final List<List<dynamic>> sortedHeaders = headers.entries
        .map((MapEntry<String, dynamic> entry) => <dynamic>[
              entry.key.toLowerCase(), // Convert header names to lowercase
              entry.value
            ])
        .toList();
    sortedHeaders.sort((List<dynamic> a, List<dynamic> b) => a[0].compareTo(b[0]));

    return sortedHeaders.where((List<dynamic> element) {
      final dynamic value = element[1];
      return value != null;
    }).map((List<dynamic> element) {
      final dynamic headerName = element[0];
      final dynamic value = element[1];
      final String canonicalValue =
          '$value'.trim().replaceAll('[', '').replaceAll(']', '').replaceAll('/\s{1,}/g', ' ');
      return '$headerName:$canonicalValue\n';
    }).join('');
  }

  String getCanonicalRequest(
      {required String method,
      required String path,
      required String query,
      required String headers,
      required String signedHeaders,
      String? contentSha256}) {
    return <dynamic>[method, path, query, headers, signedHeaders, contentSha256 ?? 'UNSIGNED-PAYLOAD'].join('\n');
  }

  String getCanonicalQueryParams(Query query) {
    // todo - finish method
    final List<List<String>> list = query.values.entries
        .map((MapEntry<String, dynamic> entry) => <String>[encodeURI(entry.key, true), encodeURI(entry.value, true)])
        .toList();
    list.sort((List<String> a, List<String> b) => a[0].compareTo(b[0]));
    return list.map((List<String> entry) => '${entry[0]}=${entry[1]}').join('&');
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
    current = current ?? DateTime.now();

    if (expires.runtimeType == String) {
      try {
        expires = DateTime.parse(expires);
      } catch (e) {
        throw 'The expiration date provided was invalid.';
      }
    } else if (expires.runtimeType == int) {
      expires = DateTime(0).add(Duration(seconds: expires));
    } else if (expires.runtimeType != DateTime) {
      throw 'The expiration date provided was invalid.';
    }

    if (expires.isBefore(current)) {
      throw 'An expiration date cannot be in the past.';
    }

    return (expires.millisecondsSinceEpoch / 1000).floor(); // The API expects seconds.
  }

  int parseAccessibleAt(dynamic accessibleAt /* string | number | Date */) {
    accessibleAt = accessibleAt == null ? accessibleAt : DateTime(0);

    if (accessibleAt.runtimeType == String) {
      try {
        accessibleAt = DateTime.parse(accessibleAt);
      } catch (e) {
        throw 'The accessible at date provided was invalid.';
      }
    } else if (accessibleAt.runtimeType == int) {
      accessibleAt = DateTime(0).add(Duration(seconds: accessibleAt));
    } else if (accessibleAt.runtimeType != DateTime) {
      throw 'The accessible at date provided was invalid.';
    }

    return (accessibleAt.millisecondsSinceEpoch / 1000).floor(); // The API expects seconds.
  }
}

class SigningError implements Exception {
  SigningError(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;
  String name = 'SigningError';
}
