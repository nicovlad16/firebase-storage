// todo - extends r.CoreOptions
// todo - add fields
abstract class DecorateRequestOptions {}

typedef BodyResponseCallback = void Function(
  dynamic err, // Error | ApiError | null
  // todo - add params
);

typedef RequestBodyCallback = void Function(DecorateRequestOptions reqOpts, BodyResponseCallback callback);

String encodeURI(String uri, bool encodeSlash) {
  return uri;
  // todo - finish function
}

class ApiError {}
