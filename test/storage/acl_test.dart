import 'package:firebase_storage/storage/acl.dart';
import 'package:test/test.dart';

void main() {
  group('Acl', () {
    const String PATH_PREFIX = '/acl';
    late AclOptions options;
    late Acl acl;

    setUp(() {
      options = AclOptions(PATH_PREFIX);
      acl = Acl(options);
    });

    group('initialization', () {
      test('should assign makeReq and pathPrefix', () {
        expect(acl.pathPrefix, PATH_PREFIX);
      });
    });
  });
}
