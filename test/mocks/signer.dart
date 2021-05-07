import 'package:firebase_storage/storage/signer.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:firebase_storage/util/util.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class URLSignerFake extends Fake implements URLSigner {
  URLSignerFake(this._authClient, this._bucket, this._file) : urlSigner = URLSigner(_authClient, _bucket, _file);
  URLSigner urlSigner;
  final AuthClient _authClient;
  final BucketI _bucket;
  final FileI? _file;

  @override
  AuthClient get authClient => _authClient;

  @override
  BucketI get bucket => _bucket;

  @override
  FileI? get file => _file;

  // @override
  // Future<String> getSignedUrl(SignerGetSignedUrlConfig cfg) async {
  //   return urlSigner.getSignedUrl(cfg);
  // }

  @override
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

  @override
  @visibleForTesting
  Future<V2SignedUrlQuery> getSignedUrlV2(GetSignedUrlConfigInternal config) async {
    return urlSigner.getSignedUrlV2(config);
  }

  @override
  @visibleForTesting
  Future<V4SignedUrlQuery> getSignedUrlV4(GetSignedUrlConfigInternal config) async {
    return urlSigner.getSignedUrlV4(config);
  }

  @override
  @visibleForTesting
  String getCanonicalHeaders(Map<String, dynamic /* number | string | string[] | undefined */ > headers) {
    return urlSigner.getCanonicalHeaders(headers);
  }

  @override
  String getCanonicalRequest(
      {required String method,
      required String path,
      required String query,
      required String headers,
      required String signedHeaders,
      String? contentSha256}) {
    return urlSigner.getCanonicalRequest(
        method: method, path: path, query: query, headers: headers, signedHeaders: signedHeaders);
  }

  @override
  String getCanonicalQueryParams(Query query) {
    return urlSigner.getCanonicalQueryParams(query);
  }

  @override
  String getResourcePath(bool cname, String bucket, String? file) {
    return urlSigner.getResourcePath(cname, bucket, file);
  }
}
