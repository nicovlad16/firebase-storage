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
  /**
   * This parameter is currently ignored.
   */
  String? userProject;
}

abstract class SetHmacKeyMetadata {
  // todo - var default
  String? state; // : 'ACTIVE' | 'INACTIVE';
  String? etag;
}

// todo - interface callback
abstract class HmacKeyMetadataCallback {}

// todo - type - HmacKeyMetadataResponse

// todo - class extends ServiceObject
class HmacKey {
  HmacKeyMetadata? metadata;
}
