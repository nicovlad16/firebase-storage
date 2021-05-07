import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:firebase_storage/util/util.dart';
import 'package:meta/meta.dart';

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

class GetSignedUrlConfigInternal extends SignerGetSignedUrlConfig {
  GetSignedUrlConfigInternal({
    required int expiration,
    dynamic accessibleAt,
    required String method,
    Map<String, dynamic>? extensionHeaders,
    Query? queryParams,
    String? cname,
    String? contentMd5,
    String? contentType,
    required this.bucket,
    String? file,
    SignerGetSignedUrlConfig? config,
  })  : method = method,
        expiration = expiration,
        super(method: method, expires: expiration) {
    if (config != null) {
      this
        ..expires = config.expires
        ..accessibleAt = config.accessibleAt
        ..virtualHostedStyle = config.virtualHostedStyle
        ..version = config.version
        ..cname = config.cname
        ..extensionHeaders = config.extensionHeaders
        ..queryParams = config.queryParams
        ..contentMd5 = config.contentMd5
        ..contentType = config.contentType;
    }

    this
      ..method = method
      ..accessibleAt = accessibleAt ?? DateTime.now()
      ..extensionHeaders = extensionHeaders
      ..queryParams = queryParams
      ..cname = cname
      ..contentMd5 = contentMd5
      ..contentType = contentType
      ..file = file;
  }

  String method;
  int expiration;
  String bucket;
  String? file;
}

class SignedUrlQuery {
  SignedUrlQuery({this.generation}) : values = <String, dynamic>{};

  int? generation;
  Map<String, dynamic> values;

// todo - 'response-content-type'?: string;
// todo - 'response-content-disposition'?: string;
}

