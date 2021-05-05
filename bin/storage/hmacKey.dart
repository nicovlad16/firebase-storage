import '../common/index.dart';
import 'storage.dart';

class HmacKeyOptions {
  HmacKeyOptions([this.projectId]);

  String? projectId;
}

class HmacKeyMetadata {
  HmacKeyMetadata({
    required this.accessId,
    this.etag,
    this.id,
    this.projectId,
    this.serviceAccountEmail,
    this.state,
    this.timeCreated,
    this.updated,
  });

  String accessId;
  String? etag;
  String? id;
  String? projectId;
  String? serviceAccountEmail;
  String? state;
  String? timeCreated;
  String? updated;
}

class SetHmacKeyMetadataOptions {
  SetHmacKeyMetadataOptions([this.userProject]);

  /// This parameter is currently ignored.
  String? userProject;
}

class SetHmacKeyMetadata {
  SetHmacKeyMetadata({this.state, this.etag});

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
