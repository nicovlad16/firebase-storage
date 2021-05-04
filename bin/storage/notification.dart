import '../common/index.dart';

abstract class DeleteNotificationOptions {
  String? userProject;
}

abstract class GetNotificationMetadataOptions {
  String? userProject;
}

typedef GetNotificationMetadataResponse = List<dynamic>; // [ResponseBody, Metadata];

typedef GetNotificationMetadataCallback = void Function(Exception? err, ResponseBody? metadata, Metadata? apiResponse);

typedef GetNotificationResponse = List<dynamic>; // [Notification, Metadata];

abstract class GetNotificationOptions {
  /// Automatically create the object if it does not exist. Default: `false`.
  bool? autoCreate;

  ///  The ID of the project which will be billed for the request.
  String? userProject;
}

typedef GetNotificationCallback = void Function(Exception? err, Notification? notification, Metadata? apiResponse);

typedef DeleteNotificationCallback = void Function(Exception? err, Metadata? apiResponse);

// todo - finish class
class Notification extends ServiceObject {}