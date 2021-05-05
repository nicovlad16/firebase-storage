import '../common/index.dart';

typedef RequestCallback = void Function(DecorateRequestOptions reqOpts, BodyResponseCallback callback);

typedef OnUploadProgressCallback = void Function(dynamic progressEvent);
