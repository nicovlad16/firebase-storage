import 'package:firebase_storage/common/index.dart';
import 'package:firebase_storage/storage/bucket.dart';
import 'package:firebase_storage/storage/notification.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class BucketMock extends Mock implements Bucket {}

@GenerateMocks(<Type>[Bucket])
void main() {
  group('Notification', () {
    const String ID = 'id';
    late Notification notification;
    late Bucket bucket;

    setUp(() {
      bucket = BucketMock();
      notification = Notification(bucket, ID);
    });

    group('instantiation', () {
      test('should inherit from ServiceObject', () {
        expect(notification is ServiceObject, true);
        expect(notification.parent, bucket);
        expect(notification.baseUrl, '/notificationConfigs');
        expect(notification.id, ID);
      });
    });
  });
}
