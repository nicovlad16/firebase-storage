import 'package:firebase_storage/common/index.dart';
import 'package:firebase_storage/storage/hmacKey.dart';
import 'package:firebase_storage/storage/storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StorageMock extends Mock implements Storage {}

@GenerateMocks(<Type>[Storage])
void main() {
  group('HmacKey', () {
    const String PROJECT_ID = 'my-project';
    const String ACCESS_ID = 'fake-access-id';
    late HmacKey hmacKey;
    late Storage storage;

    setUp(() {
      storage = StorageMock();
      when(storage.projectId).thenReturn(PROJECT_ID);
      hmacKey = HmacKey(storage, ACCESS_ID);
    });

    group('initialization', () {
      test('should inherit from ServiceObject', () {
        expect(hmacKey is ServiceObject, true);
        expect(hmacKey.parent, storage);
        expect(hmacKey.id, ACCESS_ID);
        expect(hmacKey.baseUrl, '/projects/my-project/hmacKeys');
      });

      test('should form baseUrl using options.projectId if given', () {
        const String projectId = 'another-project';
        final HmacKeyOptions options = HmacKeyOptions(projectId);
        hmacKey = HmacKey(storage, ACCESS_ID, options);
        expect(hmacKey.baseUrl, '/projects/another-project/hmacKeys');
      });
    });
  });
}
