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

// todo - extends r.CoreOptions
// todo - add fields
abstract class DecorateRequestOptions {}

typedef BodyResponseCallback = void Function(
  dynamic err, // Error | ApiError | null
  ResponseBody? body,
  Response? res,
);

String encodeURI(String uri, bool encodeSlash) {
  return uri;
  // todo - finish function
}

// todo - finish class
class ApiError {}
