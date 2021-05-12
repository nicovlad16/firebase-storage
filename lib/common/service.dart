// todo - finish class

import 'dart:io';

import 'package:firebase_storage/auth/google_auth.dart';
import 'package:firebase_storage/common/index.dart';

const String PROJECT_ID_TOKEN = '{{projectId}}';

class ServiceConfig {
  ServiceConfig({
    required this.baseUrl,
    required this.apiEndpoint,
    required this.scopes,
    this.projectIdRequired,
    required this.packageJson,
    this.authClient,
  });

  /// The base URL to make API requests to.
  String baseUrl;

  /// The API Endpoint to use when connecting to the service.
  /// Example:  storage.googleapis.com
  String apiEndpoint;

  /// The scopes required for the request.
  List<String> scopes;

  bool? projectIdRequired;
  PackageJson packageJson;

  /// Reuse an existing GoogleAuth client instead of creating a new one.
  GoogleAuth? authClient;
}

class ServiceOptions extends GoogleAuthOptions {
  ServiceOptions({
    this.authClient,
    List<Interceptor>? interceptors_,
    this.email,
    this.token,
    this.timeout,
    this.userAgent,
    this.projectId,
  }) : interceptors_ = interceptors_ ?? <Interceptor>[];

  GoogleAuth? authClient;
  List<Interceptor>? interceptors_;
  String? email;
  String? token;
  int? timeout; // http.request.options.timeout
  String? userAgent;
  String? projectId;
}

/// Service is a base class, meant to be inherited from by a "service," like
/// BigQuery or Storage.
///
/// This handles making authenticated requests by exposing a `makeReq_`
/// function.
///
/// @constructor
/// @alias module:common/service
///
/// @param {object} config - Configuration object.
/// @param {string} config.baseUrl - The base URL to make API requests to.
/// @param {string[]} config.scopes - The scopes required for the request.
/// @param {object=} options - [Configuration object](#/docs).
// todo - finish class
class Service implements ServiceObjectParent {
  Service(ServiceConfig config, [ServiceOptions? options]) {
    options ??= ServiceOptions();
    baseUrl = config.baseUrl;
    _apiEndpoint = config.apiEndpoint;
    timeout = options.timeout;
    if (options.interceptors_ != null) {
      _globalInterceptors = options.interceptors_!; // todo - arrify
    } else {
      _globalInterceptors = <Interceptor>[];
    }
    interceptors = <Interceptor>[];
    packageJson = config.packageJson;
    projectId = options.projectId ?? PROJECT_ID_TOKEN;
    projectIdRequired = config.projectIdRequired != false;
    providedUserAgent = options.userAgent;

    // var reqCfg = config;
    // reqCfg
    //   ..projectIdRequired = projectIdRequired
    //   ..projectId = projectId
    //   ..authClient = options.authClient
    //   ..credentials = options.credentials
    //   ..keyFile = options.keyFilename
    //   ..email = options.email
    //   ..token = options.token;

    // todo - finish constructor
  }

  late String baseUrl;
  late List<Interceptor> _globalInterceptors;
  late List<Interceptor> interceptors;
  late PackageJson packageJson;
  late String projectId;
  late bool projectIdRequired;
  String? providedUserAgent;
  late MakeAuthenticatedRequest makeAuthenticatedRequest;
  late Map<String, dynamic> _getCredentials;
  late String _apiEndpoint;

  late GoogleAuth authClient;
  int? timeout;

  List<Interceptor> get globalInterceptors => _globalInterceptors;

  String get apiEndpoint => _apiEndpoint;

  @override
  List<Function> getRequestInterceptors() {
    // todo: implement getRequestInterceptors
    throw UnimplementedError();
  }

  /// Make an authenticated API request.
  ///
  /// @private
  ///
  /// @param {object} reqOpts - Request options that are passed to `request`.
  /// @param {string} reqOpts.uri - A URI relative to the baseUrl.
  /// @param {function} callback - The callback function passed to `request`.
  HttpClientRequest? _request({
    dynamic /* StreamRequestOptions | DecorateRequestOptions */ reqOpts,
    BodyResponseCallback? callback,
  }) {
    reqOpts.timeout = timeout;

    final bool isAbsoluteUrl = reqOpts.uri.indexOf('http') == 0;
    final List<dynamic> uriComponents = <dynamic>[baseUrl];
    if (projectIdRequired) {
      uriComponents..add('projects')..add(projectId);
    }
    uriComponents.add(reqOpts.uri);
    if (isAbsoluteUrl) {
      // todo splice
    }

    // todo - finish method
    return null;
  }

  /// Make an authenticated API request.
  ///
  /// @param {object} reqOpts - Request options that are passed to `request`.
  /// @param {string} reqOpts.uri - A URI relative to the baseUrl.
  /// @param {function} callback - The callback function passed to `request`.
  @override
  void request(DecorateRequestOptions reqOpts, BodyResponseCallback callback) {
    _request(reqOpts: reqOpts, callback: callback);
  }

  /// Make an authenticated API request.
  ///
  /// @param {object} reqOpts - Request options that are passed to `request`.
  /// @param {string} reqOpts.uri - A URI relative to the baseUrl.
  @override
  HttpClientRequest requestStream(DecorateRequestOptions reqOpts) {
    reqOpts.shouldReturnStream = true;
    return _request(reqOpts: reqOpts)!;
  }
}
