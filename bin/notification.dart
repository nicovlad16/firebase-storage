abstract class DeleteNotificationOptions {
  String? userProject;
}

abstract class GetNotificationMetadataOptions {
  String? userProject;
}

// todo - type - GetNotificationMetadataResponse

// todo - callback - GetNotificationMetadataCallback

// todo - type - GetNotificationResponse

abstract class GetNotificationOptions {
/**
 * Automatically create the object if it does not exist. Default: `false`.
 */
  bool? autoCreate;

/**
 * The ID of the project which will be billed for the request.
 */
  String? userProject;
}

// todo - callback - GetNotificationCallback

// todo - callback - DeleteNotificationCallback

// todo - extends ServiceObject
// todo - finish class
class Notification {}
