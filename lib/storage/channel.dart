import '../common/index.dart';
import 'storage.dart';

typedef StopCallback = void Function(Exception? err, Metadata? apiResponse);

// todo - finish class
class Channel extends ServiceObject {
  Channel(Storage storage, String id, String resourceId) {
    var config = ServiceObjectConfig(
      parent: storage,
      baseUrl: 'channel',

      // An ID shouldn't be included in the API requests.
      // RE:
      // https://github.com/GoogleCloudPlatform/google-cloud-node/issues/1145
      id: '',
      methods: Methods(),
    );

    // todo - super(config);

    // TODO: remove type cast to any once ServiceObject's type declaration has
    // been fixed. https://github.com/googleapis/nodejs-common/issues/176
    // todo - final Metadata metadata = this.metadata;
    // metadata.id = id;
    // metadata.resourceId = resourceId;
  }
}
