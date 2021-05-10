import 'dart:convert';

import 'package:firebase_storage/storage/index.dart';
import 'package:firebase_storage/storage/util.dart';
import 'package:firebase_storage/util/util.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[URLSigner])
void main() {
  const String BUCKET_NAME = 'bucket-name';
  const String FILE_NAME = 'file-name.png';
  const String CLIENT_EMAIL = 'client-email';

  AuthClient authClient = AuthClient(
    sign: (_) async => 'signature',
    getCredentials: () async => GetCredentialsResponse(client_email: CLIENT_EMAIL),
  );
  BucketI bucket = BucketI(BUCKET_NAME);
  FileI file = FileI(FILE_NAME);
  URLSigner signer = URLSigner(authClient, bucket, file);

  setUp(() {
    authClient = AuthClient(
      sign: (_) async => 'signature',
      getCredentials: () async => GetCredentialsResponse(client_email: CLIENT_EMAIL),
    );
    bucket = BucketI(BUCKET_NAME);
    file = FileI(FILE_NAME);
    signer = URLSigner(authClient, bucket, file);
  });

  group('URLSigner', () {
    group('URLSigner constructor', () {
      test('should localize authClient', () {
        expect(signer.authClient, authClient);
      });

      test('should localize bucket', () {
        expect(signer.bucket, bucket);
      });

      test('should localize file', () {
        expect(signer.file, file);
      });
    });

    group('getSignedUrl', () {
      const String method = 'GET';
      late SignerGetSignedUrlConfig config;

      setUp(() {
        config = SignerGetSignedUrlConfig(
          method: method,
          expires: DateTime.now().add(const Duration(days: 2)),
        );
      });

      group('version', () {
        test('should use v2 if set', () async {
          config
            ..version = 'v2'
            ..contentMd5 = 'md5'
            ..contentType = 'application/json'
            ..extensionHeaders = <String, dynamic>{'key': 'value'};
          // todo - test
        });
      });

      group('should URI encode file name with special characters', () {
        test('v2', () async {
          file.name = "special/azAZ!*'()*%/file.jpg";
          final String encoded = encodeURI(file.name, false);
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, stringContainsInOrder(<String>[encoded]));
        });

        test('v4', () async {
          file.name = "special/azAZ!*'()*%/file.jpg";
          final String encoded = encodeURI(file.name, false);
          config.version = 'v4';
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, stringContainsInOrder(<String>[encoded]));
        });
      });

      group('should generate URL with given cname', () {
        const String cname = 'https://www.example.com';

        test('v2', () async {
          config.cname = cname;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('$cname/$FILE_NAME'));
        });

        test('v4', () async {
          config.cname = cname;
          config.version = 'v4';
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('$cname/$FILE_NAME'));
        });
      });

      group('should remove trailing slashes from cname', () {
        const String cname = 'https://www.example.com//';

        test('v2: ', () async {
          config.cname = cname;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
        });

        test('v4', () async {
          config.cname = cname;
          config.version = 'v4';
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('https://www.example.com/${file.name}'));
        });
      });

      group('should generate virtual hosted style URL', () {
        test('v2', () async {
          config.virtualHostedStyle = true;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('https://${bucket.name}.storage.googleapis.com/${file.name}'));
        });

        test('v4', () async {
          config.version = 'v4';
          config.virtualHostedStyle = true;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith('https://${bucket.name}.storage.googleapis.com/${file.name}'));
        });
      });

      group('should generate path styled URL', () {
        test('v2', () async {
          config.virtualHostedStyle = false;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith(PATH_STYLED_HOST));
        });

        test('v4', () async {
          config.version = 'v4';
          config.virtualHostedStyle = false;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, startsWith(PATH_STYLED_HOST));
        });
      });

      group('should generate URL with user-provided queryParams appended', () {
        final Map<String, dynamic> values = <String, dynamic>{
          'X-Goog-Foo': 'value',
          'X-Goog-Bar': 'azAZ!*()*%',
        };

        test('v2', () async {
          config.queryParams = Query();
          config.queryParams!.values = values;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, stringContainsInOrder(<String>[qsStringify(values)]));
        });

        test('v4', () async {
          config.version = 'v4';
          config.queryParams = Query();
          config.queryParams!.values = values;
          final String signedUrl = await signer.getSignedUrl(config);
          expect(signedUrl, stringContainsInOrder(<String>[qsStringify(values)]));
        });
      });
    });

    group('getSignedUrlV2', () {
      late GetSignedUrlConfigInternal configInternal;
      const String method = 'GET';

      setUp(() {
        configInternal = GetSignedUrlConfigInternal(
            expiration: DateTime.now().add(const Duration(seconds: 2)).millisecondsSinceEpoch ~/ 1000,
            method: method,
            bucket: bucket.name,
            file: file.name);
      });

      test('should return v2 query', () async {
        final V2SignedUrlQuery query = await signer.getSignedUrlV2(configInternal);

        final Map<String, dynamic> expected = <String, dynamic>{
          'GoogleAccessId': CLIENT_EMAIL,
          'Expires': configInternal.expiration.toString(),
          'Signature': 'signature',
        };
        expect(query.values, expected);
      });
    });

    group('getSignedUrlV4', () {
      late GetSignedUrlConfigInternal config;
      const String method = 'GET';

      setUp(() {
        config = GetSignedUrlConfigInternal(
          expiration: DateTime.now().add(const Duration(seconds: 2)).millisecondsSinceEpoch ~/ 1000,
          method: method,
          bucket: bucket.name,
        );
      });

      test('should fail for expirations beyond 7 days', () {
        config.expiration =
            DateTime.now().add(const Duration(seconds: 8 * 24 * 60 * 60)).millisecondsSinceEpoch ~/ 1000;
        const int SEVEN_DAYS = 7 * 24 * 60 * 60;

        expect(
            () => signer.getSignedUrlV4(config),
            throwsA(isA<String>().having(
              (String message) => message,
              'message',
              'Max allowed expiration is seven days ($SEVEN_DAYS seconds).',
            )));
      });

      test('should returns query params with signature', () async {
        config.queryParams = Query();
        config.queryParams!.values = <String, dynamic>{
          'foo': 'bar',
        };

        final V4SignedUrlQuery query = await signer.getSignedUrlV4(config);
        final String signatureInHex = base64.encode(utf8.encode('signature'));
        expect(query.values['X-Goog-Signature'], signatureInHex);
      });
    });

    group('getCanonicalHeaders', () {
      test('should accept multi-valued header as an array', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': <String>['bar', 'pub'],
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:bar,pub\n');
      });

      test('should lowercase and then sort header names', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'B': 'foo',
          'a': 'bar',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'a:bar\nb:foo\n');
      });

      test('should trim leading and trailing space', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': '  bar   ',
          'my': '\t  header  ',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:bar\nmy:header\n');
      });

      test('should convert sequential spaces into single space', () {
        final Map<String, dynamic> headers = <String, dynamic>{
          'foo': 'a\t\t\tbar   pub',
        };

        final String canonical = signer.getCanonicalHeaders(headers);
        expect(canonical, 'foo:a bar pub\n');
      });
    });

    group('getCanonicalRequest', () {
      const String method = 'DELETE';
      const String path = 'path';
      const String query = 'query';
      const String headers = 'headers';
      const String signedHeaders = 'signedHeaders';

      test('should return canonical request string with unsigned-payload', () {
        final String canonical = signer.getCanonicalRequest(
          method: method,
          path: path,
          query: query,
          headers: headers,
          signedHeaders: signedHeaders,
        );

        final String expected = <String>[method, path, query, headers, signedHeaders, 'UNSIGNED-PAYLOAD'].join('\n');
        expect(canonical, expected);
      });

      test('should include contentSha256 value if not undefined', () {
        const String SHA = '76af7efae0d034d1e3335ed1b90f24b6cadf2bf1';
        final String canonical = signer.getCanonicalRequest(
          method: method,
          path: path,
          query: query,
          headers: headers,
          signedHeaders: signedHeaders,
          contentSha256: SHA,
        );

        final String expected = <String>[method, path, query, headers, signedHeaders, SHA].join('\n');
        expect(canonical, expected);
      });
    });

    group('getCanonicalQueryParams', () {
      test('should encode key', () {
        const String key = 'AZ!*()*%/f';
        final Query query = Query();
        query.values[key] = 'value';
        final String canonical = signer.getCanonicalQueryParams(query);

        final String expected = '${encodeURI(key, true)}=value';
        expect(canonical, expected);
      });

      test('should encode value', () {
        const String key = 'key';
        const String value = 'AZ!*()*%/f';
        final Query query = Query();
        query.values[key] = value;
        final String canonical = signer.getCanonicalQueryParams(query);

        final String expected = '$key=${encodeURI(value, true)}';
        expect(canonical, expected);
      });

      test('should sort by key', () {
        final Query query = Query();
        query.values = <String, dynamic>{
          'B': 'bar',
          'A': 'foo',
        };
        final String canonical = signer.getCanonicalQueryParams(query);

        const String expected = 'A=foo&B=bar';
        expect(canonical, expected);
      });
    });

    group('getResourcePath', () {
      test('should not include bucket with cname', () {
        final String path = signer.getResourcePath(true, bucket.name, file.name);
        expect(path, '/${file.name}');
      });

      test('should include file name', () {
        final String path = signer.getResourcePath(false, bucket.name, file.name);
        expect(path, '/${bucket.name}/${file.name}');
      });

      test('should return path with no file name', () {
        final String path = signer.getResourcePath(false, bucket.name, null);
        expect(path, '/${bucket.name}');
      });
    });

    group('parseExpires', () {
      test('throws invalid date', () {
        expect(
          () => parseExpires('2019-31-'),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'The expiration date provided was invalid.'),
          ),
        );
      });

      test('throws if expiration is in the past', () {
        final DateTime dateTime = DateTime.now();
        expect(
          () => parseExpires(dateTime.subtract(const Duration(seconds: 1)), current: dateTime),
          throwsA(
            isA<String>()
                .having((String exception) => exception, 'message', 'An expiration date cannot be in the past.'),
          ),
        );
      });

      test('returns expiration date in seconds', () {
        final DateTime now = DateTime.now().add(const Duration(seconds: 2));
        final int expires = parseExpires(now);
        expect(expires, (now.millisecondsSinceEpoch / 1000).floor());
      });
    });
  });
}
