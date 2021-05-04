import '../common/index.dart';
import 'storage.dart';

abstract class HmacKeyOptions {
  String? projectId;
}

abstract class HmacKeyMetadata {
  late String accessId;
  String? etag;
  String? id;
  String? projectId;
  String? serviceAccountEmail;
  String? state;
  String? timeCreated;
  String? updated;
}

abstract class SetHmacKeyMetadataOptions {
  /// This parameter is currently ignored.
  String? userProject;
}

abstract class SetHmacKeyMetadata {
  String? state; //  'ACTIVE' | 'INACTIVE'
  String? etag;
}

typedef GetAclCallback = void Function(Exception? err, HmacKeyMetadata? metadata, Metadata? apiResponse);

typedef HmacKeyMetadataResponse = List<dynamic>; // [HmacKeyMetadata, Metadata]

// todo - finish class
class HmacKey extends ServiceObject {
  HmacKey(Storage storage, String accessId, HmacKeyOptions? options) {
    // todo - finish constructor
  }
  HmacKeyMetadata? metadata;
}
