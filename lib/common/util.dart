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
class DecorateRequestOptions {
  DecorateRequestOptions() : qs = <String, dynamic>{};
  Map<String, dynamic> qs;
}

typedef BodyResponseCallback = void Function(
  dynamic err, // Error | ApiError | null
  ResponseBody? body,
  Response? res,
);

// todo - finish class
class ApiError {}