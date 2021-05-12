import 'package:firebase_storage/common/service.dart';
import 'package:firebase_storage/common/service_object.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ServiceMock extends Mock implements Service {}

@GenerateMocks(<Type>[Service])
void main() {
  group('ServiceObject', () {
    const String BASE_URL = 'base-url';
    final ServiceMock parent = ServiceMock();
    const String ID = 'id';
    late ServiceObjectConfig config;
    late ServiceObject serviceObject;

    setUp(() {
      config = ServiceObjectConfig(
        baseUrl: BASE_URL,
        parent: parent,
        id: ID,
      );
      serviceObject = ServiceObject(config);
    });
    group('instantiation', () {
      test('should create an empty metadata object', () {
        expect(serviceObject.metadata, <String, dynamic>{});
      });

      test('should localize the baseUrl', () {
        expect(serviceObject.baseUrl, config.baseUrl);
      });

      test('should localize the parent instance', () {
        expect(serviceObject.parent, config.parent);
      });

      test('should localize the ID', () {
        expect(serviceObject.id, config.id);
      });
    });
  });
}