class V2SignedUrlQuery extends SignedUrlQuery {}

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
    this.version = DEFAULT_SIGNING_VERSION,
    this.cname,
    this.extensionHeaders,
    this.queryParams,
    this.contentMd5,
    this.contentType,
  })  : assert(version == 'v2' || version == 'v4'),
        assert(<String>['GET', 'PUT', 'DELETE', 'POST'].contains(method)),
        assert(expires is String || expires is int || expires is DateTime) {
    accessibleAt ??= DateTime.now();
    assert(accessibleAt is String || accessibleAt is int || accessibleAt is DateTime);
  }

  String method; // 'GET' | 'PUT' | 'DELETE' | 'POST';
  dynamic expires; // string | number | Date;
  dynamic accessibleAt; // string | number | Date;
  bool? virtualHostedStyle;
  String? version; // 'v2' | 'v4';
  String? cname;
  Map<String, dynamic>? extensionHeaders;
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

  final AuthClient _authClient;
  final BucketI _bucket;
  final FileI? _file;

  AuthClient get authClient => _authClient;

  BucketI get bucket => _bucket;

  FileI? get file => _file;

  Future<String> getSignedUrl(SignerGetSignedUrlConfig cfg) async {
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

    final GetSignedUrlConfigInternal config = GetSignedUrlConfigInternal(
      expiration: expiresInSeconds,
      method: method,
      bucket: _bucket.name,
      file: _file != null ? encodeURI(_file!.name, false) : null,
      config: cfg,
    );

    if (customHost != null) {
      config.cname = customHost;
    }

    V2SignedUrlQuery? v2signedUrlQuery;
    V4SignedUrlQuery? v4signedUrlQuery;

    if (cfg.version == DEFAULT_SIGNING_VERSION) {
      v2signedUrlQuery = await getSignedUrlV2(config);
    } else {
      v4signedUrlQuery = await getSignedUrlV4(config);
    }

    final dynamic signedUrlQuery = v2signedUrlQuery ?? v4signedUrlQuery;

    if (cfg.queryParams != null) {
      signedUrlQuery.values.addAll(cfg.queryParams!.values);
    }
    final Uri signedUrl = Uri.parse(config.cname ?? PATH_STYLED_HOST).replace(
      path: getResourcePath(config.cname != null, _bucket.name, config.file),
      queryParameters: signedUrlQuery.values,
    );

    // todo - finish method

    return signedUrl.toString();
  }

  @visibleForTesting
  Future<V2SignedUrlQuery> getSignedUrlV2(GetSignedUrlConfigInternal config) async {
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

        final V2SignedUrlQuery query = V2SignedUrlQuery();
        query.values = <String, dynamic>{
          'GoogleAccessId': credentials.client_email!,
          'Expires': config.expiration,
          'Signature': signature,
        };
        return query;
      } catch (err, stackTrace) {
        final SigningError signingErr = SigningError(err.toString(), stackTrace);
        throw signingErr;
      }
    };

    return sign();
  }

  @visibleForTesting
  Future<V4SignedUrlQuery> getSignedUrlV4(GetSignedUrlConfigInternal config) async {
    final int accessibleAtinSeconds = parseAccessibleAt(config.accessibleAt);
    // v4 limit expiration to be 7 days maximum
    if (config.expiration - accessibleAtinSeconds > SEVEN_DAYS) {
      throw 'Max allowed expiration is seven days ($SEVEN_DAYS seconds).';
    }

    final Map<String, dynamic> extensionHeaders = config.extensionHeaders ?? <String, dynamic>{};
    final Uri fqdn = Uri.parse(config.cname ?? PATH_STYLED_HOST);
    extensionHeaders['host'] = fqdn.host;
    if (config.contentMd5 != null) {
      extensionHeaders['content-md5'] = config.contentMd5;
    }
    if (config.contentType != null) {
      extensionHeaders['content-type'] = config.contentType;
    }

    String? contentSha256;
    final String? sha256Header = extensionHeaders['x-goog-content-sha256'];
    if (sha256Header != null) {
      if (sha256Header is! String
          // todo - regex || '!/[A-Fa-f0-9]{40}/'.test(sha256Header)
          ) {
        throw Exception('The header X-Goog-Content-SHA256 must be a hexadecimal string.');
      }
      contentSha256 = sha256Header;
    }

    final List<String> signedHeadersList = extensionHeaders.keys.map((e) => e.toLowerCase()).toList();
    signedHeadersList.sort();
    final String signedHeaders = signedHeadersList.join(';');

    final String extensionHeadersString = getCanonicalHeaders(extensionHeaders);

    final String datestamp = formatDate(config.accessibleAt, 'yyyyMMdd', utc: true);
    final String credentialScope = '$datestamp/auto/storage/goog4_request';

    final Future<V4SignedUrlQuery> Function() sign = () async {
      final GetCredentialsResponse credentials = await _authClient.getCredentials();
      final String credential = '${credentials.client_email}/$credentialScope';
      // todo - format date with TZ
      final String dateISO = formatDate(config.accessibleAt, 'yyyyMMddhhmmss', utc: true);
      final Query queryParams = Query();
      queryParams.values.addAll(config.queryParams != null ? config.queryParams!.values : <String, dynamic>{});
      queryParams.values.addAll(<String, dynamic>{
        'X-Goog-Algorithm': 'GOOG4-RSA-SHA256',
        'X-Goog-Credential': credential,
        'X-Goog-Date': dateISO,
        'X-Goog-Expires': config.expiration.toString(),
        'X-Goog-SignedHeaders': signedHeaders,
      });

      final String canonicalQueryParams = getCanonicalQueryParams(queryParams);

      final String canonicalRequest = getCanonicalRequest(
        method: config.method,
        path: getResourcePath(config.cname == null, config.bucket, config.file),
        query: canonicalQueryParams,
        headers: extensionHeadersString,
        signedHeaders: signedHeaders,
        contentSha256: contentSha256,
      );

      final String hash = sha256.convert(utf8.encode(canonicalRequest)).toString();

      final String blobToSign = <String>[
        'GOOG4-RSA-SHA256',
        dateISO,
        credentialScope,
        hash,
      ].join('\n');

      try {
        final String signature = await authClient.sign(blobToSign);
        final String signatureHex = base64.encode(utf8.encode(signature));
        final V4SignedUrlQuery signedQuery = V4SignedUrlQuery();
        signedQuery.values.addAll(queryParams.values);
        signedQuery.values.addAll(<String, dynamic>{
          'X-Goog-Signature': signatureHex,
        });
        return signedQuery;
      } catch (err) {
        throw SigningError(err.toString());
      }
    };

    // todo - finish method
    return sign();
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
  @visibleForTesting
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
    return <dynamic>[
      method,
      path,
      query,
      headers,
      signedHeaders,
      contentSha256 ?? 'UNSIGNED-PAYLOAD',
    ].join('\n');
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
}

class SigningError implements Exception {
  SigningError(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;
  String name = 'SigningError';
}
