import '../common/index.dart';
import '../storage/hmacKey.dart';

typedef RequestCallback = void Function(DecorateRequestOptions reqOpts, BodyResponseCallback callback);

typedef OnUploadProgressCallback = void Function(dynamic progressEvent);

typedef GetAclCallback = void Function(Exception? err, HmacKeyMetadata? metadata, Metadata? apiResponse);

const int SEVEN_DAYS = 7 * 24 * 60 * 60;
