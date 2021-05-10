part of api_request;

/// Http method type definition.
const List<String> validMethods = <String>['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD'];

/// API callback function type definition.
typedef ApiCallbackFunction = void Function(Map<String, dynamic> data);

/// Class that defines all the settings for the backend API endpoint.
/// [endpoint] The Firebase Auth backend [endpoint] and the http method
/// for that endpoint.
class ApiSettings {
  ApiSettings(this.endpoint, [this.httpMethod = 'POST'])
      : assert(validMethods.contains(httpMethod)),
        _requestValidator = ((dynamic _) {}),
        _responseValidator = ((dynamic _) {});

  final String endpoint;
  final String httpMethod;

  ApiCallbackFunction _requestValidator;
  ApiCallbackFunction _responseValidator;

  ApiCallbackFunction get requestValidator => _requestValidator;

  set requestValidator(ApiCallbackFunction? validator) {
    if (validator == null) {
      _requestValidator = (dynamic _) {};
    } else {
      _requestValidator = validator;
    }
  }

  ApiCallbackFunction get responseValidator => _responseValidator;

  set responseValidator(ApiCallbackFunction? validator) {
    if (validator == null) {
      _responseValidator = (dynamic _) {};
    } else {
      _responseValidator = validator;
    }
  }
}
