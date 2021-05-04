const Map<String, dynamic> requestDefaults = {
  'timeout': 60000,
  'gzip': true,
  'forever': true,
  'pool': {
    'maxSockets': 9223372036854775807,
  },
};

typedef ResponseBody = dynamic;

// todo - find dart stream
// Directly copy over Duplexify interfaces
// abstract class DuplexifyOptions extends DuplexOptions {
//   bool? autoDestroy;
//   bool? end;
// }

// todo - class Duplexify

//todo - DuplexifyConstructor

abstract class ParsedHttpRespMessage {
// todo - fields
}

typedef Metadata = dynamic;

class ServiceObject {}
