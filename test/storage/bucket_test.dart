import 'package:firebase_storage/common/index.dart';
import 'package:firebase_storage/storage/bucket.dart';
import 'package:firebase_storage/storage/storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StorageMock extends Mock implements Storage {}

@GenerateMocks(<Type>[Storage])
void main() {
  group('Bucket', () {
    const String BUCKET_NAME = 'test-bucket';
    late Bucket bucket;
    final StorageMock storage = StorageMock();

    setUp(() {
      bucket = Bucket(storage, BUCKET_NAME);
    });
    group('instantiation', () {
      test('should remove a leading gs://', () {
        final Bucket bucket = Bucket(storage, 'gs://bucket-name');
        expect(bucket.name, 'bucket-name');
      });

      test('should remove a trailing /', () {
        final Bucket bucket = Bucket(storage, 'bucket-name/');
        expect(bucket.name, 'bucket-name');
      });

      test('should localize the name', () {
        expect(bucket.name, BUCKET_NAME);
      });

      test('should localize the storage instance', () {
        expect(bucket.storage, storage);
      });

      group('ACL objects', () {
        test('should create an ACL object', () {
          const String pathPrefix = '/acl';
          expect(bucket.acl.pathPrefix, pathPrefix);
        });

        test('should create a default ACL object', () {
          const String pathPrefix = '/defaultObjectAcl';
          // todo - expect(bucket.acl.default.pathPrefix, pathPrefix);
        });
      });

      test('should inherit from ServiceObject', () {
        expect(bucket is ServiceObject, true);
        expect(bucket.parent, storage);
        expect(bucket.baseUrl, '/b');
        expect(bucket.id, BUCKET_NAME);
      });

      test('should localize userProject if provided', () {
        const String fakeUserProject = 'grape-spaceship-123';
        final BucketOptions options = BucketOptions(userProject: fakeUserProject);
        final Bucket bucket = Bucket(storage, BUCKET_NAME, options);
        expect(bucket.userProject, fakeUserProject);
      });
    });
  });
}
