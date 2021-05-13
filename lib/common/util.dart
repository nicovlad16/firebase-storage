import 'package:firebase_storage/auth/credentials.dart';
import 'package:firebase_storage/auth/google_auth.dart';
import 'package:firebase_storage/common/index.dart';
import 'package:http/http.dart';

const Map<String, dynamic> requestDefaults = <String, dynamic>{
  'timeout': 60000,
  'gzip': true,
  'forever': true,
  'pool': <String, dynamic>{
    'maxSockets': 9223372036854775807,
  },
};

typedef ResponseBody = dynamic;

class ParsedHttpRespMessage {
// todo - fields
}

typedef GetCredentialsCallback = void Function(Exception? err, CredentialBody? credentials);

typedef MakeAuthenticatedRequestCallback = dynamic /* void | Deuplexify | Abortable */ Function(
  DecorateRequestOptions reqOpts,
  MakeAuthenticatedRequestOptions? options,
  BodyResponseCallback callback,
);

class MakeAuthenticatedRequest {
  void init(MakeAuthenticatedRequestFactoryConfig config) {
    final GoogleAuthOptions googleAutoAuthConfig = GoogleAuthOptions(
      keyFilename: config.keyFilename,
      keyFile: config.keyFile,
      credentials: config.credentials,
      projectId: config.projectId,
      authClient: config.authClient,
    );
    if (googleAutoAuthConfig.projectId == '{{projectId}}') {
      googleAutoAuthConfig.projectId = null;
    }
    authClient = googleAutoAuthConfig.authClient ?? GoogleAuth(googleAutoAuthConfig);
  }

  late GoogleAuth authClient;

  dynamic makeAuthenticatedRequest(
    DecorateRequestOptions reqOpts, [
    MakeAuthenticatedRequestOptions? options,
    BodyResponseCallback? callback,
  ]) {}

  Future<CredentialBody> getCredentials() {
    return authClient.getCredentials();
  }
}

class MakeAuthenticatedRequestFactoryConfig extends GoogleAuthOptions {
  MakeAuthenticatedRequestFactoryConfig(
      {this.autoRetry,
      this.customEndpoint,
      this.email,
      this.maxRetries,
      this.stream,
      this.authClient,
      this.projectIdRequired,
      this.projectId,
      this.credentials,
      this.keyFile,
      this.token});

  /// Automatically retry requests if the response is related to rate limits or
  /// certain intermittent server errors. We will exponentially backoff
  /// subsequent requests by default. (default: true)
  bool? autoRetry;

  /// If true, just return the provided request options. Default: false.
  bool? customEndpoint;

  /// Account email address, required for PEM/P12 usage.
  String? email;

  /// Maximum number of automatic retries attempted before returning the error.
  /// (default: 3)
  int? maxRetries;

  Stream<dynamic>? stream;

  /// A pre-instantiated GoogleAuth client that should be used.
  /// A new will be created if this is not set.
  GoogleAuth? authClient;

  bool? projectIdRequired;

  String? projectId;

  dynamic credentials;

  String? keyFile;

  String? token;
}

class MakeAuthenticatedRequestOptions {
  MakeAuthenticatedRequestOptions(this.onAuthenticated);

  OnAuthenticatedCallback onAuthenticated;
}

typedef OnAuthenticatedCallback = void Function(Exception? err, DecorateRequestOptions? reqOpts);

class PackageJson {
  PackageJson(this.name, this.version);

  String name;
  String version;
}

// todo - extends r.CoreOptions
class DecorateRequestOptions {
  DecorateRequestOptions({
    Map<String, dynamic>? qs,
    this.autoPaginate,
    this.autoPaginateVal,
    this.objectMode,
    this.maxRetries,
    required this.uri,
    List<Interceptor>? interceptors_,
    required this.shouldReturnStream,
    this.timeout,
  })  : qs = qs ?? <String, dynamic>{},
        interceptors_ = interceptors_ ?? <Interceptor>[];

  late Map<String, dynamic> qs;
  bool? autoPaginate;
  bool? autoPaginateVal;
  bool? objectMode;
  int? maxRetries;
  String uri;
  late List<Interceptor> interceptors_;
  bool shouldReturnStream;
  int? timeout;
}

class StreamRequestOptions extends DecorateRequestOptions {
  StreamRequestOptions({
    Map<String, dynamic>? qs,
    this.autoPaginate,
    this.autoPaginateVal,
    this.objectMode,
    this.maxRetries,
    required this.uri,
    List<Interceptor>? interceptors_,
    this.timeout,
  })  : shouldReturnStream = true,
        super(
          qs: qs,
          autoPaginate: autoPaginate,
          autoPaginateVal: autoPaginateVal,
          objectMode: objectMode,
          maxRetries: maxRetries,
          uri: uri,
          interceptors_: interceptors_,
          shouldReturnStream: true,
          timeout: timeout,
        );

  late Map<String, dynamic> qs;
  bool? autoPaginate;
  bool? autoPaginateVal;
  bool? objectMode;
  int? maxRetries;
  String uri;
  late List<Interceptor> interceptors_;
  bool shouldReturnStream;
  int? timeout;
}

typedef BodyResponseCallback = void Function(
  dynamic err, // Error | ApiError | null
  ResponseBody? body,
  Response? res,
);

// todo - finish class
class ApiError {}
