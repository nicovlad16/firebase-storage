import 'package:http/http.dart';

import 'index.dart';

const Map<String, dynamic> requestDefaults = <String, dynamic>{
  'timeout': 60000,
  'gzip': true,
  'forever': true,
  'pool': <String, dynamic>{
    'maxSockets': 9223372036854775807,
  },
};

typedef ResponseBody = dynamic;

abstract class ParsedHttpRespMessage {
// todo - fields
}

typedef RequestResponse = List<dynamic>; // [Metadata, r.Response];

abstract class ServiceObjectParent {
  late List<Interceptor> interceptors;
  late List<Function> getRequestInterceptors;

// todo - learn how to do this (callback? method?) - requestStream(reqOpts: DecorateRequestOptions): r.Request;
  late RequestBodyCallback request;
}

abstract class Interceptor {
  // todo - request(opts: r.Options): DecorateRequestOptions;
}

typedef GetMetadataOptions = Map<dynamic, dynamic>;

typedef Metadata = dynamic;

typedef MetadataResponse = List<dynamic>; // [Metadata, r.Response];

typedef MetadataCallback = void Function(
  Exception? err,
  Metadata? metadata,
  Response? apiResponse,
);

typedef ExistsOptions = Map<dynamic, dynamic>;

typedef ExistsCallback = void Function(Exception? err, bool? exists);

abstract class ServiceObjectConfig {
  /// The base URL to make API requests to.
  String? baseUrl;

  /// The method which creates this object.
  Function? createMethod;

  /// The identifier of the object. For example, the name of a Storage bucket or Pub/Sub topic.
  String? id;

  /// A map of each method name that should be inherited.
  Methods? methods;

  /// The parent service instance. For example, an instance of Storage if the object is Bucket.
  late ServiceObjectParent parent;

  /// For long running operations, how often should the client poll for completion.
  int? pollIntervalMs;
}

abstract class Methods {
  // todo - finish this
}

typedef InstanceResponseCallback<T> = void Function(ApiError? err, T? instance, Response? apiResponse);

abstract class CreateOptions {}

typedef CreateResponse<T> = List<dynamic>;

typedef CreateCallback<T> = void Function(
  ApiError? err,
  T? instance,
  List<dynamic> args, // todo - variable number of args
);

typedef DeleteOptions = Map<dynamic, dynamic>;

typedef DeleteCallback = void Function(Exception? err, Response? apiResponse);

abstract class GetConfig {
  /// Create the object if it doesn't already exist.
  bool? autoCreate;
}

// todo - type GetOrCreateOptions = GetConfig & CreateOptions;

typedef GetResponse<T> = List<dynamic>; // [T, r.Response];

typedef ResponseCallback = void Function(Exception? err, Response? apiResponse);

typedef SetMetadataResponse = List<Metadata>;

typedef SetMetadataOptions = Map<dynamic, dynamic>;

/// ServiceObject is a base class, meant to be inherited from by a "service
/// object," like a BigQuery dataset or Storage bucket.
///
/// Most of the time, these objects share common functionality; they can be
/// created or deleted, and you can get or set their metadata.
///
/// By inheriting from this class, a service object will be extended with these
/// shared behaviors. Note that any method can be overridden when the service
/// object requires specific behavior.
// todo - finish class
// todo - find EventEmitter equivalent in dart
class ServiceObject {}
