import 'package:firebase_storage/common/service_object.dart';
import 'package:firebase_storage/storage/channel.dart';
import 'package:firebase_storage/storage/index.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StorageMock extends Mock implements Storage {}

@GenerateMocks(<Type>[Storage])
void main() {
  group('Channel', () {
    const String ID = 'channel-id';
    const String RESOURCE_ID = 'resource-id';
    late Channel channel;
    late Storage storage;

    setUp(() {
      storage = StorageMock();
      channel = Channel(storage, ID, RESOURCE_ID);
    });
    group('initialization', () {
      test('should inherit from ServiceObject', () {
        expect(channel is ServiceObject, true);
        expect(channel.parent, storage);
        expect(channel.baseUrl, '/channels');
        expect(channel.id, '');
      });
    });
  });
}
