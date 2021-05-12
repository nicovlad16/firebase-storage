import 'package:firebase_storage/common/service_object.dart';
import 'package:firebase_storage/storage/bucket.dart';
import 'package:firebase_storage/storage/file.dart';
import 'package:firebase_storage/storage/storage.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class BucketMock extends Mock implements Bucket {}

class StorageMock extends Mock implements Storage {}

@GenerateMocks(<Type>[Bucket, Storage])
void main() {
  group('File', () {
    const String FILE_NAME = 'file-name.png';
    late File file;
    late Bucket bucket;
    late Storage storage;

    setUp(() {
      storage = StorageMock();
      bucket = BucketMock();
      when(bucket.storage).thenReturn(storage);
      file = File(bucket, FILE_NAME);
    });

    group('initialization', () {
      test('should assign file name', () {
        expect(file.name, FILE_NAME);
      });

      test('should assign the bucket instance', () {
        expect(file.bucket, bucket);
      });

      test('should assign the storage instance', () {
        expect(file.storage, bucket.storage);
      });

      test('should not strip leading slashes', () {
        const String name = '/name';
        final File file = File(bucket, name);
        expect(file.name, name);
      });

      test('should assign KMS key name', () {
        const String kmsKeyName = 'kms-key-name';
        final FileOptions options = FileOptions(kmsKeyName: kmsKeyName);
        final File file = File(bucket, FILE_NAME, options);
        expect(file.kmsKeyName, kmsKeyName);
      });

      test('should accept specifying a generation', () {
        const int GENERATION = 2;
        final FileOptions options = FileOptions(generation: GENERATION);
        final File file = File(bucket, FILE_NAME, options);
        expect(file.generation, GENERATION);
      });

      test('should inherit from ServiceObject', () {
        // Using assert.strictEqual instead of assert to prevent
        // coercing of types.
        expect(file is ServiceObject, true);
        expect(file.parent, bucket);
        expect(file.baseUrl, '/o');
        expect(file.id, fixedEncodeURIComponent(FILE_NAME));
      });

      test('should not strip leading slash name in ServiceObject', () {
        const String name = '/name';
        final File file = File(bucket, name);
        expect(file.id, fixedEncodeURIComponent('/name'));
      });

      group('userProject', () {
        const String USER_PROJECT = 'grapce-spaceship-123';

        test('should localize the Bucket#userProject', () {
          when(bucket.userProject).thenReturn(USER_PROJECT);
          final File file = File(bucket, FILE_NAME);
          expect(file.userProject, USER_PROJECT);
        });

        test('should accept a userProject option', () {
          final FileOptions options = FileOptions(userProject: USER_PROJECT);
          final File file = File(bucket, FILE_NAME, options);
          expect(file.userProject, USER_PROJECT);
        });
      });
    });
  });
}
