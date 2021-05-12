import 'package:firebase_storage/storage/bucket.dart';
import 'package:firebase_storage/storage/iam.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class BucketMock extends Mock implements Bucket {}

@GenerateMocks(<Type>[Bucket])
void main() {
  group('Iam', () {
    Iam iam;
    Bucket bucket;

    setUp(() {
      bucket = BucketMock();
      iam = Iam(bucket);
    });

    group('initialization', () {
      test('should localize the resource ID', () {
        // todo - expect(iam.resourceId_, 'buckets/' + bucket.id);
      });
    });
  });
}
