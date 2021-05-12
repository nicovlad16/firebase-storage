import '../common/index.dart';
import 'bucket.dart';

class DeleteNotificationOptions {
  DeleteNotificationOptions([this.userProject]);

  String? userProject;
}

class GetNotificationMetadataOptions {
  GetNotificationMetadataOptions([this.userProject]);

  String? userProject;
}

typedef GetNotificationMetadataResponse = List<dynamic>; // [ResponseBody, Metadata];

typedef GetNotificationMetadataCallback = void Function(Exception? err, ResponseBody? metadata, Metadata? apiResponse);

typedef GetNotificationResponse = List<dynamic>; // [Notification, Metadata];

class GetNotificationOptions {
  GetNotificationOptions([this.autoCreate, this.userProject]);

  /// Automatically create the object if it does not exist. Default: `false`.
  bool? autoCreate;

  ///  The ID of the project which will be billed for the request.
  String? userProject;
}

typedef GetNotificationCallback = void Function(Exception? err, Notification? notification, Metadata? apiResponse);

typedef DeleteNotificationCallback = void Function(Exception? err, Metadata? apiResponse);

// todo - finish class
class Notification extends ServiceObject {
  Notification(Bucket bucket, String id)
      : super(ServiceObjectConfig(
          parent: bucket,
          baseUrl: '/notificationConfigs',
          id: id.toString(),
        ));
}
