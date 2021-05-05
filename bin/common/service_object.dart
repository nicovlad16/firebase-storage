import 'package:http/http.dart';

import '../util/util.dart' as util;
import 'index.dart';

typedef RequestResponse = List<dynamic>; // [Metadata, r.Response];

typedef GetRequestInterceptorsCallback = List<Function> Function();

typedef RequestStreamCallback = Request Function(DecorateRequestOptions reqOpts);

class ServiceObjectParent {
  ServiceObjectParent({
    required this.interceptors,
    required this.getRequestInterceptors,
    required this.requestStream,
    required this.request,
  });

  List<Interceptor> interceptors;
  GetRequestInterceptorsCallback getRequestInterceptors;
  RequestStreamCallback requestStream;
  util.RequestCallback request;
}

class Interceptor {
  // todo - request(opts: r.Options): DecorateRequestOptions;
}

typedef GetMetadataOptions = Map<String, dynamic>;

typedef Metadata = dynamic;

typedef MetadataResponse = List<dynamic>; // [Metadata, r.Response];

typedef MetadataCallback = void Function(
  Exception? err,
  Metadata? metadata,
  Response? apiResponse,
);

typedef ExistsOptions = Map<String, dynamic>;

typedef ExistsCallback = void Function(Exception? err, bool? exists);

class ServiceObjectConfig {
  ServiceObjectConfig({
    this.baseUrl,
    this.createMethod,
    this.id,
    this.methods,
    required this.parent,
    this.pollIntervalMs,
  });

  /// The base URL to make API requests to.
  String? baseUrl;

  /// The method which creates this object.
  Function? createMethod;

  /// The identifier of the object. For example, the name of a Storage bucket or Pub/Sub topic.
  String? id;

  /// A map of each method name that should be inherited.
  Methods? methods;

  /// The parent service instance. For example, an instance of Storage if the object is Bucket.
  ServiceObjectParent parent;

  /// For long running operations, how often should the client poll for completion.
  int? pollIntervalMs;
}

class Methods {
  // todo - finish this
}

typedef InstanceResponseCallback<T> = void Function(ApiError? err, T? instance, Response? apiResponse);

class CreateOptions {}

typedef CreateResponse<T> = List<dynamic>;

typedef CreateCallback<T> = void Function(
  ApiError? err,
  T? instance,
  List<dynamic> args, // todo - variable number of args
);

typedef DeleteOptions = Map<String, dynamic>;

typedef DeleteCallback = void Function(Exception? err, Response? apiResponse);

class GetConfig {
  GetConfig([this.autoCreate]);

  /// Create the object if it doesn't already exist.
  bool? autoCreate;
}

// todo - type GetOrCreateOptions = GetConfig & CreateOptions;

typedef GetResponse<T> = List<dynamic>; // [T, r.Response];

typedef ResponseCallback = void Function(Exception? err, Response? apiResponse);

typedef SetMetadataResponse = List<Metadata>;

typedef SetMetadataOptions = Map<String, dynamic>;

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
